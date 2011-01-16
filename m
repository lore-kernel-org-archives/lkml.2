Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab1APNJY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 08:09:24 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48314 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336Ab1APNJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 08:09:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=nTqPNLp6n6PrhOW1HF+l+Cmcc8Xid2gNk3ujqpg859Q/ag3z3pTOXfW2RrIsYjaEWn
         1sYMVIDFH7ZFQsNDJx2lYuO68gSZ21ffbKuPhptDfaTpKZ+cW6zPvbUoRg/o5E4UuCLb
         2lKPZJ0XtF0Br+T7Y1kbQc1jm2wDcaRyJGt+Q=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Jan Kara <jack@suse.cz>
Subject: [PATCH v4 18/24] udf: use little-endian bitops
Date: Sun, 16 Jan 2011 22:08:47 +0900
Message-Id: <1295183333-13802-19-git-send-email-akinobu.mita@gmail.com>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

Change from v3:
 - change to the post-fix notation e.g. s/test_le_bit/test_bit_le/

The whole series is available in the git repository at:
 git://git.kernel.org/pub/scm/linux/kernel/git/mita/linux-2.6.git le-bitops-v4

 fs/udf/balloc.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
index 306ee39..7e71658 100644
--- a/fs/udf/balloc.c
+++ b/fs/udf/balloc.c
@@ -27,11 +27,14 @@
 #include "udf_i.h"
 #include "udf_sb.h"
 
-#define udf_clear_bit(nr, addr) ext2_clear_bit(nr, addr)
-#define udf_set_bit(nr, addr) ext2_set_bit(nr, addr)
-#define udf_test_bit(nr, addr) ext2_test_bit(nr, addr)
+#define udf_clear_bit(nr, addr)	\
+	__test_and_clear_bit_le(nr, (unsigned long *)(addr))
+#define udf_set_bit(nr, addr)	\
+	__test_and_set_bit_le(nr, (unsigned long *)(addr))
+#define udf_test_bit(nr, addr)	\
+	test_bit_le(nr, (unsigned long *)(addr))
 #define udf_find_next_one_bit(addr, size, offset) \
-		ext2_find_next_bit(addr, size, offset)
+	find_next_bit_le((unsigned long *)(addr), size, offset)
 
 static int read_block_bitmap(struct super_block *sb,
 			     struct udf_bitmap *bitmap, unsigned int block,
-- 
1.7.3.4

