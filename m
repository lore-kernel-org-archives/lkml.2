Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab2FJJWB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 05:22:01 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:65367 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab2FJJV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 05:21:59 -0400
Message-ID: <4FD465B1.4040708@gmail.com>
Date: Sun, 10 Jun 2012 11:15:29 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120421 Thunderbird/12.0
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/17] pramfs: xip support
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Stornelli <marco.stornelli@gmail.com>

XIP operations.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
diff -Nurp linux-3.5-rc2-orig/fs/pramfs/xip.c linux-3.5-rc2/fs/pramfs/xip.c
--- linux-3.5-rc2-orig/fs/pramfs/xip.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-3.5-rc2/fs/pramfs/xip.c	2012-06-10 10:08:28.000000000 +0200
@@ -0,0 +1,117 @@
+/*
+ * BRIEF DESCRIPTION
+ *
+ * XIP operations.
+ *
+ * Copyright 2009-2011 Marco Stornelli <marco.stornelli@gmail.com>
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/mm.h>
+#include <linux/fs.h>
+#include <linux/buffer_head.h>
+#include "pram.h"
+#include "xip.h"
+
+/*
+ * Wrappers. We need to use the rcu read lock to avoid
+ * concurrent truncate operation. No problem for write because we held
+ * i_mutex.
+ */
+ssize_t pram_xip_file_read(struct file *filp, char __user *buf,
+					size_t len, loff_t *ppos)
+{
+	ssize_t res;
+	rcu_read_lock();
+	res = xip_file_read(filp, buf, len, ppos);
+	rcu_read_unlock();
+	return res;
+}
+
+static int pram_xip_file_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	int ret = 0;
+	rcu_read_lock();
+	ret = xip_file_fault(vma, vmf);
+	rcu_read_unlock();
+	return ret;
+}
+
+static const struct vm_operations_struct pram_xip_vm_ops = {
+	.fault	= pram_xip_file_fault,
+};
+
+int pram_xip_file_mmap(struct file * file, struct vm_area_struct * vma)
+{
+	BUG_ON(!file->f_mapping->a_ops->get_xip_mem);
+
+	file_accessed(file);
+	vma->vm_ops = &pram_xip_vm_ops;
+	vma->vm_flags |= VM_CAN_NONLINEAR | VM_MIXEDMAP;
+	return 0;
+}
+
+static int pram_find_and_alloc_blocks(struct inode *inode, sector_t iblock,
+				     sector_t *data_block, int create)
+{
+	int err = -EIO;
+	u64 block;
+
+	block = pram_find_data_block(inode, iblock);
+
+	if (!block) {
+		if (!create) {
+			err = -ENODATA;
+			goto err;
+		}
+
+		err = pram_alloc_blocks(inode, iblock, 1);
+		if (err)
+			goto err;
+
+		block = pram_find_data_block(inode, iblock);
+		if (!block) {
+			err = -ENODATA;
+			goto err;
+		}
+	}
+
+	*data_block = block;
+	err = 0;
+
+ err:
+	return err;
+}
+
+static inline int __pram_get_block(struct inode *inode, pgoff_t pgoff,
+				   int create, sector_t *result)
+{
+	int rc = 0;
+
+	rc = pram_find_and_alloc_blocks(inode, (sector_t)pgoff, result, create);
+
+	if (rc == -ENODATA)
+		BUG_ON(create);
+
+	return rc;
+}
+
+int pram_get_xip_mem(struct address_space *mapping, pgoff_t pgoff, int create,
+		     void **kmem, unsigned long *pfn)
+{
+	int rc;
+	sector_t block = 0;
+
+	/* first, retrieve the block */
+	rc = __pram_get_block(mapping->host, pgoff, create, &block);
+	if (rc)
+		goto exit;
+
+	*kmem = pram_get_block(mapping->host->i_sb, block);
+	*pfn =  pram_get_pfn(mapping->host->i_sb, block);
+
+exit:
+	return rc;
+}
diff -Nurp linux-3.5-rc2-orig/fs/pramfs/xip.h linux-3.5-rc2/fs/pramfs/xip.h
--- linux-3.5-rc2-orig/fs/pramfs/xip.h	1970-01-01 01:00:00.000000000 +0100
+++ linux-3.5-rc2/fs/pramfs/xip.h	2012-06-10 10:08:28.000000000 +0200
@@ -0,0 +1,33 @@
+/*
+ * BRIEF DESCRIPTION
+ *
+ * XIP operations.
+ *
+ * Copyright 2009-2011 Marco Stornelli <marco.stornelli@gmail.com>
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifdef CONFIG_PRAMFS_XIP
+int pram_get_xip_mem(struct address_space *, pgoff_t, int, void **,
+							      unsigned long *);
+ssize_t pram_xip_file_read(struct file *filp, char __user *buf,
+					size_t len, loff_t *ppos);
+int pram_xip_file_mmap(struct file * file, struct vm_area_struct * vma);
+static inline int pram_use_xip(struct super_block *sb)
+{
+	struct pram_sb_info *sbi = PRAM_SB(sb);
+	return sbi->s_mount_opt & PRAM_MOUNT_XIP;
+}
+#define mapping_is_xip(map) (map->a_ops->get_xip_mem)
+
+#else
+
+#define mapping_is_xip(map)	0
+#define pram_use_xip(sb)	0
+#define pram_get_xip_mem	NULL
+#define pram_xip_file_read	NULL
+#define pram_xip_file_mmap	NULL
+
+#endif
diff -Nurp linux-3.5-rc2-orig/mm/filemap_xip.c linux-3.5-rc2/mm/filemap_xip.c
--- linux-3.5-rc2-orig/mm/filemap_xip.c	2012-06-09 03:40:09.000000000 +0200
+++ linux-3.5-rc2/mm/filemap_xip.c	2012-06-10 10:08:27.000000000 +0200
@@ -218,7 +218,7 @@ retry:
  *
  * This function is derived from filemap_fault, but used for execute in place
  */
-static int xip_file_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+int xip_file_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct file *file = vma->vm_file;
 	struct address_space *mapping = file->f_mapping;
@@ -302,6 +302,7 @@ out:
 	}
 }

+EXPORT_SYMBOL_GPL(xip_file_fault);
 static const struct vm_operations_struct xip_file_vm_ops = {
 	.fault	= xip_file_fault,
 };
