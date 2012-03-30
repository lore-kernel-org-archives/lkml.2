Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965011Ab2C3VNs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:13:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34386 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964992Ab2C3VNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:13:43 -0400
Message-Id: <20120330194854.761662655@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:50:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Pavel Shilovsky <piastry@etersoft.ru>,
        Jeff Layton <jlayton@redhat.com>, Ben Hutchings <ben@decadent.org.uk>,
        Steve French <sfrench@us.ibm.com>
Subject: [ 094/149] CIFS: Fix a spurious error in cifs_push_posix_locks
In-Reply-To: <20120330195823.GA31857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Shilovsky <piastry@etersoft.ru>

commit ce85852b90a214cf577fc1b4f49d99fd7e98784a upstream.

Signed-off-by: Pavel Shilovsky <piastry@etersoft.ru>
Reviewed-by: Jeff Layton <jlayton@redhat.com>
Reported-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/file.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -960,9 +960,9 @@ cifs_push_posix_locks(struct cifsFileInf
 	INIT_LIST_HEAD(&locks_to_send);
 
 	/*
-	 * Allocating count locks is enough because no locks can be added to
-	 * the list while we are holding cinode->lock_mutex that protects
-	 * locking operations of this inode.
+	 * Allocating count locks is enough because no FL_POSIX locks can be
+	 * added to the list while we are holding cinode->lock_mutex that
+	 * protects locking operations of this inode.
 	 */
 	for (; i < count; i++) {
 		lck = kmalloc(sizeof(struct lock_to_push), GFP_KERNEL);
@@ -973,18 +973,20 @@ cifs_push_posix_locks(struct cifsFileInf
 		list_add_tail(&lck->llist, &locks_to_send);
 	}
 
-	i = 0;
 	el = locks_to_send.next;
 	lock_flocks();
 	cifs_for_each_lock(cfile->dentry->d_inode, before) {
+		flock = *before;
+		if ((flock->fl_flags & FL_POSIX) == 0)
+			continue;
 		if (el == &locks_to_send) {
-			/* something is really wrong */
+			/*
+			 * The list ended. We don't have enough allocated
+			 * structures - something is really wrong.
+			 */
 			cERROR(1, "Can't push all brlocks!");
 			break;
 		}
-		flock = *before;
-		if ((flock->fl_flags & FL_POSIX) == 0)
-			continue;
 		length = 1 + flock->fl_end - flock->fl_start;
 		if (flock->fl_type == F_RDLCK || flock->fl_type == F_SHLCK)
 			type = CIFS_RDLCK;
@@ -996,7 +998,6 @@ cifs_push_posix_locks(struct cifsFileInf
 		lck->length = length;
 		lck->type = type;
 		lck->offset = flock->fl_start;
-		i++;
 		el = el->next;
 	}
 	unlock_flocks();


