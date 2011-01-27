Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab1A0Hax (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 02:30:53 -0500
Received: from smtp-out.google.com ([216.239.44.51]:50942 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab1A0Haw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 02:30:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=oRbnuFlIZemjOzyGiBpoBr1aZpu5s3tZG6Gm+/4cZ0GUC10LkUVJhA49EWkdl7O1ud
         xjQ3g/RJ1zzOjPiU+HRw==
MIME-Version: 1.0
In-Reply-To: <AANLkTindtGzxnCRK7XZW1jtXRAeBz9cTshqCtTr3qnL7@mail.gmail.com>
References: <1295014231.7901.41.camel@e102109-lin.cambridge.arm.com>
	<20110114154919.GE15996@n2100.arm.linux.org.uk>
	<1295022193.7901.56.camel@e102109-lin.cambridge.arm.com>
	<20110114163520.GH15996@n2100.arm.linux.org.uk>
	<1295024327.7901.70.camel@e102109-lin.cambridge.arm.com>
	<20110114173050.GJ15996@n2100.arm.linux.org.uk>
	<20110114184759.GN15996@n2100.arm.linux.org.uk>
	<AANLkTi=J2A1Qv6NGB1bsMr6d+1VFV26KEBQ=NJ=791s0@mail.gmail.com>
	<AANLkTimd44_FjnJUCNwz412Ned5S_+YcyHjfitus3vLQ@mail.gmail.com>
	<AANLkTimZ9itumf=QZPD55+JA5cUOWKgwuA1_5=XsdPsP@mail.gmail.com>
	<20110126112624.GC2562@n2100.arm.linux.org.uk>
	<AANLkTim2fPySEMFn+ckrVAvJj8ZXEvBoZpgmZAKOWf=9@mail.gmail.com>
	<AANLkTindtGzxnCRK7XZW1jtXRAeBz9cTshqCtTr3qnL7@mail.gmail.com>
Date: Wed, 26 Jan 2011 23:30:48 -0800
X-Google-Sender-Auth: PtawW_JKBdjM9TiAbmTwsdmqDpc
Message-ID: <AANLkTinFvzSjT66kj5uU1YkLEaJNCyy2JV1H7Li_cSxi@mail.gmail.com>
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

On Wed, Jan 26, 2011 at 10:35 PM, Colin Cross <ccross@android.com> wrote:
> On Wed, Jan 26, 2011 at 10:11 PM, Colin Cross <ccross@android.com> wrote:
>> On Wed, Jan 26, 2011 at 3:26 AM, Russell King - ARM Linux
>> <linux@arm.linux.org.uk> wrote:
>>> On Tue, Jan 25, 2011 at 03:33:24PM -0800, Colin Cross wrote:
>>>> I think there is an additional change needed to
>>>> __und_usr_unknown/do_undefinstr.  do_undefinstr, which gets called
>>>> directly in __und_usr as well as by mov pc, lr, expects regs->ARM_pc
>>>> to be the fault address, and not the next PC, and gets called for 2 or
>>>> 4 byte instructions.
>>>
>>> It expects it to be the next PC:
>>>
>>> asmlinkage void __exception do_undefinstr(struct pt_regs *regs)
>>> {
>>>        unsigned int correction = thumb_mode(regs) ? 2 : 4;
>>>        unsigned int instr;
>>>        siginfo_t info;
>>>        void __user *pc;
>>>
>>>        /*
>>>         * According to the ARM ARM, PC is 2 or 4 bytes ahead,
>>>         * depending whether we're in Thumb mode or not.
>>>         * Correct this offset.
>>>         */
>>>        regs->ARM_pc -= correction;
>>>
>>> We expect the PC to be pointing at the next instruction to be executed.
>>> This is the value of the PC saved by the CPU when entering the exception.
>>> We correct the PC by four bytes for ARM mode to point at the previously
>>> executed instruction.
>>>
>>> For 16-bit Thumb mode, the PC is again pointing at the next instruction
>>> to be executed, and this is the value saved by the CPU.  So we correct
>>> the PC by two bytes as that is the Thumb instruction size.
>>>
>>> The problem comes with T2, where we advance the saved PC by two bytes
>>> if the instruction was 32-bit such that it again points at the next
>>> instruction to be executed.  This is where the problem comes in because
>>> we have two different chunks of code with completely different
>>> expectations.
>>
>> All do_undefinstr will do with the correction is subtract it off so
>> that pc points to the faulting instruction instead of the next
>> instruction, and calls any registered handlers.  VFP_bounce sometimes
>> subtracts off 4 (it doesn't care about T2 mode there, because T2 VFP
>> instructions are all 32 bit), and sometimes leaves pc pointing at the
>> next instruction.  If both were modified to expect the faulting
>> instruction's pc, do_undefinstr would leave pc unmodified, and
>> VFP_bounce would add 4 in the opposite cases from where it subtracts 4
>> now.
>>
>> iwmmxt_task_enable and crunch_task_enable can also get called from __und_usr.
>>
>> Currently, iwmmxt_task_enable will either end up in do_undefinstr
>> through mov pc, lr, or it will subtract 4 from the pc register value
>> and return through ret_from_exception.  With the change above, it
>> would not need to modify the pc value at all.
>>
>> crunch_task_enable is based on iwmmxt_task_enable, and works exactly the same.
>>
>>> Maybe we need to pass in the correction factor to do_undefinstr instead.
>>>
>>
>> That just makes it even more complicated, the correction factor has to
>> be tracked through every code path.
>>
>> RFC patch to follow.
>>
>
> Missed one case.  do_fpe calls into nwfpe_enter (I don't see any other
> users of fp_enter), which assumes the PC in the registers on the stack
> is faulting PC + 4, ignores r2, and uses r0 as the first instruction
> to emulate.  It will need to be slightly modified in my patch.
>

This patch is on top of your first patch that cleans up the comments,
but not the second patch that fixes the PC in the VFP exception case.
Compiled but not run tested, and I can't test crunch or iwmmxt.
vfpmodule.c may be able to be simplified (right now its both adding
and subtracting 4 from regs->ARM_pc).

 arch/arm/kernel/crunch-bits.S |    3 ---
 arch/arm/kernel/entry-armv.S  |   38 ++++++++++++++++++++------------------
 arch/arm/kernel/iwmmxt.S      |    3 ---
 arch/arm/nwfpe/entry.S        |    1 +
 arch/arm/vfp/vfphw.S          |    5 -----
 arch/arm/vfp/vfpmodule.c      |    6 ++++++
 6 files changed, 27 insertions(+), 29 deletions(-)

diff --git a/arch/arm/kernel/crunch-bits.S b/arch/arm/kernel/crunch-bits.S
index 0ec9bb4..0095368 100644
--- a/arch/arm/kernel/crunch-bits.S
+++ b/arch/arm/kernel/crunch-bits.S
@@ -77,11 +77,8 @@ ENTRY(crunch_task_enable)

 	ldr	r3, =crunch_owner
 	add	r0, r10, #TI_CRUNCH_STATE	@ get task crunch save area
-	ldr	r2, [sp, #60]			@ current task pc value
 	ldr	r1, [r3]			@ get current crunch owner
 	str	r0, [r3]			@ this task now owns crunch
-	sub	r2, r2, #4			@ adjust pc back
-	str	r2, [sp, #60]

 	ldr	r2, [r8, #0x80]
 	mov	r2, r2				@ flush out enable (@@@)
diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index 5876eec..f09e576 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -259,14 +259,18 @@ __und_svc:
 	@  r0 - instruction
 	@
 #ifndef	CONFIG_THUMB2_KERNEL
-	ldr	r0, [r2, #-4]
+        sub     r2, r2, #4
+	ldr	r0, [r2]
 #else
-	ldrh	r0, [r2, #-2]			@ Thumb instruction at LR - 2
+	sub	r2, r2, #2
+	ldrh	r0, [r2]			@ Thumb instruction at LR - 2
 	and	r9, r0, #0xf800
 	cmp	r9, #0xe800			@ 32-bit instruction if xx >= 0
-	ldrhhs	r9, [r2]			@ bottom 16 bits
+	ldrhhs	r9, [r2, #2]			@ bottom 16 bits
 	orrhs	r0, r9, r0, lsl #16
 #endif
+	str	r2, [sp, #S_PC]			@ replace regs->ARM_pc with
+						@ pc of faulting instruction
 	adr	r9, BSYM(1f)
 	bl	call_fpe

@@ -474,36 +478,34 @@ __und_usr:
 	@ r3 = regs->ARM_cpsr
 	@
 	tst	r3, #PSR_T_BIT			@ Thumb mode?
-	itttt	eq				@ explicit IT needed for the 1f label
-	subeq	r4, r2, #4			@ ARM instr at LR - 4
-1:	ldreqt	r0, [r4]
+	itet	eq				@ explicit IT needed for the 1f label
+	subeq	r2, r2, #4			@ ARM instr at LR - 4
+	subne	r2, r2, #2			@ Thumb instr at LR - 2
+1:	ldreqt	r0, [r2]
 #ifdef CONFIG_CPU_ENDIAN_BE8
 	reveq	r0, r0				@ little endian instruction
 #endif
+	str	r2, [sp, #S_PC]			@ replace regs->ARM_pc with
+						@ pc of faulting instruction
 	@
 	@ r0 = 32-bit ARM instruction which caused the exception
-	@ r2 = PC value for the following instruction (:= regs->ARM_pc)
-	@ r4 = PC value for the faulting instruction
-	@
+	@ r2 = PC value for the faulting instruction (:= regs->ARM_pc)
 	beq	call_fpe

 	@ Thumb instruction
 #if __LINUX_ARM_ARCH__ >= 7
-	sub	r4, r2, #2			@ Thumb instr at LR - 2
 2:
- ARM(	ldrht	r5, [r4], #2	)
- THUMB(	ldrht	r5, [r4]	)
- THUMB(	add	r4, r4, #2	)
+ ARM(	ldrht	r5, [r2], #2	)
+ THUMB(	ldrht	r5, [r2]	)
+ THUMB(	add	r4, r2, #2	)
 	and	r0, r5, #0xf800			@ mask bits 111x x... .... ....
 	cmp	r0, #0xe800			@ 32bit instruction if xx != 0
 	blo	__und_usr_unknown
 3:	ldrht	r0, [r4]
-	add	r2, r2, #2			@ r2 is PC + 2, make it PC + 4
 	orr	r0, r0, r5, lsl #16
 	@
 	@ r0 = the two 16-bit Thumb instructions which caused the exception
-	@ r2 = PC value for the following Thumb instruction (:= regs->ARM_pc+2)
-	@ r4 = PC value for the first 16-bit Thumb instruction
+	@ r2 = PC value for the faulting Thumb instruction (:= regs->ARM_pc)
 	@
 #else
 	b	__und_usr_unknown
@@ -544,7 +546,7 @@ ENDPROC(__und_usr)
  *
  * Emulators may wish to make use of the following registers:
  *  r0  = instruction opcode (32-bit ARM or two 16-bit Thumb)
- *  r2  = PC value to resume execution after successful emulation
+ *  r2  = PC value of the faulting instruction
  *  r9  = normal "successful" return address
  *  r10 = this threads thread_info structure
  *  lr  = unrecognised instruction return address
@@ -662,7 +664,7 @@ do_fpe:
 /*
  * The FP module is called with these registers set:
  *  r0  = instruction
- *  r2  = PC+4
+ *  r2  = PC of the faulting instruction
  *  r9  = normal "successful" return address
  *  r10 = FP workspace
  *  lr  = unrecognised FP instruction return address
diff --git a/arch/arm/kernel/iwmmxt.S b/arch/arm/kernel/iwmmxt.S
index 7fa3bb0..0842487 100644
--- a/arch/arm/kernel/iwmmxt.S
+++ b/arch/arm/kernel/iwmmxt.S
@@ -80,11 +80,8 @@ ENTRY(iwmmxt_task_enable)

 	ldr	r3, =concan_owner
 	add	r0, r10, #TI_IWMMXT_STATE	@ get task Concan save area
-	ldr	r2, [sp, #60]			@ current task pc value
 	ldr	r1, [r3]			@ get current Concan owner
 	str	r0, [r3]			@ this task now owns Concan regs
-	sub	r2, r2, #4			@ adjust pc back
-	str	r2, [sp, #60]

 	mrc	p15, 0, r2, c2, c0, 0
 	mov	r2, r2				@ cpwait
diff --git a/arch/arm/nwfpe/entry.S b/arch/arm/nwfpe/entry.S
index cafa183..923f03f 100644
--- a/arch/arm/nwfpe/entry.S
+++ b/arch/arm/nwfpe/entry.S
@@ -78,6 +78,7 @@ nwfpe_enter:
 	mov	sl, sp			@ we access the registers via 'sl'

 	ldr	r5, [sp, #S_PC]		@ get contents of PC;
+	add	r5, r5, #4		@ skip first PC, already have opcode
 	mov	r6, r0			@ save the opcode
 emulate:
 	ldr	r1, [sp, #S_PSR]	@ fetch the PSR
diff --git a/arch/arm/vfp/vfphw.S b/arch/arm/vfp/vfphw.S
index 7292921..73dea8b 100644
--- a/arch/arm/vfp/vfphw.S
+++ b/arch/arm/vfp/vfphw.S
@@ -139,11 +139,6 @@ check_for_exception:
 					@ out before setting an FPEXC that
 					@ stops us reading stuff
 	VFPFMXR	FPEXC, r1		@ Restore FPEXC last
-	sub	r2, r2, #4		@ Retry current instruction - if Thumb
-	str	r2, [sp, #S_PC]		@ mode it's two 16-bit instructions,
-					@ else it's one 32-bit instruction, so
-					@ always subtract 4 from the following
-					@ instruction address.
 #ifdef CONFIG_PREEMPT
 	get_thread_info	r10
 	ldr	r4, [r10, #TI_PREEMPT]	@ get preempt count
diff --git a/arch/arm/vfp/vfpmodule.c b/arch/arm/vfp/vfpmodule.c
index 0797cb5..1142742 100644
--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -293,6 +293,12 @@ void VFP_bounce(u32 trigger, u32 fpexc, struct
pt_regs *regs)
 	orig_fpscr = fpscr = fmrx(FPSCR);

 	/*
+	 * Normally the instruction will be emulated, set return PC to be
+	 * the next instruction
+	 */
+	regs->ARM_pc += 4;
+
+	/*
 	 * Check for the special VFP subarch 1 and FPSCR.IXE bit case
 	 */
 	if ((fpsid & FPSID_ARCH_MASK) == (1 << FPSID_ARCH_BIT)
