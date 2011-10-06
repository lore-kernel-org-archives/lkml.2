Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965338Ab1JFWUk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 18:20:40 -0400
Received: from cobra.newdream.net ([66.33.216.30]:51925 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965292Ab1JFWUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 18:20:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=newdream.net; h=date:from:to:cc
	:subject:in-reply-to:message-id:references:mime-version:
	content-type; q=dns; s=newdream.net; b=z8hBTRoVI9fxdUJWPAasVY01p
	CaWeBCvPQV1qkeTGoQ8W14TkqcOaLXwyNhzEf/y254zSv3WxQhcJlTKHgxTrvVTc
	/NFPKgjl5LSg6lUVZYoPyoZRis25/tpRkFR+jlJzDagLpgMXBp3xd7ivCcHuwe+1
	9AFyrhhkPTTSoR5Am0=
Date: Thu, 6 Oct 2011 15:20:37 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Christoph Hellwig <hch@infradead.org>
cc: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        ceph-devel@vger.kernel.org, rwheeler@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: add d_prune dentry operation
In-Reply-To: <20111006212118.GA24109@infradead.org>
Message-ID: <Pine.LNX.4.64.1110061507550.29500@cobra.newdream.net>
References: <1317875170-9349-1-git-send-email-sage@newdream.net>
 <1317875170-9349-2-git-send-email-sage@newdream.net> <20111006212118.GA24109@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Oct 2011, Christoph Hellwig wrote:
> On Wed, Oct 05, 2011 at 09:26:10PM -0700, Sage Weil wrote:
> > This adds a d_prune dentry operation that is called by the VFS prior to
> > pruning (i.e. unhashing and killing) a hashed dentry from the dcache.  This
> > will be used by Ceph to maintain a flag indicating whether the complete
> > contents of a directory are contained in the dcache, allowing it to satisfy
> > lookups and readdir without addition server communication.
> 
> What tree is the patch against?  I seems to fail to apply against Linus'
> latests.  

Whoops, I rebased against v3.0 instead of latest master.

> It also seem like it basically should not be be opencoded but in a
> wrapper around dentry_lru_del for all cases but the lazy removal from
> LRU in case that is referenced, with some comments explaining the whole
> thing.

Yeah, that's a bit better.  There are four dentry_lru_del() callers, two 
where we there is a reference, and two where we want to ->d_prune too.

How does the below look?

Thanks!
sage


>From 182e20331b9b2be15dbecdff7465be26ac00a81c Mon Sep 17 00:00:00 2001
From: Sage Weil <sage@newdream.net>
Date: Thu, 6 Oct 2011 15:18:21 -0700
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
 fs/dcache.c                       |   33 ++++++++++++++++++++++++++++-----
 include/linux/dcache.h            |    3 +++
 3 files changed, 32 insertions(+), 5 deletions(-)

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
index a88948b..a348f64 100644
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
@@ -254,6 +254,24 @@ static void dentry_lru_del(struct dentry *dentry)
 	}
 }
 
+static void dentry_lru_prune(struct dentry *dentry)
+{
+	if (!list_empty(&dentry->d_lru)) {
+		/*
+		 * Notify the fs this dentry is about to be pruned
+		 * before removing from the LRU.  This should happen
+		 * before we unhash it (if it was hashed to begin
+		 * with).
+		 */
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
@@ -403,8 +421,11 @@ relock:
 
 	if (ref)
 		dentry->d_count--;
-	/* if dentry was on the d_lru list delete it from there */
-	dentry_lru_del(dentry);
+	/*
+	 * if dentry was on the d_lru list delete it from there and
+	 * inform the fs via d_prune.
+	 */
+	dentry_lru_prune(dentry);
 	/* if it was on the hash then remove it */
 	__d_drop(dentry);
 	return d_kill(dentry, parent);
@@ -854,8 +875,8 @@ static void shrink_dcache_for_umount_subtree(struct dentry *dentry)
 		do {
 			struct inode *inode;
 
-			/* detach from the system */
-			dentry_lru_del(dentry);
+			/* detach from the system, inform the fs via d_prune */
+			dentry_lru_prune(dentry);
 			__d_shrink(dentry);
 
 			if (dentry->d_count != 0) {
@@ -1283,6 +1304,8 @@ void d_set_d_op(struct dentry *dentry, const struct dentry_operations *op)
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

