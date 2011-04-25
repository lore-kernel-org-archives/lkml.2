Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab1DYUXe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:23:34 -0400
Received: from 1wt.eu ([62.212.114.60]:33762 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754763Ab1DYUXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:23:30 -0400
Message-Id: <20110425200234.035231279@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:02:56 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 024/173] powerpc: Fix some 6xx/7xxx CPU setup functions
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit 1f1936ff3febf38d582177ea319eaa278f32c91f upstream.

Some of those functions try to adjust the CPU features, for example
to remove NAP support on some revisions. However, they seem to use
r5 as an index into the CPU table entry, which might have been right
a long time ago but no longer is. r4 is the right register to use.

This probably caused some off behaviours on some PowerMac variants
using 750cx or 7455 processor revisions.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/kernel/cpu_setup_6xx.S |   40 ++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

Index: longterm-2.6.27/arch/powerpc/kernel/cpu_setup_6xx.S
===================================================================
--- longterm-2.6.27.orig/arch/powerpc/kernel/cpu_setup_6xx.S	2011-01-23 10:52:08.000000000 +0100
+++ longterm-2.6.27/arch/powerpc/kernel/cpu_setup_6xx.S	2011-04-25 12:34:56.741279086 +0200
@@ -17,65 +17,65 @@
 #include <asm/cache.h>
 
 _GLOBAL(__setup_cpu_603)
-	mflr	r4
+	mflr	r5
 BEGIN_FTR_SECTION
 	bl	__init_fpu_registers
 END_FTR_SECTION_IFCLR(CPU_FTR_FPU_UNAVAILABLE)
 	bl	setup_common_caches
-	mtlr	r4
+	mtlr	r5
 	blr
 _GLOBAL(__setup_cpu_604)
-	mflr	r4
+	mflr	r5
 	bl	setup_common_caches
 	bl	setup_604_hid0
-	mtlr	r4
+	mtlr	r5
 	blr
 _GLOBAL(__setup_cpu_750)
-	mflr	r4
+	mflr	r5
 	bl	__init_fpu_registers
 	bl	setup_common_caches
 	bl	setup_750_7400_hid0
-	mtlr	r4
+	mtlr	r5
 	blr
 _GLOBAL(__setup_cpu_750cx)
-	mflr	r4
+	mflr	r5
 	bl	__init_fpu_registers
 	bl	setup_common_caches
 	bl	setup_750_7400_hid0
 	bl	setup_750cx
-	mtlr	r4
+	mtlr	r5
 	blr
 _GLOBAL(__setup_cpu_750fx)
-	mflr	r4
+	mflr	r5
 	bl	__init_fpu_registers
 	bl	setup_common_caches
 	bl	setup_750_7400_hid0
 	bl	setup_750fx
-	mtlr	r4
+	mtlr	r5
 	blr
 _GLOBAL(__setup_cpu_7400)
-	mflr	r4
+	mflr	r5
 	bl	__init_fpu_registers
 	bl	setup_7400_workarounds
 	bl	setup_common_caches
 	bl	setup_750_7400_hid0
-	mtlr	r4
+	mtlr	r5
 	blr
 _GLOBAL(__setup_cpu_7410)
-	mflr	r4
+	mflr	r5
 	bl	__init_fpu_registers
 	bl	setup_7410_workarounds
 	bl	setup_common_caches
 	bl	setup_750_7400_hid0
 	li	r3,0
 	mtspr	SPRN_L2CR2,r3
-	mtlr	r4
+	mtlr	r5
 	blr
 _GLOBAL(__setup_cpu_745x)
-	mflr	r4
+	mflr	r5
 	bl	setup_common_caches
 	bl	setup_745x_specifics
-	mtlr	r4
+	mtlr	r5
 	blr
 
 /* Enable caches for 603's, 604, 750 & 7400 */
@@ -189,10 +189,10 @@
 	cror	4*cr0+eq,4*cr0+eq,4*cr1+eq
 	cror	4*cr0+eq,4*cr0+eq,4*cr2+eq
 	bnelr
-	lwz	r6,CPU_SPEC_FEATURES(r5)
+	lwz	r6,CPU_SPEC_FEATURES(r4)
 	li	r7,CPU_FTR_CAN_NAP
 	andc	r6,r6,r7
-	stw	r6,CPU_SPEC_FEATURES(r5)
+	stw	r6,CPU_SPEC_FEATURES(r4)
 	blr
 
 /* 750fx specific
@@ -220,12 +220,12 @@
 	andis.	r11,r11,L3CR_L3E@h
 	beq	1f
 END_FTR_SECTION_IFSET(CPU_FTR_L3CR)
-	lwz	r6,CPU_SPEC_FEATURES(r5)
+	lwz	r6,CPU_SPEC_FEATURES(r4)
 	andi.	r0,r6,CPU_FTR_L3_DISABLE_NAP
 	beq	1f
 	li	r7,CPU_FTR_CAN_NAP
 	andc	r6,r6,r7
-	stw	r6,CPU_SPEC_FEATURES(r5)
+	stw	r6,CPU_SPEC_FEATURES(r4)
 1:
 	mfspr	r11,SPRN_HID0
 


