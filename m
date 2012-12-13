Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab2LMOCC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:02:02 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44038 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755859Ab2LMOB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:01:57 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiri Kosina <jkosina@suse.cz>, Jens Axboe <axboe@kernel.dk>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 020/241] floppy: properly handle failure on add_disk loop
Date: Thu, 13 Dec 2012 11:56:25 -0200
Message-Id: <1355407206-17100-21-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>

commit d60e7ec18c3fb2cbf90969ccd42889eb2d03aef9 upstream.

On floppy initialization, if something failed inside the loop we call
add_disk, there was no cleanup of previous iterations in the error
handling.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/block/floppy.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 889f47e..7ad2489 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4293,7 +4293,7 @@ static int __init floppy_init(void)
 
 		err = platform_device_register(&floppy_device[drive]);
 		if (err)
-			goto out_release_dma;
+			goto out_remove_drives;
 
 		err = device_create_file(&floppy_device[drive].dev,
 					 &dev_attr_cmos);
@@ -4311,6 +4311,15 @@ static int __init floppy_init(void)
 
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

