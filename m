Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab2HMSQz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 14:16:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53921 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592Ab2HMSQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 14:16:53 -0400
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>, Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH v3 5/6] floppy: use disk_registered for checking if a drive is present
Date: Mon, 13 Aug 2012 15:16:26 -0300
Message-Id: <1344881787-6422-6-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344881787-6422-1-git-send-email-herton.krzesinski@canonical.com>
References: <1344881787-6422-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify/cleanup code, replacing remaining checks for drives present
using disk_registered array.

Acked-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/block/floppy.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 3eafe93..381b9c1 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4114,9 +4114,7 @@ static struct platform_device floppy_device[N_DRIVE];
 static struct kobject *floppy_find(dev_t dev, int *part, void *data)
 {
 	int drive = (*part & 3) | ((*part & 0x80) >> 5);
-	if (drive >= N_DRIVE ||
-	    !(allowed_drive_mask & (1 << drive)) ||
-	    fdc_state[FDC(drive)].version == FDC_NONE)
+	if (drive >= N_DRIVE || !disk_registered[drive])
 		return NULL;
 	if (((*part >> 2) & 0x1f) >= ARRAY_SIZE(floppy_type))
 		return NULL;
@@ -4561,8 +4559,7 @@ static void __exit floppy_module_exit(void)
 	for (drive = 0; drive < N_DRIVE; drive++) {
 		del_timer_sync(&motor_off_timer[drive]);
 
-		if ((allowed_drive_mask & (1 << drive)) &&
-		    fdc_state[FDC(drive)].version != FDC_NONE) {
+		if (disk_registered[drive]) {
 			del_gendisk(disks[drive]);
 			device_remove_file(&floppy_device[drive].dev, &dev_attr_cmos);
 			platform_device_unregister(&floppy_device[drive]);
@@ -4573,8 +4570,7 @@ static void __exit floppy_module_exit(void)
 		 * These disks have not called add_disk().  Don't put down
 		 * queue reference in put_disk().
 		 */
-		if (!(allowed_drive_mask & (1 << drive)) ||
-		    fdc_state[FDC(drive)].version == FDC_NONE)
+		if (!disk_registered[drive])
 			disks[drive]->queue = NULL;
 
 		put_disk(disks[drive]);
-- 
1.7.9.5

