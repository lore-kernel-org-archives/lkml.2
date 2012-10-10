Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074Ab2JJXCA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 19:02:00 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33978 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757164Ab2JJXBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 19:01:43 -0400
X-Sasl-enc: ZzlrJFefGErv/SSQoi/AQ8oBD/VYBA00gnkCRUdIzgeJ 1349910102
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>
Subject: [ 029/122] workqueue: fix possible stall on try_to_grab_pending() of a delayed work item
Date: Thu, 11 Oct 2012 07:53:15 +0900
Message-Id: <20121010225343.373777549@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010225337.989799482@linuxfoundation.org>
References: <20121010225337.989799482@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lai Jiangshan <laijs@cn.fujitsu.com>

commit 3aa62497594430ea522050b75c033f71f2c60ee6 upstream.

Currently, when try_to_grab_pending() grabs a delayed work item, it
leaves its linked work items alone on the delayed_works.  The linked
work items are always NO_COLOR and will cause future
cwq_activate_first_delayed() increase cwq->nr_active incorrectly, and
may cause the whole cwq to stall.  For example,

state: cwq->max_active = 1, cwq->nr_active = 1
       one work in cwq->pool, many in cwq->delayed_works.

step1: try_to_grab_pending() removes a work item from delayed_works
       but leaves its NO_COLOR linked work items on it.

step2: Later on, cwq_activate_first_delayed() activates the linked
       work item increasing ->nr_active.

step3: cwq->nr_active = 1, but all activated work items of the cwq are
       NO_COLOR.  When they finish, cwq->nr_active will not be
       decreased due to NO_COLOR, and no further work items will be
       activated from cwq->delayed_works. the cwq stalls.

Fix it by ensuring the target work item is activated before stealing
PENDING in try_to_grab_pending().  This ensures that all the linked
work items are activated without incorrectly bumping cwq->nr_active.

tj: Updated comment and description.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/workqueue.c |   25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1927,10 +1927,9 @@ static void move_linked_works(struct wor
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
@@ -1938,6 +1937,14 @@ static void cwq_activate_first_delayed(s
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
@@ -2846,6 +2853,18 @@ static int try_to_grab_pending(struct wo
 		smp_rmb();
 		if (gcwq == get_work_gcwq(work)) {
 			debug_work_deactivate(work);
+
+			/*
+			 * A delayed work item cannot be grabbed directly
+			 * because it might have linked NO_COLOR work items
+			 * which, if left on the delayed_list, will confuse
+			 * cwq->nr_active management later on and cause
+			 * stall.  Make sure the work item is activated
+			 * before grabbing.
+			 */
+			if (*work_data_bits(work) & WORK_STRUCT_DELAYED)
+				cwq_activate_delayed_work(work);
+
 			list_del_init(&work->entry);
 			cwq_dec_nr_in_flight(get_work_cwq(work),
 				get_work_color(work),


