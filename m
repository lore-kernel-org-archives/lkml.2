Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab0HJJoj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 05:44:39 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:47701 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757268Ab0HJJnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 05:43:42 -0400
Message-Id: <20100810094322.997686912@szeredi.hu>
References: <20100810094134.596235651@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Tue, 10 Aug 2010 11:41:35 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Subject: [PATCH 1/7] cachefiles: use path_get instead of lone dget
Content-Disposition: inline; filename=cachefiles-fix-lone-dentry-ref.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Dentry references should not be acquired without a corresponding
vfsmount ref.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: David Howells <dhowells@redhat.com>
---
 fs/cachefiles/daemon.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

Index: linux-2.6/fs/cachefiles/daemon.c
===================================================================
--- linux-2.6.orig/fs/cachefiles/daemon.c	2010-07-05 15:44:37.000000000 +0200
+++ linux-2.6/fs/cachefiles/daemon.c	2010-07-05 15:47:40.000000000 +0200
@@ -553,7 +553,7 @@ static int cachefiles_daemon_tag(struct
 static int cachefiles_daemon_cull(struct cachefiles_cache *cache, char *args)
 {
 	struct fs_struct *fs;
-	struct dentry *dir;
+	struct path path;
 	const struct cred *saved_cred;
 	int ret;
 
@@ -575,22 +575,23 @@ static int cachefiles_daemon_cull(struct
 	/* extract the directory dentry from the cwd */
 	fs = current->fs;
 	read_lock(&fs->lock);
-	dir = dget(fs->pwd.dentry);
+	path = fs->pwd;
+	path_get(&path);
 	read_unlock(&fs->lock);
 
-	if (!S_ISDIR(dir->d_inode->i_mode))
+	if (!S_ISDIR(path.dentry->d_inode->i_mode))
 		goto notdir;
 
 	cachefiles_begin_secure(cache, &saved_cred);
-	ret = cachefiles_cull(cache, dir, args);
+	ret = cachefiles_cull(cache, path.dentry, args);
 	cachefiles_end_secure(cache, saved_cred);
 
-	dput(dir);
+	path_put(&path);
 	_leave(" = %d", ret);
 	return ret;
 
 notdir:
-	dput(dir);
+	path_put(&path);
 	kerror("cull command requires dirfd to be a directory");
 	return -ENOTDIR;
 
@@ -629,7 +630,7 @@ inval:
 static int cachefiles_daemon_inuse(struct cachefiles_cache *cache, char *args)
 {
 	struct fs_struct *fs;
-	struct dentry *dir;
+	struct path path;
 	const struct cred *saved_cred;
 	int ret;
 
@@ -651,22 +652,23 @@ static int cachefiles_daemon_inuse(struc
 	/* extract the directory dentry from the cwd */
 	fs = current->fs;
 	read_lock(&fs->lock);
-	dir = dget(fs->pwd.dentry);
+	path = fs->pwd;
+	path_get(&path);
 	read_unlock(&fs->lock);
 
-	if (!S_ISDIR(dir->d_inode->i_mode))
+	if (!S_ISDIR(path.dentry->d_inode->i_mode))
 		goto notdir;
 
 	cachefiles_begin_secure(cache, &saved_cred);
-	ret = cachefiles_check_in_use(cache, dir, args);
+	ret = cachefiles_check_in_use(cache, path.dentry, args);
 	cachefiles_end_secure(cache, saved_cred);
 
-	dput(dir);
+	path_put(&path);
 	//_leave(" = %d", ret);
 	return ret;
 
 notdir:
-	dput(dir);
+	path_put(&path);
 	kerror("inuse command requires dirfd to be a directory");
 	return -ENOTDIR;
 

-- 
