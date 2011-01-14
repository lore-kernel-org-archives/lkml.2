Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab1ANTvn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 14:51:43 -0500
Received: from smtp-out.google.com ([216.239.44.51]:61689 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab1ANTvk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 14:51:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=b9H7UM7GB8xeNMqKSokRp9Wi5chwCN8XyDpkCiymY4q9HisEi/JbqoR0zWRJWIpfcA
         bq4WLjCxN7TrqVjNN/pQ==
MIME-Version: 1.0
In-Reply-To: <AANLkTi=J2A1Qv6NGB1bsMr6d+1VFV26KEBQ=NJ=791s0@mail.gmail.com>
References: <1294990949-2729-1-git-send-email-ccross@android.com>
	<AANLkTimqiqABxCejdeOQWZZ62DVUZW2v-yMpdu1aNDQT@mail.gmail.com>
	<20110114120229.GA15996@n2100.arm.linux.org.uk>
	<1295014231.7901.41.camel@e102109-lin.cambridge.arm.com>
	<20110114154919.GE15996@n2100.arm.linux.org.uk>
	<1295022193.7901.56.camel@e102109-lin.cambridge.arm.com>
	<20110114163520.GH15996@n2100.arm.linux.org.uk>
	<1295024327.7901.70.camel@e102109-lin.cambridge.arm.com>
	<20110114173050.GJ15996@n2100.arm.linux.org.uk>
	<20110114184759.GN15996@n2100.arm.linux.org.uk>
	<AANLkTi=J2A1Qv6NGB1bsMr6d+1VFV26KEBQ=NJ=791s0@mail.gmail.com>
Date: Fri, 14 Jan 2011 11:51:38 -0800
X-Google-Sender-Auth: ppjzC739ecR_9qVVpgqXBILa4P0
Message-ID: <AANLkTimd44_FjnJUCNwz412Ned5S_+YcyHjfitus3vLQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: vfp: Fix up exception location in Thumb mode
From: Colin Cross <ccross@android.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 11:23 AM, Colin Cross <ccross@android.com> wrote:
> On Fri, Jan 14, 2011 at 10:47 AM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
>> So... this incrementally on top of the previous patch (which I've
>> reproduced below as there's a subtle comment change in there wrt IRQ
>> state.)
>>
>> This means we have consistent state - both r2 and regs->ARM_pc always
>> point to the next instruction to be executed in every case, which means
>> its easy to understand and remember while reading through the code.
>>
>> diff -u b/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
>> --- b/arch/arm/kernel/entry-armv.S
>> +++ b/arch/arm/kernel/entry-armv.S
>> @@ -499,10 +499,11 @@
>>        blo     __und_usr_unknown
>>  3:     ldrht   r0, [r4]
>>        add     r2, r2, #2                      @ r2 is PC + 2, make it PC + 4
>> -       orr     r0, r0, r5, lsl #16
>> +       str     r2, [sp, #S_PC]                 @ it's a 2x16bit instr, update
>> +       orr     r0, r0, r5, lsl #16             @  regs->ARM_pc
>>        @
>>        @ r0 = the two 16-bit Thumb instructions which caused the exception
>> -       @ r2 = PC value for the following Thumb instruction (:= regs->ARM_pc+2)
>> +       @ r2 = PC value for the following Thumb instruction (:= regs->ARM_pc)
>>        @ r4 = PC value for the first 16-bit Thumb instruction
>>        @
>>  #else
>>
>> 8<-x-x-
>>
>> diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
>> index 2b46fea..5876eec 100644
>> --- a/arch/arm/kernel/entry-armv.S
>> +++ b/arch/arm/kernel/entry-armv.S
>> @@ -461,27 +461,35 @@ ENDPROC(__irq_usr)
>>        .align  5
>>  __und_usr:
>>        usr_entry
>> -
>> -       @
>> -       @ fall through to the emulation code, which returns using r9 if
>> -       @ it has emulated the instruction, or the more conventional lr
>> -       @ if we are to treat this as a real undefined instruction
>>        @
>> -       @  r0 - instruction
>> +       @ The emulation code returns using r9 if it has emulated the
>> +       @ instruction, or the more conventional lr if we are to treat
>> +       @ this as a real undefined instruction
>>        @
>>        adr     r9, BSYM(ret_from_exception)
>>        adr     lr, BSYM(__und_usr_unknown)
>> +       @
>> +       @ r2 = regs->ARM_pc, which is either 2 or 4 bytes ahead of the
>> +       @ faulting instruction depending on Thumb mode.
>> +       @ r3 = regs->ARM_cpsr
>> +       @
>>        tst     r3, #PSR_T_BIT                  @ Thumb mode?
>> -       itet    eq                              @ explicit IT needed for the 1f label
>> +       itttt   eq                              @ explicit IT needed for the 1f label
>>        subeq   r4, r2, #4                      @ ARM instr at LR - 4
>> -       subne   r4, r2, #2                      @ Thumb instr at LR - 2
>>  1:     ldreqt  r0, [r4]
>>  #ifdef CONFIG_CPU_ENDIAN_BE8
>>        reveq   r0, r0                          @ little endian instruction
>>  #endif
>> +       @
>> +       @ r0 = 32-bit ARM instruction which caused the exception
>> +       @ r2 = PC value for the following instruction (:= regs->ARM_pc)
>> +       @ r4 = PC value for the faulting instruction
>> +       @
>>        beq     call_fpe
>> +
>>        @ Thumb instruction
>>  #if __LINUX_ARM_ARCH__ >= 7
>> +       sub     r4, r2, #2                      @ Thumb instr at LR - 2
>>  2:
>>  ARM(  ldrht   r5, [r4], #2    )
>>  THUMB(        ldrht   r5, [r4]        )
>> @@ -492,18 +500,19 @@ __und_usr:
>>  3:     ldrht   r0, [r4]
>>        add     r2, r2, #2                      @ r2 is PC + 2, make it PC + 4
>>        orr     r0, r0, r5, lsl #16
>> +       @
>> +       @ r0 = the two 16-bit Thumb instructions which caused the exception
>> +       @ r2 = PC value for the following Thumb instruction (:= regs->ARM_pc+2)
>> +       @ r4 = PC value for the first 16-bit Thumb instruction
>> +       @
>>  #else
>>        b       __und_usr_unknown
>>  #endif
>> - UNWIND(.fnend         )
>> + UNWIND(.fnend)
>>  ENDPROC(__und_usr)
>>
>> -       @
>> -       @ fallthrough to call_fpe
>> -       @
>> -
>>  /*
>> - * The out of line fixup for the ldrt above.
>> + * The out of line fixup for the ldrt instructions above.
>>  */
>>        .pushsection .fixup, "ax"
>>  4:     mov     pc, r9
>> @@ -534,11 +543,12 @@ ENDPROC(__und_usr)
>>  * NEON handler code.
>>  *
>>  * Emulators may wish to make use of the following registers:
>> - *  r0  = instruction opcode.
>> - *  r2  = PC+4
>> + *  r0  = instruction opcode (32-bit ARM or two 16-bit Thumb)
>> + *  r2  = PC value to resume execution after successful emulation
>>  *  r9  = normal "successful" return address
>> - *  r10 = this threads thread_info structure.
>> + *  r10 = this threads thread_info structure
>>  *  lr  = unrecognised instruction return address
>> + * IRQs disabled, FIQs enabled.
>>  */
>>        @
>>        @ Fall-through from Thumb-2 __und_usr
>> diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
>> index ee57640..eeb9250 100644
>> --- a/arch/arm/kernel/traps.c
>> +++ b/arch/arm/kernel/traps.c
>> @@ -347,9 +347,9 @@ asmlinkage void __exception do_undefinstr(struct pt_regs *regs)
>>        void __user *pc;
>>
>>        /*
>> -        * According to the ARM ARM, PC is 2 or 4 bytes ahead,
>> -        * depending whether we're in Thumb mode or not.
>> -        * Correct this offset.
>> +        * According to the ARM ARM, the PC is 2 or 4 bytes ahead
>> +        * depending on Thumb mode.  Correct this offset so that
>> +        * regs->ARM_pc points at the faulting instruction.
>>         */
>>        regs->ARM_pc -= correction;
>>
>> diff --git a/arch/arm/vfp/entry.S b/arch/arm/vfp/entry.S
>> index 4fa9903..2bf6089 100644
>> --- a/arch/arm/vfp/entry.S
>> +++ b/arch/arm/vfp/entry.S
>> @@ -19,6 +19,15 @@
>>  #include <asm/vfpmacros.h>
>>  #include "../kernel/entry-header.S"
>>
>> +@ VFP entry point.
>> +@
>> +@  r0  = instruction opcode (32-bit ARM or two 16-bit Thumb)
>> +@  r2  = PC value to resume execution after successful emulation
>> +@  r9  = normal "successful" return address
>> +@  r10 = this threads thread_info structure
>> +@  lr  = unrecognised instruction return address
>> +@  IRQs disabled.
>> +@
>>  ENTRY(do_vfp)
>>  #ifdef CONFIG_PREEMPT
>>        ldr     r4, [r10, #TI_PREEMPT]  @ get preempt count
>> diff --git a/arch/arm/vfp/vfphw.S b/arch/arm/vfp/vfphw.S
>> index 9897dcf..7292921 100644
>> --- a/arch/arm/vfp/vfphw.S
>> +++ b/arch/arm/vfp/vfphw.S
>> @@ -61,13 +61,13 @@
>>
>>  @ VFP hardware support entry point.
>>  @
>> -@  r0  = faulted instruction
>> -@  r2  = faulted PC+4
>> -@  r9  = successful return
>> +@  r0  = instruction opcode (32-bit ARM or two 16-bit Thumb)
>> +@  r2  = PC value to resume execution after successful emulation
>> +@  r9  = normal "successful" return address
>>  @  r10 = vfp_state union
>>  @  r11 = CPU number
>> -@  lr  = failure return
>> -
>> +@  lr  = unrecognised instruction return address
>> +@  IRQs enabled.
>>  ENTRY(vfp_support_entry)
>>        DBGSTR3 "instr %08x pc %08x state %p", r0, r2, r10
>
> I tested copying r2 to regs->ARM_pc like this patch does, and it fixes
> my test case.  Could this second patch go first so it can be applied
> to stable?
>

Also, both patches together Tested-by: Colin Cross <ccross@android.com>
