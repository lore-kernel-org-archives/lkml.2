Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227Ab3AIFon (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 00:44:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757167Ab3AIFom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 00:44:42 -0500
Date: Wed, 9 Jan 2013 00:44:38 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Guangliang Zhao <gzhao@suse.com>
cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, lucienchao@gmail.com,
        "Alasdair G. Kergon" <agk@redhat.com>
Subject: [PATCH 2/2] mirror throttling
In-Reply-To: <Pine.LNX.4.64.1301090043270.29917@file.rdu.redhat.com>
Message-ID: <Pine.LNX.4.64.1301090044170.29917@file.rdu.redhat.com>
References: <1357552933-26126-1-git-send-email-gzhao@suse.com>
 <Pine.LNX.4.64.1301090043270.29917@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dm-kcopyd: use throttle

This patch allows the administrator to limit kcopyd rate.

We maintain a history of kcopyd usage in variables io_period and
total_period. The actual kcopyd activity is "(100 * io_period /
total_period)" percent of time. If we exceed user-defined percentage
threshold, we sleep.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-kcopyd.c |  110 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 110 insertions(+)

Index: linux-3.8-rc1-fast/drivers/md/dm-kcopyd.c
===================================================================
--- linux-3.8-rc1-fast.orig/drivers/md/dm-kcopyd.c	2013-01-02 23:23:17.000000000 +0100
+++ linux-3.8-rc1-fast/drivers/md/dm-kcopyd.c	2013-01-02 23:23:25.000000000 +0100
@@ -22,6 +22,7 @@
 #include <linux/vmalloc.h>
 #include <linux/workqueue.h>
 #include <linux/mutex.h>
+#include <linux/delay.h>
 #include <linux/device-mapper.h>
 #include <linux/dm-kcopyd.h>
 
@@ -51,6 +52,8 @@ struct dm_kcopyd_client {
 	struct workqueue_struct *kcopyd_wq;
 	struct work_struct kcopyd_work;
 
+	struct dm_kcopyd_throttle *throttle;
+
 /*
  * We maintain three lists of jobs:
  *
@@ -68,6 +71,108 @@ struct dm_kcopyd_client {
 
 static struct page_list zero_page_list;
 
+static DEFINE_SPINLOCK(throttle_spinlock);
+
+/*
+ * IO/IDLE accounting slowly decays after (1 << ACOUNT_INTERVAL_SHIFT) period.
+ * When total_period >= (1 << ACOUNT_INTERVAL_SHIFT) the counters are divided
+ * by 2.
+ */
+#define ACOUNT_INTERVAL_SHIFT		SHIFT_HZ
+
+/*
+ * Sleep this number of milliseconds.
+ *
+ * It is experimentally found value.
+ * Smaller values cause increased copy rate above the limit. The reason for
+ * this is unknown. A possible explanations could be jiffies rounding errors
+ * or read/write cache inside the disk.
+ */
+#define SLEEP_MSEC			100
+
+/*
+ * Maximum number of sleep events. There is a theoretical livelock if more
+ * kcopyd clients do work simultaneously, this limit allows us to get out of
+ * the livelock.
+ */
+#define MAX_SLEEPS			10
+
+static void io_job_start(struct dm_kcopyd_throttle *t)
+{
+	unsigned throttle, now, difference;
+	int slept, skew;
+
+	if (unlikely(!t))
+		return;
+
+	slept = 0;
+
+try_again:
+	spin_lock_irq(&throttle_spinlock);
+
+	throttle = ACCESS_ONCE(t->throttle);
+
+	if (likely(throttle >= 100))
+		goto skip_limit;
+
+	now = jiffies;
+	difference = now - t->last_jiffies;
+	t->last_jiffies = now;
+	if (t->num_io_jobs)
+		t->io_period += difference;
+	t->total_period += difference;
+
+	if (unlikely(t->total_period >= (1 << ACOUNT_INTERVAL_SHIFT))) {
+		int shift = fls(t->total_period >> ACOUNT_INTERVAL_SHIFT);
+		t->total_period >>= shift;
+		t->io_period >>= shift;
+	}
+
+	skew = t->io_period - throttle * t->total_period / 100;
+	/* skew = t->io_period * 100 / throttle - t->total_period; */
+	if (unlikely(skew > 0) && slept < MAX_SLEEPS) {
+		slept++;
+		spin_unlock_irq(&throttle_spinlock);
+		msleep(SLEEP_MSEC);
+		goto try_again;
+	}
+
+skip_limit:
+	t->num_io_jobs++;
+
+	spin_unlock_irq(&throttle_spinlock);
+}
+
+static void io_job_finish(struct dm_kcopyd_throttle *t)
+{
+	unsigned long flags;
+
+	if (unlikely(!t))
+		return;
+
+	spin_lock_irqsave(&throttle_spinlock, flags);
+
+	t->num_io_jobs--;
+
+	if (likely(ACCESS_ONCE(t->throttle) >= 100))
+		goto skip_limit;
+
+	if (!t->num_io_jobs) {
+		unsigned now, difference;
+
+		now = jiffies;
+		difference = now - t->last_jiffies;
+		t->last_jiffies = now;
+
+		t->io_period += difference;
+		t->total_period += difference;
+	}
+
+skip_limit:
+	spin_unlock_irqrestore(&throttle_spinlock, flags);
+}
+
+
 static void wake(struct dm_kcopyd_client *kc)
 {
 	queue_work(kc->kcopyd_wq, &kc->kcopyd_work);
@@ -348,6 +453,8 @@ static void complete_io(unsigned long er
 	struct kcopyd_job *job = (struct kcopyd_job *) context;
 	struct dm_kcopyd_client *kc = job->kc;
 
+	io_job_finish(kc->throttle);
+
 	if (error) {
 		if (job->rw & WRITE)
 			job->write_err |= error;
@@ -389,6 +496,8 @@ static int run_io_job(struct kcopyd_job 
 		.client = job->kc->io_client,
 	};
 
+	io_job_start(job->kc->throttle);
+
 	if (job->rw == READ)
 		r = dm_io(&io_req, 1, &job->source, NULL);
 	else
@@ -708,6 +817,7 @@ struct dm_kcopyd_client *dm_kcopyd_clien
 	INIT_LIST_HEAD(&kc->complete_jobs);
 	INIT_LIST_HEAD(&kc->io_jobs);
 	INIT_LIST_HEAD(&kc->pages_jobs);
+	kc->throttle = throttle;
 
 	kc->job_pool = mempool_create_slab_pool(MIN_JOBS, _job_cache);
 	if (!kc->job_pool)

