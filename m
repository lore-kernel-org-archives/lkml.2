Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab1EIAcw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 20:32:52 -0400
Received: from mga14.intel.com ([143.182.124.37]:42109 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752968Ab1EIAcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 20:32:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,337,1301900400"; 
   d="scan'208";a="432671093"
From: Samuel Ortiz <sameo@linux.intel.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 02/19] mfd: Use mfd cell platform_data for ab3550 cells platform bits
Date: Mon,  9 May 2011 02:31:54 +0200
Message-Id: <1304901131-7104-3-git-send-email-sameo@linux.intel.com>
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
 drivers/mfd/ab3550-core.c  |    6 ++++--
 include/linux/mfd/abx500.h |    1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/ab3550-core.c b/drivers/mfd/ab3550-core.c
index ff86acf..3d7dce6 100644
--- a/drivers/mfd/ab3550-core.c
+++ b/drivers/mfd/ab3550-core.c
@@ -1320,8 +1320,10 @@ static int __init ab3550_probe(struct i2c_client *client,
 		goto exit_no_ops;
 
 	/* Set up and register the platform devices. */
-	for (i = 0; i < AB3550_NUM_DEVICES; i++)
-		ab3550_devs[i].mfd_data = ab3550_plf_data->dev_data[i];
+	for (i = 0; i < AB3550_NUM_DEVICES; i++) {
+		ab3550_devs[i].platform_data = ab3550_plf_data->dev_data[i];
+		ab3550_devs[i].pdata_size = ab3550_plf_data->dev_data_sz[i];
+	}
 
 	err = mfd_add_devices(&client->dev, 0, ab3550_devs,
 		ARRAY_SIZE(ab3550_devs), NULL,
diff --git a/include/linux/mfd/abx500.h b/include/linux/mfd/abx500.h
index 7d9b6ae..67bd6f7 100644
--- a/include/linux/mfd/abx500.h
+++ b/include/linux/mfd/abx500.h
@@ -186,6 +186,7 @@ struct abx500_init_settings {
 struct ab3550_platform_data {
 	struct {unsigned int base; unsigned int count; } irq;
 	void *dev_data[AB3550_NUM_DEVICES];
+	size_t dev_data_sz[AB3550_NUM_DEVICES];
 	struct abx500_init_settings *init_settings;
 	unsigned int init_settings_sz;
 };
-- 
1.7.2.3

