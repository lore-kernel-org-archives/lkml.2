Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab2LKN4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 08:56:25 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:57447 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab2LKN4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 08:56:24 -0500
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        dwysocha@redhat.com
Subject: [PATCH] vfs: remove unneeded permission check from path_init
Date: Tue, 11 Dec 2012 08:56:16 -0500
Message-Id: <1355234176-767-1-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When path_init is called with a valid dfd, that code checks permissions
on the open directory fd and returns an error if the check fails. This
permission check is redundant, however.

Both callers of path_init immediately call link_path_walk afterward. The
first thing that link_path_walk does is to check for exec permissions
at the starting point of the path walk.

In most cases, these checks are very quick, but when the dfd is for a
file on a NFS mount with the actimeo=0, each permission check goes
out onto the wire. The result is 2 identical ACCESS calls.

Given that these codepaths are fairly "hot", I think it makes sense to
eliminate the permission check in path_init and simply assume that the
caller will eventually check the permissions before proceeding.

Reported-by: Dave Wysochanski <dwysocha@redhat.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 40d864a..deefbc3 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1894,6 +1894,7 @@ static int path_init(int dfd, const char *name, unsigned int flags,
 			get_fs_pwd(current->fs, &nd->path);
 		}
 	} else {
+		/* Caller must check execute permissions on the starting path component */
 		struct fd f = fdget_raw(dfd);
 		struct dentry *dentry;
 
@@ -1907,12 +1908,6 @@ static int path_init(int dfd, const char *name, unsigned int flags,
 				fdput(f);
 				return -ENOTDIR;
 			}
-
-			retval = inode_permission(dentry->d_inode, MAY_EXEC);
-			if (retval) {
-				fdput(f);
-				return retval;
-			}
 		}
 
 		nd->path = f.file->f_path;
-- 
1.7.11.7

