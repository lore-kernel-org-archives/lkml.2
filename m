Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab2A3HH3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 02:07:29 -0500
Received: from mga01.intel.com ([192.55.52.88]:9011 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885Ab2A3HHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 02:07:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="111945064"
Message-Id: <20120130070634.747025323@sli10-conroe.sh.intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 30 Jan 2012 15:02:17 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, vgoyal@redhat.com, david@fromorbit.com,
        jack@suse.cz, zhu.yanhai@gmail.com, namhyung.kim@lge.com,
        shaohua.li@intel.com
Subject: [patch v2 4/8]block: fiops add ioprio support
References: <20120130070213.793690895@sli10-conroe.sh.intel.com>
Content-Disposition: inline; filename=fiops-priority-support.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add CFQ-like ioprio support. Priority A will get 20% more share than priority
A+1, which matches CFQ.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 block/fiops-iosched.c |  103 ++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 92 insertions(+), 11 deletions(-)

Index: linux/block/fiops-iosched.c
===================================================================
--- linux.orig/block/fiops-iosched.c	2012-01-18 14:42:18.000000000 +0800
+++ linux/block/fiops-iosched.c	2012-01-18 14:43:51.000000000 +0800
@@ -20,6 +20,8 @@
 #define VIOS_SYNC_SCALE (2)
 #define VIOS_ASYNC_SCALE (5)
 
+#define VIOS_PRIO_SCALE (5)
+
 struct fiops_rb_root {
 	struct rb_root rb;
 	struct rb_node *left;
@@ -29,10 +31,17 @@ struct fiops_rb_root {
 };
 #define FIOPS_RB_ROOT	(struct fiops_rb_root) { .rb = RB_ROOT}
 
+enum wl_prio_t {
+	IDLE_WORKLOAD = 0,
+	BE_WORKLOAD = 1,
+	RT_WORKLOAD = 2,
+	FIOPS_PRIO_NR,
+};
+
 struct fiops_data {
 	struct request_queue *queue;
 
-	struct fiops_rb_root service_tree;
+	struct fiops_rb_root service_tree[FIOPS_PRIO_NR];
 
 	unsigned int busy_queues;
 	unsigned int in_flight[2];
@@ -60,13 +69,16 @@ struct fiops_ioc {
 	struct list_head fifo;
 
 	pid_t pid;
+	unsigned short ioprio;
+	enum wl_prio_t wl_type;
 };
 
-#define ioc_service_tree(ioc) (&((ioc)->fiopsd->service_tree))
+#define ioc_service_tree(ioc) (&((ioc)->fiopsd->service_tree[(ioc)->wl_type]))
 #define RQ_CIC(rq)		icq_to_cic((rq)->elv.icq)
 
 enum ioc_state_flags {
 	FIOPS_IOC_FLAG_on_rr = 0,	/* on round-robin busy list */
+	FIOPS_IOC_FLAG_prio_changed,	/* task priority has changed */
 };
 
 #define FIOPS_IOC_FNS(name)						\
@@ -84,8 +96,18 @@ static inline int fiops_ioc_##name(const
 }
 
 FIOPS_IOC_FNS(on_rr);
+FIOPS_IOC_FNS(prio_changed);
 #undef FIOPS_IOC_FNS
 
+enum wl_prio_t fiops_wl_type(short prio_class)
+{
+	if (prio_class == IOPRIO_CLASS_RT)
+		return RT_WORKLOAD;
+	if (prio_class == IOPRIO_CLASS_BE)
+		return BE_WORKLOAD;
+	return IDLE_WORKLOAD;
+}
+
 static inline struct fiops_ioc *icq_to_cic(struct io_cq *icq)
 {
 	/* cic->icq is the first member, %NULL will convert to %NULL */
@@ -298,6 +320,8 @@ static u64 fiops_scaled_vios(struct fiop
 	if (!rq_is_sync(rq))
 		vios = vios * fiopsd->async_scale / fiopsd->sync_scale;
 
+	vios +=  vios * (ioc->ioprio - IOPRIO_NORM) / VIOS_PRIO_SCALE;
+
 	return vios;
 }
 
@@ -323,14 +347,19 @@ static int fiops_forced_dispatch(struct
 {
 	struct fiops_ioc *ioc;
 	int dispatched = 0;
+	int i;
 
-	while ((ioc = fiops_rb_first(&fiopsd->service_tree)) != NULL) {
-		while (!list_empty(&ioc->fifo)) {
-			fiops_dispatch_request(fiopsd, ioc);
-			dispatched++;
+	for (i = RT_WORKLOAD; i >= IDLE_WORKLOAD; i--) {
+		while (!RB_EMPTY_ROOT(&fiopsd->service_tree[i].rb)) {
+			ioc = fiops_rb_first(&fiopsd->service_tree[i]);
+
+			while (!list_empty(&ioc->fifo)) {
+				fiops_dispatch_request(fiopsd, ioc);
+				dispatched++;
+			}
+			if (fiops_ioc_on_rr(ioc))
+				fiops_del_ioc_rr(fiopsd, ioc);
 		}
-		if (fiops_ioc_on_rr(ioc))
-			fiops_del_ioc_rr(fiopsd, ioc);
 	}
 	return dispatched;
 }
@@ -338,10 +367,20 @@ static int fiops_forced_dispatch(struct
 static struct fiops_ioc *fiops_select_ioc(struct fiops_data *fiopsd)
 {
 	struct fiops_ioc *ioc;
+	struct fiops_rb_root *service_tree = NULL;
+	int i;
+
+	for (i = RT_WORKLOAD; i >= IDLE_WORKLOAD; i--) {
+		if (!RB_EMPTY_ROOT(&fiopsd->service_tree[i].rb)) {
+			service_tree = &fiopsd->service_tree[i];
+			break;
+		}
+	}
 
-	if (RB_EMPTY_ROOT(&fiopsd->service_tree.rb))
+	if (!service_tree)
 		return NULL;
-	ioc = fiops_rb_first(&fiopsd->service_tree);
+
+	ioc = fiops_rb_first(service_tree);
 	return ioc;
 }
 
@@ -378,10 +417,49 @@ static int fiops_dispatch_requests(struc
 	return 1;
 }
 
+static void fiops_init_prio_data(struct fiops_ioc *cic)
+{
+	struct task_struct *tsk = current;
+	struct io_context *ioc = cic->icq.ioc;
+	int ioprio_class;
+
+	if (!fiops_ioc_prio_changed(cic))
+		return;
+
+	ioprio_class = IOPRIO_PRIO_CLASS(ioc->ioprio);
+	switch (ioprio_class) {
+	default:
+		printk(KERN_ERR "fiops: bad prio %x\n", ioprio_class);
+	case IOPRIO_CLASS_NONE:
+		/*
+		 * no prio set, inherit CPU scheduling settings
+		 */
+		cic->ioprio = task_nice_ioprio(tsk);
+		cic->wl_type = fiops_wl_type(task_nice_ioclass(tsk));
+		break;
+	case IOPRIO_CLASS_RT:
+		cic->ioprio = task_ioprio(ioc);
+		cic->wl_type = fiops_wl_type(IOPRIO_CLASS_RT);
+		break;
+	case IOPRIO_CLASS_BE:
+		cic->ioprio = task_ioprio(ioc);
+		cic->wl_type = fiops_wl_type(IOPRIO_CLASS_BE);
+		break;
+	case IOPRIO_CLASS_IDLE:
+		cic->wl_type = fiops_wl_type(IOPRIO_CLASS_IDLE);
+		cic->ioprio = 7;
+		break;
+	}
+
+	fiops_clear_ioc_prio_changed(cic);
+}
+
 static void fiops_insert_request(struct request_queue *q, struct request *rq)
 {
 	struct fiops_ioc *ioc = RQ_CIC(rq);
 
+	fiops_init_prio_data(ioc);
+
 	list_add_tail(&rq->queuelist, &ioc->fifo);
 
 	fiops_add_rq_rb(rq);
@@ -507,6 +585,7 @@ static void fiops_kick_queue(struct work
 static void *fiops_init_queue(struct request_queue *q)
 {
 	struct fiops_data *fiopsd;
+	int i;
 
 	fiopsd = kzalloc_node(sizeof(*fiopsd), GFP_KERNEL, q->node);
 	if (!fiopsd)
@@ -514,7 +593,8 @@ static void *fiops_init_queue(struct req
 
 	fiopsd->queue = q;
 
-	fiopsd->service_tree = FIOPS_RB_ROOT;
+	for (i = IDLE_WORKLOAD; i <= RT_WORKLOAD; i++)
+		fiopsd->service_tree[i] = FIOPS_RB_ROOT;
 
 	INIT_WORK(&fiopsd->unplug_work, fiops_kick_queue);
 
@@ -538,6 +618,7 @@ static void fiops_init_icq(struct io_cq
 	ioc->fiopsd = fiopsd;
 
 	ioc->pid = current->pid;
+	fiops_mark_ioc_prio_changed(ioc);
 }
 
 /*

