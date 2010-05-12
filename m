Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305Ab0ELPw6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 11:52:58 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:50831 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756495Ab0ELPvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 11:51:17 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, neilb@suse.de
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
       linux-kernel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V7 5/9] vfs: Add freadlink syscall
Date: Wed, 12 May 2010 21:20:40 +0530
Message-Id: <1273679444-14903-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1.78.g212f0
In-Reply-To: <1273679444-14903-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1273679444-14903-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enables to use open-by-handle and then get the link target
details of a symlink using the fd returned by handle

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/stat.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/fs/stat.c b/fs/stat.c
index c4ecd52..0fbab00 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -314,6 +314,33 @@ SYSCALL_DEFINE3(readlink, const char __user *, path, char __user *, buf,
 	return sys_readlinkat(AT_FDCWD, path, buf, bufsiz);
 }
 
+SYSCALL_DEFINE3(freadlink, int, fd, char __user *, buf,
+		int, bufsiz)
+{
+	int fput_needed;
+	struct file *file;
+	int error = -EBADF;
+	struct inode *inode;
+
+	file = fget_light(fd, &fput_needed);
+	if (!file)
+		return error;
+
+	inode = file->f_path.dentry->d_inode;
+	error = -EINVAL;
+	if (inode->i_op->readlink) {
+		error = security_inode_readlink(file->f_path.dentry);
+		if (!error) {
+			touch_atime(file->f_path.mnt, file->f_path.dentry);
+			error = inode->i_op->readlink(file->f_path.dentry,
+						buf, bufsiz);
+		}
+	}
+	fput_light(file, fput_needed);
+	return error;
+}
+
+
 
 /* ---------- LFS-64 ----------- */
 #ifdef __ARCH_WANT_STAT64
-- 
1.7.1.78.g212f0

