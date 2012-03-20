Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760301Ab2CTOlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 10:41:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:13866 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760256Ab2CTOlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 10:41:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="141907426"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Ted Tso <tytso@mit.edu>
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH v1 8/9] ext4: small cleanup in ext4_commit_super
Date: Tue, 20 Mar 2012 16:41:28 +0200
Message-Id: <1332254489-2300-9-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1332254489-2300-1-git-send-email-dedekind1@gmail.com>
References: <1332254489-2300-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

We have many 'EXT4_SB(sb)' references in 'ext4_commit_super()' and I am going
to add another one, so I think the function will be a bit tidier if I introduce
a separate 'sbi' pointer for the ext4 superblock.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/ext4/super.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 7d453f7..64f3a6a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4132,8 +4132,9 @@ static int ext4_load_journal(struct super_block *sb,
 
 static int ext4_commit_super(struct super_block *sb, int sync)
 {
-	struct ext4_super_block *es = EXT4_SB(sb)->s_es;
-	struct buffer_head *sbh = EXT4_SB(sb)->s_sbh;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_super_block *es = sbi->s_es;
+	struct buffer_head *sbh = sbi->s_sbh;
 	int error = 0;
 
 	if (!sbh || block_device_ejected(sb))
@@ -4174,18 +4175,17 @@ static int ext4_commit_super(struct super_block *sb, int sync)
 		es->s_wtime = cpu_to_le32(get_seconds());
 	if (sb->s_bdev->bd_part)
 		es->s_kbytes_written =
-			cpu_to_le64(EXT4_SB(sb)->s_kbytes_written +
+			cpu_to_le64(sbi->s_kbytes_written +
 			    ((part_stat_read(sb->s_bdev->bd_part, sectors[1]) -
-			      EXT4_SB(sb)->s_sectors_written_start) >> 1));
+			      sbi->s_sectors_written_start) >> 1));
 	else
-		es->s_kbytes_written =
-			cpu_to_le64(EXT4_SB(sb)->s_kbytes_written);
+		es->s_kbytes_written = cpu_to_le64(sbi->s_kbytes_written);
 	ext4_free_blocks_count_set(es,
-			EXT4_C2B(EXT4_SB(sb), percpu_counter_sum_positive(
-				&EXT4_SB(sb)->s_freeclusters_counter)));
+			EXT4_C2B(sbi, percpu_counter_sum_positive(
+				&sbi->s_freeclusters_counter)));
 	es->s_free_inodes_count =
 		cpu_to_le32(percpu_counter_sum_positive(
-				&EXT4_SB(sb)->s_freeinodes_counter));
+				&sbi->s_freeinodes_counter));
 	BUFFER_TRACE(sbh, "marking dirty");
 	mark_buffer_dirty(sbh);
 	if (sync) {
-- 
1.7.7.6

