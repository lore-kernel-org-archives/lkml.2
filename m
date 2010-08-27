Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab0H0Pg3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 11:36:29 -0400
Received: from smtp.nokia.com ([192.100.122.230]:44119 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631Ab0H0Pg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 11:36:26 -0400
From: Yuri Ershov <ext-yuri.ershov@nokia.com>
To: eric.piel@tremplin-utc.net, samu.p.onkalo@nokia.com,
        akpm@linux-foundation.org, daniel@caiaq.de
Cc: ext-yuri.kululin@nokia.com, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, ext-yuri.ershov@nokia.com
Subject: [PATCH 1/2] lis3: Add device owner
Date: Fri, 27 Aug 2010 18:33:20 +0400
Message-Id: <ee6b20c71d49b8438ced798a9e561dbbd2991cf6.1282647258.git.ext-yuri.kululin@nokia.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1282919601-21821-1-git-send-email-ext-yuri.ershov@nokia.com>
References: <1282919601-21821-1-git-send-email-ext-yuri.ershov@nokia.com>
X-OriginalArrivalTime: 27 Aug 2010 15:35:10.0875 (UTC) FILETIME=[6F6E8EB0:01CB45FD]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device owner and change /dev/freefall file operations owner
according to the used driver

Signed-off-by: Yuri Kululin <ext-yuri.kululin@nokia.com>
---
 drivers/hwmon/lis3lv02d.c |    8 ++++++--
 drivers/hwmon/lis3lv02d.h |    2 ++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
index e278f0e..0f1bd36 100644
--- a/drivers/hwmon/lis3lv02d.c
+++ b/drivers/hwmon/lis3lv02d.c
@@ -591,8 +591,7 @@ static int lis3lv02d_misc_fasync(int fd, struct file *file, int on)
 	return fasync_helper(fd, file, on, &lis3_dev.async_queue);
 }
 
-static const struct file_operations lis3lv02d_misc_fops = {
-	.owner   = THIS_MODULE,
+static struct file_operations lis3lv02d_misc_fops = {
 	.llseek  = no_llseek,
 	.read    = lis3lv02d_misc_read,
 	.open    = lis3lv02d_misc_open,
@@ -1007,6 +1006,11 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
 		goto out;
 	}
 
+	if (dev->owner)
+		lis3lv02d_misc_fops.owner = dev->owner;
+	else
+		lis3lv02d_misc_fops.owner = THIS_MODULE;
+
 	if (misc_register(&lis3lv02d_misc_device))
 		printk(KERN_ERR DRIVER_NAME ": misc_register failed\n");
 out:
diff --git a/drivers/hwmon/lis3lv02d.h b/drivers/hwmon/lis3lv02d.h
index 1f0a66f..e63dd3d 100644
--- a/drivers/hwmon/lis3lv02d.h
+++ b/drivers/hwmon/lis3lv02d.h
@@ -258,6 +258,8 @@ struct lis3lv02d {
 	unsigned char		irq_cfg;
 	struct lis3lv02d_platform_data *pdata;	/* for passing board config */
 	struct mutex		mutex;     /* Serialize poll and selftest */
+
+	struct module		*owner;    /* Device owner */
 };
 
 int lis3lv02d_init_device(struct lis3lv02d *lis3);
-- 
1.7.1.1

