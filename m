Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325Ab0DFRm5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 13:42:57 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35776 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756659Ab0DFRmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 13:42:36 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: linux-i2c@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>
Cc: Chaithrika U S <chaithrika@ti.com>,
       "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
       "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Philby John <pjohn@in.mvista.com>,
       "Srinivasan, Nageswari" <nageswari@ti.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] i2c: davinci: Add cpufreq support
Date: Tue,  6 Apr 2010 10:42:17 -0700
Message-Id: <1270575738-22388-6-git-send-email-khilman@deeprootsystems.com>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1270575738-22388-1-git-send-email-khilman@deeprootsystems.com>
References: <1270575738-22388-1-git-send-email-khilman@deeprootsystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chaithrika U S <chaithrika@ti.com>

Add cpufreq support for DaVinci I2C driver.
Tested on DA850/OMAP-L138 EVM.

Signed-off-by: Chaithrika U S <chaithrika@ti.com>
Acked-by: Kevin Hilman <khilman@deeprootsystems.com>
---
 drivers/i2c/busses/i2c-davinci.c |   63 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 63 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
index dfec296..fd7a155 100644
--- a/drivers/i2c/busses/i2c-davinci.c
+++ b/drivers/i2c/busses/i2c-davinci.c
@@ -35,6 +35,7 @@
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
+#include <linux/cpufreq.h>
 
 #include <mach/hardware.h>
 #include <mach/i2c.h>
@@ -106,6 +107,10 @@ struct davinci_i2c_dev {
 	int			stop;
 	u8			terminate;
 	struct i2c_adapter	adapter;
+#ifdef CONFIG_CPU_FREQ
+	struct completion	xfr_complete;
+	struct notifier_block	freq_transition;
+#endif
 };
 
 /* default platform data to use if not supplied in the platform_device */
@@ -390,6 +395,11 @@ i2c_davinci_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
 		if (ret < 0)
 			return ret;
 	}
+
+#ifdef CONFIG_CPU_FREQ
+	complete(&dev->xfr_complete);
+#endif
+
 	return num;
 }
 
@@ -522,6 +532,48 @@ static irqreturn_t i2c_davinci_isr(int this_irq, void *dev_id)
 	return count ? IRQ_HANDLED : IRQ_NONE;
 }
 
+#ifdef CONFIG_CPU_FREQ
+static int i2c_davinci_cpufreq_transition(struct notifier_block *nb,
+				     unsigned long val, void *data)
+{
+	struct davinci_i2c_dev *dev;
+
+	dev = container_of(nb, struct davinci_i2c_dev, freq_transition);
+	if (val == CPUFREQ_PRECHANGE) {
+		wait_for_completion(&dev->xfr_complete);
+		davinci_i2c_reset_ctrl(dev, 0);
+	} else if (val == CPUFREQ_POSTCHANGE) {
+		i2c_davinci_calc_clk_dividers(dev);
+		davinci_i2c_reset_ctrl(dev, 1);
+	}
+
+	return 0;
+}
+
+static inline int i2c_davinci_cpufreq_register(struct davinci_i2c_dev *dev)
+{
+	dev->freq_transition.notifier_call = i2c_davinci_cpufreq_transition;
+
+	return cpufreq_register_notifier(&dev->freq_transition,
+					 CPUFREQ_TRANSITION_NOTIFIER);
+}
+
+static inline void i2c_davinci_cpufreq_deregister(struct davinci_i2c_dev *dev)
+{
+	cpufreq_unregister_notifier(&dev->freq_transition,
+				    CPUFREQ_TRANSITION_NOTIFIER);
+}
+#else
+static inline int i2c_davinci_cpufreq_register(struct davinci_i2c_dev *dev)
+{
+	return 0;
+}
+
+static inline void i2c_davinci_cpufreq_deregister(struct davinci_i2c_dev *dev)
+{
+}
+#endif
+
 static struct i2c_algorithm i2c_davinci_algo = {
 	.master_xfer	= i2c_davinci_xfer,
 	.functionality	= i2c_davinci_func,
@@ -561,6 +613,9 @@ static int davinci_i2c_probe(struct platform_device *pdev)
 	}
 
 	init_completion(&dev->cmd_complete);
+#ifdef CONFIG_CPU_FREQ
+	init_completion(&dev->xfr_complete);
+#endif
 	dev->dev = get_device(&pdev->dev);
 	dev->irq = irq->start;
 	platform_set_drvdata(pdev, dev);
@@ -586,6 +641,12 @@ static int davinci_i2c_probe(struct platform_device *pdev)
 		goto err_unuse_clocks;
 	}
 
+	r = i2c_davinci_cpufreq_register(dev);
+	if (r) {
+		dev_err(&pdev->dev, "failed to register cpufreq\n");
+		goto err_free_irq;
+	}
+
 	adap = &dev->adapter;
 	i2c_set_adapdata(adap, dev);
 	adap->owner = THIS_MODULE;
@@ -627,6 +688,8 @@ static int davinci_i2c_remove(struct platform_device *pdev)
 	struct davinci_i2c_dev *dev = platform_get_drvdata(pdev);
 	struct resource *mem;
 
+	i2c_davinci_cpufreq_deregister(dev);
+
 	platform_set_drvdata(pdev, NULL);
 	i2c_del_adapter(&dev->adapter);
 	put_device(&pdev->dev);
-- 
1.7.0.2

