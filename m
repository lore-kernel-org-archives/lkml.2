Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476Ab2IRFz4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 01:55:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:16733 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755417Ab2IRFzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 01:55:54 -0400
X-IronPort-AV: E=Sophos;i="4.80,441,1344182400"; 
   d="scan'208";a="5862499"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [V2 for-next PATCH 2/2] workqueue: remove @delayed argument from cwq_dec_nr_in_flight()
Date: Tue, 18 Sep 2012 13:57:34 +0800
Message-Id: <1347947862-4533-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1347947862-4533-1-git-send-email-laijs@cn.fujitsu.com>
References: <1347947862-4533-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/18 13:56:08,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/18 13:56:09,
	Serialize complete at 2012/09/18 13:56:09
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The argument @delayed is always false in all call site,
we simply remove it.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   21 ++++++++-------------
 1 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 834aa62..d15d383 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -995,7 +995,6 @@ static void cwq_activate_first_delayed(struct cpu_workqueue_struct *cwq)
  * cwq_dec_nr_in_flight - decrement cwq's nr_in_flight
  * @cwq: cwq of interest
  * @color: color of work which left the queue
- * @delayed: for a delayed work
  *
  * A work either has completed or is removed from pending queue,
  * decrement nr_in_flight of its cwq and handle workqueue flushing.
@@ -1003,8 +1002,7 @@ static void cwq_activate_first_delayed(struct cpu_workqueue_struct *cwq)
  * CONTEXT:
  * spin_lock_irq(gcwq->lock).
  */
-static void cwq_dec_nr_in_flight(struct cpu_workqueue_struct *cwq, int color,
-				 bool delayed)
+static void cwq_dec_nr_in_flight(struct cpu_workqueue_struct *cwq, int color)
 {
 	/* ignore uncolored works */
 	if (color == WORK_NO_COLOR)
@@ -1012,13 +1010,11 @@ static void cwq_dec_nr_in_flight(struct cpu_workqueue_struct *cwq, int color,
 
 	cwq->nr_in_flight[color]--;
 
-	if (!delayed) {
-		cwq->nr_active--;
-		if (!list_empty(&cwq->delayed_works)) {
-			/* one down, submit a delayed one */
-			if (cwq->nr_active < cwq->max_active)
-				cwq_activate_first_delayed(cwq);
-		}
+	cwq->nr_active--;
+	if (!list_empty(&cwq->delayed_works)) {
+		/* one down, submit a delayed one */
+		if (cwq->nr_active < cwq->max_active)
+			cwq_activate_first_delayed(cwq);
 	}
 
 	/* is flush in progress and are we at the flushing tip? */
@@ -1124,8 +1120,7 @@ static int try_to_grab_pending(struct work_struct *work, bool is_dwork,
 
 			list_del_init(&work->entry);
 			cwq_dec_nr_in_flight(get_work_cwq(work),
-				get_work_color(work),
-				*work_data_bits(work) & WORK_STRUCT_DELAYED);
+				get_work_color(work));
 
 			spin_unlock(&gcwq->lock);
 			return 1;
@@ -2336,7 +2331,7 @@ __acquires(&gcwq->lock)
 	hlist_del_init(&worker->hentry);
 	worker->current_work = NULL;
 	worker->current_cwq = NULL;
-	cwq_dec_nr_in_flight(cwq, work_color, false);
+	cwq_dec_nr_in_flight(cwq, work_color);
 }
 
 /**
-- 
1.7.4.4

