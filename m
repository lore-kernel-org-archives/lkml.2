Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761465Ab0HMKWt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 06:22:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761431Ab0HMKWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 06:22:48 -0400
From: Xiaotian Feng <dfeng@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Xiaotian Feng <dfeng@redhat.com>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH] workqueue: free rescuer on destroy_workqueue
Date: Fri, 13 Aug 2010 18:22:19 +0800
Message-Id: <1281694939-4163-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wq->rescuer is not freed when wq is destroyed, leads a memory leak
then. This patch also remove a redundant line.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 kernel/workqueue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 2994a0e..1001b6e 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2782,7 +2782,6 @@ struct workqueue_struct *__alloc_workqueue_key(const char *name,
 		if (IS_ERR(rescuer->task))
 			goto err;
 
-		wq->rescuer = rescuer;
 		rescuer->task->flags |= PF_THREAD_BOUND;
 		wake_up_process(rescuer->task);
 	}
@@ -2848,6 +2847,7 @@ void destroy_workqueue(struct workqueue_struct *wq)
 	if (wq->flags & WQ_RESCUER) {
 		kthread_stop(wq->rescuer->task);
 		free_mayday_mask(wq->mayday_mask);
+		kfree(wq->rescuer);
 	}
 
 	free_cwqs(wq);
-- 
1.7.2.1

