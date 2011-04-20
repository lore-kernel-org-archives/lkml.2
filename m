Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab1DTLpF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 07:45:05 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35699 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab1DTLpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 07:45:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=tnPYzfwxDA5f6A8MSkDWOqmB7mHxDgJ5m0W8mAWxQvL8xORwheu5lC9Wjnn6+TKx2I
         QjiTwUuGLdYY72XCeUErajJJHDJe15TvtfuReNlPQvZqsaqig7ZfE3D88eIw0jZB0UiZ
         e6rYQtZrrheSf8Jgb4oU8LF4qM3VYuiW29f8w=
From: Igor Plyatov <plyatov@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: stf_xl@wp.pl, Igor Plyatov <plyatov@gmail.com>
Subject: [PATCH] ATA: pata_at91.c bugfixes
Date: Wed, 20 Apr 2011 15:44:37 +0400
Message-Id: <1303299877-12088-1-git-send-email-plyatov@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Fix "initial_timing" structure initialisation. The "struct ata_timing" must
  contain 10 members, but ".dmack_hold" member was not initialised.
* The AT91SAM9 microcontrollers use special coding scheme for SMC_SETUP,
  SMC_PULSE, SMC_CYCLE registers.
  Old driver operates correctly only with low master clock values, but
  with high master clock it incorrectly calculates SMC values and stops
  to operate, because SMC can be setup only to admissible ranges in special
  format.
  New code correctly calculates SMC registers values, adjusts calculated
  to admissible ranges, enlarges cycles if required and converts values
  into SMC's format.
* Old driver calculates CS_SETUP and CS_PULSE cycles incorrectly
  because of wrong assumptions.
  New code calculates:
      CS_SETUP = SETUP/2
      CS_PULSE = PULSE + SETUP/2 + HOLD/2
* This fixes allows to correctly operate with any master clock frequency.

Signed-off-by: Igor Plyatov <plyatov@gmail.com>
---
 drivers/ata/pata_at91.c |  223 ++++++++++++++++++++++++++++++++---------------
 1 files changed, 154 insertions(+), 69 deletions(-)

diff --git a/drivers/ata/pata_at91.c b/drivers/ata/pata_at91.c
index 0da0dcc..b18249e 100644
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
@@ -31,26 +32,140 @@
 #include <mach/board.h>
 #include <mach/gpio.h>
 
+#define DRV_NAME		"pata_at91"
+#define DRV_VERSION		"0.2"
 
-#define DRV_NAME "pata_at91"
-#define DRV_VERSION "0.1"
-
-#define CF_IDE_OFFSET	    0x00c00000
-#define CF_ALT_IDE_OFFSET   0x00e00000
-#define CF_IDE_RES_SIZE     0x08
+#define CF_IDE_OFFSET		0x00c00000
+#define CF_ALT_IDE_OFFSET	0x00e00000
+#define CF_IDE_RES_SIZE		0x08
 
 struct at91_ide_info {
 	unsigned long mode;
 	unsigned int cs;
-
 	struct clk *mck;
-
 	void __iomem *ide_addr;
 	void __iomem *alt_addr;
 };
 
-static const struct ata_timing initial_timing =
-	{XFER_PIO_0, 70, 290, 240, 600, 165, 150, 600, 0};
+static const struct ata_timing initial_timing = {
+	.mode		= XFER_PIO_0,
+	.setup		= 70,
+	.act8b		= 290,
+	.rec8b		= 240,
+	.cyc8b		= 600,
+	.active		= 165,
+	.recover	= 150,
+	.dmack_hold	= 0,
+	.cycle		= 600,
+	.udma		= 0
+};
+
+/*
+ * Adjust value for one of SMC_SETUP, SMC_PULSE or SMC_CYCLE registers.
+ * Returns:
+ *		difference between input and output value or
+ *		negative value in case of invalid input value.
+ */
+static int adjust_smc_value(unsigned int *value, int *prange,
+				unsigned int size)
+{
+	unsigned char i;
+	int remainder;
+
+	for (i = 0; i < size; i = i + 2) {
+		if (*value < prange[i]) {
+			remainder = prange[i] - *value;
+			*value = prange[i]; /* nearest valid value */
+			return remainder;
+		}
+		else if ((prange[i] <= *value) && (*value <= prange[i+1])) {
+			return 0;
+		}
+	}
+	*value = prange[size - 1]; /* assign maximal possible value */
+
+	return -1; /* invalid value */
+}
+
+/*
+ * Calculate SMC_SETUP, SMC_PULSE, SMC_CYCLE register values.
+ *
+ * SMC use special coding scheme, see "Coding and Range of Timing
+ * Parameters" table from AT91SAM926x datasheets.
+ *
+ *	SETUP = 128*setup[5] + setup[4:0]
+ *	PULSE = 256*pulse[6] + pulse[5:0]
+ *	CYCLE = 256*cycle[8:7] + cycle[6:0]
+ *
+ *	cs_setup = setup/2
+ *	cs_pulse = pulse + setup/2 + hold/2
+ */
+static void calc_smc_vals(struct device *dev,
+				unsigned int *setup, unsigned int *cs_setup,
+				unsigned int *pulse, unsigned int *cs_pulse,
+				unsigned int *cycle)
+{
+	int ret_val;
+	int cs_hold;
+	int range_setup[] = {	/* SMC_SETUP valid ranges */
+		0, 31,		/* first  range */
+		128, 159,	/* second range */
+	};
+	int range_pulse[] = {	/* SMC_PULSE valid ranges */
+		0, 63,		/* first  range */
+		256, 319,	/* second range */
+	};
+	int range_cycle[] = {	/* SMC_CYCLE valid ranges */
+		0, 127,		/* first  range */
+		256, 383,	/* second range */
+		512, 639,	/* third  range */
+		768, 895,	/* fourth range */
+	};
+
+	ret_val = adjust_smc_value(setup, range_setup, sizeof(range_setup));
+	if (ret_val < 0)
+		dev_warn(dev, "maximal setup value\n");
+	else
+		*cycle += ret_val;
+
+	ret_val = adjust_smc_value(pulse, range_pulse, sizeof(range_pulse));
+	if (ret_val < 0)
+		dev_warn(dev, "maximal pulse value\n");
+	else
+		*cycle += ret_val;
+
+	ret_val = adjust_smc_value(cycle, range_cycle, sizeof(range_cycle));
+	if (ret_val < 0)
+		dev_warn(dev, "maximal cycle value\n");
+
+	*cs_setup = *setup / 2;
+	ret_val = adjust_smc_value(cs_setup, range_setup, sizeof(range_setup));
+	if (ret_val < 0)
+		dev_warn(dev, "maximal cs_setup value\n");
+
+	if (*cs_setup >= *setup) {
+		dev_warn(dev, "cs_setup value >= setup\n");
+		*cs_pulse = *pulse;
+	} else {
+		if ((*cs_setup == 0) && (*setup == 1))
+			*cs_setup = 1;
+
+		/* transformed pulse + setup/2 + hold/2 */
+		*cs_pulse = (*pulse + *cycle)/2;
+		ret_val = adjust_smc_value(cs_pulse, range_pulse,
+						sizeof(range_pulse));
+		if (ret_val < 0)
+			dev_warn(dev, "maximal cs_pulse value\n");
+		else if (ret_val > 0) {
+			cs_hold = *cycle - *cs_setup - *cs_pulse;
+			if (cs_hold < ret_val)
+				dev_warn(dev, "unable setup correct cs_pulse\n");
+		}
+	}
+
+	dev_dbg(dev, "setup=%u, cs_setup=%u, pulse=%u, cs_pulse=%u, cycle=%u\n",
+		*setup, *cs_setup, *pulse, *cs_pulse, *cycle);
+}
 
 static unsigned long calc_mck_cycles(unsigned long ns, unsigned long mck_hz)
 {
@@ -78,71 +193,43 @@ static void set_smc_mode(struct at91_ide_info *info)
 static void set_smc_timing(struct device *dev,
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
+	unsigned int cycle;       /* ATA cycle width in MCK ticks */
+	unsigned int setup;       /* setup width in MCK ticks */
+	unsigned int pulse;       /* CFIOR and CFIOW pulse width in MCK ticks */
+	unsigned int cs_setup = 0;/* CS4 or CS5 setup width in MCK ticks */
+	unsigned int cs_pulse = 0;/* CS4 or CS5 pulse width in MCK ticks*/
+	unsigned long mck_hz;     /* MCK frequency in Hz */
 
 	mck_hz = clk_get_rate(info->mck);
+	cycle = calc_mck_cycles(ata->cyc8b, mck_hz);
+	setup = calc_mck_cycles(ata->setup, mck_hz);
+	pulse = calc_mck_cycles(ata->act8b, mck_hz);
 
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
-
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
+	calc_smc_vals(dev, &setup, &cs_setup, &pulse, &cs_pulse, &cycle);
 
+	/* Convert values into SMC format */
+	setup = (setup & 0x1f) | ((setup & 0x80) >> 2);
+	pulse = (pulse & 0x3f) | ((pulse & 0x100) >> 2);
+	cycle = (cycle & 0x7f) | ((cycle & 0x300) >> 1);
+	cs_setup = (cs_setup & 0x1f) | ((cs_setup & 0x80) >> 2);
+	cs_pulse = (cs_pulse & 0x3f) | ((cs_pulse & 0x100) >> 2);
+
+	/* SMC setup. Write timings are same as read timings */
 	at91_sys_write(AT91_SMC_SETUP(info->cs),
-			AT91_SMC_NWESETUP_(nwe_setup) |
-			AT91_SMC_NRDSETUP_(nrd_setup) |
-			AT91_SMC_NCS_WRSETUP_(ncs_write_setup) |
-			AT91_SMC_NCS_RDSETUP_(ncs_read_setup));
+			AT91_SMC_NWESETUP_(setup) |
+			AT91_SMC_NRDSETUP_(setup) |
+			AT91_SMC_NCS_WRSETUP_(cs_setup) |
+			AT91_SMC_NCS_RDSETUP_(cs_setup));
 
 	at91_sys_write(AT91_SMC_PULSE(info->cs),
-			AT91_SMC_NWEPULSE_(nwe_pulse) |
-			AT91_SMC_NRDPULSE_(nrd_pulse) |
-			AT91_SMC_NCS_WRPULSE_(ncs_write_pulse) |
-			AT91_SMC_NCS_RDPULSE_(ncs_read_pulse));
+			AT91_SMC_NWEPULSE_(pulse) |
+			AT91_SMC_NRDPULSE_(pulse) |
+			AT91_SMC_NCS_WRPULSE_(cs_pulse) |
+			AT91_SMC_NCS_RDPULSE_(cs_pulse));
 
 	at91_sys_write(AT91_SMC_CYCLE(info->cs),
-			AT91_SMC_NWECYCLE_(write_cycle) |
-			AT91_SMC_NRDCYCLE_(read_cycle));
-
-	return;
+			AT91_SMC_NWECYCLE_(cycle) |
+			AT91_SMC_NRDCYCLE_(cycle));
 }
 
 static void pata_at91_set_piomode(struct ata_port *ap, struct ata_device *adev)
@@ -163,8 +250,6 @@ static void pata_at91_set_piomode(struct ata_port *ap, struct ata_device *adev)
 
 	/* Setup SMC mode */
 	set_smc_mode(info);
-
-	return;
 }
 
 static unsigned int pata_at91_data_xfer_noirq(struct ata_device *dev,
@@ -330,7 +415,7 @@ static int __devexit pata_at91_remove(struct platform_device *pdev)
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

