Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab1AFMGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 07:06:35 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62225 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757Ab1AFMGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 07:06:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=FHPL+lKT6rifnxBuX8B2kgFwyr2+nchsIVPaaK62Vu5FUkFtlPuK5yjOr9sFoT8p38
         CTcIJpB3iL3uOSYpRE1Wp3We0DRT1AB0euU49q/TBd0+y5xs6UfwrsCIPbfAeSZag3qp
         7sB0B0lattLG2FiX12owyv48kh4CdYfJT/8Po=
Message-ID: <4D25AF5B.3060301@gmail.com>
Date: Thu, 06 Jan 2011 13:02:35 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>
Subject: [PATCH 07/17] pramfs: symlink operations
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Stornelli <marco.stornelli@gmail.com>

Symlink operations.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
diff --git a/fs/pramfs/symlink.c b/fs/pramfs/symlink.c
new file mode 100644
index 0000000..f129271
--- /dev/null
+++ b/fs/pramfs/symlink.c
@@ -0,0 +1,76 @@
+/*
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
