Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933048Ab1J1RCp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 13:02:45 -0400
Received: from cobra.newdream.net ([66.33.216.30]:47214 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932364Ab1J1RCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 13:02:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=newdream.net; h=date:from:to:cc
	:subject:in-reply-to:message-id:references:mime-version:
	content-type; q=dns; s=newdream.net; b=U8CW1OCk4qktCqxWIjHMfED4w
	4+cVGIWBOWp+t2VlUA6w0C9G5TzI6m2y7sfzJyzh4Hr7CNOn3dOEMH8EEcFuOag3
	LVhTFp8hZeCybKNuUL0oImGCzK0Ki5iHorVl/Zc/+Mr4PmP2iN4XeDUd9bT9X4Cg
	0GC3/oP4dv63KCfWro=
Date: Fri, 28 Oct 2011 10:02:42 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Christoph Hellwig <hch@infradead.org>
cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        viro@ZenIV.linux.org.uk, ceph-devel@vger.kernel.org,
        rwheeler@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: add d_prune dentry operation
In-Reply-To: <20111028121652.GA23417@infradead.org>
Message-ID: <Pine.LNX.4.64.1110280953470.28024@cobra.newdream.net>
References: <1317875170-9349-1-git-send-email-sage@newdream.net>
 <1317875170-9349-2-git-send-email-sage@newdream.net> <20111006212118.GA24109@infradead.org>
 <Pine.LNX.4.64.1110061507550.29500@cobra.newdream.net> <20111010051141.GV3159@dastard>
 <Pine.LNX.4.64.1110100850020.26361@cobra.newdream.net> <20111028121652.GA23417@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Oct 2011, Christoph Hellwig wrote:
> This variant seems to crash btrfs in xfstests 010:

This got rebased enough times that DCACHE_OP_PRUNE collided with 
DCACHE_NEEDS_LOOKUP.  The version below fixes that, and also renumbers a 
few of those constants to group it with the other DCACHE_OP_* guys.  I 
assume it's okay to switch those up?

sage


>From 2c39148ba12ce13442d66319f9d1ba91ce62974d Mon Sep 17 00:00:00 2001
From: Sage Weil <sage@newdream.net>
Date: Fri, 28 Oct 2011 09:55:21 -0700
Subject: [PATCH] vfs: add d_prune dentry operation

This adds a d_prune dentry operation that is called by the VFS prior to
pruning (i.e. unhashing and killing) a hashed dentry from the dcache.
Wrap dentry_lru_del() and use the new _prune() helper in the cases where we
are about to unhash and kill the dentry.

This will be used by Ceph to maintain a flag indicating whether the
complete contents of a directory are contained in the dcache, allowing it
to satisfy lookups and readdir without addition server communication.

Renumber a few DCACHE_* #defines to group DCACHE_OP_PRUNE with the other
DCACHE_OP_ bits.

Signed-off-by: Sage Weil <sage@newdream.net>
---

v4: fixed DCACHE_OP_PRUNE collision with DCACHE_NEEDS_LOOKUP.
v3: better comments for dentry_lru_{del,prune}
v2: move prune call into dentry_lru_prune() wrapper

 Documentation/filesystems/Locking |    1 +
 fs/dcache.c                       |   40 ++++++++++++++++++++++++++++++++----
 include/linux/dcache.h            |    8 ++++--
 3 files changed, 41 insertions(+), 8 deletions(-)

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
index 62157c0..4df9261 100644
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
@@ -184,8 +185,9 @@ struct dentry_operations {
 #define DCACHE_OP_COMPARE	0x0002
 #define DCACHE_OP_REVALIDATE	0x0004
 #define DCACHE_OP_DELETE	0x0008
+#define DCACHE_OP_PRUNE         0x0010
 
-#define	DCACHE_DISCONNECTED	0x0010
+#define	DCACHE_DISCONNECTED	0x0020
      /* This dentry is possibly not currently connected to the dcache tree, in
       * which case its parent will either be itself, or will have this flag as
       * well.  nfsd will not use a dentry with this bit set, but will first
@@ -196,8 +198,8 @@ struct dentry_operations {
       * dentry into place and return that dentry rather than the passed one,
       * typically using d_splice_alias. */
 
-#define DCACHE_REFERENCED	0x0020  /* Recently used, don't discard. */
-#define DCACHE_RCUACCESS	0x0040	/* Entry has ever been RCU-visible */
+#define DCACHE_REFERENCED	0x0040  /* Recently used, don't discard. */
+#define DCACHE_RCUACCESS	0x0080	/* Entry has ever been RCU-visible */
 
 #define DCACHE_CANT_MOUNT	0x0100
 #define DCACHE_GENOCIDE		0x0200
-- 
1.7.0

