Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab1KJFEY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 00:04:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42517 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934391Ab1KJD2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:28:30 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:13 2011
Message-Id: <20111109212713.482793419@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:27:30 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andy Whitcroft <apw@canonical.com>,
        Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [128/262] readlinkat: ensure we return ENOENT for the empty pathname for normal lookups
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Whitcroft <apw@canonical.com>

commit 1fa1e7f615f4d3ae436fa319af6e4eebdd4026a8 upstream.

Since the commit below which added O_PATH support to the *at() calls, the
error return for readlink/readlinkat for the empty pathname has switched
from ENOENT to EINVAL:

  commit 65cfc6722361570bfe255698d9cd4dccaf47570d
  Author: Al Viro <viro@zeniv.linux.org.uk>
  Date:   Sun Mar 13 15:56:26 2011 -0400

    readlinkat(), fchownat() and fstatat() with empty relative pathnames

This is both unexpected for userspace and makes readlink/readlinkat
inconsistant with all other interfaces; and inconsistant with our stated
return for these pathnames.

As the readlinkat call does not have a flags parameter we cannot use the
AT_EMPTY_PATH approach used in the other calls.  Therefore expose whether
the original path is infact entry via a new user_path_at_empty() path
lookup function.  Use this to determine whether to default to EINVAL or
ENOENT for failures.

Addresses http://bugs.launchpad.net/bugs/817187

[akpm@linux-foundation.org: remove unused getname_flags()]
Signed-off-by: Andy Whitcroft <apw@canonical.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/namei.c            |   18 +++++++++++++-----
 fs/stat.c             |    5 +++--
 include/linux/namei.h |    1 +
 3 files changed, 17 insertions(+), 7 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -136,7 +136,7 @@ static int do_getname(const char __user
 	return retval;
 }
 
-static char *getname_flags(const char __user * filename, int flags)
+static char *getname_flags(const char __user *filename, int flags, int *empty)
 {
 	char *tmp, *result;
 
@@ -147,6 +147,8 @@ static char *getname_flags(const char __
 
 		result = tmp;
 		if (retval < 0) {
+			if (retval == -ENOENT && empty)
+				*empty = 1;
 			if (retval != -ENOENT || !(flags & LOOKUP_EMPTY)) {
 				__putname(tmp);
 				result = ERR_PTR(retval);
@@ -159,7 +161,7 @@ static char *getname_flags(const char __
 
 char *getname(const char __user * filename)
 {
-	return getname_flags(filename, 0);
+	return getname_flags(filename, 0, 0);
 }
 
 #ifdef CONFIG_AUDITSYSCALL
@@ -1747,11 +1749,11 @@ struct dentry *lookup_one_len(const char
 	return __lookup_hash(&this, base, NULL);
 }
 
-int user_path_at(int dfd, const char __user *name, unsigned flags,
-		 struct path *path)
+int user_path_at_empty(int dfd, const char __user *name, unsigned flags,
+		 struct path *path, int *empty)
 {
 	struct nameidata nd;
-	char *tmp = getname_flags(name, flags);
+	char *tmp = getname_flags(name, flags, empty);
 	int err = PTR_ERR(tmp);
 	if (!IS_ERR(tmp)) {
 
@@ -1765,6 +1767,12 @@ int user_path_at(int dfd, const char __u
 	return err;
 }
 
+int user_path_at(int dfd, const char __user *name, unsigned flags,
+		 struct path *path)
+{
+	return user_path_at_empty(dfd, name, flags, path, 0);
+}
+
 static int user_path_parent(int dfd, const char __user *path,
 			struct nameidata *nd, char **name)
 {
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -296,15 +296,16 @@ SYSCALL_DEFINE4(readlinkat, int, dfd, co
 {
 	struct path path;
 	int error;
+	int empty = 0;
 
 	if (bufsiz <= 0)
 		return -EINVAL;
 
-	error = user_path_at(dfd, pathname, LOOKUP_EMPTY, &path);
+	error = user_path_at_empty(dfd, pathname, LOOKUP_EMPTY, &path, &empty);
 	if (!error) {
 		struct inode *inode = path.dentry->d_inode;
 
-		error = -EINVAL;
+		error = empty ? -ENOENT : -EINVAL;
 		if (inode->i_op->readlink) {
 			error = security_inode_readlink(path.dentry);
 			if (!error) {
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -67,6 +67,7 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LA
 #define LOOKUP_EMPTY		0x4000
 
 extern int user_path_at(int, const char __user *, unsigned, struct path *);
+extern int user_path_at_empty(int, const char __user *, unsigned, struct path *, int *empty);
 
 #define user_path(name, path) user_path_at(AT_FDCWD, name, LOOKUP_FOLLOW, path)
 #define user_lpath(name, path) user_path_at(AT_FDCWD, name, 0, path)


