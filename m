Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571Ab2J1PB3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 11:01:29 -0400
Received: from londo.lunn.ch ([80.238.139.98]:57590 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016Ab2J1PB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 11:01:27 -0400
From: Andrew Lunn <andrew@lunn.ch>
To: lrg@ti.com, broonie@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH] Regulator: core: Unregister when gpio request fails.
Date: Sun, 28 Oct 2012 16:01:11 +0100
Message-Id: <1351436471-17210-1-git-send-email-andrew@lunn.ch>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the gpio_request_one() fails, or returns EPROBE_DEFER, the
regulator must be device_unregister()ed. When this is not done,
there are WARNING: from sysfs:

WARNING: at fs/sysfs/file.c:343 sysfs_open_file+0x238/0x268()

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/regulator/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 5c4829c..aa4d28b 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3365,7 +3365,7 @@ regulator_register(const struct regulator_desc *regulator_desc,
 		if (ret != 0) {
 			rdev_err(rdev, "Failed to request enable GPIO%d: %d\n",
 				 config->ena_gpio, ret);
-			goto clean;
+			goto wash;
 		}
 
 		rdev->ena_gpio = config->ena_gpio;
@@ -3449,6 +3449,7 @@ scrub:
 	if (rdev->ena_gpio)
 		gpio_free(rdev->ena_gpio);
 	kfree(rdev->constraints);
+wash:
 	device_unregister(&rdev->dev);
 	/* device core frees rdev */
 	rdev = ERR_PTR(ret);
-- 
1.7.10.4

