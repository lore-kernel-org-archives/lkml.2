Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750Ab0GNVXo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 17:23:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41726 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757520Ab0GNVXm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 17:23:42 -0400
MIME-Version: 1.0
In-Reply-To: <20100714203940.GC22096@Krystal>
References: <20100714154923.947138065@efficios.com>
	<20100714155804.049012415@efficios.com>
	<AANLkTiml2uwYqQayTKjMN2gI3LnjVFpwxXkv8GN3McEE@mail.gmail.com>
	<20100714170617.GB4955@Krystal>
	<AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com>
	<20100714203940.GC22096@Krystal>
Date: Wed, 14 Jul 2010 14:23:06 -0700
Message-ID: <AANLkTinM0eFnreNB5l_6f20oSGBchqAtYPb57tM01kUB@mail.gmail.com>
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>, Tejun Heo <htejun@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 1:39 PM, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
>>  - load percpu NMI stack frame pointer
>>  - if non-zero we know we're nested, and should ignore this NMI:
>>     - we're returning to kernel mode, so return immediately by using
>> "popf/ret", which also keeps NMI's disabled in the hardware until the
>> "real" NMI iret happens.
>
> Maybe incrementing a per-cpu missed NMIs count could be appropriate here so we
> know how many NMIs should be replayed at iret ?

No. As mentioned, there is no such counter in real hardware either.

Look at what happens for the not-nested case:

 - NMI1 triggers. The CPU takes a fault, and runs the NMI handler with
NMI's disabled

 - NMI2 triggers. Nothing happens, the NMI's are disabled.

 - NMI3 triggers. Again, nothing happens, the NMI's are still disabled

 - the NMI handler returns.

 - What happens now?

How many NMI interrupts do you get? ONE. Exactly like my "emulate it
in software" approach. The hardware doesn't have any counters for
pending NMI's either. Why should the software emulation have them?

>>     - before the popf/iret, use the NMI stack pointer to make the NMI
>> return stack be invalid and cause a fault
>
> I assume you mean "popf/ret" here.

Yes, that was as typo. The whole point of using popf was obviously to
_avoid_ the iret ;)

> So assuming we use a frame copy, we should
> change the nmi stack pointer in the nesting 0 nmi stack copy, so the nesting 0
> NMI iret will trigger the fault
>
>>   - set the NMI stack pointer to the current stack pointer
>
> That would mean bringing back the NMI stack pointer to the (nesting - 1) nmi
> stack copy.

I think you're confused. Or I am by your question.

The NMI code would literally just do:

 - check if the NMI was nested, by looking at whether the percpu
nmi-stack-pointer is non-NULL

 - if it was nested, do nothing, an return with a popf/ret. The only
stack this sequence might needs is to save/restore the register that
we use for the percpu value (although maybe we can just co a "cmpl
$0,%_percpu_seg:nmi_stack_ptr" and not even need that), and it's
atomic because at this point we know that NMI's are disabled (we've
not _yet_ taken any nested faults)

 - if it's a regular (non-nesting) NMI, we'd basically do

     6* pushq 48(%rsp)

   to copy the five words that the NMI pushed (ss/esp/eflags/cs/eip)
and the one we saved ourselves (if we needed any, maybe we can make do
with just 5 words).

 - then we just save that new stack pointer to the percpu thing with a simple

     movq %rsp,%__percpu_seg:nmi_stack_ptr

and we're all done. The final "iret" will do the right thing (either
fault or return), and there are no races that I can see exactly
because we use a single nmi-atomic instruction (the "iret" itself) to
either re-enable NMI's _or_ test whether we should re-do an NMI.

There is a single-instruction window that is interestign in the return
path, which is the window between the two final instructions:

    movl $0,%__percpu_seg:nmi_stack_ptr
    iret

where I wonder what happens if we have re-enabled NMI (due to a fault
in the NMI handler), but we haven't actually taken the NMI itself yet,
so now we _will_ re-use the stack. Hmm. I suspect we need another of
those horrible "if the NMI happens at this particular %rip" cases that
we already have for the sysenter code on x86-32 for the NMI/DEBUG trap
case of fixing up the stack pointer.

And maybe I missed something else. But it does look reasonably simple.
Subtle, but not a lot of code. And the code is all very much about the
NMI itself, not about other random sequences. No?

                Linus
