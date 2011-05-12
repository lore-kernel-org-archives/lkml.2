Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569Ab1ELSQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 14:16:41 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65358 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932540Ab1ELSQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 14:16:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=GzcUZFo3PpNB5kPek3lbgyD+vpUmMJzrO9G3bkUnd03qcUztm/UJavheWeCNq1Yj4w
         gC4m+QaOO9jUsWMENixsNeMd5QKQAasYobxC2hWJTmD8UIeeFg74tUKCqE5VNzsb3XJj
         XGuMv+yYmCJ7nCZSBWNpkoADvIsk18FN//Y4s=
From: Igor Plyatov <plyatov@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <tj@kernel.org>,
        linux-ide@vger.kernel.org, Stanislaw Gruszka <stf_xl@wp.pl>
Cc: linux-kernel@vger.kernel.org, Igor Plyatov <plyatov@gmail.com>
Subject: [PATCH] pata_at91: SMC settings calculation bugfixes, support for t6z and IORDY
Date: Thu, 12 May 2011 22:15:51 +0400
Message-Id: <1305224151-11557-1-git-send-email-plyatov@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* New code correctly calculates SMC registers values, adjusts calculated
  to admissible ranges, enlarges cycles when required and converts values
  into SMC's format.
* Support for TDF cycles (ATA t6z) and IORDY line added.
* Eliminate need in the initial_timing structure.
* Code cleanup.

Signed-off-by: Igor Plyatov <plyatov@gmail.com>
---
 drivers/ata/pata_at91.c |  297 +++++++++++++++++++++++++++++++----------------
 1 files changed, 198 insertions(+), 99 deletions(-)

diff --git a/drivers/ata/pata_at91.c b/drivers/ata/pata_at91.c
index a5fdbdc..960c725 100644
--- a/drivers/ata/pata_at91.c
+++ b/drivers/ata/pata_at91.c
@@ -3,6 +3,7 @@
  * with CompactFlash interface in True IDE mode
  *
  * Copyright (C) 2009 Matyukevich Sergey
+ *               2011 Igor Plyatov
  *
  * Based on:
  *      * generic platform driver by Paul Mundt: drivers/ata/pata_platform.c
@@ -31,38 +32,150 @@
 #include <mach/board.h>
 #include <mach/gpio.h>
 
+#define DRV_NAME		"pata_at91"
+#define DRV_VERSION		"0.3"
 
-#define DRV_NAME "pata_at91"
-#define DRV_VERSION "0.2"
-
-#define CF_IDE_OFFSET	    0x00c00000
-#define CF_ALT_IDE_OFFSET   0x00e00000
-#define CF_IDE_RES_SIZE     0x08
-#define NCS_RD_PULSE_LIMIT  0x3f /* maximal value for pulse bitfields */
+#define CF_IDE_OFFSET		0x00c00000
+#define CF_ALT_IDE_OFFSET	0x00e00000
+#define CF_IDE_RES_SIZE		0x08
+#define CS_PULSE_MAXIMUM	319
+#define ER_SMC_CALC		1
+#define ER_SMC_RECALC		2
 
 struct at91_ide_info {
 	unsigned long mode;
 	unsigned int cs;
-
 	struct clk *mck;
-
 	void __iomem *ide_addr;
 	void __iomem *alt_addr;
 };
 
-static const struct ata_timing initial_timing = {
-	.mode		= XFER_PIO_0,
-	.setup		= 70,
-	.act8b		= 290,
-	.rec8b		= 240,
-	.cyc8b		= 600,
-	.active		= 165,
-	.recover	= 150,
-	.dmack_hold	= 0,
-	.cycle		= 600,
-	.udma		= 0
+/**
+ * struct smc_range - range of valid values for SMC register.
+ */
+struct smc_range {
+	int min;
+	int max;
 };
 
+/**
+ * adjust_smc_value - adjust value for one of SMC registers.
+ * @value: adjusted value
+ * @range: array of SMC ranges with valid values
+ * @size: SMC ranges array size
+ *
+ * This returns the difference between input and output value or negative
+ * in case of invalid input value.
+ * If negative returned, then output value = maximal possible from ranges.
+ */
+static int adjust_smc_value(int *value, struct smc_range *range, int size)
+{
+	int maximum = (range + size - 1)->max;
+	int remainder;
+
+	do {
+		if (*value < range->min) {
+			remainder = range->min - *value;
+			*value = range->min; /* nearest valid value */
+			return remainder;
+		} else if ((range->min <= *value) && (*value <= range->max))
+			return 0;
+
+		range++;
+	} while (--size);
+	*value = maximum;
+
+	return -1; /* invalid value */
+}
+
+/**
+ * calc_smc_vals - calculate SMC register values
+ * @dev: ATA device
+ * @setup: SMC_SETUP register value
+ * @pulse: SMC_PULSE register value
+ * @cycle: SMC_CYCLE register value
+ *
+ * This returns negative in case of invalid values for SMC registers:
+ * -ER_SMC_RECALC - recalculation required for SMC values,
+ * -ER_SMC_CALC - calculation failed (invalid input values).
+ *
+ * SMC use special coding scheme, see "Coding and Range of Timing
+ * Parameters" table from AT91SAM9 datasheets.
+ *
+ *	SMC_SETUP = 128*setup[5] + setup[4:0]
+ *	SMC_PULSE = 256*pulse[6] + pulse[5:0]
+ *	SMC_CYCLE = 256*cycle[8:7] + cycle[6:0]
+ */
+static int calc_smc_vals(struct device *dev,
+		int *setup, int *pulse, int *cycle, int *cs_pulse)
+{
+	int ret_val;
+	int err = 0;
+	struct smc_range range_setup[] = {	/* SMC_SETUP valid values */
+		{.min = 0,	.max = 31},	/* first  range */
+		{.min = 128,	.max = 159}	/* second range */
+	};
+	struct smc_range range_pulse[] = {	/* SMC_PULSE valid values */
+		{.min = 0,	.max = 63},	/* first  range */
+		{.min = 256,	.max = 319}	/* second range */
+	};
+	struct smc_range range_cycle[] = {	/* SMC_CYCLE valid values */
+		{.min = 0,	.max = 127},	/* first  range */
+		{.min = 256,	.max = 383},	/* second range */
+		{.min = 512,	.max = 639},	/* third  range */
+		{.min = 768,	.max = 895}	/* fourth range */
+	};
+
+	ret_val = adjust_smc_value(setup, range_setup, ARRAY_SIZE(range_setup));
+	if (ret_val < 0)
+		dev_warn(dev, "maximal SMC Setup value\n");
+	else
+		*cycle += ret_val;
+
+	ret_val = adjust_smc_value(pulse, range_pulse, ARRAY_SIZE(range_pulse));
+	if (ret_val < 0)
+		dev_warn(dev, "maximal SMC Pulse value\n");
+	else
+		*cycle += ret_val;
+
+	ret_val = adjust_smc_value(cycle, range_cycle, ARRAY_SIZE(range_cycle));
+	if (ret_val < 0)
+		dev_warn(dev, "maximal SMC Cycle value\n");
+
+	*cs_pulse = *cycle;
+	if (*cs_pulse > CS_PULSE_MAXIMUM) {
+		dev_err(dev, "unable to calculate valid SMC settings\n");
+		return -ER_SMC_CALC;
+	}
+
+	ret_val = adjust_smc_value(cs_pulse, range_pulse,
+					ARRAY_SIZE(range_pulse));
+	if (ret_val < 0) {
+		dev_warn(dev, "maximal SMC CS Pulse value\n");
+	} else if (ret_val != 0) {
+		*cycle = *cs_pulse;
+		dev_warn(dev, "SMC Cycle extended\n");
+		err = -ER_SMC_RECALC;
+	}
+
+	return err;
+}
+
+/**
+ * to_smc_format - convert values into SMC format
+ * @setup: SETUP value of SMC Setup Register
+ * @pulse: PULSE value of SMC Pulse Register
+ * @cycle: CYCLE value of SMC Cycle Register
+ * @cs_pulse: NCS_PULSE value of SMC Pulse Register
+ */
+static void to_smc_format(int *setup, int *pulse, int *cycle, int *cs_pulse)
+{
+	*setup = (*setup & 0x1f) | ((*setup & 0x80) >> 2);
+	*pulse = (*pulse & 0x3f) | ((*pulse & 0x100) >> 2);
+	*cycle = (*cycle & 0x7f) | ((*cycle & 0x300) >> 1);
+	*cs_pulse = (*cs_pulse & 0x3f) | ((*cs_pulse & 0x100) >> 2);
+}
+
 static unsigned long calc_mck_cycles(unsigned long ns, unsigned long mck_hz)
 {
 	unsigned long mul;
@@ -80,85 +193,77 @@ static unsigned long calc_mck_cycles(unsigned long ns, unsigned long mck_hz)
 	return (ns * mul + 65536) >> 16;    /* rounding */
 }
 
-static void set_smc_mode(struct at91_ide_info *info)
-{
-	at91_sys_write(AT91_SMC_MODE(info->cs), info->mode);
-	return;
-}
-
-static void set_smc_timing(struct device *dev,
+/**
+ * set_smc_timing - SMC timings setup.
+ * @dev: device
+ * @info: AT91 IDE info
+ * @ata: ATA timings
+ *
+ * Its assumed that write timings are same as read timings,
+ * cs_setup = 0 and cs_pulse = cycle.
+ */
+static void set_smc_timing(struct device *dev, struct ata_device *adev,
 		struct at91_ide_info *info, const struct ata_timing *ata)
 {
-	unsigned long read_cycle, write_cycle, active, recover;
-	unsigned long nrd_setup, nrd_pulse, nrd_recover;
-	unsigned long nwe_setup, nwe_pulse;
-
-	unsigned long ncs_write_setup, ncs_write_pulse;
-	unsigned long ncs_read_setup, ncs_read_pulse;
-
-	unsigned long mck_hz;
-
-	read_cycle  = ata->cyc8b;
-	nrd_setup   = ata->setup;
-	nrd_pulse   = ata->act8b;
-	nrd_recover = ata->rec8b;
-
+	int ret = 0;
+	int use_iordy;
+	unsigned int t6z;         /* data tristate time in ns */
+	unsigned int cycle;       /* SMC Cycle width in MCK ticks */
+	unsigned int setup;       /* SMC Setup width in MCK ticks */
+	unsigned int pulse;       /* CFIOR and CFIOW pulse width in MCK ticks */
+	unsigned int cs_setup = 0;/* CS4 or CS5 setup width in MCK ticks */
+	unsigned int cs_pulse;    /* CS4 or CS5 pulse width in MCK ticks*/
+	unsigned int tdf_cycles;  /* SMC TDF MCK ticks */
+	unsigned long mck_hz;     /* MCK frequency in Hz */
+
+	t6z = (ata->mode < XFER_PIO_5) ? 30 : 20;
 	mck_hz = clk_get_rate(info->mck);
-
-	read_cycle  = calc_mck_cycles(read_cycle, mck_hz);
-	nrd_setup   = calc_mck_cycles(nrd_setup, mck_hz);
-	nrd_pulse   = calc_mck_cycles(nrd_pulse, mck_hz);
-	nrd_recover = calc_mck_cycles(nrd_recover, mck_hz);
-
-	active  = nrd_setup + nrd_pulse;
-	recover = read_cycle - active;
-
-	/* Need at least two cycles recovery */
-	if (recover < 2)
-		read_cycle = active + 2;
-
-	/* (CS0, CS1, DIR, OE) <= (CFCE1, CFCE2, CFRNW, NCSX) timings */
-	ncs_read_setup = 1;
-	ncs_read_pulse = read_cycle - 2;
-	if (ncs_read_pulse > NCS_RD_PULSE_LIMIT) {
-		ncs_read_pulse = NCS_RD_PULSE_LIMIT;
-		dev_warn(dev, "ncs_read_pulse limited to maximal value %lu\n",
-			ncs_read_pulse);
+	cycle = calc_mck_cycles(ata->cyc8b, mck_hz);
+	setup = calc_mck_cycles(ata->setup, mck_hz);
+	pulse = calc_mck_cycles(ata->act8b, mck_hz);
+	tdf_cycles = calc_mck_cycles(t6z, mck_hz);
+
+	do {
+		ret = calc_smc_vals(dev, &setup, &pulse, &cycle, &cs_pulse);
+	} while (ret == -ER_SMC_RECALC);
+
+	if (ret == -ER_SMC_CALC)
+		dev_err(dev, "Interface may not operate correctly\n");
+
+	dev_dbg(dev, "SMC Setup=%u, Pulse=%u, Cycle=%u, CS Pulse=%u\n",
+		setup, pulse, cycle, cs_pulse);
+	to_smc_format(&setup, &pulse, &cycle, &cs_pulse);
+	/* disable or enable waiting for IORDY signal */
+	use_iordy = ata_pio_need_iordy(adev);
+	if (use_iordy)
+		info->mode |= AT91_SMC_EXNWMODE_READY;
+
+	if (tdf_cycles > 15) {
+		tdf_cycles = 15;
+		dev_warn(dev, "maximal SMC TDF Cycles value\n");
 	}
 
-	/* Write timings same as read timings */
-	write_cycle = read_cycle;
-	nwe_setup = nrd_setup;
-	nwe_pulse = nrd_pulse;
-	ncs_write_setup = ncs_read_setup;
-	ncs_write_pulse = ncs_read_pulse;
-
-	dev_dbg(dev, "ATA timings: nrd_setup = %lu nrd_pulse = %lu nrd_cycle = %lu\n",
-			nrd_setup, nrd_pulse, read_cycle);
-	dev_dbg(dev, "ATA timings: nwe_setup = %lu nwe_pulse = %lu nwe_cycle = %lu\n",
-			nwe_setup, nwe_pulse, write_cycle);
-	dev_dbg(dev, "ATA timings: ncs_read_setup = %lu ncs_read_pulse = %lu\n",
-			ncs_read_setup, ncs_read_pulse);
-	dev_dbg(dev, "ATA timings: ncs_write_setup = %lu ncs_write_pulse = %lu\n",
-			ncs_write_setup, ncs_write_pulse);
+	dev_dbg(dev, "Use IORDY=%u, TDF Cycles=%u\n", use_iordy, tdf_cycles);
+	info->mode |= AT91_SMC_TDF_(tdf_cycles);
 
+	/* write SMC Setup Register */
 	at91_sys_write(AT91_SMC_SETUP(info->cs),
-			AT91_SMC_NWESETUP_(nwe_setup) |
-			AT91_SMC_NRDSETUP_(nrd_setup) |
-			AT91_SMC_NCS_WRSETUP_(ncs_write_setup) |
-			AT91_SMC_NCS_RDSETUP_(ncs_read_setup));
-
+			AT91_SMC_NWESETUP_(setup) |
+			AT91_SMC_NRDSETUP_(setup) |
+			AT91_SMC_NCS_WRSETUP_(cs_setup) |
+			AT91_SMC_NCS_RDSETUP_(cs_setup));
+	/* write SMC Pulse Register */
 	at91_sys_write(AT91_SMC_PULSE(info->cs),
-			AT91_SMC_NWEPULSE_(nwe_pulse) |
-			AT91_SMC_NRDPULSE_(nrd_pulse) |
-			AT91_SMC_NCS_WRPULSE_(ncs_write_pulse) |
-			AT91_SMC_NCS_RDPULSE_(ncs_read_pulse));
-
+			AT91_SMC_NWEPULSE_(pulse) |
+			AT91_SMC_NRDPULSE_(pulse) |
+			AT91_SMC_NCS_WRPULSE_(cs_pulse) |
+			AT91_SMC_NCS_RDPULSE_(cs_pulse));
+	/* write SMC Cycle Register */
 	at91_sys_write(AT91_SMC_CYCLE(info->cs),
-			AT91_SMC_NWECYCLE_(write_cycle) |
-			AT91_SMC_NRDCYCLE_(read_cycle));
-
-	return;
+			AT91_SMC_NWECYCLE_(cycle) |
+			AT91_SMC_NRDCYCLE_(cycle));
+	/* write SMC Mode Register*/
+	at91_sys_write(AT91_SMC_MODE(info->cs), info->mode);
 }
 
 static void pata_at91_set_piomode(struct ata_port *ap, struct ata_device *adev)
@@ -172,15 +277,9 @@ static void pata_at91_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	if (ret) {
 		dev_warn(ap->dev, "Failed to compute ATA timing %d, "
 			 "set PIO_0 timing\n", ret);
-		set_smc_timing(ap->dev, info, &initial_timing);
-	} else {
-		set_smc_timing(ap->dev, info, &timing);
+		timing = *ata_timing_find_mode(XFER_PIO_0);
 	}
-
-	/* Setup SMC mode */
-	set_smc_mode(info);
-
-	return;
+	set_smc_timing(ap->dev, adev, info, &timing);
 }
 
 static unsigned int pata_at91_data_xfer_noirq(struct ata_device *dev,
@@ -346,7 +445,7 @@ static int __devexit pata_at91_remove(struct platform_device *pdev)
 static struct platform_driver pata_at91_driver = {
 	.probe		= pata_at91_probe,
 	.remove		= __devexit_p(pata_at91_remove),
-	.driver 	= {
+	.driver		= {
 		.name		= DRV_NAME,
 		.owner		= THIS_MODULE,
 	},
-- 
1.7.1

