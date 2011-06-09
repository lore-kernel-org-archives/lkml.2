Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab1FITWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 15:22:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44320 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983Ab1FITWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 15:22:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=S7TSOLaQJKZ3tp4EBKMk0qZRNykPGu+d6Qwnpq0i6mbUtrNoLpyiazcqOQKKt9Io3+
         z4avbHCd9FboJj/iayamV8++LYrwGusdsYCBugr8Zcn9EYj9tyUztRdr5KxA6hq3fpyR
         dC1JfA2osHMqirvFIwt+2sFelM8NNtzuZjj+A=
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>, Ben Dooks <ben-linux@fluff.org>
Subject: [PATCH 12/13] i2c-designware: Add runtime power management support
Date: Thu,  9 Jun 2011 12:21:49 -0700
Message-Id: <1307647310-24332-13-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1307647310-24332-1-git-send-email-dirk.brandewie@gmail.com>
References: <1307647310-24332-1-git-send-email-dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

Add runtime power management to the PCI driver.

Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
Signed-off-by: Ben Dooks <ben-linux@fluff.org>
---
 drivers/i2c/busses/i2c-designware-core.c   |   10 +++-
 drivers/i2c/busses/i2c-designware-core.h   |    1 +
 drivers/i2c/busses/i2c-designware-pcidrv.c |   89 ++++++++++++++++++++++++++++
 3 files changed, 98 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/i2c-designware-core.c
index b9f18dd..df87992 100644
--- a/drivers/i2c/busses/i2c-designware-core.c
+++ b/drivers/i2c/busses/i2c-designware-core.c
@@ -31,6 +31,7 @@
 #include <linux/i2c.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
+#include <linux/pm_runtime.h>
 #include <linux/delay.h>
 #include "i2c-designware-core.h"
 
@@ -501,6 +502,7 @@ i2c_dw_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
 	dev_dbg(dev->dev, "%s: msgs: %d\n", __func__, num);
 
 	mutex_lock(&dev->lock);
+	pm_runtime_get_sync(dev->dev);
 
 	INIT_COMPLETION(dev->cmd_complete);
 	dev->msgs = msgs;
@@ -550,6 +552,7 @@ i2c_dw_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
 	ret = -EIO;
 
 done:
+	pm_runtime_put(dev->dev);
 	mutex_unlock(&dev->lock);
 
 	return ret;
@@ -671,10 +674,13 @@ void i2c_dw_enable(struct dw_i2c_dev *dev)
 	dw_writel(dev, 1, DW_IC_ENABLE);
 }
 
-void i2c_dw_disable(struct dw_i2c_dev *dev)
+u32 i2c_dw_is_enabled(struct dw_i2c_dev *dev)
 {
-	int ret;
+	return dw_readl(dev, DW_IC_ENABLE);
+}
 
+void i2c_dw_disable(struct dw_i2c_dev *dev)
+{
 	/* Disable controller */
 	dw_writel(dev, 0, DW_IC_ENABLE);
 
diff --git a/drivers/i2c/busses/i2c-designware-core.h b/drivers/i2c/busses/i2c-designware-core.h
index 6450a6a..4a75888 100644
--- a/drivers/i2c/busses/i2c-designware-core.h
+++ b/drivers/i2c/busses/i2c-designware-core.h
@@ -98,6 +98,7 @@ extern int i2c_dw_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 extern u32 i2c_dw_func(struct i2c_adapter *adap);
 extern irqreturn_t i2c_dw_isr(int this_irq, void *dev_id);
 extern void i2c_dw_enable(struct dw_i2c_dev *dev);
+extern u32 i2c_dw_is_enabled(struct dw_i2c_dev *dev);
 extern void i2c_dw_disable(struct dw_i2c_dev *dev);
 extern void i2c_dw_clear_int(struct dw_i2c_dev *dev);
 extern void i2c_dw_disable_int(struct dw_i2c_dev *dev);
diff --git a/drivers/i2c/busses/i2c-designware-pcidrv.c b/drivers/i2c/busses/i2c-designware-pcidrv.c
index 83307ef..d2223b5 100644
--- a/drivers/i2c/busses/i2c-designware-pcidrv.c
+++ b/drivers/i2c/busses/i2c-designware-pcidrv.c
@@ -38,6 +38,7 @@
 #include <linux/io.h>
 #include <linux/slab.h>
 #include <linux/pci.h>
+#include <linux/pm_runtime.h>
 #include "i2c-designware-core.h"
 
 #define DRIVER_NAME "i2c-designware-pci"
@@ -137,6 +138,82 @@ static struct i2c_algorithm i2c_dw_algo = {
 	.functionality	= i2c_dw_func,
 };
 
+static int i2c_dw_pci_suspend(struct pci_dev *pdev, pm_message_t mesg)
+{
+	struct dw_i2c_dev *i2c = pci_get_drvdata(pdev);
+	int err;
+
+
+	i2c_dw_disable(i2c);
+
+	err = pci_save_state(pdev);
+	if (err) {
+		dev_err(&pdev->dev, "pci_save_state failed\n");
+		return err;
+	}
+
+	err = pci_set_power_state(pdev, PCI_D3hot);
+	if (err) {
+		dev_err(&pdev->dev, "pci_set_power_state failed\n");
+		return err;
+	}
+
+	return 0;
+}
+
+static int i2c_dw_pci_runtime_suspend(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	dev_dbg(dev, "PCI suspend called\n");
+	return i2c_dw_pci_suspend(pdev, PMSG_SUSPEND);
+}
+
+static int i2c_dw_pci_resume(struct pci_dev *pdev)
+{
+	struct dw_i2c_dev *i2c = pci_get_drvdata(pdev);
+	int err;
+	u32 enabled;
+
+	enabled = i2c_dw_is_enabled(i2c);
+	if (enabled)
+		return 0;
+
+	err = pci_set_power_state(pdev, PCI_D0);
+	if (err) {
+		dev_err(&pdev->dev, "pci_set_power_state() failed\n");
+		return err;
+	}
+
+	pci_restore_state(pdev);
+
+	i2c_dw_init(i2c);
+	i2c_dw_enable(i2c);
+	return 0;
+}
+
+static int i2c_dw_pci_runtime_resume(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	dev_dbg(dev, "runtime_resume called\n");
+	return i2c_dw_pci_resume(pdev);
+}
+
+static int i2c_dw_pci_runtime_idle(struct device *dev)
+{
+	int err = pm_schedule_suspend(dev, 500);
+	dev_dbg(dev, "runtime_idle called\n");
+
+	if (err != 0)
+		return 0;
+	return -EBUSY;
+}
+
+static const struct dev_pm_ops i2c_dw_pm_ops = {
+	.runtime_suspend = i2c_dw_pci_runtime_suspend,
+	.runtime_resume = i2c_dw_pci_runtime_resume,
+	.runtime_idle = i2c_dw_pci_runtime_idle,
+};
+
 static u32 i2c_dw_get_clk_rate_khz(struct dw_i2c_dev *dev)
 {
 	return dev->controller->clk_khz;
@@ -245,6 +322,9 @@ const struct pci_device_id *id)
 		goto err_free_irq;
 	}
 
+	pm_runtime_put_noidle(&pdev->dev);
+	pm_runtime_allow(&pdev->dev);
+
 	return 0;
 
 err_free_irq:
@@ -264,6 +344,10 @@ static void __devexit i2c_dw_pci_remove(struct pci_dev *pdev)
 {
 	struct dw_i2c_dev *dev = pci_get_drvdata(pdev);
 
+	i2c_dw_disable(dev);
+	pm_runtime_forbid(&pdev->dev);
+	pm_runtime_get_noresume(&pdev->dev);
+
 	pci_set_drvdata(pdev, NULL);
 	i2c_del_adapter(&dev->adapter);
 	put_device(&pdev->dev);
@@ -297,6 +381,11 @@ static struct pci_driver dw_i2c_driver = {
 	.id_table	= i2_designware_pci_ids,
 	.probe		= i2c_dw_pci_probe,
 	.remove		= __devexit_p(i2c_dw_pci_remove),
+	.resume         = i2c_dw_pci_resume,
+	.suspend        = i2c_dw_pci_suspend,
+	.driver         = {
+		.pm     = &i2c_dw_pm_ops,
+	},
 };
 
 static int __init dw_i2c_init_driver(void)
-- 
1.7.3.4

