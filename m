Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144Ab0KMOzs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 09:55:48 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38111 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756653Ab0KMOzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 09:55:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=at4dyuR6l4HeS93xWPcMvAl5kVOUvAVO21e9XZ1bFlHQ3UqqsKVkhIW2+kut3oZy6O
         Od/scqTrQndEZz2fH7ys9QVvZqEJM5fX754XBtqbIxRtDkXslvDg31d1WQVuEbcBEpCQ
         0R2BQcPrat90dIL6ErqM1vyVAT2Errq6MHrlQ=
Message-ID: <4CDEA62D.4070308@gmail.com>
Date: Sat, 13 Nov 2010 15:52:29 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 09/16 v3] pramfs: dir operations
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Stornelli <marco.stornelli@gmail.com>

File operations for directories.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
diff -Nurp linux-2.6.36-orig/fs/pramfs/dir.c linux-2.6.36/fs/pramfs/dir.c
--- linux-2.6.36-orig/fs/pramfs/dir.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.36/fs/pramfs/dir.c	2010-09-17 19:08:54.000000000 +0200
@@ -0,0 +1,215 @@
+/*
+ * FILE NAME fs/pramfs/dir.c
+ *
+ * BRIEF DESCRIPTION
+ *
+ * File operations for directories.
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
+#include <linux/pagemap.h>
+#include "pram.h"
+
+/*
+ *	Parent is locked.
+ */
+int pram_add_link(struct dentry *dentry, struct inode *inode)
+{
+	struct inode *dir = dentry->d_parent->d_inode;
+	struct pram_inode *pidir, *pi, *pitail = NULL;
+	u64 tail_ino, prev_ino;
+
+	const char *name = dentry->d_name.name;
+
+	int namelen = dentry->d_name.len > PRAM_NAME_LEN ?
+		PRAM_NAME_LEN : dentry->d_name.len;
+
+	pidir = pram_get_inode(dir->i_sb, dir->i_ino);
+	pi = pram_get_inode(dir->i_sb, inode->i_ino);
+
+	dir->i_mtime = dir->i_ctime = CURRENT_TIME;
+
+	tail_ino = be64_to_cpu(pidir->i_type.dir.tail);
+	if (tail_ino != 0) {
+		pitail = pram_get_inode(dir->i_sb, tail_ino);
+		pram_memunlock_inode(pitail);
+		pitail->i_d.d_next = cpu_to_be64(inode->i_ino);
+		pram_memlock_inode(pitail);
+
+		prev_ino = tail_ino;
+
+		pram_memunlock_inode(pidir);
+		pidir->i_type.dir.tail = cpu_to_be64(inode->i_ino);
+		pidir->i_mtime = cpu_to_be32(dir->i_mtime.tv_sec);
+		pidir->i_ctime = cpu_to_be32(dir->i_ctime.tv_sec);
+		pram_memlock_inode(pidir);
+	} else {
+		/* the directory is empty */
+		prev_ino = 0;
+
+		pram_memunlock_inode(pidir);
+		pidir->i_type.dir.tail = cpu_to_be64(inode->i_ino);
+		pidir->i_type.dir.head = cpu_to_be64(inode->i_ino);
+		pidir->i_mtime = cpu_to_be32(dir->i_mtime.tv_sec);
+		pidir->i_ctime = cpu_to_be32(dir->i_ctime.tv_sec);
+		pram_memlock_inode(pidir);
+	}
+
+
+	pram_memunlock_inode(pi);
+	pi->i_d.d_prev = cpu_to_be64(prev_ino);
+	pi->i_d.d_parent = cpu_to_be64(dir->i_ino);
+	memcpy(pi->i_d.d_name, name, namelen);
+	pi->i_d.d_name[namelen] = '\0';
+	pram_memlock_inode(pi);
+	return 0;
+}
+
+int pram_remove_link(struct inode *inode)
+{
+	struct super_block *sb = inode->i_sb;
+	struct pram_inode *prev = NULL;
+	struct pram_inode *next = NULL;
+	struct pram_inode *pidir, *pi;
+
+	pi = pram_get_inode(sb, inode->i_ino);
+	pidir = pram_get_inode(sb, be64_to_cpu(pi->i_d.d_parent));
+	if (!pidir)
+		return -EACCES;
+
+	if (inode->i_ino == be64_to_cpu(pidir->i_type.dir.head)) {
+		/* first inode in directory */
+		next = pram_get_inode(sb, be64_to_cpu(pi->i_d.d_next));
+
+		if (next) {
+			pram_memunlock_inode(next);
+			next->i_d.d_prev = 0;
+			pram_memlock_inode(next);
+
+			pram_memunlock_inode(pidir);
+			pidir->i_type.dir.head = pi->i_d.d_next;
+		} else {
+			pram_memunlock_inode(pidir);
+			pidir->i_type.dir.head = 0;
+			pidir->i_type.dir.tail = 0;
+		}
+		pram_memlock_inode(pidir);
+	} else if (inode->i_ino == be64_to_cpu(pidir->i_type.dir.tail)) {
+		/* last inode in directory */
+		prev = pram_get_inode(sb, be64_to_cpu(pi->i_d.d_prev));
+
+		pram_memunlock_inode(prev);
+		prev->i_d.d_next = 0;
+		pram_memlock_inode(prev);
+
+		pram_memunlock_inode(pidir);
+		pidir->i_type.dir.tail = pi->i_d.d_prev;
+		pram_memlock_inode(pidir);
+	} else {
+		/* somewhere in the middle */
+		prev = pram_get_inode(sb, be64_to_cpu(pi->i_d.d_prev));
+		next = pram_get_inode(sb, be64_to_cpu(pi->i_d.d_next));
+
+		if (prev && next) {
+			pram_memunlock_inode(prev);
+			prev->i_d.d_next = pi->i_d.d_next;
+			pram_memlock_inode(prev);
+
+			pram_memunlock_inode(next);
+			next->i_d.d_prev = pi->i_d.d_prev;
+			pram_memlock_inode(next);
+		}
+	}
+
+	pram_memunlock_inode(pi);
+	pi->i_d.d_next = 0;
+	pi->i_d.d_prev = 0;
+	pi->i_d.d_parent = 0;
+	pram_memlock_inode(pi);
+
+	return 0;
+}
+
+#define S_SHIFT 12
+static unsigned int dtype_by_mode[S_IFMT >> S_SHIFT] = {
+	[S_IFREG >> S_SHIFT]    DT_REG,
+	[S_IFDIR >> S_SHIFT]    DT_DIR,
+	[S_IFCHR >> S_SHIFT]    DT_CHR,
+	[S_IFBLK >> S_SHIFT]    DT_BLK,
+	[S_IFIFO >> S_SHIFT]    DT_FIFO,
+	[S_IFSOCK >> S_SHIFT]   DT_SOCK,
+	[S_IFLNK >> S_SHIFT]    DT_LNK,
+};
+
+static int pram_readdir(struct file *filp, void *dirent, filldir_t filldir)
+{
+	struct inode *inode = filp->f_dentry->d_inode;
+	struct super_block *sb = inode->i_sb;
+	struct pram_inode *pi;
+	int namelen, ret = 0;
+	char *name;
+	ino_t ino;
+
+	pi = pram_get_inode(sb, inode->i_ino);
+
+	switch ((unsigned long)filp->f_pos) {
+	case 0:
+		ret = filldir(dirent, ".", 1, 0, inode->i_ino, DT_DIR);
+		filp->f_pos++;
+		return ret;
+	case 1:
+		ret = filldir(dirent, "..", 2, 1, be64_to_cpu(pi->i_d.d_parent), DT_DIR);
+		ino = be64_to_cpu(pi->i_type.dir.head);
+		filp->f_pos = ino ? ino : 2;
+		return ret;
+	case 2:
+		ino = be64_to_cpu(pi->i_type.dir.head);
+		if (ino) {
+			filp->f_pos = ino;
+			pi = pram_get_inode(sb, ino);
+			break;
+		} else {
+			/* the directory is empty */
+			filp->f_pos = 2;
+			return 0;
+		}
+	case 3:
+		return 0;
+	default:
+		ino = filp->f_pos;
+		pi = pram_get_inode(sb, ino);
+		break;
+	}
+
+	while (pi && !be16_to_cpu(pi->i_links_count)) {
+		ino = filp->f_pos = be64_to_cpu(pi->i_d.d_next);
+		pi = pram_get_inode(sb, ino);
+	}
+
+	if (pi) {
+		name = pi->i_d.d_name;
+		namelen = strlen(name);
+
+		ret = filldir(dirent, name, namelen,
+			      filp->f_pos, ino,
+			      dtype_by_mode[(be16_to_cpu(pi->i_mode) & S_IFMT)>>S_SHIFT]);
+		filp->f_pos = pi->i_d.d_next ? be64_to_cpu(pi->i_d.d_next) : 3;
+	} else
+		filp->f_pos = 3;
+
+	return ret;
+}
+
+struct file_operations pram_dir_operations = {
+	.read		= generic_read_dir,
+	.readdir	= pram_readdir,
+	.fsync		= noop_fsync,
+};
 
