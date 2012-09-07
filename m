Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760827Ab2IGOTO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 10:19:14 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:43357 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760687Ab2IGOSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 10:18:48 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, michael.brantley@deshaw.com,
        hch@infradead.org, miklos@szeredi.hu, pstaubach@exagrid.com
Subject: [PATCH v6 07/20] vfs: fix symlinkat to retry on ESTALE errors
Date: Fri,  7 Sep 2012 10:18:14 -0400
Message-Id: <1347027507-20956-8-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347027507-20956-1-git-send-email-jlayton@redhat.com>
References: <1347027507-20956-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 9068375..ac731fc 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3524,21 +3524,25 @@ SYSCALL_DEFINE3(symlinkat, const char __user *, oldname,
 	struct getname_info *from;
 	struct dentry *dentry;
 	struct path path;
+	unsigned int try = 0;
 
 	from = getname(oldname);
 	if (IS_ERR(from))
 		return PTR_ERR(from);
 
-	dentry = user_path_create(newdfd, newname, &path, false, false);
-	error = PTR_ERR(dentry);
-	if (IS_ERR(dentry))
-		goto out_putname;
+	do {
+		dentry = user_path_create(newdfd, newname, &path, false, false);
+		if (IS_ERR(dentry)) {
+			error = PTR_ERR(dentry);
+			break;
+		}
 
-	error = security_path_symlink(&path, dentry, from->name);
-	if (!error)
-		error = vfs_symlink(path.dentry->d_inode, dentry, from->name);
-	done_path_create(&path, dentry);
-out_putname:
+		error = security_path_symlink(&path, dentry, from->name);
+		if (!error)
+			error = vfs_symlink(path.dentry->d_inode, dentry,
+						from->name);
+		done_path_create(&path, dentry);
+	} while (retry_estale(error, try++));
 	putname(from);
 	return error;
 }
-- 
1.7.11.4

