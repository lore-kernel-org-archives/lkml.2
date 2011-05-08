Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275Ab1EHSwv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 14:52:51 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:58405 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932227Ab1EHSuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 14:50:20 -0400
Date: Sun, 8 May 2011 20:43:41 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 7/14] HPFS: When marking or clearing the dirty bit, sync the
 filesystem
Message-ID: <alpine.DEB.2.00.1105082028000.7013@artax.karlin.mff.cuni.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When marking or clearing the dirty bit, sync the filesystem

Signed-off-by: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>

---
 fs/hpfs/super.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6.39-rc5-fast/fs/hpfs/super.c
===================================================================
--- linux-2.6.39-rc5-fast.orig/fs/hpfs/super.c	2011-05-05 01:02:47.000000000 +0200
+++ linux-2.6.39-rc5-fast/fs/hpfs/super.c	2011-05-05 01:02:52.000000000 +0200
@@ -27,6 +27,7 @@ static void mark_dirty(struct super_bloc
 			sb->dirty = 1;
 			sb->old_wrote = 0;
 			mark_buffer_dirty(bh);
+			sync_dirty_buffer(bh);
 			brelse(bh);
 		}
 	}
@@ -40,10 +41,12 @@ static void unmark_dirty(struct super_bl
 	struct buffer_head *bh;
 	struct hpfs_spare_block *sb;
 	if (s->s_flags & MS_RDONLY) return;
+	sync_blockdev(s->s_bdev);
 	if ((sb = hpfs_map_sector(s, 17, &bh, 0))) {
 		sb->dirty = hpfs_sb(s)->sb_chkdsk > 1 - hpfs_sb(s)->sb_was_error;
 		sb->old_wrote = hpfs_sb(s)->sb_chkdsk >= 2 && !hpfs_sb(s)->sb_was_error;
 		mark_buffer_dirty(bh);
+		sync_dirty_buffer(bh);
 		brelse(bh);
 	}
 }
