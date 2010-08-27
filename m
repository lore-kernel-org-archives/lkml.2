Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab0H0LDy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 07:03:54 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:33426 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab0H0LDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 07:03:52 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@kernel.dk,
        hooanon05@yahoo.co.jp, bfields@fieldses.org, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V19 06/15] vfs: Add handle based link syscall
Date: Fri, 27 Aug 2010 16:32:53 +0530
Message-Id: <1282906982-26918-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282906982-26918-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1282906982-26918-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/namei.c               |   45 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/syscalls.h |    2 ++
 2 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 4718802..304b187 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2706,6 +2706,51 @@ SYSCALL_DEFINE2(link, const char __user *, oldname, const char __user *, newname
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
index e45ef50..9c82364 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -850,4 +850,6 @@ asmlinkage long sys_handle_stat(int mountdirfd,
 				struct file_handle __user *ufh,
 				struct stat __user *statbuf);
 #endif
+asmlinkage long sys_handle_link(int mountdirfd, struct file_handle __user *uofh,
+				int newfd, const char __user *newname);
 #endif
-- 
1.7.0.4

