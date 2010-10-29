Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761270Ab0J2J6O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 05:58:14 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:60692 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761215Ab0J2J6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 05:58:12 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@kernel.dk,
        hooanon05@yahoo.co.jp, bfields@fieldses.org, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V22 04/14] vfs: Add handle based readlink syscall
Date: Fri, 29 Oct 2010 15:27:13 +0530
Message-Id: <1288346243-12211-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288346243-12211-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1288346243-12211-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/stat.c                |   28 ++++++++++++++++++++++++++++
 include/linux/syscalls.h |    3 +++
 2 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/fs/stat.c b/fs/stat.c
index 12e90e2..29052eb 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -319,6 +319,34 @@ SYSCALL_DEFINE3(readlink, const char __user *, path, char __user *, buf,
 	return sys_readlinkat(AT_FDCWD, path, buf, bufsiz);
 }
 
+SYSCALL_DEFINE4(handle_readlink, int, mountdirfd,
+		struct file_handle __user *, ufh,
+		char __user *, buf, int, bufsiz)
+{
+	long retval = 0;
+	struct path path;
+	struct inode *inode;
+
+	if (bufsiz <= 0)
+		return -EINVAL;
+	retval = handle_to_path(mountdirfd, ufh, &path);
+	if (retval)
+		goto out_err;
+
+	inode = path.dentry->d_inode;
+	retval = -EINVAL;
+	if (inode->i_op->readlink) {
+		retval = security_inode_readlink(path.dentry);
+		if (!retval) {
+			touch_atime(path.mnt, path.dentry);
+			retval = inode->i_op->readlink(path.dentry,
+						       buf, bufsiz);
+		}
+	}
+	path_put(&path);
+out_err:
+	return retval;
+}
 
 /* ---------- LFS-64 ----------- */
 #ifdef __ARCH_WANT_STAT64
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 65934c2..7361880 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -839,4 +839,7 @@ asmlinkage long sys_name_to_handle_at(int dfd, const char __user *name,
 asmlinkage long sys_open_by_handle_at(int mountdirfd,
 				      struct file_handle __user *handle,
 				      int flags);
+asmlinkage long sys_handle_readlink(int mountdirfd,
+				    struct file_handle __user *ufh,
+				    char __user *buf, int bufsiz);
 #endif
-- 
1.7.1

