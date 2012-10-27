Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab2J0MeM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 08:34:12 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:47879 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021Ab2J0MeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 08:34:07 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, michael.brantley@deshaw.com,
        hch@infradead.org, miklos@szeredi.hu, pstaubach@exagrid.com
Subject: [PATCH v8 09/32] vfs: add a reval argument to user_path_parent
Date: Sat, 27 Oct 2012 08:33:16 -0400
Message-Id: <1351341219-17837-10-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1351341219-17837-1-git-send-email-jlayton@redhat.com>
References: <1351341219-17837-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...so we can tell it when to set LOOKUP_REVAL.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index d542a19..47b6016 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2184,15 +2184,20 @@ int user_path_at(int dfd, const char __user *name, unsigned flags,
  *     path-walking is complete.
  */
 static struct filename *
-user_path_parent(int dfd, const char __user *path, struct nameidata *nd)
+user_path_parent(int dfd, const char __user *path, struct nameidata *nd,
+		 unsigned int reval)
 {
 	struct filename *s = getname(path);
 	int error;
+	unsigned int flags = LOOKUP_PARENT;
+
+	if (reval)
+		flags |= LOOKUP_REVAL;
 
 	if (IS_ERR(s))
 		return s;
 
-	error = filename_lookup(dfd, s, LOOKUP_PARENT, nd);
+	error = filename_lookup(dfd, s, flags, nd);
 	if (error) {
 		putname(s);
 		return ERR_PTR(error);
@@ -3340,7 +3345,7 @@ static long do_rmdir(int dfd, const char __user *pathname)
 	struct dentry *dentry;
 	struct nameidata nd;
 
-	name = user_path_parent(dfd, pathname, &nd);
+	name = user_path_parent(dfd, pathname, &nd, 0);
 	if (IS_ERR(name))
 		return PTR_ERR(name);
 
@@ -3436,7 +3441,7 @@ static long do_unlinkat(int dfd, const char __user *pathname)
 	struct nameidata nd;
 	struct inode *inode = NULL;
 
-	name = user_path_parent(dfd, pathname, &nd);
+	name = user_path_parent(dfd, pathname, &nd, 0);
 	if (IS_ERR(name))
 		return PTR_ERR(name);
 
@@ -3831,13 +3836,13 @@ SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
 	struct filename *to;
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
1.7.11.7

