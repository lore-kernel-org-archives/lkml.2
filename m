Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab1IBRCo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 13:02:44 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:30456 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562Ab1IBRCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 13:02:42 -0400
From: Maxim Patlasov <maxim.patlasov@gmail.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2] cfq: queued/in_driver stats
Date: Fri,  2 Sep 2011 21:02:42 +0400
Message-Id: <1314982962-30271-1-git-send-email-maxim.patlasov@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch implements gathering and exporting statistics for cfqd->rq_queued
and cfqd->rq_in_driver. Average values of queued/in_driver are visible via
/sys/.../iosched/queued_avg and /sys/.../iosched/in_driver_avg correspondingly.
The output is in form of "%lu.%02lu %lu.%02lu %lu.%02lu" where the first
value represents average over 1 sec interval, the second - over 5 sec,
the third - over 15 sec.

The patch also exports cfqd->hw_tag to be seen via /sys/.../iosched/hw_tag.

Seeing hw_tag is useful to be sure that cfq detected NCQ correctly on given
h/w. queued/in_driver stats are useful to debug performance problems: e.g.,
if you know that fast h/w raid is able to concurrently process many requests
quite effectively, but at the same time you observe high queued average and
low in_driver one, you can suggest that cfq underloads h/w raid.

Changes since first version: do_div was used wrongly, fixed.

Signed-off-by: Maxim Patlasov <maxim.patlasov@gmail.com>
---
 block/cfq-iosched.c |  114 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 114 insertions(+), 0 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 1f96ad6..869d9d2 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -14,6 +14,7 @@
 #include <linux/rbtree.h>
 #include <linux/ioprio.h>
 #include <linux/blktrace_api.h>
+#include <linux/sched.h>
 #include "cfq.h"
 
 /*
@@ -303,8 +304,37 @@ struct cfq_data {
 
 	/* Number of groups which are on blkcg->blkg_list */
 	unsigned int nr_blkcg_linked_grps;
+
+	/* average */
+	unsigned long cfq_avg_queued[3];
+	unsigned long cfq_avg_indriver[3];
+
+	/* when (in jiffies) to update averages next time */
+	unsigned long cfq_calc_load_update;
+
+	/* last values seen */
+	int cfq_queued_last;
+	int cfq_indriver_last;
+};
+
+#define EXP_ARR_SIZ 12
+/*
+ * EXP_ARR[i][j] == ((EXP_I / FIXED_1) ^ (2^j)) * FIXED_1
+ * where I == 1 for i=0, I == 5 for i=1, I == 15 for i=2
+ */
+const u16 EXP_ARR[3][EXP_ARR_SIZ] = {
+	{ EXP_1, 1733, 1466, 1050, 539, 142, 10 },
+	{ EXP_5, 1981, 1915, 1791, 1567, 1199, 701, 240, 28 },
+	{ EXP_15, 2026, 2004, 1962, 1879, 1723, 1451, 1028, 516, 130, 8 }
 };
 
+/*
+ * update averages every 5sec/60
+ */
+#define CFQD_LOAD_FREQ max(LOAD_FREQ / 60, 1)
+
+static void cfq_update_stats(struct cfq_data *cfqd, int indrv_delta);
+
 static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd);
 
 static struct cfq_rb_root *service_tree_for(struct cfq_group *cfqg,
@@ -1574,6 +1604,7 @@ static void cfq_activate_request(struct request_queue *q, struct request *rq)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
 
+	cfq_update_stats(cfqd, 1);
 	cfqd->rq_in_driver++;
 	cfq_log_cfqq(cfqd, RQ_CFQQ(rq), "activate rq, drv=%d",
 						cfqd->rq_in_driver);
@@ -1586,6 +1617,7 @@ static void cfq_deactivate_request(struct request_queue *q, struct request *rq)
 	struct cfq_data *cfqd = q->elevator->elevator_data;
 
 	WARN_ON(!cfqd->rq_in_driver);
+	cfq_update_stats(cfqd, -1);
 	cfqd->rq_in_driver--;
 	cfq_log_cfqq(cfqd, RQ_CFQQ(rq), "deactivate rq, drv=%d",
 						cfqd->rq_in_driver);
@@ -3553,6 +3585,44 @@ static bool cfq_should_wait_busy(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	return false;
 }
 
+static void
+avg_calc_load(struct cfq_data *cfqd, int exp_idx,
+	      unsigned long queued, unsigned long indriver)
+{
+	queued <<= FSHIFT;
+	indriver <<= FSHIFT;
+
+	CALC_LOAD(cfqd->cfq_avg_queued[0], EXP_ARR[0][exp_idx], queued);
+	CALC_LOAD(cfqd->cfq_avg_queued[1], EXP_ARR[1][exp_idx], queued);
+	CALC_LOAD(cfqd->cfq_avg_queued[2], EXP_ARR[2][exp_idx], queued);
+
+	CALC_LOAD(cfqd->cfq_avg_indriver[0], EXP_ARR[0][exp_idx], indriver);
+	CALC_LOAD(cfqd->cfq_avg_indriver[1], EXP_ARR[1][exp_idx], indriver);
+	CALC_LOAD(cfqd->cfq_avg_indriver[2], EXP_ARR[2][exp_idx], indriver);
+}
+
+static void cfq_update_stats(struct cfq_data *cfqd, int indrv_delta)
+{
+	unsigned long now = jiffies;
+
+	if (time_before(now, cfqd->cfq_calc_load_update))
+		goto done;
+
+	if (now - cfqd->cfq_calc_load_update >= CFQD_LOAD_FREQ) {
+		int idx = clamp(fls((now - cfqd->cfq_calc_load_update)
+					/ CFQD_LOAD_FREQ)-1, 0, EXP_ARR_SIZ-1);
+		avg_calc_load(cfqd, idx, cfqd->cfq_queued_last,
+			      cfqd->cfq_indriver_last);
+	}
+
+	avg_calc_load(cfqd, 0, cfqd->rq_queued, cfqd->rq_in_driver);
+
+	cfqd->cfq_calc_load_update = now + CFQD_LOAD_FREQ;
+done:
+	cfqd->cfq_queued_last = cfqd->rq_queued;
+	cfqd->cfq_indriver_last = cfqd->rq_in_driver + indrv_delta;
+}
+
 static void cfq_completed_request(struct request_queue *q, struct request *rq)
 {
 	struct cfq_queue *cfqq = RQ_CFQQ(rq);
@@ -3565,6 +3635,7 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 		     !!(rq->cmd_flags & REQ_NOIDLE));
 
 	cfq_update_hw_tag(cfqd);
+	cfq_update_stats(cfqd, -1);
 
 	WARN_ON(!cfqd->rq_in_driver);
 	WARN_ON(!cfqq->dispatched);
@@ -4113,6 +4184,21 @@ cfq_var_show(unsigned int var, char *page)
 	return sprintf(page, "%d\n", var);
 }
 
+#define LOAD_INT(x) ((x) >> FSHIFT)
+#define LOAD_FRAC(x) LOAD_INT(((x) & (FIXED_1-1)) * 100)
+
+static ssize_t
+cfq_var_avg_show(unsigned long *var, char *page)
+{
+	unsigned long avg1 = var[0] + FIXED_1/200;
+	unsigned long avg2 = var[1] + FIXED_1/200;
+	unsigned long avg3 = var[2] + FIXED_1/200;
+	return sprintf(page, "%lu.%02lu %lu.%02lu %lu.%02lu\n",
+		       LOAD_INT(avg1), LOAD_FRAC(avg1),
+		       LOAD_INT(avg2), LOAD_FRAC(avg2),
+		       LOAD_INT(avg3), LOAD_FRAC(avg3));
+}
+
 static ssize_t
 cfq_var_store(unsigned int *var, const char *page, size_t count)
 {
@@ -4131,6 +4217,17 @@ static ssize_t __FUNC(struct elevator_queue *e, char *page)		\
 		__data = jiffies_to_msecs(__data);			\
 	return cfq_var_show(__data, (page));				\
 }
+
+#define SHOW_FUNCTION_AVG(__FUNC, __VAR)				\
+static ssize_t __FUNC(struct elevator_queue *e, char *page)		\
+{									\
+	struct cfq_data *cfqd = e->elevator_data;			\
+	unsigned long *__data = __VAR;					\
+	spin_lock_irq(cfqd->queue->queue_lock);				\
+	cfq_update_stats(cfqd, 0);					\
+	spin_unlock_irq(cfqd->queue->queue_lock);			\
+	return cfq_var_avg_show(__data, (page));			\
+}
 SHOW_FUNCTION(cfq_quantum_show, cfqd->cfq_quantum, 0);
 SHOW_FUNCTION(cfq_fifo_expire_sync_show, cfqd->cfq_fifo_expire[1], 1);
 SHOW_FUNCTION(cfq_fifo_expire_async_show, cfqd->cfq_fifo_expire[0], 1);
@@ -4142,6 +4239,9 @@ SHOW_FUNCTION(cfq_slice_sync_show, cfqd->cfq_slice[1], 1);
 SHOW_FUNCTION(cfq_slice_async_show, cfqd->cfq_slice[0], 1);
 SHOW_FUNCTION(cfq_slice_async_rq_show, cfqd->cfq_slice_async_rq, 0);
 SHOW_FUNCTION(cfq_low_latency_show, cfqd->cfq_latency, 0);
+SHOW_FUNCTION_AVG(cfq_queued_avg_show, cfqd->cfq_avg_queued);
+SHOW_FUNCTION_AVG(cfq_in_driver_avg_show, cfqd->cfq_avg_indriver);
+SHOW_FUNCTION(cfq_hw_tag_show, cfqd->hw_tag, 0);
 #undef SHOW_FUNCTION
 
 #define STORE_FUNCTION(__FUNC, __PTR, MIN, MAX, __CONV)			\
@@ -4160,6 +4260,14 @@ static ssize_t __FUNC(struct elevator_queue *e, const char *page, size_t count)
 		*(__PTR) = __data;					\
 	return ret;							\
 }
+
+#define STORE_FUNCTION_AVG(__FUNC, __PTR)				\
+static ssize_t __FUNC(struct elevator_queue *e, const char *p, size_t count)  \
+{									\
+	struct cfq_data *cfqd = e->elevator_data;			\
+	__PTR[0] = __PTR[1] = __PTR[2] = 0;				\
+	return count;							\
+}
 STORE_FUNCTION(cfq_quantum_store, &cfqd->cfq_quantum, 1, UINT_MAX, 0);
 STORE_FUNCTION(cfq_fifo_expire_sync_store, &cfqd->cfq_fifo_expire[1], 1,
 		UINT_MAX, 1);
@@ -4175,6 +4283,9 @@ STORE_FUNCTION(cfq_slice_async_store, &cfqd->cfq_slice[0], 1, UINT_MAX, 1);
 STORE_FUNCTION(cfq_slice_async_rq_store, &cfqd->cfq_slice_async_rq, 1,
 		UINT_MAX, 0);
 STORE_FUNCTION(cfq_low_latency_store, &cfqd->cfq_latency, 0, 1, 0);
+STORE_FUNCTION_AVG(cfq_queued_avg_store, cfqd->cfq_avg_queued);
+STORE_FUNCTION_AVG(cfq_in_driver_avg_store, cfqd->cfq_avg_indriver);
+STORE_FUNCTION(cfq_hw_tag_store, &cfqd->hw_tag, 0, UINT_MAX, 0);
 #undef STORE_FUNCTION
 
 #define CFQ_ATTR(name) \
@@ -4192,6 +4303,9 @@ static struct elv_fs_entry cfq_attrs[] = {
 	CFQ_ATTR(slice_idle),
 	CFQ_ATTR(group_idle),
 	CFQ_ATTR(low_latency),
+	CFQ_ATTR(queued_avg),
+	CFQ_ATTR(in_driver_avg),
+	CFQ_ATTR(hw_tag),
 	__ATTR_NULL
 };
 
-- 
1.7.4.4

