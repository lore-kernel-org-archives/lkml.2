Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab2HMSQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 14:16:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53914 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990Ab2HMSQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 14:16:48 -0400
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>, Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH v3 4/6] floppy: properly handle failure on add_disk loop
Date: Mon, 13 Aug 2012 15:16:25 -0300
Message-Id: <1344881787-6422-5-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344881787-6422-1-git-send-email-herton.krzesinski@canonical.com>
References: <1344881787-6422-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On do_floppy_init, if something failed inside the loop we call add_disk,
there was no cleanup of previous iterations in the error handling.

Cc: stable@vger.kernel.org
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/block/floppy.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 9272203..3eafe93 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4294,7 +4294,7 @@ static int __init do_floppy_init(void)
 
 		err = platform_device_register(&floppy_device[drive]);
 		if (err)
-			goto out_release_dma;
+			goto out_remove_drives;
 
 		err = device_create_file(&floppy_device[drive].dev,
 					 &dev_attr_cmos);
@@ -4313,6 +4313,14 @@ static int __init do_floppy_init(void)
 
 out_unreg_platform_dev:
 	platform_device_unregister(&floppy_device[drive]);
+out_remove_drives:
+	while (drive--) {
+		if (disk_registered[drive]) {
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

