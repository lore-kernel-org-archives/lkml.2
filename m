Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab2BUSTR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 13:19:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29856 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755105Ab2BUSRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 13:17:38 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 61/73] union-mount: Make various syscalls aware (link, chmod,
 chown, utimes & setxattr) [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 21 Feb 2012 18:05:09 +0000
Message-ID: <20120221180509.25235.7686.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the link, chmod, chown, utimes and setxattr syscalls and their variants
aware of unionmounts by passing LOOKUP_COPY_UP to pathwalk.

This has the downside that the copyup will occur even if permission is later
denied to perform the operation.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/namei.c  |    2 +-
 fs/open.c   |    5 +++--
 fs/utimes.c |    2 +-
 fs/xattr.c  |   10 ++++++----
 4 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 6ec5725..efad85e 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3583,7 +3583,7 @@ SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
 	if (flags & AT_SYMLINK_FOLLOW)
 		how |= LOOKUP_FOLLOW;
 
-	error = user_path_at(olddfd, oldname, how, &old_path);
+	error = user_path_at(olddfd, oldname, how | LOOKUP_COPY_UP, &old_path);
 	if (error)
 		return error;
 
diff --git a/fs/open.c b/fs/open.c
index d3be9e3..bce645b 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -516,7 +516,8 @@ SYSCALL_DEFINE3(fchmodat, int, dfd, const char __user *, filename, umode_t, mode
 	struct path path;
 	int error;
 
-	error = user_path_at(dfd, filename, LOOKUP_FOLLOW, &path);
+	error = user_path_at(dfd, filename, LOOKUP_FOLLOW | LOOKUP_COPY_UP,
+			     &path);
 	if (!error) {
 		error = chmod_common(&path, mode);
 		path_put(&path);
@@ -569,7 +570,7 @@ SYSCALL_DEFINE5(fchownat, int, dfd, const char __user *, filename, uid_t, user,
 	lookup_flags = (flag & AT_SYMLINK_NOFOLLOW) ? 0 : LOOKUP_FOLLOW;
 	if (flag & AT_EMPTY_PATH)
 		lookup_flags |= LOOKUP_EMPTY;
-	error = user_path_at(dfd, filename, lookup_flags, &path);
+	error = user_path_at(dfd, filename, lookup_flags | LOOKUP_COPY_UP, &path);
 	if (error)
 		goto out;
 	error = mnt_want_write(path.mnt);
diff --git a/fs/utimes.c b/fs/utimes.c
index ba653f3..5fe9ed5 100644
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -154,7 +154,7 @@ long do_utimes(int dfd, const char __user *filename, struct timespec *times,
 		fput(file);
 	} else {
 		struct path path;
-		int lookup_flags = 0;
+		int lookup_flags = LOOKUP_COPY_UP;
 
 		if (!(flags & AT_SYMLINK_NOFOLLOW))
 			lookup_flags |= LOOKUP_FOLLOW;
diff --git a/fs/xattr.c b/fs/xattr.c
index 82f4337..b1d8b4c 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -351,7 +351,8 @@ SYSCALL_DEFINE5(setxattr, const char __user *, pathname,
 	struct path path;
 	int error;
 
-	error = user_path(pathname, &path);
+	error = user_path_at(AT_FDCWD, pathname, LOOKUP_FOLLOW | LOOKUP_COPY_UP,
+			     &path);
 	if (error)
 		return error;
 	error = mnt_want_write(path.mnt);
@@ -370,7 +371,7 @@ SYSCALL_DEFINE5(lsetxattr, const char __user *, pathname,
 	struct path path;
 	int error;
 
-	error = user_lpath(pathname, &path);
+	error = user_path_at(AT_FDCWD, pathname, LOOKUP_COPY_UP, &path);
 	if (error)
 		return error;
 	error = mnt_want_write(path.mnt);
@@ -580,7 +581,8 @@ SYSCALL_DEFINE2(removexattr, const char __user *, pathname,
 	struct path path;
 	int error;
 
-	error = user_path(pathname, &path);
+	error = user_path_at(AT_FDCWD, pathname, LOOKUP_FOLLOW | LOOKUP_COPY_UP,
+			     &path);
 	if (error)
 		return error;
 	error = mnt_want_write(path.mnt);
@@ -598,7 +600,7 @@ SYSCALL_DEFINE2(lremovexattr, const char __user *, pathname,
 	struct path path;
 	int error;
 
-	error = user_lpath(pathname, &path);
+	error = user_path_at(AT_FDCWD, pathname, LOOKUP_COPY_UP, &path);
 	if (error)
 		return error;
 	error = mnt_want_write(path.mnt);

