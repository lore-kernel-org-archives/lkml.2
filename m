Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606Ab2H1Ld3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 07:33:29 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49681 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751557Ab2H1Ld2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 07:33:28 -0400
X-IronPort-AV: E=Sophos;i="4.77,842,1336320000"; 
   d="scan'208";a="5740311"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 2/3 V2] workqueue: ensure the wq_worker_sleeping() see the right flags
Date: Tue, 28 Aug 2012 19:34:38 +0800
Message-Id: <1346153686-3380-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1346153686-3380-1-git-send-email-laijs@cn.fujitsu.com>
References: <1346153686-3380-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/28 19:33:13,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/28 19:33:14,
	Serialize complete at 2012/08/28 19:33:14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The compiler may compile this code into TWO write/modify instructions.
		worker->flags &= ~WORKER_UNBOUND;
		worker->flags |= WORKER_REBIND;

so the other CPU may see the temporary of worker->flags which has
not WORKER_UNBOUND nor WORKER_REBIND, it will wrongly do local wake up.

So we simply change the code that WORKER_UNBOUND is cleared in
busy_worker_rebind_fn(), not in rebind_workers(). And REBIND is not
used for busy_worker, busy_worker_rebind_fn() knows itself need
to do rebind when it is called.

Because the rebind_workers() will wait busy_worker_rebind_fn() to
finish rebinding and clearing, the CPU can't be offline,
busy_worker_rebind_fn() will not clear the wrong WORKER_UNBOUND.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 5f63883..3e0bd20 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1354,7 +1354,7 @@ static void busy_worker_rebind_fn(struct work_struct *work)
 
 	/* CPU must be online at this point */
 	WARN_ON(!worker_maybe_bind_and_lock(worker));
-	worker_clr_flags(worker, WORKER_REBIND);
+	worker_clr_flags(worker, WORKER_UNBOUND);
 	spin_unlock_irq(&gcwq->lock);
 
 	/* all_cnt is only accessed by the bound CPU, don't need any lock */
@@ -1420,10 +1420,6 @@ static void rebind_workers(struct global_cwq *gcwq)
 	for_each_busy_worker(worker, i, pos, gcwq) {
 		struct work_struct *rebind_work = &worker->rebind_work;
 
-		/* morph UNBOUND to REBIND */
-		worker->flags &= ~WORKER_UNBOUND;
-		worker->flags |= WORKER_REBIND;
-
 		if (test_and_set_bit(WORK_STRUCT_PENDING_BIT,
 				     work_data_bits(rebind_work)))
 			continue;
-- 
1.7.4.4

