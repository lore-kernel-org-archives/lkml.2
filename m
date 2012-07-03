Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932914Ab2GCL75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 07:59:57 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:46601 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932767Ab2GCL7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 07:59:54 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linus.walleij@stericsson.com, arnd@arndb.de, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/1] mfd: Fix runtime warning caused by duplicate device registration
Date: Tue,  3 Jul 2012 12:59:48 +0100
Message-Id: <1341316788-12730-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We register the ab8500 as an MFD device from db8500 code during Device Tree
boot in order to solve some limitations of DT. However, when Device Tree is
not enabled, we still want to allow platform code to register the ab8500 in
the normal way. Here we force MFD device registration of the ab8500 only
when booting with Device Tree enabled.

Solves this issue:
WARNING: at fs/sysfs/dir.c:526 sysfs_add_one+0x88/0xb0()
sysfs: cannot create duplicate filename '/bus/platform/devices/ab8500-core.0'

Reported-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/db8500-prcmu.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 80def6c..4ec0ed1 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -2964,6 +2964,9 @@ static struct mfd_cell db8500_prcmu_devs[] = {
 		.name = "cpufreq-u8500",
 		.of_compatible = "stericsson,cpufreq-u8500",
 	},
+};
+
+static struct mfd_cell db8500_of_prcmu_devs[] = {
 	{
 		.name = "ab8500-core",
 		.of_compatible = "stericsson,ab8500",
@@ -3014,6 +3017,15 @@ static int __devinit db8500_prcmu_probe(struct platform_device *pdev)
 		return err;
 	}
 
+	if (np) {
+		err = mfd_add_devices(&pdev->dev, 0, db8500_of_prcmu_devs,
+				ARRAY_SIZE(db8500_of_prcmu_devs), NULL, 0);
+		if (err) {
+			pr_err("prcmu: Failed to add DT subdevices\n");
+			return err;
+		}
+	}
+
 	pr_info("DB8500 PRCMU initialized\n");
 
 no_irq_return:
-- 
1.7.9.5

