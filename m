Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab2H0R6o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 13:58:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:17857 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754023Ab2H0R5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 13:57:46 -0400
X-IronPort-AV: E=Sophos;i="4.77,837,1336320000"; 
   d="scan'208";a="5733851"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 6/7] workqueue: init 0 for idle_rebind.cnt
Date: Tue, 28 Aug 2012 01:58:26 +0800
Message-Id: <1346090307-3020-7-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1346090307-3020-1-git-send-email-laijs@cn.fujitsu.com>
References: <1346090307-3020-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/28 01:57:34,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/28 01:57:34,
	Serialize complete at 2012/08/28 01:57:34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Access idle_rebind.cnt is always protected by gcwq->lock,
don't need to init it as 1.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index ed23c9a..9f38a65 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1394,7 +1394,7 @@ static void rebind_workers(struct global_cwq *gcwq)
 	 * us to finish up by competing on pool->manager_mutex.
 	 */
 	init_completion(&idle_rebind.done);
-	idle_rebind.cnt = 1;
+	idle_rebind.cnt = 0;
 	INIT_COMPLETION(idle_rebind.done);
 
 	/* set REBIND and kick idle ones, we'll wait for these later */
@@ -1435,7 +1435,7 @@ static void rebind_workers(struct global_cwq *gcwq)
 	}
 
 	/* waiting for all idle workers to be rebound */
-	if (--idle_rebind.cnt) {
+	if (idle_rebind.cnt) {
 		spin_unlock_irq(&gcwq->lock);
 		wait_for_completion(&idle_rebind.done);
 		spin_lock_irq(&gcwq->lock);
-- 
1.7.4.4

