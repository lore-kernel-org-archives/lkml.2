Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab1BGNDy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 08:03:54 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65130 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab1BGNDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 08:03:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=H423sI28f8aaRl1GliU8q57QQRjN4clOiDqHCy9tSrACHyz/TwaeDjyJ3xYFfsPaWN
         xpulffue3MdJXGNWHFhVSna0cVFn5sg4FGqMMsecCJ6IkIa0ubakzSZkzJ75LG6pVIzv
         6Icn9Mlw1xWzBrlBlFQubqc6EX6qL08IPf06M=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH fixed] ide/pmac: housekeeping
Date: Mon, 7 Feb 2011 14:01:31 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-0.7-desktop; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201102071401.32082.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* remove legacy IDE_PMAC_DEBUG debugging code
* rename struct pmac_ide_hwif to struct pmac_ide_priv
* remove pmac_ide_hwif_t
* remove needless {dev,pci}_get_drvdata() casts

Compile-time tested only.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
fixed word-wrapping

 drivers/ide/pmac.c |   94 +++++++++++++++--------------------------------------
 1 file changed, 28 insertions(+), 66 deletions(-)

Index: b/drivers/ide/pmac.c
===================================================================
--- a/drivers/ide/pmac.c
+++ b/drivers/ide/pmac.c
@@ -48,11 +48,9 @@
 
 #define DRV_NAME "ide-pmac"
 
-#undef IDE_PMAC_DEBUG
-
 #define DMA_WAIT_TIMEOUT	50
 
-typedef struct pmac_ide_hwif {
+struct pmac_ide_priv {
 	unsigned long			regbase;
 	int				irq;
 	int				kind;
@@ -72,7 +70,7 @@ typedef struct pmac_ide_hwif {
 	 */
 	volatile struct dbdma_regs __iomem *	dma_regs;
 	struct dbdma_cmd*		dma_table_cpu;
-} pmac_ide_hwif_t;
+};
 
 enum {
 	controller_ohare,	/* OHare based */
@@ -415,8 +413,7 @@ static int pmac_ide_init_dma(ide_hwif_t
 static void pmac_ide_apply_timings(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	pmac_ide_hwif_t *pmif =
-		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
+	struct pmac_ide_priv *pmif = dev_get_drvdata(hwif->gendev.parent);
 
 	if (drive->dn & 1)
 		writel(pmif->timings[1], PMAC_IDE_REG(IDE_TIMING_CONFIG));
@@ -433,8 +430,7 @@ static void pmac_ide_apply_timings(ide_d
 static void pmac_ide_kauai_apply_timings(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	pmac_ide_hwif_t *pmif =
-		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
+	struct pmac_ide_priv *pmif = dev_get_drvdata(hwif->gendev.parent);
 
 	if (drive->dn & 1) {
 		writel(pmif->timings[1], PMAC_IDE_REG(IDE_KAUAI_PIO_CONFIG));
@@ -453,8 +449,7 @@ static void
 pmac_ide_do_update_timings(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	pmac_ide_hwif_t *pmif =
-		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
+	struct pmac_ide_priv *pmif = dev_get_drvdata(hwif->gendev.parent);
 
 	if (pmif->kind == controller_sh_ata6 ||
 	    pmif->kind == controller_un_ata6 ||
@@ -499,8 +494,7 @@ static void pmac_write_devctl(ide_hwif_t
  */
 static void pmac_ide_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	pmac_ide_hwif_t *pmif =
-		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
+	struct pmac_ide_priv *pmif = dev_get_drvdata(hwif->gendev.parent);
 	const u8 pio = drive->pio_mode - XFER_PIO_0;
 	struct ide_timing *tim = ide_timing_find_mode(XFER_PIO_0 + pio);
 	u32 *timings, t;
@@ -568,11 +562,6 @@ static void pmac_ide_set_pio_mode(ide_hw
 		}
 	}
 
-#ifdef IDE_PMAC_DEBUG
-	printk(KERN_ERR "%s: Set PIO timing for mode %d, reg: 0x%08x\n",
-		drive->name, pio,  *timings);
-#endif	
-
 	*timings = t;
 	pmac_ide_do_update_timings(drive);
 }
@@ -597,10 +586,6 @@ set_timings_udma_ata4(u32 *timings, u8 s
 			(rdyToPauseTicks << TR_66_UDMA_RDY2PAUS_SHIFT) |
 			(addrTicks <<TR_66_UDMA_ADDRSETUP_SHIFT) |
 			TR_66_UDMA_EN;
-#ifdef IDE_PMAC_DEBUG
-	printk(KERN_ERR "ide_pmac: Set UDMA timing for mode %d, reg: 0x%08x\n",
-		speed & 0xf,  *timings);
-#endif	
 
 	return 0;
 }
@@ -698,11 +683,6 @@ set_timings_mdma(ide_drive_t *drive, int
 		cycleTime = tm[i].cycleTime;
 		accessTime = tm[i].accessTime;
 		recTime = tm[i].recoveryTime;
-
-#ifdef IDE_PMAC_DEBUG
-		printk(KERN_ERR "%s: MDMA, cycleTime: %d, accessTime: %d, recTime: %d\n",
-			drive->name, cycleTime, accessTime, recTime);
-#endif
 	}
 	switch(intf_type) {
 	case controller_sh_ata6: {
@@ -772,16 +752,11 @@ set_timings_mdma(ide_drive_t *drive, int
 			*timings |= TR_33_MDMA_HALFTICK;
 		}
 	}
-#ifdef IDE_PMAC_DEBUG
-	printk(KERN_ERR "%s: Set MDMA timing for mode %d, reg: 0x%08x\n",
-		drive->name, speed & 0xf,  *timings);
-#endif	
 }
 
 static void pmac_ide_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	pmac_ide_hwif_t *pmif =
-		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
+	struct pmac_ide_priv *pmif = dev_get_drvdata(hwif->gendev.parent);
 	int ret = 0;
 	u32 *timings, *timings2, tl[2];
 	u8 unit = drive->dn & 1;
@@ -821,8 +796,7 @@ static void pmac_ide_set_dma_mode(ide_hw
  * Blast some well known "safe" values to the timing registers at init or
  * wakeup from sleep time, before we do real calculation
  */
-static void
-sanitize_timings(pmac_ide_hwif_t *pmif)
+static void sanitize_timings(struct pmac_ide_priv *pmif)
 {
 	unsigned int value, value2 = 0;
 	
@@ -852,7 +826,7 @@ sanitize_timings(pmac_ide_hwif_t *pmif)
 	pmif->timings[2] = pmif->timings[3] = value2;
 }
 
-static int on_media_bay(pmac_ide_hwif_t *pmif)
+static int on_media_bay(struct pmac_ide_priv *pmif)
 {
 	return pmif->mdev && pmif->mdev->media_bay != NULL;
 }
@@ -860,7 +834,7 @@ static int on_media_bay(pmac_ide_hwif_t
 /* Suspend call back, should be called after the child devices
  * have actually been suspended
  */
-static int pmac_ide_do_suspend(pmac_ide_hwif_t *pmif)
+static int pmac_ide_do_suspend(struct pmac_ide_priv *pmif)
 {
 	/* We clear the timings */
 	pmif->timings[0] = 0;
@@ -889,7 +863,7 @@ static int pmac_ide_do_suspend(pmac_ide_
 /* Resume call back, should be called before the child devices
  * are resumed
  */
-static int pmac_ide_do_resume(pmac_ide_hwif_t *pmif)
+static int pmac_ide_do_resume(struct pmac_ide_priv *pmif)
 {
 	/* Hard reset & re-enable controller (do we really need to reset ? -BenH) */
 	if (!on_media_bay(pmif)) {
@@ -918,8 +892,7 @@ static int pmac_ide_do_resume(pmac_ide_h
 
 static u8 pmac_ide_cable_detect(ide_hwif_t *hwif)
 {
-	pmac_ide_hwif_t *pmif =
-		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
+	struct pmac_ide_priv *pmif = dev_get_drvdata(hwif->gendev.parent);
 	struct device_node *np = pmif->node;
 	const char *cable = of_get_property(np, "cable-type", NULL);
 	struct device_node *root = of_find_node_by_path("/");
@@ -950,8 +923,7 @@ static u8 pmac_ide_cable_detect(ide_hwif
 static void pmac_ide_init_dev(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	pmac_ide_hwif_t *pmif =
-		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
+	struct pmac_ide_priv *pmif = dev_get_drvdata(hwif->gendev.parent);
 
 	if (on_media_bay(pmif)) {
 		if (check_media_bay(pmif->mdev->media_bay) == MB_CD) {
@@ -1024,7 +996,7 @@ static const struct ide_port_info pmac_p
  * Setup, register & probe an IDE channel driven by this driver, this is
  * called by one of the 2 probe functions (macio or PCI).
  */
-static int __devinit pmac_ide_setup_device(pmac_ide_hwif_t *pmif,
+static int __devinit pmac_ide_setup_device(struct pmac_ide_priv *pmif,
 					   struct ide_hw *hw)
 {
 	struct device_node *np = pmif->node;
@@ -1143,7 +1115,7 @@ pmac_ide_macio_attach(struct macio_dev *
 {
 	void __iomem *base;
 	unsigned long regbase;
-	pmac_ide_hwif_t *pmif;
+	struct pmac_ide_priv *pmif;
 	int irq, rc;
 	struct ide_hw hw;
 
@@ -1228,8 +1200,7 @@ out_free_pmif:
 static int
 pmac_ide_macio_suspend(struct macio_dev *mdev, pm_message_t mesg)
 {
-	pmac_ide_hwif_t *pmif =
-		(pmac_ide_hwif_t *)dev_get_drvdata(&mdev->ofdev.dev);
+	struct pmac_ide_priv *pmif = dev_get_drvdata(&mdev->ofdev.dev);
 	int rc = 0;
 
 	if (mesg.event != mdev->ofdev.dev.power.power_state.event
@@ -1245,8 +1216,7 @@ pmac_ide_macio_suspend(struct macio_dev
 static int
 pmac_ide_macio_resume(struct macio_dev *mdev)
 {
-	pmac_ide_hwif_t *pmif =
-		(pmac_ide_hwif_t *)dev_get_drvdata(&mdev->ofdev.dev);
+	struct pmac_ide_priv *pmif = dev_get_drvdata(&mdev->ofdev.dev);
 	int rc = 0;
 
 	if (mdev->ofdev.dev.power.power_state.event != PM_EVENT_ON) {
@@ -1265,7 +1235,7 @@ static int __devinit
 pmac_ide_pci_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct device_node *np;
-	pmac_ide_hwif_t *pmif;
+	struct pmac_ide_priv *pmif;
 	void __iomem *base;
 	unsigned long rbase, rlen;
 	int rc;
@@ -1334,7 +1304,7 @@ out_free_pmif:
 static int
 pmac_ide_pci_suspend(struct pci_dev *pdev, pm_message_t mesg)
 {
-	pmac_ide_hwif_t *pmif = (pmac_ide_hwif_t *)pci_get_drvdata(pdev);
+	struct pmac_ide_priv *pmif = pci_get_drvdata(pdev);
 	int rc = 0;
 
 	if (mesg.event != pdev->dev.power.power_state.event
@@ -1350,7 +1320,7 @@ pmac_ide_pci_suspend(struct pci_dev *pde
 static int
 pmac_ide_pci_resume(struct pci_dev *pdev)
 {
-	pmac_ide_hwif_t *pmif = (pmac_ide_hwif_t *)pci_get_drvdata(pdev);
+	struct pmac_ide_priv *pmif = pci_get_drvdata(pdev);
 	int rc = 0;
 
 	if (pdev->dev.power.power_state.event != PM_EVENT_ON) {
@@ -1365,8 +1335,7 @@ pmac_ide_pci_resume(struct pci_dev *pdev
 #ifdef CONFIG_PMAC_MEDIABAY
 static void pmac_ide_macio_mb_event(struct macio_dev* mdev, int mb_state)
 {
-	pmac_ide_hwif_t *pmif =
-		(pmac_ide_hwif_t *)dev_get_drvdata(&mdev->ofdev.dev);
+	struct pmac_ide_priv *pmif = dev_get_drvdata(&mdev->ofdev.dev);
 
 	switch(mb_state) {
 	case MB_CD:
@@ -1468,8 +1437,7 @@ out:
 static int pmac_ide_build_dmatable(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	pmac_ide_hwif_t *pmif =
-		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
+	struct pmac_ide_priv *pmif = dev_get_drvdata(hwif->gendev.parent);
 	struct dbdma_cmd *table;
 	volatile struct dbdma_regs __iomem *dma = pmif->dma_regs;
 	struct scatterlist *sg;
@@ -1546,8 +1514,7 @@ static int pmac_ide_build_dmatable(ide_d
 static int pmac_ide_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	pmac_ide_hwif_t *pmif =
-		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
+	struct pmac_ide_priv *pmif = dev_get_drvdata(hwif->gendev.parent);
 	u8 unit = drive->dn & 1, ata4 = (pmif->kind == controller_kl_ata4);
 	u8 write = !!(cmd->tf_flags & IDE_TFLAG_WRITE);
 
@@ -1572,8 +1539,7 @@ static void
 pmac_ide_dma_start(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	pmac_ide_hwif_t *pmif =
-		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
+	struct pmac_ide_priv *pmif = dev_get_drvdata(hwif->gendev.parent);
 	volatile struct dbdma_regs __iomem *dma;
 
 	dma = pmif->dma_regs;
@@ -1590,8 +1556,7 @@ static int
 pmac_ide_dma_end (ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	pmac_ide_hwif_t *pmif =
-		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
+	struct pmac_ide_priv *pmif = dev_get_drvdata(hwif->gendev.parent);
 	volatile struct dbdma_regs __iomem *dma = pmif->dma_regs;
 	u32 dstat;
 
@@ -1615,8 +1580,7 @@ static int
 pmac_ide_dma_test_irq (ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	pmac_ide_hwif_t *pmif =
-		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
+	struct pmac_ide_priv *pmif = dev_get_drvdata(hwif->gendev.parent);
 	volatile struct dbdma_regs __iomem *dma = pmif->dma_regs;
 	unsigned long status, timeout;
 
@@ -1670,8 +1634,7 @@ static void
 pmac_ide_dma_lost_irq (ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	pmac_ide_hwif_t *pmif =
-		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
+	struct pmac_ide_priv *pmif = dev_get_drvdata(hwif->gendev.parent);
 	volatile struct dbdma_regs __iomem *dma = pmif->dma_regs;
 	unsigned long status = readl(&dma->status);
 
@@ -1694,8 +1657,7 @@ static const struct ide_dma_ops pmac_dma
 static int __devinit pmac_ide_init_dma(ide_hwif_t *hwif,
 				       const struct ide_port_info *d)
 {
-	pmac_ide_hwif_t *pmif =
-		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
+	struct pmac_ide_priv *pmif = dev_get_drvdata(hwif->gendev.parent);
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 
 	/* We won't need pci_dev if we switch to generic consistent
