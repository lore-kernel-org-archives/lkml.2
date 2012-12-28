Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab2L1QQa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 11:16:30 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:26340 "HELO
	vsp-authed-03-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753685Ab2L1QQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 11:16:28 -0500
From: Andreas Larsson <andreas@gaisler.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: spi-devel-general@lists.sourceforge.net,
        Mingkai Hu <Mingkai.hu@freescale.com>,
        Anton Vorontsov <avorontsov@ru.mvista.com>,
        Joakim Tjernlund <Joakim.Tjernlund@transmode.se>,
        Kumar Gala <galak@kernel.crashing.org>,
        Peter Korsgaard <jacmet@sunsite.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH] spi: spi-fsl-spi: Make spi-fsl-spi usable in cpu mode outside of FSL SOC environments and add a grlib variant normally running on sparc
Date: Fri, 28 Dec 2012 17:16:08 +0100
Message-Id: <1356711368-10437-1-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes the cpu mode of the driver available outside of an FSL SOC
and even powerpc environment. This is accomplished by putting things
regarding fsl specific code and to cpm specific code within ifdefs.

Furthermore, this adds support for the mostly register-compatible
SPICTRL core from the GRLIB VHDL IP core library normally running on
sparc. A different entry in of_fsl_spi_match matches this core and
indicates a different hardware type that is used to set up different
function pointers and special cases. The fetching of irq is changed to
work under sparc as well.

The GRLIB core operates in cpu mode and from the driver's point of view
the important differences are that the number of bits per word might be
limited and that there might be native chipselects selected via the
added slvsel register. These differences if present are indicated by an
added capabilities register.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
---

This patch relies upon parts of the "of, of_gpio, of_spi: Fix and
improve of_parse_phandle_with_args, of_gpio_named_count and
of_spi_register_master" patchset - https://lkml.org/lkml/2012/12/27/54.

The grlib type has been tested under sparc, but the fsl type has only
been compile tested, so it would be great if someone with an fsl board
could test this out.

One could argue that it would be better to add the grlib variant as a
mode flag in of_mpc8xxx_spi_probe instead of using a new type field, but
that would require to add a flag for this core in
include/linux/fsl_devices.h which does not feel right given that this
core is not part of an fsl device.

Maybe the different out/in_be32 vs iowrite/read32be in spi-fsl-lib.h is
over the top, but I'm not sure if there might be subtle differences
between those on powerpc and I don't have any fsl hardware to try things
out on.

 drivers/spi/Kconfig       |    4 +-
 drivers/spi/spi-fsl-lib.c |   10 ++
 drivers/spi/spi-fsl-lib.h |   19 +++
 drivers/spi/spi-fsl-spi.c |  276 ++++++++++++++++++++++++++++++++++++++-------
 4 files changed, 267 insertions(+), 42 deletions(-)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 2e188e1..17db805 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -218,11 +218,11 @@ config SPI_MPC512x_PSC
 
 config SPI_FSL_LIB
 	tristate
-	depends on FSL_SOC
+	depends on OF
 
 config SPI_FSL_SPI
 	bool "Freescale SPI controller"
-	depends on FSL_SOC
+	depends on OF
 	select SPI_FSL_LIB
 	help
 	  This enables using the Freescale SPI controllers in master mode.
diff --git a/drivers/spi/spi-fsl-lib.c b/drivers/spi/spi-fsl-lib.c
index 8ade675..e3ea564 100644
--- a/drivers/spi/spi-fsl-lib.c
+++ b/drivers/spi/spi-fsl-lib.c
@@ -23,7 +23,9 @@
 #include <linux/mm.h>
 #include <linux/of_platform.h>
 #include <linux/spi/spi.h>
+#ifdef CONFIG_FSL_SOC
 #include <sysdev/fsl_soc.h>
+#endif
 
 #include "spi-fsl-lib.h"
 
@@ -208,6 +210,7 @@ int of_mpc8xxx_spi_probe(struct platform_device *ofdev)
 	/* Allocate bus num dynamically. */
 	pdata->bus_num = -1;
 
+#ifdef CONFIG_FSL_SOC
 	/* SPI controller is either clocked from QE or SoC clock. */
 	pdata->sysclk = get_brgfreq();
 	if (pdata->sysclk == -1) {
@@ -217,16 +220,23 @@ int of_mpc8xxx_spi_probe(struct platform_device *ofdev)
 			goto err;
 		}
 	}
+#else
+	ret = of_property_read_u32(np, "clock-frequency", &pdata->sysclk);
+	if (ret)
+		goto err;
+#endif
 
 	prop = of_get_property(np, "mode", NULL);
 	if (prop && !strcmp(prop, "cpu-qe"))
 		pdata->flags = SPI_QE_CPU_MODE;
+#ifdef CONFIG_FSL_SOC
 	else if (prop && !strcmp(prop, "qe"))
 		pdata->flags = SPI_CPM_MODE | SPI_QE;
 	else if (of_device_is_compatible(np, "fsl,cpm2-spi"))
 		pdata->flags = SPI_CPM_MODE | SPI_CPM2;
 	else if (of_device_is_compatible(np, "fsl,cpm1-spi"))
 		pdata->flags = SPI_CPM_MODE | SPI_CPM1;
+#endif
 
 	return 0;
 
diff --git a/drivers/spi/spi-fsl-lib.h b/drivers/spi/spi-fsl-lib.h
index cbe881b..f66f736 100644
--- a/drivers/spi/spi-fsl-lib.h
+++ b/drivers/spi/spi-fsl-lib.h
@@ -34,8 +34,10 @@ struct mpc8xxx_spi {
 
 	int subblock;
 	struct spi_pram __iomem *pram;
+#ifdef CONFIG_FSL_SOC
 	struct cpm_buf_desc __iomem *tx_bd;
 	struct cpm_buf_desc __iomem *rx_bd;
+#endif
 
 	struct spi_transfer *xfer_in_progress;
 
@@ -67,6 +69,15 @@ struct mpc8xxx_spi {
 
 	unsigned int flags;
 
+#ifdef CONFIG_SPI_FSL_SPI
+	int type;
+	int native_chipselects;
+	u8 max_bits_per_word;
+
+	void (*set_shifts)(u32 *rx_shift, u32 *tx_shift,
+			   int bits_per_word, int msb_first);
+#endif
+
 	struct workqueue_struct *workqueue;
 	struct work_struct work;
 
@@ -87,12 +98,20 @@ struct spi_mpc8xxx_cs {
 
 static inline void mpc8xxx_spi_write_reg(__be32 __iomem *reg, u32 val)
 {
+#ifdef CONFIG_FSL_SOC
 	out_be32(reg, val);
+#else
+	iowrite32be(val, reg);
+#endif
 }
 
 static inline u32 mpc8xxx_spi_read_reg(__be32 __iomem *reg)
 {
+#ifdef CONFIG_FSL_SOC
 	return in_be32(reg);
+#else
+	return ioread32be(reg);
+#endif
 }
 
 struct mpc8xxx_spi_probe_info {
diff --git a/drivers/spi/spi-fsl-spi.c b/drivers/spi/spi-fsl-spi.c
index 3ff4dfe..f9ca8ba 100644
--- a/drivers/spi/spi-fsl-spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -10,6 +10,10 @@
  * Copyright (c) 2009  MontaVista Software, Inc.
  * Author: Anton Vorontsov <avorontsov@ru.mvista.com>
  *
+ * GRLIB support:
+ * Copyright (c) 2012 Aeroflex Gaisler AB.
+ * Author: Andreas Larsson <andreas@gaisler.com>
+ *
  * This program is free software; you can redistribute  it and/or modify it
  * under  the terms of  the GNU General  Public License as published by the
  * Free Software Foundation;  either version 2 of the  License, or (at your
@@ -30,15 +34,20 @@
 #include <linux/mutex.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
 #include <linux/gpio.h>
 #include <linux/of_gpio.h>
 
+#ifdef CONFIG_FSL_SOC
 #include <sysdev/fsl_soc.h>
 #include <asm/cpm.h>
 #include <asm/qe.h>
+#endif
 
 #include "spi-fsl-lib.h"
 
+#ifdef CONFIG_FSL_SOC
 /* CPM1 and CPM2 are mutually exclusive. */
 #ifdef CONFIG_CPM1
 #include <asm/cpm1.h>
@@ -47,16 +56,19 @@
 #include <asm/cpm2.h>
 #define CPM_SPI_CMD mk_cr_cmd(CPM_CR_SPI_PAGE, CPM_CR_SPI_SBLOCK, 0, 0)
 #endif
+#endif
 
 /* SPI Controller registers */
 struct fsl_spi_reg {
-	u8 res1[0x20];
+	__be32 cap; /* TYPE_GRLIB specific */
+	u8 res1[0x1C];
 	__be32 mode;
 	__be32 event;
 	__be32 mask;
 	__be32 command;
 	__be32 transmit;
 	__be32 receive;
+	__be32 slvsel; /* TYPE_GRLIB specific */
 };
 
 /* SPI Controller mode register definitions */
@@ -72,6 +84,11 @@ struct fsl_spi_reg {
 #define	SPMODE_OP		(1 << 14)
 #define	SPMODE_CG(x)		((x) << 7)
 
+/* TYPE_GRLIB SPI Controller capability register definitions */
+#define SPCAP_SSEN(x)           (((x) >> 16) & 0x1)
+#define SPCAP_SSSZ(x)           (((x) >> 24) & 0xff)
+#define SPCAP_MAXWLEN(x)	(((x) >> 20) & 0xf)
+
 /*
  * Default for SPI Mode:
  *	SPI MODE 0 (inactive low, phase middle, MSB, 8-bit length, slow clk
@@ -96,9 +113,53 @@ struct fsl_spi_reg {
 #define	SPI_PRAM_SIZE	0x100
 #define	SPI_MRBLR	((unsigned int)PAGE_SIZE)
 
+#ifdef CONFIG_FSL_SOC
 static void *fsl_dummy_rx;
 static DEFINE_MUTEX(fsl_dummy_rx_lock);
 static int fsl_dummy_rx_refcnt;
+#endif
+
+#define TYPE_FSL	0
+#define TYPE_GRLIB	1
+
+
+struct spi_fsl_match_data {
+	int type;
+};
+
+static struct spi_fsl_match_data of_fsl_spi_fsl_config = {
+	.type = TYPE_FSL,
+};
+
+static struct spi_fsl_match_data of_fsl_spi_grlib_config = {
+	.type = TYPE_GRLIB,
+};
+
+
+static struct of_device_id of_fsl_spi_match[] = {
+	{
+		.compatible = "fsl,spi",
+		.data = &of_fsl_spi_fsl_config,
+	},
+	{
+		.compatible = "aeroflexgaisler,spictrl",
+		.data = &of_fsl_spi_grlib_config,
+	},
+	{}
+};
+MODULE_DEVICE_TABLE(of, of_fsl_spi_match);
+
+static int fsl_spi_get_type(struct device *dev)
+{
+	const struct of_device_id *match;
+
+	if (dev->of_node) {
+		match = of_match_node(of_fsl_spi_match, dev->of_node);
+		if (match && match->data)
+			return ((struct spi_fsl_match_data *)match->data)->type;
+	}
+	return TYPE_FSL;
+}
 
 static void fsl_spi_change_mode(struct spi_device *spi)
 {
@@ -117,6 +178,7 @@ static void fsl_spi_change_mode(struct spi_device *spi)
 	/* Turn off SPI unit prior changing mode */
 	mpc8xxx_spi_write_reg(mode, cs->hw_mode & ~SPMODE_ENABLE);
 
+#ifdef CONFIG_FSL_SOC
 	/* When in CPM mode, we need to reinit tx and rx. */
 	if (mspi->flags & SPI_CPM_MODE) {
 		if (mspi->flags & SPI_QE) {
@@ -132,6 +194,7 @@ static void fsl_spi_change_mode(struct spi_device *spi)
 			}
 		}
 	}
+#endif
 	mpc8xxx_spi_write_reg(mode, cs->hw_mode);
 	local_irq_restore(flags);
 }
@@ -163,6 +226,40 @@ static void fsl_spi_chipselect(struct spi_device *spi, int value)
 	}
 }
 
+static void fsl_spi_qe_cpu_set_shifts(u32 *rx_shift, u32 *tx_shift,
+				      int bits_per_word, int msb_first)
+{
+	*rx_shift = 0;
+	*tx_shift = 0;
+	if (msb_first) {
+		if (bits_per_word <= 8) {
+			*rx_shift = 16;
+			*tx_shift = 24;
+		} else if (bits_per_word <= 16) {
+			*rx_shift = 16;
+			*tx_shift = 16;
+		}
+	} else {
+		if (bits_per_word <= 8)
+			*rx_shift = 8;
+	}
+}
+
+static void fsl_spi_grlib_set_shifts(u32 *rx_shift, u32 *tx_shift,
+				     int bits_per_word, int msb_first)
+{
+	*rx_shift = 0;
+	*tx_shift = 0;
+	if (bits_per_word <= 16) {
+		if (msb_first) {
+			*rx_shift = 16; /* LSB in bit 16 */
+			*tx_shift = 32 - bits_per_word; /* MSB in bit 31 */
+		} else {
+			*rx_shift = 16 - bits_per_word; /* MSB in bit 15 */
+		}
+	}
+}
+
 static int mspi_apply_cpu_mode_quirks(struct spi_mpc8xxx_cs *cs,
 				struct spi_device *spi,
 				struct mpc8xxx_spi *mpc8xxx_spi,
@@ -173,31 +270,19 @@ static int mspi_apply_cpu_mode_quirks(struct spi_mpc8xxx_cs *cs,
 	if (bits_per_word <= 8) {
 		cs->get_rx = mpc8xxx_spi_rx_buf_u8;
 		cs->get_tx = mpc8xxx_spi_tx_buf_u8;
-		if (mpc8xxx_spi->flags & SPI_QE_CPU_MODE) {
-			cs->rx_shift = 16;
-			cs->tx_shift = 24;
-		}
 	} else if (bits_per_word <= 16) {
 		cs->get_rx = mpc8xxx_spi_rx_buf_u16;
 		cs->get_tx = mpc8xxx_spi_tx_buf_u16;
-		if (mpc8xxx_spi->flags & SPI_QE_CPU_MODE) {
-			cs->rx_shift = 16;
-			cs->tx_shift = 16;
-		}
 	} else if (bits_per_word <= 32) {
 		cs->get_rx = mpc8xxx_spi_rx_buf_u32;
 		cs->get_tx = mpc8xxx_spi_tx_buf_u32;
 	} else
 		return -EINVAL;
 
-	if (mpc8xxx_spi->flags & SPI_QE_CPU_MODE &&
-	    spi->mode & SPI_LSB_FIRST) {
-		cs->tx_shift = 0;
-		if (bits_per_word <= 8)
-			cs->rx_shift = 8;
-		else
-			cs->rx_shift = 0;
-	}
+	if (mpc8xxx_spi->set_shifts)
+		mpc8xxx_spi->set_shifts(&cs->rx_shift, &cs->tx_shift,
+					bits_per_word,
+					!(spi->mode & SPI_LSB_FIRST));
 	mpc8xxx_spi->rx_shift = cs->rx_shift;
 	mpc8xxx_spi->tx_shift = cs->tx_shift;
 	mpc8xxx_spi->get_rx = cs->get_rx;
@@ -246,7 +331,8 @@ static int fsl_spi_setup_transfer(struct spi_device *spi,
 
 	/* Make sure its a bit width we support [4..16, 32] */
 	if ((bits_per_word < 4)
-	    || ((bits_per_word > 16) && (bits_per_word != 32)))
+	    || ((bits_per_word > 16) && (bits_per_word != 32))
+	    || (bits_per_word > mpc8xxx_spi->max_bits_per_word))
 		return -EINVAL;
 
 	if (!hz)
@@ -295,6 +381,7 @@ static int fsl_spi_setup_transfer(struct spi_device *spi,
 	return 0;
 }
 
+#ifdef CONFIG_FSL_SOC
 static void fsl_spi_cpm_bufs_start(struct mpc8xxx_spi *mspi)
 {
 	struct cpm_buf_desc __iomem *tx_bd = mspi->tx_bd;
@@ -323,6 +410,9 @@ static void fsl_spi_cpm_bufs_start(struct mpc8xxx_spi *mspi)
 	/* start transfer */
 	mpc8xxx_spi_write_reg(&reg_base->command, SPCOM_STR);
 }
+#else
+static void fsl_spi_cpm_bufs_start(struct mpc8xxx_spi *mspi) { }
+#endif
 
 static int fsl_spi_cpm_bufs(struct mpc8xxx_spi *mspi,
 				struct spi_transfer *t, bool is_dma_mapped)
@@ -528,7 +618,7 @@ static int fsl_spi_setup(struct spi_device *spi)
 {
 	struct mpc8xxx_spi *mpc8xxx_spi;
 	struct fsl_spi_reg *reg_base;
-	int retval;
+	int retval, desel;
 	u32 hw_mode;
 	struct spi_mpc8xxx_cs	*cs = spi->controller_state;
 
@@ -565,9 +655,47 @@ static int fsl_spi_setup(struct spi_device *spi)
 		cs->hw_mode = hw_mode; /* Restore settings */
 		return retval;
 	}
+
+	if (mpc8xxx_spi->type == TYPE_GRLIB) {
+		if (gpio_is_valid(spi->cs_gpio)) {
+			retval = gpio_request(spi->cs_gpio,
+					      dev_name(&spi->dev));
+			if (retval)
+				return retval;
+
+			desel = !(spi->mode & SPI_CS_HIGH);
+			desel ^= !!(spi->cs_gpio_flags & OF_GPIO_ACTIVE_LOW);
+			retval = gpio_direction_output(spi->cs_gpio, desel);
+			if (retval) {
+				gpio_free(spi->cs_gpio);
+				return retval;
+			}
+		} else if (spi->cs_gpio != -EEXIST) {
+			if (spi->cs_gpio < 0)
+				return spi->cs_gpio;
+			return -EINVAL;
+		}
+		/* When spi->cs_gpio == -EEXIST, a hole in the phandle list
+		 * indicates to use native chipselect if present, or allow for
+		 * an always selected chip
+		 */
+	}
+
+	/* Initialize chipselect - might be active at this point */
+	fsl_spi_chipselect(spi, BITBANG_CS_INACTIVE);
+
 	return 0;
 }
 
+static void fsl_spi_cleanup(struct spi_device *spi)
+{
+	struct mpc8xxx_spi *mpc8xxx_spi = spi_master_get_devdata(spi->master);
+
+	if (mpc8xxx_spi->type == TYPE_GRLIB && gpio_is_valid(spi->cs_gpio))
+		gpio_free(spi->cs_gpio);
+}
+
+#ifdef CONFIG_FSL_SOC
 static void fsl_spi_cpm_irq(struct mpc8xxx_spi *mspi, u32 events)
 {
 	u16 len;
@@ -591,6 +719,9 @@ static void fsl_spi_cpm_irq(struct mpc8xxx_spi *mspi, u32 events)
 	else
 		complete(&mspi->done);
 }
+#else
+static void fsl_spi_cpm_irq(struct mpc8xxx_spi *mspi, u32 events) { }
+#endif
 
 static void fsl_spi_cpu_irq(struct mpc8xxx_spi *mspi, u32 events)
 {
@@ -646,6 +777,7 @@ static irqreturn_t fsl_spi_irq(s32 irq, void *context_data)
 	return ret;
 }
 
+#ifdef CONFIG_FSL_SOC
 static void *fsl_spi_alloc_dummy_rx(void)
 {
 	mutex_lock(&fsl_dummy_rx_lock);
@@ -836,6 +968,10 @@ static void fsl_spi_cpm_free(struct mpc8xxx_spi *mspi)
 	cpm_muram_free(cpm_muram_offset(mspi->pram));
 	fsl_spi_free_dummy_rx();
 }
+#else
+static int fsl_spi_cpm_init(struct mpc8xxx_spi *mspi) { return 0; }
+static void fsl_spi_cpm_free(struct mpc8xxx_spi *mspi) { }
+#endif
 
 static void fsl_spi_remove(struct mpc8xxx_spi *mspi)
 {
@@ -843,6 +979,52 @@ static void fsl_spi_remove(struct mpc8xxx_spi *mspi)
 	fsl_spi_cpm_free(mspi);
 }
 
+static void fsl_spi_grlib_cs_control(struct spi_device *spi, bool on)
+{
+	struct mpc8xxx_spi *mpc8xxx_spi = spi_master_get_devdata(spi->master);
+	struct fsl_spi_reg *reg_base = mpc8xxx_spi->reg_base;
+	u32 slvsel;
+	u16 cs = spi->chip_select;
+
+	if (gpio_is_valid(spi->cs_gpio)) {
+		if  (spi->cs_gpio_flags & OF_GPIO_ACTIVE_LOW)
+			on = !on;
+		gpio_set_value(spi->cs_gpio, on);
+	} else if (cs < mpc8xxx_spi->native_chipselects) {
+		slvsel = mpc8xxx_spi_read_reg(&reg_base->slvsel);
+		slvsel = on ? (slvsel | (1 << cs)) : (slvsel & ~(1 << cs));
+		mpc8xxx_spi_write_reg(&reg_base->slvsel, slvsel);
+	}
+}
+
+static void fsl_spi_grlib_probe(struct device *dev)
+{
+	struct fsl_spi_platform_data *pdata = dev->platform_data;
+	struct spi_master *master = dev_get_drvdata(dev);
+	struct mpc8xxx_spi *mpc8xxx_spi = spi_master_get_devdata(master);
+	struct fsl_spi_reg *reg_base = mpc8xxx_spi->reg_base;
+	int ret, mbits;
+	u32 capabilities;
+	u32 bus_num;
+
+	capabilities = mpc8xxx_spi_read_reg(&reg_base->cap);
+
+	mpc8xxx_spi->set_shifts = fsl_spi_grlib_set_shifts;
+	mbits = SPCAP_MAXWLEN(capabilities);
+	if (mbits)
+		mpc8xxx_spi->max_bits_per_word = mbits + 1;
+
+	ret = of_property_read_u32(dev->of_node, "bus-number", &bus_num);
+	if (!ret)
+		master->bus_num = bus_num;
+
+	mpc8xxx_spi->native_chipselects = 0;
+	if (SPCAP_SSEN(capabilities))
+		mpc8xxx_spi->native_chipselects = SPCAP_SSSZ(capabilities);
+	master->num_chipselect = mpc8xxx_spi->native_chipselects;
+	pdata->cs_control = fsl_spi_grlib_cs_control;
+}
+
 static struct spi_master * fsl_spi_probe(struct device *dev,
 		struct resource *mem, unsigned int irq)
 {
@@ -866,27 +1048,36 @@ static struct spi_master * fsl_spi_probe(struct device *dev,
 		goto err_probe;
 
 	master->setup = fsl_spi_setup;
+	master->cleanup = fsl_spi_cleanup;
 
 	mpc8xxx_spi = spi_master_get_devdata(master);
 	mpc8xxx_spi->spi_do_one_msg = fsl_spi_do_one_msg;
 	mpc8xxx_spi->spi_remove = fsl_spi_remove;
-
+	mpc8xxx_spi->max_bits_per_word = 32;
+	mpc8xxx_spi->type = fsl_spi_get_type(dev);
 
 	ret = fsl_spi_cpm_init(mpc8xxx_spi);
 	if (ret)
 		goto err_cpm_init;
 
-	if (mpc8xxx_spi->flags & SPI_QE_CPU_MODE) {
-		mpc8xxx_spi->rx_shift = 16;
-		mpc8xxx_spi->tx_shift = 24;
-	}
-
 	mpc8xxx_spi->reg_base = ioremap(mem->start, resource_size(mem));
 	if (mpc8xxx_spi->reg_base == NULL) {
 		ret = -ENOMEM;
 		goto err_ioremap;
 	}
 
+	if (mpc8xxx_spi->type == TYPE_GRLIB)
+		fsl_spi_grlib_probe(dev);
+
+	if (mpc8xxx_spi->flags & SPI_QE_CPU_MODE)
+		mpc8xxx_spi->set_shifts = fsl_spi_qe_cpu_set_shifts;
+
+	if (mpc8xxx_spi->set_shifts)
+		/* 8 bits per word and MSB first */
+		mpc8xxx_spi->set_shifts(&mpc8xxx_spi->rx_shift,
+					&mpc8xxx_spi->tx_shift, 8, 1);
+
+
 	/* Register for SPI Interrupt */
 	ret = request_irq(mpc8xxx_spi->irq, fsl_spi_irq,
 			  0, "fsl_spi", mpc8xxx_spi);
@@ -904,6 +1095,10 @@ static struct spi_master * fsl_spi_probe(struct device *dev,
 
 	/* Enable SPI interface */
 	regval = pdata->initial_spmode | SPMODE_INIT_VAL | SPMODE_ENABLE;
+	if (mpc8xxx_spi->max_bits_per_word < 8) {
+		regval &= ~SPMODE_LEN(0xF);
+		regval |= SPMODE_LEN(mpc8xxx_spi->max_bits_per_word - 1);
+	}
 	if (mpc8xxx_spi->flags & SPI_QE_CPU_MODE)
 		regval |= SPMODE_OP;
 
@@ -1049,28 +1244,31 @@ static int of_fsl_spi_probe(struct platform_device *ofdev)
 	struct device_node *np = ofdev->dev.of_node;
 	struct spi_master *master;
 	struct resource mem;
-	struct resource irq;
+	int irq, type;
 	int ret = -ENOMEM;
 
 	ret = of_mpc8xxx_spi_probe(ofdev);
 	if (ret)
 		return ret;
 
-	ret = of_fsl_spi_get_chipselects(dev);
-	if (ret)
-		goto err;
+	type = fsl_spi_get_type(&ofdev->dev);
+	if (type == TYPE_FSL) {
+		ret = of_fsl_spi_get_chipselects(dev);
+		if (ret)
+			goto err;
+	}
 
 	ret = of_address_to_resource(np, 0, &mem);
 	if (ret)
 		goto err;
 
-	ret = of_irq_to_resource(np, 0, &irq);
-	if (!ret) {
+	irq = irq_of_parse_and_map(np, 0);
+	if (!irq) {
 		ret = -EINVAL;
 		goto err;
 	}
 
-	master = fsl_spi_probe(dev, &mem, irq.start);
+	master = fsl_spi_probe(dev, &mem, irq);
 	if (IS_ERR(master)) {
 		ret = PTR_ERR(master);
 		goto err;
@@ -1079,27 +1277,25 @@ static int of_fsl_spi_probe(struct platform_device *ofdev)
 	return 0;
 
 err:
-	of_fsl_spi_free_chipselects(dev);
+	if (type == TYPE_FSL)
+		of_fsl_spi_free_chipselects(dev);
 	return ret;
 }
 
 static int of_fsl_spi_remove(struct platform_device *ofdev)
 {
+	struct spi_master *master = dev_get_drvdata(&ofdev->dev);
+	struct mpc8xxx_spi *mpc8xxx_spi = spi_master_get_devdata(master);
 	int ret;
 
 	ret = mpc8xxx_spi_remove(&ofdev->dev);
 	if (ret)
 		return ret;
-	of_fsl_spi_free_chipselects(&ofdev->dev);
+	if (mpc8xxx_spi->type == TYPE_FSL)
+		of_fsl_spi_free_chipselects(&ofdev->dev);
 	return 0;
 }
 
-static const struct of_device_id of_fsl_spi_match[] = {
-	{ .compatible = "fsl,spi" },
-	{}
-};
-MODULE_DEVICE_TABLE(of, of_fsl_spi_match);
-
 static struct platform_driver of_fsl_spi_driver = {
 	.driver = {
 		.name = "fsl_spi",
-- 
1.7.0.4

