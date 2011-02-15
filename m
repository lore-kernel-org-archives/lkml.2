Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab1BOMpQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 07:45:16 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53151 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab1BOMpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 07:45:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=aTmWzXX/Wvhs13r/hYOP+Qpf6SQ4tDJ4KLPbAmTX823Z19P/+Xjphv3lNZQ6uniGop
         dKqVN1/dlOg1qJdk8OgA3J5Br+ZIbltMPogB0wJE9zt1NGYWT/25bASdPkdWsvk0QcQK
         T+h6vh0ixKvTS/ohWaAKKKmYN/tCw4t4wuHf4=
From: Peter Korsgaard <jacmet@sunsite.dk>
To: grant.likely@secretlab.ca, dbrownell@users.sourceforge.net,
        linux-kernel@vger.kernel.org
Cc: Peter Korsgaard <jacmet@sunsite.dk>
Subject: [PATCHv2] mcp23s08: support mcp23s17 variant
Date: Tue, 15 Feb 2011 13:44:55 +0100
Message-Id: <1297773895-12640-1-git-send-email-jacmet@sunsite.dk>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mpc23s17 is very similar to the mcp23s08, except that registers are 16bit
wide, so extend the interface to work with both variants.

The s17 variant also has an additional address pin, so adjust platform
data structure to support up to 8 devices per SPI chipselect.

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
---
Changes since v1:
- Add mcp23s08_ops callbacks for 8 and 16 bit instead of handling both
  in the same accessor function as requested by Grant.
- Don't use a temporary buffer for 8bit version of read_regs -
  Stack addresses are not DMA safe.

 drivers/gpio/Kconfig         |    6 +-
 drivers/gpio/mcp23s08.c      |  191 +++++++++++++++++++++++++++++++-----------
 include/linux/spi/mcp23s08.h |   15 ++--
 3 files changed, 155 insertions(+), 57 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 664660e..9573b33 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -368,11 +368,11 @@ config GPIO_MAX7301
 	  GPIO driver for Maxim MAX7301 SPI-based GPIO expander.
 
 config GPIO_MCP23S08
-	tristate "Microchip MCP23S08 I/O expander"
+	tristate "Microchip MCP23Sxx I/O expander"
 	depends on SPI_MASTER
 	help
-	  SPI driver for Microchip MCP23S08 I/O expander.  This provides
-	  a GPIO interface supporting inputs and outputs.
+	  SPI driver for Microchip MCP23S08/MPC23S17 I/O expanders.
+	  This provides a GPIO interface supporting inputs and outputs.
 
 config GPIO_MC33880
 	tristate "Freescale MC33880 high-side/low-side switch"
diff --git a/drivers/gpio/mcp23s08.c b/drivers/gpio/mcp23s08.c
index 69f6f19..40e0760 100644
--- a/drivers/gpio/mcp23s08.c
+++ b/drivers/gpio/mcp23s08.c
@@ -10,7 +10,13 @@
 #include <linux/spi/spi.h>
 #include <linux/spi/mcp23s08.h>
 #include <linux/slab.h>
+#include <asm/byteorder.h>
 
+/**
+ * MCP types supported by driver
+ */
+#define MCP_TYPE_S08	0
+#define MCP_TYPE_S17	1
 
 /* Registers are all 8 bits wide.
  *
@@ -35,27 +41,38 @@
 #define MCP_GPIO	0x09
 #define MCP_OLAT	0x0a
 
+struct mcp23s08;
+
+struct mcp23s08_ops {
+	int	(*read)(struct mcp23s08 *mcp, unsigned reg);
+	int	(*write)(struct mcp23s08 *mcp, unsigned reg, unsigned val);
+	int	(*read_regs)(struct mcp23s08 *mcp, unsigned reg,
+			     u16 *vals, unsigned n);
+};
+
 struct mcp23s08 {
 	struct spi_device	*spi;
 	u8			addr;
 
-	u8			cache[11];
+	u16			cache[11];
 	/* lock protects the cached values */
 	struct mutex		lock;
 
 	struct gpio_chip	chip;
 
 	struct work_struct	work;
+
+	const struct mcp23s08_ops	*ops;
 };
 
-/* A given spi_device can represent up to four mcp23s08 chips
+/* A given spi_device can represent up to eight mcp23sxx chips
  * sharing the same chipselect but using different addresses
  * (e.g. chips #0 and #3 might be populated, but not #1 or $2).
  * Driver data holds all the per-chip data.
  */
 struct mcp23s08_driver_data {
 	unsigned		ngpio;
-	struct mcp23s08		*mcp[4];
+	struct mcp23s08		*mcp[8];
 	struct mcp23s08		chip[];
 };
 
@@ -70,7 +87,7 @@ static int mcp23s08_read(struct mcp23s08 *mcp, unsigned reg)
 	return (status < 0) ? status : rx[0];
 }
 
-static int mcp23s08_write(struct mcp23s08 *mcp, unsigned reg, u8 val)
+static int mcp23s08_write(struct mcp23s08 *mcp, unsigned reg, unsigned val)
 {
 	u8	tx[3];
 
@@ -81,17 +98,81 @@ static int mcp23s08_write(struct mcp23s08 *mcp, unsigned reg, u8 val)
 }
 
 static int
-mcp23s08_read_regs(struct mcp23s08 *mcp, unsigned reg, u8 *vals, unsigned n)
+mcp23s08_read_regs(struct mcp23s08 *mcp, unsigned reg, u16 *vals, unsigned n)
 {
-	u8	tx[2];
+	u8	tx[2], *tmp;
+	int	status;
 
 	if ((n + reg) > sizeof mcp->cache)
 		return -EINVAL;
 	tx[0] = mcp->addr | 0x01;
 	tx[1] = reg;
-	return spi_write_then_read(mcp->spi, tx, sizeof tx, vals, n);
+
+	tmp = (u8 *)vals;
+	status = spi_write_then_read(mcp->spi, tx, sizeof tx, tmp, n);
+	if (status >= 0) {
+		while (n--)
+			vals[n] = tmp[n]; /* expand to 16bit */
+	}
+	return status;
+}
+
+static int mcp23s17_read(struct mcp23s08 *mcp, unsigned reg)
+{
+	u8	tx[2], rx[2];
+	int	status;
+
+	tx[0] = mcp->addr | 0x01;
+	tx[1] = reg << 1;
+	status = spi_write_then_read(mcp->spi, tx, sizeof tx, rx, sizeof rx);
+	return (status < 0) ? status : (rx[0] | (rx[1] << 8));
+}
+
+static int mcp23s17_write(struct mcp23s08 *mcp, unsigned reg, unsigned val)
+{
+	u8	tx[4];
+
+	tx[0] = mcp->addr;
+	tx[1] = reg << 1;
+	tx[2] = val;
+	tx[3] = val >> 8;
+	return spi_write_then_read(mcp->spi, tx, sizeof tx, NULL, 0);
+}
+
+static int
+mcp23s17_read_regs(struct mcp23s08 *mcp, unsigned reg, u16 *vals, unsigned n)
+{
+	u8	tx[2];
+	int	status;
+
+	if ((n + reg) > sizeof mcp->cache)
+		return -EINVAL;
+	tx[0] = mcp->addr | 0x01;
+	tx[1] = reg << 1;
+
+	status = spi_write_then_read(mcp->spi, tx, sizeof tx,
+				     (u8 *)vals, n * 2);
+	if (status >= 0) {
+		while (n--)
+			vals[n] = __le16_to_cpu((__le16)vals[n]);
+	}
+
+	return status;
 }
 
+static const struct mcp23s08_ops mcp23s08_ops = {
+	.read		= mcp23s08_read,
+	.write		= mcp23s08_write,
+	.read_regs	= mcp23s08_read_regs,
+};
+
+static const struct mcp23s08_ops mcp23s17_ops = {
+	.read		= mcp23s17_read,
+	.write		= mcp23s17_write,
+	.read_regs	= mcp23s17_read_regs,
+};
+
+
 /*----------------------------------------------------------------------*/
 
 static int mcp23s08_direction_input(struct gpio_chip *chip, unsigned offset)
@@ -101,7 +182,7 @@ static int mcp23s08_direction_input(struct gpio_chip *chip, unsigned offset)
 
 	mutex_lock(&mcp->lock);
 	mcp->cache[MCP_IODIR] |= (1 << offset);
-	status = mcp23s08_write(mcp, MCP_IODIR, mcp->cache[MCP_IODIR]);
+	status = mcp->ops->write(mcp, MCP_IODIR, mcp->cache[MCP_IODIR]);
 	mutex_unlock(&mcp->lock);
 	return status;
 }
@@ -114,7 +195,7 @@ static int mcp23s08_get(struct gpio_chip *chip, unsigned offset)
 	mutex_lock(&mcp->lock);
 
 	/* REVISIT reading this clears any IRQ ... */
-	status = mcp23s08_read(mcp, MCP_GPIO);
+	status = mcp->ops->read(mcp, MCP_GPIO);
 	if (status < 0)
 		status = 0;
 	else {
@@ -127,20 +208,20 @@ static int mcp23s08_get(struct gpio_chip *chip, unsigned offset)
 
 static int __mcp23s08_set(struct mcp23s08 *mcp, unsigned mask, int value)
 {
-	u8 olat = mcp->cache[MCP_OLAT];
+	unsigned olat = mcp->cache[MCP_OLAT];
 
 	if (value)
 		olat |= mask;
 	else
 		olat &= ~mask;
 	mcp->cache[MCP_OLAT] = olat;
-	return mcp23s08_write(mcp, MCP_OLAT, olat);
+	return mcp->ops->write(mcp, MCP_OLAT, olat);
 }
 
 static void mcp23s08_set(struct gpio_chip *chip, unsigned offset, int value)
 {
 	struct mcp23s08	*mcp = container_of(chip, struct mcp23s08, chip);
-	u8 mask = 1 << offset;
+	unsigned mask = 1 << offset;
 
 	mutex_lock(&mcp->lock);
 	__mcp23s08_set(mcp, mask, value);
@@ -151,14 +232,14 @@ static int
 mcp23s08_direction_output(struct gpio_chip *chip, unsigned offset, int value)
 {
 	struct mcp23s08	*mcp = container_of(chip, struct mcp23s08, chip);
-	u8 mask = 1 << offset;
+	unsigned mask = 1 << offset;
 	int status;
 
 	mutex_lock(&mcp->lock);
 	status = __mcp23s08_set(mcp, mask, value);
 	if (status == 0) {
 		mcp->cache[MCP_IODIR] &= ~mask;
-		status = mcp23s08_write(mcp, MCP_IODIR, mcp->cache[MCP_IODIR]);
+		status = mcp->ops->write(mcp, MCP_IODIR, mcp->cache[MCP_IODIR]);
 	}
 	mutex_unlock(&mcp->lock);
 	return status;
@@ -184,16 +265,16 @@ static void mcp23s08_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 	mcp = container_of(chip, struct mcp23s08, chip);
 
 	/* NOTE: we only handle one bank for now ... */
-	bank = '0' + ((mcp->addr >> 1) & 0x3);
+	bank = '0' + ((mcp->addr >> 1) & 0x7);
 
 	mutex_lock(&mcp->lock);
-	t = mcp23s08_read_regs(mcp, 0, mcp->cache, sizeof mcp->cache);
+	t = mcp->ops->read_regs(mcp, 0, mcp->cache, ARRAY_SIZE(mcp->cache));
 	if (t < 0) {
 		seq_printf(s, " I/O ERROR %d\n", t);
 		goto done;
 	}
 
-	for (t = 0, mask = 1; t < 8; t++, mask <<= 1) {
+	for (t = 0, mask = 1; t < chip->ngpio; t++, mask <<= 1) {
 		const char	*label;
 
 		label = gpiochip_is_requested(chip, t);
@@ -219,28 +300,33 @@ done:
 /*----------------------------------------------------------------------*/
 
 static int mcp23s08_probe_one(struct spi_device *spi, unsigned addr,
-		unsigned base, unsigned pullups)
+			      unsigned type, unsigned base, unsigned pullups)
 {
 	struct mcp23s08_driver_data	*data = spi_get_drvdata(spi);
 	struct mcp23s08			*mcp = data->mcp[addr];
 	int				status;
-	int				do_update = 0;
 
 	mutex_init(&mcp->lock);
 
 	mcp->spi = spi;
 	mcp->addr = 0x40 | (addr << 1);
 
-	mcp->chip.label = "mcp23s08",
-
 	mcp->chip.direction_input = mcp23s08_direction_input;
 	mcp->chip.get = mcp23s08_get;
 	mcp->chip.direction_output = mcp23s08_direction_output;
 	mcp->chip.set = mcp23s08_set;
 	mcp->chip.dbg_show = mcp23s08_dbg_show;
 
+	if (type == MCP_TYPE_S17) {
+		mcp->ops = &mcp23s17_ops;
+		mcp->chip.ngpio = 16;
+		mcp->chip.label = "mcp23s17";
+	} else {
+		mcp->ops = &mcp23s08_ops;
+		mcp->chip.ngpio = 8;
+		mcp->chip.label = "mcp23s08";
+	}
 	mcp->chip.base = base;
-	mcp->chip.ngpio = 8;
 	mcp->chip.can_sleep = 1;
 	mcp->chip.dev = &spi->dev;
 	mcp->chip.owner = THIS_MODULE;
@@ -248,45 +334,39 @@ static int mcp23s08_probe_one(struct spi_device *spi, unsigned addr,
 	/* verify MCP_IOCON.SEQOP = 0, so sequential reads work,
 	 * and MCP_IOCON.HAEN = 1, so we work with all chips.
 	 */
-	status = mcp23s08_read(mcp, MCP_IOCON);
+	status = mcp->ops->read(mcp, MCP_IOCON);
 	if (status < 0)
 		goto fail;
 	if ((status & IOCON_SEQOP) || !(status & IOCON_HAEN)) {
-		status &= ~IOCON_SEQOP;
-		status |= IOCON_HAEN;
-		status = mcp23s08_write(mcp, MCP_IOCON, (u8) status);
+		/* mcp23s17 has IOCON twice, make sure they are in sync */
+		status &= ~(IOCON_SEQOP | (IOCON_SEQOP << 8));
+		status |= IOCON_HAEN | (IOCON_HAEN << 8);
+		status = mcp->ops->write(mcp, MCP_IOCON, status);
 		if (status < 0)
 			goto fail;
 	}
 
 	/* configure ~100K pullups */
-	status = mcp23s08_write(mcp, MCP_GPPU, pullups);
+	status = mcp->ops->write(mcp, MCP_GPPU, pullups);
 	if (status < 0)
 		goto fail;
 
-	status = mcp23s08_read_regs(mcp, 0, mcp->cache, sizeof mcp->cache);
+	status = mcp->ops->read_regs(mcp, 0, mcp->cache, ARRAY_SIZE(mcp->cache));
 	if (status < 0)
 		goto fail;
 
 	/* disable inverter on input */
 	if (mcp->cache[MCP_IPOL] != 0) {
 		mcp->cache[MCP_IPOL] = 0;
-		do_update = 1;
+		status = mcp->ops->write(mcp, MCP_IPOL, 0);
+		if (status < 0)
+			goto fail;
 	}
 
 	/* disable irqs */
 	if (mcp->cache[MCP_GPINTEN] != 0) {
 		mcp->cache[MCP_GPINTEN] = 0;
-		do_update = 1;
-	}
-
-	if (do_update) {
-		u8 tx[4];
-
-		tx[0] = mcp->addr;
-		tx[1] = MCP_IPOL;
-		memcpy(&tx[2], &mcp->cache[MCP_IPOL], sizeof(tx) - 2);
-		status = spi_write_then_read(mcp->spi, tx, sizeof tx, NULL, 0);
+		status = mcp->ops->write(mcp, MCP_GPINTEN, 0);
 		if (status < 0)
 			goto fail;
 	}
@@ -305,19 +385,26 @@ static int mcp23s08_probe(struct spi_device *spi)
 	unsigned			addr;
 	unsigned			chips = 0;
 	struct mcp23s08_driver_data	*data;
-	int				status;
+	int				status, type;
 	unsigned			base;
 
+	type = spi_get_device_id(spi)->driver_data;
+
 	pdata = spi->dev.platform_data;
 	if (!pdata || !gpio_is_valid(pdata->base)) {
 		dev_dbg(&spi->dev, "invalid or missing platform data\n");
 		return -EINVAL;
 	}
 
-	for (addr = 0; addr < 4; addr++) {
+	for (addr = 0; addr < ARRAY_SIZE(pdata->chip); addr++) {
 		if (!pdata->chip[addr].is_present)
 			continue;
 		chips++;
+		if ((type == MCP_TYPE_S08) && (addr > 3)) {
+			dev_err(&spi->dev,
+				"mcp23s08 only supports address 0..3\n");
+			return -EINVAL;
+		}
 	}
 	if (!chips)
 		return -ENODEV;
@@ -329,16 +416,17 @@ static int mcp23s08_probe(struct spi_device *spi)
 	spi_set_drvdata(spi, data);
 
 	base = pdata->base;
-	for (addr = 0; addr < 4; addr++) {
+	for (addr = 0; addr < ARRAY_SIZE(pdata->chip); addr++) {
 		if (!pdata->chip[addr].is_present)
 			continue;
 		chips--;
 		data->mcp[addr] = &data->chip[chips];
-		status = mcp23s08_probe_one(spi, addr, base,
-				pdata->chip[addr].pullups);
+		status = mcp23s08_probe_one(spi, addr, type, base,
+					    pdata->chip[addr].pullups);
 		if (status < 0)
 			goto fail;
-		base += 8;
+
+		base += (type == MCP_TYPE_S17) ? 16 : 8;
 	}
 	data->ngpio = base - pdata->base;
 
@@ -358,7 +446,7 @@ static int mcp23s08_probe(struct spi_device *spi)
 	return 0;
 
 fail:
-	for (addr = 0; addr < 4; addr++) {
+	for (addr = 0; addr < ARRAY_SIZE(data->mcp); addr++) {
 		int tmp;
 
 		if (!data->mcp[addr])
@@ -388,7 +476,7 @@ static int mcp23s08_remove(struct spi_device *spi)
 		}
 	}
 
-	for (addr = 0; addr < 4; addr++) {
+	for (addr = 0; addr < ARRAY_SIZE(data->mcp); addr++) {
 		int tmp;
 
 		if (!data->mcp[addr])
@@ -405,9 +493,17 @@ static int mcp23s08_remove(struct spi_device *spi)
 	return status;
 }
 
+static const struct spi_device_id mcp23s08_ids[] = {
+	{ "mcp23s08", MCP_TYPE_S08 },
+	{ "mcp23s17", MCP_TYPE_S17 },
+	{ },
+};
+MODULE_DEVICE_TABLE(spi, mcp23s08_ids);
+
 static struct spi_driver mcp23s08_driver = {
 	.probe		= mcp23s08_probe,
 	.remove		= mcp23s08_remove,
+	.id_table	= mcp23s08_ids,
 	.driver = {
 		.name	= "mcp23s08",
 		.owner	= THIS_MODULE,
@@ -432,4 +528,3 @@ static void __exit mcp23s08_exit(void)
 module_exit(mcp23s08_exit);
 
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("spi:mcp23s08");
diff --git a/include/linux/spi/mcp23s08.h b/include/linux/spi/mcp23s08.h
index 22ef107..c42cff8 100644
--- a/include/linux/spi/mcp23s08.h
+++ b/include/linux/spi/mcp23s08.h
@@ -2,21 +2,24 @@
 /* FIXME driver should be able to handle IRQs...  */
 
 struct mcp23s08_chip_info {
-	bool	is_present;		/* true iff populated */
-	u8	pullups;		/* BIT(x) means enable pullup x */
+	bool		is_present;	/* true if populated */
+	unsigned	pullups;	/* BIT(x) means enable pullup x */
 };
 
 struct mcp23s08_platform_data {
-	/* Four slaves (numbered 0..3) can share one SPI chipselect, and
-	 * will provide 8..32 GPIOs using 1..4 gpio_chip instances.
+	/* For mcp23s08, up to 4 slaves (numbered 0..3) can share one SPI
+	 * chipselect, each providing 1 gpio_chip instance with 8 gpios.
+	 * For mpc23s17, up to 8 slaves (numbered 0..7) can share one SPI
+	 * chipselect, each providing 1 gpio_chip (port A + port B) with
+	 * 16 gpios.
 	 */
-	struct mcp23s08_chip_info	chip[4];
+	struct mcp23s08_chip_info	chip[8];
 
 	/* "base" is the number of the first GPIO.  Dynamic assignment is
 	 * not currently supported, and even if there are gaps in chip
 	 * addressing the GPIO numbers are sequential .. so for example
 	 * if only slaves 0 and 3 are present, their GPIOs range from
-	 * base to base+15.
+	 * base to base+15 (or base+31 for s17 variant).
 	 */
 	unsigned	base;
 
-- 
1.7.2.3

