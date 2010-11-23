Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab0KWNmA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 08:42:00 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39926 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476Ab0KWNkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 08:40:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=TlIr8kT613hHVnJ9TBvqFKlGCgggY60yXm/EbrilRzZ9vt9BMDWcR2r1r753o2X0Sj
         FykvN+CwgXR/X1sY19wY707TneHXW4VuBUYLd+I+F32jUxK4LrhdD/4u7QjQVlBSJm5r
         tlMq2ru1uTqtqgqyDmPwkyCHEaoOcTQI5F8/I=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v3 16/22] udf: use little-endian bitops
Date: Tue, 23 Nov 2010 22:38:18 +0900
Message-Id: <1290519504-3958-17-git-send-email-akinobu.mita@gmail.com>
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
---
No change from previous submission
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
1.7.3.2

