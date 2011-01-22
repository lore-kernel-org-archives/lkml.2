Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab1AVNO5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 08:14:57 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43821 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab1AVNOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 08:14:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kAYr3ES3S5nFuXH9ZMyJQskODNpuFAbMZ5MLE/gjreyPu8E1/Y0km+A/NaY41kXG/P
         Ks8qNaly5uMTdwbITP8EL6aJyUaSalPbxyJSz/tgJrofopJUn1Lns68mJsC4ajaWy71E
         9uUxeKo4XndfuI8ITfOpOStER51Ck1kzrYV5o=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, NeilBrown <neilb@suse.de>
Subject: [PATCH v5 23/27] md: use little-endian bitops
Date: Sat, 22 Jan 2011 22:13:55 +0900
Message-Id: <1295702039-23186-24-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1295702039-23186-1-git-send-email-akinobu.mita@gmail.com>
References: <1295702039-23186-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a preparation for removing ext2 non-atomic bit operations from
asm/bitops.h.  This converts ext2 non-atomic bit operations to
little-endian bit operations.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: NeilBrown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

Change from v4:
 - no changes

The whole series is available in the git branch at:
 git://git.kernel.org/pub/scm/linux/kernel/git/mita/linux-2.6.git le-bitops-v5

 drivers/md/bitmap.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 9a35320..a2ce0b2 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -854,7 +854,7 @@ static void bitmap_file_set_bit(struct bitmap *bitmap, sector_t block)
 		if (bitmap->flags & BITMAP_HOSTENDIAN)
 			set_bit(bit, kaddr);
 		else
-			ext2_set_bit(bit, kaddr);
+			__test_and_set_bit_le(bit, kaddr);
 		kunmap_atomic(kaddr, KM_USER0);
 		PRINTK("set file bit %lu page %lu\n", bit, page->index);
 	}
@@ -1050,7 +1050,7 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 		if (bitmap->flags & BITMAP_HOSTENDIAN)
 			b = test_bit(bit, paddr);
 		else
-			b = ext2_test_bit(bit, paddr);
+			b = test_bit_le(bit, paddr);
 		kunmap_atomic(paddr, KM_USER0);
 		if (b) {
 			/* if the disk bit is set, set the memory bit */
@@ -1226,7 +1226,7 @@ void bitmap_daemon_work(mddev_t *mddev)
 						clear_bit(file_page_offset(bitmap, j),
 							  paddr);
 					else
-						ext2_clear_bit(file_page_offset(bitmap, j),
+						__test_and_clear_bit_le(file_page_offset(bitmap, j),
 							       paddr);
 					kunmap_atomic(paddr, KM_USER0);
 				} else
-- 
1.7.3.4

