Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab2H0X5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 19:57:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55635 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174Ab2H0X5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 19:57:22 -0400
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <ben@decadent.org.uk>,
        Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] floppy: use common function to check if floppies can be registered
Date: Mon, 27 Aug 2012 20:56:55 -0300
Message-Id: <1346111816-16700-6-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1346111816-16700-1-git-send-email-herton.krzesinski@canonical.com>
References: <1346111816-16700-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The same checks to see if a drive can be or is registered are
repeated through the code, factor out the checks in a common function
and replace the repeated checks with it.

Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/block/floppy.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 2197c88..c4e6152 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4110,12 +4110,19 @@ static struct platform_driver floppy_driver = {
 
 static struct platform_device floppy_device[N_DRIVE];
 
+static bool floppy_available(int drive)
+{
+	if (!(allowed_drive_mask & (1 << drive)))
+		return false;
+	if (fdc_state[FDC(drive)].version == FDC_NONE)
+		return false;
+	return true;
+}
+
 static struct kobject *floppy_find(dev_t dev, int *part, void *data)
 {
 	int drive = (*part & 3) | ((*part & 0x80) >> 5);
-	if (drive >= N_DRIVE ||
-	    !(allowed_drive_mask & (1 << drive)) ||
-	    fdc_state[FDC(drive)].version == FDC_NONE)
+	if (drive >= N_DRIVE || !floppy_available(drive))
 		return NULL;
 	if (((*part >> 2) & 0x1f) >= ARRAY_SIZE(floppy_type))
 		return NULL;
@@ -4282,9 +4289,7 @@ static int __init do_floppy_init(void)
 	}
 
 	for (drive = 0; drive < N_DRIVE; drive++) {
-		if (!(allowed_drive_mask & (1 << drive)))
-			continue;
-		if (fdc_state[FDC(drive)].version == FDC_NONE)
+		if (!floppy_available(drive))
 			continue;
 
 		floppy_device[drive].name = floppy_device_name;
@@ -4313,8 +4318,7 @@ out_unreg_platform_dev:
 	platform_device_unregister(&floppy_device[drive]);
 out_remove_drives:
 	while (drive--) {
-		if ((allowed_drive_mask & (1 << drive)) &&
-		    fdc_state[FDC(drive)].version != FDC_NONE) {
+		if (floppy_available(drive)) {
 			del_gendisk(disks[drive]);
 			device_remove_file(&floppy_device[drive].dev, &dev_attr_cmos);
 			platform_device_unregister(&floppy_device[drive]);
@@ -4553,8 +4557,7 @@ static void __exit floppy_module_exit(void)
 	for (drive = 0; drive < N_DRIVE; drive++) {
 		del_timer_sync(&motor_off_timer[drive]);
 
-		if ((allowed_drive_mask & (1 << drive)) &&
-		    fdc_state[FDC(drive)].version != FDC_NONE) {
+		if (floppy_available(drive)) {
 			del_gendisk(disks[drive]);
 			device_remove_file(&floppy_device[drive].dev, &dev_attr_cmos);
 			platform_device_unregister(&floppy_device[drive]);
-- 
1.7.9.5

