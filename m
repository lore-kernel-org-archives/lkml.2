Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab2IHRLj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 13:11:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:36187 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751365Ab2IHRLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 13:11:18 -0400
X-IronPort-AV: E=Sophos;i="4.80,392,1344182400"; 
   d="scan'208";a="5807474"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 1/7 V6] workqueue: ensure the wq_worker_sleeping() see the right flags
Date: Sun, 9 Sep 2012 01:12:50 +0800
Message-Id: <1347124383-18723-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1347124383-18723-1-git-send-email-laijs@cn.fujitsu.com>
References: <1347124383-18723-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/09 01:10:47,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/09 01:10:48,
	Serialize complete at 2012/09/09 01:10:48
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
index 85bd340..050b2a5 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1739,10 +1739,13 @@ retry:
 	for_each_busy_worker(worker, i, pos, gcwq) {
 		struct work_struct *rebind_work = &worker->rebind_work;
 		struct workqueue_struct *wq;
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

