Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751289Ab1FZF4r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 01:56:47 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53142 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab1FZF4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 01:56:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kqAkzhROotr5Fdqdo4nJzjzUtx0Ck3p7NWfuPD9rIMyg//ro/+ipUr2v8+jKFI2t1g
         uC3ejuKgpdiWHmx+dg+futT88LUXgqaqfrqFzOLqZMzHof5Y7ZuLY/lTV2caqNn2cnlD
         Y7wRahC2j8AmCr1bnoIrNyVc0rJGbQqcbjT7o=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org
Subject: [PATCH resend 1/6] ext4: use proper little-endian bitops
Date: Sun, 26 Jun 2011 14:57:51 +0900
Message-Id: <1309067876-3537-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1309067876-3537-1-git-send-email-akinobu.mita@gmail.com>
References: <1309067876-3537-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext4_{set,clear}_bit() is defined as __test_and_{set,clear}_bit_le()
for ext4.  Only two ext4_{set,clear}_bit() calls check the return
value. The rest of calls ignore the return value and they can be
replaced with __{set,clear}_bit_le().

This changes ext4_{set,clear}_bit() from __test_and_{set,clear}_bit_le()
to __{set,clear}_bit_le() and introduces ext4_test_and_{set,clear}_bit()
for the two places where old bit needs to be returned.

This ext4_{set,clear}_bit() change is considered safe, because if someone
uses these macros without noticing the change, new ext4_{set,clear}_bit
don't have return value and causes compiler errors where the return
value is used.

This also removes unused ext4_find_first_zero_bit().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org
---
 fs/ext4/ext4.h   |    7 ++++---
 fs/ext4/ialloc.c |    4 ++--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 1921392..cb65177 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -930,12 +930,13 @@ struct ext4_inode_info {
 #define test_opt2(sb, opt)		(EXT4_SB(sb)->s_mount_opt2 & \
 					 EXT4_MOUNT2_##opt)
 
-#define ext4_set_bit			__test_and_set_bit_le
+#define ext4_test_and_set_bit		__test_and_set_bit_le
+#define ext4_set_bit			__set_bit_le
 #define ext4_set_bit_atomic		ext2_set_bit_atomic
-#define ext4_clear_bit			__test_and_clear_bit_le
+#define ext4_test_and_clear_bit		__test_and_clear_bit_le
+#define ext4_clear_bit			__clear_bit_le
 #define ext4_clear_bit_atomic		ext2_clear_bit_atomic
 #define ext4_test_bit			test_bit_le
-#define ext4_find_first_zero_bit	find_first_zero_bit_le
 #define ext4_find_next_zero_bit		find_next_zero_bit_le
 #define ext4_find_next_bit		find_next_bit_le
 
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 21bb2f6..e3de479 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -252,7 +252,7 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
 		fatal = ext4_journal_get_write_access(handle, bh2);
 	}
 	ext4_lock_group(sb, block_group);
-	cleared = ext4_clear_bit(bit, bitmap_bh->b_data);
+	cleared = ext4_test_and_clear_bit(bit, bitmap_bh->b_data);
 	if (fatal || !cleared) {
 		ext4_unlock_group(sb, block_group);
 		goto out;
@@ -729,7 +729,7 @@ static int ext4_claim_inode(struct super_block *sb,
 	 */
 	down_read(&grp->alloc_sem);
 	ext4_lock_group(sb, group);
-	if (ext4_set_bit(ino, inode_bitmap_bh->b_data)) {
+	if (ext4_test_and_set_bit(ino, inode_bitmap_bh->b_data)) {
 		/* not a free inode */
 		retval = 1;
 		goto err_ret;
-- 
1.7.4.4

