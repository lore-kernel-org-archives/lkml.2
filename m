Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab2KIOV6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 09:21:58 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:46840 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753733Ab2KIOUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 09:20:43 -0500
From: ciminaghi@gnudd.com
To: sameo@linux.intel.com, rubini@gnudd.com, giancarlo.asnaghi@st.com,
        broonie@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org, Davide Ciminaghi <ciminaghi@gnudd.com>
Subject: [PATCH 08/10] drivers/mfd/sta2x11-mfd: add scr (otp registers) platform driver
Date: Fri,  9 Nov 2012 15:19:59 +0100
Message-Id: <1352470801-2418-9-git-send-email-ciminaghi@gnudd.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1352470801-2418-1-git-send-email-ciminaghi@gnudd.com>
References: <1352470801-2418-1-git-send-email-ciminaghi@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Ciminaghi <ciminaghi@gnudd.com>


Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
---
 drivers/mfd/sta2x11-mfd.c       |   52 ++++++++++++++++++++++++++++++++++++++-
 include/linux/mfd/sta2x11-mfd.h |    7 ++++++
 2 files changed, 58 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/sta2x11-mfd.c b/drivers/mfd/sta2x11-mfd.c
index da65839..7365f0f 100644
--- a/drivers/mfd/sta2x11-mfd.c
+++ b/drivers/mfd/sta2x11-mfd.c
@@ -175,10 +175,16 @@ static void sta2x11_regmap_unlock(void *__lock)
 	spin_unlock(lock);
 }
 
+/* OTP (one time programmable registers do not require locking */
+static void sta2x11_regmap_nolock(void *__lock)
+{
+}
+
 static const char *sta2x11_mfd_names[sta2x11_n_mfd_plat_devs] = {
 	[sta2x11_sctl] = STA2X11_MFD_SCTL_NAME,
 	[sta2x11_apbreg] = STA2X11_MFD_APBREG_NAME,
 	[sta2x11_apb_soc_regs] = STA2X11_MFD_APB_SOC_REGS_NAME,
+	[sta2x11_scr] = STA2X11_MFD_SCR_NAME,
 };
 
 static bool sta2x11_sctl_writeable_reg(struct device *dev, unsigned int reg)
@@ -196,6 +202,28 @@ static struct regmap_config sta2x11_sctl_regmap_config = {
 	.writeable_reg = sta2x11_sctl_writeable_reg,
 };
 
+static bool sta2x11_scr_readable_reg(struct device *dev, unsigned int reg)
+{
+	return (reg == STA2X11_SECR_CR) ||
+		__reg_within_range(reg, STA2X11_SECR_FVR0, STA2X11_SECR_FVR1);
+}
+
+static bool sta2x11_scr_writeable_reg(struct device *dev, unsigned int reg)
+{
+	return false;
+}
+
+static struct regmap_config sta2x11_scr_regmap_config = {
+	.reg_bits = 32,
+	.reg_stride = 4,
+	.val_bits = 32,
+	.lock = sta2x11_regmap_nolock,
+	.unlock = sta2x11_regmap_nolock,
+	.max_register = STA2X11_SECR_FVR1,
+	.readable_reg = sta2x11_scr_readable_reg,
+	.writeable_reg = sta2x11_scr_writeable_reg,
+};
+
 static bool sta2x11_apbreg_readable_reg(struct device *dev, unsigned int reg)
 {
 	/* Two blocks (CAN and MLB, SARAC) 0x100 bytes apart */
@@ -279,9 +307,10 @@ sta2x11_mfd_regmap_configs[sta2x11_n_mfd_plat_devs] = {
 	[sta2x11_sctl] = &sta2x11_sctl_regmap_config,
 	[sta2x11_apbreg] = &sta2x11_apbreg_regmap_config,
 	[sta2x11_apb_soc_regs] = &sta2x11_apb_soc_regs_regmap_config,
+	[sta2x11_scr] = &sta2x11_scr_regmap_config,
 };
 
-/* Probe for the three platform devices */
+/* Probe for the four platform devices */
 
 static int sta2x11_mfd_platform_probe(struct platform_device *dev,
 				      enum sta2x11_mfd_plat_dev index)
@@ -339,6 +368,11 @@ static int sta2x11_apb_soc_regs_probe(struct platform_device *dev)
 	return sta2x11_mfd_platform_probe(dev, sta2x11_apb_soc_regs);
 }
 
+static int sta2x11_scr_probe(struct platform_device *dev)
+{
+	return sta2x11_mfd_platform_probe(dev, sta2x11_scr);
+}
+
 /* The three platform drivers */
 static struct platform_driver sta2x11_sctl_platform_driver = {
 	.driver = {
@@ -382,6 +416,21 @@ static int __init sta2x11_apb_soc_regs_init(void)
 	return platform_driver_register(&sta2x11_apb_soc_regs_platform_driver);
 }
 
+static struct platform_driver sta2x11_scr_platform_driver = {
+	.driver = {
+		.name = STA2X11_MFD_SCR_NAME,
+		.owner = THIS_MODULE,
+	},
+	.probe = sta2x11_scr_probe,
+};
+
+static int __init sta2x11_scr_init(void)
+{
+	pr_info("%s\n", __func__);
+	return platform_driver_register(&sta2x11_scr_platform_driver);
+}
+
+
 /*
  * What follows are the PCI devices that host the above pdevs.
  * Each logic block is 4kB and they are all consecutive: we use this info.
@@ -631,6 +680,7 @@ static int __init sta2x11_mfd_init(void)
 subsys_initcall(sta2x11_apbreg_init);
 subsys_initcall(sta2x11_sctl_init);
 subsys_initcall(sta2x11_apb_soc_regs_init);
+subsys_initcall(sta2x11_scr_init);
 rootfs_initcall(sta2x11_mfd_init);
 
 MODULE_LICENSE("GPL v2");
diff --git a/include/linux/mfd/sta2x11-mfd.h b/include/linux/mfd/sta2x11-mfd.h
index 058de2b..08cad95 100644
--- a/include/linux/mfd/sta2x11-mfd.h
+++ b/include/linux/mfd/sta2x11-mfd.h
@@ -482,6 +482,13 @@ u32 sta2x11_apb_soc_regs_mask(struct pci_dev *pdev, u32 reg, u32 mask, u32 val)
 #define COMPENSATION_REG3		0x3cc
 #define TEST_CTL_REG			0x3d0
 
+/*
+ * SECR (OTP) registers
+ */
+#define STA2X11_SECR_CR			0x00
+#define STA2X11_SECR_FVR0		0x10
+#define STA2X11_SECR_FVR1		0x14
+
 extern int sta2x11_mfd_get_regs_data(struct platform_device *pdev,
 				     enum sta2x11_mfd_plat_dev index,
 				     void __iomem **regs,
-- 
1.7.10.4

