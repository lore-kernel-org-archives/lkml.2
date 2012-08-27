Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab2H0X5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 19:57:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55628 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174Ab2H0X5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 19:57:18 -0400
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <ben@decadent.org.uk>,
        Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] floppy: properly handle failure on add_disk loop
Date: Mon, 27 Aug 2012 20:56:54 -0300
Message-Id: <1346111816-16700-5-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1346111816-16700-1-git-send-email-herton.krzesinski@canonical.com>
References: <1346111816-16700-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On floppy initialization, if something failed inside the loop we call
add_disk, there was no cleanup of previous iterations in the error
handling.

Cc: stable@vger.kernel.org
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/block/floppy.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 32551f2..2197c88 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4293,7 +4293,7 @@ static int __init do_floppy_init(void)
 
 		err = platform_device_register(&floppy_device[drive]);
 		if (err)
-			goto out_release_dma;
+			goto out_remove_drives;
 
 		err = device_create_file(&floppy_device[drive].dev,
 					 &dev_attr_cmos);
@@ -4311,6 +4311,15 @@ static int __init do_floppy_init(void)
 
 out_unreg_platform_dev:
 	platform_device_unregister(&floppy_device[drive]);
+out_remove_drives:
+	while (drive--) {
+		if ((allowed_drive_mask & (1 << drive)) &&
+		    fdc_state[FDC(drive)].version != FDC_NONE) {
+			del_gendisk(disks[drive]);
+			device_remove_file(&floppy_device[drive].dev, &dev_attr_cmos);
+			platform_device_unregister(&floppy_device[drive]);
+		}
+	}
 out_release_dma:
 	if (atomic_read(&usage_count))
 		floppy_release_irq_and_dma();
-- 
1.7.9.5

