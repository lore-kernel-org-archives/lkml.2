Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489Ab1KHHG3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 02:06:29 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:40655 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751478Ab1KHHGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 02:06:06 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <rabin.vincent@stericsson.com>, <linus.walleij@stericsson.com>,
        <linux-kernel@vger.kernel.org>, <sameo@linux.intel.com>
Cc: <armando.visconti@st.com>, <shiraz.hashim@st.com>, <vipin.kumar@st.com>,
        <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>, <bhavna.yadav@st.com>,
        <vincenzo.frascino@st.com>, <mirko.gardi@st.com>,
        <srinidhi.kasagar@stericsson.com>
Subject: [PATCH 2/2] mfd/stmpe: Add support for SPI interface
Date: Tue, 8 Nov 2011 12:35:51 +0530
Message-ID: <17b9785025d7c6f149b3807900025eda387877bf.1320735865.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1320735864.git.viresh.kumar@st.com>
References: <cover.1320735864.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Few STMPE controller can have register interface over SPI or I2C. Current
implementation only supports I2C.

This patch adds support for SPI interface for accessing STMPE's address space.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/mfd/Kconfig     |    8 ++-
 drivers/mfd/Makefile    |    1 +
 drivers/mfd/stmpe-spi.c |  147 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/mfd/stmpe.h     |    1 +
 4 files changed, 156 insertions(+), 1 deletions(-)
 create mode 100644 drivers/mfd/stmpe-spi.c

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 2f8561a..ebfb296 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -272,7 +272,7 @@ config TWL6040_CORE
 
 config MFD_STMPE
 	bool "Support STMicroelectronics STMPE"
-	depends on I2C=y && GENERIC_HARDIRQS
+	depends on (I2C=y || SPI_MASTER=y) && GENERIC_HARDIRQS
 	select MFD_CORE
 	help
 	  Support for the STMPE family of I/O Expanders from
@@ -302,6 +302,12 @@ config STMPE_I2C
 	default y
 	help
 	  This is used to enable I2C interface of STMPE
+
+config STMPE_SPI
+	bool "STMPE SPI Inteface"
+	depends on SPI_MASTER
+	help
+	  This is used to enable SPI interface of STMPE
 endmenu
 
 config MFD_TC3589X
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 24ee9bb..eac1e9f 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -17,6 +17,7 @@ obj-$(CONFIG_MFD_TI_SSP)	+= ti-ssp.o
 
 obj-$(CONFIG_MFD_STMPE)		+= stmpe.o
 obj-$(CONFIG_STMPE_I2C)		+= stmpe-i2c.o
+obj-$(CONFIG_STMPE_SPI)		+= stmpe-spi.o
 obj-$(CONFIG_MFD_TC3589X)	+= tc3589x.o
 obj-$(CONFIG_MFD_T7L66XB)	+= t7l66xb.o tmio_core.o
 obj-$(CONFIG_MFD_TC6387XB)	+= tc6387xb.o tmio_core.o
diff --git a/drivers/mfd/stmpe-spi.c b/drivers/mfd/stmpe-spi.c
new file mode 100644
index 0000000..6f1c0ad3
--- /dev/null
+++ b/drivers/mfd/stmpe-spi.c
@@ -0,0 +1,147 @@
+/*
+ * ST Microelectronics MFD: stmpe's spi client specific driver
+ *
+ * Copyright (C) ST Microelectronics SA 2011
+ *
+ * License Terms: GNU General Public License, version 2
+ * Author: Viresh Kumar <viresh.kumar@st.com> for ST Microelectronics
+ */
+
+#include <linux/spi/spi.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include "stmpe.h"
+
+#define READ_CMD	(1 << 7)
+
+static int spi_reg_read(struct stmpe *stmpe, u8 reg)
+{
+	struct spi_device *spi = stmpe->client;
+	int status = spi_w8r16(spi, reg | READ_CMD);
+
+	return (status < 0) ? status : status >> 8;
+}
+
+static int spi_reg_write(struct stmpe *stmpe, u8 reg, u8 val)
+{
+	struct spi_device *spi = stmpe->client;
+	u16 cmd = (val << 8) | reg;
+
+	return spi_write(spi, (const u8 *)&cmd, 2);
+}
+
+static int spi_block_read(struct stmpe *stmpe, u8 reg, u8 length, u8 *values)
+{
+	int ret, i;
+
+	for (i = 0; i < length; i++) {
+		ret = spi_reg_read(stmpe, reg + i);
+		if (ret < 0)
+			return ret;
+		*(values + i) = ret;
+	}
+
+	return 0;
+}
+
+static int spi_block_write(struct stmpe *stmpe, u8 reg, u8 length,
+		const u8 *values)
+{
+	int ret = 0, i;
+
+	for (i = length; i > 0; i--, reg++) {
+		ret = spi_reg_write(stmpe, reg, *(values + i - 1));
+		if (ret < 0)
+			return ret;
+	}
+
+	return ret;
+}
+
+static void spi_init(struct stmpe *stmpe)
+{
+	struct spi_device *spi = stmpe->client;
+
+	dev_set_drvdata(stmpe->dev, stmpe);
+	spi->bits_per_word = 8;
+
+	/* This register is only present for stmpe811 */
+	if (stmpe->variant->id_val == 0x0811)
+		spi_reg_write(stmpe, STMPE811_REG_SPI_CFG, spi->mode);
+
+	if (spi_setup(spi) < 0)
+		dev_dbg(&spi->dev, "spi_setup failed\n");
+}
+
+static struct stmpe_client_info spi_ci = {
+	.read_byte = spi_reg_read,
+	.write_byte = spi_reg_write,
+	.read_block = spi_block_read,
+	.write_block = spi_block_write,
+	.init = spi_init,
+};
+
+static int __devinit
+stmpe_spi_probe(struct spi_device *spi)
+{
+	/* don't exceed max specified rate - 1MHz - Limitation of STMPE */
+	if (spi->max_speed_hz > 1000000) {
+		dev_dbg(&spi->dev, "f(sample) %d KHz?\n",
+				(spi->max_speed_hz/1000));
+		return -EINVAL;
+	}
+
+	spi_ci.irq = spi->irq;
+	spi_ci.client = spi;
+	spi_ci.dev = &spi->dev;
+
+	return stmpe_probe(&spi_ci);
+}
+
+static int __devexit stmpe_spi_remove(struct spi_device *spi)
+{
+	struct stmpe *stmpe = dev_get_drvdata(&spi->dev);
+
+	return stmpe_remove(stmpe);
+}
+
+static const struct spi_device_id stmpe_spi_id[] = {
+	{ "stmpe811", STMPE811 },
+	{ "stmpe1601", STMPE1601 },
+	{ "stmpe2401", STMPE2401 },
+	{ "stmpe2403", STMPE2403 },
+	{ }
+};
+MODULE_DEVICE_TABLE(spi, stmpe_id);
+
+static struct spi_driver stmpe_spi_driver = {
+	.driver = {
+		.name	= "stmpe-spi",
+		.bus	= &spi_bus_type,
+		.owner	= THIS_MODULE,
+#ifdef CONFIG_PM
+		.pm	= &stmpe_dev_pm_ops,
+#endif
+	},
+	.probe		= stmpe_spi_probe,
+	.remove		= __devexit_p(stmpe_spi_remove),
+	.id_table	= stmpe_spi_id,
+};
+
+static int __init stmpe_init(void)
+{
+	return spi_register_driver(&stmpe_spi_driver);
+}
+subsys_initcall(stmpe_init);
+
+static void __exit stmpe_exit(void)
+{
+	spi_unregister_driver(&stmpe_spi_driver);
+}
+module_exit(stmpe_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("STMPE MFD core driver");
+MODULE_AUTHOR("Rabin Vincent <rabin.vincent@stericsson.com>");
diff --git a/drivers/mfd/stmpe.h b/drivers/mfd/stmpe.h
index c716044..908f482 100644
--- a/drivers/mfd/stmpe.h
+++ b/drivers/mfd/stmpe.h
@@ -120,6 +120,7 @@ int stmpe_remove(struct stmpe *stmpe);
 
 #define STMPE811_REG_CHIP_ID		0x00
 #define STMPE811_REG_SYS_CTRL2		0x04
+#define STMPE811_REG_SPI_CFG		0x08
 #define STMPE811_REG_INT_CTRL		0x09
 #define STMPE811_REG_INT_EN		0x0A
 #define STMPE811_REG_INT_STA		0x0B
-- 
1.7.2.2

