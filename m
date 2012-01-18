Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582Ab2ARB77 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 20:59:59 -0500
Received: from havoc.gtf.org ([69.61.125.42]:40929 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754351Ab2ARB75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 20:59:57 -0500
Date: Tue, 17 Jan 2012 20:59:55 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata bug fixes
Message-ID: <20120118015955.GA30184@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Summary:

	1) PM async fix

	2) additional ata_piix, CD-ROM quirks

	3) sata_fsl minor vendor update

	4) pata_bf54x "make DMA actually work"



-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Please pull b73fa4630e63e4d23407181c2bc0a54777bd0ce8 from
git://github.com/jgarzik/libata-dev.git upstream-linus

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTxYm4SWzCDIBeCsvAQIUmw//ZmCgcsoPOXDz5s2zBHwiNWK50P1GmnTa
SVoe7iDPfmwArS4OUhpP3mee2ff+N/96mCazX6JQRT1FMbP8uRjdUkz8hQpxqlSL
ZCyRFbgy2J0RY6D6BD51b2Ltk8BTqjiRV63QAWiU7R15e8a0tNnHYhSB4CZlwue0
dPJ62gAMsyE6qEE3p49jeBBypxYCOUXBqFGwXYRaov7z+U88lfz7JCgZ/HnHSqJq
FVQqOcbC7bwqFfy59Qz8HTcBxvt6DXjkBw+L1d6jk0bL7H3NL2unvtso50ygjxHc
u7v8GvopFuXthJqCJO7XaftgGICwlY9LXmYG7wPsjtPTGV8hVo9JPNgCvBVwYT21
aCO3vlvjqiphJnOu+8G8cQUpMR5w+hKTqmnvM7RbSwEdl2eCujAOAH57bwIswdtM
wRxHDyDqUUx5+ZKgz62YdzGioraODtTRvnq6qfA+I7xplZbwkqZCV2eBcLIwP97G
3ofpQsjV+bpuZuLq4+oZlWUybwypnOxyronQQDYH4Olns+X4SrL31Gs3t7XfHsBV
B5tisuK4c/Cce8s0yNzhr5aAOFauQ7WZmOZmx/BTqeT6KX4va5jgaxMr0FINRAv0
OVrBbBYJTK9kS+xwmi+Xbe2wb7Ek2CSt6WGArOW/Dl7EzYP3WXMTu73kizwnFD/L
t4Zh+BlRsp8=
=4Nh2
-----END PGP SIGNATURE-----

to receive the following updates:

 drivers/ata/ata_piix.c         |    7 ++
 drivers/ata/libata-core.c      |    2 +
 drivers/ata/libata-transport.c |    1 +
 drivers/ata/pata_bf54x.c       |  167 +++++++++++++++++++++-------------------
 drivers/ata/sata_fsl.c         |   11 +++
 5 files changed, 109 insertions(+), 79 deletions(-)

Benjamin Larsson (1):
      [libata] ata_piix: Add Toshiba Satellite Pro A120 to the quirks list     due to broken suspend functionality.

Jerry Huang (1):
      [libata] sata_fsl: fix the controller operating mode

Lin Ming (1):
      [libata] enable ata port async suspend

Sonic Zhang (1):
      [libata] pata_bf54x: Support sg list in bmdma transfer.

Vladimir LAVALLADE (1):
      [libata] add DVRTD08A and DVR-215 to NOSETXFER device quirk list

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 69ac373..fdf27b9 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -1117,6 +1117,13 @@ static int piix_broken_suspend(void)
 			},
 		},
 		{
+			.ident = "Satellite Pro A120",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+				DMI_MATCH(DMI_PRODUCT_NAME, "Satellite Pro A120"),
+			},
+		},
+		{
 			.ident = "Portege M500",
 			.matches = {
 				DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 11c9aea..c06e0ec 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4125,6 +4125,8 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	 * device and controller are SATA.
 	 */
 	{ "PIONEER DVD-RW  DVRTD08",	NULL,	ATA_HORKAGE_NOSETXFER },
+	{ "PIONEER DVD-RW  DVRTD08A",	NULL,	ATA_HORKAGE_NOSETXFER },
+	{ "PIONEER DVD-RW  DVR-215",	NULL,	ATA_HORKAGE_NOSETXFER },
 	{ "PIONEER DVD-RW  DVR-212D",	NULL,	ATA_HORKAGE_NOSETXFER },
 	{ "PIONEER DVD-RW  DVR-216D",	NULL,	ATA_HORKAGE_NOSETXFER },
 
diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-transport.c
index 9a7f0ea..74aaee3 100644
--- a/drivers/ata/libata-transport.c
+++ b/drivers/ata/libata-transport.c
@@ -291,6 +291,7 @@ int ata_tport_add(struct device *parent,
 		goto tport_err;
 	}
 
+	device_enable_async_suspend(dev);
 	pm_runtime_set_active(dev);
 	pm_runtime_enable(dev);
 
diff --git a/drivers/ata/pata_bf54x.c b/drivers/ata/pata_bf54x.c
index d6a4677..1e65842 100644
--- a/drivers/ata/pata_bf54x.c
+++ b/drivers/ata/pata_bf54x.c
@@ -251,6 +251,8 @@ static const u32 udma_tenvmin = 20;
 static const u32 udma_tackmin = 20;
 static const u32 udma_tssmin = 50;
 
+#define BFIN_MAX_SG_SEGMENTS 4
+
 /**
  *
  *	Function:       num_clocks_min
@@ -829,79 +831,61 @@ static void bfin_set_devctl(struct ata_port *ap, u8 ctl)
 
 static void bfin_bmdma_setup(struct ata_queued_cmd *qc)
 {
-	unsigned short config = WDSIZE_16;
+	struct ata_port *ap = qc->ap;
+	struct dma_desc_array *dma_desc_cpu = (struct dma_desc_array *)ap->bmdma_prd;
+	void __iomem *base = (void __iomem *)ap->ioaddr.ctl_addr;
+	unsigned short config = DMAFLOW_ARRAY | NDSIZE_5 | RESTART | WDSIZE_16 | DMAEN;
 	struct scatterlist *sg;
 	unsigned int si;
+	unsigned int channel;
+	unsigned int dir;
+	unsigned int size = 0;
 
 	dev_dbg(qc->ap->dev, "in atapi dma setup\n");
 	/* Program the ATA_CTRL register with dir */
 	if (qc->tf.flags & ATA_TFLAG_WRITE) {
-		/* fill the ATAPI DMA controller */
-		set_dma_config(CH_ATAPI_TX, config);
-		set_dma_x_modify(CH_ATAPI_TX, 2);
-		for_each_sg(qc->sg, sg, qc->n_elem, si) {
-			set_dma_start_addr(CH_ATAPI_TX, sg_dma_address(sg));
-			set_dma_x_count(CH_ATAPI_TX, sg_dma_len(sg) >> 1);
-		}
+		channel = CH_ATAPI_TX;
+		dir = DMA_TO_DEVICE;
 	} else {
+		channel = CH_ATAPI_RX;
+		dir = DMA_FROM_DEVICE;
 		config |= WNR;
-		/* fill the ATAPI DMA controller */
-		set_dma_config(CH_ATAPI_RX, config);
-		set_dma_x_modify(CH_ATAPI_RX, 2);
-		for_each_sg(qc->sg, sg, qc->n_elem, si) {
-			set_dma_start_addr(CH_ATAPI_RX, sg_dma_address(sg));
-			set_dma_x_count(CH_ATAPI_RX, sg_dma_len(sg) >> 1);
-		}
 	}
-}
 
-/**
- *	bfin_bmdma_start - Start an IDE DMA transaction
- *	@qc: Info associated with this ATA transaction.
- *
- *	Note: Original code is ata_bmdma_start().
- */
+	dma_map_sg(ap->dev, qc->sg, qc->n_elem, dir);
 
-static void bfin_bmdma_start(struct ata_queued_cmd *qc)
-{
-	struct ata_port *ap = qc->ap;
-	void __iomem *base = (void __iomem *)ap->ioaddr.ctl_addr;
-	struct scatterlist *sg;
-	unsigned int si;
+	/* fill the ATAPI DMA controller */
+	for_each_sg(qc->sg, sg, qc->n_elem, si) {
+		dma_desc_cpu[si].start_addr = sg_dma_address(sg);
+		dma_desc_cpu[si].cfg = config;
+		dma_desc_cpu[si].x_count = sg_dma_len(sg) >> 1;
+		dma_desc_cpu[si].x_modify = 2;
+		size += sg_dma_len(sg);
+	}
 
-	dev_dbg(qc->ap->dev, "in atapi dma start\n");
-	if (!(ap->udma_mask || ap->mwdma_mask))
-		return;
+	/* Set the last descriptor to stop mode */
+	dma_desc_cpu[qc->n_elem - 1].cfg &= ~(DMAFLOW | NDSIZE);
 
-	/* start ATAPI DMA controller*/
-	if (qc->tf.flags & ATA_TFLAG_WRITE) {
-		/*
-		 * On blackfin arch, uncacheable memory is not
-		 * allocated with flag GFP_DMA. DMA buffer from
-		 * common kenel code should be flushed if WB
-		 * data cache is enabled. Otherwise, this loop
-		 * is an empty loop and optimized out.
-		 */
-		for_each_sg(qc->sg, sg, qc->n_elem, si) {
-			flush_dcache_range(sg_dma_address(sg),
-				sg_dma_address(sg) + sg_dma_len(sg));
-		}
-		enable_dma(CH_ATAPI_TX);
-		dev_dbg(qc->ap->dev, "enable udma write\n");
+	flush_dcache_range((unsigned int)dma_desc_cpu,
+		(unsigned int)dma_desc_cpu +
+			qc->n_elem * sizeof(struct dma_desc_array));
 
-		/* Send ATA DMA write command */
-		bfin_exec_command(ap, &qc->tf);
+	/* Enable ATA DMA operation*/
+	set_dma_curr_desc_addr(channel, (unsigned long *)ap->bmdma_prd_dma);
+	set_dma_x_count(channel, 0);
+	set_dma_x_modify(channel, 0);
+	set_dma_config(channel, config);
+
+	SSYNC();
+
+	/* Send ATA DMA command */
+	bfin_exec_command(ap, &qc->tf);
 
+	if (qc->tf.flags & ATA_TFLAG_WRITE) {
 		/* set ATA DMA write direction */
 		ATAPI_SET_CONTROL(base, (ATAPI_GET_CONTROL(base)
 			| XFER_DIR));
 	} else {
-		enable_dma(CH_ATAPI_RX);
-		dev_dbg(qc->ap->dev, "enable udma read\n");
-
-		/* Send ATA DMA read command */
-		bfin_exec_command(ap, &qc->tf);
-
 		/* set ATA DMA read direction */
 		ATAPI_SET_CONTROL(base, (ATAPI_GET_CONTROL(base)
 			& ~XFER_DIR));
@@ -913,12 +897,28 @@ static void bfin_bmdma_start(struct ata_queued_cmd *qc)
 	/* Set ATAPI state machine contorl in terminate sequence */
 	ATAPI_SET_CONTROL(base, ATAPI_GET_CONTROL(base) | END_ON_TERM);
 
-	/* Set transfer length to buffer len */
-	for_each_sg(qc->sg, sg, qc->n_elem, si) {
-		ATAPI_SET_XFER_LEN(base, (sg_dma_len(sg) >> 1));
-	}
+	/* Set transfer length to the total size of sg buffers */
+	ATAPI_SET_XFER_LEN(base, size >> 1);
+}
 
-	/* Enable ATA DMA operation*/
+/**
+ *	bfin_bmdma_start - Start an IDE DMA transaction
+ *	@qc: Info associated with this ATA transaction.
+ *
+ *	Note: Original code is ata_bmdma_start().
+ */
+
+static void bfin_bmdma_start(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	void __iomem *base = (void __iomem *)ap->ioaddr.ctl_addr;
+
+	dev_dbg(qc->ap->dev, "in atapi dma start\n");
+
+	if (!(ap->udma_mask || ap->mwdma_mask))
+		return;
+
+	/* start ATAPI transfer*/
 	if (ap->udma_mask)
 		ATAPI_SET_CONTROL(base, ATAPI_GET_CONTROL(base)
 			| ULTRA_START);
@@ -935,34 +935,23 @@ static void bfin_bmdma_start(struct ata_queued_cmd *qc)
 static void bfin_bmdma_stop(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
-	struct scatterlist *sg;
-	unsigned int si;
+	unsigned int dir;
 
 	dev_dbg(qc->ap->dev, "in atapi dma stop\n");
+
 	if (!(ap->udma_mask || ap->mwdma_mask))
 		return;
 
 	/* stop ATAPI DMA controller*/
-	if (qc->tf.flags & ATA_TFLAG_WRITE)
+	if (qc->tf.flags & ATA_TFLAG_WRITE) {
+		dir = DMA_TO_DEVICE;
 		disable_dma(CH_ATAPI_TX);
-	else {
+	} else {
+		dir = DMA_FROM_DEVICE;
 		disable_dma(CH_ATAPI_RX);
-		if (ap->hsm_task_state & HSM_ST_LAST) {
-			/*
-			 * On blackfin arch, uncacheable memory is not
-			 * allocated with flag GFP_DMA. DMA buffer from
-			 * common kenel code should be invalidated if
-			 * data cache is enabled. Otherwise, this loop
-			 * is an empty loop and optimized out.
-			 */
-			for_each_sg(qc->sg, sg, qc->n_elem, si) {
-				invalidate_dcache_range(
-					sg_dma_address(sg),
-					sg_dma_address(sg)
-					+ sg_dma_len(sg));
-			}
-		}
 	}
+
+	dma_unmap_sg(ap->dev, qc->sg, qc->n_elem, dir);
 }
 
 /**
@@ -1260,6 +1249,11 @@ static void bfin_port_stop(struct ata_port *ap)
 {
 	dev_dbg(ap->dev, "in atapi port stop\n");
 	if (ap->udma_mask != 0 || ap->mwdma_mask != 0) {
+		dma_free_coherent(ap->dev,
+			BFIN_MAX_SG_SEGMENTS * sizeof(struct dma_desc_array),
+			ap->bmdma_prd,
+			ap->bmdma_prd_dma);
+
 		free_dma(CH_ATAPI_RX);
 		free_dma(CH_ATAPI_TX);
 	}
@@ -1271,14 +1265,29 @@ static int bfin_port_start(struct ata_port *ap)
 	if (!(ap->udma_mask || ap->mwdma_mask))
 		return 0;
 
+	ap->bmdma_prd = dma_alloc_coherent(ap->dev,
+				BFIN_MAX_SG_SEGMENTS * sizeof(struct dma_desc_array),
+				&ap->bmdma_prd_dma,
+				GFP_KERNEL);
+
+	if (ap->bmdma_prd == NULL) {
+		dev_info(ap->dev, "Unable to allocate DMA descriptor array.\n");
+		goto out;
+	}
+
 	if (request_dma(CH_ATAPI_RX, "BFIN ATAPI RX DMA") >= 0) {
 		if (request_dma(CH_ATAPI_TX,
 			"BFIN ATAPI TX DMA") >= 0)
 			return 0;
 
 		free_dma(CH_ATAPI_RX);
+		dma_free_coherent(ap->dev,
+			BFIN_MAX_SG_SEGMENTS * sizeof(struct dma_desc_array),
+			ap->bmdma_prd,
+			ap->bmdma_prd_dma);
 	}
 
+out:
 	ap->udma_mask = 0;
 	ap->mwdma_mask = 0;
 	dev_err(ap->dev, "Unable to request ATAPI DMA!"
@@ -1400,7 +1409,7 @@ static irqreturn_t bfin_ata_interrupt(int irq, void *dev_instance)
 
 static struct scsi_host_template bfin_sht = {
 	ATA_BASE_SHT(DRV_NAME),
-	.sg_tablesize		= SG_NONE,
+	.sg_tablesize		= BFIN_MAX_SG_SEGMENTS,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 };
 
diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index 5a2c95b..0120b0d 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -140,6 +140,7 @@ enum {
 	 */
 	HCONTROL_ONLINE_PHY_RST = (1 << 31),
 	HCONTROL_FORCE_OFFLINE = (1 << 30),
+	HCONTROL_LEGACY = (1 << 28),
 	HCONTROL_PARITY_PROT_MOD = (1 << 14),
 	HCONTROL_DPATH_PARITY = (1 << 12),
 	HCONTROL_SNOOP_ENABLE = (1 << 10),
@@ -1223,6 +1224,10 @@ static int sata_fsl_init_controller(struct ata_host *host)
 	 * part of the port_start() callback
 	 */
 
+	/* sata controller to operate in enterprise mode */
+	temp = ioread32(hcr_base + HCONTROL);
+	iowrite32(temp & ~HCONTROL_LEGACY, hcr_base + HCONTROL);
+
 	/* ack. any pending IRQs for this controller/port */
 	temp = ioread32(hcr_base + HSTATUS);
 	if (temp & 0x3F)
@@ -1421,6 +1426,12 @@ static int sata_fsl_resume(struct platform_device *op)
 	/* Recovery the CHBA register in host controller cmd register set */
 	iowrite32(pp->cmdslot_paddr & 0xffffffff, hcr_base + CHBA);
 
+	iowrite32((ioread32(hcr_base + HCONTROL)
+				| HCONTROL_ONLINE_PHY_RST
+				| HCONTROL_SNOOP_ENABLE
+				| HCONTROL_PMP_ATTACHED),
+			hcr_base + HCONTROL);
+
 	ata_host_resume(host);
 	return 0;
 }
