Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab1ERVZl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:25:41 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44973 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316Ab1ERVZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:25:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Kwqsh14rVGXGwhGDUJYlqVk/vyWsY+RL0FVGA+GcMIZKFBqyezOpuPKRmWWn5dBmfc
         jGN33qfPjkcoKW/szKHyXZKrSKYmW9GtefABziVJCtSFdrw5krWb1VyMAp0fIExadBP4
         MXlkQtfUGb1Puf8gZxLEcwNcMMzIgMo8ybN+4=
From: Eric Van Hensbergen <ericvh@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org, bg-linux@lists.anl-external.org,
        Eric Van Hensbergen <ericvh@gmail.com>
Subject: [PATCH 7/7] [RFC] SMP support code
Date: Wed, 18 May 2011 16:24:55 -0500
Message-Id: <1305753895-24845-7-git-send-email-ericvh@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1305753895-24845-1-git-send-email-ericvh@gmail.com>
References: <1305753895-24845-1-git-send-email-ericvh@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the necessary core code to enable SMP support on BlueGene/P

Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
---
 arch/powerpc/kernel/head_44x.S         |   72 +++++++++++++++++++++++++++++
 arch/powerpc/mm/fault.c                |   77 ++++++++++++++++++++++++++++++++
 arch/powerpc/platforms/Kconfig.cputype |    2 +-
 3 files changed, 150 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/head_44x.S b/arch/powerpc/kernel/head_44x.S
index 1f7ae60..57d4483 100644
--- a/arch/powerpc/kernel/head_44x.S
+++ b/arch/powerpc/kernel/head_44x.S
@@ -1133,6 +1133,70 @@ clear_utlb_entry:
 
 #endif /* CONFIG_PPC_47x */
 
+#if defined(CONFIG_BGP) && defined(CONFIG_SMP)
+_GLOBAL(start_secondary_bgp)
+	/* U2 will be enabled in TLBs. */
+        lis     r7,PPC44x_MMUCR_U2@h
+        mtspr   SPRN_MMUCR,r7
+        li      r7,0
+        mtspr   SPRN_PID,r7
+        sync
+        lis     r8,KERNELBASE@h
+
+        /* The tlb_44x_hwater global var (setup by cpu#0) reveals how many
+         * 256M TLBs we need to map.
+         */
+        lis     r9, tlb_44x_hwater@ha
+        lwz     r9, tlb_44x_hwater@l(r9)
+
+        li      r5,(PPC44x_TLB_SW | PPC44x_TLB_SR | PPC44x_TLB_SX | \
+						PPC44x_TLB_M|PPC44x_TLB_U2)
+        oris    r5, r5, PPC44x_TLB_WL1@h
+
+        /* tlb_44x_hwater is the biggest TLB slot number for regular TLBs.
+           TLB 63 covers kernel base mapping(256MB) and TLB 62 covers CNS.
+           With 768MB lowmem, it is set to 59.
+        */
+2:
+        addi    r9, r9, 1
+        cmpwi   r9,62                  /* Stop at entry 62 which is the fw */
+        beq     3f
+        addis   r7,r7,0x1000           /* add 256M */
+        addis   r8,r8,0x1000
+        ori     r6,r8,PPC44x_TLB_VALID | PPC44x_TLB_256M
+
+        tlbwe   r6,r9,PPC44x_TLB_PAGEID /* Load the pageid fields */
+        tlbwe   r7,r9,PPC44x_TLB_XLAT   /* Load the translation fields */
+        tlbwe   r5,r9,PPC44x_TLB_ATTRIB /* Load the attrib/access fields */
+        b       2b
+
+3:      isync
+
+        /* Setup context from global var secondary_ti */
+        lis     r1, secondary_ti@ha
+        lwz     r1, secondary_ti@l(r1)
+        lwz     r2, TI_TASK(r1)         /*  r2 = task_info */
+
+        addi    r3,r2,THREAD    /* init task's THREAD */
+        mtspr   SPRN_SPRG3,r3
+
+        li      r0,0
+        stwu    r0,THREAD_SIZE-STACK_FRAME_OVERHEAD(r1)
+
+        /* Let's move on */
+        lis     r4,start_secondary@h
+        ori     r4,r4,start_secondary@l
+        lis     r3,MSR_KERNEL@h
+        ori     r3,r3,MSR_KERNEL@l
+        mtspr   SPRN_SRR0,r4
+        mtspr   SPRN_SRR1,r3
+        rfi                     /* change context and jump to start_secondary */
+
+_GLOBAL(start_secondary_resume)
+	/* I don't think this currently happens on BGP */
+	b       .
+#endif /* CONFIG_BGP && CONFIG_SMP */
+
 /*
  * Here we are back to code that is common between 44x and 47x
  *
@@ -1144,6 +1208,14 @@ head_start_common:
 	lis	r4,interrupt_base@h	/* IVPR only uses the high 16-bits */
 	mtspr	SPRN_IVPR,r4
 
+#if defined(CONFIG_BGP) && defined(CONFIG_SMP)
+	/* are we an additional CPU */
+	li	r0, 0
+	mfspr	r4, SPRN_PIR
+	cmpw	r4, r0
+	bgt	start_secondary_bgp
+#endif /* CONFIG_BGP && CONFIG_SMP */
+
 	addis	r22,r22,KERNELBASE@h
 	mtlr	r22
 	isync
diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
index 54f4fb9..0e73244 100644
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -103,6 +103,77 @@ static int store_updates_sp(struct pt_regs *regs)
 	return 0;
 }
 
+#ifdef CONFIG_BGP
+/*
+ * The icbi instruction does not broadcast to all cpus in the ppc450
+ * processor used by Blue Gene/P.  It is unlikely this problem will
+ * be exhibited in other processors so this remains ifdef'ed for BGP
+ * specifically.
+ *
+ * We deal with this by marking executable pages either writable, or
+ * executable, but never both.  The permissions will fault back and
+ * forth if the thread is actively writing to executable sections.
+ * Each time we fault to become executable we flush the dcache into
+ * icache on all cpus.
+ */
+struct bgp_fixup_parm {
+	struct page		*page;
+	unsigned long		address;
+	struct vm_area_struct	*vma;
+};
+
+static void bgp_fixup_cache_tlb(void *parm)
+{
+	struct bgp_fixup_parm	*p = parm;
+
+	if (!PageHighMem(p->page))
+		flush_dcache_icache_page(p->page);
+	local_flush_tlb_page(p->vma, p->address);
+}
+
+static void bgp_fixup_access_perms(struct vm_area_struct *vma,
+				  unsigned long address,
+				  int is_write, int is_exec)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	pte_t *ptep = NULL;
+	pmd_t *pmdp;
+
+	if (get_pteptr(mm, address, &ptep, &pmdp)) {
+		spinlock_t *ptl = pte_lockptr(mm, pmdp);
+		pte_t old;
+
+		spin_lock(ptl);
+		old = *ptep;
+		if (pte_present(old)) {
+			struct page *page = pte_page(old);
+
+			if (is_exec) {
+				struct bgp_fixup_parm param = {
+					.page		= page,
+					.address	= address,
+					.vma		= vma,
+				};
+				pte_update(ptep, _PAGE_HWWRITE, 0);
+				on_each_cpu(bgp_fixup_cache_tlb, &param, 1);
+				pte_update(ptep, 0, _PAGE_EXEC);
+				pte_unmap_unlock(ptep, ptl);
+				return;
+			}
+			if (is_write &&
+			    (pte_val(old) & _PAGE_RW) &&
+			    (pte_val(old) & _PAGE_DIRTY) &&
+			    !(pte_val(old) & _PAGE_HWWRITE)) {
+				pte_update(ptep, _PAGE_EXEC, _PAGE_HWWRITE);
+			}
+		}
+		if (!pte_same(old, *ptep))
+			flush_tlb_page(vma, address);
+		pte_unmap_unlock(ptep, ptl);
+	}
+}
+#endif /* CONFIG_BGP */
+
 /*
  * For 600- and 800-family processors, the error_code parameter is DSISR
  * for a data fault, SRR1 for an instruction fault. For 400-family processors
@@ -333,6 +404,12 @@ good_area:
 		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1, 0,
 				     regs, address);
 	}
+
+#ifdef CONFIG_BGP
+	/* Fixup _PAGE_EXEC and _PAGE_HWWRITE if necessary */
+	bgp_fixup_access_perms(vma, address, is_write, is_exec);
+#endif /* CONFIG_BGP */
+
 	up_read(&mm->mmap_sem);
 	return 0;
 
diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index 3a3c711..b77a25f 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -300,7 +300,7 @@ config PPC_PERF_CTRS
          This enables the powerpc-specific perf_event back-end.
 
 config SMP
-	depends on PPC_BOOK3S || PPC_BOOK3E || FSL_BOOKE || PPC_47x
+	depends on PPC_BOOK3S || PPC_BOOK3E || FSL_BOOKE || PPC_47x || BGP
 	bool "Symmetric multi-processing support"
 	---help---
 	  This enables support for systems with more than one CPU. If you have
-- 
1.7.4.1

