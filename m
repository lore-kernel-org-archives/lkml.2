Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab2IXKHr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 06:07:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59251 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752778Ab2IXKFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 06:05:14 -0400
X-IronPort-AV: E=Sophos;i="4.80,474,1344182400"; 
   d="scan'208";a="5907208"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 02/10] workqueue: remove unneeded check
Date: Mon, 24 Sep 2012 18:07:04 +0800
Message-Id: <1348481238-6138-3-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1348481238-6138-1-git-send-email-laijs@cn.fujitsu.com>
References: <1348481238-6138-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/24 18:05:27,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/24 18:05:28,
	Serialize complete at 2012/09/24 18:05:28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we always pass flush responsibility to next, we will not deprive it,
now the ->first_flusher can only be changed by the first_flusher, no one
can change it, no race as 4ce48b37 said.

Remove the check introduced by 4ce48b37, use BUG_ON() instead.

Also move "wq->first_flusher = NULL;" later.

This patch doesn't make any functional difference.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 360b7e2..acd9e2f 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2682,12 +2682,7 @@ void flush_workqueue(struct workqueue_struct *wq)
 
 	mutex_lock(&wq->flush_mutex);
 
-	/* we might have raced, check again with mutex held */
-	if (wq->first_flusher != &this_flusher)
-		goto out_unlock;
-
-	wq->first_flusher = NULL;
-
+	BUG_ON(wq->first_flusher != &this_flusher);
 	BUG_ON(!list_empty(&this_flusher.list));
 	BUG_ON(wq->flush_color != this_flusher.flush_color);
 
@@ -2728,6 +2723,7 @@ void flush_workqueue(struct workqueue_struct *wq)
 
 		if (list_empty(&wq->flusher_queue)) {
 			BUG_ON(wq->flush_color != wq->work_color);
+			wq->first_flusher = NULL;
 			break;
 		}
 
-- 
1.7.4.4

