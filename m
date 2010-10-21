Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935Ab0JUOoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 10:44:17 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48175 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911Ab0JUOoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 10:44:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qcJ0aOyqxPc99ZoLZvnzQ3V40Bo+onP8tDGHv6NlFm8QVHl5lSVHcuNA6DRWFyd3uc
         /FfoyvsItAfaI2bqB0u9oE0FHnwR2Qlapx1hYqzeSdwHbCOuydbFLEJP3Mu/rOvlHJVg
         V3FyaihzJEZoeoFIltTwXEtfLe7iFT1pSoQ0k=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org
Subject: [PATCH v2 12/22] ext4: use little-endian bitops
Date: Thu, 21 Oct 2010 23:41:07 +0900
Message-Id: <1287672077-5797-13-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1287672077-5797-1-git-send-email-akinobu.mita@gmail.com>
References: <1287672077-5797-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a preparation for removing ext2 non-atomic bit operations from
asm/bitops.h. This converts ext2 non-atomic bit operations to
little-endian bit operations.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org
---
No change from previous submission

 fs/ext4/ext4.h |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 889ec9d..821c11a 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -895,14 +895,20 @@ struct ext4_inode_info {
 #define test_opt(sb, opt)		(EXT4_SB(sb)->s_mount_opt & \
 					 EXT4_MOUNT_##opt)
 
-#define ext4_set_bit			ext2_set_bit
+#define ext4_set_bit(nr, addr)	\
+	__test_and_set_le_bit((nr), (unsigned long *)(addr))
 #define ext4_set_bit_atomic		ext2_set_bit_atomic
-#define ext4_clear_bit			ext2_clear_bit
+#define ext4_clear_bit(nr, addr)	\
+	__test_and_clear_le_bit((nr), (unsigned long *)(addr))
 #define ext4_clear_bit_atomic		ext2_clear_bit_atomic
-#define ext4_test_bit			ext2_test_bit
-#define ext4_find_first_zero_bit	ext2_find_first_zero_bit
-#define ext4_find_next_zero_bit		ext2_find_next_zero_bit
-#define ext4_find_next_bit		ext2_find_next_bit
+#define ext4_test_bit(nr, addr)	\
+	test_le_bit((nr), (unsigned long *)(addr))
+#define ext4_find_first_zero_bit(addr, size)	\
+	find_first_zero_le_bit((unsigned long *)(addr), (size))
+#define ext4_find_next_zero_bit(addr, size, off)	\
+	find_next_zero_le_bit((unsigned long *)(addr), (size), (off))
+#define ext4_find_next_bit(addr, size, off)	\
+	find_next_le_bit((unsigned long *)(addr), (size), (off))
 
 /*
  * Maximal mount counts between two filesystem checks
-- 
1.7.1.231.gd0b16

