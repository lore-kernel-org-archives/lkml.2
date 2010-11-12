Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463Ab0KLWa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 17:30:26 -0500
Received: from havoc.gtf.org ([69.61.125.42]:52160 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752456Ab0KLWaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 17:30:25 -0500
Date: Fri, 12 Nov 2010 17:30:18 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20101112223018.GA1738@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/libata-scsi.c    |    5 ++++-
 drivers/ata/pata_legacy.c    |    2 +-
 drivers/ata/pata_octeon_cf.c |    2 --
 3 files changed, 5 insertions(+), 4 deletions(-)

Julia Lawall (1):
      drivers/ata/pata_octeon_cf.c: delete double assignment

Tejun Heo (2):
      libata: fix NULL sdev dereference race in atapi_qc_complete()
      pata_legacy: fix CONFIG_PATA_WINBOND_VLB_MODULE test

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index d050e07..3f91c01 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2552,8 +2552,11 @@ static void atapi_qc_complete(struct ata_queued_cmd *qc)
 		 *
 		 * If door lock fails, always clear sdev->locked to
 		 * avoid this infinite loop.
+		 *
+		 * This may happen before SCSI scan is complete.  Make
+		 * sure qc->dev->sdev isn't NULL before dereferencing.
 		 */
-		if (qc->cdb[0] == ALLOW_MEDIUM_REMOVAL)
+		if (qc->cdb[0] == ALLOW_MEDIUM_REMOVAL && qc->dev->sdev)
 			qc->dev->sdev->locked = 0;
 
 		qc->scsicmd->result = SAM_STAT_CHECK_CONDITION;
diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index eaf1941..6bd9425 100644
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -142,7 +142,7 @@ static int autospeed;		/* Chip present which snoops speed changes */
 static int pio_mask = ATA_PIO4;	/* PIO range for autospeed devices */
 static int iordy_mask = 0xFFFFFFFF;	/* Use iordy if available */
 
-#ifdef PATA_WINBOND_VLB_MODULE
+#ifdef CONFIG_PATA_WINBOND_VLB_MODULE
 static int winbond = 1;		/* Set to probe Winbond controllers,
 					give I/O port if non standard */
 #else
diff --git a/drivers/ata/pata_octeon_cf.c b/drivers/ata/pata_octeon_cf.c
index 74b8298..fa1b95a 100644
--- a/drivers/ata/pata_octeon_cf.c
+++ b/drivers/ata/pata_octeon_cf.c
@@ -653,8 +653,6 @@ static irqreturn_t octeon_cf_interrupt(int irq, void *dev_instance)
 
 		ap = host->ports[i];
 		ocd = ap->dev->platform_data;
-
-		ocd = ap->dev->platform_data;
 		cf_port = ap->private_data;
 		dma_int.u64 =
 			cvmx_read_csr(CVMX_MIO_BOOT_DMA_INTX(ocd->dma_engine));
