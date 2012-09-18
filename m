Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab2IRFzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 01:55:54 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:16733 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754613Ab2IRFzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 01:55:52 -0400
X-IronPort-AV: E=Sophos;i="4.80,441,1344182400"; 
   d="scan'208";a="5862498"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [V2 -stable PATCH 1/2] workqueue: fix leak of active
Date: Tue, 18 Sep 2012 13:57:33 +0800
Message-Id: <1347947862-4533-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/18 13:56:08,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/18 13:56:08,
	Serialize complete at 2012/09/18 13:56:08
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

try_to_grab_pending() leave LINKED tagalong in delayed queue when
it deletes a work. This behavior will cause future
cwq_activate_first_delayed() increase the ->nr_active wrongly,
and may cause the whole cwq frozen.

example:

state: cwq->max_active = 1, cwq->nr_active = 1
       one work in cwq->pool, many in cwq->delayed_works.

step1: try_to_grab_pending() remove a work from delayed_works
       but leave tagalong.
step2: when the work in cwq->pool is finished,
       cwq_activate_first_delayed() move the tagalong to cwq->pool
       and increase the ->nr_active.

current state: cwq->nr_active = 1, but works of the cwq
               in cwq->pool are all NO_COLOR, so even when
               these works are finished, cwq->nr_active will
               not be decreased, and no work will be moved from
               cwq->delayed_works. the whole cwq is frozen.

Fix it by moving the work to cwq->pool before delete it
in try_to_grab_pending(), thus the tagalong is left in
cwq->pool like as grabbing non-delayed work.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   26 +++++++++++++++++++++++---
 1 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 7b91332..834aa62 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -973,10 +973,9 @@ static void move_linked_works(struct work_struct *work, struct list_head *head,
 		*nextp = n;
 }
 
-static void cwq_activate_first_delayed(struct cpu_workqueue_struct *cwq)
+static void cwq_activate_delayed_work(struct work_struct *work)
 {
-	struct work_struct *work = list_first_entry(&cwq->delayed_works,
-						    struct work_struct, entry);
+	struct cpu_workqueue_struct *cwq = get_work_cwq(work);
 
 	trace_workqueue_activate_work(work);
 	move_linked_works(work, &cwq->pool->worklist, NULL);
@@ -984,6 +983,14 @@ static void cwq_activate_first_delayed(struct cpu_workqueue_struct *cwq)
 	cwq->nr_active++;
 }
 
+static void cwq_activate_first_delayed(struct cpu_workqueue_struct *cwq)
+{
+	struct work_struct *work = list_first_entry(&cwq->delayed_works,
+						    struct work_struct, entry);
+
+	cwq_activate_delayed_work(work);
+}
+
 /**
  * cwq_dec_nr_in_flight - decrement cwq's nr_in_flight
  * @cwq: cwq of interest
@@ -1102,6 +1109,19 @@ static int try_to_grab_pending(struct work_struct *work, bool is_dwork,
 		smp_rmb();
 		if (gcwq == get_work_gcwq(work)) {
 			debug_work_deactivate(work);
+
+			/*
+			 * We cannot remove delayed work directly.
+			 * Otherwise we may leave some LINKED
+			 * tagalong(if exist) in the ->delayed_works,
+			 * and future cwq_activate_first_delayed() will
+			 * move this tagalong works((which are all NO_COLOR)
+			 * to cwq->pool and increase the ->nr_active,
+			 * and it may cause the whole cwq frozen.
+			 */
+			if (*work_data_bits(work) & WORK_STRUCT_DELAYED)
+				cwq_activate_delayed_work(work);
+
 			list_del_init(&work->entry);
 			cwq_dec_nr_in_flight(get_work_cwq(work),
 				get_work_color(work),
-- 
1.7.4.4

