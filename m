Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317Ab1EIAdE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 20:33:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:1427 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756232Ab1EIAdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 20:33:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,337,1301900400"; 
   d="scan'208";a="689907760"
From: Samuel Ortiz <sameo@linux.intel.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 03/19] mfd: Use mfd cell platform_data for ab3100 cells platform bits
Date: Mon,  9 May 2011 02:31:55 +0200
Message-Id: <1304901131-7104-4-git-send-email-sameo@linux.intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1304901131-7104-1-git-send-email-sameo@linux.intel.com>
References: <1304901131-7104-1-git-send-email-sameo@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the addition of a platform device mfd_cell pointer, MFD drivers
can go back to passing platform data back to their sub drivers.
This allows for an mfd_cell->mfd_data removal and thus keep the sub drivers
MFD agnostic. This is mostly needed for non MFD aware sub drivers.

Cc: Linus Walleij <linus.walleij@stericsson.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/mfd/ab3100-core.c  |    6 ++++--
 drivers/regulator/ab3100.c |    3 +--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/ab3100-core.c b/drivers/mfd/ab3100-core.c
index a751927..a20e1c4 100644
--- a/drivers/mfd/ab3100-core.c
+++ b/drivers/mfd/ab3100-core.c
@@ -949,8 +949,10 @@ static int __devinit ab3100_probe(struct i2c_client *client,
 		goto exit_no_ops;
 
 	/* Set up and register the platform devices. */
-	for (i = 0; i < ARRAY_SIZE(ab3100_devs); i++)
-		ab3100_devs[i].mfd_data = ab3100_plf_data;
+	for (i = 0; i < ARRAY_SIZE(ab3100_devs); i++) {
+		ab3100_devs[i].platform_data = ab3100_plf_data;
+		ab3100_devs[i].pdata_size = sizeof(struct ab3100_platform_data);
+	}
 
 	err = mfd_add_devices(&client->dev, 0, ab3100_devs,
 		ARRAY_SIZE(ab3100_devs), NULL, 0);
diff --git a/drivers/regulator/ab3100.c b/drivers/regulator/ab3100.c
index b1d7794..585e494 100644
--- a/drivers/regulator/ab3100.c
+++ b/drivers/regulator/ab3100.c
@@ -17,7 +17,6 @@
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
 #include <linux/mfd/abx500.h>
-#include <linux/mfd/core.h>
 
 /* LDO registers and some handy masking definitions for AB3100 */
 #define AB3100_LDO_A		0x40
@@ -582,7 +581,7 @@ ab3100_regulator_desc[AB3100_NUM_REGULATORS] = {
 
 static int __devinit ab3100_regulators_probe(struct platform_device *pdev)
 {
-	struct ab3100_platform_data *plfdata = mfd_get_data(pdev);
+	struct ab3100_platform_data *plfdata = pdev->dev.platform_data;
 	int err = 0;
 	u8 data;
 	int i;
-- 
1.7.2.3

