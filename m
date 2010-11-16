Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758607Ab0KPOX4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 09:23:56 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:32788 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758443Ab0KPOXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 09:23:51 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiQJAKMh4kx5Ldur/2dsb2JhbACVYYx9cr5mhUsEilg
Message-Id: <20101116142029.033776117@kernel.dk>
User-Agent: quilt/0.48-1
Date: Wed, 17 Nov 2010 01:09:09 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 09/28] hostfs: simplify locking
References: <20101116140900.039761100@kernel.dk>
Content-Disposition: inline; filename=hostfs-change.patch
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

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/dcache.c	2010-11-17 01:05:47.000000000 +1100
@@ -2140,7 +2140,7 @@ char *dynamic_dname(struct dentry *dentr
 /*
  * Write full pathname from the root of the filesystem into the buffer.
  */
-char *__dentry_path(struct dentry *dentry, char *buf, int buflen)
+static char *__dentry_path(struct dentry *dentry, char *buf, int buflen)
 {
 	char *end = buf + buflen;
 	char *retval;
@@ -2167,7 +2167,18 @@ char *__dentry_path(struct dentry *dentr
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
Index: linux-2.6/fs/hostfs/hostfs_kern.c
===================================================================
--- linux-2.6.orig/fs/hostfs/hostfs_kern.c	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/fs/hostfs/hostfs_kern.c	2010-11-17 00:52:37.000000000 +1100
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
@@ -123,25 +121,23 @@ static char *dentry_name(struct dentry *
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
Index: linux-2.6/include/linux/dcache.h
===================================================================
--- linux-2.6.orig/include/linux/dcache.h	2010-11-17 00:52:37.000000000 +1100
+++ linux-2.6/include/linux/dcache.h	2010-11-17 01:05:47.000000000 +1100
@@ -309,7 +309,7 @@ extern char *dynamic_dname(struct dentry
 extern char *__d_path(const struct path *path, struct path *root, char *, int);
 extern char *d_path(const struct path *, char *, int);
 extern char *d_path_with_unreachable(const struct path *, char *, int);
-extern char *__dentry_path(struct dentry *, char *, int);
+extern char *dentry_path_raw(struct dentry *, char *, int);
 extern char *dentry_path(struct dentry *, char *, int);
 
 /* Allocation counts.. */


