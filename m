Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab0CWNm3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 09:42:29 -0400
Received: from havoc.gtf.org ([69.61.125.42]:55033 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131Ab0CWNm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 09:42:27 -0400
Date: Tue, 23 Mar 2010 09:42:26 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20100323134226.GA14752@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This push includes a fix for the ata_piix timeouts people have been
seeing...  it has seen several successful test reports, and is ready for
wider testing in 2.6.34-rc.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/libata-sff.c |   43 ++++++++++++++++++++++++++++++++++++-------
 drivers/ata/pata_via.c   |    1 +
 2 files changed, 37 insertions(+), 7 deletions(-)

JosephChan@via.com.tw (1):
      pata_via: Add VIA VX900 support

Tejun Heo (1):
      libata-sff: fix spurious IRQ handling

diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 561dec2..2774772 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -1667,6 +1667,7 @@ unsigned int ata_sff_host_intr(struct ata_port *ap,
 {
 	struct ata_eh_info *ehi = &ap->link.eh_info;
 	u8 status, host_stat = 0;
+	bool bmdma_stopped = false;
 
 	VPRINTK("ata%u: protocol %d task_state %d\n",
 		ap->print_id, qc->tf.protocol, ap->hsm_task_state);
@@ -1699,6 +1700,7 @@ unsigned int ata_sff_host_intr(struct ata_port *ap,
 
 			/* before we do anything else, clear DMA-Start bit */
 			ap->ops->bmdma_stop(qc);
+			bmdma_stopped = true;
 
 			if (unlikely(host_stat & ATA_DMA_ERR)) {
 				/* error when transfering data to/from memory */
@@ -1716,8 +1718,14 @@ unsigned int ata_sff_host_intr(struct ata_port *ap,
 
 	/* check main status, clearing INTRQ if needed */
 	status = ata_sff_irq_status(ap);
-	if (status & ATA_BUSY)
-		goto idle_irq;
+	if (status & ATA_BUSY) {
+		if (bmdma_stopped) {
+			/* BMDMA engine is already stopped, we're screwed */
+			qc->err_mask |= AC_ERR_HSM;
+			ap->hsm_task_state = HSM_ST_ERR;
+		} else
+			goto idle_irq;
+	}
 
 	/* ack bmdma irq events */
 	ap->ops->sff_irq_clear(ap);
@@ -1762,13 +1770,16 @@ EXPORT_SYMBOL_GPL(ata_sff_host_intr);
 irqreturn_t ata_sff_interrupt(int irq, void *dev_instance)
 {
 	struct ata_host *host = dev_instance;
+	bool retried = false;
 	unsigned int i;
-	unsigned int handled = 0, polling = 0;
+	unsigned int handled, idle, polling;
 	unsigned long flags;
 
 	/* TODO: make _irqsave conditional on x86 PCI IDE legacy mode */
 	spin_lock_irqsave(&host->lock, flags);
 
+retry:
+	handled = idle = polling = 0;
 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_port *ap = host->ports[i];
 		struct ata_queued_cmd *qc;
@@ -1782,7 +1793,8 @@ irqreturn_t ata_sff_interrupt(int irq, void *dev_instance)
 				handled |= ata_sff_host_intr(ap, qc);
 			else
 				polling |= 1 << i;
-		}
+		} else
+			idle |= 1 << i;
 	}
 
 	/*
@@ -1790,7 +1802,9 @@ irqreturn_t ata_sff_interrupt(int irq, void *dev_instance)
 	 * asserting IRQ line, nobody cared will ensue.  Check IRQ
 	 * pending status if available and clear spurious IRQ.
 	 */
-	if (!handled) {
+	if (!handled && !retried) {
+		bool retry = false;
+
 		for (i = 0; i < host->n_ports; i++) {
 			struct ata_port *ap = host->ports[i];
 
@@ -1805,8 +1819,23 @@ irqreturn_t ata_sff_interrupt(int irq, void *dev_instance)
 				ata_port_printk(ap, KERN_INFO,
 						"clearing spurious IRQ\n");
 
-			ap->ops->sff_check_status(ap);
-			ap->ops->sff_irq_clear(ap);
+			if (idle & (1 << i)) {
+				ap->ops->sff_check_status(ap);
+				ap->ops->sff_irq_clear(ap);
+			} else {
+				/* clear INTRQ and check if BUSY cleared */
+				if (!(ap->ops->sff_check_status(ap) & ATA_BUSY))
+					retry |= true;
+				/*
+				 * With command in flight, we can't do
+				 * sff_irq_clear() w/o racing with completion.
+				 */
+			}
+		}
+
+		if (retry) {
+			retried = true;
+			goto retry;
 		}
 	}
 
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index 3059ec0..95d39c3 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -677,6 +677,7 @@ static const struct pci_device_id via[] = {
 	{ PCI_VDEVICE(VIA, 0x3164), },
 	{ PCI_VDEVICE(VIA, 0x5324), },
 	{ PCI_VDEVICE(VIA, 0xC409), VIA_IDFLAG_SINGLE },
+	{ PCI_VDEVICE(VIA, 0x9001), VIA_IDFLAG_SINGLE },
 
 	{ },
 };
