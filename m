Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561Ab2AIRQp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 12:16:45 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:57665
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932266Ab2AIRQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 12:16:43 -0500
Date: Mon, 9 Jan 2012 12:16:39 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, gregkh@suse.de,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        david@fromorbit.com
Subject: Re: [RFC PATCH] shrink_dcache_parent() deadlock
Message-ID: <20120109171639.GA9359@infradead.org>
References: <87ipkl87m9.fsf@tucsk.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ipkl87m9.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave's patch from August in which removes the whole select_parent lru abuse
should fix this to, and actually clean up that area.  It will probably
need a rebase as it was near the end of a larger series.  We probably
want the patch directly following it in the series, too.

---
From:	Dave Chinner <david@fromorbit.com>
Subject: [PATCH 11/13] dcache: use a dispose list in select_parent

From: Dave Chinner <dchinner@redhat.com>

select_parent currently abuses the dentry cache LRU to provide
cleanup features for child dentries that need to be freed. It moves
them to the tail of the LRU, then tells shrink_dcache_parent() to
calls __shrink_dcache_sb to unconditionally move them to a dispose
list (as DCACHE_REFERENCED is ignored). __shrink_dcache_sb() has to
relock the dentries to move them off the LRU onto the dispose list,
but otherwise does not touch the dentries that select_parent() moved
to the tail of the LRU. It then passses the dispose list to
shrink_dentry_list() which tries to free the dentries.

IOWs, the use of __shrink_dcache_sb() is superfluous - we can build
exactly the same list of dentries for disposal directly in
select_parent() and call shrink_dentry_list() instead of calling
__shrink_dcache_sb() to do that. This means that we avoid long holds
on the lru lock walking the LRU moving dentries to the dispose list
We also avoid the need to relock each dentry just to move it off the
LRU, reducing the numebr of times we lock each dentry to dispose of
them in shrink_dcache_parent() from 3 to 2 times.

Further, we remove one of the two callers of __shrink_dcache_sb().
This also means that __shrink_dcache_sb can be moved into back into
prune_dcache_sb() and we no longer have to handle referenced
dentries conditionally, simplifying the code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/dcache.c |   65 ++++++++++++++++++++---------------------------------------
 1 files changed, 22 insertions(+), 43 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index d19e453..b931415 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -264,15 +264,15 @@ static void dentry_lru_del(struct dentry *dentry)
 	}
 }
 
-static void dentry_lru_move_tail(struct dentry *dentry)
+static void dentry_lru_move_list(struct dentry *dentry, struct list_head *list)
 {
 	spin_lock(&dentry->d_sb->s_dentry_lru_lock);
 	if (list_empty(&dentry->d_lru)) {
-		list_add_tail(&dentry->d_lru, &dentry->d_sb->s_dentry_lru);
+		list_add_tail(&dentry->d_lru, list);
 		dentry->d_sb->s_nr_dentry_unused++;
 		this_cpu_inc(nr_dentry_unused);
 	} else {
-		list_move_tail(&dentry->d_lru, &dentry->d_sb->s_dentry_lru);
+		list_move_tail(&dentry->d_lru, list);
 	}
 	spin_unlock(&dentry->d_sb->s_dentry_lru_lock);
 }
@@ -752,14 +752,18 @@ static void shrink_dentry_list(struct list_head *list)
 }
 
 /**
- * __shrink_dcache_sb - shrink the dentry LRU on a given superblock
- * @sb:		superblock to shrink dentry LRU.
- * @count:	number of entries to prune
- * @flags:	flags to control the dentry processing
+ * prune_dcache_sb - shrink the dcache
+ * @sb: superblock
+ * @nr_to_scan: number of entries to try to free
+ *
+ * Attempt to shrink the superblock dcache LRU by @nr_to_scan entries. This is
+ * done when we need more memory an called from the superblock shrinker
+ * function.
  *
- * If flags contains DCACHE_REFERENCED reference dentries will not be pruned.
+ * This function may fail to free any resources if all the dentries are in
+ * use.
  */
-static long __shrink_dcache_sb(struct super_block *sb, long count, int flags)
+long prune_dcache_sb(struct super_block *sb, long nr_to_scan)
 {
 	struct dentry *dentry;
 	LIST_HEAD(referenced);
@@ -779,13 +783,7 @@ relock:
 			goto relock;
 		}
 
-		/*
-		 * If we are honouring the DCACHE_REFERENCED flag and the
-		 * dentry has this flag set, don't free it.  Clear the flag
-		 * and put it back on the LRU.
-		 */
-		if (flags & DCACHE_REFERENCED &&
-				dentry->d_flags & DCACHE_REFERENCED) {
+		if (dentry->d_flags & DCACHE_REFERENCED) {
 			dentry->d_flags &= ~DCACHE_REFERENCED;
 			list_move(&dentry->d_lru, &referenced);
 			spin_unlock(&dentry->d_lock);
@@ -793,7 +791,7 @@ relock:
 			list_move_tail(&dentry->d_lru, &tmp);
 			spin_unlock(&dentry->d_lock);
 			freed++;
-			if (!--count)
+			if (!--nr_to_scan)
 				break;
 		}
 		cond_resched_lock(&sb->s_dentry_lru_lock);
@@ -807,23 +805,6 @@ relock:
 }
 
 /**
- * prune_dcache_sb - shrink the dcache
- * @sb: superblock
- * @nr_to_scan: number of entries to try to free
- *
- * Attempt to shrink the superblock dcache LRU by @nr_to_scan entries. This is
- * done when we need more memory an called from the superblock shrinker
- * function.
- *
- * This function may fail to free any resources if all the dentries are in
- * use.
- */
-long prune_dcache_sb(struct super_block *sb, long nr_to_scan)
-{
-	return __shrink_dcache_sb(sb, nr_to_scan, DCACHE_REFERENCED);
-}
-
-/**
  * shrink_dcache_sb - shrink dcache for a superblock
  * @sb: superblock
  *
@@ -1073,7 +1054,7 @@ EXPORT_SYMBOL(have_submounts);
  * drop the lock and return early due to latency
  * constraints.
  */
-static long select_parent(struct dentry * parent)
+static long select_parent(struct dentry *parent, struct list_head *dispose)
 {
 	struct dentry *this_parent;
 	struct list_head *next;
@@ -1095,12 +1076,11 @@ resume:
 
 		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
 
-		/* 
-		 * move only zero ref count dentries to the end 
-		 * of the unused list for prune_dcache
+		/*
+		 * move only zero ref count dentries to the dispose list.
 		 */
 		if (!dentry->d_count) {
-			dentry_lru_move_tail(dentry);
+			dentry_lru_move_list(dentry, dispose);
 			found++;
 		} else {
 			dentry_lru_del(dentry);
@@ -1162,14 +1142,13 @@ rename_retry:
  *
  * Prune the dcache to remove unused children of the parent dentry.
  */
- 
 void shrink_dcache_parent(struct dentry * parent)
 {
-	struct super_block *sb = parent->d_sb;
+	LIST_HEAD(dispose);
 	long found;
 
-	while ((found = select_parent(parent)) != 0)
-		__shrink_dcache_sb(sb, found, 0);
+	while ((found = select_parent(parent, &dispose)) != 0)
+		shrink_dentry_list(&dispose);
 }
 EXPORT_SYMBOL(shrink_dcache_parent);
 
-- 
1.7.5.4

--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

