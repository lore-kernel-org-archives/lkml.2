Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab2BUTM7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 14:12:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754793Ab2BUTLC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:11:02 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 48/73] union-mount: Add wrapper for lookup_union_locked() and
 RCU hook [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com> (Further development)
Date: Tue, 21 Feb 2012 18:03:30 +0000
Message-ID: <20120221180330.25235.88964.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a wrapper function for lookup_union_locked() that locks the parent
directory and follows the mount after lookup.  This is appropriate for calling
from do_lookup() when in refwalk mode.

Also add an RCU-mode pathwalk lookup function.  This need not leave RCU-mode if
the upper dentry is appropriately assembled or the lower dentry can be validly
used.

Original-author: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com> (Further development)
---

 fs/namei.c |  149 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 147 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 2d69ce1..c0adf4c 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1195,6 +1195,9 @@ static int __lookup_union(struct nameidata *nd, struct qstr *name,
 		 * layer's directory to the union stack for the topmost
 		 * directory.
 		 */
+#warning what if the directory is managed?
+#warning should we d_revalidate the lower dentry?
+#warning how to handle automounts?
 		follow_mount(&lower);
 
 		if (!topmost->dentry->d_inode) {
@@ -1277,6 +1280,144 @@ static int lookup_union_locked(struct nameidata *nd, struct qstr *name,
 }
 
 /*
+ * lookup_union - union mount-aware part of do_lookup()
+ *
+ * do_lookup()-style wrapper for lookup_union().  Follows mounts.
+ */
+static int lookup_union(struct nameidata *nd, struct qstr *name,
+			struct path *topmost)
+{
+	struct dentry *parent = nd->path.dentry;
+	struct inode *dir = parent->d_inode;
+	int err;
+
+	mutex_lock(&dir->i_mutex);
+	err = lookup_union_locked(nd, name, topmost);
+	mutex_unlock(&dir->i_mutex);
+	if (err)
+		return err;
+
+	return follow_managed(topmost, nd->flags);
+}
+
+/*
+ * lookup_union_rcu - Handle union mounted dentries in RCU-walk mode
+ * @nd: The current pathwalk state (refers to @parent currently)
+ * @parent: The parent directory (holds the union stack)
+ * @path: The point just looked up in @parent
+ * @parent_seq: The d_seq of @parent at the point of lookup
+ * @inode: The inode at @dentry (*@inode is NULL if negative dentry)
+ *
+ * Handle a dentry that represents a non-directory file or a hole/reference in
+ * a union mount upperfs.  This involves transiting to the lower file, provided
+ * we aren't going to open the lower file for writing - otherwise we have to
+ * copy the file up (which we can't do in rcuwalk mode).
+ *
+ * Directories are handled differently: they're unconditionally and completely
+ * mirrored from the lowerfs to the upperfs as soon as we encounter them in a
+ * lookup.  However, since we don't create dentries in rcuwalk mode, this will
+ * be handled automatically by refwalk mode.
+ *
+ * We return true if we don't need to do anything or if we've successfully
+ * updated the path.  If we need to drop out of RCU-walk and go to refwalk
+ * mode, we return false.
+ */
+static bool lookup_union_rcu(struct nameidata *nd,
+			     struct dentry *parent,
+			     struct path *path,
+			     unsigned parent_seq,
+			     struct inode **inode)
+{
+	struct dentry *dentry = path->dentry;
+	struct inode *parent_inode = nd->inode;
+	unsigned layer, layers;
+
+	/* Handle non-unionmount dentries first.  The union stack will have
+	 * been built during the initial lookup of the parent dir, so if it's
+	 * not there, it's not unioned.
+	 */
+	if (!IS_DIR_UNIONED(parent))
+		return true;
+
+	/* If it's positive then no further lookup is needed: the file or
+	 * directory has been copied up and the user gets to play with that.
+	 */
+	if (*inode)
+		return true;
+
+	/* If this dentry is a blocker, then stop here. */
+	if (d_is_whiteout(dentry) ||
+	    (IS_OPAQUE(parent_inode) && !d_is_fallthru(dentry)))
+		return true;
+
+	/* At this point we have a negative dentry in the unionmount that may
+	 * be overlaying a non-directory file in a lower filesystem, so we loop
+	 * through the union stack of the parent directory to try to find a
+	 * usable dentry further down.
+	 */
+	layers = parent->d_sb->s_union_count;
+	for (layer = 0; layer < layers; layer++) {
+		/* Look for the a matching dentry in this layer, assuming it's
+		 * still valid.  Since the lower fs is hard locked R/O,
+		 * revalidation ought to be unnecessary.
+		 */
+		unsigned ldseq, seq;
+		struct dentry *lower_dir, *lower;
+		struct path *lower_path = union_find_dir(parent, layer);
+		if (!lower_path->mnt)
+			continue;
+
+		lower_dir = lower_path->dentry;
+		ldseq = read_seqcount_begin(&lower_dir->d_seq);
+
+		if (unlikely(lower_dir->d_flags & DCACHE_OP_REVALIDATE)) {
+			if (unlikely(d_revalidate(lower_dir, nd) <= 0) ||
+			    __read_seqcount_retry(&lower_dir->d_seq, ldseq))
+				return false;
+		}
+
+		lower = __d_lookup_rcu(lower_dir, &dentry->d_name, &seq, inode);
+		if (!lower)
+			return false;
+
+		/* We've got a negative dentry which can mean several things: a
+		 * plain negative dentry is ignored and lookup continues to the
+		 * next layer; but a whiteout or a non-fallthru in an opaque
+		 * dir covers everything below it.
+		 */
+		if (!*inode) {
+			if (d_is_whiteout(lower) ||
+			    (IS_OPAQUE(parent_inode) && !d_is_fallthru(lower))) {
+				if (read_seqcount_retry(&lower_dir->d_seq,
+							ldseq))
+					return false;
+				return true;
+			}
+			continue;
+		}
+
+		/* If the lower dentry is a directory then it will need copying
+		 * up before we can make use of it.
+		 */
+		if (S_ISDIR((*inode)->i_mode))
+			return false;
+
+		/* We have a file in a lower fs that we can use */
+		if (read_seqcount_retry(&lower_dir->d_seq, ldseq) ||
+		    __read_seqcount_retry(&parent->d_seq, parent_seq))
+			return false;
+
+		path->mnt = lower_path->mnt;
+		path->dentry = lower;
+		nd->seq = seq;
+		return true;
+	}
+
+	/* Found nothing, so just use the top negative dentry */
+	return dentry;
+}
+
+/*
  * Allocate a dentry with name and parent, and perform a parent
  * directory ->lookup on it. Returns the new dentry, or ERR_PTR
  * on error. parent->d_inode->i_mutex must be held. d_lookup must
@@ -1351,14 +1492,15 @@ static int do_lookup(struct nameidata *nd, struct qstr *name,
 	 * do the non-racy lookup, below.
 	 */
 	if (nd->flags & LOOKUP_RCU) {
-		unsigned seq;
+		unsigned seq, pseq;
 		*inode = nd->inode;
 		dentry = __d_lookup_rcu(parent, name, &seq, inode);
 		if (!dentry)
 			goto unlazy;
 
 		/* Memory barrier in read_seqcount_begin of child is enough */
-		if (__read_seqcount_retry(&parent->d_seq, nd->seq))
+		pseq = nd->seq;
+		if (__read_seqcount_retry(&parent->d_seq, pseq))
 			return -ECHILD;
 		nd->seq = seq;
 
@@ -1372,8 +1514,11 @@ static int do_lookup(struct nameidata *nd, struct qstr *name,
 		}
 		if (unlikely(d_need_lookup(dentry)))
 			goto unlazy;
+
 		path->mnt = mnt;
 		path->dentry = dentry;
+		if (unlikely(!lookup_union_rcu(nd, parent, path, pseq, inode)))
+			goto unlazy;
 		if (unlikely(!__follow_mount_rcu(nd, path, inode)))
 			goto unlazy;
 		if (unlikely(path->dentry->d_flags & DCACHE_NEED_AUTOMOUNT))

