Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab2H0R5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 13:57:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:6203 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753952Ab2H0R5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 13:57:46 -0400
X-IronPort-AV: E=Sophos;i="4.77,837,1336320000"; 
   d="scan'208";a="5733850"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 5/7] workqueue: ensure the wq_worker_sleeping() see the right flags
Date: Tue, 28 Aug 2012 01:58:25 +0800
Message-Id: <1346090307-3020-6-git-send-email-laijs@cn.fujitsu.com>
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

The compiler may compile this code into TWO write/modify instructions.
		worker->flags &= ~WORKER_UNBOUND;
		worker->flags |= WORKER_REBIND;

so the other CPU may see the temporary of worker->flags which has
not WORKER_UNBOUND nor WORKER_REBIND, it will wrongly do local wake up.

so we use one write/modify instruction explicitly instead.

This bug will not occur on idle workers, because they have another
WORKER_NOT_RUNNING flags.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 96485c0..ed23c9a 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1415,10 +1415,13 @@ static void rebind_workers(struct global_cwq *gcwq)
 	/* rebind busy workers */
 	for_each_busy_worker(worker, i, pos, gcwq) {
 		struct work_struct *rebind_work = &worker->rebind_work;
+		unsigned long worker_flags = worker->flags;
 
 		/* morph UNBOUND to REBIND */
-		worker->flags &= ~WORKER_UNBOUND;
-		worker->flags |= WORKER_REBIND;
+		worker_flags &= ~WORKER_UNBOUND;
+		worker_flags |= WORKER_REBIND;
+		/* ensure the wq_worker_sleeping() see the right flags */
+		ACCESS_ONCE(worker->flags) = worker_flags;
 
 		if (test_and_set_bit(WORK_STRUCT_PENDING_BIT,
 				     work_data_bits(rebind_work)))
-- 
1.7.4.4

