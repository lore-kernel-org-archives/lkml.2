Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab0HZNYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 09:24:20 -0400
Received: from relay2.sgi.com ([192.48.179.30]:38414 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751641Ab0HZNVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 09:21:24 -0400
Message-Id: <20100826132123.921815206@sgi.com>
User-Agent: quilt/0.47-1
Date: Thu, 26 Aug 2010 08:19:43 -0500
From: steiner@sgi.com
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [Patch 06/25] GRU - change context stealing
References: <20100826131937.108920216@sgi.com>
Content-Disposition: inline; filename=uv_gru_kservices
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

This patch substantially reworks the way the GRU driver steals
contexts from users in order to use the GRU resources for kernel use.

The new version fixes some ugly locking bugs and is overall more efficient.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/grufault.c     |    2 
 drivers/misc/sgi-gru/grukservices.c |  271 +++++++++++++++++-------------------
 drivers/misc/sgi-gru/gruprocfs.c    |   12 +
 drivers/misc/sgi-gru/grutables.h    |   37 +++-
 drivers/misc/sgi-gru/grutlbpurge.c  |    2 
 5 files changed, 167 insertions(+), 157 deletions(-)

Index: linux/drivers/misc/sgi-gru/grufault.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufault.c	2010-07-19 10:23:21.000000000 -0500
+++ linux/drivers/misc/sgi-gru/grufault.c	2010-07-19 10:23:54.846243726 -0500
@@ -564,7 +564,7 @@ static irqreturn_t gru_intr(int chiplet,
 
 	for_each_cbr_in_tfm(cbrnum, dmap.fault_bits) {
 		STAT(intr_cbr);
-		cmp = gru->gs_blade->bs_async_wq;
+		cmp = gru->gs_async_wq[cbrnum];
 		if (cmp)
 			complete(cmp);
 		gru_dbg(grudev, "gid %d, cbr_done %d, done %d\n",
Index: linux/drivers/misc/sgi-gru/grukservices.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grukservices.c	2010-07-19 10:23:10.000000000 -0500
+++ linux/drivers/misc/sgi-gru/grukservices.c	2010-07-19 10:23:54.854242947 -0500
@@ -95,14 +95,20 @@
  */
 
 
-#define ASYNC_HAN_TO_BID(h)	((h) - 1)
-#define ASYNC_BID_TO_HAN(b)	((b) + 1)
-#define ASYNC_HAN_TO_BS(h)	gru_base[ASYNC_HAN_TO_BID(h)]
-
-#define GRU_NUM_KERNEL_CBR	1
-#define GRU_NUM_KERNEL_DSR_BYTES 256
-#define GRU_NUM_KERNEL_DSR_CL	(GRU_NUM_KERNEL_DSR_BYTES /		\
-					GRU_CACHE_LINE_BYTES)
+#define HAN_TO_BID(h)	((h) - 1)
+#define BID_TO_HAN(b)	((b) + 1)
+#define HAN_TO_BS(h)	gru_base[HAN_TO_BID(h)]
+
+/* Total CBRs in a kernel context for a blade */
+#define GRU_NUM_KERNEL_CBRS	GRU_CBR_AU_SIZE
+
+/* Total DSR bytes in a kernel context for a blade */
+#define GRU_NUM_KERNEL_DSR_BYTES GRU_DSR_AU_BYTES
+
+/* Total DSR bytes/CL per CBR */
+#define GRU_CBR_DSR_BYTES	(GRU_NUM_KERNEL_DSR_BYTES /		\
+					GRU_NUM_KERNEL_CBRS)
+#define GRU_CBR_DSR_CL		(GRU_CBR_DSR_BYTES / GRU_CACHE_LINE_BYTES)
 
 /* GRU instruction attributes for all instructions */
 #define IMA			IMA_CB_DELAY
@@ -153,28 +159,32 @@ static void gru_load_kernel_context(stru
 	struct gru_state *gru;
 	struct gru_thread_state *kgts;
 	void *vaddr;
-	int ctxnum, ncpus;
+	int ctxnum;
 
 	up_read(&bs->bs_kgts_sema);
+	STAT(load_kcontext);
 	down_write(&bs->bs_kgts_sema);
 
+again:
 	if (!bs->bs_kgts) {
-		bs->bs_kgts = gru_alloc_gts(NULL, 0, 0, 0, 0, 0);
+		int cbrs = GRU_CB_COUNT_TO_AU(GRU_NUM_KERNEL_CBRS);
+		int dsrs = GRU_DS_BYTES_TO_AU(GRU_NUM_KERNEL_DSR_BYTES);
+		bs->bs_kgts = gru_alloc_gts(NULL, cbrs, dsrs, 0, 0, 0);
 		bs->bs_kgts->ts_user_blade_id = blade_id;
 	}
 	kgts = bs->bs_kgts;
 
 	if (!kgts->ts_gru) {
-		STAT(load_kernel_context);
-		ncpus = uv_blade_nr_possible_cpus(blade_id);
-		kgts->ts_cbr_au_count = GRU_CB_COUNT_TO_AU(
-			GRU_NUM_KERNEL_CBR * ncpus + bs->bs_async_cbrs);
-		kgts->ts_dsr_au_count = GRU_DS_BYTES_TO_AU(
-			GRU_NUM_KERNEL_DSR_BYTES * ncpus +
-				bs->bs_async_dsr_bytes);
-		while (!gru_assign_gru_context(kgts)) {
+		STAT(load_kcontext_assign);
+		if (!gru_assign_gru_context(kgts)) {
+			STAT(load_kcontext_steal);
+
+			up_write(&bs->bs_kgts_sema);
 			msleep(1);
-			gru_steal_context(kgts);
+			down_write(&bs->bs_kgts_sema);
+			if (bs->bs_kgts)
+				gru_steal_context(kgts);
+			goto again;
 		}
 		gru_load_context(kgts);
 		gru = bs->bs_kgts->ts_gru;
@@ -224,7 +234,7 @@ static struct gru_blade_state *gru_lock_
 	struct gru_blade_state *bs;
 	int bid;
 
-	STAT(lock_kernel_context);
+	STAT(lock_kcontext);
 again:
 	bid = blade_id < 0 ? uv_numa_blade_id() : blade_id;
 	bs = gru_base[bid];
@@ -251,33 +261,51 @@ static void gru_unlock_kernel_context(in
 
 	bs = gru_base[blade_id];
 	up_read(&bs->bs_kgts_sema);
-	STAT(unlock_kernel_context);
+	STAT(unlock_kcontext);
 }
 
 /*
  * Reserve & get pointers to the DSR/CBRs reserved for the current cpu.
  * 	- returns with preemption disabled
  */
-static int gru_get_cpu_resources(int dsr_bytes, void **cb, void **dsr)
+static int gru_get_cpu_resources(int blade_id, int dsr_bytes, void **cb, void **dsr)
 {
 	struct gru_blade_state *bs;
-	int lcpu;
+	int n, busy = 0;
+	void *cb0;
 
 	BUG_ON(dsr_bytes > GRU_NUM_KERNEL_DSR_BYTES);
 	preempt_disable();
-	bs = gru_lock_kernel_context(-1);
-	lcpu = uv_blade_processor_id();
-	*cb = bs->kernel_cb + lcpu * GRU_HANDLE_STRIDE;
-	*dsr = bs->kernel_dsr + lcpu * GRU_NUM_KERNEL_DSR_BYTES;
-	return 0;
+	bs = gru_lock_kernel_context(blade_id);
+
+	/*
+	 * Starting at a random CBR, lock a CBR for
+	 * this task.
+	 */
+	n = gru_random() % GRU_NUM_KERNEL_CBRS;
+	STAT(get_kcontext_cbr);
+	cb0 = bs->kernel_cb + n * GRU_HANDLE_STRIDE;
+	while (!trylock_cbr_handle(cb0)) {
+		n = (n + 1) % GRU_NUM_KERNEL_CBRS;
+		cb0 = bs->kernel_cb + n * GRU_HANDLE_STRIDE;
+		if (!busy)
+			STAT(get_kcontext_cbr_busy);
+		busy = 1;
+		cpu_relax();
+	}
+	*cb = cb0;
+	if (dsr)
+		*dsr = bs->kernel_dsr + n * GRU_CBR_DSR_BYTES;
+	return BID_TO_HAN(bs->bs_grus[0].gs_blade_id);
 }
 
 /*
  * Free the current cpus reserved DSR/CBR resources.
  */
-static void gru_free_cpu_resources(void *cb, void *dsr)
+static void gru_free_cpu_resources(int han, void *cb)
 {
-	gru_unlock_kernel_context(uv_numa_blade_id());
+	unlock_cbr_handle(cb);
+	gru_unlock_kernel_context(HAN_TO_BID(han));
 	preempt_enable();
 }
 
@@ -297,28 +325,11 @@ unsigned long gru_reserve_async_resource
 			struct completion *cmp)
 {
 	struct gru_blade_state *bs;
-	struct gru_thread_state *kgts;
 	int ret = 0;
 
 	bs = gru_base[blade_id];
-
-	down_write(&bs->bs_kgts_sema);
-
-	/* Verify no resources already reserved */
-	if (bs->bs_async_dsr_bytes + bs->bs_async_cbrs)
-		goto done;
-	bs->bs_async_dsr_bytes = dsr_bytes;
-	bs->bs_async_cbrs = cbrs;
-	bs->bs_async_wq = cmp;
-	kgts = bs->bs_kgts;
-
-	/* Resources changed. Unload context if already loaded */
-	if (kgts && kgts->ts_gru)
-		gru_unload_context(kgts, 0);
-	ret = ASYNC_BID_TO_HAN(blade_id);
-
-done:
-	up_write(&bs->bs_kgts_sema);
+	if (cmpxchg(&bs->bs_async_wq, 0, cmp) == 0)
+		ret = BID_TO_HAN(blade_id);
 	return ret;
 }
 
@@ -330,13 +341,9 @@ done:
  */
 void gru_release_async_resources(unsigned long han)
 {
-	struct gru_blade_state *bs = ASYNC_HAN_TO_BS(han);
+	struct gru_blade_state *bs = HAN_TO_BS(han);
 
-	down_write(&bs->bs_kgts_sema);
-	bs->bs_async_dsr_bytes = 0;
-	bs->bs_async_cbrs = 0;
 	bs->bs_async_wq = NULL;
-	up_write(&bs->bs_kgts_sema);
 }
 
 /*
@@ -347,7 +354,7 @@ void gru_release_async_resources(unsigne
  */
 void gru_wait_async_cbr(unsigned long han)
 {
-	struct gru_blade_state *bs = ASYNC_HAN_TO_BS(han);
+	struct gru_blade_state *bs = HAN_TO_BS(han);
 
 	wait_for_completion(bs->bs_async_wq);
 	mb();
@@ -364,16 +371,15 @@ void gru_wait_async_cbr(unsigned long ha
  */
 void gru_lock_async_resource(unsigned long han,  void **cb, void **dsr)
 {
-	struct gru_blade_state *bs = ASYNC_HAN_TO_BS(han);
-	int blade_id = ASYNC_HAN_TO_BID(han);
-	int ncpus;
-
-	gru_lock_kernel_context(blade_id);
-	ncpus = uv_blade_nr_possible_cpus(blade_id);
-	if (cb)
-		*cb = bs->kernel_cb + ncpus * GRU_HANDLE_STRIDE;
-	if (dsr)
-		*dsr = bs->kernel_dsr + ncpus * GRU_NUM_KERNEL_DSR_BYTES;
+	int blade_id = HAN_TO_BID(han);
+	struct gru_blade_state *bs = HAN_TO_BS(han);
+	int cbrnum;
+
+	STAT(lock_async_resource);
+	han = gru_get_cpu_resources(blade_id, 1, cb, dsr);
+	bs->bs_async_cbr = *cb;
+	cbrnum = thread_cbr_number(bs->bs_kgts, get_cb_number(*cb));
+	bs->bs_kgts->ts_gru->gs_async_wq[cbrnum] = bs->bs_async_wq;
 }
 
 /*
@@ -384,9 +390,11 @@ void gru_lock_async_resource(unsigned lo
  */
 void gru_unlock_async_resource(unsigned long han)
 {
-	int blade_id = ASYNC_HAN_TO_BID(han);
+	struct gru_blade_state *bs = HAN_TO_BS(han);
 
-	gru_unlock_kernel_context(blade_id);
+	STAT(unlock_async_resource);
+	gru_free_cpu_resources(han, bs->bs_async_cbr);
+	bs->bs_async_cbr = NULL;
 }
 
 /*----------------------------------------------------------------------*/
@@ -434,20 +442,29 @@ char *gru_get_cb_exception_detail_str(in
 	struct gru_control_block_status *gen = (void *)cb;
 	struct control_block_extended_exc_detail excdet;
 
-	if (ret > 0 && gen->istatus == CBS_EXCEPTION) {
+	if (gen->istatus == CBS_EXCEPTION) {
 		gru_get_cb_exception_detail(cb, &excdet);
 		snprintf(buf, size,
 			"GRU:%d exception: cb %p, opc %d, exopc %d, ecause 0x%x,"
-			"excdet0 0x%lx, excdet1 0x%x", smp_processor_id(),
+			"excdet0 0x%lx, excdet1 0x%x, execstatus 0x%x, state 0x%x", smp_processor_id(),
 			gen, excdet.opc, excdet.exopc, excdet.ecause,
-			excdet.exceptdet0, excdet.exceptdet1);
+			excdet.exceptdet0, excdet.exceptdet1,
+			excdet.cbrexecstatus, excdet.cbrexecstatus);
 	} else {
 		snprintf(buf, size, "No exception");
 	}
 	return buf;
 }
 
-static int gru_wait_idle_or_exception(struct gru_control_block_status *gen)
+static void gru_print_cb_exception_detail(char *id, void *cb)
+{
+	char buf[GRU_EXC_STR_SIZE];
+
+	gru_get_cb_exception_detail_str(1, cb, buf, sizeof(buf));
+	printk(KERN_ERR "GRU: %d  %s\n", smp_processor_id(), buf);
+}
+
+static int gru_wait_idle_or_exception(struct gru_instruction_bits *gen)
 {
 	while (gen->istatus >= CBS_ACTIVE) {
 		cpu_relax();
@@ -458,7 +475,7 @@ static int gru_wait_idle_or_exception(st
 
 static int gru_retry_exception(void *cb)
 {
-	struct gru_control_block_status *gen = (void *)cb;
+	struct gru_instruction_bits *gen = (void *)cb;
 	struct control_block_extended_exc_detail excdet;
 	int retry = EXCEPTION_RETRY_LIMIT;
 
@@ -475,13 +492,14 @@ static int gru_retry_exception(void *cb)
 			break;
 		gen->icmd = 1;
 		gru_flush_cache(gen);
+		printk(KERN_ERR "GRU: %d retry exception 0x%p\n", smp_processor_id(), cb);
 	}
 	return CBS_EXCEPTION;
 }
 
 int gru_check_status_proc(void *cb)
 {
-	struct gru_control_block_status *gen = (void *)cb;
+	struct gru_instruction_bits *gen = (void *)cb;
 	int ret;
 
 	ret = gen->istatus;
@@ -494,7 +512,7 @@ int gru_check_status_proc(void *cb)
 
 int gru_wait_proc(void *cb)
 {
-	struct gru_control_block_status *gen = (void *)cb;
+	struct gru_instruction_bits *gen = (void *)cb;
 	int ret;
 
 	ret = gru_wait_idle_or_exception(gen);
@@ -517,8 +535,10 @@ void gru_wait_abort_proc(void *cb)
 	int ret;
 
 	ret = gru_wait_proc(cb);
-	if (ret)
-		gru_abort(ret, cb, "gru_wait_abort");
+	if (ret) {
+		gru_print_cb_exception_detail("abort", cb);
+		panic("gru_wait_abort");
+	}
 }
 
 
@@ -799,14 +819,13 @@ int gru_send_message_gpa(struct gru_mess
 	struct message_header *mhdr;
 	void *cb;
 	void *dsr;
-	int istatus, clines, ret;
+	int han, istatus, clines, ret;
 
 	STAT(mesq_send);
 	BUG_ON(bytes < sizeof(int) || bytes > 2 * GRU_CACHE_LINE_BYTES);
 
 	clines = DIV_ROUND_UP(bytes, GRU_CACHE_LINE_BYTES);
-	if (gru_get_cpu_resources(bytes, &cb, &dsr))
-		return MQE_BUG_NO_RESOURCES;
+	han = gru_get_cpu_resources(-1, bytes, &cb, &dsr);
 	memcpy(dsr, mesg, bytes);
 	mhdr = dsr;
 	mhdr->present = MQS_FULL;
@@ -823,7 +842,7 @@ int gru_send_message_gpa(struct gru_mess
 		if (istatus != CBS_IDLE)
 			ret = send_message_failure(cb, mqd, dsr, clines);
 	} while (ret == MQIE_AGAIN);
-	gru_free_cpu_resources(cb, dsr);
+	gru_free_cpu_resources(han, cb);
 
 	if (ret)
 		STAT(mesq_send_failed);
@@ -906,22 +925,20 @@ int gru_read_gpa(unsigned long *value, u
 {
 	void *cb;
 	void *dsr;
-	int ret, iaa;
+	int han, ret, iaa;
 
 	STAT(read_gpa);
-	if (gru_get_cpu_resources(GRU_NUM_KERNEL_DSR_BYTES, &cb, &dsr))
-		return MQE_BUG_NO_RESOURCES;
+	han = gru_get_cpu_resources(-1, GRU_NUM_KERNEL_DSR_BYTES, &cb, &dsr);
 	iaa = gpa >> 62;
 	gru_vload_phys(cb, gpa, gru_get_tri(dsr), iaa, IMA);
 	ret = gru_wait(cb);
 	if (ret == CBS_IDLE)
 		*value = *(unsigned long *)dsr;
-	gru_free_cpu_resources(cb, dsr);
+	gru_free_cpu_resources(han, cb);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(gru_read_gpa);
 
-
 /*
  * Copy a block of data using the GRU resources
  */
@@ -930,22 +947,20 @@ int gru_copy_gpa(unsigned long dest_gpa,
 {
 	void *cb;
 	void *dsr;
-	int ret;
+	int han, ret;
 
 	STAT(copy_gpa);
-	if (gru_get_cpu_resources(GRU_NUM_KERNEL_DSR_BYTES, &cb, &dsr))
-		return MQE_BUG_NO_RESOURCES;
+	han = gru_get_cpu_resources(-1, GRU_NUM_KERNEL_DSR_BYTES, &cb, &dsr);
 	gru_bcopy(cb, src_gpa, dest_gpa, gru_get_tri(dsr),
-		  XTYPE_B, bytes, GRU_NUM_KERNEL_DSR_CL, IMA);
+		  XTYPE_B, bytes, GRU_CBR_DSR_CL, IMA);
 	ret = gru_wait(cb);
-	gru_free_cpu_resources(cb, dsr);
+	gru_free_cpu_resources(han, cb);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(gru_copy_gpa);
 
 /* ------------------- KERNEL QUICKTESTS RUN AT STARTUP ----------------*/
 /* 	Temp - will delete after we gain confidence in the GRU		*/
-
 static int quicktest0(unsigned long arg)
 {
 	unsigned long word0;
@@ -953,40 +968,39 @@ static int quicktest0(unsigned long arg)
 	void *cb;
 	void *dsr;
 	unsigned long *p;
-	int ret = -EIO;
+	int han, ret = -EIO;
 
-	if (gru_get_cpu_resources(GRU_CACHE_LINE_BYTES, &cb, &dsr))
-		return MQE_BUG_NO_RESOURCES;
+	han = gru_get_cpu_resources(-1, GRU_CACHE_LINE_BYTES, &cb, &dsr);
 	p = dsr;
 	word0 = MAGIC;
 	word1 = 0;
 
 	gru_vload(cb, uv_gpa(&word0), gru_get_tri(dsr), XTYPE_DW, 1, 1, IMA);
 	if (gru_wait(cb) != CBS_IDLE) {
-		printk(KERN_DEBUG "GRU:%d quicktest0: CBR failure 1\n", smp_processor_id());
+		printk(KERN_DEBUG "GRU: %d quicktest0: 0x%p CBR failure 1\n", smp_processor_id(), cb);
 		goto done;
 	}
 
 	if (*p != MAGIC) {
-		printk(KERN_DEBUG "GRU:%d quicktest0 bad magic 0x%lx\n", smp_processor_id(), *p);
+		printk(KERN_DEBUG "GRU: %d quicktest0: 0x%p bad magic 0x%lx\n", smp_processor_id(), cb, *p);
 		goto done;
 	}
 	gru_vstore(cb, uv_gpa(&word1), gru_get_tri(dsr), XTYPE_DW, 1, 1, IMA);
 	if (gru_wait(cb) != CBS_IDLE) {
-		printk(KERN_DEBUG "GRU:%d quicktest0: CBR failure 2\n", smp_processor_id());
+		printk(KERN_DEBUG "GRU: %d quicktest0: 0x%p CBR failure 2\n", smp_processor_id(), cb);
 		goto done;
 	}
 
 	if (word0 != word1 || word1 != MAGIC) {
 		printk(KERN_DEBUG
-		       "GRU:%d quicktest0 err: found 0x%lx, expected 0x%lx\n",
-		     smp_processor_id(), word1, MAGIC);
+		       "GRU: %d quicktest0 err 0x%p: found 0x%lx, expected 0x%lx\n",
+		     smp_processor_id(), cb, word1, MAGIC);
 		goto done;
 	}
 	ret = 0;
 
 done:
-	gru_free_cpu_resources(cb, dsr);
+	gru_free_cpu_resources(han, cb);
 	return ret;
 }
 
@@ -1018,7 +1032,7 @@ static int quicktest1(unsigned long arg)
 			break;
 	}
 	if (ret != MQE_QUEUE_FULL || i != 4) {
-		printk(KERN_DEBUG "GRU:%d quicktest1: unexpect status %d, i %d\n",
+		printk(KERN_DEBUG "GRU: %d quicktest1: unexpect status %d, msg %d\n",
 		       smp_processor_id(), ret, i);
 		goto done;
 	}
@@ -1030,7 +1044,7 @@ static int quicktest1(unsigned long arg)
 		gru_free_message(&mqd, m);
 	}
 	if (i != 4) {
-		printk(KERN_DEBUG "GRU:%d quicktest2: bad message, i %d, m %p, m8 %d\n",
+		printk(KERN_DEBUG "GRU: %d quicktest2: bad message, i %d, m %p, m8 %d\n",
 			smp_processor_id(), i, m, m ? m[8] : -1);
 		goto done;
 	}
@@ -1046,54 +1060,30 @@ static int quicktest2(unsigned long arg)
 	static DECLARE_COMPLETION(cmp);
 	unsigned long han;
 	int blade_id = 0;
-	int numcb = 4;
 	int ret = 0;
 	unsigned long *buf;
-	void *cb0, *cb;
-	struct gru_control_block_status *gen;
-	int i, k, istatus, bytes;
+	void *cb;
+	int bytes;
 
-	bytes = numcb * 4 * 8;
+	bytes = 4 * 8;
 	buf = kmalloc(bytes, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
 	ret = -EBUSY;
-	han = gru_reserve_async_resources(blade_id, numcb, 0, &cmp);
+	han = gru_reserve_async_resources(blade_id, 1, 0, &cmp);
 	if (!han)
 		goto done;
 
-	gru_lock_async_resource(han, &cb0, NULL);
-	memset(buf, 0xee, bytes);
-	for (i = 0; i < numcb; i++)
-		gru_vset(cb0 + i * GRU_HANDLE_STRIDE, uv_gpa(&buf[i * 4]), 0,
-				XTYPE_DW, 4, 1, IMA_INTERRUPT);
-
-	ret = 0;
-	k = numcb;
-	do {
-		gru_wait_async_cbr(han);
-		for (i = 0; i < numcb; i++) {
-			cb = cb0 + i * GRU_HANDLE_STRIDE;
-			istatus = gru_check_status(cb);
-			if (istatus != CBS_ACTIVE && istatus != CBS_CALL_OS)
-				break;
-		}
-		if (i == numcb)
-			continue;
-		if (istatus != CBS_IDLE) {
-			printk(KERN_DEBUG "GRU:%d quicktest2: cb %d, exception\n", smp_processor_id(), i);
-			ret = -EFAULT;
-		} else if (buf[4 * i] || buf[4 * i + 1] || buf[4 * i + 2] ||
-				buf[4 * i + 3]) {
-			printk(KERN_DEBUG "GRU:%d quicktest2:cb %d,  buf 0x%lx, 0x%lx, 0x%lx, 0x%lx\n",
-			       smp_processor_id(), i, buf[4 * i], buf[4 * i + 1], buf[4 * i + 2], buf[4 * i + 3]);
-			ret = -EIO;
-		}
-		k--;
-		gen = cb;
-		gen->istatus = CBS_CALL_OS; /* don't handle this CBR again */
-	} while (k);
+	memset(buf, 0xef, bytes);
+	gru_lock_async_resource(han, &cb, NULL);
+	gru_vset(cb, uv_gpa(buf), 0, XTYPE_DW, 4, 1, IMA_INTERRUPT);
+	gru_wait_async_cbr(han);
+	if (buf[0] || buf[1] || buf[2] || buf[3]) {
+		printk(KERN_DEBUG "GRU: %d quicktest2:cb 0x%p (0x%lx, 0x%lx, 0x%lx 0x%lx)\n",
+		       smp_processor_id(), cb, buf[0], buf[1], buf[2], buf[3]);
+		ret = -EIO;
+	}
 	BUG_ON(cmp.done);
 
 	gru_unlock_async_resource(han);
@@ -1113,7 +1103,7 @@ static int quicktest3(unsigned long arg)
 	memset(buf1, get_cycles() & 255, sizeof(buf1));
 	gru_copy_gpa(uv_gpa(buf2), uv_gpa(buf1), BUFSIZE);
 	if (memcmp(buf1, buf2, BUFSIZE)) {
-		printk(KERN_DEBUG "GRU:%d quicktest3 error\n", smp_processor_id());
+		printk(KERN_DEBUG "GRU: %d quicktest3 error\n", smp_processor_id());
 		ret = -EIO;
 	}
 	return ret;
@@ -1158,4 +1148,3 @@ void gru_kservices_exit(void)
 	if (gru_free_kernel_contexts())
 		BUG();
 }
-
Index: linux/drivers/misc/sgi-gru/gruprocfs.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/gruprocfs.c	2010-07-19 10:23:16.000000000 -0500
+++ linux/drivers/misc/sgi-gru/gruprocfs.c	2010-07-19 10:23:54.870243453 -0500
@@ -52,9 +52,15 @@ static int statistics_show(struct seq_fi
 	printstat(s, assign_context_failed);
 	printstat(s, free_context);
 	printstat(s, load_user_context);
-	printstat(s, load_kernel_context);
-	printstat(s, lock_kernel_context);
-	printstat(s, unlock_kernel_context);
+	printstat(s, load_kcontext);
+	printstat(s, load_kcontext_assign);
+	printstat(s, load_kcontext_steal);
+	printstat(s, lock_kcontext);
+	printstat(s, unlock_kcontext);
+	printstat(s, get_kcontext_cbr);
+	printstat(s, get_kcontext_cbr_busy);
+	printstat(s, lock_async_resource);
+	printstat(s, unlock_async_resource);
 	printstat(s, steal_user_context);
 	printstat(s, steal_kernel_context);
 	printstat(s, steal_context_failed);
Index: linux/drivers/misc/sgi-gru/grutables.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grutables.h	2010-07-19 10:23:21.000000000 -0500
+++ linux/drivers/misc/sgi-gru/grutables.h	2010-07-19 10:25:12.510295762 -0500
@@ -163,6 +163,8 @@ extern unsigned int gru_max_gids;
 #define GRU_DRIVER_ID_STR	"SGI GRU Device Driver"
 #define GRU_DRIVER_VERSION_STR	"0.85"
 
+#define gru_random()    get_cycles()
+
 /*
  * GRU statistics.
  */
@@ -178,9 +180,15 @@ struct gru_stats_s {
 	atomic_long_t assign_context_failed;
 	atomic_long_t free_context;
 	atomic_long_t load_user_context;
-	atomic_long_t load_kernel_context;
-	atomic_long_t lock_kernel_context;
-	atomic_long_t unlock_kernel_context;
+	atomic_long_t load_kcontext;
+	atomic_long_t load_kcontext_assign;
+	atomic_long_t load_kcontext_steal;
+	atomic_long_t lock_kcontext;
+	atomic_long_t unlock_kcontext;
+	atomic_long_t get_kcontext_cbr;
+	atomic_long_t get_kcontext_cbr_busy;
+	atomic_long_t lock_async_resource;
+	atomic_long_t unlock_async_resource;
 	atomic_long_t steal_user_context;
 	atomic_long_t steal_kernel_context;
 	atomic_long_t steal_context_failed;
@@ -443,14 +451,11 @@ struct gru_state {
 							   resources */
 	unsigned long		gs_dsr_map;		/* bitmap used to manage
 							   DATA resources */
-	unsigned int		gs_reserved_cbrs;	/* Number of kernel-
-							   reserved cbrs */
-	unsigned int		gs_reserved_dsr_bytes;	/* Bytes of kernel-
-							   reserved dsrs */
 	unsigned short		gs_active_contexts;	/* number of contexts
 							   in use */
 	struct gru_thread_state	*gs_gts[GRU_NUM_CCH];	/* GTS currently using
 							   the context */
+	struct completion	*gs_async_wq[GRU_NUM_CB];
 	int			gs_irq[GRU_NUM_TFM];	/* Interrupt irqs */
 };
 
@@ -466,8 +471,7 @@ struct gru_blade_state {
 	struct gru_thread_state *bs_kgts;		/* GTS for kernel use */
 
 	/* ---- the following are used for managing kernel async GRU CBRs --- */
-	int			bs_async_dsr_bytes;	/* DSRs for async */
-	int			bs_async_cbrs;		/* CBRs AU for async */
+	void			*bs_async_cbr;		/* CBR for async */
 	struct completion	*bs_async_wq;
 
 	/* ---- the following are protected by the bs_lock spinlock ---- */
@@ -558,11 +562,24 @@ struct gru_blade_state {
 
 /*-----------------------------------------------------------------------------
  * Lock / Unlock GRU handles
- * 	Use the "delresp" bit in the handle as a "lock" bit.
+ * 	Use the "delresp" bit in MCS handles as a "lock" bit.
+ * 	Use the "unmapped" bit in CBRs as a "lock" bit.
+ *
+ *		Return: 0 = lock failed, 1 = locked
  */
 
 /* Lock hierarchy checking enabled only in emulator */
 
+static inline int trylock_cbr_handle(void *h)
+{
+	return !test_and_set_bit(2, h);
+}
+
+static inline void unlock_cbr_handle(void *h)
+{
+	clear_bit(2, h);
+}
+
 /* 0 = lock failed, 1 = locked */
 static inline int __trylock_handle(void *h)
 {
Index: linux/drivers/misc/sgi-gru/grutlbpurge.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grutlbpurge.c	2010-07-19 10:23:15.000000000 -0500
+++ linux/drivers/misc/sgi-gru/grutlbpurge.c	2010-07-19 10:23:54.902272728 -0500
@@ -40,8 +40,6 @@
 #include "grutables.h"
 #include <asm/uv/uv_hub.h>
 
-#define gru_random()	get_cycles()
-
 /* ---------------------------------- TLB Invalidation functions --------
  * get_tgh_handle
  *

