Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab1I1XDb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:03:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54679 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933123Ab1I1WrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:47:25 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:42 2011
Message-Id: <20110928220141.926557317@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:02:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiri Slaby <jslaby@suse.cz>, Manfred Spraul <manfred@colorfullife.com>
Subject: [158/244] ipc/mqueue.c: refactor failure handling
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

commit 04715206c0c2fd4ec5ca77fa51e3a5b41ce71492 upstream.

If new_inode fails to allocate an inode we need only to return with
NULL.  But now we test the opposite and have all the work in a nested
block.  So do the opposite to save one indentation level (and remove
unnecessary line breaks).

This is only a preparation/cleanup for the next patch where we fix up
return values from mqueue_get_inode.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 ipc/mqueue.c |  115 +++++++++++++++++++++++++++++------------------------------
 1 file changed, 58 insertions(+), 57 deletions(-)

--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -115,69 +115,70 @@ static struct inode *mqueue_get_inode(st
 	struct inode *inode;
 
 	inode = new_inode(sb);
-	if (inode) {
-		inode->i_ino = get_next_ino();
-		inode->i_mode = mode;
-		inode->i_uid = current_fsuid();
-		inode->i_gid = current_fsgid();
-		inode->i_mtime = inode->i_ctime = inode->i_atime =
-				CURRENT_TIME;
-
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
+	if (!inode)
+		goto err;
 
-			/* all is ok */
-			info->user = get_uid(u);
-		} else if (S_ISDIR(mode)) {
-			inc_nlink(inode);
-			/* Some things misbehave if size == 0 on a directory */
-			inode->i_size = 2 * DIRENT_SIZE;
-			inode->i_op = &mqueue_dir_inode_operations;
-			inode->i_fop = &simple_dir_operations;
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
+
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
 


