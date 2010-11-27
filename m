Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab0K0KeW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 05:34:22 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:34780 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752592Ab0K0K0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 05:26:01 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAO1p8Ex5Lcx2/2dsb2JhbACjC3K9doVHBIph
Message-Id: <00ae02ad2dc603cf4346d6d79b8960e3e9a87b50.1290852959.git.npiggin@kernel.dk>
In-Reply-To: <cover.1290852958.git.npiggin@kernel.dk>
References: <cover.1290852958.git.npiggin@kernel.dk>
From: Nick Piggin <npiggin@kernel.dk>
Date: Sat, 27 Nov 2010 20:44:40 +1100
Subject: [PATCH 10/46] hostfs: simplify locking
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove dcache_lock locking from hostfs filesystem, and move it into dcache
helpers. All that should really be required is a coherent path name, protection
from concurrent modification is not provided outside path name generation
because dcache_lock is dropped before the path is used.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>
---
 fs/dcache.c             |   15 +++++++++++++--
 fs/hostfs/hostfs_kern.c |   24 ++++++++++--------------
 include/linux/dcache.h  |    2 +-
 3 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 9fd5180..4f9ccbe 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2140,7 +2140,7 @@ char *dynamic_dname(struct dentry *dentry, char *buffer, int buflen,
 /*
  * Write full pathname from the root of the filesystem into the buffer.
  */
-char *__dentry_path(struct dentry *dentry, char *buf, int buflen)
+static char *__dentry_path(struct dentry *dentry, char *buf, int buflen)
 {
 	char *end = buf + buflen;
 	char *retval;
@@ -2167,7 +2167,18 @@ char *__dentry_path(struct dentry *dentry, char *buf, int buflen)
 Elong:
 	return ERR_PTR(-ENAMETOOLONG);
 }
-EXPORT_SYMBOL(__dentry_path);
+
+char *dentry_path_raw(struct dentry *dentry, char *buf, int buflen)
+{
+	char *retval;
+
+	spin_lock(&dcache_lock);
+	retval = __dentry_path(dentry, buf, buflen);
+	spin_unlock(&dcache_lock);
+
+	return retval;
+}
+EXPORT_SYMBOL(dentry_path_raw);
 
 char *dentry_path(struct dentry *dentry, char *buf, int buflen)
 {
diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index cfe8bc7..39dc505 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -92,12 +92,10 @@ __uml_setup("hostfs=", hostfs_args,
 
 static char *__dentry_name(struct dentry *dentry, char *name)
 {
-	char *p = __dentry_path(dentry, name, PATH_MAX);
+	char *p = dentry_path_raw(dentry, name, PATH_MAX);
 	char *root;
 	size_t len;
 
-	spin_unlock(&dcache_lock);
-
 	root = dentry->d_sb->s_fs_info;
 	len = strlen(root);
 	if (IS_ERR(p)) {
@@ -123,25 +121,23 @@ static char *dentry_name(struct dentry *dentry)
 	if (!name)
 		return NULL;
 
-	spin_lock(&dcache_lock);
 	return __dentry_name(dentry, name); /* will unlock */
 }
 
 static char *inode_name(struct inode *ino)
 {
 	struct dentry *dentry;
-	char *name = __getname();
-	if (!name)
-		return NULL;
+	char *name;
 
-	spin_lock(&dcache_lock);
-	if (list_empty(&ino->i_dentry)) {
-		spin_unlock(&dcache_lock);
-		__putname(name);
+	dentry = d_find_alias(ino);
+	if (!dentry)
 		return NULL;
-	}
-	dentry = list_first_entry(&ino->i_dentry, struct dentry, d_alias);
-	return __dentry_name(dentry, name); /* will unlock */
+
+	name = dentry_name(dentry);
+
+	dput(dentry);
+
+	return name;
 }
 
 static char *follow_link(char *link)
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 4ef2af7..6b5760b 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -309,7 +309,7 @@ extern char *dynamic_dname(struct dentry *, char *, int, const char *, ...);
 extern char *__d_path(const struct path *path, struct path *root, char *, int);
 extern char *d_path(const struct path *, char *, int);
 extern char *d_path_with_unreachable(const struct path *, char *, int);
-extern char *__dentry_path(struct dentry *, char *, int);
+extern char *dentry_path_raw(struct dentry *, char *, int);
 extern char *dentry_path(struct dentry *, char *, int);
 
 /* Allocation counts.. */
-- 
1.7.1

