Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507Ab2IRIpu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 04:45:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64349 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756746Ab2IRIps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 04:45:48 -0400
X-IronPort-AV: E=Sophos;i="4.80,442,1344182400"; 
   d="scan'208";a="5864223"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 2/2] workqueue: Keep activate-order equals to queue_work()-order
Date: Tue, 18 Sep 2012 16:36:53 +0800
Message-Id: <1347957414-6692-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1347957414-6692-1-git-send-email-laijs@cn.fujitsu.com>
References: <1347957414-6692-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/18 16:35:10,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/18 16:35:14,
	Serialize complete at 2012/09/18 16:35:14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The whole workqueue.c keeps activate-order equals to queue_work()-order
in any given cwq except workqueue_set_max_active().

If this order is not kept, something may be not good:

first_work_fn() { release some resource; }
second_work_fn() { wait and request the resource; use resource; }

1. user queues the first work.	# ->max_active is low, is queued on ->delayed_works.
2. someone increases the >max_active via workqueue_set_max_active()
3. user queues the second work.	# queued on cwq->pool.

When the second work is launched to execute, it waits the first work
to release the resource. But the first work is still in ->delayed_works,
it waits the first work to finish and them it can be activated.

It is bad. we fix it by activating the first work in the step 2.

I can't fully determine that it is workqueue's responsibility
or the user's responsibility.
If it is workqueue's responsibility, the patch needs go to -stable.
If it is user's responsibility. it is a nice cleanup, it can go to for-next.
I prefer it is workqueue's responsibility.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index d0ca063..8783414 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3458,7 +3458,7 @@ void workqueue_set_max_active(struct workqueue_struct *wq, int max_active)
 
 		if (!(wq->flags & WQ_FREEZABLE) ||
 		    !(gcwq->flags & GCWQ_FREEZING))
-			get_cwq(gcwq->cpu, wq)->max_active = max_active;
+			cwq_set_max_active(get_cwq(gcwq->cpu, wq), max_active);
 
 		spin_unlock_irq(&gcwq->lock);
 	}
-- 
1.7.4.4

