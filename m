Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716Ab2EWB0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 21:26:16 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:35975 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab2EWB0P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 21:26:15 -0400
MIME-Version: 1.0
In-Reply-To: <1337733575.13348.134.camel@gandalf.stny.rr.com>
References: <4FBB8C40.6080304@redhat.com>
	<1337693441.13348.36.camel@gandalf.stny.rr.com>
	<4FBB986F.5030306@redhat.com>
	<1337695780.13348.41.camel@gandalf.stny.rr.com>
	<4FBBA094.3090703@redhat.com>
	<1337696825.13348.44.camel@gandalf.stny.rr.com>
	<CA+55aFwx3QjNB2ckQfsThhDn7=Bm1d=n0Ai8zawbpLKBKgugGg@mail.gmail.com>
	<1337733575.13348.134.camel@gandalf.stny.rr.com>
Date: Tue, 22 May 2012 21:26:13 -0400
Message-ID: <CAMzpN2hWhcYBT0noFSc24e_fH-sVwK+Da97Byvge4tsF3_vRTQ@mail.gmail.com>
Subject: Re: NMI vs #PF clash
From: Brian Gerst <brgerst@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 8:39 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 2012-05-22 at 08:33 -0700, Linus Torvalds wrote:
>> On Tue, May 22, 2012 at 7:27 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> >
>> > Is reading it fast? Then we could do a two reads and only write when
>> > needed.
>>
>> Even better: we could do nothing at all.
>>
>> We could just say: let's make sure that any #PF case that can happen
>> in #NMI can also be re-done with arbitrary 'error_code' and 'struct
>> regs' contents.
>>
>> At that point, what could happen is
>>  - #PF
>>   - NMI
>>    - #PF
>>     - read cr2 for NMI fault
>>     - handle the NMI #PF
>>     - return from #PF
>>   - return from #NMI
>>   - read cr2 for original #PF fault - but get the NMI cr2 again
>>   - hande the #PF again (this should be a no-op now)
>
> I tested this by forcing all NMIs to have a page fault, and then running
> perf against hackbench to see what breaks. This doesn't work because the
> cr2 contains where the fault happened.
>
> If the NMI faulting address was in kernel space, the page fault it
> interrupted will think the user task is trying to access kernel memory
> and fault.
>
> Basically, the address will not be valid for the user task and this will
> make the task take a SEGFAULT.
>
> I had the NMI fault on the address 0x12348, but had a exception table to
> handle it.
>
> hackbench[2236]: segfault at 12348 ip 0000003054a091c4 sp 00007fff22c6e840 error 4 in ld-2.12.2.so[3054a00000+1e000]
>
> With the below patch, the faulting NMIs don't seem to be harming anything.
>
>
>>   - return from #PF
>>  - instruction restart causes new #PF
>>   - now we do the original page fault
>>
>> So one option is to just make sure that the few cases (just the
>> vmalloc area?) that NMI can trigger are all ok to be re-done with
>> other state.
>>
>> I note that right now we have
>>
>>         if (unlikely(fault_in_kernel_space(address))) {
>>                 if (!(error_code & (PF_RSVD | PF_USER | PF_PROT))) {
>>                         if (vmalloc_fault(address) >= 0)
>>                                 return;
>>
>> and that the error_code check means that the retried NMI #PF would not
>> go through that. But maybe we don't even need that check?
>>
>> That error_code thing seems to literally be the only thing that keeps
>> us from just re-doing the vmalloc_fault() silently.
>
> Avi, you want to test this?
>
> -- Steve
>
> Index: linux-trace.git/arch/x86/kernel/entry_64.S
> ===================================================================
> --- linux-trace.git.orig/arch/x86/kernel/entry_64.S
> +++ linux-trace.git/arch/x86/kernel/entry_64.S
> @@ -1586,7 +1586,7 @@ ENTRY(nmi)
>         * Check the special variable on the stack to see if NMIs are
>         * executing.
>         */
> -       cmpl $1, -8(%rsp)
> +       cmpl $1, -16(%rsp)
>        je nested_nmi
>
>        /*
> @@ -1615,7 +1615,7 @@ nested_nmi:
>
>  1:
>        /* Set up the interrupted NMIs stack to jump to repeat_nmi */
> -       leaq -6*8(%rsp), %rdx
> +       leaq -7*8(%rsp), %rdx
>        movq %rdx, %rsp
>        CFI_ADJUST_CFA_OFFSET 6*8
>        pushq_cfi $__KERNEL_DS
> @@ -1625,7 +1625,7 @@ nested_nmi:
>        pushq_cfi $repeat_nmi
>
>        /* Put stack back */
> -       addq $(11*8), %rsp
> +       addq $(12*8), %rsp
>        CFI_ADJUST_CFA_OFFSET -11*8
>
>  nested_nmi_out:
> @@ -1650,6 +1650,8 @@ first_nmi:
>         * +-------------------------+
>         * | temp storage for rdx    |
>         * +-------------------------+
> +        * | saved cr2               |
> +        * +-------------------------+
>         * | NMI executing variable  |
>         * +-------------------------+
>         * | Saved SS                |
> @@ -1672,8 +1674,20 @@ first_nmi:
>         * to the repeat_nmi. The original stack frame and the temp storage
>         * is also used by nested NMIs and can not be trusted on exit.
>         */
> +
> +       /*
> +        * Save off the CR2 register. If we take a page fault in the NMI then
> +        * it could corrupt the CR2 value. If the NMI preempts a page fault
> +        * handler before it was able to read the CR2 register, and then the
> +        * NMI itself takes a page fault, the page fault that was preempted
> +        * will read the information from the NMI page fault and not the
> +        * origin fault. Save it off and restore it if it changes.
> +        */
> +       movq %cr2, %rdx
> +       pushq_cfi %rdx
> +
>        /* Do not pop rdx, nested NMIs will corrupt that part of the stack */
> -       movq (%rsp), %rdx
> +       movq 8(%rsp), %rdx
>        CFI_RESTORE rdx
>
>        /* Leave room for the "in NMI" variable. */
> @@ -1682,7 +1696,7 @@ first_nmi:
>
>        /* Copy the stack frame to the Saved frame */
>        .rept 5
> -       pushq_cfi 6*8(%rsp)
> +       pushq_cfi 7*8(%rsp)
>        .endr
>        CFI_DEF_CFA_OFFSET SS+8-RIP
>
> @@ -1734,6 +1748,13 @@ end_repeat_nmi:
>  nmi_swapgs:
>        SWAPGS_UNSAFE_STACK
>  nmi_restore:
> +       /* Test if the cr2 reg changed */
> +       movq ORIG_RAX-R15+(12*8)(%rsp), %rdx
> +       movq %cr2, %rcx
> +       cmp %rdx, %rcx
> +       je 1f
> +       movq %rdx, %cr2
> +1:
>        RESTORE_ALL 8
>        /* Clear the NMI executing stack variable */
>        movq $0, 10*8(%rsp)

You could save cr2 in a callee-saved register (like r12) instead of
putting it on the stack.

--
Brian Gerst
