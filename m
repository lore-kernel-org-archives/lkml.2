Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483Ab2KNFvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 00:51:11 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55257 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756426Ab2KNFvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:51:07 -0500
Message-Id: <20121114053938.731103602@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:40:08 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        Jiri Kosina <jkosina@suse.cz>, Jens Axboe <axboe@kernel.dk>
Subject: [ 35/82] floppy: properly handle failure on add_disk loop
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>

commit d60e7ec18c3fb2cbf90969ccd42889eb2d03aef9 upstream.

On floppy initialization, if something failed inside the loop we call
add_disk, there was no cleanup of previous iterations in the error
handling.

Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/block/floppy.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4305,7 +4305,7 @@ static int __init floppy_init(void)
 
 		err = platform_device_register(&floppy_device[drive]);
 		if (err)
-			goto out_flush_work;
+			goto out_remove_drives;
 
 		err = device_create_file(&floppy_device[drive].dev,
 					 &dev_attr_cmos);
@@ -4323,6 +4323,15 @@ static int __init floppy_init(void)
 
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
 out_flush_work:
 	flush_work_sync(&floppy_work);
 	if (atomic_read(&usage_count))


