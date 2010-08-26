Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab0HZNYL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 09:24:11 -0400
Received: from relay2.sgi.com ([192.48.179.30]:38421 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751905Ab0HZNVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 09:21:25 -0400
Message-Id: <20100826132124.570390061@sgi.com>
User-Agent: quilt/0.47-1
Date: Thu, 26 Aug 2010 08:19:47 -0500
From: steiner@sgi.com
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [Patch 10/25] GRU - eliminate gru contention on mmap_sem
References: <20100826131937.108920216@sgi.com>
Content-Disposition: inline; filename=uv_gru_mmap_lock
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Rework the way the mmap_sem is used by the GRU driver. The old code
had a few pathes that acquired the lock for write. By changing
the place that the mmu_notifier was allocated/freed, the mmap_sem
is no longer acquired for write. This eliminates some contention on the lock
and improves performance of threaded tests that use the gru.
This also eliminates an endcase where zap_vma_range() could be called without
holding the mmap_sem .

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/grufault.c    |   11 ++++---
 drivers/misc/sgi-gru/grufile.c     |   16 +++++++----
 drivers/misc/sgi-gru/gruhandles.c  |    5 ---
 drivers/misc/sgi-gru/grumain.c     |   51 ++++++++++++++++++++++---------------
 drivers/misc/sgi-gru/grutables.h   |   11 +++++++
 drivers/misc/sgi-gru/grutlbpurge.c |   18 +++----------
 6 files changed, 63 insertions(+), 49 deletions(-)

Index: linux/drivers/misc/sgi-gru/grufault.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufault.c	2010-07-19 10:23:54.846243726 -0500
+++ linux/drivers/misc/sgi-gru/grufault.c	2010-07-19 10:25:31.203387741 -0500
@@ -98,7 +98,7 @@ static struct gru_thread_state *gru_allo
 	struct vm_area_struct *vma;
 	struct gru_thread_state *gts = ERR_PTR(-EINVAL);
 
-	down_write(&mm->mmap_sem);
+	down_read(&mm->mmap_sem);
 	vma = gru_find_vma(current->mm, vaddr);
 	if (!vma)
 		goto err;
@@ -107,11 +107,10 @@ static struct gru_thread_state *gru_allo
 	if (IS_ERR(gts))
 		goto err;
 	mutex_lock(&gts->ts_ctxlock);
-	downgrade_write(&mm->mmap_sem);
 	return gts;
 
 err:
-	up_write(&mm->mmap_sem);
+	up_read(&mm->mmap_sem);
 	return gts;
 }
 
@@ -764,18 +763,20 @@ static int gru_unload_all_contexts(void)
 	struct gru_thread_state *gts;
 	struct gru_state *gru;
 	int gid, ctxnum;
+	struct gru_blade_state *blade;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 	foreach_gid(gid) {
 		gru = GID_TO_GRU(gid);
+		blade = gru->gs_blade;
 		spin_lock(&gru->gs_lock);
 		for (ctxnum = 0; ctxnum < GRU_NUM_CCH; ctxnum++) {
 			gts = gru->gs_gts[ctxnum];
-			if (gts && mutex_trylock(&gts->ts_ctxlock)) {
+			if (gts && gru_is_gts_stealable(gts, blade)) {
 				spin_unlock(&gru->gs_lock);
 				gru_unload_context(gts, 1);
-				mutex_unlock(&gts->ts_ctxlock);
+				gru_gts_stolen(gts, blade);
 				spin_lock(&gru->gs_lock);
 			}
 		}
Index: linux/drivers/misc/sgi-gru/grufile.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufile.c	2010-07-19 10:23:21.622879486 -0500
+++ linux/drivers/misc/sgi-gru/grufile.c	2010-07-19 10:25:31.203387741 -0500
@@ -88,6 +88,7 @@ static void gru_vma_close(struct vm_area
 		mutex_unlock(&gts->ts_ctxlock);
 		gts_drop(gts);
 	}
+	gru_drop_mmu_notifier(vdata->vd_gms);
 	kfree(vdata);
 	STAT(vdata_free);
 }
@@ -101,6 +102,8 @@ static void gru_vma_close(struct vm_area
  */
 static int gru_file_mmap(struct file *file, struct vm_area_struct *vma)
 {
+	struct gru_vma_data *vdata;
+
 	if ((vma->vm_flags & (VM_SHARED | VM_WRITE)) != (VM_SHARED | VM_WRITE))
 		return -EPERM;
 
@@ -114,9 +117,10 @@ static int gru_file_mmap(struct file *fi
 	vma->vm_page_prot = PAGE_SHARED;
 	vma->vm_ops = &gru_vm_ops;
 
-	vma->vm_private_data = gru_alloc_vma_data(vma, 0);
-	if (!vma->vm_private_data)
-		return -ENOMEM;
+	vdata = gru_alloc_vma_data(vma, 0);
+	if (IS_ERR(vdata))
+		return PTR_ERR(vdata);
+	vma->vm_private_data = vdata;
 
 	gru_dbg(grudev, "file %p, vaddr 0x%lx, vma %p, vdata %p\n",
 		file, vma->vm_start, vma, vma->vm_private_data);
@@ -144,18 +148,20 @@ static int gru_create_new_context(unsign
 	if (!(req.options & GRU_OPT_MISS_MASK))
 		req.options |= GRU_OPT_MISS_FMM_INTR;
 
-	down_write(&current->mm->mmap_sem);
+	down_read(&current->mm->mmap_sem);
 	vma = gru_find_vma(current->mm, req.gseg);
 	if (vma) {
 		vdata = vma->vm_private_data;
+		spin_lock(&vdata->vd_lock);
 		vdata->vd_user_options = req.options;
 		vdata->vd_dsr_au_count =
 		    GRU_DS_BYTES_TO_AU(req.data_segment_bytes);
 		vdata->vd_cbr_au_count = GRU_CB_COUNT_TO_AU(req.control_blocks);
 		vdata->vd_tlb_preload_count = req.tlb_preload_count;
+		spin_unlock(&vdata->vd_lock);
 		ret = 0;
 	}
-	up_write(&current->mm->mmap_sem);
+	up_read(&current->mm->mmap_sem);
 
 	return ret;
 }
Index: linux/drivers/misc/sgi-gru/gruhandles.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/gruhandles.c	2010-07-19 10:23:10.078252250 -0500
+++ linux/drivers/misc/sgi-gru/gruhandles.c	2010-07-19 10:25:31.223491144 -0500
@@ -132,11 +132,6 @@ int cch_deallocate(struct gru_context_co
 	start_instruction(cch);
 	ret = wait_instruction_complete(cch, cchop_deallocate);
 
-	/*
-	 * Stop speculation into the GSEG being unmapped by the previous
-	 * DEALLOCATE.
-	 */
-	sync_core();
 	return ret;
 }
 
Index: linux/drivers/misc/sgi-gru/grumain.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grumain.c	2010-07-19 10:23:10.078252250 -0500
+++ linux/drivers/misc/sgi-gru/grumain.c	2010-07-19 10:25:31.247511575 -0500
@@ -295,8 +295,6 @@ static void gru_unload_mm_tracker(struct
 void gts_drop(struct gru_thread_state *gts)
 {
 	if (gts && atomic_dec_return(&gts->ts_refcnt) == 0) {
-		if (gts->ts_gms)
-			gru_drop_mmu_notifier(gts->ts_gms);
 		kfree(gts);
 		STAT(gts_free);
 	}
@@ -324,7 +322,6 @@ struct gru_thread_state *gru_alloc_gts(s
 		unsigned char tlb_preload_count, int options, int tsid)
 {
 	struct gru_thread_state *gts;
-	struct gru_mm_struct *gms;
 	int bytes;
 
 	bytes = DSR_BYTES(dsr_au_count) + CBR_BYTES(cbr_au_count);
@@ -349,20 +346,15 @@ struct gru_thread_state *gru_alloc_gts(s
 	gts->ts_cch_req_slice = -1;
 	gts->ts_sizeavail = GRU_SIZEAVAIL(PAGE_SHIFT);
 	if (vma) {
+		struct gru_vma_data *vdata = vma->vm_private_data;
+
+		gts->ts_gms = vdata->vd_gms;;
 		gts->ts_mm = current->mm;
 		gts->ts_vma = vma;
-		gms = gru_register_mmu_notifier();
-		if (IS_ERR(gms))
-			goto err;
-		gts->ts_gms = gms;
 	}
 
 	gru_dbg(grudev, "alloc gts %p\n", gts);
 	return gts;
-
-err:
-	gts_drop(gts);
-	return ERR_CAST(gms);
 }
 
 /*
@@ -371,16 +363,25 @@ err:
 struct gru_vma_data *gru_alloc_vma_data(struct vm_area_struct *vma, int tsid)
 {
 	struct gru_vma_data *vdata = NULL;
+	struct gru_mm_struct *gms;
 
 	vdata = kmalloc(sizeof(*vdata), GFP_KERNEL);
 	if (!vdata)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
+	gms = gru_register_mmu_notifier();
+	if (IS_ERR(gms))
+		goto err;
+	vdata->vd_gms = gms;
 
 	STAT(vdata_alloc);
 	INIT_LIST_HEAD(&vdata->vd_head);
 	spin_lock_init(&vdata->vd_lock);
 	gru_dbg(grudev, "alloc vdata %p\n", vdata);
 	return vdata;
+
+err:
+	kfree(vdata);
+	return ERR_PTR(PTR_ERR(gms));
 }
 
 /*
@@ -758,16 +759,23 @@ void gru_check_context_placement(struct
 #define next_gru(b, g)	(((g) < &(b)->bs_grus[GRU_CHIPLETS_PER_BLADE - 1]) ?  \
 				 ((g)+1) : &(b)->bs_grus[0])
 
-static int is_gts_stealable(struct gru_thread_state *gts,
+int gru_is_gts_stealable(struct gru_thread_state *gts,
 		struct gru_blade_state *bs)
 {
-	if (is_kernel_context(gts))
-		return down_write_trylock(&bs->bs_kgts_sema);
-	else
-		return mutex_trylock(&gts->ts_ctxlock);
+	int ret = 0, ret2;
+	if (is_kernel_context(gts)) {
+		ret = down_write_trylock(&bs->bs_kgts_sema);
+	} else {
+		ret2 = down_read_trylock(&gts->ts_mm->mmap_sem);
+		if (ret2)
+			ret = mutex_trylock(&gts->ts_ctxlock);
+		if (ret2 && !ret)
+			up_read(&gts->ts_mm->mmap_sem);
+	}
+	return ret;
 }
 
-static void gts_stolen(struct gru_thread_state *gts,
+void gru_gts_stolen(struct gru_thread_state *gts,
 		struct gru_blade_state *bs)
 {
 	if (is_kernel_context(gts)) {
@@ -775,6 +783,7 @@ static void gts_stolen(struct gru_thread
 		STAT(steal_kernel_context);
 	} else {
 		mutex_unlock(&gts->ts_ctxlock);
+		up_read(&gts->ts_mm->mmap_sem);
 		STAT(steal_user_context);
 	}
 }
@@ -819,7 +828,7 @@ void gru_steal_context(struct gru_thread
 			 	* success are high. If trylock fails, try to steal a
 			 	* different GSEG.
 			 	*/
-				if (ngts && is_gts_stealable(ngts, blade))
+				if (ngts && gru_is_gts_stealable(ngts, blade))
 					break;
 				ngts = NULL;
 			}
@@ -839,7 +848,7 @@ void gru_steal_context(struct gru_thread
 		gts->ustats.context_stolen++;
 		ngts->ts_steal_jiffies = jiffies;
 		gru_unload_context(ngts, is_kernel_context(ngts) ? 0 : 1);
-		gts_stolen(ngts, blade);
+		gru_gts_stolen(ngts, blade);
 	} else {
 		STAT(steal_context_failed);
 	}
@@ -951,6 +960,8 @@ again:
 		if (!gru_assign_gru_context(gts)) {
 			preempt_enable();
 			mutex_unlock(&gts->ts_ctxlock);
+			if (signal_pending(current))
+				return VM_FAULT_NOPAGE;
 			set_current_state(TASK_INTERRUPTIBLE);
 			schedule_timeout(GRU_ASSIGN_DELAY);  /* true hack ZZZ */
 			if (gts->ts_steal_jiffies + GRU_STEAL_DELAY < jiffies)
Index: linux/drivers/misc/sgi-gru/grutables.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grutables.h	2010-07-19 10:25:12.510295762 -0500
+++ linux/drivers/misc/sgi-gru/grutables.h	2010-07-19 10:25:31.274286154 -0500
@@ -115,10 +115,14 @@
  *       task -->|
  *       task ---+---> mm ->------ (notifier) -------+-> gms
  *                     |                             |
+ *                     |              +------------->|
+ *                     |             /               |
  *                     |--> vma -> vdata ---> gts--->|		GSEG1 (thread1)
  *                     |                  |          |
  *                     |                  +-> gts--->|		GSEG1 (thread2)
  *                     |                             |
+ *                     |              +------------->|
+ *                     |             /               |
  *                     |--> vma -> vdata ---> gts--->|		GSEG2 (thread2)
  *                     .
  *                     .
@@ -336,6 +340,7 @@ struct gru_mm_struct {
 	wait_queue_head_t	ms_wait_queue;
 	DECLARE_BITMAP(ms_asidmap, GRU_MAX_GRUS);
 	struct gru_mm_tracker	ms_asids[GRU_MAX_GRUS];
+	struct mm_struct	*ms_mm;		/* for mmu_notifier_unreg */
 };
 
 /*
@@ -345,6 +350,7 @@ struct gru_mm_struct {
 struct gru_vma_data {
 	spinlock_t		vd_lock;	/* Serialize access to vma */
 	struct list_head	vd_head;	/* head of linked list of gts */
+	struct gru_mm_struct	*vd_gms;	/* asid & ioproc struct */
 	long			vd_user_options;/* misc user option flags */
 	int			vd_cbr_au_count;
 	int			vd_dsr_au_count;
@@ -469,7 +475,6 @@ struct gru_blade_state {
 							   reserved DSR */
 	struct rw_semaphore	bs_kgts_sema;		/* lock for kgts */
 	struct gru_thread_state *bs_kgts;		/* GTS for kernel use */
-
 	/* ---- the following are used for managing kernel async GRU CBRs --- */
 	void			*bs_async_cbr;		/* CBR for async */
 	struct completion	*bs_async_wq;
@@ -670,6 +675,10 @@ extern int gru_user_flush_tlb(unsigned l
 extern int gru_user_unload_context(unsigned long arg);
 extern int gru_get_exception_detail(unsigned long arg);
 extern int gru_set_context_option(unsigned long address);
+extern int gru_is_gts_stealable(struct gru_thread_state *gts,
+				struct gru_blade_state *blade);
+extern void gru_gts_stolen(struct gru_thread_state *gts,
+				struct gru_blade_state *blade);
 extern void gru_check_context_placement(struct gru_thread_state *gts);
 extern int gru_cpu_fault_map_id(void);
 extern struct vm_area_struct *gru_find_vma(struct mm_struct *mm, unsigned long vaddr);
Index: linux/drivers/misc/sgi-gru/grutlbpurge.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grutlbpurge.c	2010-07-19 10:25:29.491266141 -0500
+++ linux/drivers/misc/sgi-gru/grutlbpurge.c	2010-07-19 10:25:31.298287925 -0500
@@ -263,21 +263,10 @@ static void gru_invalidate_page(struct m
 	gru_dbg(grudev, "gms %p, address 0x%lx\n", gms, address);
 }
 
-static void gru_release(struct mmu_notifier *mn, struct mm_struct *mm)
-{
-	struct gru_mm_struct *gms = container_of(mn, struct gru_mm_struct,
-						 ms_notifier);
-
-	gms->ms_released = 1;
-	gru_dbg(grudev, "gms %p\n", gms);
-}
-
-
 static const struct mmu_notifier_ops gru_mmuops = {
 	.invalidate_page	= gru_invalidate_page,
 	.invalidate_range_start	= gru_invalidate_range_start,
 	.invalidate_range_end	= gru_invalidate_range_end,
-	.release		= gru_release,
 };
 
 /* Move this to the basic mmu_notifier file. But for now... */
@@ -316,6 +305,7 @@ struct gru_mm_struct *gru_register_mmu_n
 			STAT(gms_alloc);
 			spin_lock_init(&gms->ms_asid_lock);
 			gms->ms_notifier.ops = &gru_mmuops;
+			gms->ms_mm = current->mm;
 			atomic_set(&gms->ms_refcnt, 1);
 			init_waitqueue_head(&gms->ms_wait_queue);
 			err = __mmu_notifier_register(&gms->ms_notifier, current->mm);
@@ -328,6 +318,9 @@ struct gru_mm_struct *gru_register_mmu_n
 	return gms;
 error:
 	kfree(gms);
+	/* mmu_notifier_register EINTR is reported as EAGAIN */
+	if (err == -EINTR)
+		err = -EAGAIN;
 	return ERR_PTR(err);
 }
 
@@ -336,8 +329,7 @@ void gru_drop_mmu_notifier(struct gru_mm
 	gru_dbg(grudev, "gms %p, refcnt %d, released %d\n", gms,
 		atomic_read(&gms->ms_refcnt), gms->ms_released);
 	if (atomic_dec_return(&gms->ms_refcnt) == 0) {
-		if (!gms->ms_released)
-			mmu_notifier_unregister(&gms->ms_notifier, current->mm);
+		mmu_notifier_unregister(&gms->ms_notifier, gms->ms_mm);
 		kfree(gms);
 		STAT(gms_free);
 	}

