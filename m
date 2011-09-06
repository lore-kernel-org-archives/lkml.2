Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab1IFNCf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 09:02:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754407Ab1IFNCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 09:02:23 -0400
From: Jerome Marchand <jmarchan@redhat.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>,
        Nitin Gupta <ngupta@vflare.org>, Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 2/2] staging: zram: prevent accessing an unallocated table when init fails early
Date: Tue,  6 Sep 2011 15:02:12 +0200
Message-Id: <1315314132-8436-2-git-send-email-jmarchan@redhat.com>
In-Reply-To: <1315314132-8436-1-git-send-email-jmarchan@redhat.com>
References: <1315314132-8436-1-git-send-email-jmarchan@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the allocation of zram->table fails, we set zram->disksize to zero
to prevent accessing the unallocated table entries during cleanup.
However, we currently don't take this precaution when the initialization
fails earlier.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 drivers/staging/zram/zram_drv.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 2d1c8bd..b99cf53 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -651,24 +651,22 @@ int zram_init_device(struct zram *zram)
 	if (!zram->compress_workmem) {
 		pr_err("Error allocating compressor working memory!\n");
 		ret = -ENOMEM;
-		goto fail;
+		goto fail_no_table;
 	}
 
 	zram->compress_buffer = (void *)__get_free_pages(__GFP_ZERO, 1);
 	if (!zram->compress_buffer) {
 		pr_err("Error allocating compressor buffer space\n");
 		ret = -ENOMEM;
-		goto fail;
+		goto fail_no_table;
 	}
 
 	num_pages = zram->disksize >> PAGE_SHIFT;
 	zram->table = vzalloc(num_pages * sizeof(*zram->table));
 	if (!zram->table) {
 		pr_err("Error allocating zram address table\n");
-		/* To prevent accessing table entries during cleanup */
-		zram->disksize = 0;
 		ret = -ENOMEM;
-		goto fail;
+		goto fail_no_table;
 	}
 
 	set_capacity(zram->disk, zram->disksize >> SECTOR_SHIFT);
@@ -689,6 +687,9 @@ int zram_init_device(struct zram *zram)
 	pr_debug("Initialization done!\n");
 	return 0;
 
+fail_no_table:
+	/* To prevent accessing table entries during cleanup */
+	zram->disksize = 0;
 fail:
 	__zram_reset_device(zram);
 	up_write(&zram->init_lock);
-- 
1.7.6

