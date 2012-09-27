Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336Ab2I0Mwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 08:52:49 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61278 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783Ab2I0Mwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 08:52:45 -0400
From: Yan Hong <clouds.yan@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] vfs: misc comment clean
Date: Thu, 27 Sep 2012 20:51:56 +0800
Message-Id: <1348750316-4138-8-git-send-email-clouds.yan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348750316-4138-1-git-send-email-clouds.yan@gmail.com>
References: <no>
 <1348750316-4138-1-git-send-email-clouds.yan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mostly fix comments which reference inexist locks or parameters.

Signed-off-by: Yan Hong <clouds.yan@gmail.com>
---
 fs/dcache.c    |   12 ++++--------
 fs/inode.c     |    4 ++--
 fs/namei.c     |    2 +-
 fs/namespace.c |    9 +++------
 4 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 8086636..2d97518 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -44,8 +44,6 @@
  * Usage:
  * dcache->d_inode->i_lock protects:
  *   - i_dentry, d_alias, d_inode of aliases
- * dcache_hash_bucket lock protects:
- *   - the dcache hash table
  * s_anon bl list spinlock protects:
  *   - the s_anon list (see __d_drop)
  * dcache_lru_lock protects:
@@ -64,7 +62,6 @@
  * dentry->d_inode->i_lock
  *   dentry->d_lock
  *     dcache_lru_lock
- *     dcache_hash_bucket lock
  *     s_anon lock
  *
  * If there is an ancestor relationship:
@@ -145,10 +142,9 @@ int proc_nr_dentry(ctl_table *table, int write, void __user *buffer,
 
 #include <asm/word-at-a-time.h>
 /*
- * NOTE! 'cs' and 'scount' come from a dentry, so it has a
- * aligned allocation for this particular component. We don't
- * strictly need the load_unaligned_zeropad() safety, but it
- * doesn't hurt either.
+ * NOTE! 'cs' comes from a dentry, so it has an aligned allocation
+ * for this particular component. We don't strictly need the
+ * load_unaligned_zeropad() safety, but it doesn't hurt either.
  *
  * In contrast, 'ct' and 'tcount' can be from a pathname, and do
  * need the careful unaligned handling.
@@ -304,7 +300,7 @@ static void dentry_unlink_inode(struct dentry * dentry)
 }
 
 /*
- * dentry_lru_(add|del|prune|move_tail) must be called with d_lock held.
+ * dentry_lru_(add|del|prune|move_list) must be called with d_lock held.
  */
 static void dentry_lru_add(struct dentry *dentry)
 {
diff --git a/fs/inode.c b/fs/inode.c
index e89d30c..46d4f16 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -676,7 +676,7 @@ static int can_unuse(struct inode *inode)
  * Walk the superblock inode LRU for freeable inodes and attempt to free them.
  * This is called from the superblock shrinker function with a number of inodes
  * to trim from the LRU. Inodes to be freed are moved to a temporary list and
- * then are freed outside inode_lock by dispose_list().
+ * then are freed outside s_inode_lru_lock by dispose_list().
  *
  * Any inodes which are pinned purely because of attached pagecache have their
  * pagecache removed.  If the inode has metadata buffers attached to
@@ -777,7 +777,7 @@ void prune_icache_sb(struct super_block *sb, int nr_to_scan)
 
 static void __wait_on_freeing_inode(struct inode *inode);
 /*
- * Called with the inode lock held.
+ * Called with the inode_hash_lock held.
  */
 static struct inode *find_inode(struct super_block *sb,
 				struct hlist_head *head,
diff --git a/fs/namei.c b/fs/namei.c
index 5ffd97d..7b1f714 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -421,7 +421,7 @@ EXPORT_SYMBOL(path_put);
  * Path walking has 2 modes, rcu-walk and ref-walk (see
  * Documentation/filesystems/path-lookup.txt).  In situations when we can't
  * continue in RCU mode, we attempt to drop out of rcu-walk mode and grab
- * normal reference counts on dentries and vfsmounts to transition to rcu-walk
+ * normal reference counts on dentries and vfsmounts to transition to ref-walk
  * mode.  Refcounts are grabbed at the last known good point before rcu-walk
  * got stuck, so ref-walk may continue from there. If this is not successful
  * (eg. a seqcount has changed), then failure is returned and it's up to caller
diff --git a/fs/namespace.c b/fs/namespace.c
index ca2b6e9..b7477ee 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1239,9 +1239,6 @@ static inline bool path_unmounted(struct path *path)
 }
 
 /*
- * Now umount can handle mount points as well as block devices.
- * This is important for filesystems which use unnamed block devices.
- *
  * We now support a flag for forced unmount like the other 'big iron'
  * unixes. Our API is identical to OSF/1 to avoid making a mess of AMD
  */
@@ -1431,9 +1428,9 @@ static int invent_group_ids(struct mount *mnt, bool recurse)
 }
 
 /*
- *  @source_mnt : mount tree to be attached
- *  @nd         : place the mount tree @source_mnt is attached
- *  @parent_nd  : if non-null, detach the source_mnt from its parent and
+ *  @source_mnt  : mount tree to be attached
+ *  @path        : place the mount tree @source_mnt is attached
+ *  @parent_path : if non-null, detach the @source_mnt from its parent and
  *  		   store the parent mount and mountpoint dentry.
  *  		   (done when source_mnt is moved)
  *
-- 
1.7.9.5

