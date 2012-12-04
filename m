Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429Ab2LDIBc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 03:01:32 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:27998 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab2LDH64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 02:58:56 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, nicolas.ferre@atmel.com,
        plagnioj@jcrosoft.com, richard.genoud@gmail.com, JM.Lin@atmel.com,
        wenyou.yang@atmel.com, devicetree-discuss@lists.ozlabs.org,
        spi-devel-general@lists.sourceforge.net, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, rob@landley.net
Subject: [v2 PATCH 02/14] of_spi: add generic binding support to specify cs gpio
Date: Tue,  4 Dec 2012 15:53:48 +0800
Message-Id: <1354607640-13229-3-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354607640-13229-1-git-send-email-wenyou.yang@atmel.com>
References: <1354607640-13229-1-git-send-email-wenyou.yang@atmel.com>
X-OriginalArrivalTime: 04 Dec 2012 07:58:18.0624 (UTC) FILETIME=[1F518000:01CDD1F5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

This will allow to use gpio for chip select with no modification in the
driver binding

When use the cs-gpios, the gpio number will be passed via the cs_gpio field
and the number of chip select will automatically increased.

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: spi-devel-general@lists.sourceforge.net
Cc: grant.likely@secretlab.ca
Cc: rob.herring@calxeda.com
Cc: rob@landley.net
Cc: richard.genoud@gmail.com
---
Hi, Richard,

This patch based on the original patch from Jean-Christophe, 
 	[PATCH] of_spi: add generic binding support to specify cs gpio
and merge the patch from Richard Genoud,
	[PATCH] [BUG] SPI: array out of bound => no CS

Could you sign your signature in this patch?

Best Regards,
Wenyou Yang

 Documentation/devicetree/bindings/spi/spi-bus.txt |    6 +++
 drivers/spi/spi.c                                 |   55 +++++++++++++++++++--
 include/linux/spi/spi.h                           |    3 ++
 3 files changed, 61 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/spi/spi-bus.txt b/Documentation/devicetree/bindings/spi/spi-bus.txt
index d2c33d0..7f59ae30 100644
--- a/Documentation/devicetree/bindings/spi/spi-bus.txt
+++ b/Documentation/devicetree/bindings/spi/spi-bus.txt
@@ -12,6 +12,7 @@ The SPI master node requires the following properties:
 - #size-cells     - should be zero.
 - compatible      - name of SPI bus controller following generic names
     		recommended practice.
+- cs-gpios	  - (optional) gpios chip select.
 No other properties are required in the SPI bus node.  It is assumed
 that a driver for an SPI bus device will understand that it is an SPI bus.
 However, the binding does not attempt to define the specific method for
@@ -21,6 +22,8 @@ assumption that board specific platform code will be used to manage
 chip selects.  Individual drivers can define additional properties to
 support describing the chip select layout.
 
+If cs-gpios is used the number of chip select will automatically increased.
+
 Optional property:
 - num-cs : total number of chipselects
 
@@ -37,6 +40,9 @@ contain the following properties.
 - spi-cs-high     - (optional) Empty property indicating device requires
     		chip select active high
 
+If a gpio chipselect is used for the SPI slave the gpio number will be passed
+via the controller_data
+
 SPI example for an MPC5200 SPI bus:
 	spi@f00 {
 		#address-cells = <1>;
diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 84c2861..74e6577 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -30,6 +30,7 @@
 #include <linux/slab.h>
 #include <linux/mod_devicetable.h>
 #include <linux/spi/spi.h>
+#include <linux/of_gpio.h>
 #include <linux/pm_runtime.h>
 #include <linux/export.h>
 #include <linux/sched.h>
@@ -327,6 +328,7 @@ struct spi_device *spi_alloc_device(struct spi_master *master)
 	spi->dev.parent = &master->dev;
 	spi->dev.bus = &spi_bus_type;
 	spi->dev.release = spidev_release;
+	spi->cs_gpio = -EINVAL;
 	device_initialize(&spi->dev);
 	return spi;
 }
@@ -344,15 +346,16 @@ EXPORT_SYMBOL_GPL(spi_alloc_device);
 int spi_add_device(struct spi_device *spi)
 {
 	static DEFINE_MUTEX(spi_add_lock);
-	struct device *dev = spi->master->dev.parent;
+	struct spi_master *master = spi->master;
+	struct device *dev = master->dev.parent;
 	struct device *d;
 	int status;
 
 	/* Chipselects are numbered 0..max; validate. */
-	if (spi->chip_select >= spi->master->num_chipselect) {
+	if (spi->chip_select >= master->num_chipselect) {
 		dev_err(dev, "cs%d >= max %d\n",
 			spi->chip_select,
-			spi->master->num_chipselect);
+			master->num_chipselect);
 		return -EINVAL;
 	}
 
@@ -376,6 +379,9 @@ int spi_add_device(struct spi_device *spi)
 		goto done;
 	}
 
+	if (master->cs_gpios)
+		spi->cs_gpio = master->cs_gpios[spi->chip_select];
+
 	/* Drivers may modify this initial i/o setup, but will
 	 * normally rely on the device being setup.  Devices
 	 * using SPI_CS_HIGH can't coexist well otherwise...
@@ -946,6 +952,45 @@ struct spi_master *spi_alloc_master(struct device *dev, unsigned size)
 }
 EXPORT_SYMBOL_GPL(spi_alloc_master);
 
+#ifdef CONFIG_OF
+static int of_spi_register_master(struct spi_master *master)
+{
+	int nb, i;
+	int *cs;
+	struct device_node *np = master->dev.of_node;
+
+	if (!np)
+		return 0;
+
+	nb = of_gpio_named_count(np, "cs-gpios");
+
+	if (nb < 1)
+		return 0;
+
+	cs = devm_kzalloc(&master->dev,
+			  sizeof(int) * (master->num_chipselect + nb),
+			  GFP_KERNEL);
+	master->cs_gpios = cs;
+
+	if (!master->cs_gpios)
+		return -ENOMEM;
+
+	memset(cs, -EINVAL, master->num_chipselect);
+	cs += master->num_chipselect;
+	master->num_chipselect += nb;
+
+	for (i = 0; i < nb; i++)
+		cs[i] = of_get_named_gpio(np, "cs-gpios", i);
+
+	return 0;
+}
+#else
+static int of_spi_register_master(struct spi_master *master)
+{
+	return 0;
+}
+#endif
+
 /**
  * spi_register_master - register SPI master controller
  * @master: initialized master, originally from spi_alloc_master()
@@ -977,6 +1022,10 @@ int spi_register_master(struct spi_master *master)
 	if (!dev)
 		return -ENODEV;
 
+	status = of_spi_register_master(master);
+	if (status)
+		return status;
+
 	/* even if it's just one always-selected device, there must
 	 * be at least one chipselect
 	 */
diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index fa702ae..f629189 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -90,6 +90,7 @@ struct spi_device {
 	void			*controller_state;
 	void			*controller_data;
 	char			modalias[SPI_NAME_SIZE];
+	int			cs_gpio;	/* chip select gpio */
 
 	/*
 	 * likely need more hooks for more protocol options affecting how
@@ -362,6 +363,8 @@ struct spi_master {
 	int (*transfer_one_message)(struct spi_master *master,
 				    struct spi_message *mesg);
 	int (*unprepare_transfer_hardware)(struct spi_master *master);
+	/* gpio chip select */
+	int			*cs_gpios;
 };
 
 static inline void *spi_master_get_devdata(struct spi_master *master)
-- 
1.7.9.5

