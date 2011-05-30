Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab1E3HWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 03:22:36 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:56759 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab1E3HWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 03:22:34 -0400
Message-ID: <4DE345B0.8020505@in.ibm.com>
Date: Mon, 30 May 2011 12:52:24 +0530
From: Suzuki Poulose <suzuki@in.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux ppc dev <linuxppc-dev@lists.ozlabs.org>
CC: "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Josh Boyer <jwboyer@linux.vnet.ibm.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] Kexec support for PPC440x
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KEXEC Support for ppc440X

The patch adds kexec support for PPC440x based boards. This work is based
on the KEXEC patches for FSL BookE.

The FSL BookE patch and the code flow could be found at the link below:

http://patchwork.ozlabs.org/patch/49359/

We invalidate all the TLB entries except the one this code is run from,
and create a 1:1 mapping for 0-2GiB in blocks of 256M. Later we jump to
the 1:1 mapping.

I have tested this patches on Ebony and Sequoia boards. It would be great
if somebody could test this on the other boards.

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
---
  arch/powerpc/Kconfig                    |    2
  arch/powerpc/include/asm/kexec.h        |    2
  arch/powerpc/kernel/44x_kexec_mapping.S |   66 ++++++++++++++++++++++++++++++++
  arch/powerpc/kernel/misc_32.S           |   22 ++++++++++
  4 files changed, 90 insertions(+), 2 deletions(-)

Index: powerpc/arch/powerpc/Kconfig
===================================================================
--- powerpc.orig/arch/powerpc/Kconfig
+++ powerpc/arch/powerpc/Kconfig
@@ -349,7 +349,7 @@ config ARCH_ENABLE_MEMORY_HOTREMOVE
  
  config KEXEC
  	bool "kexec system call (EXPERIMENTAL)"
-	depends on (PPC_BOOK3S || FSL_BOOKE) && EXPERIMENTAL
+	depends on (PPC_BOOK3S || FSL_BOOKE || (44x && !SMP && !47x)) && EXPERIMENTAL
  	help
  	  kexec is a system call that implements the ability to shutdown your
  	  current kernel, and to start another kernel.  It is like a reboot
Index: powerpc/arch/powerpc/include/asm/kexec.h
===================================================================
--- powerpc.orig/arch/powerpc/include/asm/kexec.h
+++ powerpc/arch/powerpc/include/asm/kexec.h
@@ -2,7 +2,7 @@
  #define _ASM_POWERPC_KEXEC_H
  #ifdef __KERNEL__
  
-#ifdef CONFIG_FSL_BOOKE
+#if defined(CONFIG_FSL_BOOKE) || defined(CONFIG_44x)
  
  /*
   * On FSL-BookE we setup a 1:1 mapping which covers the first 2GiB of memory
Index: powerpc/arch/powerpc/kernel/44x_kexec_mapping.S
===================================================================
--- /dev/null
+++ powerpc/arch/powerpc/kernel/44x_kexec_mapping.S
@@ -0,0 +1,66 @@
+/*
+ * Copyright (C) 2011 IBM
+ *
+ * Author : Suzuki K. Poulose <suzuki@in.ibm.com>
+ *
+ * This source code is licensed under the GNU General Public License,
+ * Version 2.  See the file COPYING for more details.
+ *
+ * Code for setting up 1:1 mapping for PPC440x for KEXEC
+ *
+ * We cannot switch off the MMU on PPC44x.
+ * So we:
+ * 1) Invalidate all the mappings except the one we are
+ * running from.
+ * 2) Create a 1:1 mapping for 0-2GiB
+ *
+ * - Based on the kexec support code for FSL BookE
+ * - Based on the boot up code for ppc44x from head_44x.S
+ * - Doesn't support 47x yet.
+ * - Doesn't support SMP.
+ *
+ */
+	bl	nxtins				/* Find our address */
+nxtins:	mflr	r5				/* Make it accessible */
+	tlbsx	r23,0,r5			/* Find entry we are in */
+	li	r4,0				/* Start at TLB entry 0 */
+	li	r3,0				/* Set PAGEID inval value */
+1:	cmpw	r23,r4				/* Is this our entry? */
+	beq	skip				/* If so, skip the inval */
+	tlbwe	r3,r4,PPC44x_TLB_PAGEID		/* If not, inval the entry */
+skip:	addi	r4,r4,1				/* Increment */
+	cmpwi	r4,64				/* Are we done? */
+	bne	1b				/* If not, repeat */
+	isync
+
+/*
+ * Setup 1:1 mapping  for 0-2GiB in blocks of 256M.
+ * r23 is the index to the mapping of this code.
+ * Skip it.
+ */
+	/* attribute fields. rwx for SUPERVISOR mode */
+	li	r5, 0
+	ori	r5, r5, (PPC44x_TLB_SW | PPC44x_TLB_SR | PPC44x_TLB_SX | PPC44x_TLB_G)
+
+	li	r11, 0				/* PageNumber */
+	li	r6, 0				/* TLB Index  */
+
+next_tlb:
+	rotlwi	r3, r11, 28			/* Create EPN (bits 0-3) */
+	mr	r4, r3				/* RPN = EPN  */
+	ori	r3, r3, PPC44x_TLB_VALID | PPC44x_TLB_256M /* SIZE = 256M, Valid */
+	cmpw	r6, r23				/* Is this our TLB entry ? */
+	bne	write_tlb
+	addi	r6, r6, 1			/* Skip our entry */
+
+write_tlb:
+	tlbwe	r3, r6, PPC44x_TLB_PAGEID	/* PageID field : EPN, V, SIZE */
+	tlbwe	r4, r6, PPC44x_TLB_XLAT		/* Address translation : RPN   */
+	tlbwe	r5, r6, PPC44x_TLB_ATTRIB	/* Attributes */
+
+	addi	r11, r11, 1			/* Increment PN */
+	addi	r6, r6, 1			/* Increment TLB Index */
+	cmpwi	r11, 8				/* Are we done ? */
+	bne	next_tlb
+	isync
+
Index: powerpc/arch/powerpc/kernel/misc_32.S
===================================================================
--- powerpc.orig/arch/powerpc/kernel/misc_32.S
+++ powerpc/arch/powerpc/kernel/misc_32.S
@@ -736,6 +736,28 @@ relocate_new_kernel:
  	mr      r5, r31
  
  	li	r0, 0
+#elif defined(CONFIG_44x)  && !defined(CONFIG_47x)
+
+	mr	r29, r3
+	mr	r30, r4
+	mr	r31, r5
+
+#include "44x_kexec_mapping.S"
+
+	mr	r3, r29
+	mr	r4, r30
+	mr	r5, r31
+
+	li	r0, 0
+
+	/* Jump back to the 1:1 address */
+	mr	r8, r0
+	mtspr	SPRN_SRR1, r8
+	addi	r8, r4, 1f - relocate_new_kernel
+	mtspr	SPRN_SRR0, r8
+	sync
+	rfi
+1:
  #else
  	li	r0, 0
  
