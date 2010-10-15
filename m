Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab0JOJqH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 05:46:07 -0400
Received: from [150.82.175.143] ([150.82.175.143]:37676 "EHLO
	dhcpa11143.tky.aist.go.jp" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755025Ab0JOJo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 05:44:57 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Jan Kara <jack@suse.cz>
Subject: [PATCH 16/22] udf: use little endian bitops
Date: Fri, 15 Oct 2010 18:46:15 +0900
Message-Id: <1287135981-17604-17-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.1.231.gd0b16
In-Reply-To: <1287135981-17604-1-git-send-email-akinobu.mita@gmail.com>
References: <1287135981-17604-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a preparation for removing ext2 non-atomic bit operations from
asm/bitops.h. This converts ext2 non-atomic bit operations to
little endian bit operations.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Jan Kara <jack@suse.cz>
---
 fs/udf/balloc.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
index b608efa..e55aff9 100644
--- a/fs/udf/balloc.c
+++ b/fs/udf/balloc.c
@@ -27,11 +27,14 @@
 #include "udf_i.h"
 #include "udf_sb.h"
 
-#define udf_clear_bit(nr, addr) ext2_clear_bit(nr, addr)
-#define udf_set_bit(nr, addr) ext2_set_bit(nr, addr)
-#define udf_test_bit(nr, addr) ext2_test_bit(nr, addr)
+#define udf_clear_bit(nr, addr)	\
+	__test_and_clear_le_bit(nr, (unsigned long *)(addr))
+#define udf_set_bit(nr, addr)	\
+	__test_and_set_le_bit(nr, (unsigned long *)(addr))
+#define udf_test_bit(nr, addr)	\
+	test_le_bit(nr, (unsigned long *)(addr))
 #define udf_find_next_one_bit(addr, size, offset) \
-		ext2_find_next_bit(addr, size, offset)
+	find_next_le_bit((unsigned long *)(addr), size, offset)
 
 static int read_block_bitmap(struct super_block *sb,
 			     struct udf_bitmap *bitmap, unsigned int block,
-- 
1.7.1.231.gd0b16

