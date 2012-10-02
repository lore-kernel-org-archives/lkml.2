Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab2JBAW4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 20:22:56 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43333 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236Ab2JBARr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 20:17:47 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: eparis@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com
Subject: [PATCH v7 29/49] vfs: add a reval argument to user_path_parent
Date: Mon,  1 Oct 2012 20:16:38 -0400
Message-Id: <1349137018-21948-30-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
References: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...so we can tell it when to set LOOKUP_REVAL.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index e0ee4b9..b73315d 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2187,15 +2187,20 @@ int user_path_at(int dfd, const char __user *name, unsigned flags,
  *     path-walking is complete.
  */
 static struct getname_info *
-user_path_parent(int dfd, const char __user *path, struct nameidata *nd)
+user_path_parent(int dfd, const char __user *path, struct nameidata *nd,
+		 unsigned int reval)
 {
 	struct getname_info *s = getname(path);
 	int error;
+	unsigned int flags = LOOKUP_PARENT;
+
+	if (reval)
+		flags |= LOOKUP_REVAL;
 
 	if (IS_ERR(s))
 		return s;
 
-	error = ginfo_lookup(dfd, s, LOOKUP_PARENT, nd);
+	error = ginfo_lookup(dfd, s, flags, nd);
 	if (error) {
 		putname(s);
 		return ERR_PTR(error);
@@ -3343,7 +3348,7 @@ static long do_rmdir(int dfd, const char __user *pathname)
 	struct dentry *dentry;
 	struct nameidata nd;
 
-	name = user_path_parent(dfd, pathname, &nd);
+	name = user_path_parent(dfd, pathname, &nd, 0);
 	if (IS_ERR(name))
 		return PTR_ERR(name);
 
@@ -3439,7 +3444,7 @@ static long do_unlinkat(int dfd, const char __user *pathname)
 	struct nameidata nd;
 	struct inode *inode = NULL;
 
-	name = user_path_parent(dfd, pathname, &nd);
+	name = user_path_parent(dfd, pathname, &nd, 0);
 	if (IS_ERR(name))
 		return PTR_ERR(name);
 
@@ -3834,13 +3839,13 @@ SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
 	struct getname_info *to;
 	int error;
 
-	from = user_path_parent(olddfd, oldname, &oldnd);
+	from = user_path_parent(olddfd, oldname, &oldnd, 0);
 	if (IS_ERR(from)) {
 		error = PTR_ERR(from);
 		goto exit;
 	}
 
-	to = user_path_parent(newdfd, newname, &newnd);
+	to = user_path_parent(newdfd, newname, &newnd, 0);
 	if (IS_ERR(to)) {
 		error = PTR_ERR(to);
 		goto exit1;
-- 
1.7.11.4

