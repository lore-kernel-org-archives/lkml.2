Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587Ab1JJQTq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 12:19:46 -0400
Received: from cobra.newdream.net ([66.33.216.30]:48661 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab1JJQTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 12:19:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=newdream.net; h=date:from:to:cc
	:subject:in-reply-to:message-id:references:mime-version:
	content-type; q=dns; s=newdream.net; b=2wVr4pct1rORCDygCIbX6Qep6
	lnU/ulqAXcJf0LKqAFLrWNUby04c+0j/lCgzuoXgnE6YAkj9JSX0J/TIYk964BKW
	LUeycBugJ+Pd9gIUxwmCyQuUqvvCbOCXDlKFmKeZTESqkOmZeWVzHdoLErYSugk4
	JChrQp16gbAqKDLOT4=
Date: Mon, 10 Oct 2011 09:19:43 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Dave Chinner <david@fromorbit.com>
cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        viro@ZenIV.linux.org.uk, ceph-devel@vger.kernel.org,
        rwheeler@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: add d_prune dentry operation
In-Reply-To: <20111010051141.GV3159@dastard>
Message-ID: <Pine.LNX.4.64.1110100850020.26361@cobra.newdream.net>
References: <1317875170-9349-1-git-send-email-sage@newdream.net>
 <1317875170-9349-2-git-send-email-sage@newdream.net> <20111006212118.GA24109@infradead.org>
 <Pine.LNX.4.64.1110061507550.29500@cobra.newdream.net> <20111010051141.GV3159@dastard>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Oct 2011, Dave Chinner wrote:
> On Thu, Oct 06, 2011 at 03:20:37PM -0700, Sage Weil wrote:
> > On Thu, 6 Oct 2011, Christoph Hellwig wrote:
> > > On Wed, Oct 05, 2011 at 09:26:10PM -0700, Sage Weil wrote:
> > > > This adds a d_prune dentry operation that is called by the VFS prior to
> > > > pruning (i.e. unhashing and killing) a hashed dentry from the dcache.  This
> > > > will be used by Ceph to maintain a flag indicating whether the complete
> > > > contents of a directory are contained in the dcache, allowing it to satisfy
> > > > lookups and readdir without addition server communication.
> > > 
> > > What tree is the patch against?  I seems to fail to apply against Linus'
> > > latests.  
> > 
> > Whoops, I rebased against v3.0 instead of latest master.
> > 
> > > It also seem like it basically should not be be opencoded but in a
> > > wrapper around dentry_lru_del for all cases but the lazy removal from
> > > LRU in case that is referenced, with some comments explaining the whole
> > > thing.
> > 
> > Yeah, that's a bit better.  There are four dentry_lru_del() callers, two 
> > where we there is a reference, and two where we want to ->d_prune too.
> 
> The code in the patch doesn't explain to me why you'd need to call
> dentry_lru_prune() rather than dentry_lru_del()? It's something to
> do with the difference between active and inactive LRU removal, but
> I can't really tell. My patchset removes the LRU abuse from
> select_parent, so I'm kind of wondering what the correct thing is to
> do there. 
> 
> Hence, can you add a bit of documentation to those functions
> explaining why and when you should use one or the other?  i.e
> document the situations where the FS needs to be notified of
> pruning, rather than leaving anyone who is reading the code
> guessing.

Let me know if the below is clearer.  The requirement is that ->d_prune be 
called prior to unhashing (and then destroying) a victim dentry.  I'm a 
little worried about mixing that in with the lru helpers because it is 
only indirectly related to whether the dentry is on the LRU, and that may 
confuse people.  A cleaned up opencoded patch is here:

	https://github.com/NewDreamNetwork/ceph-client/commit/784a6aa6dc7baf2069c40988d79130dba17c7068

and the updated dentry_lru_prune() wrapper version is below.

Thanks-
sage



>From 619707e0b6fca69f165d1d4f048ab8211531d559 Mon Sep 17 00:00:00 2001
From: Sage Weil <sage@newdream.net>
Date: Mon, 10 Oct 2011 09:18:16 -0700
Subject: [PATCH] vfs: add d_prune dentry operation

This adds a d_prune dentry operation that is called by the VFS prior to
pruning (i.e. unhashing and killing) a hashed dentry from the dcache.
Wrap dentry_lru_del() and use the new _prune() helper in the cases where we
are about to unhash and kill the dentry.

This will be used by Ceph to maintain a flag indicating whether the
complete contents of a directory are contained in the dcache, allowing it
to satisfy lookups and readdir without addition server communication.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 Documentation/filesystems/Locking |    1 +
 fs/dcache.c                       |   40 ++++++++++++++++++++++++++++++++----
 include/linux/dcache.h            |    3 ++
 3 files changed, 39 insertions(+), 5 deletions(-)

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index 6533807..d819ba1 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -29,6 +29,7 @@ d_hash		no		no		no		maybe
 d_compare:	yes		no		no		maybe
 d_delete:	no		yes		no		no
 d_release:	no		no		yes		no
+d_prune:        no              yes             no              no
 d_iput:		no		no		yes		no
 d_dname:	no		no		no		no
 d_automount:	no		no		yes		no
diff --git a/fs/dcache.c b/fs/dcache.c
index a88948b..274f13e 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -225,7 +225,7 @@ static void dentry_unlink_inode(struct dentry * dentry)
 }
 
 /*
- * dentry_lru_(add|del|move_tail) must be called with d_lock held.
+ * dentry_lru_(add|del|prune|move_tail) must be called with d_lock held.
  */
 static void dentry_lru_add(struct dentry *dentry)
 {
@@ -245,6 +245,9 @@ static void __dentry_lru_del(struct dentry *dentry)
 	dentry_stat.nr_unused--;
 }
 
+/*
+ * Remove a dentry with references from the LRU.
+ */
 static void dentry_lru_del(struct dentry *dentry)
 {
 	if (!list_empty(&dentry->d_lru)) {
@@ -254,6 +257,23 @@ static void dentry_lru_del(struct dentry *dentry)
 	}
 }
 
+/*
+ * Remove a dentry that is unreferenced and about to be pruned
+ * (unhashed and destroyed) from the LRU, and inform the file system.
+ * This wrapper should be called _prior_ to unhashing a victim dentry.
+ */
+static void dentry_lru_prune(struct dentry *dentry)
+{
+	if (!list_empty(&dentry->d_lru)) {
+		if (dentry->d_flags & DCACHE_OP_PRUNE)
+			dentry->d_op->d_prune(dentry);
+
+		spin_lock(&dcache_lru_lock);
+		__dentry_lru_del(dentry);
+		spin_unlock(&dcache_lru_lock);
+	}
+}
+
 static void dentry_lru_move_tail(struct dentry *dentry)
 {
 	spin_lock(&dcache_lru_lock);
@@ -403,8 +423,12 @@ relock:
 
 	if (ref)
 		dentry->d_count--;
-	/* if dentry was on the d_lru list delete it from there */
-	dentry_lru_del(dentry);
+	/*
+	 * if dentry was on the d_lru list delete it from there.
+	 * inform the fs via d_prune that this dentry is about to be
+	 * unhashed and destroyed.
+	 */
+	dentry_lru_prune(dentry);
 	/* if it was on the hash then remove it */
 	__d_drop(dentry);
 	return d_kill(dentry, parent);
@@ -854,8 +878,12 @@ static void shrink_dcache_for_umount_subtree(struct dentry *dentry)
 		do {
 			struct inode *inode;
 
-			/* detach from the system */
-			dentry_lru_del(dentry);
+			/*
+			 * remove the dentry from the lru, and inform
+			 * the fs that this dentry is about to be
+			 * unhashed and destroyed.
+			 */
+			dentry_lru_prune(dentry);
 			__d_shrink(dentry);
 
 			if (dentry->d_count != 0) {
@@ -1283,6 +1311,8 @@ void d_set_d_op(struct dentry *dentry, const struct dentry_operations *op)
 		dentry->d_flags |= DCACHE_OP_REVALIDATE;
 	if (op->d_delete)
 		dentry->d_flags |= DCACHE_OP_DELETE;
+	if (op->d_prune)
+		dentry->d_flags |= DCACHE_OP_PRUNE;
 
 }
 EXPORT_SYMBOL(d_set_d_op);
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 62157c0..69ee43a 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -165,6 +165,7 @@ struct dentry_operations {
 			unsigned int, const char *, const struct qstr *);
 	int (*d_delete)(const struct dentry *);
 	void (*d_release)(struct dentry *);
+	void (*d_prune)(struct dentry *);
 	void (*d_iput)(struct dentry *, struct inode *);
 	char *(*d_dname)(struct dentry *, char *, int);
 	struct vfsmount *(*d_automount)(struct path *);
@@ -216,6 +217,8 @@ struct dentry_operations {
 #define DCACHE_MANAGED_DENTRY \
 	(DCACHE_MOUNTED|DCACHE_NEED_AUTOMOUNT|DCACHE_MANAGE_TRANSIT)
 
+#define DCACHE_OP_PRUNE         0x80000
+
 extern seqlock_t rename_lock;
 
 static inline int dname_external(struct dentry *dentry)
-- 
1.7.0

