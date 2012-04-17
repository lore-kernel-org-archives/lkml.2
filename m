Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299Ab2DQPsF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 11:48:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756167Ab2DQPqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 11:46:35 -0400
From: Doug Ledford <dledford@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, kosaki.motohiro@gmail.com,
        Doug Ledford <dledford@redhat.com>
Subject: [Patch 3/8] ipc/mqueue: enforce hard limits
Date: Tue, 17 Apr 2012 11:46:20 -0400
Message-Id: <583c60bf335068e68b9d84a07a2355b9da11f911.1334676645.git.dledford@redhat.com>
In-Reply-To: <cover.1334676645.git.dledford@redhat.com>
References: <cover.1334676645.git.dledford@redhat.com>
In-Reply-To: <cover.1334676645.git.dledford@redhat.com>
References: <cover.1334676645.git.dledford@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In two places we don't enforce the hard limits for
CAP_SYS_RESOURCE apps.  In preparation for making more
reasonable hard limits, start enforcing them even on
CAP_SYS_RESOURCE.

Signed-off-by: Doug Ledford <dledford@redhat.com>
---
 ipc/mqueue.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index b178268..8f75d84 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -299,8 +299,9 @@ static int mqueue_create(struct inode *dir, struct dentry *dentry,
 		error = -EACCES;
 		goto out_unlock;
 	}
-	if (ipc_ns->mq_queues_count >= ipc_ns->mq_queues_max &&
-			!capable(CAP_SYS_RESOURCE)) {
+	if (ipc_ns->mq_queues_count >= HARD_QUEUESMAX ||
+	    (ipc_ns->mq_queues_count >= ipc_ns->mq_queues_max &&
+	     !capable(CAP_SYS_RESOURCE))) {
 		error = -ENOSPC;
 		goto out_unlock;
 	}
@@ -584,7 +585,8 @@ static int mq_attr_ok(struct ipc_namespace *ipc_ns, struct mq_attr *attr)
 	if (attr->mq_maxmsg <= 0 || attr->mq_msgsize <= 0)
 		return 0;
 	if (capable(CAP_SYS_RESOURCE)) {
-		if (attr->mq_maxmsg > HARD_MSGMAX)
+		if (attr->mq_maxmsg > HARD_MSGMAX ||
+		    attr->mq_msgsize > HARD_MSGSIZEMAX)
 			return 0;
 	} else {
 		if (attr->mq_maxmsg > ipc_ns->mq_msg_max ||
-- 
1.7.7.6

