Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965435Ab1C3V6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:58:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:4889 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964800Ab1C3VGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="673447326"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: benh@kernel.crashing.org, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [66/275] powerpc: Fix some 6xx/7xxx CPU setup functions
Message-Id: <20110330210503.2C1E73E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:05:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/powerpc/kernel/cpu_setup_6xx.S |   40 ++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

Index: linux-2.6.35.y/arch/powerpc/kernel/cpu_setup_6xx.S
===================================================================
--- linux-2.6.35.y.orig/arch/powerpc/kernel/cpu_setup_6xx.S	2011-03-29 22:51:43.567608382 -0700
+++ linux-2.6.35.y/arch/powerpc/kernel/cpu_setup_6xx.S	2011-03-29 23:02:59.554311574 -0700
@@ -18,7 +18,7 @@
 #include <asm/mmu.h>
 
 _GLOBAL(__setup_cpu_603)
-	mflr	r4
+	mflr	r5
 BEGIN_MMU_FTR_SECTION
 	li	r10,0
 	mtspr	SPRN_SPRG_603_LRU,r10		/* init SW LRU tracking */
@@ -27,60 +27,60 @@
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
@@ -194,10 +194,10 @@
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
@@ -225,12 +225,12 @@
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
 
