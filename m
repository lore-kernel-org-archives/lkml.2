Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab0KMOxe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 09:53:34 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47192 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084Ab0KMOx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 09:53:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=ZSBdn0Bh1wK4eDJ7ENnibcwqekktoY39jFbZ2SEvW6ARqZ7uq0wXFxN1HMYuTrvWiF
         k2Xl17ujtO9W/YTTkABFz/gzhrCM5dee3tlzq+RH9/q6dRgO4y6TVsR/qzeeyYuhr7a3
         B+PfBd4H8TkPQ9Nhaj82EnZ0y/qVCG+EI5OVw=
Message-ID: <4CDEA5A1.3000005@gmail.com>
Date: Sat, 13 Nov 2010 15:50:09 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 04/16 v3] pramfs: file operations
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Stornelli <marco.stornelli@gmail.com>

File operations.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
diff -Nurp linux-2.6.36-orig/fs/pramfs/file.c linux-2.6.36/fs/pramfs/file.c
--- linux-2.6.36-orig/fs/pramfs/file.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.36/fs/pramfs/file.c	2010-09-24 18:34:03.000000000 +0200
@@ -0,0 +1,166 @@
+/*
+ * FILE NAME fs/pramfs/file.c
+ *
+ * BRIEF DESCRIPTION
+ *
+ * File operations for files.
+ *
+ * Copyright 2009-2010 Marco Stornelli <marco.stornelli@gmail.com>
+ * Copyright 2003 Sony Corporation
+ * Copyright 2003 Matsushita Electric Industrial Co., Ltd.
+ * 2003-2004 (c) MontaVista Software, Inc. , Steve Longerbeam
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+#include <linux/fs.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/uio.h>
+#include <linux/mm.h>
+#include <linux/uaccess.h>
+#include "pram.h"
+#include "acl.h"
+#include "xip.h"
+#include "xattr.h"
+
+static int pram_open_file(struct inode *inode, struct file *filp)
+{
+#ifndef CONFIG_PRAMFS_XIP
+	/* Without XIP we force to use Direct IO */
+	filp->f_flags |= O_DIRECT;
+#endif
+	return generic_file_open(inode, filp);
+}
+
+ssize_t __pram_direct_IO(int rw, struct kiocb *iocb,
+		   const struct iovec *iov,
+		   loff_t offset, unsigned long nr_segs)
+{
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = file->f_mapping->host;
+	struct super_block *sb = inode->i_sb;
+	int progress = 0, hole = 0;
+	ssize_t retval = 0;
+	void *tmp = NULL;
+	unsigned long blocknr, blockoff;
+	int num_blocks, blocksize_mask, blocksize, blocksize_bits;
+	char __user *buf = iov->iov_base;
+	size_t length = iov_length(iov, nr_segs);
+
+	if (length < 0)
+		return -EINVAL;
+	if ((rw == READ) && (offset + length > inode->i_size))
+		length = inode->i_size - offset;
+	if (!length)
+		goto out;
+
+	blocksize_bits = inode->i_sb->s_blocksize_bits;
+	blocksize = 1 << blocksize_bits;
+	blocksize_mask = blocksize - 1;
+
+	/* find starting block number to access */
+	blocknr = offset >> blocksize_bits;
+	/* find starting offset within starting block */
+	blockoff = offset & blocksize_mask;
+	/* find number of blocks to access */
+	num_blocks = (blockoff + length + blocksize_mask) >> blocksize_bits;
+
+	if (rw == WRITE) {
+		/* prepare a temporary buffer to hold a user data block
+		   for writing. */
+		tmp = kmalloc(blocksize, GFP_KERNEL);
+		if (!tmp)
+			return -ENOMEM;
+		/* now allocate the data blocks we'll need */
+		retval = pram_alloc_blocks(inode, blocknr, num_blocks);
+		if (retval)
+			goto fail1;
+	}
+
+	while (length) {
+		int count;
+		u8 *bp = NULL;
+		u64 block = pram_find_data_block(inode, blocknr++);
+		if (unlikely(!block && rw == READ)) {
+			/* We are falling in a hole */
+			hole = 1;
+		} else {
+			bp = (u8 *)pram_get_block(sb, block);
+			if (!bp)
+				goto fail2;
+		}
+
+		count = blockoff + length > blocksize ?
+			blocksize - blockoff : length;
+
+		if (rw == READ) {
+			if (unlikely(hole)) {
+				retval = clear_user(buf, count);
+				if (retval) {
+					retval = -EFAULT;
+					goto fail1;
+				}
+			} else {
+				retval = copy_to_user(buf, &bp[blockoff], count);
+				if (retval) {
+					retval = -EFAULT;
+					goto fail1;
+				}
+			}
+		} else {
+			retval = copy_from_user(tmp, buf, count);
+			if (retval) {
+				retval = -EFAULT;
+				goto fail1;
+			}
+
+			pram_memunlock_block(inode->i_sb, bp);
+			memcpy(&bp[blockoff], tmp, count);
+			pram_memlock_block(inode->i_sb, bp);
+		}
+
+		progress += count;
+		buf += count;
+		length -= count;
+		blockoff = 0;
+		hole = 0;
+	}
+
+fail2:
+	retval = progress;
+fail1:
+	kfree(tmp);
+out:
+	return retval;
+}
+
+int __pram_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	/* Only private mappings */
+	if (vma->vm_flags & VM_SHARED)
+		return -EINVAL;
+	return generic_file_mmap(file, vma);
+}
+
+struct file_operations pram_file_operations = {
+	.llseek		= generic_file_llseek,
+	.read		= pram_read,
+	.write		= pram_write,
+	.aio_read	= pram_aio_read,
+	.aio_write	= pram_aio_write,
+	.mmap		= pram_mmap,
+	.open		= pram_open_file,
+	.fsync		= noop_fsync,
+};
+
+struct inode_operations pram_file_inode_operations = {
+#ifdef CONFIG_PRAMFS_XATTR
+	.setxattr	= generic_setxattr,
+	.getxattr	= generic_getxattr,
+	.listxattr	= pram_listxattr,
+	.removexattr	= generic_removexattr,
+#endif
+	.setattr	= pram_notify_change,
+	.check_acl	= pram_check_acl,
+};
