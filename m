Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932765Ab2AXCsA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:48:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50552 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932731Ab2AXCru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:47:50 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:30 2012
Message-Id: <20120124023930.662311780@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:34:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Miklos Szeredi <mszeredi@suse.cz>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [076/129] fix shrink_dcache_parent() livelock
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 4117
Lines: 122

From: Miklos Szeredi <miklos@szeredi.hu>

commit eaf5f9073533cde21c7121c136f1c3f072d9cf59 upstream.

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
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/dcache.c            |   15 +++++++++++----
 include/linux/dcache.h |    1 +
 2 files changed, 12 insertions(+), 4 deletions(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -242,6 +242,7 @@ static void dentry_lru_add(struct dentry
 static void __dentry_lru_del(struct dentry *dentry)
 {
 	list_del_init(&dentry->d_lru);
+	dentry->d_flags &= ~DCACHE_SHRINK_LIST;
 	dentry->d_sb->s_nr_dentry_unused--;
 	dentry_stat.nr_unused--;
 }
@@ -805,6 +806,7 @@ relock:
 			spin_unlock(&dentry->d_lock);
 		} else {
 			list_move_tail(&dentry->d_lru, &tmp);
+			dentry->d_flags |= DCACHE_SHRINK_LIST;
 			spin_unlock(&dentry->d_lock);
 			if (!--count)
 				break;
@@ -1096,14 +1098,19 @@ resume:
 
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
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -203,6 +203,7 @@ struct dentry_operations {
 
 #define DCACHE_CANT_MOUNT	0x0100
 #define DCACHE_GENOCIDE		0x0200
+#define DCACHE_SHRINK_LIST	0x0400
 
 #define DCACHE_NFSFS_RENAMED	0x1000
      /* this dentry has been "silly renamed" and has to be deleted on the last


