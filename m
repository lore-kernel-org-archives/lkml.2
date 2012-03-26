Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389Ab2CZKyW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 06:54:22 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:47445 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757359Ab2CZKyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 06:54:16 -0400
MIME-Version: 1.0
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, mszeredi@suse.cz
Subject: [PATCH 6/6] vfs: split __lookup_hash
Date: Mon, 26 Mar 2012 12:54:24 +0200
Message-Id: <1332759264-23533-7-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332759264-23533-1-git-send-email-miklos@szeredi.hu>
References: <1332759264-23533-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Split __lookup_hash into two component functions:

 lookup_dcache - tries cached lookup, returns whether real lookup is needed
 lookup_real - calls i_op->lookup

This eliminates code duplication between d_alloc_and_lookup() and
d_inode_lookup().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c |  103 +++++++++++++++++++++++++----------------------------------
 1 files changed, 44 insertions(+), 59 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index d500cb0..d15d0ba 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1058,53 +1058,65 @@ static void follow_dotdot(struct nameidata *nd)
 }
 
 /*
- * Allocate a dentry with name and parent, and perform a parent
- * directory ->lookup on it. Returns the new dentry, or ERR_PTR
- * on error. parent->d_inode->i_mutex must be held. d_lookup must
- * have verified that no child exists while under i_mutex.
+ * This looks up the name in dcache, possibly revalidates the old dentry and
+ * allocates a new one if not found or not valid.  In the need_lookup argument
+ * returns whether i_op->lookup is necessary.
+ *
+ * dir->d_inode->i_mutex must be held
  */
-static struct dentry *d_alloc_and_lookup(struct dentry *parent,
-				struct qstr *name, struct nameidata *nd)
+static struct dentry *lookup_dcache(struct qstr *name, struct dentry *dir,
+				    struct nameidata *nd, bool *need_lookup)
 {
-	struct inode *inode = parent->d_inode;
 	struct dentry *dentry;
-	struct dentry *old;
+	int error;
 
-	/* Don't create child dentry for a dead directory. */
-	if (unlikely(IS_DEADDIR(inode)))
-		return ERR_PTR(-ENOENT);
+	*need_lookup = false;
+	dentry = d_lookup(dir, name);
+	if (dentry) {
+		if (d_need_lookup(dentry)) {
+			*need_lookup = true;
+		} else if (dentry->d_flags & DCACHE_OP_REVALIDATE) {
+			error = d_revalidate(dentry, nd);
+			if (unlikely(error <= 0)) {
+				if (error < 0) {
+					dput(dentry);
+					return ERR_PTR(error);
+				} else if (!d_invalidate(dentry)) {
+					dput(dentry);
+					dentry = NULL;
+				}
+			}
+		}
+	}
 
-	dentry = d_alloc(parent, name);
-	if (unlikely(!dentry))
-		return ERR_PTR(-ENOMEM);
+	if (!dentry) {
+		dentry = d_alloc(dir, name);
+		if (unlikely(!dentry))
+			return ERR_PTR(-ENOMEM);
 
-	old = inode->i_op->lookup(inode, dentry, nd);
-	if (unlikely(old)) {
-		dput(dentry);
-		dentry = old;
+		*need_lookup = true;
 	}
 	return dentry;
 }
 
 /*
- * We already have a dentry, but require a lookup to be performed on the parent
- * directory to fill in d_inode. Returns the new dentry, or ERR_PTR on error.
- * parent->d_inode->i_mutex must be held. d_lookup must have verified that no
- * child exists while under i_mutex.
+ * Call i_op->lookup on the dentry.  The dentry must be negative but may be
+ * hashed if it was pouplated with DCACHE_NEED_LOOKUP.
+ *
+ * dir->d_inode->i_mutex must be held
  */
-static struct dentry *d_inode_lookup(struct dentry *parent, struct dentry *dentry,
-				     struct nameidata *nd)
+static struct dentry *lookup_real(struct inode *dir, struct dentry *dentry,
+				  struct nameidata *nd)
 {
-	struct inode *inode = parent->d_inode;
 	struct dentry *old;
 
 	/* Don't create child dentry for a dead directory. */
-	if (unlikely(IS_DEADDIR(inode))) {
+	if (unlikely(IS_DEADDIR(dir))) {
 		dput(dentry);
 		return ERR_PTR(-ENOENT);
 	}
 
-	old = inode->i_op->lookup(inode, dentry, nd);
+	old = dir->i_op->lookup(dir, dentry, nd);
 	if (unlikely(old)) {
 		dput(dentry);
 		dentry = old;
@@ -1115,41 +1127,14 @@ static struct dentry *d_inode_lookup(struct dentry *parent, struct dentry *dentr
 static struct dentry *__lookup_hash(struct qstr *name, struct dentry *base,
 				    struct nameidata *nd)
 {
+	bool need_lookup;
 	struct dentry *dentry;
 
-	dentry = d_lookup(base, name);
-
-	if (dentry && d_need_lookup(dentry)) {
-		/*
-		 * __lookup_hash is called with the parent dir's i_mutex already
-		 * held, so we are good to go here.
-		 */
-		return d_inode_lookup(base, dentry, nd);
-	}
+	dentry = lookup_dcache(name, base, nd, &need_lookup);
+	if (!need_lookup)
+		return dentry;
 
-	if (dentry && (dentry->d_flags & DCACHE_OP_REVALIDATE)) {
-		int status = d_revalidate(dentry, nd);
-		if (unlikely(status <= 0)) {
-			/*
-			 * The dentry failed validation.
-			 * If d_revalidate returned 0 attempt to invalidate
-			 * the dentry otherwise d_revalidate is asking us
-			 * to return a fail status.
-			 */
-			if (status < 0) {
-				dput(dentry);
-				return ERR_PTR(status);
-			} else if (!d_invalidate(dentry)) {
-				dput(dentry);
-				dentry = NULL;
-			}
-		}
-	}
-
-	if (!dentry)
-		dentry = d_alloc_and_lookup(base, name, nd);
-
-	return dentry;
+	return lookup_real(base->d_inode, dentry, nd);
 }
 
 /*
-- 
1.7.7

