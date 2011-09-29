Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896Ab1I2PQP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 11:16:15 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59036 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997Ab1I2PQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 11:16:14 -0400
From: Barry Song <21cnbao@gmail.com>
To: pavel@ucw.cz, rjw@sisk.pl, frank.hofmann@tomtom.com
Cc: linux-mmc@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, Barry Song <baohua.song@csr.com>,
        Barry Song <Baohua.Song@csr.com>
Subject: [PATCH v2] PM: HIBERNATION: add resume_wait param to support MMC-like devices as resume file
Date: Thu, 29 Sep 2011 23:15:57 +0800
Message-Id: <1317309357-3871-1-git-send-email-21cnbao@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Barry Song <baohua.song@csr.com>

Some devices like mmc are async detected very slow. For example,
drivers/mmc/host/sdhci.c launchs a 200ms delayed work to detect
mmc partitions then add disk.

we do have wait_for_device_probe and scsi_complete_async_scans
before calling swsusp_check, but it is not enough to wait mmc.

This patch adds resumewait kernel param just like rootwait so
that we have enough time to wait mmc ready. The differene is
here we wait for resume partition but rootwait waits for rootfs
partition.

This patch will make swsusp support many embedded products
without scsi devices but devices like mmc.

This was tested on one ARM platform with Frank Hofmann's patch.

Signed-off-by: Barry Song <Baohua.Song@csr.com>
Reviewed-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
---
 -v2:
 add document for the resumewait kernel parameter

 Documentation/kernel-parameters.txt |    4 ++++
 kernel/power/hibernate.c            |   16 ++++++++++++++++
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 614d038..2aed0d2 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2237,6 +2237,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			in <PAGE_SIZE> units (needed only for swap files).
 			See  Documentation/power/swsusp-and-swap-files.txt
 
+	resumewait	[HIBERNATION] Wait (indefinitely) for resume device to show up.
+			Useful for devices that are detected asynchronously
+			(e.g. USB and MMC devices).
+
 	hibernate=	[HIBERNATION]
 		noresume	Don't check if there's a hibernation image
 				present during boot.
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index 8f7b1db..9f4b4f3 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -14,6 +14,7 @@
 #include <linux/reboot.h>
 #include <linux/string.h>
 #include <linux/device.h>
+#include <linux/async.h>
 #include <linux/kmod.h>
 #include <linux/delay.h>
 #include <linux/fs.h>
@@ -31,6 +32,7 @@
 
 static int nocompress = 0;
 static int noresume = 0;
+static int resume_wait = 0;
 static char resume_file[256] = CONFIG_PM_STD_PARTITION;
 dev_t swsusp_resume_device;
 sector_t swsusp_resume_block;
@@ -732,6 +734,13 @@ static int software_resume(void)
 		 * to wait for this to finish.
 		 */
 		wait_for_device_probe();
+
+		if (resume_wait) {
+			while ((swsusp_resume_device = name_to_dev_t(resume_file)) == 0)
+				msleep(10);
+			async_synchronize_full();
+		}
+
 		/*
 		 * We can't depend on SCSI devices being available after loading
 		 * one of their modules until scsi_complete_async_scans() is
@@ -1060,7 +1069,14 @@ static int __init noresume_setup(char *str)
 	return 1;
 }
 
+static int __init resumewait_setup(char *str)
+{
+	resume_wait = 1;
+	return 1;
+}
+
 __setup("noresume", noresume_setup);
 __setup("resume_offset=", resume_offset_setup);
 __setup("resume=", resume_setup);
 __setup("hibernate=", hibernate_setup);
+__setup("resumewait", resumewait_setup);
-- 
1.7.0.4

