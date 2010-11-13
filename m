Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729Ab0KMOy4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 09:54:56 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38111 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754854Ab0KMOyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 09:54:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=AcmCwSDWy+TMe0L1KHfC/JNUdo9VubmHR5IjKYsuy2k8VwThQh0PWxS4Non46W91GY
         Ud0jGh43fYnKeGz2mINFR1rFxT+TM5gv+4wA10zfr/bsful1CUCS2KQtIn96n5mVD+ZK
         +ou8R+2gS8pZ02wzAdmlNIqP04Mde2WHj8Z28=
Message-ID: <4CDEA5EE.6000008@gmail.com>
Date: Sat, 13 Nov 2010 15:51:26 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 07/16 v3] pramfs: symbolic links
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Stornelli <marco.stornelli@gmail.com>

Symlink operations.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
diff -Nurp linux-2.6.36-orig/fs/pramfs/symlink.c linux-2.6.36/fs/pramfs/symlink.c
--- linux-2.6.36-orig/fs/pramfs/symlink.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.36/fs/pramfs/symlink.c	2010-09-14 18:49:52.000000000 +0200
@@ -0,0 +1,78 @@
+/*
+ * FILE NAME fs/pramfs/symlink.c
+ *
+ * BRIEF DESCRIPTION
+ *
+ * Symlink operations
+ *
+ * Copyright 2009-2010 Marco Stornelli <marco.stornelli@gmail.com>
+ * Copyright 2003 Sony Corporation
+ * Copyright 2003 Matsushita Electric Industrial Co., Ltd.
+ * 2003-2004 (c) MontaVista Software, Inc. , Steve Longerbeam
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/fs.h>
+#include "pram.h"
+#include "xattr.h"
+
+int pram_block_symlink(struct inode *inode, const char *symname, int len)
+{
+	struct super_block *sb = inode->i_sb;
+	u64 block;
+	char *blockp;
+	int err;
+
+	err = pram_alloc_blocks(inode, 0, 1);
+	if (err)
+		return err;
+
+	block = pram_find_data_block(inode, 0);
+	blockp = pram_get_block(sb, block);
+
+	pram_memunlock_block(sb, blockp);
+	memcpy(blockp, symname, len);
+	blockp[len] = '\0';
+	pram_memlock_block(sb, blockp);
+	return 0;
+}
+
+static int pram_readlink(struct dentry *dentry, char *buffer, int buflen)
+{
+	struct inode *inode = dentry->d_inode;
+	struct super_block *sb = inode->i_sb;
+	u64 block;
+	char *blockp;
+
+	block = pram_find_data_block(inode, 0);
+	blockp = pram_get_block(sb, block);
+	return vfs_readlink(dentry, buffer, buflen, blockp);
+}
+
+static void *pram_follow_link(struct dentry *dentry, struct nameidata *nd)
+{
+	struct inode *inode = dentry->d_inode;
+	struct super_block *sb = inode->i_sb;
+	off_t block;
+	int status;
+	char *blockp;
+
+	block = pram_find_data_block(inode, 0);
+	blockp = pram_get_block(sb, block);
+	status = vfs_follow_link(nd, blockp);
+	return ERR_PTR(status);
+}
+
+struct inode_operations pram_symlink_inode_operations = {
+	.readlink	= pram_readlink,
+	.follow_link	= pram_follow_link,
+	.setattr	= pram_notify_change,
+#ifdef CONFIG_PRAMFS_XATTR
+	.setxattr	= generic_setxattr,
+	.getxattr	= generic_getxattr,
+	.listxattr	= pram_listxattr,
+	.removexattr	= generic_removexattr,
+#endif
+};
 
