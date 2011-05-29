Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282Ab1E2TXm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 15:23:42 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:52009 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755091Ab1E2TXk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 15:23:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=rHKER8aFRovEpYa8FnlWP4r52NDi4cXduftrlsisN3DapvWravhAR6EbwWH+158yjU
         hJ2hi/NGg+X15K2X4bKounjl+BvmUQmdRZBUUE+R5oL7afs++xvLVmuKyJ9fgayTV27N
         UeXeNqlAS4worw/ySc7DL4/A6MxBuCY8m8j2o=
MIME-Version: 1.0
In-Reply-To: <20110529191055.GC9835@elte.hu>
References: <cover.1306517576.git.luto@mit.edu> <452208dbdf79d4c821d701d5973621bf7546419a.1306517576.git.luto@mit.edu>
 <20110529191055.GC9835@elte.hu>
From: Andrew Lutomirski <luto@mit.edu>
Date: Sun, 29 May 2011 15:23:20 -0400
X-Google-Sender-Auth: kwTHR904UsT6ebfDCOPaD5V8tGs
Message-ID: <BANLkTin=nCdEjA3Fgj6jH5TrSryit8K_XQ@mail.gmail.com>
Subject: Re: [PATCH 4/5] x86-64: Replace vsyscall gettimeofday fallback with
 int 0xcc
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 29, 2011 at 3:10 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Andy Lutomirski <luto@MIT.EDU> wrote:
>
>> --- a/arch/x86/kernel/entry_64.S
>> +++ b/arch/x86/kernel/entry_64.S
>> @@ -1121,6 +1121,8 @@ zeroentry spurious_interrupt_bug do_spurious_interrupt_bug
>>  zeroentry coprocessor_error do_coprocessor_error
>>  errorentry alignment_check do_alignment_check
>>  zeroentry simd_coprocessor_error do_simd_coprocessor_error
>> +zeroentry intcc do_intcc
>> +
>>
>>       /* Reload gs selector with exception handling */
>>       /* edi:  new selector */
>> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
>
> I forgot to reply to your prior question about zeroentry vs.
> paranoidzeroentry.
>
> That distinction is an undocumented x86-64-ism.

Is this an erratum or just the undocumented fact that
swapgs twice puts usergs back and confuses the kernel?

>
> Btw, as a sidenote, and since you are already touching this code,
> would you be interested in putting this explanation into the source
> code? It's certainly not obvious and whoever wrote those macros did
> not think of documenting them for later generations ;-)

Will do.

>
>> +++ b/arch/x86/kernel/traps.c
>> @@ -872,6 +872,10 @@ void __init trap_init(void)
>>       set_bit(SYSCALL_VECTOR, used_vectors);
>>  #endif
>>
>> +     set_system_intr_gate(0xCC, &intcc);
>> +     set_bit(0xCC, used_vectors);
>> +     printk(KERN_ERR "intcc gate isntalled\n");
>
> I think you mentioned it but i cannot remember your reasoning why you
> marked it 0xcc (and not closer to the existing syscall vector) -
> please add a comment about it into the source code as well.
>
> Ok, i suspect you marked it 0xCC because that's the INT3 instruction
> - not very useful for exploits?

Exactly.

The comments in irq_vectors.h make it sound like vectors 0x81..0xed
are used for device interrupts but AFAICT it's only 0x20..0x39 that
are used, so the precise choice of vector doesn't matter that much.

>
>> +void dotraplinkage do_intcc(struct pt_regs *regs, long error_code)
>> +{
>> +     /* Kernel code must never get here. */
>> +     if (!user_mode(regs))
>> +             BUG();
>
> Nit: you can use BUG_ON() for that.

Yep.

>
>> +     local_irq_enable();
>> +
>> +     if (!in_vsyscall_page(regs->ip)) {
>> +             struct task_struct *tsk = current;
>> +             if (show_unhandled_signals && unhandled_signal(tsk, SIGSEGV) &&
>
> Nit: please put an empty new line between local variable definitions
> and the first statement that follows - we do this for visual clarity.
>
> A not-so-nit: i'd not limit this message to unhandled signals alone.
> An attacker could install a SIGSEGV handler, send a SIGSEGV and
> attempt the exploit right then - he'll get a free attempt with no
> logging performed, right?.

I think if an exploit can call sigaction, then we've already lost.
But I can still make the change.

>
>> +                 printk_ratelimit()) {
>> +                     printk(KERN_INFO
>> +                            "%s[%d] illegal int $0xCC ip:%lx sp:%lx",
>> +                            tsk->comm, task_pid_nr(tsk),
>> +                            regs->ip, regs->sp);
>
> I'd suggest putting the text 'exploit attempt?' into the printk
> somewhere - a sysadmin might not necessarily know what an illegal int
> $0xCC is..

Will do.

>
>> +                     print_vma_addr(" in ", regs->ip);
>> +                     printk("\n");
>> +             }
>> +
>> +             force_sig(SIGSEGV, current);
>> +             return;
>> +     }
>> +
>> +     if (current->seccomp.mode) {
>> +             do_exit(SIGKILL);
>> +             return;
>> +     }
>> +
>> +     regs->ax = sys_gettimeofday((struct timeval __user *)regs->di, NULL);
>
> Does the vsyscall gettimeofday ignore the zone parameter too?

No, but the vsyscall gettimeofday doesn't use the fallback to get the timezone.

>
>> +
>> +     local_irq_disable();
>> +     return;
>> +}
>
> Nit: no need for a 'return;' at the end of a void function.

:)

That pointless "return" statement was to hide the fact that the
local_irq_enable wasn't correctly matched.

I'm changing this code a fair bit in preparation for the extra bonus
patch to defang vsyscalls even more by trapping all of them.

--Andy
