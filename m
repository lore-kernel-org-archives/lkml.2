Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab2IXKFP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 06:05:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59251 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751181Ab2IXKFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 06:05:13 -0400
X-IronPort-AV: E=Sophos;i="4.80,474,1344182400"; 
   d="scan'208";a="5907206"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 01/10] workqueue: always pass flush responsibility to next
Date: Mon, 24 Sep 2012 18:07:03 +0800
Message-Id: <1348481238-6138-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1348481238-6138-1-git-send-email-laijs@cn.fujitsu.com>
References: <1348481238-6138-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/24 18:05:27,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/24 18:05:27,
	Serialize complete at 2012/09/24 18:05:27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

depriving the responsibility make the code complex, we pass it to the next
unconditionally.

After this change, we don't need to go back to repeat cascading, so we use
"break" to exit the loop.

The loop will be remove in later patch.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index a59171a..360b7e2 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2740,15 +2740,8 @@ void flush_workqueue(struct workqueue_struct *wq)
 
 		list_del_init(&next->list);
 		wq->first_flusher = next;
-
-		if (flush_workqueue_prep_cwqs(wq, wq->flush_color, -1))
-			break;
-
-		/*
-		 * Meh... this color is already done, clear first
-		 * flusher and repeat cascading.
-		 */
-		wq->first_flusher = NULL;
+		flush_workqueue_prep_cwqs(wq, wq->flush_color, -1);
+		break;
 	}
 
 out_unlock:
-- 
1.7.4.4

