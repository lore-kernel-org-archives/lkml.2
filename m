Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758304Ab0JUOo5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 10:44:57 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48175 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755061Ab0JUOoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 10:44:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rjyKgLi9lQ/2qBm1o0YB+3hUEo75T3YQka0yA3tDkQHzbvzTyCG0D0RFFducKIly7r
         LzBBGCj28u2Cn4peLTLloePzi3d+sEhaxS6GcMxn4tZEpLsUzCdPXvKPDtoCWCXJlNwN
         jSSz/ZWxtGHGDLVaHeZmUGGtdmBHSF6Jwloak=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-raid@vger.kernel.org
Subject: [PATCH v2 18/22] md: use little-endian bit operations
Date: Thu, 21 Oct 2010 23:41:13 +0900
Message-Id: <1287672077-5797-19-git-send-email-akinobu.mita@gmail.com>
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
Acked-by: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
---
No change from previous submission

 drivers/md/bitmap.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index e4fb58d..2a37051 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -850,7 +850,7 @@ static void bitmap_file_set_bit(struct bitmap *bitmap, sector_t block)
 		if (bitmap->flags & BITMAP_HOSTENDIAN)
 			set_bit(bit, kaddr);
 		else
-			ext2_set_bit(bit, kaddr);
+			__test_and_set_le_bit(bit, kaddr);
 		kunmap_atomic(kaddr, KM_USER0);
 		PRINTK("set file bit %lu page %lu\n", bit, page->index);
 	}
@@ -1046,7 +1046,7 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 		if (bitmap->flags & BITMAP_HOSTENDIAN)
 			b = test_bit(bit, paddr);
 		else
-			b = ext2_test_bit(bit, paddr);
+			b = test_le_bit(bit, paddr);
 		kunmap_atomic(paddr, KM_USER0);
 		if (b) {
 			/* if the disk bit is set, set the memory bit */
@@ -1222,7 +1222,7 @@ void bitmap_daemon_work(mddev_t *mddev)
 						clear_bit(file_page_offset(bitmap, j),
 							  paddr);
 					else
-						ext2_clear_bit(file_page_offset(bitmap, j),
+						__test_and_clear_le_bit(file_page_offset(bitmap, j),
 							       paddr);
 					kunmap_atomic(paddr, KM_USER0);
 				} else
-- 
1.7.1.231.gd0b16

