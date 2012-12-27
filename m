Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab2L0MLX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 07:11:23 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:61933 "HELO
	vsp-authed-02-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752729Ab2L0MLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 07:11:20 -0500
From: Andreas Larsson <andreas@gaisler.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        software@gaisler.com
Subject: [PATCH 5/6] of_spi: Add fetching of of_gpio flags to of_spi_register_master
Date: Thu, 27 Dec 2012 13:10:46 +0100
Message-Id: <1356610247-11491-6-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1356610247-11491-1-git-send-email-andreas@gaisler.com>
References: <1356610247-11491-1-git-send-email-andreas@gaisler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using a gpio chip select with a OF_GPIO_ACTIVE_LOW flag, this needs to be
known to the controller driver.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
---
 Documentation/devicetree/bindings/spi/spi-bus.txt |    3 +-
 drivers/spi/spi.c                                 |   24 ++++++++++++++++++--
 include/linux/spi/spi.h                           |    5 ++++
 3 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/spi/spi-bus.txt b/Documentation/devicetree/bindings/spi/spi-bus.txt
index 296015e..a4950a6 100644
--- a/Documentation/devicetree/bindings/spi/spi-bus.txt
+++ b/Documentation/devicetree/bindings/spi/spi-bus.txt
@@ -57,7 +57,8 @@ contain the following properties.
     		    3-wire mode.
 
 If a gpio chipselect is used for the SPI slave the gpio number will be passed
-via the cs_gpio
+via the cs_gpio and the corresponding of_gpio_flags will be passed via
+cs_gpio_flags.
 
 SPI example for an MPC5200 SPI bus:
 	spi@f00 {
diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index a4baa0a..6f1b717 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -385,8 +385,10 @@ int spi_add_device(struct spi_device *spi)
 		goto done;
 	}
 
-	if (master->cs_gpios)
+	if (master->cs_gpios) {
 		spi->cs_gpio = master->cs_gpios[spi->chip_select];
+		spi->cs_gpio_flags = master->cs_gpio_flags[spi->chip_select];
+	}
 
 	/* Drivers may modify this initial i/o setup, but will
 	 * normally rely on the device being setup.  Devices
@@ -1060,7 +1062,8 @@ EXPORT_SYMBOL_GPL(spi_alloc_master);
 static int of_spi_register_master(struct spi_master *master)
 {
 	int nb;
-	int i, *cs;
+	int ret, i, *cs;
+	enum of_gpio_flags *flags;
 	struct device_node *np = master->dev.of_node;
 
 	if (!np)
@@ -1083,13 +1086,28 @@ static int of_spi_register_master(struct spi_master *master)
 	if (!master->cs_gpios)
 		return -ENOMEM;
 
+	flags = devm_kzalloc(&master->dev,
+			     sizeof(*flags) * master->num_chipselect,
+			     GFP_KERNEL);
+	master->cs_gpio_flags = flags;
+
+	if (!master->cs_gpio_flags) {
+		ret = -ENOMEM;
+		goto err_alloc_flags;
+	}
+
 	for (i = 0; i < master->num_chipselect; i++)
 		cs[i] = -EINVAL;
 
 	for (i = 0; i < nb; i++)
-		cs[i] = of_get_named_gpio(np, "cs-gpios", i);
+		cs[i] = of_get_named_gpio_flags(np, "cs-gpios", i, &flags[i]);
 
 	return 0;
+
+err_alloc_flags:
+	devm_kfree(&master->dev, master->cs_gpios);
+	master->cs_gpios = NULL;
+	return ret;
 }
 #else
 static int of_spi_register_master(struct spi_master *master)
diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index 88a669c..96b1055 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -23,6 +23,7 @@
 #include <linux/mod_devicetable.h>
 #include <linux/slab.h>
 #include <linux/kthread.h>
+#include <linux/of_gpio.h>
 
 /*
  * INTERFACES between SPI master-side drivers and SPI infrastructure.
@@ -58,6 +59,7 @@ extern struct bus_type spi_bus_type;
  *	for that name.  This appears in the sysfs "modalias" attribute
  *	for driver coldplugging, and in uevents used for hotplugging
  * @cs_gpio: Negative or gpio for chip select.
+ * @cs_gpio_flags: of_gpio_flags corresponding to cs_gpio
  *
  * A @spi_device is used to interchange data between an SPI slave
  * (usually a discrete chip) and CPU memory.
@@ -92,6 +94,7 @@ struct spi_device {
 	void			*controller_data;
 	char			modalias[SPI_NAME_SIZE];
 	int			cs_gpio;	/* chip select gpio */
+	enum of_gpio_flags	cs_gpio_flags;	/* chip select of_gpio_flags */
 
 	/*
 	 * likely need more hooks for more protocol options affecting how
@@ -260,6 +263,7 @@ static inline void spi_unregister_driver(struct spi_driver *sdrv)
  *	queue so the subsystem notifies the driver that it may relax the
  *	hardware by issuing this call
  * @cs_gpios: possible array of negative values or gpios for chip selects
+ * @cs_gpio_flags: possible array of of_gpio_flags corresponding to cs_gpios
  *
  * Each SPI master controller can communicate with one or more @spi_device
  * children.  These make a small bus, sharing MOSI, MISO and SCK signals
@@ -367,6 +371,7 @@ struct spi_master {
 	int (*unprepare_transfer_hardware)(struct spi_master *master);
 	/* gpio chip select */
 	int			*cs_gpios;
+	enum of_gpio_flags	*cs_gpio_flags;
 };
 
 static inline void *spi_master_get_devdata(struct spi_master *master)
-- 
1.7.0.4

