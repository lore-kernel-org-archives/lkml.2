Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab1I2J3r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 05:29:47 -0400
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:37547 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab1I2J3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 05:29:45 -0400
From: Barry Song <Barry.Song@csr.com>
To: <pavel@ucw.cz>, <rjw@sisk.pl>, <frank.hofmann@tomtom.com>
CC: <linux-pm@lists.linux-foundation.org>, <linux-mmc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <workgroup.linux@csr.com>, Barry Song <baohua.song@csr.com>,
        Barry Song <Baohua.Song@csr.com>
Subject: [PATCH] PM: HIBERNATION: add resume_wait param to support MMC-like devices as resume file
Date: Thu, 29 Sep 2011 02:29:08 -0700
Message-ID: <1317288548-19560-1-git-send-email-Barry.Song@csr.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.125.36.59]
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
---
 kernel/power/hibernate.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

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
1.7.1



Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
More information can be found at www.csr.com. Follow CSR on Twitter at http://twitter.com/CSR_PLC and read our blog at www.csr.com/blog
