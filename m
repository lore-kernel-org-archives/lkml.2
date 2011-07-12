Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757608Ab1GLGo1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 02:44:27 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:49812 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab1GLGo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 02:44:26 -0400
From: "Suzuki K. Poulose" <suzuki@in.ibm.com>
Subject: [PATCH v2] powerpc32: Kexec support for PPC440X chipsets
To: Benjammin Herrenschmidt <benh@kernel.crashing.org>,
        Kumar Gala <galak@kernel.crashing.org>
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>,
        linux ppc dev <linuxppc-dev@lists.ozlabs.org>,
        kexec <kexec@lists.infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Suzuki Poulose <suzuki@in.ibm.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Date: Tue, 12 Jul 2011 12:14:16 +0530
Message-ID: <20110712064356.28567.48722.stgit@suzukikp.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from V1: Uses a tmp mapping in the other address space to setup
		 the 1:1 mapping (suggested by Sebastian Andrzej Siewior).

Note: Should we do the same for kernel entry code for PPC44x ?

This patch adds kexec support for PPC440 based chipsets.This work is based
on the KEXEC patches for FSL BookE.

The FSL BookE patch and the code flow could be found at the link below:

	http://patchwork.ozlabs.org/patch/49359/

Steps:

1) Invalidate all the TLB entries except the one this code is run from
2) Create a tmp mapping for our code in the other address space and jump to it
3) Invalidate the entry we used
4) Create a 1:1 mapping for 0-2GiB in blocks of 256M
5) Jump to the new 1:1 mapping and invalidate the tmp mapping

I have tested this patches on Ebony, Sequoia boards and Virtex on QEMU.
It would be great if somebody could test this on the other boards.

Signed-off-by: 	Suzuki Poulose <suzuki@in.ibm.com>
Cc:	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---

 arch/powerpc/Kconfig             |    2 
 arch/powerpc/include/asm/kexec.h |    2 
 arch/powerpc/kernel/misc_32.S    |  170 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 172 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 423145a6..d04fae0 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -349,7 +349,7 @@ config ARCH_ENABLE_MEMORY_HOTREMOVE
 
 config KEXEC
 	bool "kexec system call (EXPERIMENTAL)"
-	depends on (PPC_BOOK3S || FSL_BOOKE) && EXPERIMENTAL
+	depends on (PPC_BOOK3S || FSL_BOOKE || (44x && !SMP && !47x)) && EXPERIMENTAL
 	help
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
diff --git a/arch/powerpc/include/asm/kexec.h b/arch/powerpc/include/asm/kexec.h
index 8a33698..f921eb1 100644
--- a/arch/powerpc/include/asm/kexec.h
+++ b/arch/powerpc/include/asm/kexec.h
@@ -2,7 +2,7 @@
 #define _ASM_POWERPC_KEXEC_H
 #ifdef __KERNEL__
 
-#ifdef CONFIG_FSL_BOOKE
+#if defined(CONFIG_FSL_BOOKE) || defined(CONFIG_44x)
 
 /*
  * On FSL-BookE we setup a 1:1 mapping which covers the first 2GiB of memory
diff --git a/arch/powerpc/kernel/misc_32.S b/arch/powerpc/kernel/misc_32.S
index 998a100..a7881ab 100644
--- a/arch/powerpc/kernel/misc_32.S
+++ b/arch/powerpc/kernel/misc_32.S
@@ -8,6 +8,7 @@
  * kexec bits:
  * Copyright (C) 2002-2003 Eric Biederman  <ebiederm@xmission.com>
  * GameCube/ppc32 port Copyright (C) 2004 Albert Herranz
+ * PPC440x port  Copyright (C) 2011 Suzuki Poulose <suzuki@in.ibm.com>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -736,6 +737,175 @@ relocate_new_kernel:
 	mr      r5, r31
 
 	li	r0, 0
+#elif defined(CONFIG_44x)  && !defined(CONFIG_47x)
+
+/*
+ * Code for setting up 1:1 mapping for PPC440x for KEXEC
+ *
+ * We cannot switch off the MMU on PPC44x.
+ * So we:
+ * 1) Invalidate all the mappings except the one we are running from.
+ * 2) Create a tmp mapping for our code in the other address space(TS) and
+ *    jump to it. Invalidate the entry we started in.
+ * 3) Create a 1:1 mapping for 0-2GiB in chunks of 256M in original TS.
+ * 4) Jump to the 1:1 mapping in original TS.
+ * 5) Invalidate the tmp mapping.
+ *
+ * - Based on the kexec support code for FSL BookE
+ * - Doesn't support 47x yet.
+ *
+ */
+	/* Save our parameters */
+	mr	r29, r3
+	mr	r30, r4
+	mr	r31, r5
+
+	/* Load our MSR_IS and TID to MMUCR for TLB search */
+	mfspr	r3,SPRN_PID
+	mfmsr	r4
+	andi.	r4,r4,MSR_IS@l
+	beq	wmmucr
+	oris	r3,r3,PPC44x_MMUCR_STS@h
+wmmucr:
+	mtspr	SPRN_MMUCR,r3
+	sync
+
+	/*
+	 * Invalidate all the TLB entries except the current entry
+	 * where we are running from
+	 */
+	bl	0f				/* Find our address */
+0:	mflr	r5				/* Make it accessible */
+	tlbsx	r23,0,r5			/* Find entry we are in */
+	li	r4,0				/* Start at TLB entry 0 */
+	li	r3,0				/* Set PAGEID inval value */
+1:	cmpw	r23,r4				/* Is this our entry? */
+	beq	skip				/* If so, skip the inval */
+	tlbwe	r3,r4,PPC44x_TLB_PAGEID		/* If not, inval the entry */
+skip:
+	addi	r4,r4,1				/* Increment */
+	cmpwi	r4,64				/* Are we done?	*/
+	bne	1b				/* If not, repeat */
+	isync
+
+	/* Create a temp mapping and jump to it */
+	andi.	r6, r23, 1		/* Find the index to use */
+	addi	r24, r6, 1		/* r24 will contain 1 or 2 */
+
+	mfmsr	r9			/* get the MSR */
+	rlwinm	r5, r9, 27, 31, 31	/* Extract the MSR[IS] */
+	xori	r7, r5, 1		/* Use the other address space */
+
+	/* Read the current mapping entries */
+	tlbre	r3, r23, PPC44x_TLB_PAGEID
+	tlbre	r4, r23, PPC44x_TLB_XLAT
+	tlbre	r5, r23, PPC44x_TLB_ATTRIB
+
+	/* Save our current XLAT entry */
+	mr	r25, r4
+
+	/* Extract the TLB PageSize */
+	li	r10, 1 			/* r10 will hold PageSize */
+	rlwinm	r11, r3, 0, 24, 27	/* bits 24-27 */
+
+	/* XXX: As of now we use 256M, 4K pages */
+	cmpwi	r11, PPC44x_TLB_256M
+	bne	tlb_4k
+	rotlwi	r10, r10, 28		/* r10 = 256M */
+	b	write_out
+tlb_4k:
+	cmpwi	r11, PPC44x_TLB_4K
+	bne	default
+	rotlwi	r10, r10, 12		/* r10 = 4K */
+	b	write_out
+default:
+	rotlwi	r10, r10, 10		/* r10 = 1K */
+
+write_out:
+	/*
+	 * Write out the tmp 1:1 mapping for this code in other address space
+	 * Fixup  EPN = RPN , TS=other address space
+	 */
+	insrwi	r3, r7, 1, 23		/* Bit 23 is TS for PAGEID field */
+
+	/* Write out the tmp mapping entries */
+	tlbwe	r3, r24, PPC44x_TLB_PAGEID
+	tlbwe	r4, r24, PPC44x_TLB_XLAT
+	tlbwe	r5, r24, PPC44x_TLB_ATTRIB
+
+	subi	r11, r10, 1		/* PageOffset Mask = PageSize - 1 */
+	not	r10, r11		/* Mask for PageNum */
+
+	/* Switch to other address space in MSR */
+	insrwi	r9, r7, 1, 26		/* Set MSR[IS] = r7 */
+
+	bl	1f
+1:	mflr	r8
+	addi	r8, r8, (2f-1b)		/* Find the target offset */
+
+	/* Jump to the tmp mapping */
+	mtspr	SPRN_SRR0, r8
+	mtspr	SPRN_SRR1, r9
+	rfi
+
+2:
+	/* Invalidate the entry we were executing from */
+	li	r3, 0
+	tlbwe	r3, r23, PPC44x_TLB_PAGEID
+
+	/* attribute fields. rwx for SUPERVISOR mode */
+	li	r5, 0
+	ori	r5, r5, (PPC44x_TLB_SW | PPC44x_TLB_SR | PPC44x_TLB_SX | PPC44x_TLB_G)
+
+	/* Create 1:1 mapping in 256M pages */
+	xori	r7, r7, 1			/* Revert back to Original TS */
+
+	li	r8, 0				/* PageNumber */
+	li	r6, 3				/* TLB Index, start at 3  */
+
+next_tlb:
+	rotlwi	r3, r8, 28			/* Create EPN (bits 0-3) */
+	mr	r4, r3				/* RPN = EPN  */
+	ori	r3, r3, (PPC44x_TLB_VALID | PPC44x_TLB_256M) /* SIZE = 256M, Valid */
+	insrwi	r3, r7, 1, 23			/* Set TS from r7 */
+
+	tlbwe	r3, r6, PPC44x_TLB_PAGEID	/* PageID field : EPN, V, SIZE */
+	tlbwe	r4, r6, PPC44x_TLB_XLAT		/* Address translation : RPN   */
+	tlbwe	r5, r6, PPC44x_TLB_ATTRIB	/* Attributes */
+
+	addi	r8, r8, 1			/* Increment PN */
+	addi	r6, r6, 1			/* Increment TLB Index */
+	cmpwi	r8, 8				/* Are we done ? */
+	bne	next_tlb
+	isync
+
+	/* Jump to the new mapping 1:1 */
+	li	r9,0
+	insrwi	r9, r7, 1, 26			/* Set MSR[IS] = r7 */
+
+	bl	1f
+1:	mflr	r8
+	and	r8, r8, r11			/* Get our offset within page */
+	addi	r8, r8, (2f-1b)
+
+	and	r5, r25, r10			/* Get our target PageNum */
+	or	r8, r8, r5			/* Target jump address */
+
+	mtspr	SPRN_SRR0, r8
+	mtspr	SPRN_SRR1, r9
+	rfi
+2:
+	/* Invalidate the tmp entry we used */
+	li	r3, 0
+	tlbwe	r3, r24, PPC44x_TLB_PAGEID
+	sync
+
+	/* Restore the parameters */
+	mr	r3, r29
+	mr	r4, r30
+	mr	r5, r31
+
+	li	r0, 0
 #else
 	li	r0, 0
 

