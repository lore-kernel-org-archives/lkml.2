Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab1APNMD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 08:12:03 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49634 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab1APNJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 08:09:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=FtLrlZ/BRMnha61DEzwwM2BCqud7vND7iHmD1RoZtiGFOfDSgcHdPgWD5mNtzL6OOU
         PeAvOITf5rb6OEhYHLutr7iFoIHej+cH1qo+c+ZXHicZlkf2egaa2nGp/oH9+TxFwZLu
         iNUQhl/nfaQSqY2uzXXTlPCqFzBdV4kX/usLM=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>
Subject: [PATCH v4 13/24] ext3: use little-endian bitops
Date: Sun, 16 Jan 2011 22:08:42 +0900
Message-Id: <1295183333-13802-14-git-send-email-akinobu.mita@gmail.com>
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
Acked-by: Jan Kara <jack@suse.cz>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

Change from v3:
 - change to the post-fix notation e.g. s/test_le_bit/test_bit_le/

The whole series is available in the git repository at:
 git://git.kernel.org/pub/scm/linux/kernel/git/mita/linux-2.6.git le-bitops-v4

 include/linux/ext3_fs.h |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
index 65990ef..0faf57c 100644
--- a/include/linux/ext3_fs.h
+++ b/include/linux/ext3_fs.h
@@ -418,13 +418,18 @@ struct ext3_inode {
 #define EXT2_MOUNT_DATA_FLAGS		EXT3_MOUNT_DATA_FLAGS
 #endif
 
-#define ext3_set_bit			ext2_set_bit
+#define ext3_set_bit(nr, addr)	\
+	__test_and_set_bit_le((nr), (unsigned long *)(addr))
 #define ext3_set_bit_atomic		ext2_set_bit_atomic
-#define ext3_clear_bit			ext2_clear_bit
+#define ext3_clear_bit(nr, addr)	\
+	__test_and_clear_bit_le((nr), (unsigned long *)(addr))
 #define ext3_clear_bit_atomic		ext2_clear_bit_atomic
-#define ext3_test_bit			ext2_test_bit
-#define ext3_find_first_zero_bit	ext2_find_first_zero_bit
-#define ext3_find_next_zero_bit		ext2_find_next_zero_bit
+#define ext3_test_bit(nr, addr)	\
+	test_bit_le((nr), (unsigned long *)(addr))
+#define ext3_find_first_zero_bit(addr, size)	\
+	find_first_zero_bit_le((unsigned long *)(addr), (size))
+#define ext3_find_next_zero_bit(addr, size, off)	\
+	find_next_zero_bit_le((unsigned long *)(addr), (size), (off))
 
 /*
  * Maximal mount counts between two filesystem checks
-- 
1.7.3.4

