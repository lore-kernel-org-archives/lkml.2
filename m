Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab2DBLqM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:46:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:58478 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477Ab2DBLpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:45:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="124444287"
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
To: Ted Tso <tytso@mit.edu>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Ext4 Mailing List <linux-ext4@vger.kernel.org>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH v2 1/4] ext4: Remove useless marking of superblock dirty
Date: Mon,  2 Apr 2012 14:45:36 +0300
Message-Id: <1333367140-28370-2-git-send-email-artem.bityutskiy@linux.intel.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1333367140-28370-1-git-send-email-artem.bityutskiy@linux.intel.com>
References: <1333367140-28370-1-git-send-email-artem.bityutskiy@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

Commit a0375156 properly notes that superblock doesn't need to be marked
as dirty when only number of free inodes / blocks / number of directories
changes since that is recomputed on each mount anyway. However that comment
leaves some unnecessary markings as dirty in place. Remove these.

Artem: tested using xfstests for both journalled and non-journalled ext4.

Signed-off-by: Jan Kara <jack@suse.cz>
Tested-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/ext4/ialloc.c  |    2 --
 fs/ext4/mballoc.c |    2 --
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 409c2ee..b7188c6 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -295,7 +295,6 @@ out:
 		err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
 		if (!fatal)
 			fatal = err;
-		ext4_mark_super_dirty(sb);
 	} else
 		ext4_error(sb, "bit already cleared for inode %lu", ino);
 
@@ -800,7 +799,6 @@ got:
 	percpu_counter_dec(&sbi->s_freeinodes_counter);
 	if (S_ISDIR(mode))
 		percpu_counter_inc(&sbi->s_dirs_counter);
-	ext4_mark_super_dirty(sb);
 
 	if (sbi->s_log_groups_per_flex) {
 		flex_group = ext4_flex_group(sbi, group);
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 99ab428..3db3dfc 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2822,7 +2822,6 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 	err = ext4_handle_dirty_metadata(handle, NULL, gdp_bh);
 
 out_err:
-	ext4_mark_super_dirty(sb);
 	brelse(bitmap_bh);
 	return err;
 }
@@ -4692,7 +4691,6 @@ do_more:
 		put_bh(bitmap_bh);
 		goto do_more;
 	}
-	ext4_mark_super_dirty(sb);
 error_return:
 	brelse(bitmap_bh);
 	ext4_std_error(sb, err);
-- 
1.7.7.6

