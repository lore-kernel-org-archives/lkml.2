Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab2AIK71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 05:59:27 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:60523 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab2AIK7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 05:59:25 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Subject: [RFC PATCH] shrink_dcache_parent() deadlock
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mgorman@suse.de, gregkh@suse.de, hch@infradead.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Date: Mon, 09 Jan 2012 11:58:54 +0100
Message-ID: <87ipkl87m9.fsf@tucsk.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two (or more) concurrent calls of shrink_dcache_parent() on the same
dentry with the right timing may cause shrink_dcache_parent() to loop
forever.

Here's what appears to happen:

1 - CPU0: select_parent(P) finds C and puts it on sb->s_dentry_lru, returns 1

2 - CPU0: __shrink_dcache_sb() moves C from sb->s_dentry_lru to tmp

3 - CPU1: select_parent(P) locks P->d_lock

4 - CPU0: shrink_dentry_list() locks C->d_lock
    dentry_kill(C) tries to lock P->d_lock but fails, unlocks C->d_lock

5 - CPU1: select_parent(P) locks C->d_lock,
          moves C from tmp to sb->s_dentry_lru, returns 1

6 - CPU0: shrink_dentry_list() finds tmp empty, returns

7 - Goto 2 with CPU0 and CPU1 switched


So basically select_parent() steals the dentry from shrink_dentry_list()
and thinks it found a new one, causing shrink_dentry_list() to think
it's making progress and loop over and over.

This was actually triggered by a combination of the bonding driver
removing a directory in sysfs and a udev rule causing udev to do stat
multiple times on the just removed directory.

One fix would be to check all callers and prevent concurrent calls to
shrink_dcache_parent().  But I think a better solution is to stop the
stealing behavior.

This patch adds a new dentry flag that is set when the dentry is removed
from the lru and put on the list being processed by
shrink_dentry_list().  The flag is cleared in dentry_lru_del() which is
called if the dentry gets a new reference just before it's pruned.

Thoughts?

diff --git a/fs/dcache.c b/fs/dcache.c
index 89509b5..09805eb 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -242,6 +242,7 @@ static void dentry_lru_add(struct dentry *dentry)
 static void __dentry_lru_del(struct dentry *dentry)
 {
 	list_del_init(&dentry->d_lru);
+	dentry->d_flags &= ~DCACHE_SHRINK_LIST;
 	dentry->d_sb->s_nr_dentry_unused--;
 	dentry_stat.nr_unused--;
 }
@@ -807,6 +808,7 @@ relock:
 			spin_unlock(&dentry->d_lock);
 		} else {
 			list_move_tail(&dentry->d_lru, &tmp);
+			dentry->d_flags |= DCACHE_SHRINK_LIST;
 			spin_unlock(&dentry->d_lock);
 			if (!--count)
 				break;
@@ -1117,11 +1119,11 @@ resume:
 		 * move only zero ref count dentries to the end 
 		 * of the unused list for prune_dcache
 		 */
-		if (!dentry->d_count) {
+		if (dentry->d_count) {
+			dentry_lru_del(dentry);
+		} else if(!(dentry->d_flags & DCACHE_SHRINK_LIST)) {
 			dentry_lru_move_tail(dentry);
 			found++;
-		} else {
-			dentry_lru_del(dentry);
 		}
 
 		/*
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index ed9f74f..4eb8c80 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -203,6 +203,7 @@ struct dentry_operations {
 
 #define DCACHE_CANT_MOUNT	0x0100
 #define DCACHE_GENOCIDE		0x0200
+#define DCACHE_SHRINK_LIST	0x0400
 
 #define DCACHE_NFSFS_RENAMED	0x1000
      /* this dentry has been "silly renamed" and has to be deleted on the last
