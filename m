Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab1FCNKt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 09:10:49 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:43439 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210Ab1FCNKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 09:10:48 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 2/2] IPC: mqueue, fix mq_open return value
Date: Fri,  3 Jun 2011 15:10:40 +0200
Message-Id: <1307106641-7215-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.5.3
In-Reply-To: <1307106641-7215-1-git-send-email-jslaby@suse.cz>
References: <1307106641-7215-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We return ENOMEM from mqueue_get_inode even when we have enough
memory. Namely in case the system rlimit of mqueue was reached. This
error propagates to mq_queue and user sees the error unexpectedly. So
fix this up to properly return EMFILE as described in the manpage:
	EMFILE The process already has the maximum number of files and
	       message queues open.
instead of:
	ENOMEM Insufficient memory.

With the previous patch we just switch to ERR_PTR/PTR_ERR/IS_ERR
error handling here.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 ipc/mqueue.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index d43c30f..ed049ea 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -113,6 +113,7 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
 {
 	struct user_struct *u = current_user();
 	struct inode *inode;
+	int ret = -ENOMEM;
 
 	inode = new_inode(sb);
 	if (!inode)
@@ -160,6 +161,7 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
 		    u->mq_bytes + mq_bytes > task_rlimit(p, RLIMIT_MSGQUEUE)) {
 			spin_unlock(&mq_lock);
 			/* mqueue_evict_inode() releases info->messages */
+			ret = -EMFILE;
 			goto out_inode;
 		}
 		u->mq_bytes += mq_bytes;
@@ -179,7 +181,7 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
 out_inode:
 	iput(inode);
 err:
-	return NULL;
+	return ERR_PTR(ret);
 }
 
 static int mqueue_fill_super(struct super_block *sb, void *data, int silent)
@@ -195,8 +197,8 @@ static int mqueue_fill_super(struct super_block *sb, void *data, int silent)
 
 	inode = mqueue_get_inode(sb, ns, S_IFDIR | S_ISVTX | S_IRWXUGO,
 				NULL);
-	if (!inode) {
-		error = -ENOMEM;
+	if (IS_ERR(inode)) {
+		error = PTR_ERR(inode);
 		goto out;
 	}
 
@@ -316,8 +318,8 @@ static int mqueue_create(struct inode *dir, struct dentry *dentry,
 	spin_unlock(&mq_lock);
 
 	inode = mqueue_get_inode(dir->i_sb, ipc_ns, mode, attr);
-	if (!inode) {
-		error = -ENOMEM;
+	if (IS_ERR(inode)) {
+		error = PTR_ERR(inode);
 		spin_lock(&mq_lock);
 		ipc_ns->mq_queues_count--;
 		goto out_unlock;
-- 
1.7.4.2


