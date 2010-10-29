Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933746Ab0J2J6o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 05:58:44 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:33801 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761292Ab0J2J6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 05:58:40 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@kernel.dk,
        hooanon05@yahoo.co.jp, bfields@fieldses.org, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V22 08/14] vfs: Add handle based link syscall
Date: Fri, 29 Oct 2010 15:27:17 +0530
Message-Id: <1288346243-12211-9-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288346243-12211-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1288346243-12211-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/namei.c               |   45 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/syscalls.h |    2 ++
 2 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 9c8d4cc..1259721 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2695,6 +2695,51 @@ SYSCALL_DEFINE2(link, const char __user *, oldname, const char __user *, newname
 	return sys_linkat(AT_FDCWD, oldname, AT_FDCWD, newname, 0);
 }
 
+SYSCALL_DEFINE4(handle_link, int, mountdirfd, struct file_handle __user *, uofh,
+		int, newdfd, const char __user *, newname)
+{
+	char *to;
+	int error;
+	struct dentry *new_dentry;
+	struct nameidata nd;
+	struct path old_path;
+
+	error = handle_to_path(mountdirfd, uofh, &old_path);
+	if (error)
+		return error;
+
+	error = user_path_parent(newdfd, newname, &nd, &to);
+	if (error)
+		goto out;
+	error = -EXDEV;
+	if (old_path.mnt != nd.path.mnt)
+		goto out_release;
+	new_dentry = lookup_create(&nd, 0);
+	error = PTR_ERR(new_dentry);
+	if (IS_ERR(new_dentry))
+		goto out_unlock;
+	error = mnt_want_write(nd.path.mnt);
+	if (error)
+		goto out_dput;
+	error = security_path_link(old_path.dentry, &nd.path, new_dentry);
+	if (error)
+		goto out_drop_write;
+	error = vfs_link(old_path.dentry, nd.path.dentry->d_inode, new_dentry);
+out_drop_write:
+	mnt_drop_write(nd.path.mnt);
+out_dput:
+	dput(new_dentry);
+out_unlock:
+	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
+out_release:
+	path_put(&nd.path);
+	putname(to);
+out:
+	path_put(&old_path);
+
+	return error;
+}
+
 /*
  * The worst of all namespace operations - renaming directory. "Perverted"
  * doesn't even start to describe it. Somebody in UCB had a heck of a trip...
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index dd1d994..7d4e6a4 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -851,4 +851,6 @@ asmlinkage long sys_handle_stat(int mountdirfd,
 				struct file_handle __user *ufh,
 				struct stat __user *statbuf);
 #endif
+asmlinkage long sys_handle_link(int mountdirfd, struct file_handle __user *uofh,
+				int newfd, const char __user *newname);
 #endif
-- 
1.7.1

