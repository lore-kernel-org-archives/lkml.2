Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965518Ab2CPXtk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:49:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38586 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946237Ab2CPXkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:40:05 -0400
Message-Id: <20120316233811.484341257@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 16 Mar 2012 16:38:20 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jeff Layton <jlayton@redhat.com>,
        Pavel Shilovsky <piastry@etersoft.ru>,
        Steve French <sfrench@us.ibm.com>
Subject: [ 10/41] CIFS: Do not kmalloc under the flocks spinlock
In-Reply-To: <20120316233829.GA14022@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Shilovsky <piastry@etersoft.ru>

commit d5751469f210d2149cc2159ffff66cbeef6da3f2 upstream.

Reorganize the code to make the memory already allocated before
spinlock'ed loop.

Reviewed-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Pavel Shilovsky <piastry@etersoft.ru>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/file.c |   69 ++++++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 56 insertions(+), 13 deletions(-)

--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -920,16 +920,26 @@ cifs_push_mandatory_locks(struct cifsFil
 	for (lockp = &inode->i_flock; *lockp != NULL; \
 	     lockp = &(*lockp)->fl_next)
 
+struct lock_to_push {
+	struct list_head llist;
+	__u64 offset;
+	__u64 length;
+	__u32 pid;
+	__u16 netfid;
+	__u8 type;
+};
+
 static int
 cifs_push_posix_locks(struct cifsFileInfo *cfile)
 {
 	struct cifsInodeInfo *cinode = CIFS_I(cfile->dentry->d_inode);
 	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
 	struct file_lock *flock, **before;
-	struct cifsLockInfo *lck, *tmp;
+	unsigned int count = 0, i = 0;
 	int rc = 0, xid, type;
+	struct list_head locks_to_send, *el;
+	struct lock_to_push *lck, *tmp;
 	__u64 length;
-	struct list_head locks_to_send;
 
 	xid = GetXid();
 
@@ -940,29 +950,55 @@ cifs_push_posix_locks(struct cifsFileInf
 		return rc;
 	}
 
+	lock_flocks();
+	cifs_for_each_lock(cfile->dentry->d_inode, before) {
+		if ((*before)->fl_flags & FL_POSIX)
+			count++;
+	}
+	unlock_flocks();
+
 	INIT_LIST_HEAD(&locks_to_send);
 
+	/*
+	 * Allocating count locks is enough because no locks can be added to
+	 * the list while we are holding cinode->lock_mutex that protects
+	 * locking operations of this inode.
+	 */
+	for (; i < count; i++) {
+		lck = kmalloc(sizeof(struct lock_to_push), GFP_KERNEL);
+		if (!lck) {
+			rc = -ENOMEM;
+			goto err_out;
+		}
+		list_add_tail(&lck->llist, &locks_to_send);
+	}
+
+	i = 0;
+	el = locks_to_send.next;
 	lock_flocks();
 	cifs_for_each_lock(cfile->dentry->d_inode, before) {
+		if (el == &locks_to_send) {
+			/* something is really wrong */
+			cERROR(1, "Can't push all brlocks!");
+			break;
+		}
 		flock = *before;
+		if ((flock->fl_flags & FL_POSIX) == 0)
+			continue;
 		length = 1 + flock->fl_end - flock->fl_start;
 		if (flock->fl_type == F_RDLCK || flock->fl_type == F_SHLCK)
 			type = CIFS_RDLCK;
 		else
 			type = CIFS_WRLCK;
-
-		lck = cifs_lock_init(flock->fl_start, length, type,
-				     cfile->netfid);
-		if (!lck) {
-			rc = -ENOMEM;
-			goto send_locks;
-		}
+		lck = list_entry(el, struct lock_to_push, llist);
 		lck->pid = flock->fl_pid;
-
-		list_add_tail(&lck->llist, &locks_to_send);
+		lck->netfid = cfile->netfid;
+		lck->length = length;
+		lck->type = type;
+		lck->offset = flock->fl_start;
+		i++;
+		el = el->next;
 	}
-
-send_locks:
 	unlock_flocks();
 
 	list_for_each_entry_safe(lck, tmp, &locks_to_send, llist) {
@@ -979,11 +1015,18 @@ send_locks:
 		kfree(lck);
 	}
 
+out:
 	cinode->can_cache_brlcks = false;
 	mutex_unlock(&cinode->lock_mutex);
 
 	FreeXid(xid);
 	return rc;
+err_out:
+	list_for_each_entry_safe(lck, tmp, &locks_to_send, llist) {
+		list_del(&lck->llist);
+		kfree(lck);
+	}
+	goto out;
 }
 
 static int


