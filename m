Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932385Ab1EHSv2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 14:51:28 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:38416 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932230Ab1EHSuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 14:50:21 -0400
Date: Sun, 8 May 2011 20:44:08 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 9/14] HPFS: Fix a bug that filesystem was not marked dirty
 when remounting it
Message-ID: <alpine.DEB.2.00.1105082028570.7013@artax.karlin.mff.cuni.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a bug that filesystem was not marked dirty when remounting it

Signed-off-by: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>

---
 fs/hpfs/super.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

Index: linux-2.6.39-rc5-fast/fs/hpfs/super.c
===================================================================
--- linux-2.6.39-rc5-fast.orig/fs/hpfs/super.c	2011-05-05 01:02:52.000000000 +0200
+++ linux-2.6.39-rc5-fast/fs/hpfs/super.c	2011-05-05 01:02:55.000000000 +0200
@@ -18,9 +18,9 @@
 
 /* Mark the filesystem dirty, so that chkdsk checks it when os/2 booted */
 
-static void mark_dirty(struct super_block *s)
+static void mark_dirty(struct super_block *s, int remount)
 {
-	if (hpfs_sb(s)->sb_chkdsk && !(s->s_flags & MS_RDONLY)) {
+	if (hpfs_sb(s)->sb_chkdsk && (remount || !(s->s_flags & MS_RDONLY))) {
 		struct buffer_head *bh;
 		struct hpfs_spare_block *sb;
 		if ((sb = hpfs_map_sector(s, 17, &bh, 0))) {
@@ -66,13 +66,13 @@ void hpfs_error(struct super_block *s, c
 	if (!hpfs_sb(s)->sb_was_error) {
 		if (hpfs_sb(s)->sb_err == 2) {
 			printk("; crashing the system because you wanted it\n");
-			mark_dirty(s);
+			mark_dirty(s, 0);
 			panic("HPFS panic");
 		} else if (hpfs_sb(s)->sb_err == 1) {
 			if (s->s_flags & MS_RDONLY) printk("; already mounted read-only\n");
 			else {
 				printk("; remounting read-only\n");
-				mark_dirty(s);
+				mark_dirty(s, 0);
 				s->s_flags |= MS_RDONLY;
 			}
 		} else if (s->s_flags & MS_RDONLY) printk("; going on - but anything won't be destroyed because it's read-only\n");
@@ -419,7 +419,7 @@ static int hpfs_remount_fs(struct super_
 	sbi->sb_eas = eas; sbi->sb_chk = chk; sbi->sb_chkdsk = chkdsk;
 	sbi->sb_err = errs; sbi->sb_timeshift = timeshift;
 
-	if (!(*flags & MS_RDONLY)) mark_dirty(s);
+	if (!(*flags & MS_RDONLY)) mark_dirty(s, 1);
 
 	replace_mount_options(s, new_opts);
 
@@ -576,7 +576,7 @@ static int hpfs_fill_super(struct super_
 	if (spareblock->hotfixes_used || spareblock->n_spares_used) {
 		if (errs >= 2) {
 			printk("HPFS: Hotfixes not supported here, try chkdsk\n");
-			mark_dirty(s);
+			mark_dirty(s, 0);
 			goto bail4;
 		}
 		hpfs_error(s, "hotfixes not supported here, try chkdsk");
@@ -586,7 +586,7 @@ static int hpfs_fill_super(struct super_
 	if (spareblock->n_dnode_spares != spareblock->n_dnode_spares_free) {
 		if (errs >= 2) {
 			printk("HPFS: Spare dnodes used, try chkdsk\n");
-			mark_dirty(s);
+			mark_dirty(s, 0);
 			goto bail4;
 		}
 		hpfs_error(s, "warning: spare dnodes used, try chkdsk");
@@ -605,7 +605,7 @@ static int hpfs_fill_super(struct super_
 		if (hpfs_chk_sectors(s, superblock->dir_band_start, superblock->n_dir_band, "dir_band") ||
 		    hpfs_chk_sectors(s, superblock->dir_band_bitmap, 4, "dir_band_bitmap") ||
 		    hpfs_chk_sectors(s, superblock->bitmaps, 4, "bitmaps")) {
-			mark_dirty(s);
+			mark_dirty(s, 0);
 			goto bail4;
 		}
 		sbi->sb_dirband_size = a;
