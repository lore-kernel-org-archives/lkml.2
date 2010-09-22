Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365Ab0IVFSD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 01:18:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051Ab0IVFSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 01:18:00 -0400
From: cdahlin@redhat.com
To: linux-kernel@vger.kernel.org
Cc: Casey Dahlin <cdahlin@redhat.com>, John McCutchan <john@johnmccutchan.com>,
        Robert Love <rlove@rlove.org>, Eric Paris <eparis@parisplace.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 1/3] Introduce inotify_add_watch_at system call
Date: Wed, 22 Sep 2010 01:16:56 -0400
Message-Id: <1285132618-31573-2-git-send-email-cdahlin@redhat.com>
In-Reply-To: <1285132618-31573-1-git-send-email-cdahlin@redhat.com>
References: <1285132618-31573-1-git-send-email-cdahlin@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Casey Dahlin <cdahlin@redhat.com>

This adds inotify to the *at family of system calls (openat(2), unlinkat(2),
etc) and lets you specify a directory file descriptor as a root for the
pathname argument. It is otherwise the same as the inotify_add_watch system
call.

Signed-off-by: Casey Dahlin <cdahlin@redhat.com>
---
 fs/notify/inotify/inotify_user.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index bf7f6d7..ed110ca 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -108,7 +108,7 @@ static inline u32 inotify_mask_to_arg(__u32 mask)
 		       IN_Q_OVERFLOW);
 }
 
-/* intofiy userspace file descriptor functions */
+/* inotfiy userspace file descriptor functions */
 static unsigned int inotify_poll(struct file *file, poll_table *wait)
 {
 	struct fsnotify_group *group = file->private_data;
@@ -350,11 +350,11 @@ static const struct file_operations inotify_fops = {
 /*
  * find_inode - resolve a user-given path to a specific inode
  */
-static int inotify_find_inode(const char __user *dirname, struct path *path, unsigned flags)
+static int inotify_find_inode(int dfd, const char __user *dirname, struct path *path, unsigned flags)
 {
 	int error;
 
-	error = user_path_at(AT_FDCWD, dirname, flags, path);
+	error = user_path_at(dfd, dirname, flags, path);
 	if (error)
 		return error;
 	/* you can only watch an inode if you have read permissions on it */
@@ -762,8 +762,8 @@ SYSCALL_DEFINE0(inotify_init)
 	return sys_inotify_init1(0);
 }
 
-SYSCALL_DEFINE3(inotify_add_watch, int, fd, const char __user *, pathname,
-		u32, mask)
+SYSCALL_DEFINE4(inotify_add_watch_at, int, fd, int, dfd, const char __user *,
+		pathname, u32, mask)
 {
 	struct fsnotify_group *group;
 	struct inode *inode;
@@ -787,7 +787,7 @@ SYSCALL_DEFINE3(inotify_add_watch, int, fd, const char __user *, pathname,
 	if (mask & IN_ONLYDIR)
 		flags |= LOOKUP_DIRECTORY;
 
-	ret = inotify_find_inode(pathname, &path, flags);
+	ret = inotify_find_inode(dfd, pathname, &path, flags);
 	if (ret)
 		goto fput_and_out;
 
@@ -803,6 +803,12 @@ fput_and_out:
 	return ret;
 }
 
+SYSCALL_DEFINE3(inotify_add_watch, int, fd, const char __user *, pathname,
+		u32, mask)
+{
+	return sys_inotify_add_watch_at(fd, AT_FDCWD, pathname, mask);
+}
+
 SYSCALL_DEFINE2(inotify_rm_watch, int, fd, __s32, wd)
 {
 	struct fsnotify_group *group;
-- 
1.7.2.3

