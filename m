Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab1APNJM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 08:09:12 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48314 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359Ab1APNJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 08:09:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=NX3xuePTiEIZD8VXJ12juCmrMqgbrrluDkZZMdYZKjVXj1dVc0ozvHnV3hqc5fBZ5O
         DB68dn2oCthzQySftAO1enUZyAcewMnov8hKlzwnS9FM5UxbEPyWRzI79wFC7FhUWpOu
         w9gS6k+Kj2q0MeMVNVtzij6fB62T5jo5g6IHM=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH v4 14/24] ext4: use little-endian bitops
Date: Sun, 16 Jan 2011 22:08:43 +0900
Message-Id: <1295183333-13802-15-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1295183333-13802-1-git-send-email-akinobu.mita@gmail.com>
References: <1295183333-13802-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a preparation for removing ext2 non-atomic bit operations from
asm/bitops.h.  This converts ext2 non-atomic bit operations to
little-endian bit operations.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

Change from v3:
 - change to the post-fix notation e.g. s/test_le_bit/test_bit_le/

The whole series is available in the git repository at:
 git://git.kernel.org/pub/scm/linux/kernel/git/mita/linux-2.6.git le-bitops-v4

 fs/ext4/ext4.h |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 1de65f5..eaad5fc 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -922,14 +922,20 @@ struct ext4_inode_info {
 #define test_opt2(sb, opt)		(EXT4_SB(sb)->s_mount_opt2 & \
 					 EXT4_MOUNT2_##opt)
 
-#define ext4_set_bit			ext2_set_bit
+#define ext4_set_bit(nr, addr)	\
+	__test_and_set_bit_le((nr), (unsigned long *)(addr))
 #define ext4_set_bit_atomic		ext2_set_bit_atomic
-#define ext4_clear_bit			ext2_clear_bit
+#define ext4_clear_bit(nr, addr)	\
+	__test_and_clear_bit_le((nr), (unsigned long *)(addr))
 #define ext4_clear_bit_atomic		ext2_clear_bit_atomic
-#define ext4_test_bit			ext2_test_bit
-#define ext4_find_first_zero_bit	ext2_find_first_zero_bit
-#define ext4_find_next_zero_bit		ext2_find_next_zero_bit
-#define ext4_find_next_bit		ext2_find_next_bit
+#define ext4_test_bit(nr, addr)	\
+	test_bit_le((nr), (unsigned long *)(addr))
+#define ext4_find_first_zero_bit(addr, size)	\
+	find_first_zero_bit_le((unsigned long *)(addr), (size))
+#define ext4_find_next_zero_bit(addr, size, off)	\
+	find_next_zero_bit_le((unsigned long *)(addr), (size), (off))
+#define ext4_find_next_bit(addr, size, off)	\
+	find_next_bit_le((unsigned long *)(addr), (size), (off))
 
 /*
  * Maximal mount counts between two filesystem checks
-- 
1.7.3.4

