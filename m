Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab1I1XDD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:03:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54696 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933046Ab1I1Wrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:47:35 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:42 2011
Message-Id: <20110928220142.033134480@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:02:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiri Slaby <jslaby@suse.cz>, Manfred Spraul <manfred@colorfullife.com>
Subject: [159/244] ipc/mqueue.c: fix mq_open() return value
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

commit d40dcdb0172a1ba853464983a059fb45e0aaf61a upstream.

We return ENOMEM from mqueue_get_inode even when we have enough memory.
Namely in case the system rlimit of mqueue was reached.  This error
propagates to mq_queue and user sees the error unexpectedly.  So fix
this up to properly return EMFILE as described in the manpage:

	EMFILE The process already has the maximum number of files and
	       message queues open.

instead of:

	ENOMEM Insufficient memory.

With the previous patch we just switch to ERR_PTR/PTR_ERR/IS_ERR error
handling here.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 ipc/mqueue.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -113,6 +113,7 @@ static struct inode *mqueue_get_inode(st
 {
 	struct user_struct *u = current_user();
 	struct inode *inode;
+	int ret = -ENOMEM;
 
 	inode = new_inode(sb);
 	if (!inode)
@@ -160,6 +161,7 @@ static struct inode *mqueue_get_inode(st
 		    u->mq_bytes + mq_bytes > task_rlimit(p, RLIMIT_MSGQUEUE)) {
 			spin_unlock(&mq_lock);
 			/* mqueue_evict_inode() releases info->messages */
+			ret = -EMFILE;
 			goto out_inode;
 		}
 		u->mq_bytes += mq_bytes;
@@ -179,7 +181,7 @@ static struct inode *mqueue_get_inode(st
 out_inode:
 	iput(inode);
 err:
-	return NULL;
+	return ERR_PTR(ret);
 }
 
 static int mqueue_fill_super(struct super_block *sb, void *data, int silent)
@@ -195,8 +197,8 @@ static int mqueue_fill_super(struct supe
 
 	inode = mqueue_get_inode(sb, ns, S_IFDIR | S_ISVTX | S_IRWXUGO,
 				NULL);
-	if (!inode) {
-		error = -ENOMEM;
+	if (IS_ERR(inode)) {
+		error = PTR_ERR(inode);
 		goto out;
 	}
 
@@ -316,8 +318,8 @@ static int mqueue_create(struct inode *d
 	spin_unlock(&mq_lock);
 
 	inode = mqueue_get_inode(dir->i_sb, ipc_ns, mode, attr);
-	if (!inode) {
-		error = -ENOMEM;
+	if (IS_ERR(inode)) {
+		error = PTR_ERR(inode);
 		spin_lock(&mq_lock);
 		ipc_ns->mq_queues_count--;
 		goto out_unlock;


