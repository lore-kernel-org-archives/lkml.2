Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab2L0RU0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 12:20:26 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:57355 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab2L0RUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 12:20:24 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        bug-track@fisher-privat.net
Subject: [PATCH 2/2] fat: mark fs as dirty on mount and clean on umount
References: <87pq1vza3y.fsf@devron.myhome.or.jp>
Date: Fri, 28 Dec 2012 02:20:20 +0900
In-Reply-To: <87pq1vza3y.fsf@devron.myhome.or.jp> (OGAWA Hirofumi's message of
	"Fri, 28 Dec 2012 02:19:13 +0900")
Message-ID: <87han7za23.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Oleksij Rempel <bug-track@fisher-privat.net>

There is no documented methods to mark FAT as dirty. Unofficially MS
started to use reserved Byte in boot sector for this purpose,
at least since Win 2000. With Win 7 user is warned if fs is dirty
and asked to clean it.
Different versions of Win, handle it in different ways,
but always have same meaning:
- Win 2000 and XP, set it on write operations and
  remove it after operation was finnished
- Win 7, set dirty flag on first write and remove it on umount.

We will do it as fallow:
- set dirty flag on mount. If fs was initially dirty, warn user,
  remember it and do not do any changes to boot sector.
- clean it on umount. If fs was initially dirty, leave it dirty.
- do not do any thing if fs mounted read-only.
- TODO: leave fs dirty if we found some error after mount.

patch history:
- v2. do not warn on read-only. Some style fixes.
- v3. make fat_set_state static.
- v4. add "force" variable to fat_set_state and use it on remount ro to rw.

Signed-off-by: Oleksij Rempel <bug-track@fisher-privat.net>
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/fat.h                  |    2 +
 fs/fat/inode.c                |   66 +++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/msdos_fs.h |    2 +
 3 files changed, 70 insertions(+)

diff -puN fs/fat/fat.h~fat-check-dirty-2 fs/fat/fat.h
--- linux/fs/fat/fat.h~fat-check-dirty-2	2012-12-28 02:17:42.000000000 +0900
+++ linux-hirofumi/fs/fat/fat.h	2012-12-28 02:17:42.000000000 +0900
@@ -95,6 +95,8 @@ struct msdos_sb_info {
 
 	spinlock_t dir_hash_lock;
 	struct hlist_head dir_hashtable[FAT_HASH_SIZE];
+
+	unsigned int dirty;           /* fs state before mount */
 };
 
 #define FAT_CACHE_VALID	0	/* special case for valid cache */
diff -puN fs/fat/inode.c~fat-check-dirty-2 fs/fat/inode.c
--- linux/fs/fat/inode.c~fat-check-dirty-2	2012-12-28 02:17:42.000000000 +0900
+++ linux-hirofumi/fs/fat/inode.c	2012-12-28 02:17:42.000000000 +0900
@@ -488,10 +488,59 @@ static void fat_evict_inode(struct inode
 	fat_detach(inode);
 }
 
+static void fat_set_state(struct super_block *sb,
+			unsigned int set, unsigned int force)
+{
+	struct buffer_head *bh;
+	struct fat_boot_sector *b;
+	struct msdos_sb_info *sbi = sb->s_fs_info;
+
+	/* do not change any thing if mounted read only */
+	if ((sb->s_flags & MS_RDONLY) && !force)
+		return;
+
+	/* do not change state if fs was dirty */
+	if (sbi->dirty) {
+		/* warn only on set (mount). */
+		if (set)
+			fat_msg(sb, KERN_WARNING, "Volume was not properly "
+				"unmounted. Some data may be corrupt. "
+				"Please run fsck.");
+		return;
+	}
+
+	bh = sb_bread(sb, 0);
+	if (bh == NULL) {
+		fat_msg(sb, KERN_ERR, "unable to read boot sector "
+			"to mark fs as dirty");
+		return;
+	}
+
+	b = (struct fat_boot_sector *) bh->b_data;
+
+	if (sbi->fat_bits == 32) {
+		if (set)
+			b->fat32.state |= FAT_STATE_DIRTY;
+		else
+			b->fat32.state &= ~FAT_STATE_DIRTY;
+	} else /* fat 16 and 12 */ {
+		if (set)
+			b->fat16.state |= FAT_STATE_DIRTY;
+		else
+			b->fat16.state &= ~FAT_STATE_DIRTY;
+	}
+
+	mark_buffer_dirty(bh);
+	sync_dirty_buffer(bh);
+	brelse(bh);
+}
+
 static void fat_put_super(struct super_block *sb)
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 
+	fat_set_state(sb, 0, 0);
+
 	iput(sbi->fsinfo_inode);
 	iput(sbi->fat_inode);
 
@@ -566,8 +615,18 @@ static void __exit fat_destroy_inodecach
 
 static int fat_remount(struct super_block *sb, int *flags, char *data)
 {
+	int new_rdonly;
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 	*flags |= MS_NODIRATIME | (sbi->options.isvfat ? 0 : MS_NOATIME);
+
+	/* make sure we update state on remount. */
+	new_rdonly = *flags & MS_RDONLY;
+	if (new_rdonly != (sb->s_flags & MS_RDONLY)) {
+		if (new_rdonly)
+			fat_set_state(sb, 0, 0);
+		else
+			fat_set_state(sb, 1, 1);
+	}
 	return 0;
 }
 
@@ -1362,6 +1421,12 @@ int fat_fill_super(struct super_block *s
 	if (sbi->fat_bits != 32)
 		sbi->fat_bits = (total_clusters > MAX_FAT12) ? 16 : 12;
 
+	/* some OSes set FAT_STATE_DIRTY and clean it on unmount. */
+	if (sbi->fat_bits == 32)
+		sbi->dirty = b->fat32.state & FAT_STATE_DIRTY;
+	else /* fat 16 or 12 */
+		sbi->dirty = b->fat16.state & FAT_STATE_DIRTY;
+
 	/* check that FAT table does not overflow */
 	fat_clusters = sbi->fat_length * sb->s_blocksize * 8 / sbi->fat_bits;
 	total_clusters = min(total_clusters, fat_clusters - FAT_START_ENT);
@@ -1456,6 +1521,7 @@ int fat_fill_super(struct super_block *s
 					"the device does not support discard");
 	}
 
+	fat_set_state(sb, 1, 0);
 	return 0;
 
 out_invalid:
diff -puN include/uapi/linux/msdos_fs.h~fat-check-dirty-2 include/uapi/linux/msdos_fs.h
--- linux/include/uapi/linux/msdos_fs.h~fat-check-dirty-2	2012-12-28 02:17:42.000000000 +0900
+++ linux-hirofumi/include/uapi/linux/msdos_fs.h	2012-12-28 02:17:42.000000000 +0900
@@ -87,6 +87,8 @@
 #define IS_FSINFO(x)	(le32_to_cpu((x)->signature1) == FAT_FSINFO_SIG1 \
 			 && le32_to_cpu((x)->signature2) == FAT_FSINFO_SIG2)
 
+#define FAT_STATE_DIRTY 0x01
+
 struct __fat_dirent {
 	long		d_ino;
 	__kernel_off_t	d_off;
_

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
