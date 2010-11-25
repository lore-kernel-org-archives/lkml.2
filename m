Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab0KYOLZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 09:11:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752328Ab0KYOLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 09:11:24 -0500
From: Lukas Czerner <lczerner@redhat.com>
To: tytso@mit.edu
Cc: linux-kernel@vger.kernel.org, sandeen@redhat.com, lczerner@redhat.com
Subject: [PATCH] ext4: fix possible overflow in ext4_trim_fs()
Date: Thu, 25 Nov 2010 15:11:17 +0100
Message-Id: <1290694277-29462-1-git-send-email-lczerner@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When determining last group through ext4_get_group_no_and_offset() the
result may be wrong in cases when range->start and range-len are too
big, because it may overflow when summing up those two numbers.

Fix that by checking range->len and limit its value to
ext4_blocks_count(). This commit was tested by myself with expected
result.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/mballoc.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 5b4d4e3..7b05d92 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4819,6 +4819,7 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
 	ext4_group_t group, ngroups = ext4_get_groups_count(sb);
 	ext4_grpblk_t cnt = 0, first_block, last_block;
 	uint64_t start, len, minlen, trimmed;
+	ext4_fsblk_t blocks_count = ext4_blocks_count(EXT4_SB(sb)->s_es);
 	int ret = 0;
 
 	start = range->start >> sb->s_blocksize_bits;
@@ -4826,6 +4827,9 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
 	minlen = range->minlen >> sb->s_blocksize_bits;
 	trimmed = 0;
 
+	if (len > blocks_count)
+		len = blocks_count - start;
+
 	if (unlikely(minlen > EXT4_BLOCKS_PER_GROUP(sb)))
 		return -EINVAL;
 
-- 
1.7.2.3

