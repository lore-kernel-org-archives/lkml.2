Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab2IXKGY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 06:06:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:40596 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753236Ab2IXKFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 06:05:15 -0400
X-IronPort-AV: E=Sophos;i="4.80,474,1344182400"; 
   d="scan'208";a="5907209"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 04/10] workqueue: use nr_cwqs_to_flush array
Date: Mon, 24 Sep 2012 18:07:06 +0800
Message-Id: <1348481238-6138-5-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1348481238-6138-1-git-send-email-laijs@cn.fujitsu.com>
References: <1348481238-6138-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/24 18:05:27,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/24 18:05:28,
	Serialize complete at 2012/09/24 18:05:28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each color uses its own nr_cwqs_to_flush[color].

This patch doesn't make any functional difference.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 5439fb6..861b4c7 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -250,7 +250,7 @@ struct workqueue_struct {
 	struct mutex		flush_mutex;	/* protects wq flushing */
 	int			work_color;	/* F: current work color */
 	int			flush_color;	/* F: current flush color */
-	atomic_t		nr_cwqs_to_flush; /* flush in progress */
+	atomic_t		nr_cwqs_to_flush[WORK_NR_COLORS];
 	struct wq_flusher	*first_flusher;	/* F: first flusher */
 	struct list_head	flusher_queue;	/* F: flush waiters */
 	struct list_head	flusher_overflow; /* F: flush overflow list */
@@ -1036,7 +1036,7 @@ static void cwq_dec_nr_in_flight(struct cpu_workqueue_struct *cwq, int color)
 	 * If this was the last cwq, wake up the first flusher.  It
 	 * will handle the rest.
 	 */
-	if (atomic_dec_and_test(&cwq->wq->nr_cwqs_to_flush))
+	if (atomic_dec_and_test(&cwq->wq->nr_cwqs_to_flush[color]))
 		complete(&cwq->wq->first_flusher->done);
 }
 
@@ -2540,8 +2540,8 @@ static void insert_wq_barrier(struct cpu_workqueue_struct *cwq,
  * -1.  If no cwq has in-flight commands at the specified color, all
  * cwq->flush_color's stay at -1 and %false is returned.  If any cwq
  * has in flight commands, its cwq->flush_color is set to
- * @flush_color, @wq->nr_cwqs_to_flush is updated accordingly, cwq
- * wakeup logic is armed and %true is returned.
+ * @flush_color, @wq->nr_cwqs_to_flush[flush_color] is updated accordingly,
+ * cwq wakeup logic is armed and %true is returned.
  *
  * The caller should have initialized @wq->first_flusher prior to
  * calling this function with non-negative @flush_color.  If
@@ -2566,8 +2566,8 @@ static bool flush_workqueue_prep_cwqs(struct workqueue_struct *wq,
 	unsigned int cpu;
 
 	if (flush_color >= 0) {
-		BUG_ON(atomic_read(&wq->nr_cwqs_to_flush));
-		atomic_set(&wq->nr_cwqs_to_flush, 1);
+		BUG_ON(atomic_read(&wq->nr_cwqs_to_flush[flush_color]));
+		atomic_set(&wq->nr_cwqs_to_flush[flush_color], 1);
 	}
 
 	for_each_cwq_cpu(cpu, wq) {
@@ -2581,7 +2581,7 @@ static bool flush_workqueue_prep_cwqs(struct workqueue_struct *wq,
 
 			if (cwq->nr_in_flight[flush_color]) {
 				cwq->flush_color = flush_color;
-				atomic_inc(&wq->nr_cwqs_to_flush);
+				atomic_inc(&wq->nr_cwqs_to_flush[flush_color]);
 				wait = true;
 			}
 		}
@@ -2594,7 +2594,8 @@ static bool flush_workqueue_prep_cwqs(struct workqueue_struct *wq,
 		spin_unlock_irq(&gcwq->lock);
 	}
 
-	if (flush_color >= 0 && atomic_dec_and_test(&wq->nr_cwqs_to_flush))
+	if (flush_color >= 0 &&
+	    atomic_dec_and_test(&wq->nr_cwqs_to_flush[flush_color]))
 		complete(&wq->first_flusher->done);
 
 	return wait;
@@ -3211,6 +3212,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 	struct workqueue_struct *wq;
 	unsigned int cpu;
 	size_t namelen;
+	int color;
 
 	/* determine namelen, allocate wq and format name */
 	va_start(args, lock_name);
@@ -3239,7 +3241,8 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 	wq->flags = flags;
 	wq->saved_max_active = max_active;
 	mutex_init(&wq->flush_mutex);
-	atomic_set(&wq->nr_cwqs_to_flush, 0);
+	for (color = 0; color < WORK_NR_COLORS; color++)
+		atomic_set(&wq->nr_cwqs_to_flush[color], 0);
 	INIT_LIST_HEAD(&wq->flusher_queue);
 	INIT_LIST_HEAD(&wq->flusher_overflow);
 
-- 
1.7.4.4

