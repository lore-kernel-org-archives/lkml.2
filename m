Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631Ab2IZRSn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 13:18:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:10407 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757598Ab2IZRSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 13:18:40 -0400
X-IronPort-AV: E=Sophos;i="4.80,492,1344182400"; 
   d="scan'208";a="5922246"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 03/12] workqueue: remove WORKER_PREP from rescuer
Date: Thu, 27 Sep 2012 01:20:34 +0800
Message-Id: <1348680043-5077-4-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1348680043-5077-1-git-send-email-laijs@cn.fujitsu.com>
References: <1348680043-5077-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/27 01:18:45,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/27 01:18:45,
	Serialize complete at 2012/09/27 01:18:45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no reason to use WORKER_PREP, remove it from rescuer.

And there is no reason to set it so early in alloc_worker(),
move "worker->flags = WORKER_PREP" to start_worker().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index c55884d..e41c562 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1759,8 +1759,6 @@ static struct worker *alloc_worker(void)
 		INIT_LIST_HEAD(&worker->entry);
 		INIT_LIST_HEAD(&worker->scheduled);
 		INIT_WORK(&worker->rebind_work, busy_worker_rebind_fn);
-		/* on creation a worker is in !idle && prep state */
-		worker->flags = WORKER_PREP;
 	}
 	return worker;
 }
@@ -1854,6 +1852,7 @@ fail:
 static void start_worker(struct worker *worker)
 {
 	worker->flags |= WORKER_STARTED;
+	worker->flags |= WORKER_PREP;
 	worker->pool->nr_workers++;
 	worker_enter_idle(worker);
 	wake_up_process(worker->task);
-- 
1.7.7.6

