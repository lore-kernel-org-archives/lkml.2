Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768Ab2AJRXC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 12:23:02 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59092 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080Ab2AJRW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 12:22:58 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, gregkh@suse.de,
        akpm@linux-foundation.org
Subject: [PATCH v2] vfs: fix shrink_dcache_parent() livelock
References: <87k44zdbjm.fsf@tucsk.pomaz.szeredi.hu>
Date: Tue, 10 Jan 2012 18:22:25 +0100
In-Reply-To: <87k44zdbjm.fsf@tucsk.pomaz.szeredi.hu> (Miklos Szeredi's message
	of "Tue, 10 Jan 2012 12:47:25 +0100")
Message-ID: <87fwfncw1a.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set flag in prune_dcache_sb() for consistency.  Add stable@ to cc.

Please apply.

Thanks,
Miklos

----
Subject: vfs: fix shrink_dcache_parent() livelock

From: Miklos Szeredi <mszeredi@suse.cz>

Two (or more) concurrent calls of shrink_dcache_parent() on the same dentry may
cause shrink_dcache_parent() to loop forever.

Here's what appears to happen:

1 - CPU0: select_parent(P) finds C and puts it on dispose list, returns 1

2 - CPU1: select_parent(P) locks P->d_lock

3 - CPU0: shrink_dentry_list() locks C->d_lock
   dentry_kill(C) tries to lock P->d_lock but fails, unlocks C->d_lock

4 - CPU1: select_parent(P) locks C->d_lock,
         moves C from dispose list being processed on CPU0 to the new
dispose list, returns 1

5 - CPU0: shrink_dentry_list() finds dispose list empty, returns

6 - Goto 2 with CPU0 and CPU1 switched

Basically select_parent() steals the dentry from shrink_dentry_list() and thinks
it found a new one, causing shrink_dentry_list() to think it's making progress
and loop over and over.

One way to trigger this is to make udev calls stat() on the sysfs file while it
is going away.

Having a file in /lib/udev/rules.d/ with only this one rule seems to the trick:

ATTR{vendor}=="0x8086", ATTR{device}=="0x10ca", ENV{PCI_SLOT_NAME}="%k", ENV{MATCHADDR}="$attr{address}", RUN+="/bin/true"

Then execute the following loop:

while true; do
        echo -bond0 > /sys/class/net/bonding_masters
        echo +bond0 > /sys/class/net/bonding_masters
        echo -bond1 > /sys/class/net/bonding_masters
        echo +bond1 > /sys/class/net/bonding_masters
done


One fix would be to check all callers and prevent concurrent calls to
shrink_dcache_parent().  But I think a better solution is to stop the
stealing behavior.

This patch adds a new dentry flag that is set when the dentry is added to the
dispose list.  The flag is cleared in dentry_lru_del() in case the dentry gets a
new reference just before being pruned.

If the dentry has this flag, select_parent() will skip it and let
shrink_dentry_list() retry pruning it.  With select_parent() skipping those
dentries there will not be the appearance of progress (new dentries found) when
there is none, hence shrink_dcache_parent() will not loop forever.

Set the flag is also set in prune_dcache_sb() for consistency as suggested by
Linus.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: stable@vger.kernel.org
---
 fs/dcache.c            |   15 +++++++++++----
 include/linux/dcache.h |    1 +
 2 files changed, 12 insertions(+), 4 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c	2012-01-10 16:18:30.000000000 +0100
+++ linux-2.6/fs/dcache.c	2012-01-10 17:39:46.000000000 +0100
@@ -243,6 +243,7 @@ static void dentry_lru_add(struct dentry
 static void __dentry_lru_del(struct dentry *dentry)
 {
 	list_del_init(&dentry->d_lru);
+	dentry->d_flags &= ~DCACHE_SHRINK_LIST;
 	dentry->d_sb->s_nr_dentry_unused--;
 	dentry_stat.nr_unused--;
 }
@@ -806,6 +807,7 @@ void prune_dcache_sb(struct super_block
 			spin_unlock(&dentry->d_lock);
 		} else {
 			list_move_tail(&dentry->d_lru, &tmp);
+			dentry->d_flags |= DCACHE_SHRINK_LIST;
 			spin_unlock(&dentry->d_lock);
 			if (!--count)
 				break;
@@ -1097,14 +1099,19 @@ static int select_parent(struct dentry *
 
 		/*
 		 * move only zero ref count dentries to the dispose list.
+		 *
+		 * Those which are presently on the shrink list, being processed
+		 * by shrink_dentry_list(), shouldn't be moved.  Otherwise the
+		 * loop in shrink_dcache_parent() might not make any progress
+		 * and loop forever.
 		 */
-		if (!dentry->d_count) {
+		if (dentry->d_count) {
+			dentry_lru_del(dentry);
+		} else if (!(dentry->d_flags & DCACHE_SHRINK_LIST)) {
 			dentry_lru_move_list(dentry, dispose);
+			dentry->d_flags |= DCACHE_SHRINK_LIST;
 			found++;
-		} else {
-			dentry_lru_del(dentry);
 		}
-
 		/*
 		 * We can return to the caller if we have found some (this
 		 * ensures forward progress). We'll be coming back to find
Index: linux-2.6/include/linux/dcache.h
===================================================================
--- linux-2.6.orig/include/linux/dcache.h	2012-01-10 16:18:30.000000000 +0100
+++ linux-2.6/include/linux/dcache.h	2012-01-10 17:36:29.000000000 +0100
@@ -203,6 +203,7 @@ struct dentry_operations {
 
 #define DCACHE_CANT_MOUNT	0x0100
 #define DCACHE_GENOCIDE		0x0200
+#define DCACHE_SHRINK_LIST	0x0400
 
 #define DCACHE_NFSFS_RENAMED	0x1000
      /* this dentry has been "silly renamed" and has to be deleted on the last
