Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677Ab0KMOz0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 09:55:26 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38111 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754854Ab0KMOzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 09:55:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=jW11z2hqkgXevFTO3vHZumDGRZLpf8NvwTQc8C35aLwFFhXevllVxOlEcfSNbab5AL
         zCoSCLKlkDsuIlXLEXmG8XRR5ZAXek4F/BYTocChQuIYxwvZvCVl4eD08C7VE8I/Aitx
         dnOKV1cntBN8s+dUDCyqvrm67C/gpbRLyi8h8=
Message-ID: <4CDEA611.5050404@gmail.com>
Date: Sat, 13 Nov 2010 15:52:01 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 08/16 v3] pramfs: headers
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Stornelli <marco.stornelli@gmail.com>

Definitions for the PRAMFS filesystem.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
diff -Nurp linux-2.6.36-orig/fs/pramfs/pram.h linux-2.6.36/fs/pramfs/pram.h
--- linux-2.6.36-orig/fs/pramfs/pram.h	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.36/fs/pramfs/pram.h	2010-10-30 12:02:45.000000000 +0200
@@ -0,0 +1,317 @@
+/*
+ * FILE NAME pram.h
+ *
+ * BRIEF DESCRIPTION
+ *
+ * Definitions for the PRAMFS filesystem.
+ *
+ * Copyright 2009-2010 Marco Stornelli <marco.stornelli@gmail.com>
+ * Copyright 2003 Sony Corporation
+ * Copyright 2003 Matsushita Electric Industrial Co., Ltd.
+ * 2003-2004 (c) MontaVista Software, Inc. , Steve Longerbeam
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+#ifndef __PRAM_H
+#define __PRAM_H
+
+#include <linux/buffer_head.h>
+#include <linux/pram_fs.h>
+#include <linux/pram_fs_sb.h>
+#include <linux/crc16.h>
+#include <linux/mutex.h>
+#include <linux/types.h>
+
+/*
+ * Debug code
+ */
+#define pram_dbg(s, args...)	pr_debug("PRAMFS: "s, ## args)
+#define pram_err(s, args...)	pr_err("PRAMFS: "s, ## args)
+#define pram_warn(s, args...)	pr_warning("PRAMFS: "s, ## args)
+#define pram_info(s, args...)	pr_info("PRAMFS: "s, ## args)
+
+/* Function Prototypes */
+
+#ifdef CONFIG_PRAMFS_XIP
+
+#define pram_read	xip_file_read
+#define pram_write	xip_file_write
+#define pram_mmap	xip_file_mmap
+#define pram_aio_read	NULL
+#define pram_aio_write	NULL
+#define pram_readpage	NULL
+#define pram_direct_IO	NULL
+
+#else
+
+#define pram_read	do_sync_read
+#define pram_write	do_sync_write
+#define pram_mmap	__pram_mmap
+#define pram_aio_read	generic_file_aio_read
+#define pram_aio_write	generic_file_aio_write
+#define pram_direct_IO	__pram_direct_IO
+#define pram_readpage	__pram_readpage
+
+extern int pram_get_and_update_block(struct inode *inode, sector_t iblock,
+				     struct buffer_head *bh, int create);
+
+static inline int __pram_readpage(struct file *file, struct page *page)
+{
+	return block_read_full_page(page, pram_get_and_update_block);
+}
+
+/* file.c */
+extern ssize_t __pram_direct_IO(int rw, struct kiocb *iocb,
+			  const struct iovec *iov,
+			  loff_t offset, unsigned long nr_segs);
+extern int __pram_mmap(struct file *file, struct vm_area_struct *vma);
+
+#endif /* CONFIG_PRAMFS_XIP */
+
+#define pram_set_bit			ext2_set_bit
+#define pram_clear_bit			ext2_clear_bit
+#define pram_find_next_zero_bit		ext2_find_next_zero_bit
+
+/* balloc.c */
+extern void pram_init_bitmap(struct super_block *sb);
+extern void pram_free_block(struct super_block *sb, unsigned long blocknr);
+extern int pram_new_block(struct super_block *sb, unsigned long *blocknr, int zero);
+extern unsigned long pram_count_free_blocks(struct super_block *sb);
+
+/* dir.c */
+extern int pram_add_link(struct dentry *dentry, struct inode *inode);
+extern int pram_remove_link(struct inode *inode);
+
+/* namei.c */
+extern struct dentry *pram_get_parent(struct dentry *child);
+
+/* inode.c */
+extern int pram_alloc_blocks(struct inode *inode, int file_blocknr, int num);
+extern u64 pram_find_data_block(struct inode *inode,
+					 int file_blocknr);
+
+extern struct inode *pram_iget(struct super_block *sb, unsigned long ino);
+extern void pram_put_inode(struct inode *inode);
+extern void pram_evict_inode(struct inode *inode);
+extern struct inode *pram_new_inode(struct inode *dir, int mode);
+extern int pram_update_inode(struct inode *inode);
+extern int pram_write_inode(struct inode *inode, struct writeback_control *wbc);
+extern void pram_dirty_inode(struct inode *inode);
+extern int pram_notify_change(struct dentry *dentry, struct iattr *attr);
+
+
+/* super.c */
+#ifdef CONFIG_PRAMFS_TEST
+extern struct pram_super_block *get_pram_super(void);
+#endif
+extern struct super_block *pram_read_super(struct super_block *sb,
+					      void *data,
+					      int silent);
+extern int pram_statfs(struct dentry *d, struct kstatfs *buf);
+extern int pram_remount(struct super_block *sb, int *flags, char *data);
+
+/* symlink.c */
+extern int pram_block_symlink(struct inode *inode,
+			       const char *symname, int len);
+
+
+#ifdef CONFIG_PRAMFS_WRITE_PROTECT
+extern void pram_writeable(void *vaddr, unsigned long size, int rw);
+
+#define wrprotect(addr, size) pram_writeable(addr, size, 0)
+
+#else
+
+#define wrprotect(addr, size) do {} while (0)
+
+#endif /* CONFIG PRAMFS_WRITE_PROTECT */
+
+/* Inline functions start here */
+
+static inline int pram_calc_checksum(u8 *data, int n)
+{
+	u16 crc = 0;
+	crc = crc16(~0, (__u8 *)data + sizeof(__be16), n - sizeof(__be16));
+	if (*((__be16 *)data) == cpu_to_be16(crc))
+		return 0;
+	else
+		return 1;
+}
+
+/* If this is part of a read-modify-write of the super block,
+   pram_memunlock_super() before calling! */
+static inline struct pram_super_block *
+pram_get_super(struct super_block *sb)
+{
+	struct pram_sb_info *sbi = (struct pram_sb_info *)sb->s_fs_info;
+	return (struct pram_super_block *)sbi->virt_addr;
+}
+
+static inline struct pram_super_block *
+pram_get_redund_super(struct super_block *sb)
+{
+	struct pram_sb_info *sbi = (struct pram_sb_info *)sb->s_fs_info;
+	return (struct pram_super_block *)(sbi->virt_addr + PRAM_SB_SIZE);
+}
+
+/* pram_memunlock_super() before calling! */
+static inline void pram_sync_super(struct pram_super_block *ps)
+{
+	u16 crc = 0;
+	ps->s_wtime = cpu_to_be32(get_seconds());
+	ps->s_sum = 0;
+	crc = crc16(~0, (__u8 *)ps + sizeof(__be16), PRAM_SB_SIZE - sizeof(__be16));
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
+	crc = crc16(~0, (__u8 *)pi + sizeof(__be16), PRAM_INODE_SIZE - sizeof(__be16));
+	pi->i_sum = cpu_to_be16(crc);
+}
+
+#ifdef CONFIG_PRAMFS_WRITE_PROTECT
+static inline void pram_memunlock_range(void *p, unsigned long len)
+{
+#ifndef CONFIG_X86
+	local_irq_disable();
+#endif
+	preempt_disable();
+	pram_writeable(p, len, 1);
+}
+
+static inline void pram_memlock_range(void *p, unsigned long len)
+{
+	pram_writeable(p, len, 0);
+	preempt_enable();
+#ifndef CONFIG_X86
+	local_irq_enable();
+#endif
+}
+#else
+static inline void pram_memunlock_range(void *p, unsigned long len) {}
+static inline void pram_memlock_range(void *p, unsigned long len) {}
+#endif
+
+/* write protection for super block */
+#define pram_memunlock_super(ps) \
+	pram_memunlock_range((ps), PRAM_SB_SIZE)
+#define pram_memlock_super(ps) {\
+	pram_sync_super(ps);\
+	pram_memlock_range((ps), PRAM_SB_SIZE);\
+}
+
+/* write protection for inode metadata */
+#define pram_memunlock_inode(pi) \
+	pram_memunlock_range((pi), PRAM_INODE_SIZE)
+#define pram_memlock_inode(pi) {\
+	pram_sync_inode(pi);\
+	pram_memlock_range((pi), PRAM_INODE_SIZE);\
+}
+
+/* write protection for a data block */
+#define pram_memunlock_block(sb, bp) \
+	pram_memunlock_range((bp), (sb)->s_blocksize)
+#define pram_memlock_block(sb, bp) \
+	pram_memlock_range((bp), (sb)->s_blocksize)
+
+static inline void *
+pram_get_bitmap(struct super_block *sb)
+{
+	struct pram_super_block *ps = pram_get_super(sb);
+	return (void *)ps + be64_to_cpu(ps->s_bitmap_start);
+}
+
+/* If this is part of a read-modify-write of the inode metadata,
+   pram_memunlock_inode() before calling! */
+static inline struct pram_inode *
+pram_get_inode(struct super_block *sb, u64 ino)
+{
+	struct pram_super_block *ps = pram_get_super(sb);
+	return ino ? (struct pram_inode *)((void *)ps + ino) : NULL;
+}
+
+static inline ino_t
+pram_get_inodenr(struct super_block *sb, struct pram_inode *pi)
+{
+	struct pram_super_block *ps = pram_get_super(sb);
+	return (ino_t)((unsigned long)pi - (unsigned long)ps);
+}
+
+static inline u64
+pram_get_block_off(struct super_block *sb, unsigned long blocknr)
+{
+	struct pram_super_block *ps = pram_get_super(sb);
+	return (u64)(be64_to_cpu(ps->s_bitmap_start) +
+			     (blocknr << sb->s_blocksize_bits));
+}
+
+static inline unsigned long
+pram_get_blocknr(struct super_block *sb, u64 block)
+{
+	struct pram_super_block *ps = pram_get_super(sb);
+	return (block - be64_to_cpu(ps->s_bitmap_start)) >> sb->s_blocksize_bits;
+}
+
+/* If this is part of a read-modify-write of the block,
+   pram_memunlock_block() before calling! */
+static inline void *
+pram_get_block(struct super_block *sb, u64 block)
+{
+	struct pram_super_block *ps = pram_get_super(sb);
+	return block ? ((void *)ps + block) : NULL;
+}
+
+struct pram_inode_vfs {
+#ifdef CONFIG_PRAMFS_XATTR
+	/*
+	 * Extended attributes can be read independently of the main file
+	 * data. Taking i_mutex even when reading would cause contention
+	 * between readers of EAs and writers of regular file data, so
+	 * instead we synchronize on xattr_sem when reading or changing
+	 * EAs.
+	 */
+	struct rw_semaphore xattr_sem;
+#endif
+	/*
+	 * truncate_mutex is for serialising the truncate path against
+	 * get/update block.
+	 */
+	struct mutex truncate_mutex;
+	struct inode vfs_inode;
+};
+
+static inline struct pram_inode_vfs *PRAM_I(struct inode *inode)
+{
+	return container_of(inode, struct pram_inode_vfs, vfs_inode);
+}
+
+/*
+ * Inodes and files operations
+ */
+
+/* dir.c */
+extern struct file_operations pram_dir_operations;
+
+/* file.c */
+extern struct inode_operations pram_file_inode_operations;
+extern struct file_operations pram_file_operations;
+
+/* inode.c */
+extern struct address_space_operations pram_aops;
+
+/* namei.c */
+extern struct inode_operations pram_dir_inode_operations;
+
+/* symlink.c */
+extern struct inode_operations pram_symlink_inode_operations;
+
+extern struct backing_dev_info pram_backing_dev_info;
+
+#endif	/* __PRAM_H */
diff -Nurp linux-2.6.36-orig/include/linux/magic.h linux-2.6.36/include/linux/magic.h
--- linux-2.6.36-orig/include/linux/magic.h	2010-09-13 01:07:37.000000000 +0200
+++ linux-2.6.36/include/linux/magic.h	2010-09-14 18:49:52.000000000 +0200
@@ -39,6 +39,7 @@
 #define OPENPROM_SUPER_MAGIC	0x9fa1
 #define PROC_SUPER_MAGIC	0x9fa0
 #define QNX4_SUPER_MAGIC	0x002f		/* qnx4 fs detection */
+#define PRAM_SUPER_MAGIC	0xEFFA
  #define REISERFS_SUPER_MAGIC	0x52654973	/* used by gcc */
 					/* used by file system utilities that
diff -Nurp linux-2.6.36-orig/include/linux/pram_fs.h linux-2.6.36/include/linux/pram_fs.h
--- linux-2.6.36-orig/include/linux/pram_fs.h	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.36/include/linux/pram_fs.h	2010-09-25 14:10:14.000000000 +0200
@@ -0,0 +1,118 @@
+/*
+ * FILE NAME include/linux/pram_fs.h
+ *
+ * BRIEF DESCRIPTION
+ *
+ * Definitions for the PRAMFS filesystem.
+ *
+ * Copyright 2009-2010 Marco Stornelli <marco.stornelli@gmail.com>
+ * Copyright 2003 Sony Corporation
+ * Copyright 2003 Matsushita Electric Industrial Co., Ltd.
+ * 2003-2004 (c) MontaVista Software, Inc. , Steve Longerbeam
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+#ifndef _LINUX_PRAM_FS_H
+#define _LINUX_PRAM_FS_H
+
+#include <linux/types.h>
+#include <linux/magic.h>
+
+/*
+ * The PRAM filesystem constants/structures
+ */
+
+/*
+ * Maximal count of links to a file
+ */
+#define PRAM_LINK_MAX		32000
+
+#define PRAM_MIN_BLOCK_SIZE 512
+#define PRAM_MAX_BLOCK_SIZE 4096
+#define PRAM_DEF_BLOCK_SIZE 2048
+
+#define PRAM_INODE_SIZE 128 /* must be power of two */
+#define PRAM_INODE_BITS   7
+
+/*
+ * Structure of a directory entry in PRAMFS.
+ * Offsets are to the inode that holds the referenced dentry.
+ */
+struct pram_dentry {
+	__be64	d_next;     /* next dentry in this directory */
+	__be64	d_prev;     /* previous dentry in this directory */
+	__be64	d_parent;   /* parent directory */
+	char	d_name[0];
+};
+
+
+/*
+ * Structure of an inode in PRAMFS
+ */
+struct pram_inode {
+	__be16	i_sum;          /* checksum of this inode */
+	__be32	i_uid;		/* Owner Uid */
+	__be32	i_gid;		/* Group Id */
+	__be16	i_mode;		/* File mode */
+	__be16	i_links_count;	/* Links count */
+	__be32	i_blocks;	/* Blocks count */
+	__be32	i_size;		/* Size of data in bytes */
+	__be32	i_atime;	/* Access time */
+	__be32	i_ctime;	/* Creation time */
+	__be32	i_mtime;	/* Modification time */
+	__be32	i_dtime;	/* Deletion Time */
+	__be64	i_xattr;	/* Extended attribute block */
+	__be32	i_generation;	/* File version (for NFS) */
+
+	union {
+		struct {
+			/*
+			 * ptr to row block of 2D block pointer array,
+			 * file block #'s 0 to (blocksize/8)^2 - 1.
+			 */
+			__be64 row_block;
+		} reg;   /* regular file or symlink inode */
+		struct {
+			__be64 head; /* first entry in this directory */
+			__be64 tail; /* last entry in this directory */
+		} dir;
+		struct {
+			__be32 rdev; /* major/minor # */
+		} dev;   /* device inode */
+	} i_type;
+
+	struct pram_dentry i_d;
+};
+
+#define PRAM_NAME_LEN \
+    (PRAM_INODE_SIZE - offsetof(struct pram_inode, i_d.d_name) - 1)
+
+
+#define PRAM_SB_SIZE 128 /* must be power of two */
+
+/*
+ * Structure of the super block in PRAMFS
+ */
+struct pram_super_block {
+	__be16	s_sum;          /* checksum of this sb, including padding */
+	__be64	s_size;         /* total size of fs in bytes */
+	__be32	s_blocksize;    /* blocksize in bytes */
+	__be32	s_inodes_count;	/* total inodes count (used or free) */
+	__be32	s_free_inodes_count;/* free inodes count */
+	__be32	s_free_inode_hint;  /* start hint for locating free inodes */
+	__be32	s_blocks_count;	/* total data blocks count (used or free) */
+	__be32	s_free_blocks_count;/* free data blocks count */
+	__be32	s_free_blocknr_hint;/* free data blocks count */
+	__be64	s_bitmap_start; /* data block in-use bitmap location */
+	__be32	s_bitmap_blocks;/* size of bitmap in number of blocks */
+	__be32	s_mtime;	/* Mount time */
+	__be32	s_wtime;	/* Write time */
+	__be16	s_magic;	/* Magic signature */
+	char	s_volume_name[16]; /* volume name */
+};
+
+/* The root inode follows immediately after the redundant super block */
+#define PRAM_ROOT_INO (PRAM_SB_SIZE*2)
+
+#endif	/* _LINUX_PRAM_FS_H */
diff -Nurp linux-2.6.36-orig/include/linux/pram_fs_sb.h linux-2.6.36/include/linux/pram_fs_sb.h
--- linux-2.6.36-orig/include/linux/pram_fs_sb.h	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.36/include/linux/pram_fs_sb.h	2010-09-18 08:39:39.000000000 +0200
@@ -0,0 +1,44 @@
+/*
+ * FILE NAME include/linux/pram_fs_sb.h
+ *
+ * Definitions for the PRAM filesystem.
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
+#ifndef _LINUX_PRAM_FS_SB
+#define _LINUX_PRAM_FS_SB
+
+/*
+ * PRAM filesystem super-block data in memory
+ */
+struct pram_sb_info {
+	/*
+	 * base physical and virtual address of PRAMFS (which is also
+	 * the pointer to the super block)
+	 */
+	phys_addr_t phys_addr;
+	void *virt_addr;
+
+	/* Mount options */
+	unsigned long bpi;
+	unsigned long num_inodes;
+	unsigned long blocksize;
+	unsigned long initsize;
+	uid_t uid;		    /* Mount uid for root directory */
+	gid_t gid;		    /* Mount gid for root directory */
+	mode_t mode;		    /* Mount mode for root directory */
+	atomic_t next_generation;
+#ifdef CONFIG_PRAMFS_XATTR
+	struct rb_root desc_tree;
+	spinlock_t desc_tree_lock;
+#endif
+};
+
+#endif	/* _LINUX_PRAM_FS_SB */
 
