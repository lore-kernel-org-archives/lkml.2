Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab2FJJXD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 05:23:03 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50509 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375Ab2FJJXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 05:23:00 -0400
Message-ID: <4FD465EE.8060603@gmail.com>
Date: Sun, 10 Jun 2012 11:16:30 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120421 Thunderbird/12.0
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 14/17] pramfs: write protection
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Stornelli <marco.stornelli@gmail.com>

Memory write protection.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
diff -Nurp linux-3.5-rc2-orig/fs/pramfs/wprotect.c linux-3.5-rc2/fs/pramfs/wprotect.c
--- linux-3.5-rc2-orig/fs/pramfs/wprotect.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-3.5-rc2/fs/pramfs/wprotect.c	2012-06-10 10:08:28.000000000 +0200
@@ -0,0 +1,41 @@
+/*
+ * BRIEF DESCRIPTION
+ *
+ * Write protection for the filesystem pages.
+ *
+ * Copyright 2009-2011 Marco Stornelli <marco.stornelli@gmail.com>
+ * Copyright 2003 Sony Corporation
+ * Copyright 2003 Matsushita Electric Industrial Co., Ltd.
+ * 2003-2004 (c) MontaVista Software, Inc. , Steve Longerbeam
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/io.h>
+#include "pram.h"
+
+DEFINE_SPINLOCK(writeable_lock);
+
+void pram_writeable(void *vaddr, unsigned long size, int rw)
+{
+	int ret = 0;
+	unsigned long nrpages = size >> PAGE_SHIFT;
+	unsigned long addr = (unsigned long)vaddr;
+
+	/* Page aligned */
+	addr &= PAGE_MASK;
+
+	if (size & (PAGE_SIZE - 1))
+		nrpages++;
+
+	if (rw)
+		ret = set_memory_rw(addr, nrpages);
+	else
+		ret = set_memory_ro(addr, nrpages);
+
+	BUG_ON(ret);
+}
diff -Nurp linux-3.5-rc2-orig/fs/pramfs/wprotect.h linux-3.5-rc2/fs/pramfs/wprotect.h
--- linux-3.5-rc2-orig/fs/pramfs/wprotect.h	1970-01-01 01:00:00.000000000 +0100
+++ linux-3.5-rc2/fs/pramfs/wprotect.h	2012-06-10 10:08:28.000000000 +0200
@@ -0,0 +1,153 @@
+/*
+ * BRIEF DESCRIPTION
+ *
+ * Memory protection definitions for the PRAMFS filesystem.
+ *
+ * Copyright 2010-2011 Marco Stornelli <marco.stornelli@gmail.com>
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifndef __WPROTECT_H
+#define __WPROTECT_H
+
+#include <linux/pram_fs.h>
+
+/* pram_memunlock_super() before calling! */
+static inline void pram_sync_super(struct pram_super_block *ps)
+{
+	u16 crc = 0;
+	ps->s_wtime = cpu_to_be32(get_seconds());
+	ps->s_sum = 0;
+	crc = crc16(~0, (__u8 *)ps + sizeof(__be16), PRAM_SB_SIZE -
+								sizeof(__be16));
+	ps->s_sum = cpu_to_be16(crc);
+	/* Keep sync redundant super block */
+	memcpy((void *)ps + PRAM_SB_SIZE, (void *)ps, PRAM_SB_SIZE);
+}
+
+/* pram_memunlock_inode() before calling! */
+static inline void pram_sync_inode(struct pram_inode *pi)
+{
+	u16 crc = 0;
+	pi->i_sum = 0;
+	crc = crc16(~0, (__u8 *)pi + sizeof(__be16), PRAM_INODE_SIZE -
+								sizeof(__be16));
+	pi->i_sum = cpu_to_be16(crc);
+}
+
+#ifdef CONFIG_PRAMFS_WRITE_PROTECT
+extern void pram_writeable(void *vaddr, unsigned long size, int rw);
+extern spinlock_t writeable_lock;
+static inline int pram_is_protected(struct super_block *sb)
+{
+	struct pram_sb_info *sbi = (struct pram_sb_info *)sb->s_fs_info;
+	return sbi->s_mount_opt & PRAM_MOUNT_PROTECT;
+}
+
+static inline void __pram_memunlock_range(void *p, unsigned long len)
+{
+	/*
+	 * NOTE: Ideally we should lock all the kernel to be memory safe
+	 * and avoid to write in the protected memory,
+	 * obviously it's not possible, so we only serialize
+	 * the operations at fs level. We can't disable the interrupts
+	 * because we could have a deadlock in this path.
+	 */
+	spin_lock(&writeable_lock);
+	pram_writeable(p, len, 1);
+}
+
+static inline void __pram_memlock_range(void *p, unsigned long len)
+{
+	pram_writeable(p, len, 0);
+	spin_unlock(&writeable_lock);
+}
+
+static inline void pram_memunlock_range(struct super_block *sb, void *p,
+					unsigned long len)
+{
+	if (pram_is_protected(sb))
+		__pram_memunlock_range(p, len);
+}
+
+static inline void pram_memlock_range(struct super_block *sb, void *p,
+					unsigned long len)
+{
+	if (pram_is_protected(sb))
+		__pram_memlock_range(p, len);
+}
+
+static inline void pram_memunlock_super(struct super_block *sb,
+					struct pram_super_block *ps)
+{
+	if (pram_is_protected(sb))
+		__pram_memunlock_range(ps, PRAM_SB_SIZE);
+}
+
+static inline void pram_memlock_super(struct super_block *sb,
+					struct pram_super_block *ps)
+{
+	pram_sync_super(ps);
+	if (pram_is_protected(sb))
+		__pram_memlock_range(ps, PRAM_SB_SIZE);
+}
+
+static inline void pram_memunlock_inode(struct super_block *sb,
+					struct pram_inode *pi)
+{
+	if (pram_is_protected(sb))
+		__pram_memunlock_range(pi, PRAM_SB_SIZE);
+}
+
+static inline void pram_memlock_inode(struct super_block *sb,
+					struct pram_inode *pi)
+{
+	pram_sync_inode(pi);
+	if (pram_is_protected(sb))
+		__pram_memlock_range(pi, PRAM_SB_SIZE);
+}
+
+static inline void pram_memunlock_block(struct super_block *sb,
+					void *bp)
+{
+	if (pram_is_protected(sb))
+		__pram_memunlock_range(bp, sb->s_blocksize);
+}
+
+static inline void pram_memlock_block(struct super_block *sb,
+					void *bp)
+{
+	if (pram_is_protected(sb))
+		__pram_memlock_range(bp, sb->s_blocksize);
+}
+
+#else
+#define pram_is_protected(sb)	0
+#define pram_writeable(vaddr, size, rw) do {} while (0)
+static inline void pram_memunlock_range(struct super_block *sb, void *p,
+					unsigned long len) {}
+static inline void pram_memlock_range(struct super_block *sb, void *p,
+					unsigned long len) {}
+static inline void pram_memunlock_super(struct super_block *sb,
+					struct pram_super_block *ps) {}
+static inline void pram_memlock_super(struct super_block *sb,
+					struct pram_super_block *ps)
+{
+	pram_sync_super(ps);
+}
+static inline void pram_memunlock_inode(struct super_block *sb,
+					struct pram_inode *pi) {}
+static inline void pram_memlock_inode(struct super_block *sb,
+					struct pram_inode *pi)
+{
+	pram_sync_inode(pi);
+}
+static inline void pram_memunlock_block(struct super_block *sb,
+					void *bp) {}
+static inline void pram_memlock_block(struct super_block *sb,
+					void *bp) {}
+
+#endif /* CONFIG PRAMFS_WRITE_PROTECT */
+#endif
