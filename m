Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab1I0Wb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 18:31:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753072Ab1I0WbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 18:31:21 -0400
From: Doug Ledford <dledford@redhat.com>
To: akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, joe.korty@ccur.com, amwang@redhat.com,
        Doug Ledford <dledford@redhat.com>
Subject: [PATCH 3/4] ipc/mqueue: enforce hard limits
Date: Tue, 27 Sep 2011 18:30:12 -0400
Message-Id: <1317162613-11060-4-git-send-email-dledford@redhat.com>
In-Reply-To: <1317162613-11060-1-git-send-email-dledford@redhat.com>
References: <1317162613-11060-1-git-send-email-dledford@redhat.com>
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
index c6597fc..7cda828 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -310,8 +310,9 @@ static int mqueue_create(struct inode *dir, struct dentry *dentry,
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
@@ -591,7 +592,8 @@ static int mq_attr_ok(struct ipc_namespace *ipc_ns, struct mq_attr *attr)
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
1.7.6

