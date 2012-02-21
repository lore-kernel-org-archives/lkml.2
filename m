Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab2BUSKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 13:10:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2994 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754841Ab2BUSHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 13:07:51 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 01/73] VFS: Make chown() and lchown() call fchownat() [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 21 Feb 2012 17:57:29 +0000
Message-ID: <20120221175729.25235.64646.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the chown() and lchown() syscalls jump to the fchownat() syscall with the
appropriate extra arguments.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/open.c |   41 +++++++----------------------------------
 1 files changed, 7 insertions(+), 34 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 77becc0..3c44148 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -527,25 +527,6 @@ static int chown_common(struct path *path, uid_t user, gid_t group)
 	return error;
 }
 
-SYSCALL_DEFINE3(chown, const char __user *, filename, uid_t, user, gid_t, group)
-{
-	struct path path;
-	int error;
-
-	error = user_path(filename, &path);
-	if (error)
-		goto out;
-	error = mnt_want_write(path.mnt);
-	if (error)
-		goto out_release;
-	error = chown_common(&path, user, group);
-	mnt_drop_write(path.mnt);
-out_release:
-	path_put(&path);
-out:
-	return error;
-}
-
 SYSCALL_DEFINE5(fchownat, int, dfd, const char __user *, filename, uid_t, user,
 		gid_t, group, int, flag)
 {
@@ -573,23 +554,15 @@ out:
 	return error;
 }
 
-SYSCALL_DEFINE3(lchown, const char __user *, filename, uid_t, user, gid_t, group)
+SYSCALL_DEFINE3(chown, const char __user *, filename, uid_t, user, gid_t, group)
 {
-	struct path path;
-	int error;
+	return sys_fchownat(AT_FDCWD, filename, user, group, 0);
+}
 
-	error = user_lpath(filename, &path);
-	if (error)
-		goto out;
-	error = mnt_want_write(path.mnt);
-	if (error)
-		goto out_release;
-	error = chown_common(&path, user, group);
-	mnt_drop_write(path.mnt);
-out_release:
-	path_put(&path);
-out:
-	return error;
+SYSCALL_DEFINE3(lchown, const char __user *, filename, uid_t, user, gid_t, group)
+{
+	return sys_fchownat(AT_FDCWD, filename, user, group,
+			    AT_SYMLINK_NOFOLLOW);
 }
 
 SYSCALL_DEFINE3(fchown, unsigned int, fd, uid_t, user, gid_t, group)

