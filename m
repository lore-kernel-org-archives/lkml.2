Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab0KWNkC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 08:40:02 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57002 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358Ab0KWNj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 08:39:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=WTaqpA4ltvjfQ6oAGzo1O7nU4yKbFoeW3XCvaKIktGIFuZJI0SQhGJka325hI829VI
         lVnNrPrJ8jl2eClYBTwy7YfleaebB9RCtyG1kQFFpi7Qj4yWPoSIGo8A79R/hqi9j949
         jsW+SnVWkXhVO1zPTnVseKUtk9PqZEMGs7fb8=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org
Subject: [PATCH v3 11/22] ext3: use little-endian bitops
Date: Tue, 23 Nov 2010 22:38:13 +0900
Message-Id: <1290519504-3958-12-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1290519504-3958-1-git-send-email-akinobu.mita@gmail.com>
References: <1290519504-3958-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a preparation for removing ext2 non-atomic bit operations from
asm/bitops.h. This converts ext2 non-atomic bit operations to
little-endian bit operations.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org
---
No change from previous submission
 include/linux/ext3_fs.h |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
index 6ce1bca..34ef455 100644
--- a/include/linux/ext3_fs.h
+++ b/include/linux/ext3_fs.h
@@ -418,13 +418,18 @@ struct ext3_inode {
 #define EXT2_MOUNT_DATA_FLAGS		EXT3_MOUNT_DATA_FLAGS
 #endif
 
-#define ext3_set_bit			ext2_set_bit
+#define ext3_set_bit(nr, addr)	\
+	__test_and_set_le_bit((nr), (unsigned long *)(addr))
 #define ext3_set_bit_atomic		ext2_set_bit_atomic
-#define ext3_clear_bit			ext2_clear_bit
+#define ext3_clear_bit(nr, addr)	\
+	__test_and_clear_le_bit((nr), (unsigned long *)(addr))
 #define ext3_clear_bit_atomic		ext2_clear_bit_atomic
-#define ext3_test_bit			ext2_test_bit
-#define ext3_find_first_zero_bit	ext2_find_first_zero_bit
-#define ext3_find_next_zero_bit		ext2_find_next_zero_bit
+#define ext3_test_bit(nr, addr)	\
+	test_le_bit((nr), (unsigned long *)(addr))
+#define ext3_find_first_zero_bit(addr, size)	\
+	find_first_zero_le_bit((unsigned long *)(addr), (size))
+#define ext3_find_next_zero_bit(addr, size, off)	\
+	find_next_zero_le_bit((unsigned long *)(addr), (size), (off))
 
 /*
  * Maximal mount counts between two filesystem checks
-- 
1.7.3.2

