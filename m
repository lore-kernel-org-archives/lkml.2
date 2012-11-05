Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932889Ab2KEPWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 10:22:37 -0500
Received: from mail-yh0-f46.google.com ([209.85.213.46]:34402 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932868Ab2KEPWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 10:22:35 -0500
From: Jeff Layton <jlayton@redhat.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, michael.brantley@deshaw.com,
        hch@infradead.org, miklos@szeredi.hu, pstaubach@exagrid.com
Subject: [PATCH v9 07/34] vfs: fix symlinkat to retry on ESTALE errors
Date: Mon,  5 Nov 2012 10:21:46 -0500
Message-Id: <1352128933-28526-8-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352128933-28526-1-git-send-email-jlayton@redhat.com>
References: <1352128933-28526-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 04e4851..af1b473 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3525,21 +3525,25 @@ SYSCALL_DEFINE3(symlinkat, const char __user *, oldname,
 	struct filename *from;
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
+		dentry = user_path_create(newdfd, newname, &path, false, try);
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
1.7.11.7

