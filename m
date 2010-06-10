Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab0FJFWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 01:22:44 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51408 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593Ab0FJFWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 01:22:41 -0400
Subject: [PATCH 2/2] i2c: Add OF-style registration and binding
From: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, jeremy.kerr@canonical.com,
       devicetree-discuss@lists.ozlabs.org, ben-linux@fluff.org,
       linux-i2c@vger.kernel.org
Date: Wed, 09 Jun 2010 23:22:37 -0600
Message-ID: <20100610052237.16222.32754.stgit@angua>
In-Reply-To: <20100610052102.16222.86662.stgit@angua>
References: <20100610052102.16222.86662.stgit@angua>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds OF hooks to the i2c core so that devices can automatically
be registered based on device tree data.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/i2c/busses/i2c-cpm.c     |    5 -----
 drivers/i2c/busses/i2c-ibm_iic.c |    3 ---
 drivers/i2c/busses/i2c-mpc.c     |    1 -
 drivers/i2c/i2c-core.c           |    9 +++++++++
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/i2c/busses/i2c-cpm.c b/drivers/i2c/busses/i2c-cpm.c
index 03ae62e..e591de1 100644
--- a/drivers/i2c/busses/i2c-cpm.c
+++ b/drivers/i2c/busses/i2c-cpm.c
@@ -677,11 +677,6 @@ static int __devinit cpm_i2c_probe(struct of_device *ofdev,
 	dev_dbg(&ofdev->dev, "hw routines for %s registered.\n",
 		cpm->adap.name);
 
-	/*
-	 * register OF I2C devices
-	 */
-	of_i2c_register_devices(&cpm->adap);
-
 	return 0;
 out_shut:
 	cpm_i2c_shutdown(cpm);
diff --git a/drivers/i2c/busses/i2c-ibm_iic.c b/drivers/i2c/busses/i2c-ibm_iic.c
index d964121..1168d61 100644
--- a/drivers/i2c/busses/i2c-ibm_iic.c
+++ b/drivers/i2c/busses/i2c-ibm_iic.c
@@ -761,9 +761,6 @@ static int __devinit iic_probe(struct of_device *ofdev,
 	dev_info(&ofdev->dev, "using %s mode\n",
 		 dev->fast_mode ? "fast (400 kHz)" : "standard (100 kHz)");
 
-	/* Now register all the child nodes */
-	of_i2c_register_devices(adap);
-
 	return 0;
 
 error_cleanup:
diff --git a/drivers/i2c/busses/i2c-mpc.c b/drivers/i2c/busses/i2c-mpc.c
index d2e26d2..9f7fef8 100644
--- a/drivers/i2c/busses/i2c-mpc.c
+++ b/drivers/i2c/busses/i2c-mpc.c
@@ -607,7 +607,6 @@ static int __devinit fsl_i2c_probe(struct of_device *op,
 		dev_err(i2c->dev, "failed to add adapter\n");
 		goto fail_add;
 	}
-	of_i2c_register_devices(&i2c->adap);
 
 	return result;
 
diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 1cca263..5588ac1 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -30,6 +30,8 @@
 #include <linux/init.h>
 #include <linux/idr.h>
 #include <linux/mutex.h>
+#include <linux/of_i2c.h>
+#include <linux/of_device.h>
 #include <linux/completion.h>
 #include <linux/hardirq.h>
 #include <linux/irqflags.h>
@@ -70,6 +72,10 @@ static int i2c_device_match(struct device *dev, struct device_driver *drv)
 	if (!client)
 		return 0;
 
+	/* Attempt an OF style match */
+	if (of_driver_match_device(dev, drv))
+		return 1;
+
 	driver = to_i2c_driver(drv);
 	/* match on an id table if there is one */
 	if (driver->id_table)
@@ -790,6 +796,9 @@ static int i2c_register_adapter(struct i2c_adapter *adap)
 	if (adap->nr < __i2c_first_dynamic_bus_num)
 		i2c_scan_static_board_info(adap);
 
+	/* Register devices from the device tree */
+	of_i2c_register_devices(adap);
+
 	/* Notify drivers */
 	mutex_lock(&core_lock);
 	dummy = bus_for_each_drv(&i2c_bus_type, NULL, adap,

