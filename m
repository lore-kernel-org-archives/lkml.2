Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405Ab1GMPUN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 11:20:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755127Ab1GMPUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 11:20:11 -0400
Message-ID: <4E1DB7A5.7040708@redhat.com>
Date: Wed, 13 Jul 2011 17:20:05 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nitin Gupta <ngupta@vflare.org>
Subject: [PATCH] Staging: zram: Fix kunmapping order
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixes the unmapping order of KM_USER0/1 in
handle_uncompressed_page() and zram_read() so that kmap()/kunmap() calls
are correctly nested.

Reported-by: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 zram_drv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index c5fdc55..d70ec1a 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -199,8 +199,8 @@ static void handle_uncompressed_page(struct zram *zram, struct bio_vec *bvec,
 	cmem = kmap_atomic(zram->table[index].page, KM_USER1);
 
 	memcpy(user_mem + bvec->bv_offset, cmem + offset, bvec->bv_len);
-	kunmap_atomic(user_mem, KM_USER0);
 	kunmap_atomic(cmem, KM_USER1);
+	kunmap_atomic(user_mem, KM_USER0);
 
 	flush_dcache_page(page);
 }
@@ -267,8 +267,8 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
 		kfree(uncmem);
 	}
 
-	kunmap_atomic(user_mem, KM_USER0);
 	kunmap_atomic(cmem, KM_USER1);
+	kunmap_atomic(user_mem, KM_USER0);
 
 	/* Should NEVER happen. Return bio error if it does. */
 	if (unlikely(ret != LZO_E_OK)) {
