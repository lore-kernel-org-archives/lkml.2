Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab2H1Lda (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 07:33:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:6546 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752352Ab2H1Ld2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 07:33:28 -0400
X-IronPort-AV: E=Sophos;i="4.77,842,1336320000"; 
   d="scan'208";a="5740312"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 3/3 V2] workqueue: no pending test for busy_worker.rebind_work
Date: Tue, 28 Aug 2012 19:34:39 +0800
Message-Id: <1346153686-3380-3-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1346153686-3380-1-git-send-email-laijs@cn.fujitsu.com>
References: <1346153686-3380-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/28 19:33:14,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/28 19:33:14,
	Serialize complete at 2012/08/28 19:33:14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rebind_workers() can't return until all workers notify itself,
it means when rebind_workers() returns, all queued busy_worker.rebind_work
have launched, the pending bit is cleared.

When the new rebind_workers() comes, it dozn't need to test the already known
cleared pending bit.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 3e0bd20..eec11c3 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1420,10 +1420,6 @@ static void rebind_workers(struct global_cwq *gcwq)
 	for_each_busy_worker(worker, i, pos, gcwq) {
 		struct work_struct *rebind_work = &worker->rebind_work;
 
-		if (test_and_set_bit(WORK_STRUCT_PENDING_BIT,
-				     work_data_bits(rebind_work)))
-			continue;
-
 		all_cnt++;
 		worker->worker_rebind = &worker_rebind;
 
-- 
1.7.4.4

