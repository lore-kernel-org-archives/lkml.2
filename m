Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab2IQCiF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 22:38:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:46197 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752931Ab2IQCiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 22:38:03 -0400
X-IronPort-AV: E=Sophos;i="4.80,432,1344182400"; 
   d="scan'208";a="5854585"
Message-ID: <50568D85.5030309@cn.fujitsu.com>
Date: Mon, 17 Sep 2012 10:40:05 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] workqueue: fix leak of active
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/17 10:38:20,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/17 10:38:21,
	Serialize complete at 2012/09/17 10:38:21
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

try_to_grab_pending() leave LINKED tagalong in delayed queue when
it deletes a work. This behavior will cause future
cwq_activate_first_delayed() increase the ->nr_active wrongly,
and may cause the whole cwq frozen.

example:

state:	cwq->max_active = 1, cwq->nr_active = 1
	one work in cwq->pool, many in cwq->delayed_works.

step1:	try_to_grab_pending() remove a work from delayed_works but leave tagalong.
step2:	when the work in cwq->pool is finished, cwq_activate_first_delayed()
	move the tagalong to cwq->pool and increase the ->nr_active.

current state: cwq->nr_active = 1, but works of the cwq in cwq->pool are all NO_COLOR,
	so even when these works are finished, cwq->nr_active will not be decreased,
	and no work will be moved from cwq->delayed_works. the cwq is frozen.

Fix it by moving the tagalong to cwq->pool in try_to_grab_pending().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 7b91332..1a268b2 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1101,11 +1101,26 @@ static int try_to_grab_pending(struct work_struct *work, bool is_dwork,
 		 */
 		smp_rmb();
 		if (gcwq == get_work_gcwq(work)) {
+			unsigned long delayed;
+
+			/*
+			 * move LINKED tagalong(if exist) out from
+			 * delayed queue. Otherwise some future
+			 * cwq_activate_first_delayed() may move
+			 * works(which are all NO_COLOR) to cwq->pool
+			 * and increase the ->nr_active. It may
+			 * cause the whole cwq frozen.
+			 */
+			delayed = *work_data_bits(work) & WORK_STRUCT_DELAYED;
+			if (delayed)
+				move_linked_works(work,
+					&get_work_cwq(work)->pool->worklist,
+					NULL);
+
 			debug_work_deactivate(work);
 			list_del_init(&work->entry);
 			cwq_dec_nr_in_flight(get_work_cwq(work),
-				get_work_color(work),
-				*work_data_bits(work) & WORK_STRUCT_DELAYED);
+				get_work_color(work), delayed);
 
 			spin_unlock(&gcwq->lock);
 			return 1;
