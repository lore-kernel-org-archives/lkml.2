Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751300Ab1AWPqi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 10:46:38 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49596 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab1AWPqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 10:46:36 -0500
Date: Sun, 23 Jan 2011 15:46:07 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Colin Cross <ccross@android.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: vfp: Fix up exception location in Thumb mode
Message-ID: <20110123154607.GC30094@n2100.arm.linux.org.uk>
References: <20110114120229.GA15996@n2100.arm.linux.org.uk> <1295014231.7901.41.camel@e102109-lin.cambridge.arm.com> <20110114154919.GE15996@n2100.arm.linux.org.uk> <1295022193.7901.56.camel@e102109-lin.cambridge.arm.com> <20110114163520.GH15996@n2100.arm.linux.org.uk> <1295024327.7901.70.camel@e102109-lin.cambridge.arm.com> <20110114173050.GJ15996@n2100.arm.linux.org.uk> <AANLkTin_pMzNc-ZL+rVcwaVawer0poyxhatqw5P-A2qW@mail.gmail.com> <20110115154019.GF15996@n2100.arm.linux.org.uk> <AANLkTim8OhAtqADck0Snq-7z7opw=coiQ4=DeO0O7Qa-@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTim8OhAtqADck0Snq-7z7opw=coiQ4=DeO0O7Qa-@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 16, 2011 at 09:25:00PM +0000, Catalin Marinas wrote:
> On 15 January 2011 15:40, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Sat, Jan 15, 2011 at 03:31:04PM +0000, Catalin Marinas wrote:
> >> On 14 January 2011 17:30, Russell King - ARM Linux
> >> <linux@arm.linux.org.uk> wrote:
> >> > +@  r9  = normal "successful" return address
> >> >  @  r10 = vfp_state union
> >> >  @  r11 = CPU number
> >> > -@  lr  = failure return
> >> > -
> >> > +@  lr  = unrecognised instruction return address
> >> > +@  IRQs enabled.
> >> >  ENTRY(vfp_support_entry)
> >> >        DBGSTR3 "instr %08x pc %08x state %p", r0, r2, r10
> >> >
> >> > @@ -138,9 +138,12 @@ check_for_exception:
> >> >                                        @ exception before retrying branch
> >> >                                        @ out before setting an FPEXC that
> >> >                                        @ stops us reading stuff
> >> > -       VFPFMXR FPEXC, r1               @ restore FPEXC last
> >> > -       sub     r2, r2, #4
> >> > -       str     r2, [sp, #S_PC]         @ retry the instruction
> >> > +       VFPFMXR FPEXC, r1               @ Restore FPEXC last
> >> > +       sub     r2, r2, #4              @ Retry current instruction - if Thumb
> >> > +       str     r2, [sp, #S_PC]         @ mode it's two 16-bit instructions,
> >> > +                                       @ else it's one 32-bit instruction, so
> >> > +                                       @ always subtract 4 from the following
> >> > +                                       @ instruction address.
> >>
> >> I would say it's always a 32-bit instruction but made up of two 16-bit
> >> values to allow half-word alignment.
> >
> > Do you have a suggested replacement text?
> 
> Maybe something like: Retry the current VFP instruction (32-bit in
> both ARM and Thumb modes).
> 
> (I was wondering whether we can get on the above code path with
> asynchronous VFP exceptions where the interrupted instruction may not
> be the VFP one. But I think all Thumb-2 processors these days generate
> synchronous exceptions)

I don't think so from my understanding.

Firstly, in order to raise an undefined instruction fault, the coprocessor
has to be targetted with an instruction for it.  So the faulting instruction
here must always be for the VFP coprocessor.

Secondly, in order to get an asynchronous exception, the VFP hardware has
to be enabled.  We only retry the instruction if the VFP hardware wasn't
enabled.

So, here's the revised patch.  Ack?

diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index 2b46fea..5876eec 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -461,27 +461,35 @@ ENDPROC(__irq_usr)
 	.align	5
 __und_usr:
 	usr_entry
-
-	@
-	@ fall through to the emulation code, which returns using r9 if
-	@ it has emulated the instruction, or the more conventional lr
-	@ if we are to treat this as a real undefined instruction
 	@
-	@  r0 - instruction
+	@ The emulation code returns using r9 if it has emulated the
+	@ instruction, or the more conventional lr if we are to treat
+	@ this as a real undefined instruction
 	@
 	adr	r9, BSYM(ret_from_exception)
 	adr	lr, BSYM(__und_usr_unknown)
+	@
+	@ r2 = regs->ARM_pc, which is either 2 or 4 bytes ahead of the
+	@ faulting instruction depending on Thumb mode.
+	@ r3 = regs->ARM_cpsr
+	@
 	tst	r3, #PSR_T_BIT			@ Thumb mode?
-	itet	eq				@ explicit IT needed for the 1f label
+	itttt	eq				@ explicit IT needed for the 1f label
 	subeq	r4, r2, #4			@ ARM instr at LR - 4
-	subne	r4, r2, #2			@ Thumb instr at LR - 2
 1:	ldreqt	r0, [r4]
 #ifdef CONFIG_CPU_ENDIAN_BE8
 	reveq	r0, r0				@ little endian instruction
 #endif
+	@
+	@ r0 = 32-bit ARM instruction which caused the exception
+	@ r2 = PC value for the following instruction (:= regs->ARM_pc)
+	@ r4 = PC value for the faulting instruction
+	@
 	beq	call_fpe
+
 	@ Thumb instruction
 #if __LINUX_ARM_ARCH__ >= 7
+	sub	r4, r2, #2			@ Thumb instr at LR - 2
 2:
  ARM(	ldrht	r5, [r4], #2	)
  THUMB(	ldrht	r5, [r4]	)
@@ -492,18 +500,19 @@ __und_usr:
 3:	ldrht	r0, [r4]
 	add	r2, r2, #2			@ r2 is PC + 2, make it PC + 4
 	orr	r0, r0, r5, lsl #16
+	@
+	@ r0 = the two 16-bit Thumb instructions which caused the exception
+	@ r2 = PC value for the following Thumb instruction (:= regs->ARM_pc+2)
+	@ r4 = PC value for the second 16-bit Thumb instruction
+	@
 #else
 	b	__und_usr_unknown
 #endif
- UNWIND(.fnend		)
+ UNWIND(.fnend)
 ENDPROC(__und_usr)
 
-	@
-	@ fallthrough to call_fpe
-	@
-
 /*
- * The out of line fixup for the ldrt above.
+ * The out of line fixup for the ldrt instructions above.
  */
 	.pushsection .fixup, "ax"
 4:	mov	pc, r9
@@ -534,11 +543,12 @@ ENDPROC(__und_usr)
  * NEON handler code.
  *
  * Emulators may wish to make use of the following registers:
- *  r0  = instruction opcode.
- *  r2  = PC+4
+ *  r0  = instruction opcode (32-bit ARM or two 16-bit Thumb)
+ *  r2  = PC value to resume execution after successful emulation
  *  r9  = normal "successful" return address
- *  r10 = this threads thread_info structure.
+ *  r10 = this threads thread_info structure
  *  lr  = unrecognised instruction return address
+ * IRQs disabled, FIQs enabled.
  */
 	@
 	@ Fall-through from Thumb-2 __und_usr
diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index ee57640..eeb9250 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -347,9 +347,9 @@ asmlinkage void __exception do_undefinstr(struct pt_regs *regs)
 	void __user *pc;
 
 	/*
-	 * According to the ARM ARM, PC is 2 or 4 bytes ahead,
-	 * depending whether we're in Thumb mode or not.
-	 * Correct this offset.
+	 * According to the ARM ARM, the PC is 2 or 4 bytes ahead
+	 * depending on Thumb mode.  Correct this offset so that
+	 * regs->ARM_pc points at the faulting instruction.
 	 */
 	regs->ARM_pc -= correction;
 
diff --git a/arch/arm/vfp/entry.S b/arch/arm/vfp/entry.S
index 4fa9903..2bf6089 100644
--- a/arch/arm/vfp/entry.S
+++ b/arch/arm/vfp/entry.S
@@ -19,6 +19,15 @@
 #include <asm/vfpmacros.h>
 #include "../kernel/entry-header.S"
 
+@ VFP entry point.
+@
+@  r0  = instruction opcode (32-bit ARM or two 16-bit Thumb)
+@  r2  = PC value to resume execution after successful emulation
+@  r9  = normal "successful" return address
+@  r10 = this threads thread_info structure
+@  lr  = unrecognised instruction return address
+@  IRQs disabled.
+@
 ENTRY(do_vfp)
 #ifdef CONFIG_PREEMPT
 	ldr	r4, [r10, #TI_PREEMPT]	@ get preempt count
diff --git a/arch/arm/vfp/vfphw.S b/arch/arm/vfp/vfphw.S
index 9897dcf..7292921 100644
--- a/arch/arm/vfp/vfphw.S
+++ b/arch/arm/vfp/vfphw.S
@@ -61,13 +61,13 @@
 
 @ VFP hardware support entry point.
 @
-@  r0  = faulted instruction
-@  r2  = faulted PC+4
-@  r9  = successful return
+@  r0  = instruction opcode (32-bit ARM or two 16-bit Thumb)
+@  r2  = PC value to resume execution after successful emulation
+@  r9  = normal "successful" return address
 @  r10 = vfp_state union
 @  r11 = CPU number
-@  lr  = failure return
-
+@  lr  = unrecognised instruction return address
+@  IRQs enabled.
 ENTRY(vfp_support_entry)
 	DBGSTR3	"instr %08x pc %08x state %p", r0, r2, r10
 
@@ -138,9 +138,9 @@ check_for_exception:
 					@ exception before retrying branch
 					@ out before setting an FPEXC that
 					@ stops us reading stuff
-	VFPFMXR	FPEXC, r1		@ restore FPEXC last
-	sub	r2, r2, #4
-	str	r2, [sp, #S_PC]		@ retry the instruction
+	VFPFMXR	FPEXC, r1		@ Restore FPEXC last
+	sub	r2, r2, #4		@ Retry current instruction, 32-bit
+	str	r2, [sp, #S_PC]		@ in both ARM and Thumb modes.
 #ifdef CONFIG_PREEMPT
 	get_thread_info	r10
 	ldr	r4, [r10, #TI_PREEMPT]	@ get preempt count

