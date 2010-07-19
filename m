Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967035Ab0GSVla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 17:41:30 -0400
Received: from relay3.sgi.com ([192.48.152.1]:40070 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966871Ab0GSViy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 17:38:54 -0400
Message-Id: <20100719213853.435631072@sgi.com>
User-Agent: quilt/0.47-1
Date: Mon, 19 Jul 2010 16:32:32 -0500
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 14/25] GRU - add polling for tlb misses
References: <20100719213651.362618144@sgi.com>
Content-Disposition: inline; filename=uv_gru_tlb_polling
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Currently, the GRU driver processes TLB misses by sending an interrupt to the cpu.
The TLB is updated from the interrupt handler.

Some workloads have unused cpus. This patch (still experimental) uses idle
cpus to poll for TLB misses. When a miss occurs, the TLB is updated directly
w/o having to send interrupts to the cpu.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/gru.h       |    1 
 drivers/misc/sgi-gru/grufault.c  |   50 ++++++++++++++++++++++++++++++++++-----
 drivers/misc/sgi-gru/grufile.c   |   20 +++++++++++++++
 drivers/misc/sgi-gru/grulib.h    |   10 +++++++
 drivers/misc/sgi-gru/grumain.c   |   33 +++++++++++--------------
 drivers/misc/sgi-gru/gruprocfs.c |    2 +
 drivers/misc/sgi-gru/grutables.h |    7 ++++-
 7 files changed, 97 insertions(+), 26 deletions(-)

Index: linux/drivers/misc/sgi-gru/gru.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/gru.h	2010-07-19 10:23:16.266244020 -0500
+++ linux/drivers/misc/sgi-gru/gru.h	2010-07-19 10:25:40.974376072 -0500
@@ -71,7 +71,6 @@ struct gru_gseg_statistics {
 #define GRU_OPT_MISS_USER_POLL	0x0001	/* User will poll CB for faults */
 #define GRU_OPT_MISS_FMM_INTR	0x0002	/* Send interrupt to cpu to
 					   handle fault */
-#define GRU_OPT_MISS_FMM_POLL	0x0003	/* Use system polling thread */
 #define GRU_OPT_MISS_MASK	0x0003	/* Mask for TLB MISS option */
 
 
Index: linux/drivers/misc/sgi-gru/grufault.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufault.c	2010-07-19 10:25:31.203387741 -0500
+++ linux/drivers/misc/sgi-gru/grufault.c	2010-07-19 10:25:40.978392010 -0500
@@ -156,7 +156,7 @@ static void get_clear_fault_map(struct g
 	unsigned long i, k;
 	struct gru_tlb_fault_map *tfm;
 
-	tfm = get_tfm_for_cpu(gru, gru_cpu_fault_map_id());
+	tfm = get_tfm_for_cpu(gru, gru_cpu_fault_map_id(gru));
 	prefetchw(tfm);		/* Helps on hardware, required for emulator */
 	for (i = 0; i < BITS_TO_LONGS(GRU_NUM_CBE); i++) {
 		k = tfm->fault_bits[i];
@@ -325,7 +325,7 @@ static void gru_preload_tlb(struct gru_s
 	unsigned long vaddr = 0, gpa;
 	int ret, pageshift;
 
-	if (cbe->opccpy != OP_BCOPY)
+	if (cbe->opccpy != OP_BCOPY || (cbe->cbrexecstatus & CBR_EXS_TLB_INVAL))
 		return;
 
 	if (fault_vaddr == cbe->cbe_baddr0)
@@ -546,8 +546,6 @@ static irqreturn_t gru_intr(int chiplet,
 	struct completion *cmp;
 	int cbrnum, ctxnum, multi = 0;
 
-	STAT(intr);
-
 	gru = &gru_base[blade]->bs_grus[chiplet];
 	if (!gru) {
 		dev_err(grudev, "GRU: invalid interrupt: cpu %d, chiplet %d\n",
@@ -610,14 +608,54 @@ static irqreturn_t gru_intr(int chiplet,
 	return IRQ_HANDLED;
 }
 
+#define YIELD_TICKS	(HZ / 20)
+void gru_intr_poll(int chiplet, int blade)
+{
+	struct gru_state *gru;
+	struct gru_tlb_fault_map *tfm;
+	unsigned long j, j_yield = 0, j_intr = 0;
+
+	gru = &gru_base[blade]->bs_grus[chiplet];
+	tfm = get_tfm_for_cpu(gru, 0);
+	gru->gs_fmm_polling_mode = 1;
+
+	while (likely(!signal_pending(current))) {
+		j = jiffies;
+		if (j_intr == j) {
+			cpu_relax();
+		} else {
+			__monitor(tfm, 0, 0);
+			smp_mb();
+			if (likely(tfm->fault_bits[0] + tfm->fault_bits[1] + tfm->done_bits[0] + tfm->done_bits[1]) == 0) {
+				__mwait(0x0, 0);
+				STAT(intr_poll);
+			}
+		}
+		if (likely(tfm->fault_bits[0] + tfm->fault_bits[1] + tfm->done_bits[0] + tfm->done_bits[1])) {
+			gru_intr(chiplet, blade);
+			STAT(intr_poll_found);
+			j_intr = j;
+		}
+		if (unlikely(j < j_yield)) {
+			yield();
+			j_yield = jiffies + YIELD_TICKS;
+		}
+	}
+	gru->gs_fmm_polling_mode = 0;
+}
+
 irqreturn_t gru0_intr(int irq, void *dev_id)
 {
-	return gru_intr(0, uv_numa_blade_id());
+	gru_intr(0, uv_numa_blade_id());
+	STAT(intr);
+	return IRQ_HANDLED;
 }
 
 irqreturn_t gru1_intr(int irq, void *dev_id)
 {
-	return gru_intr(1, uv_numa_blade_id());
+	gru_intr(1, uv_numa_blade_id());
+	STAT(intr);
+	return IRQ_HANDLED;
 }
 
 irqreturn_t gru_intr_mblade(int irq, void *dev_id)
Index: linux/drivers/misc/sgi-gru/grufile.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufile.c	2010-07-19 10:25:39.950898415 -0500
+++ linux/drivers/misc/sgi-gru/grufile.c	2010-07-19 10:25:41.002455321 -0500
@@ -127,6 +127,23 @@ static int gru_file_mmap(struct file *fi
 	return 0;
 }
 
+int gru_enable_polling_mode(unsigned long arg)
+{
+	struct gru_fmm_polling_req req;
+	struct gru_state *gru;
+
+	if (copy_from_user(&req, (void __user *)arg, sizeof(req)))
+		return -EFAULT;
+
+	if (req.gid >= gru_max_gids)
+		return -EINVAL;
+
+	gru = GID_TO_GRU(req.gid);
+	gru_intr_poll(gru->gs_chiplet_id, gru->gs_blade_id);
+	return 0;
+}
+
+
 /*
  * Create a new GRU context
  */
@@ -186,6 +203,9 @@ static long gru_file_unlocked_ioctl(stru
 	case GRU_SET_CONTEXT_OPTION:
 		err = gru_set_context_option(arg);
 		break;
+	case GRU_FMM_POLLING_MODE:
+		err = gru_enable_polling_mode(arg);
+		break;
 	case GRU_USER_GET_EXCEPTION_DETAIL:
 		err = gru_get_exception_detail(arg);
 		break;
Index: linux/drivers/misc/sgi-gru/grulib.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grulib.h	2010-07-19 10:25:39.950898415 -0500
+++ linux/drivers/misc/sgi-gru/grulib.h	2010-07-19 10:25:41.042456010 -0500
@@ -50,6 +50,9 @@
 /* For getting gseg statistics */
 #define GRU_GET_GSEG_STATISTICS		_IOWR(GRU_IOCTL_NUM, 12, void *)
 
+/* For switching a GRU to FMM polling mode */
+#define GRU_FMM_POLLING_MODE		_IOWR(GRU_IOCTL_NUM, 13, void *)
+
 /* For user TLB flushing (primarily for tests) */
 #define GRU_USER_FLUSH_TLB		_IOWR(GRU_IOCTL_NUM, 50, void *)
 
@@ -85,6 +88,13 @@ struct gru_unload_context_req {
 };
 
 /*
+ * Structure used to initiate GRU polling for TLB misses
+ */
+struct gru_fmm_polling_req {
+	unsigned int	gid;
+};
+
+/*
  * Structure used to set context options
  */
 enum {sco_gseg_owner, sco_cch_req_slice, sco_blade_chiplet};
Index: linux/drivers/misc/sgi-gru/grumain.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grumain.c	2010-07-19 10:25:37.570888442 -0500
+++ linux/drivers/misc/sgi-gru/grumain.c	2010-07-19 10:25:41.058388796 -0500
@@ -51,7 +51,7 @@ struct device *grudev = &gru_device;
  * multiple cpus may be using the same map.
  *	ZZZ should be inline but did not work on emulator
  */
-int gru_cpu_fault_map_id(void)
+int gru_cpu_fault_map_id(struct gru_state *gru)
 {
 #ifdef CONFIG_IA64
 	return uv_blade_processor_id() % GRU_NUM_TFM;
@@ -59,6 +59,8 @@ int gru_cpu_fault_map_id(void)
 	int cpu = smp_processor_id();
 	int id, core;
 
+	if (gru->gs_fmm_polling_mode)
+		return 0;
 	core = uv_cpu_core_number(cpu);
 	id = core + UV_MAX_INT_CORES * uv_cpu_socket_number(cpu);
 	return id;
@@ -596,14 +598,11 @@ void gru_load_context(struct gru_thread_
 
 	cch = get_cch(gru->gs_gru_base_vaddr, ctxnum);
 	lock_cch_handle(cch);
-	cch->tfm_fault_bit_enable =
-	    (gts->ts_user_options == GRU_OPT_MISS_FMM_POLL
-	     || gts->ts_user_options == GRU_OPT_MISS_FMM_INTR);
-	cch->tlb_int_enable = (gts->ts_user_options == GRU_OPT_MISS_FMM_INTR);
-	if (cch->tlb_int_enable) {
-		gts->ts_tlb_int_select = gru_cpu_fault_map_id();
-		cch->tlb_int_select = gts->ts_tlb_int_select;
-	}
+	cch->tfm_fault_bit_enable = gts->ts_user_options == GRU_OPT_MISS_FMM_INTR;
+	gts->ts_tlb_int_select = gru_cpu_fault_map_id(gru);
+	cch->tlb_int_select = gts->ts_tlb_int_select;
+	cch->tlb_int_enable = !gru->gs_fmm_polling_mode &&
+			gts->ts_user_options == GRU_OPT_MISS_FMM_INTR;
 	if (gts->ts_cch_req_slice >= 0) {
 		cch->req_slice_set_enable = 1;
 		cch->req_slice = gts->ts_cch_req_slice;
@@ -671,11 +670,9 @@ int gru_update_cch(struct gru_thread_sta
 			BUG();
 		for (i = 0; i < 8; i++)
 			cch->sizeavail[i] = gts->ts_sizeavail;
-		gts->ts_tlb_int_select = gru_cpu_fault_map_id();
-		cch->tlb_int_select = gru_cpu_fault_map_id();
-		cch->tfm_fault_bit_enable =
-		  (gts->ts_user_options == GRU_OPT_MISS_FMM_POLL
-		    || gts->ts_user_options == GRU_OPT_MISS_FMM_INTR);
+		gts->ts_tlb_int_select = gru_cpu_fault_map_id(gru);
+		cch->tlb_int_select = gts->ts_tlb_int_select;
+		cch->tfm_fault_bit_enable = gts->ts_user_options == GRU_OPT_MISS_FMM_INTR;
 		if (cch_start(cch))
 			BUG();
 		ret = 1;
@@ -692,14 +689,14 @@ exit:
  * 	- task has migrated to a different cpu on the same blade where
  * 	  it was previously running.
  */
-static int gru_retarget_intr(struct gru_thread_state *gts)
+static int gru_retarget_intr(struct gru_state *gru, struct gru_thread_state *gts)
 {
 	if (gts->ts_tlb_int_select < 0
-	    || gts->ts_tlb_int_select == gru_cpu_fault_map_id())
+	    || gts->ts_tlb_int_select == gru_cpu_fault_map_id(gru))
 		return 0;
 
 	gru_dbg(grudev, "retarget from %d to %d\n", gts->ts_tlb_int_select,
-		gru_cpu_fault_map_id());
+		gru_cpu_fault_map_id(gru));
 	return gru_update_cch(gts);
 }
 
@@ -745,7 +742,7 @@ void gru_check_context_placement(struct
 	if (!gru_check_chiplet_assignment(gru, gts)) {
 		STAT(check_context_unload);
 		gru_unload_context(gts, 1);
-	} else if (gru_retarget_intr(gts)) {
+	} else if (gru_retarget_intr(gru, gts)) {
 		STAT(check_context_retarget_intr);
 	}
 }
Index: linux/drivers/misc/sgi-gru/gruprocfs.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/gruprocfs.c	2010-07-19 10:25:39.034257217 -0500
+++ linux/drivers/misc/sgi-gru/gruprocfs.c	2010-07-19 10:25:41.078288158 -0500
@@ -72,6 +72,8 @@ static int statistics_show(struct seq_fi
 	printstat(s, intr);
 	printstat(s, intr_cbr);
 	printstat(s, intr_tfh);
+	printstat(s, intr_poll);
+	printstat(s, intr_poll_found);
 	printstat(s, intr_spurious);
 	printstat(s, intr_mm_lock_failed);
 	printstat(s, call_os);
Index: linux/drivers/misc/sgi-gru/grutables.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grutables.h	2010-07-19 10:25:31.274286154 -0500
+++ linux/drivers/misc/sgi-gru/grutables.h	2010-07-19 10:25:41.130287807 -0500
@@ -204,6 +204,8 @@ struct gru_stats_s {
 	atomic_long_t intr;
 	atomic_long_t intr_cbr;
 	atomic_long_t intr_tfh;
+	atomic_long_t intr_poll;
+	atomic_long_t intr_poll_found;
 	atomic_long_t intr_spurious;
 	atomic_long_t intr_mm_lock_failed;
 	atomic_long_t call_os;
@@ -438,6 +440,8 @@ struct gru_state {
 							   local flush */
 	unsigned char		gs_tgh_first_remote;	/* starting TGH# for
 							   remote flush */
+	unsigned char		gs_fmm_polling_mode;	/* Chiplet is in TFH polling mode
+							   for TLB misses */
 	spinlock_t		gs_asid_lock;		/* lock used for
 							   assigning asids */
 	spinlock_t		gs_lock;		/* lock used for
@@ -668,6 +672,7 @@ extern void gru_kservices_exit(void);
 extern irqreturn_t gru0_intr(int irq, void *dev_id);
 extern irqreturn_t gru1_intr(int irq, void *dev_id);
 extern irqreturn_t gru_intr_mblade(int irq, void *dev_id);
+extern void gru_intr_poll(int chiplet, int blade);
 extern int gru_dump_chiplet_request(unsigned long arg);
 extern long gru_get_gseg_statistics(unsigned long arg);
 extern int gru_handle_user_call_os(unsigned long address);
@@ -680,7 +685,7 @@ extern int gru_is_gts_stealable(struct g
 extern void gru_gts_stolen(struct gru_thread_state *gts,
 				struct gru_blade_state *blade);
 extern void gru_check_context_placement(struct gru_thread_state *gts);
-extern int gru_cpu_fault_map_id(void);
+extern int gru_cpu_fault_map_id(struct gru_state *gru);
 extern struct vm_area_struct *gru_find_vma(struct mm_struct *mm, unsigned long vaddr);
 extern void gru_flush_all_tlb(struct gru_state *gru);
 extern int gru_proc_init(void);

