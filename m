Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187Ab2EATI3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 15:08:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758057Ab2EATI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 15:08:26 -0400
From: Doug Ledford <dledford@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, sfr@canb.auug.org.au,
        Doug Ledford <dledford@redhat.com>
Subject: [Patch 3/4] ipc/mqueue: strengthen checks on mqueue creation
Date: Tue,  1 May 2012 13:50:54 -0400
Message-Id: <d280fa846e9093a3cc82d9e75da4bb8074c7d4c7.1335894230.git.dledford@redhat.com>
In-Reply-To: <1335894655-11398-1-git-send-email-dledford@redhat.com>
References: <1335894655-11398-1-git-send-email-dledford@redhat.com>
In-Reply-To: <5b62749cb9227016ed5965fa57b96c0dccce37a8.1335894230.git.dledford@redhat.com>
References: <5b62749cb9227016ed5965fa57b96c0dccce37a8.1335894230.git.dledford@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already check the mq attr struct if it's passed in, but now that the
admin can set system wide defaults separate from maximums, it's actually
possible to set the defaults to something that would overflow.  So,
if there is no attr struct passed in to the open call, check the default
values.

While we are at it, simplify mq_attr_ok() by making it return 0 or an
error condition, so that way if we add more tests to it later, we have
the option of what error should be returned instead of the calling
location having to pick a possibly inaccurate error code.

Signed-off-by: Doug Ledford <dledford@redhat.com>
---
 ipc/mqueue.c |   27 ++++++++++++++++++---------
 1 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 4b2892e..6089f73 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -673,27 +673,27 @@ static int mq_attr_ok(struct ipc_namespace *ipc_ns, struct mq_attr *attr)
 	int mq_treesize;
 
 	if (attr->mq_maxmsg <= 0 || attr->mq_msgsize <= 0)
-		return 0;
+		return -EINVAL;
 	if (capable(CAP_SYS_RESOURCE)) {
 		if (attr->mq_maxmsg > HARD_MSGMAX ||
 		    attr->mq_msgsize > HARD_MSGSIZEMAX)
-			return 0;
+			return -EINVAL;
 	} else {
 		if (attr->mq_maxmsg > ipc_ns->mq_msg_max ||
 				attr->mq_msgsize > ipc_ns->mq_msgsize_max)
-			return 0;
+			return -EINVAL;
 	}
 	/* check for overflow */
 	if (attr->mq_msgsize > ULONG_MAX/attr->mq_maxmsg)
-		return 0;
+		return -ENOMEM;
 	mq_treesize = attr->mq_maxmsg * sizeof(struct msg_msg) +
 		min_t(unsigned int, attr->mq_maxmsg, MQ_PRIO_MAX) *
 		sizeof(struct posix_msg_tree_node);
 	if ((unsigned long)(attr->mq_maxmsg * attr->mq_msgsize +
 			    mq_treesize) <
 	    (unsigned long)(attr->mq_maxmsg * attr->mq_msgsize))
-		return 0;
-	return 1;
+		return -ENOMEM;
+	return 0;
 }
 
 /*
@@ -708,12 +708,21 @@ static struct file *do_create(struct ipc_namespace *ipc_ns, struct dentry *dir,
 	int ret;
 
 	if (attr) {
-		if (!mq_attr_ok(ipc_ns, attr)) {
-			ret = -EINVAL;
+		ret = mq_attr_ok(ipc_ns, attr);
+		if (ret)
 			goto out;
-		}
 		/* store for use during create */
 		dentry->d_fsdata = attr;
+	} else {
+		struct mq_attr def_attr;
+
+		def_attr.mq_maxmsg = min(ipc_ns->mq_msg_max,
+					 ipc_ns->mq_msg_default);
+		def_attr.mq_msgsize = min(ipc_ns->mq_msgsize_max,
+					  ipc_ns->mq_msgsize_default);
+		ret = mq_attr_ok(ipc_ns, &def_attr);
+		if (ret)
+			goto out;
 	}
 
 	mode &= ~current_umask();
-- 
1.7.7.6

