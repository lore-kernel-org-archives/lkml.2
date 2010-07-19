Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966880Ab0GSViy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 17:38:54 -0400
Received: from relay3.sgi.com ([192.48.152.1]:40063 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965514Ab0GSVix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 17:38:53 -0400
Message-Id: <20100719213851.441059587@sgi.com>
User-Agent: quilt/0.47-1
Date: Mon, 19 Jul 2010 16:32:20 -0500
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 02/25] GRU - skip gru tlb purging of gru contexts:w
References: <20100719213651.362618144@sgi.com>
Content-Disposition: inline; filename=uv_gru_no_tlb_purge_gseg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Skip purging the GRU TLB if the purge request is for the GRU
itself. The driver will not create TLB mappings for vmas
that map the GRU address space. Purging them is unnecessary.

This is only an optimization and is not functionally required. However, if
GRU resources are oversubscribed (unusual except for stress tests),
purging can be frequent.

Signed-off-by: Jack Steiner <steiner@sgi.com>


---
 drivers/misc/sgi-gru/grufault.c    |    8 ++++----
 drivers/misc/sgi-gru/grufile.c     |    2 +-
 drivers/misc/sgi-gru/gruprocfs.c   |    1 +
 drivers/misc/sgi-gru/grutables.h   |    3 ++-
 drivers/misc/sgi-gru/grutlbpurge.c |   11 +++++++++--
 5 files changed, 17 insertions(+), 8 deletions(-)

Index: linux/drivers/misc/sgi-gru/grufault.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufault.c	2010-06-09 08:11:31.480037430 -0500
+++ linux/drivers/misc/sgi-gru/grufault.c	2010-06-09 08:11:39.747460083 -0500
@@ -57,11 +57,11 @@ static inline int is_gru_paddr(unsigned
 /*
  * Find the vma of a GRU segment. Caller must hold mmap_sem.
  */
-struct vm_area_struct *gru_find_vma(unsigned long vaddr)
+struct vm_area_struct *gru_find_vma(struct mm_struct *mm, unsigned long vaddr)
 {
 	struct vm_area_struct *vma;
 
-	vma = find_vma(current->mm, vaddr);
+	vma = find_vma(mm, vaddr);
 	if (vma && vma->vm_start <= vaddr && vma->vm_ops == &gru_vm_ops)
 		return vma;
 	return NULL;
@@ -82,7 +82,7 @@ static struct gru_thread_state *gru_find
 	struct gru_thread_state *gts = NULL;
 
 	down_read(&mm->mmap_sem);
-	vma = gru_find_vma(vaddr);
+	vma = gru_find_vma(current->mm, vaddr);
 	if (vma)
 		gts = gru_find_thread_state(vma, TSID(vaddr, vma));
 	if (gts)
@@ -99,7 +99,7 @@ static struct gru_thread_state *gru_allo
 	struct gru_thread_state *gts = ERR_PTR(-EINVAL);
 
 	down_write(&mm->mmap_sem);
-	vma = gru_find_vma(vaddr);
+	vma = gru_find_vma(current->mm, vaddr);
 	if (!vma)
 		goto err;
 
Index: linux/drivers/misc/sgi-gru/grufile.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufile.c	2010-06-09 08:11:31.480037430 -0500
+++ linux/drivers/misc/sgi-gru/grufile.c	2010-06-09 08:11:39.751457793 -0500
@@ -145,7 +145,7 @@ static int gru_create_new_context(unsign
 		req.options |= GRU_OPT_MISS_FMM_INTR;
 
 	down_write(&current->mm->mmap_sem);
-	vma = gru_find_vma(req.gseg);
+	vma = gru_find_vma(current->mm, req.gseg);
 	if (vma) {
 		vdata = vma->vm_private_data;
 		vdata->vd_user_options = req.options;
Index: linux/drivers/misc/sgi-gru/gruprocfs.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/gruprocfs.c	2010-06-09 08:11:31.480037430 -0500
+++ linux/drivers/misc/sgi-gru/gruprocfs.c	2010-06-09 08:11:39.763413322 -0500
@@ -87,6 +87,7 @@ static int statistics_show(struct seq_fi
 	printstat(s, tlb_dropin_fail_no_exception);
 	printstat(s, tfh_stale_on_fault);
 	printstat(s, mmu_invalidate_range);
+	printstat(s, mmu_invalidate_range_flush);
 	printstat(s, mmu_invalidate_page);
 	printstat(s, flush_tlb);
 	printstat(s, flush_tlb_gru);
Index: linux/drivers/misc/sgi-gru/grutables.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grutables.h	2010-06-09 08:11:31.480037430 -0500
+++ linux/drivers/misc/sgi-gru/grutables.h	2010-06-09 08:11:39.779413278 -0500
@@ -213,6 +213,7 @@ struct gru_stats_s {
 	atomic_long_t tlb_dropin_fail_no_exception;
 	atomic_long_t tfh_stale_on_fault;
 	atomic_long_t mmu_invalidate_range;
+	atomic_long_t mmu_invalidate_range_flush;
 	atomic_long_t mmu_invalidate_page;
 	atomic_long_t flush_tlb;
 	atomic_long_t flush_tlb_gru;
@@ -653,7 +654,7 @@ extern int gru_get_exception_detail(unsi
 extern int gru_set_context_option(unsigned long address);
 extern void gru_check_context_placement(struct gru_thread_state *gts);
 extern int gru_cpu_fault_map_id(void);
-extern struct vm_area_struct *gru_find_vma(unsigned long vaddr);
+extern struct vm_area_struct *gru_find_vma(struct mm_struct *mm, unsigned long vaddr);
 extern void gru_flush_all_tlb(struct gru_state *gru);
 extern int gru_proc_init(void);
 extern void gru_proc_exit(void);
Index: linux/drivers/misc/sgi-gru/grutlbpurge.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grutlbpurge.c	2010-06-09 08:11:31.480037430 -0500
+++ linux/drivers/misc/sgi-gru/grutlbpurge.c	2010-06-09 08:11:39.795536964 -0500
@@ -226,11 +226,19 @@ static void gru_invalidate_range_start(s
 	struct gru_mm_struct *gms = container_of(mn, struct gru_mm_struct,
 						 ms_notifier);
 
+	if (mm && atomic_read(&mm->mm_users) && unlikely(down_write_trylock(&mm->mmap_sem))) {
+		up_write(&mm->mmap_sem);
+	}
 	STAT(mmu_invalidate_range);
 	atomic_inc(&gms->ms_range_active);
 	gru_dbg(grudev, "gms %p, start 0x%lx, end 0x%lx, act %d\n", gms,
 		start, end, atomic_read(&gms->ms_range_active));
-	gru_flush_tlb_range(gms, start, end - start);
+
+	/* No need to flush if unmapping a GRU context */
+	if (!gru_find_vma(mm, start)) {
+		STAT(mmu_invalidate_range_flush);
+		gru_flush_tlb_range(gms, start, end - start);
+	}
 }
 
 static void gru_invalidate_range_end(struct mmu_notifier *mn,
@@ -242,7 +250,6 @@ static void gru_invalidate_range_end(str
 
 	/* ..._and_test() provides needed barrier */
 	(void)atomic_dec_and_test(&gms->ms_range_active);
-
 	wake_up_all(&gms->ms_wait_queue);
 	gru_dbg(grudev, "gms %p, start 0x%lx, end 0x%lx\n", gms, start, end);
 }

