Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602Ab0JAHGd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 03:06:33 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:57806 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239Ab0JAHG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 03:06:29 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        benh@kernel.crashing.org
Cc: paulus@samba.org, Ian Munsie <imunsie@au1.ibm.com>,
        Matthew McClintock <msm@freescale.com>,
        Torez Smith <lnxtorez@linux.vnet.ibm.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Subject: [PATCH 11/18] powerpc: Make assembly endian agnostic when accessing 64bit values
Date: Fri,  1 Oct 2010 17:06:04 +1000
Message-Id: <1285916771-18033-12-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com>
References: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

The 32bit PowerPC ABI states that when passing arguments and return
values via registers a value of type long long is stored in pairs of
registers as follows:

The lower addressed word is stored in the next available odd numbered
register and the higher addressed value is stored in register+1.

i.e. the values will either be stored in the next available of:
r3/r4, r5/r6, r7/r8 or r9/r10

Since the lower addressed value must be in the lower register number we
have an endianness issue and need to treat this specially in any
assembly that is passed or returns a 64bit value.

This patch introduces some aliases in ppc_asm.h which will select the
appropriate register from the pair depending on the CPU endianness.
There are in the form of r34l for the low word from the r3/r4 pair and
r34h for the high word and so on for the remaining register pairs.

It also introduces p64l and p64h which can be used to select the
appropriate offset whenever loading a 32bit word while referring to the
address of a 64bit value. For instance if r3 contains the address of a
64bit value the following assembly would load the high word into r5 and
the low word into r6 regardless of endianness:
	lwz	r5,p64h(r3)
	lwz	r6,p64l(r3)

Finally, the patch also alters the functions in misc_32.S that take
64bit arguments to use these new accessors to work on the little endian
PowerPC architecture:

mulhdu, __div64_32, __ashrdi3, __ashldi3, __lshrdi3 and __ucmpdi2

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 arch/powerpc/include/asm/ppc_asm.h |   24 ++++++++++++
 arch/powerpc/kernel/misc_32.S      |   72 ++++++++++++++++++------------------
 arch/powerpc/lib/div64.S           |    8 ++--
 3 files changed, 64 insertions(+), 40 deletions(-)

diff --git a/arch/powerpc/include/asm/ppc_asm.h b/arch/powerpc/include/asm/ppc_asm.h
index 9821006..6929483 100644
--- a/arch/powerpc/include/asm/ppc_asm.h
+++ b/arch/powerpc/include/asm/ppc_asm.h
@@ -510,6 +510,30 @@ END_FTR_SECTION_IFCLR(CPU_FTR_601)
 #define	r30	30
 #define	r31	31
 
+/* Endian agnostic accessors for 64 bit values passed and returned in GPRs */
+#ifdef __BIG_ENDIAN__
+#define r34l	r4
+#define r34h	r3
+#define r56l	r6
+#define r56h	r5
+#define r78l	r8
+#define r78h	r7
+
+/* Endian agnostic accessors for pointer offsets to 64 bit values */
+#define p64l	4
+#define p64h	0
+#else
+#define r34l	r3
+#define r34h	r4
+#define r56l	r5
+#define r56h	r6
+#define r78l	r7
+#define r78h	r8
+
+#define p64l	0
+#define p64h	4
+#endif
+
 
 /* Floating Point Registers (FPRs) */
 
diff --git a/arch/powerpc/kernel/misc_32.S b/arch/powerpc/kernel/misc_32.S
index a7a570d..6c40079 100644
--- a/arch/powerpc/kernel/misc_32.S
+++ b/arch/powerpc/kernel/misc_32.S
@@ -60,27 +60,27 @@ _GLOBAL(call_handle_irq)
  * This returns the high 64 bits of the product of two 64-bit numbers.
  */
 _GLOBAL(mulhdu)
-	cmpwi	r6,0
-	cmpwi	cr1,r3,0
-	mr	r10,r4
-	mulhwu	r4,r4,r5
+	cmpwi	r56l,0
+	cmpwi	cr1,r34h,0
+	mr	r10,r34l
+	mulhwu	r34l,r34l,r56h
 	beq	1f
-	mulhwu	r0,r10,r6
-	mullw	r7,r10,r5
+	mulhwu	r0,r10,r56l
+	mullw	r7,r10,r56h
 	addc	r7,r0,r7
-	addze	r4,r4
+	addze	r34l,r34l
 1:	beqlr	cr1		/* all done if high part of A is 0 */
-	mr	r10,r3
-	mullw	r9,r3,r5
-	mulhwu	r3,r3,r5
+	mr	r10,r34h
+	mullw	r9,r34h,r56h
+	mulhwu	r34h,r34h,r56h
 	beq	2f
-	mullw	r0,r10,r6
-	mulhwu	r8,r10,r6
+	mullw	r0,r10,r56l
+	mulhwu	r8,r10,r56l
 	addc	r7,r0,r7
-	adde	r4,r4,r8
-	addze	r3,r3
-2:	addc	r4,r4,r9
-	addze	r3,r3
+	adde	r34l,r34l,r8
+	addze	r34h,r34h
+2:	addc	r34l,r34l,r9
+	addze	r34h,r34h
 	blr
 
 /*
@@ -606,37 +606,37 @@ _GLOBAL(atomic_set_mask)
  */
 _GLOBAL(__ashrdi3)
 	subfic	r6,r5,32
-	srw	r4,r4,r5	# LSW = count > 31 ? 0 : LSW >> count
+	srw	r34l,r34l,r5	# LSW = count > 31 ? 0 : LSW >> count
 	addi	r7,r5,32	# could be xori, or addi with -32
-	slw	r6,r3,r6	# t1 = count > 31 ? 0 : MSW << (32-count)
+	slw	r6,r34h,r6	# t1 = count > 31 ? 0 : MSW << (32-count)
 	rlwinm	r8,r7,0,32	# t3 = (count < 32) ? 32 : 0
-	sraw	r7,r3,r7	# t2 = MSW >> (count-32)
-	or	r4,r4,r6	# LSW |= t1
+	sraw	r7,r34h,r7	# t2 = MSW >> (count-32)
+	or	r34l,r34l,r6	# LSW |= t1
 	slw	r7,r7,r8	# t2 = (count < 32) ? 0 : t2
-	sraw	r3,r3,r5	# MSW = MSW >> count
-	or	r4,r4,r7	# LSW |= t2
+	sraw	r34h,r34h,r5	# MSW = MSW >> count
+	or	r34l,r34l,r7	# LSW |= t2
 	blr
 
 _GLOBAL(__ashldi3)
 	subfic	r6,r5,32
-	slw	r3,r3,r5	# MSW = count > 31 ? 0 : MSW << count
+	slw	r34h,r34h,r5	# MSW = count > 31 ? 0 : MSW << count
 	addi	r7,r5,32	# could be xori, or addi with -32
-	srw	r6,r4,r6	# t1 = count > 31 ? 0 : LSW >> (32-count)
-	slw	r7,r4,r7	# t2 = count < 32 ? 0 : LSW << (count-32)
-	or	r3,r3,r6	# MSW |= t1
-	slw	r4,r4,r5	# LSW = LSW << count
-	or	r3,r3,r7	# MSW |= t2
+	srw	r6,r34l,r6	# t1 = count > 31 ? 0 : LSW >> (32-count)
+	slw	r7,r34l,r7	# t2 = count < 32 ? 0 : LSW << (count-32)
+	or	r34h,r34h,r6	# MSW |= t1
+	slw	r34l,r34l,r5	# LSW = LSW << count
+	or	r34h,r34h,r7	# MSW |= t2
 	blr
 
 _GLOBAL(__lshrdi3)
 	subfic	r6,r5,32
-	srw	r4,r4,r5	# LSW = count > 31 ? 0 : LSW >> count
+	srw	r34l,r34l,r5	# LSW = count > 31 ? 0 : LSW >> count
 	addi	r7,r5,32	# could be xori, or addi with -32
-	slw	r6,r3,r6	# t1 = count > 31 ? 0 : MSW << (32-count)
-	srw	r7,r3,r7	# t2 = count < 32 ? 0 : MSW >> (count-32)
-	or	r4,r4,r6	# LSW |= t1
-	srw	r3,r3,r5	# MSW = MSW >> count
-	or	r4,r4,r7	# LSW |= t2
+	slw	r6,r34h,r6	# t1 = count > 31 ? 0 : MSW << (32-count)
+	srw	r7,r34h,r7	# t2 = count < 32 ? 0 : MSW >> (count-32)
+	or	r34l,r34l,r6	# LSW |= t1
+	srw	r34h,r34h,r5	# MSW = MSW >> count
+	or	r34l,r34l,r7	# LSW |= t2
 	blr
 
 /*
@@ -644,10 +644,10 @@ _GLOBAL(__lshrdi3)
  * Returns 0 if a < b, 1 if a == b, 2 if a > b.
  */
 _GLOBAL(__ucmpdi2)
-	cmplw	r3,r5
+	cmplw	r34h,r56h
 	li	r3,1
 	bne	1f
-	cmplw	r4,r6
+	cmplw	r34l,r56l
 	beqlr
 1:	li	r3,0
 	bltlr
diff --git a/arch/powerpc/lib/div64.S b/arch/powerpc/lib/div64.S
index 83d9832..12f2da4 100644
--- a/arch/powerpc/lib/div64.S
+++ b/arch/powerpc/lib/div64.S
@@ -17,8 +17,8 @@
 #include <asm/processor.h>
 
 _GLOBAL(__div64_32)
-	lwz	r5,0(r3)	# get the dividend into r5/r6
-	lwz	r6,4(r3)
+	lwz	r5,p64h(r3)	# get the dividend into r5/r6
+	lwz	r6,p64l(r3)
 	cmplw	r5,r4
 	li	r7,0
 	li	r8,0
@@ -53,7 +53,7 @@ _GLOBAL(__div64_32)
 	mullw	r10,r0,r4	# and get the remainder
 	add	r8,r8,r0
 	subf	r6,r10,r6
-4:	stw	r7,0(r3)	# return the quotient in *r3
-	stw	r8,4(r3)
+4:	stw	r7,p64h(r3)	# return the quotient in *r3
+	stw	r8,p64l(r3)
 	mr	r3,r6		# return the remainder in r3
 	blr
-- 
1.7.1

