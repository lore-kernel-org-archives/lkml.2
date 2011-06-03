Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab1FCNKu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 09:10:50 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:43440 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038Ab1FCNKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 09:10:48 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 1/2] IPC: mqueue, refactor failure handling
Date: Fri,  3 Jun 2011 15:10:39 +0200
Message-Id: <1307106641-7215-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If new_inode fails to allocate an inode we need only to return with
NULL. But now we test the opposite and have all the work in a nested
block. So do the opposite to save one indentation level (and remove
unnecessary line breaks).

This is only a preparation/cleanup for the next patch where we fix up
return values from mqueue_get_inode.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
I don't know who to send this to. Neither MAINTAINERS nor git log
shows somebody taking care about the code. Maybe you have a better
code=>people mapping file, Andrew?

 ipc/mqueue.c |  115 +++++++++++++++++++++++++++++-----------------------------
 1 files changed, 58 insertions(+), 57 deletions(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 14fb6d6..d43c30f 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -115,69 +115,70 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
 	struct inode *inode;
 
 	inode = new_inode(sb);
-	if (inode) {
-		inode->i_ino = get_next_ino();
-		inode->i_mode = mode;
-		inode->i_uid = current_fsuid();
-		inode->i_gid = current_fsgid();
-		inode->i_mtime = inode->i_ctime = inode->i_atime =
-				CURRENT_TIME;
+	if (!inode)
+		goto err;
 
-		if (S_ISREG(mode)) {
-			struct mqueue_inode_info *info;
-			struct task_struct *p = current;
-			unsigned long mq_bytes, mq_msg_tblsz;
-
-			inode->i_fop = &mqueue_file_operations;
-			inode->i_size = FILENT_SIZE;
-			/* mqueue specific info */
-			info = MQUEUE_I(inode);
-			spin_lock_init(&info->lock);
-			init_waitqueue_head(&info->wait_q);
-			INIT_LIST_HEAD(&info->e_wait_q[0].list);
-			INIT_LIST_HEAD(&info->e_wait_q[1].list);
-			info->notify_owner = NULL;
-			info->qsize = 0;
-			info->user = NULL;	/* set when all is ok */
-			memset(&info->attr, 0, sizeof(info->attr));
-			info->attr.mq_maxmsg = ipc_ns->mq_msg_max;
-			info->attr.mq_msgsize = ipc_ns->mq_msgsize_max;
-			if (attr) {
-				info->attr.mq_maxmsg = attr->mq_maxmsg;
-				info->attr.mq_msgsize = attr->mq_msgsize;
-			}
-			mq_msg_tblsz = info->attr.mq_maxmsg * sizeof(struct msg_msg *);
-			info->messages = kmalloc(mq_msg_tblsz, GFP_KERNEL);
-			if (!info->messages)
-				goto out_inode;
-
-			mq_bytes = (mq_msg_tblsz +
-				(info->attr.mq_maxmsg * info->attr.mq_msgsize));
-
-			spin_lock(&mq_lock);
-			if (u->mq_bytes + mq_bytes < u->mq_bytes ||
-		 	    u->mq_bytes + mq_bytes >
-			    task_rlimit(p, RLIMIT_MSGQUEUE)) {
-				spin_unlock(&mq_lock);
-				/* mqueue_evict_inode() releases info->messages */
-				goto out_inode;
-			}
-			u->mq_bytes += mq_bytes;
-			spin_unlock(&mq_lock);
+	inode->i_ino = get_next_ino();
+	inode->i_mode = mode;
+	inode->i_uid = current_fsuid();
+	inode->i_gid = current_fsgid();
+	inode->i_mtime = inode->i_ctime = inode->i_atime = CURRENT_TIME;
+
+	if (S_ISREG(mode)) {
+		struct mqueue_inode_info *info;
+		struct task_struct *p = current;
+		unsigned long mq_bytes, mq_msg_tblsz;
+
+		inode->i_fop = &mqueue_file_operations;
+		inode->i_size = FILENT_SIZE;
+		/* mqueue specific info */
+		info = MQUEUE_I(inode);
+		spin_lock_init(&info->lock);
+		init_waitqueue_head(&info->wait_q);
+		INIT_LIST_HEAD(&info->e_wait_q[0].list);
+		INIT_LIST_HEAD(&info->e_wait_q[1].list);
+		info->notify_owner = NULL;
+		info->qsize = 0;
+		info->user = NULL;	/* set when all is ok */
+		memset(&info->attr, 0, sizeof(info->attr));
+		info->attr.mq_maxmsg = ipc_ns->mq_msg_max;
+		info->attr.mq_msgsize = ipc_ns->mq_msgsize_max;
+		if (attr) {
+			info->attr.mq_maxmsg = attr->mq_maxmsg;
+			info->attr.mq_msgsize = attr->mq_msgsize;
+		}
+		mq_msg_tblsz = info->attr.mq_maxmsg * sizeof(struct msg_msg *);
+		info->messages = kmalloc(mq_msg_tblsz, GFP_KERNEL);
+		if (!info->messages)
+			goto out_inode;
 
-			/* all is ok */
-			info->user = get_uid(u);
-		} else if (S_ISDIR(mode)) {
-			inc_nlink(inode);
-			/* Some things misbehave if size == 0 on a directory */
-			inode->i_size = 2 * DIRENT_SIZE;
-			inode->i_op = &mqueue_dir_inode_operations;
-			inode->i_fop = &simple_dir_operations;
+		mq_bytes = (mq_msg_tblsz +
+			(info->attr.mq_maxmsg * info->attr.mq_msgsize));
+
+		spin_lock(&mq_lock);
+		if (u->mq_bytes + mq_bytes < u->mq_bytes ||
+		    u->mq_bytes + mq_bytes > task_rlimit(p, RLIMIT_MSGQUEUE)) {
+			spin_unlock(&mq_lock);
+			/* mqueue_evict_inode() releases info->messages */
+			goto out_inode;
 		}
+		u->mq_bytes += mq_bytes;
+		spin_unlock(&mq_lock);
+
+		/* all is ok */
+		info->user = get_uid(u);
+	} else if (S_ISDIR(mode)) {
+		inc_nlink(inode);
+		/* Some things misbehave if size == 0 on a directory */
+		inode->i_size = 2 * DIRENT_SIZE;
+		inode->i_op = &mqueue_dir_inode_operations;
+		inode->i_fop = &simple_dir_operations;
 	}
+
 	return inode;
 out_inode:
 	iput(inode);
+err:
 	return NULL;
 }
 
-- 
1.7.4.2


