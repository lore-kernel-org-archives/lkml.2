Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046Ab1ETVLI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 17:11:08 -0400
Received: from havoc.gtf.org ([69.61.125.42]:37935 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758029Ab1ETVLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 17:11:03 -0400
Date: Fri, 20 May 2011 17:10:49 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata updates for 2.6.40
Message-ID: <20110520211049.GA25254@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Not a big list for 2.6.40.  Note the "fix oops" commit you already have;
git will DTRT and notice that when you merge.

There remains a big pile of minor Bart patches I'm sorting through,
probably slated for 2.6.41 at this point.

We'll have to watch for regressions with the "power off empty ports"
change from Intel.  Everything looks good with the change, and it
saves power, but it's the kind of change that really just needs wide
field testing before we can have full confidence.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/acard-ahci.c   |    2 
 drivers/ata/libata-core.c  |   10 +
 drivers/ata/libata-eh.c    |    4 
 drivers/ata/libata-pmp.c   |   10 +
 drivers/ata/libata-scsi.c  |    2 
 drivers/ata/libata-sff.c   |    9 +
 drivers/ata/pata_at91.c    |  297 ++++++++++++++++++++++++++++++---------------
 drivers/ata/pata_cmd64x.c  |   42 +++++-
 drivers/ata/pata_triflex.c |   23 +++
 include/linux/libata.h     |    1 
 include/linux/pci_ids.h    |    2 
 11 files changed, 290 insertions(+), 112 deletions(-)

Igor Plyatov (1):
      pata_at91: SMC settings calculation bugfixes, support for t6z and IORDY

James Bottomley (2):
      pata_cm64x: fix boot crash on parisc
      libata-sff: prevent irq descriptions for dummy ports

Jeff Garzik (1):
      drivers/ata/acard-ahci.c: fix enum warning

Kristen Carlson Accardi (1):
      libata: Power off empty ports

Martin K. Petersen (1):
      libata: Use Maximum Write Same Length to report discard size limit

Mikulas Patocka (1):
      ATA: Don't powerdown Compaq Triflex IDE device on suspend

Pavel Herrmann (1):
      libata-pmp: add support for Thermaltake BlackX Duet esata drive dock

Tejun Heo (1):
      libata: fix oops when LPM is used with PMP

diff --git a/drivers/ata/acard-ahci.c b/drivers/ata/acard-ahci.c
index 339c210..ae22be4 100644
--- a/drivers/ata/acard-ahci.c
+++ b/drivers/ata/acard-ahci.c
@@ -417,7 +417,7 @@ static int acard_ahci_init_one(struct pci_dev *pdev, const struct pci_device_id
 
 	VPRINTK("ENTER\n");
 
-	WARN_ON(ATA_MAX_QUEUE > AHCI_MAX_CMDS);
+	WARN_ON((int)ATA_MAX_QUEUE > AHCI_MAX_CMDS);
 
 	if (!printed_version++)
 		dev_printk(KERN_DEBUG, &pdev->dev, "version " DRV_VERSION "\n");
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 76c3c15..736bee5 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3619,8 +3619,14 @@ int sata_link_scr_lpm(struct ata_link *link, enum ata_lpm_policy policy,
 		scontrol |= (0x2 << 8);
 		break;
 	case ATA_LPM_MIN_POWER:
-		/* no restrictions on LPM transitions */
-		scontrol &= ~(0x3 << 8);
+		if (ata_link_nr_enabled(link) > 0)
+			/* no restrictions on LPM transitions */
+			scontrol &= ~(0x3 << 8);
+		else {
+			/* empty port, power off */
+			scontrol &= ~0xf;
+			scontrol |= (0x1 << 2);
+		}
 		break;
 	default:
 		WARN_ON(1);
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index f26f2fe..dfb6e9d 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -3316,7 +3316,7 @@ static int ata_eh_set_lpm(struct ata_link *link, enum ata_lpm_policy policy,
 	struct ata_eh_context *ehc = &link->eh_context;
 	struct ata_device *dev, *link_dev = NULL, *lpm_dev = NULL;
 	enum ata_lpm_policy old_policy = link->lpm_policy;
-	bool no_dipm = ap->flags & ATA_FLAG_NO_DIPM;
+	bool no_dipm = link->ap->flags & ATA_FLAG_NO_DIPM;
 	unsigned int hints = ATA_LPM_EMPTY | ATA_LPM_HIPM;
 	unsigned int err_mask;
 	int rc;
@@ -3423,7 +3423,7 @@ fail:
 	return rc;
 }
 
-static int ata_link_nr_enabled(struct ata_link *link)
+int ata_link_nr_enabled(struct ata_link *link)
 {
 	struct ata_device *dev;
 	int cnt = 0;
diff --git a/drivers/ata/libata-pmp.c b/drivers/ata/libata-pmp.c
index 3120596..f06b7ea 100644
--- a/drivers/ata/libata-pmp.c
+++ b/drivers/ata/libata-pmp.c
@@ -449,6 +449,16 @@ static void sata_pmp_quirks(struct ata_port *ap)
 		 * otherwise.  Don't try hard to recover it.
 		 */
 		ap->pmp_link[ap->nr_pmp_links - 1].flags |= ATA_LFLAG_NO_RETRY;
+	} else if (vendor == 0x197b && devid == 0x2352) {
+		/* chip found in Thermaltake BlackX Duet, jmicron JMB350? */
+		ata_for_each_link(link, ap, EDGE) {
+			/* SRST breaks detection and disks get misclassified
+			 * LPM disabled to avoid potential problems
+			 */
+			link->flags |= ATA_LFLAG_NO_LPM |
+				       ATA_LFLAG_NO_SRST |
+				       ATA_LFLAG_ASSUME_ATA;
+		}
 	}
 }
 
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index e2f57e9e..30ea95f 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2138,7 +2138,7 @@ static unsigned int ata_scsiop_inq_b0(struct ata_scsi_args *args, u8 *rbuf)
 	 * with the unmap bit set.
 	 */
 	if (ata_id_has_trim(args->id)) {
-		put_unaligned_be32(65535 * 512 / 8, &rbuf[20]);
+		put_unaligned_be64(65535 * 512 / 8, &rbuf[36]);
 		put_unaligned_be32(1, &rbuf[28]);
 	}
 
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index f8380ce..b1b926c 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -2447,13 +2447,18 @@ int ata_pci_sff_activate_host(struct ata_host *host,
 		return -ENOMEM;
 
 	if (!legacy_mode && pdev->irq) {
+		int i;
+
 		rc = devm_request_irq(dev, pdev->irq, irq_handler,
 				      IRQF_SHARED, drv_name, host);
 		if (rc)
 			goto out;
 
-		ata_port_desc(host->ports[0], "irq %d", pdev->irq);
-		ata_port_desc(host->ports[1], "irq %d", pdev->irq);
+		for (i = 0; i < 2; i++) {
+			if (ata_port_is_dummy(host->ports[i]))
+				continue;
+			ata_port_desc(host->ports[i], "irq %d", pdev->irq);
+		}
 	} else if (legacy_mode) {
 		if (!ata_port_is_dummy(host->ports[0])) {
 			rc = devm_request_irq(dev, ATA_PRIMARY_IRQ(pdev),
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
diff --git a/drivers/ata/pata_cmd64x.c b/drivers/ata/pata_cmd64x.c
index 905ff76..7bafc16 100644
--- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -41,6 +41,9 @@
 enum {
 	CFR 		= 0x50,
 		CFR_INTR_CH0  = 0x04,
+	CNTRL		= 0x51,
+		CNTRL_CH0     = 0x04,
+		CNTRL_CH1     = 0x08,
 	CMDTIM 		= 0x52,
 	ARTTIM0 	= 0x53,
 	DRWTIM0 	= 0x54,
@@ -328,9 +331,19 @@ static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 			.port_ops = &cmd648_port_ops
 		}
 	};
-	const struct ata_port_info *ppi[] = { &cmd_info[id->driver_data], NULL };
-	u8 mrdmode;
+	const struct ata_port_info *ppi[] = { 
+		&cmd_info[id->driver_data],
+		&cmd_info[id->driver_data],
+		NULL
+	};
+	u8 mrdmode, reg;
 	int rc;
+	struct pci_dev *bridge = pdev->bus->self;
+	/* mobility split bridges don't report enabled ports correctly */
+	int port_ok = !(bridge && bridge->vendor ==
+			PCI_VENDOR_ID_MOBILITY_ELECTRONICS);
+	/* all (with exceptions below) apart from 643 have CNTRL_CH0 bit */
+	int cntrl_ch0_ok = (id->driver_data != 0);
 
 	rc = pcim_enable_device(pdev);
 	if (rc)
@@ -341,11 +354,18 @@ static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	if (pdev->device == PCI_DEVICE_ID_CMD_646) {
 		/* Does UDMA work ? */
-		if (pdev->revision > 4)
+		if (pdev->revision > 4) {
 			ppi[0] = &cmd_info[2];
+			ppi[1] = &cmd_info[2];
+		}
 		/* Early rev with other problems ? */
-		else if (pdev->revision == 1)
+		else if (pdev->revision == 1) {
 			ppi[0] = &cmd_info[3];
+			ppi[1] = &cmd_info[3];
+		}
+		/* revs 1,2 have no CNTRL_CH0 */
+		if (pdev->revision < 3)
+			cntrl_ch0_ok = 0;
 	}
 
 	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 64);
@@ -354,6 +374,20 @@ static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	mrdmode |= 0x02;	/* Memory read line enable */
 	pci_write_config_byte(pdev, MRDMODE, mrdmode);
 
+	/* check for enabled ports */
+	pci_read_config_byte(pdev, CNTRL, &reg);
+	if (!port_ok)
+		dev_printk(KERN_NOTICE, &pdev->dev, "Mobility Bridge detected, ignoring CNTRL port enable/disable\n");
+	if (port_ok && cntrl_ch0_ok && !(reg & CNTRL_CH0)) {
+		dev_printk(KERN_NOTICE, &pdev->dev, "Primary port is disabled\n");
+		ppi[0] = &ata_dummy_port_info;
+		
+	}
+	if (port_ok && !(reg & CNTRL_CH1)) {
+		dev_printk(KERN_NOTICE, &pdev->dev, "Secondary port is disabled\n");
+		ppi[1] = &ata_dummy_port_info;
+	}
+
 	/* Force PIO 0 here.. */
 
 	/* PPC specific fixup copied from old driver */
diff --git a/drivers/ata/pata_triflex.c b/drivers/ata/pata_triflex.c
index 03b6d69..b3e0c94 100644
--- a/drivers/ata/pata_triflex.c
+++ b/drivers/ata/pata_triflex.c
@@ -210,13 +210,34 @@ static const struct pci_device_id triflex[] = {
 	{ },
 };
 
+#ifdef CONFIG_PM
+static int triflex_ata_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg)
+{
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	int rc = 0;
+
+	rc = ata_host_suspend(host, mesg);
+	if (rc)
+		return rc;
+
+	/*
+	 * We must not disable or powerdown the device.
+	 * APM bios refuses to suspend if IDE is not accessible.
+	 */
+	pci_save_state(pdev);
+
+	return 0;
+}
+
+#endif
+
 static struct pci_driver triflex_pci_driver = {
 	.name 		= DRV_NAME,
 	.id_table	= triflex,
 	.probe 		= triflex_init_one,
 	.remove		= ata_pci_remove_one,
 #ifdef CONFIG_PM
-	.suspend	= ata_pci_device_suspend,
+	.suspend	= triflex_ata_pci_device_suspend,
 	.resume		= ata_pci_device_resume,
 #endif
 };
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 04f32a3..5a9926b 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1151,6 +1151,7 @@ extern void ata_do_eh(struct ata_port *ap, ata_prereset_fn_t prereset,
 		      ata_reset_fn_t softreset, ata_reset_fn_t hardreset,
 		      ata_postreset_fn_t postreset);
 extern void ata_std_error_handler(struct ata_port *ap);
+extern int ata_link_nr_enabled(struct ata_link *link);
 
 /*
  * Base operations to inherit from and initializers for sht
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 8abe8d7..8652a4f 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -608,6 +608,8 @@
 #define PCI_DEVICE_ID_MATROX_G550	0x2527
 #define PCI_DEVICE_ID_MATROX_VIA	0x4536
 
+#define PCI_VENDOR_ID_MOBILITY_ELECTRONICS	0x14f2
+
 #define PCI_VENDOR_ID_CT		0x102c
 #define PCI_DEVICE_ID_CT_69000		0x00c0
 #define PCI_DEVICE_ID_CT_65545		0x00d8
