Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab0IJCle (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 22:41:34 -0400
Received: from havoc.gtf.org ([69.61.125.42]:51515 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413Ab0IJClc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 22:41:32 -0400
Date: Thu, 9 Sep 2010 22:41:28 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20100910024128.GA18628@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Regression fixes, regular fixes, and a couple new device ids.  The
biggest change LOC-wise is Gwendal's PMP s/ap/link/ fixes, but that is
actually the most straightforward of the bunch.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ahci.c        |    3 +++
 drivers/ata/ata_piix.c    |    4 ++++
 drivers/ata/libahci.c     |    2 +-
 drivers/ata/libata-core.c |   14 +++++++++++++-
 drivers/ata/libata-eh.c   |    4 ++++
 drivers/ata/libata-sff.c  |   41 +++++++++++++++++++++++++++++++----------
 drivers/ata/pata_artop.c  |    3 ++-
 drivers/ata/pata_via.c    |    2 ++
 drivers/ata/sata_mv.c     |    2 +-
 include/linux/libata.h    |    4 +++-
 10 files changed, 64 insertions(+), 15 deletions(-)

Gwendal Grignou (1):
      libata-sff: Reenable Port Multiplier after libata-sff remodeling.

Jean Delvare (1):
      pata_artop: Fix device ID parity check

Seth Heasley (2):
      ata_piix: IDE Mode SATA patch for Intel Patsburg DeviceIDs
      ahci: AHCI and RAID mode SATA patch for Intel Patsburg DeviceIDs

Tejun Heo (3):
      ahci: fix hang on failed softreset
      libata,pata_via: revert ata_wait_idle() removal from ata_sff/via_tf_load()
      libata: skip EH autopsy and recovery during suspend

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 013727b..ff1c945 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -253,6 +253,9 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, 0x1c05), board_ahci }, /* CPT RAID */
 	{ PCI_VDEVICE(INTEL, 0x1c06), board_ahci }, /* CPT RAID */
 	{ PCI_VDEVICE(INTEL, 0x1c07), board_ahci }, /* CPT RAID */
+	{ PCI_VDEVICE(INTEL, 0x1d02), board_ahci }, /* PBG AHCI */
+	{ PCI_VDEVICE(INTEL, 0x1d04), board_ahci }, /* PBG RAID */
+	{ PCI_VDEVICE(INTEL, 0x1d06), board_ahci }, /* PBG RAID */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 3971bc0..d712675 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -302,6 +302,10 @@ static const struct pci_device_id piix_pci_tbl[] = {
 	{ 0x8086, 0x1c08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	/* SATA Controller IDE (CPT) */
 	{ 0x8086, 0x1c09, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	/* SATA Controller IDE (PBG) */
+	{ 0x8086, 0x1d00, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
+	/* SATA Controller IDE (PBG) */
+	{ 0x8086, 0x1d08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	{ }	/* terminate list */
 };
 
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 666850d..68dc678 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -1326,7 +1326,7 @@ int ahci_do_softreset(struct ata_link *link, unsigned int *class,
 	/* issue the first D2H Register FIS */
 	msecs = 0;
 	now = jiffies;
-	if (time_after(now, deadline))
+	if (time_after(deadline, now))
 		msecs = jiffies_to_msecs(deadline - now);
 
 	tf.ctl |= ATA_SRST;
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index c035b3d..932eaee 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5418,6 +5418,7 @@ static int ata_host_request_pm(struct ata_host *host, pm_message_t mesg,
  */
 int ata_host_suspend(struct ata_host *host, pm_message_t mesg)
 {
+	unsigned int ehi_flags = ATA_EHI_QUIET;
 	int rc;
 
 	/*
@@ -5426,7 +5427,18 @@ int ata_host_suspend(struct ata_host *host, pm_message_t mesg)
 	 */
 	ata_lpm_enable(host);
 
-	rc = ata_host_request_pm(host, mesg, 0, ATA_EHI_QUIET, 1);
+	/*
+	 * On some hardware, device fails to respond after spun down
+	 * for suspend.  As the device won't be used before being
+	 * resumed, we don't need to touch the device.  Ask EH to skip
+	 * the usual stuff and proceed directly to suspend.
+	 *
+	 * http://thread.gmane.org/gmane.linux.ide/46764
+	 */
+	if (mesg.event == PM_EVENT_SUSPEND)
+		ehi_flags |= ATA_EHI_NO_AUTOPSY | ATA_EHI_NO_RECOVERY;
+
+	rc = ata_host_request_pm(host, mesg, 0, ehi_flags, 1);
 	if (rc == 0)
 		host->dev->power.power_state = mesg;
 	return rc;
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index c9ae299..e48302e 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -3235,6 +3235,10 @@ static int ata_eh_skip_recovery(struct ata_link *link)
 	if (link->flags & ATA_LFLAG_DISABLED)
 		return 1;
 
+	/* skip if explicitly requested */
+	if (ehc->i.flags & ATA_EHI_NO_RECOVERY)
+		return 1;
+
 	/* thaw frozen port and recover failed devices */
 	if ((ap->pflags & ATA_PFLAG_FROZEN) || ata_link_nr_enabled(link))
 		return 0;
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 3b82d8e..e30c537 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -418,6 +418,7 @@ void ata_sff_tf_load(struct ata_port *ap, const struct ata_taskfile *tf)
 		if (ioaddr->ctl_addr)
 			iowrite8(tf->ctl, ioaddr->ctl_addr);
 		ap->last_ctl = tf->ctl;
+		ata_wait_idle(ap);
 	}
 
 	if (is_addr && (tf->flags & ATA_TFLAG_LBA48)) {
@@ -453,6 +454,8 @@ void ata_sff_tf_load(struct ata_port *ap, const struct ata_taskfile *tf)
 		iowrite8(tf->device, ioaddr->device_addr);
 		VPRINTK("device 0x%X\n", tf->device);
 	}
+
+	ata_wait_idle(ap);
 }
 EXPORT_SYMBOL_GPL(ata_sff_tf_load);
 
@@ -1042,7 +1045,8 @@ static void ata_hsm_qc_complete(struct ata_queued_cmd *qc, int in_wq)
 int ata_sff_hsm_move(struct ata_port *ap, struct ata_queued_cmd *qc,
 		     u8 status, int in_wq)
 {
-	struct ata_eh_info *ehi = &ap->link.eh_info;
+	struct ata_link *link = qc->dev->link;
+	struct ata_eh_info *ehi = &link->eh_info;
 	unsigned long flags = 0;
 	int poll_next;
 
@@ -1298,8 +1302,14 @@ fsm_start:
 }
 EXPORT_SYMBOL_GPL(ata_sff_hsm_move);
 
-void ata_sff_queue_pio_task(struct ata_port *ap, unsigned long delay)
+void ata_sff_queue_pio_task(struct ata_link *link, unsigned long delay)
 {
+	struct ata_port *ap = link->ap;
+
+	WARN_ON((ap->sff_pio_task_link != NULL) &&
+		(ap->sff_pio_task_link != link));
+	ap->sff_pio_task_link = link;
+
 	/* may fail if ata_sff_flush_pio_task() in progress */
 	queue_delayed_work(ata_sff_wq, &ap->sff_pio_task,
 			   msecs_to_jiffies(delay));
@@ -1321,14 +1331,18 @@ static void ata_sff_pio_task(struct work_struct *work)
 {
 	struct ata_port *ap =
 		container_of(work, struct ata_port, sff_pio_task.work);
+	struct ata_link *link = ap->sff_pio_task_link;
 	struct ata_queued_cmd *qc;
 	u8 status;
 	int poll_next;
 
+	BUG_ON(ap->sff_pio_task_link == NULL); 
 	/* qc can be NULL if timeout occurred */
-	qc = ata_qc_from_tag(ap, ap->link.active_tag);
-	if (!qc)
+	qc = ata_qc_from_tag(ap, link->active_tag);
+	if (!qc) {
+		ap->sff_pio_task_link = NULL;
 		return;
+	}
 
 fsm_start:
 	WARN_ON_ONCE(ap->hsm_task_state == HSM_ST_IDLE);
@@ -1345,11 +1359,16 @@ fsm_start:
 		msleep(2);
 		status = ata_sff_busy_wait(ap, ATA_BUSY, 10);
 		if (status & ATA_BUSY) {
-			ata_sff_queue_pio_task(ap, ATA_SHORT_PAUSE);
+			ata_sff_queue_pio_task(link, ATA_SHORT_PAUSE);
 			return;
 		}
 	}
 
+	/*
+	 * hsm_move() may trigger another command to be processed.
+	 * clean the link beforehand.
+	 */
+	ap->sff_pio_task_link = NULL;
 	/* move the HSM */
 	poll_next = ata_sff_hsm_move(ap, qc, status, 1);
 
@@ -1376,6 +1395,7 @@ fsm_start:
 unsigned int ata_sff_qc_issue(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
+	struct ata_link *link = qc->dev->link;
 
 	/* Use polling pio if the LLD doesn't handle
 	 * interrupt driven pio and atapi CDB interrupt.
@@ -1396,7 +1416,7 @@ unsigned int ata_sff_qc_issue(struct ata_queued_cmd *qc)
 		ap->hsm_task_state = HSM_ST_LAST;
 
 		if (qc->tf.flags & ATA_TFLAG_POLLING)
-			ata_sff_queue_pio_task(ap, 0);
+			ata_sff_queue_pio_task(link, 0);
 
 		break;
 
@@ -1409,7 +1429,7 @@ unsigned int ata_sff_qc_issue(struct ata_queued_cmd *qc)
 		if (qc->tf.flags & ATA_TFLAG_WRITE) {
 			/* PIO data out protocol */
 			ap->hsm_task_state = HSM_ST_FIRST;
-			ata_sff_queue_pio_task(ap, 0);
+			ata_sff_queue_pio_task(link, 0);
 
 			/* always send first data block using the
 			 * ata_sff_pio_task() codepath.
@@ -1419,7 +1439,7 @@ unsigned int ata_sff_qc_issue(struct ata_queued_cmd *qc)
 			ap->hsm_task_state = HSM_ST;
 
 			if (qc->tf.flags & ATA_TFLAG_POLLING)
-				ata_sff_queue_pio_task(ap, 0);
+				ata_sff_queue_pio_task(link, 0);
 
 			/* if polling, ata_sff_pio_task() handles the
 			 * rest.  otherwise, interrupt handler takes
@@ -1441,7 +1461,7 @@ unsigned int ata_sff_qc_issue(struct ata_queued_cmd *qc)
 		/* send cdb by polling if no cdb interrupt */
 		if ((!(qc->dev->flags & ATA_DFLAG_CDB_INTR)) ||
 		    (qc->tf.flags & ATA_TFLAG_POLLING))
-			ata_sff_queue_pio_task(ap, 0);
+			ata_sff_queue_pio_task(link, 0);
 		break;
 
 	default:
@@ -2734,6 +2754,7 @@ EXPORT_SYMBOL_GPL(ata_bmdma_dumb_qc_prep);
 unsigned int ata_bmdma_qc_issue(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
+	struct ata_link *link = qc->dev->link;
 
 	/* defer PIO handling to sff_qc_issue */
 	if (!ata_is_dma(qc->tf.protocol))
@@ -2762,7 +2783,7 @@ unsigned int ata_bmdma_qc_issue(struct ata_queued_cmd *qc)
 
 		/* send cdb by polling if no cdb interrupt */
 		if (!(qc->dev->flags & ATA_DFLAG_CDB_INTR))
-			ata_sff_queue_pio_task(ap, 0);
+			ata_sff_queue_pio_task(link, 0);
 		break;
 
 	default:
diff --git a/drivers/ata/pata_artop.c b/drivers/ata/pata_artop.c
index ba43f0f..2215632 100644
--- a/drivers/ata/pata_artop.c
+++ b/drivers/ata/pata_artop.c
@@ -74,7 +74,8 @@ static int artop6260_pre_reset(struct ata_link *link, unsigned long deadline)
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 
 	/* Odd numbered device ids are the units with enable bits (the -R cards) */
-	if (pdev->device % 1 && !pci_test_config_bits(pdev, &artop_enable_bits[ap->port_no]))
+	if ((pdev->device & 1) &&
+	    !pci_test_config_bits(pdev, &artop_enable_bits[ap->port_no]))
 		return -ENOENT;
 
 	return ata_sff_prereset(link, deadline);
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index 5e65988..ac8d7d9 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -417,6 +417,8 @@ static void via_tf_load(struct ata_port *ap, const struct ata_taskfile *tf)
 			tf->lbam,
 			tf->lbah);
 	}
+
+	ata_wait_idle(ap);
 }
 
 static int via_port_start(struct ata_port *ap)
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 8198259..a9fd970 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -2284,7 +2284,7 @@ static unsigned int mv_qc_issue_fis(struct ata_queued_cmd *qc)
 	}
 
 	if (qc->tf.flags & ATA_TFLAG_POLLING)
-		ata_sff_queue_pio_task(ap, 0);
+		ata_sff_queue_pio_task(link, 0);
 	return 0;
 }
 
diff --git a/include/linux/libata.h b/include/linux/libata.h
index f010f18..45fb296 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -335,6 +335,7 @@ enum {
 	ATA_EHI_HOTPLUGGED	= (1 << 0),  /* could have been hotplugged */
 	ATA_EHI_NO_AUTOPSY	= (1 << 2),  /* no autopsy */
 	ATA_EHI_QUIET		= (1 << 3),  /* be quiet */
+	ATA_EHI_NO_RECOVERY	= (1 << 4),  /* no recovery */
 
 	ATA_EHI_DID_SOFTRESET	= (1 << 16), /* already soft-reset this port */
 	ATA_EHI_DID_HARDRESET	= (1 << 17), /* already soft-reset this port */
@@ -723,6 +724,7 @@ struct ata_port {
 	struct ata_ioports	ioaddr;	/* ATA cmd/ctl/dma register blocks */
 	u8			ctl;	/* cache of ATA control register */
 	u8			last_ctl;	/* Cache last written value */
+	struct ata_link*	sff_pio_task_link; /* link currently used */
 	struct delayed_work	sff_pio_task;
 #ifdef CONFIG_ATA_BMDMA
 	struct ata_bmdma_prd	*bmdma_prd;	/* BMDMA SG list */
@@ -1594,7 +1596,7 @@ extern void ata_sff_irq_on(struct ata_port *ap);
 extern void ata_sff_irq_clear(struct ata_port *ap);
 extern int ata_sff_hsm_move(struct ata_port *ap, struct ata_queued_cmd *qc,
 			    u8 status, int in_wq);
-extern void ata_sff_queue_pio_task(struct ata_port *ap, unsigned long delay);
+extern void ata_sff_queue_pio_task(struct ata_link *link, unsigned long delay);
 extern unsigned int ata_sff_qc_issue(struct ata_queued_cmd *qc);
 extern bool ata_sff_qc_fill_rtf(struct ata_queued_cmd *qc);
 extern unsigned int ata_sff_port_intr(struct ata_port *ap,
