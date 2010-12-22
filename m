Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab0LVRVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 12:21:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15870 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027Ab0LVRVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 12:21:49 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] CacheFiles: Add calls to path-based security hooks
To: jmorris@namei.org, viro@zeniv.linux.org.uk,
        penguin-kernel@I-love.SAKURA.ne.jp
Cc: tomoyo-users-en@lists.sourceforge.jp,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Wed, 22 Dec 2010 17:21:29 +0000
Message-ID: <20101222172129.30524.17341.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add calls to path-based security hooks into CacheFiles as, unlike inode-based
security, these aren't implicit in the vfs_mkdir() and similar calls.

Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> 
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/cachefiles/namei.c |   52 +++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 44 insertions(+), 8 deletions(-)

diff --git a/fs/cachefiles/namei.c b/fs/cachefiles/namei.c
index 42c7faf..a0358c2 100644
--- a/fs/cachefiles/namei.c
+++ b/fs/cachefiles/namei.c
@@ -275,6 +275,7 @@ static int cachefiles_bury_object(struct cachefiles_cache *cache,
 				  bool preemptive)
 {
 	struct dentry *grave, *trap;
+	struct path path, path_to_graveyard;
 	char nbuffer[8 + 8 + 1];
 	int ret;
 
@@ -287,10 +288,18 @@ static int cachefiles_bury_object(struct cachefiles_cache *cache,
 	/* non-directories can just be unlinked */
 	if (!S_ISDIR(rep->d_inode->i_mode)) {
 		_debug("unlink stale object");
-		ret = vfs_unlink(dir->d_inode, rep);
 
-		if (preemptive)
-			cachefiles_mark_object_buried(cache, rep);
+		path.mnt = cache->mnt;
+		path.dentry = dir;
+		ret = security_path_unlink(&path, rep);
+		if (ret < 0) {
+			cachefiles_io_error(cache, "Unlink security error");
+		} else {
+			ret = vfs_unlink(dir->d_inode, rep);
+
+			if (preemptive)
+				cachefiles_mark_object_buried(cache, rep);
+		}
 
 		mutex_unlock(&dir->d_inode->i_mutex);
 
@@ -379,12 +388,23 @@ try_again:
 	}
 
 	/* attempt the rename */
-	ret = vfs_rename(dir->d_inode, rep, cache->graveyard->d_inode, grave);
-	if (ret != 0 && ret != -ENOMEM)
-		cachefiles_io_error(cache, "Rename failed with error %d", ret);
+	path.mnt = cache->mnt;
+	path.dentry = dir;
+	path_to_graveyard.mnt = cache->mnt;
+	path_to_graveyard.dentry = cache->graveyard;
+	ret = security_path_rename(&path, rep, &path_to_graveyard, grave);
+	if (ret < 0) {
+		cachefiles_io_error(cache, "Rename security error %d", ret);
+	} else {
+		ret = vfs_rename(dir->d_inode, rep,
+				 cache->graveyard->d_inode, grave);
+		if (ret != 0 && ret != -ENOMEM)
+			cachefiles_io_error(cache,
+					    "Rename failed with error %d", ret);
 
-	if (preemptive)
-		cachefiles_mark_object_buried(cache, rep);
+		if (preemptive)
+			cachefiles_mark_object_buried(cache, rep);
+	}
 
 	unlock_rename(cache->graveyard, dir);
 	dput(grave);
@@ -448,6 +468,7 @@ int cachefiles_walk_to_object(struct cachefiles_object *parent,
 {
 	struct cachefiles_cache *cache;
 	struct dentry *dir, *next = NULL;
+	struct path path;
 	unsigned long start;
 	const char *name;
 	int ret, nlen;
@@ -458,6 +479,7 @@ int cachefiles_walk_to_object(struct cachefiles_object *parent,
 
 	cache = container_of(parent->fscache.cache,
 			     struct cachefiles_cache, cache);
+	path.mnt = cache->mnt;
 
 	ASSERT(parent->dentry);
 	ASSERT(parent->dentry->d_inode);
@@ -511,6 +533,10 @@ lookup_again:
 			if (ret < 0)
 				goto create_error;
 
+			path.dentry = dir;
+			ret = security_path_mkdir(&path, next, 0);
+			if (ret < 0)
+				goto create_error;
 			start = jiffies;
 			ret = vfs_mkdir(dir->d_inode, next, 0);
 			cachefiles_hist(cachefiles_mkdir_histogram, start);
@@ -536,6 +562,10 @@ lookup_again:
 			if (ret < 0)
 				goto create_error;
 
+			path.dentry = dir;
+			ret = security_path_mknod(&path, next, S_IFREG, 0);
+			if (ret < 0)
+				goto create_error;
 			start = jiffies;
 			ret = vfs_create(dir->d_inode, next, S_IFREG, NULL);
 			cachefiles_hist(cachefiles_create_histogram, start);
@@ -692,6 +722,7 @@ struct dentry *cachefiles_get_directory(struct cachefiles_cache *cache,
 {
 	struct dentry *subdir;
 	unsigned long start;
+	struct path path;
 	int ret;
 
 	_enter(",,%s", dirname);
@@ -719,6 +750,11 @@ struct dentry *cachefiles_get_directory(struct cachefiles_cache *cache,
 
 		_debug("attempt mkdir");
 
+		path.mnt = cache->mnt;
+		path.dentry = dir;
+		ret = security_path_mkdir(&path, subdir, 0700);
+		if (ret < 0)
+			goto mkdir_error;
 		ret = vfs_mkdir(dir->d_inode, subdir, 0700);
 		if (ret < 0)
 			goto mkdir_error;

