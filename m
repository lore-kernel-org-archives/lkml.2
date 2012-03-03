Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028Ab2CCKHG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 05:07:06 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3701 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab2CCKGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 05:06:23 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6637"; a="166538998"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 1/2] libfs: Add simple_open()
Date: Sat,  3 Mar 2012 02:06:19 -0800
Message-Id: <1330769180-22354-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.9.2.315.g25a78
In-Reply-To: <1330769180-22354-1-git-send-email-sboyd@codeaurora.org>
References: <1330769180-22354-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

debugfs and a few other drivers use a version of simple_open() to
pass a pointer from the file to the read/write file ops. Add
support for this simple case to libfs so that we can remove the
many duplicate copies of this simple function.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 fs/libfs.c         |    8 ++++++++
 include/linux/fs.h |    1 +
 2 files changed, 9 insertions(+)

diff --git a/fs/libfs.c b/fs/libfs.c
index 7c895a7..f5af1d6 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -264,6 +264,13 @@ Enomem:
 	return ERR_PTR(-ENOMEM);
 }
 
+int simple_open(struct inode *inode, struct file *file)
+{
+	if (inode->i_private)
+		file->private_data = inode->i_private;
+	return 0;
+}
+
 int simple_link(struct dentry *old_dentry, struct inode *dir, struct dentry *dentry)
 {
 	struct inode *inode = old_dentry->d_inode;
@@ -984,6 +991,7 @@ EXPORT_SYMBOL(simple_dir_operations);
 EXPORT_SYMBOL(simple_empty);
 EXPORT_SYMBOL(simple_fill_super);
 EXPORT_SYMBOL(simple_getattr);
+EXPORT_SYMBOL(simple_open);
 EXPORT_SYMBOL(simple_link);
 EXPORT_SYMBOL(simple_lookup);
 EXPORT_SYMBOL(simple_pin_fs);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f42a557..7871f90 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2517,6 +2517,7 @@ extern int dcache_readdir(struct file *, void *, filldir_t);
 extern int simple_setattr(struct dentry *, struct iattr *);
 extern int simple_getattr(struct vfsmount *, struct dentry *, struct kstat *);
 extern int simple_statfs(struct dentry *, struct kstatfs *);
+extern int simple_open(struct inode *inode, struct file *file);
 extern int simple_link(struct dentry *, struct inode *, struct dentry *);
 extern int simple_unlink(struct inode *, struct dentry *);
 extern int simple_rmdir(struct inode *, struct dentry *);
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

