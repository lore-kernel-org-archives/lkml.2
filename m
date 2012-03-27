Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab2C0LLl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 07:11:41 -0400
Received: from ftp.meprolight.com ([194.90.149.17]:57382 "EHLO meprolight.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753778Ab2C0LLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 07:11:40 -0400
From: Alex Gershgorin <alexg@meprolight.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: <broonie@opensource.wolfsonmicro.com>, <linux-kernel@vger.kernel.org>,
        <marc.reilly@gmail.com>, <s.hauer@pengutronix.de>,
        <fabio.estevam@freescale.com>, Alex Gershgorin <alexg@meprolight.com>
Subject: [PATCH v1] mfd: mc13xxx: add I2C support fix building for v3.3
Date: Tue, 27 Mar 2012 13:04:20 +0200
Message-ID: <1332846260-18145-1-git-send-email-alexg@meprolight.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following compilation errors,
when using a series mc13xxx-add-I2C-support-V4

1)
drivers/mfd/mc13xxx-spi.c:50: error: unknown field 'pad_bits'
specified in initializer

It fixed in include/linux/regmap.h

2)
drivers/mfd/mc13xxx-core.c: In function 'mc13xxx_probe_flags_dt':
drivers/mfd/mc13xxx-core.c:619: error: request for member 'of_node'
in something not a structure or union

It fexed in drivers/mfd/mc13xxx-core.c

3)
drivers/built-in.o: In function `mc13xxx_common_cleanup':
clkdev.c:(.text+0x3ee10): undefined reference to `regmap_exit'
drivers/built-in.o: In function `mc13xxx_reg_rmw':
clkdev.c:(.text+0x3ef98): undefined reference to `regmap_update_bits'
drivers/built-in.o: In function `mc13xxx_reg_write':
clkdev.c:(.text+0x3efd4): undefined reference to `regmap_write'
drivers/built-in.o: In function `mc13xxx_reg_read':
clkdev.c:(.text+0x3f08c): undefined reference to `regmap_read'
drivers/built-in.o: In function `mc13xxx_spi_probe':
clkdev.c:(.text+0x3fa50): undefined reference to `regmap_init_spi'
drivers/built-in.o: In function `mc13xxx_i2c_probe':
clkdev.c:(.text+0x3fb90): undefined reference to `regmap_init_i2c'
make: *** [.tmp_vmlinux1] Error 1

It fixed in drivers/mfd/Kconfig by adding CONFIG_REGMAP_I2C/CONFIG_REGMAP_SPI

It was successfully tested on Linux v3.3

Signed-off-by: Alex Gershgorin <alexg@meprolight.com>
---
 drivers/mfd/Kconfig        |    2 ++
 drivers/mfd/mc13xxx-core.c |    2 +-
 include/linux/regmap.h     |    2 ++
 3 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 9da32a2..74e00cf 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -576,6 +576,8 @@ config MFD_MC13XXX
 	depends on SPI_MASTER || I2C
 	select MFD_CORE
 	select MFD_MC13783
+	select REGMAP_I2C if I2C
+	select REGMAP_SPI if SPI_MASTER
 	help
 	  Enable support for the Freescale MC13783 and MC13892 PMICs.
 	  This driver provides common support for accessing the device,
diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
index 31dbf91..5a60273 100644
--- a/drivers/mfd/mc13xxx-core.c
+++ b/drivers/mfd/mc13xxx-core.c
@@ -616,7 +616,7 @@ static int mc13xxx_add_subdevice(struct mc13xxx *mc13xxx, const char *format)
 #ifdef CONFIG_OF
 static int mc13xxx_probe_flags_dt(struct mc13xxx *mc13xxx)
 {
-	struct device_node *np = mc13xxx->dev.of_node;
+	struct device_node *np = mc13xxx->dev->of_node;
 
 	if (!np)
 		return -ENODEV;
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index eb93921..8c6f5e9 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -45,6 +45,7 @@ struct reg_default {
  *
  * @reg_bits: Number of bits in a register address, mandatory.
  * @val_bits: Number of bits in a register value, mandatory.
+ * @pad_bits: Number of bits in a register pad, mandatory.
  *
  * @writeable_reg: Optional callback returning true if the register
  *                 can be written to.
@@ -75,6 +76,7 @@ struct reg_default {
 struct regmap_config {
 	int reg_bits;
 	int val_bits;
+	int pad_bits;
 
 	bool (*writeable_reg)(struct device *dev, unsigned int reg);
 	bool (*readable_reg)(struct device *dev, unsigned int reg);
-- 
1.7.0.4

