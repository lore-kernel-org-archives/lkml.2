Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab2BUTyF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 14:54:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755160Ab2BUTx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:53:56 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 58/73] unionmount: Add LOOKUP_COPY_UP [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 21 Feb 2012 18:04:46 +0000
Message-ID: <20120221180446.25235.25330.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add LOOKUP_COPY_UP as a pathwalk flag to indicate that if we hit a file on a
lower layer in the union, we definitely want it copying up.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/namei.c            |   23 +++++++++++++++++++++--
 fs/union.h            |   12 ++++++++++--
 include/linux/namei.h |    1 +
 3 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index be505cd..6ec5725 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1214,6 +1214,16 @@ static int __lookup_union(struct nameidata *nd, struct qstr *name,
 	return 0;
 
 out_found_file:
+	/* If the caller demands a top-level dentry then we have to copy up. */
+	if (nd->flags & LOOKUP_COPY_UP) {
+		nd->path = parent;
+		err = union_copyup_file(nd, &lower, topmost->dentry,
+					i_size_read(lower.dentry->d_inode));
+		if (err)
+			goto out_err;
+		goto out_lookup_done;
+	}
+
 	/* Swap out the positive lower dentry with the negative upper
 	 * dentry for this file.  Note that the matching mntput() is done
 	 * in link_path_walk().
@@ -1350,6 +1360,15 @@ static bool lookup_union_rcu(struct nameidata *nd,
 	    (IS_OPAQUE(parent_inode) && !d_is_fallthru(dentry)))
 		return true;
 
+	/* The dentry is a fallthru in an opaque unioned directory.
+	 *
+	 * If the caller demands that the terminal dentry be instantiated in
+	 * the top layer of the union (copied up) immediately, that will
+	 * require a mutex.
+	 */
+	if (nd->flags & LOOKUP_COPY_UP)
+		return false;
+
 	/* At this point we have a negative dentry in the unionmount that may
 	 * be overlaying a non-directory file in a lower filesystem, so we loop
 	 * through the union stack of the parent directory to try to find a
@@ -1588,7 +1607,7 @@ retry:
 	if (err)
 		nd->flags |= LOOKUP_JUMPED;
 
-	if (needs_lookup_union(&nd->path, path)) {
+	if (needs_lookup_union(nd, &nd->path, path)) {
 		int err = lookup_union(nd, name, path);
 		if (err < 0)
 			return err;
@@ -2147,7 +2166,7 @@ static int lookup_hash(struct nameidata *nd, struct qstr *name,
 	path->mnt = nd->path.mnt;
 	path->dentry = result;
 
-	if (needs_lookup_union(&nd->path, path))
+	if (needs_lookup_union(nd, &nd->path, path))
 		return lookup_union_locked(nd, name, path);
 	return 0;
 }
diff --git a/fs/union.h b/fs/union.h
index 62d8ef5..5c4db67 100644
--- a/fs/union.h
+++ b/fs/union.h
@@ -92,7 +92,8 @@ struct path *union_find_dir(struct dentry *dentry, unsigned int layer)
  * dentry.
  */
 static inline
-bool needs_lookup_union(struct path *parent_path, struct path *path)
+bool needs_lookup_union(struct nameidata *nd,
+			struct path *parent_path, struct path *path)
 {
 	if (!IS_DIR_UNIONED(parent_path->dentry))
 		return false;
@@ -102,6 +103,12 @@ bool needs_lookup_union(struct path *parent_path, struct path *path)
 	if (IS_ROOT(path->dentry))
 		return false;
 
+	/* If this is a fallthru dentry and the caller requires the underlying
+	 * inode to be copied up, then do so.
+	 */
+	if (nd->flags & LOOKUP_COPY_UP && d_is_fallthru(path->dentry))
+		return true;
+
 	/* It's okay not to have the lock; will recheck in lookup_union() */
 	/* XXX set for root dentry at mount? */
 	return !(path->dentry->d_flags & DCACHE_UNION_LOOKUP_DONE);
@@ -134,7 +141,8 @@ static inline int union_create_topmost_dir(struct path *parent, struct qstr *nam
 	return 0;
 }
 
-static inline bool needs_lookup_union(struct path *parent_path, struct path *path)
+static inline bool needs_lookup_union(struct nameidata *nd,
+				      struct path *parent_path, struct path *path)
 {
 	return false;
 }
diff --git a/include/linux/namei.h b/include/linux/namei.h
index e273639..1736ece 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -65,6 +65,7 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT, LAST_BIND};
 #define LOOKUP_JUMPED		0x1000
 #define LOOKUP_ROOT		0x2000
 #define LOOKUP_EMPTY		0x4000
+#define LOOKUP_COPY_UP		0x8000 /* Copy up from lower mount if unionmounted */
 
 extern int user_path_at(int, const char __user *, unsigned, struct path *);
 extern int user_path_at_empty(int, const char __user *, unsigned, struct path *, int *empty);

