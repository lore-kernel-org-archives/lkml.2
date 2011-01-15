Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab1AOPkl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 10:40:41 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37168 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab1AOPkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 10:40:40 -0500
Date: Sat, 15 Jan 2011 15:40:19 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Colin Cross <ccross@android.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: vfp: Fix up exception location in Thumb mode
Message-ID: <20110115154019.GF15996@n2100.arm.linux.org.uk>
References: <1294990949-2729-1-git-send-email-ccross@android.com> <AANLkTimqiqABxCejdeOQWZZ62DVUZW2v-yMpdu1aNDQT@mail.gmail.com> <20110114120229.GA15996@n2100.arm.linux.org.uk> <1295014231.7901.41.camel@e102109-lin.cambridge.arm.com> <20110114154919.GE15996@n2100.arm.linux.org.uk> <1295022193.7901.56.camel@e102109-lin.cambridge.arm.com> <20110114163520.GH15996@n2100.arm.linux.org.uk> <1295024327.7901.70.camel@e102109-lin.cambridge.arm.com> <20110114173050.GJ15996@n2100.arm.linux.org.uk> <AANLkTin_pMzNc-ZL+rVcwaVawer0poyxhatqw5P-A2qW@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTin_pMzNc-ZL+rVcwaVawer0poyxhatqw5P-A2qW@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 15, 2011 at 03:31:04PM +0000, Catalin Marinas wrote:
> On 14 January 2011 17:30, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Fri, Jan 14, 2011 at 04:58:47PM +0000, Catalin Marinas wrote:
> >> I agree, this code needs some clean-up. Maybe for Undef we could unify
> >> the ARM and Thumb-2 offsets so that they are both 4 (it may confuse the
> >> breakpoint code, I haven't checked).
> >>
> >> Otherwise just let the code handling the undef deal with the ARM/Thumb
> >> difference. For SVC, it makes sense to have different offsets as we
> >> always return to the next instruction.
> [...]
> > When the VFP support code tests the state of the VFP hardware during boot,
> > it sets the VFP handler to point at vfp_testing_entry, bypassing the normal
> > VFP handling code, and executes a VFP instruction.
> >
> > If this VFP instruction faults (eg, because there is no VFP hardware
> > present or we're not permitted to use it), it could end up resuming
> > execution in the middle of the 16-bit paired instruction because
> > regs->ARM_pc points in the middle of it.
> 
> Yes, that's possible. We probably never tried a Thumb-2 kernel where
> VFP isn't present.
> 
> > Or maybe we should just make it unconditional that whenever we have an
> > undefined instruction exception, the regs->ARM_pc value will always be
> > set for resuming execution after the faulted instruction.  That makes
> > it consistent with r2 throughout the code in every case.
> 
> I have some comments below.
> 
> > diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
> > index 2b46fea..5876eec 100644
> > --- a/arch/arm/kernel/entry-armv.S
> > +++ b/arch/arm/kernel/entry-armv.S
> > @@ -461,27 +461,35 @@ ENDPROC(__irq_usr)
> >        .align  5
> >  __und_usr:
> >        usr_entry
> > -
> > -       @
> > -       @ fall through to the emulation code, which returns using r9 if
> > -       @ it has emulated the instruction, or the more conventional lr
> > -       @ if we are to treat this as a real undefined instruction
> >        @
> > -       @  r0 - instruction
> > +       @ The emulation code returns using r9 if it has emulated the
> > +       @ instruction, or the more conventional lr if we are to treat
> > +       @ this as a real undefined instruction
> >        @
> >        adr     r9, BSYM(ret_from_exception)
> >        adr     lr, BSYM(__und_usr_unknown)
> > +       @
> > +       @ r2 = regs->ARM_pc, which is either 2 or 4 bytes ahead of the
> > +       @ faulting instruction depending on Thumb mode.
> > +       @ r3 = regs->ARM_cpsr
> > +       @
> >        tst     r3, #PSR_T_BIT                  @ Thumb mode?
> > -       itet    eq                              @ explicit IT needed for the 1f label
> > +       itttt   eq                              @ explicit IT needed for the 1f label
> >        subeq   r4, r2, #4                      @ ARM instr at LR - 4
> > -       subne   r4, r2, #2                      @ Thumb instr at LR - 2
> >  1:     ldreqt  r0, [r4]
> 
> The itttt above should just be itt. The reveq is conditionally
> compiled and beq doesn't necessarily need one.

It's a reveq, so I thought we should cover all the instructions with
an 'eq' conditional for thumb.

> 
> >  #ifdef CONFIG_CPU_ENDIAN_BE8
> >        reveq   r0, r0                          @ little endian instruction
> >  #endif
> > +       @
> > +       @ r0 = 32-bit ARM instruction which caused the exception
> > +       @ r2 = PC value for the following instruction (:= regs->ARM_pc)
> 
> Is r2 here always the PC value following instruction? If the Thumb
> instruction was 32-bit, it just points in the middle of the faulting
> instruction.

Is the T bit ever zero in this case?  The code here is:

	tst	r3, #PSR_T_BIT
	subeq	r4, r2, #4
1:	ldreqt	r0, [r4]
	reveq	r0, r0
	beq	call_fpe

So, if !T, then we subtract 4 and load the instruction (which was the
faulting instruction).  So r2 is the following instruction.

Ah, maybe you're getting confused by the comment.  Should we put
an 'eq' suffix on the end of each line? ;)

> 
> > +       @ r4 = PC value for the faulting instruction
> > +       @
> >        beq     call_fpe
> > +
> >        @ Thumb instruction
> >  #if __LINUX_ARM_ARCH__ >= 7
> > +       sub     r4, r2, #2                      @ Thumb instr at LR - 2
> >  2:
> >  ARM(  ldrht   r5, [r4], #2    )
> >  THUMB(        ldrht   r5, [r4]        )
> > @@ -492,18 +500,19 @@ __und_usr:
> >  3:     ldrht   r0, [r4]
> >        add     r2, r2, #2                      @ r2 is PC + 2, make it PC + 4
> >        orr     r0, r0, r5, lsl #16
> > +       @
> > +       @ r0 = the two 16-bit Thumb instructions which caused the exception
> > +       @ r2 = PC value for the following Thumb instruction (:= regs->ARM_pc+2)
> 
> That's correct.
> 
> > +       @ r4 = PC value for the first 16-bit Thumb instruction
> 
> I think r4 here points in the middle of tha faulting instruction for
> 32-bit Thumb.

You're right.
> 
> > +       @
> >  #else
> >        b       __und_usr_unknown
> >  #endif
> > - UNWIND(.fnend         )
> > + UNWIND(.fnend)
> >  ENDPROC(__und_usr)
> >
> > -       @
> > -       @ fallthrough to call_fpe
> > -       @
> > -
> >  /*
> > - * The out of line fixup for the ldrt above.
> > + * The out of line fixup for the ldrt instructions above.
> >  */
> >        .pushsection .fixup, "ax"
> >  4:     mov     pc, r9
> > @@ -534,11 +543,12 @@ ENDPROC(__und_usr)
> >  * NEON handler code.
> >  *
> >  * Emulators may wish to make use of the following registers:
> > - *  r0  = instruction opcode.
> > - *  r2  = PC+4
> > + *  r0  = instruction opcode (32-bit ARM or two 16-bit Thumb)
> > + *  r2  = PC value to resume execution after successful emulation
> >  *  r9  = normal "successful" return address
> > - *  r10 = this threads thread_info structure.
> > + *  r10 = this threads thread_info structure
> >  *  lr  = unrecognised instruction return address
> > + * IRQs disabled, FIQs enabled.
> >  */
> >        @
> >        @ Fall-through from Thumb-2 __und_usr
> > diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
> > index ee57640..eeb9250 100644
> > --- a/arch/arm/kernel/traps.c
> > +++ b/arch/arm/kernel/traps.c
> > @@ -347,9 +347,9 @@ asmlinkage void __exception do_undefinstr(struct pt_regs *regs)
> >        void __user *pc;
> >
> >        /*
> > -        * According to the ARM ARM, PC is 2 or 4 bytes ahead,
> > -        * depending whether we're in Thumb mode or not.
> > -        * Correct this offset.
> > +        * According to the ARM ARM, the PC is 2 or 4 bytes ahead
> > +        * depending on Thumb mode.  Correct this offset so that
> > +        * regs->ARM_pc points at the faulting instruction.
> >         */
> >        regs->ARM_pc -= correction;
> >
> > diff --git a/arch/arm/vfp/entry.S b/arch/arm/vfp/entry.S
> > index 4fa9903..2bf6089 100644
> > --- a/arch/arm/vfp/entry.S
> > +++ b/arch/arm/vfp/entry.S
> > @@ -19,6 +19,14 @@
> >  #include <asm/vfpmacros.h>
> >  #include "../kernel/entry-header.S"
> >
> > +@ VFP entry point.
> > +@
> > +@  r0  = instruction opcode (32-bit ARM or two 16-bit Thumb)
> > +@  r2  = PC value to resume execution after successful emulation
> > +@  r9  = normal "successful" return address
> > +@  r10 = this threads thread_info structure
> > +@  lr  = unrecognised instruction return address
> > +@
> >  ENTRY(do_vfp)
> >  #ifdef CONFIG_PREEMPT
> >        ldr     r4, [r10, #TI_PREEMPT]  @ get preempt count
> > diff --git a/arch/arm/vfp/vfphw.S b/arch/arm/vfp/vfphw.S
> > index 9897dcf..7292921 100644
> > --- a/arch/arm/vfp/vfphw.S
> > +++ b/arch/arm/vfp/vfphw.S
> > @@ -61,13 +61,13 @@
> >
> >  @ VFP hardware support entry point.
> >  @
> > -@  r0  = faulted instruction
> > -@  r2  = faulted PC+4
> > -@  r9  = successful return
> > +@  r0  = instruction opcode (32-bit ARM or two 16-bit Thumb)
> > +@  r2  = PC value to resume execution after successful emulation
> 
> That's right.
> 
> > +@  r9  = normal "successful" return address
> >  @  r10 = vfp_state union
> >  @  r11 = CPU number
> > -@  lr  = failure return
> > -
> > +@  lr  = unrecognised instruction return address
> > +@  IRQs enabled.
> >  ENTRY(vfp_support_entry)
> >        DBGSTR3 "instr %08x pc %08x state %p", r0, r2, r10
> >
> > @@ -138,9 +138,12 @@ check_for_exception:
> >                                        @ exception before retrying branch
> >                                        @ out before setting an FPEXC that
> >                                        @ stops us reading stuff
> > -       VFPFMXR FPEXC, r1               @ restore FPEXC last
> > -       sub     r2, r2, #4
> > -       str     r2, [sp, #S_PC]         @ retry the instruction
> > +       VFPFMXR FPEXC, r1               @ Restore FPEXC last
> > +       sub     r2, r2, #4              @ Retry current instruction - if Thumb
> > +       str     r2, [sp, #S_PC]         @ mode it's two 16-bit instructions,
> > +                                       @ else it's one 32-bit instruction, so
> > +                                       @ always subtract 4 from the following
> > +                                       @ instruction address.
> 
> I would say it's always a 32-bit instruction but made up of two 16-bit
> values to allow half-word alignment.

Do you have a suggested replacement text?
