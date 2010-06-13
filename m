Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab0FMPcO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 11:32:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:37719 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754034Ab0FMPcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 11:32:10 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, tglx@linutronix.de, bphilips@suse.de, yinghai@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, stern@rowland.harvard.edu, gregkh@suse.de,
       khali@linux-fr.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/12] libata: use IRQ expecting
Date: Sun, 13 Jun 2010 17:31:37 +0200
Message-Id: <1276443098-20653-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1276443098-20653-1-git-send-email-tj@kernel.org>
References: <1276443098-20653-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 13 Jun 2010 15:31:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to its age, ATA is very susceptible to IRQ delivery problems in
both directions - lost and spurious interrupts.  In traditional PATA,
the IRQ line is ultimately out of the controller and driver's control.
Even relatively new SATA isn't free from these issues.  Many
controllers still emulate the traditional IDE interface which doesn't
have reliable way to indicate interrupt pending state and there also
is an issue regarding the interpretation of nIEN on both sides of the
cable.

Most of these problems can be worked around by using the new IRQ
expecting mechanism without adding noticeable overhead.  In ATA,
almost all operations are initiated by the host and the controller
signals progress or completion using IRQ.  IRQ expecting can easily be
added in libata core and applied to all libata drivers.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/ata/libata-core.c |   15 +++++++++++++--
 drivers/ata/libata-eh.c   |    4 +++-
 drivers/ata/libata-sff.c  |   37 +++++++++++++++++++------------------
 include/linux/libata.h    |    2 ++
 4 files changed, 37 insertions(+), 21 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index ddf8e48..9a0aaa0 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4972,6 +4972,8 @@ void ata_qc_complete(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
 
+	unexpect_irq(ap->irq_expect, false);
+
 	/* XXX: New EH and old EH use different mechanisms to
 	 * synchronize EH with regular execution path.
 	 *
@@ -5087,6 +5089,9 @@ int ata_qc_complete_multiple(struct ata_port *ap, u32 qc_active)
 		done_mask &= ~(1 << tag);
 	}
 
+	if (ap->qc_active)
+		expect_irq(ap->irq_expect);
+
 	return nr_done;
 }
 
@@ -5153,6 +5158,7 @@ void ata_qc_issue(struct ata_queued_cmd *qc)
 	qc->err_mask |= ap->ops->qc_issue(qc);
 	if (unlikely(qc->err_mask))
 		goto err;
+	expect_irq(ap->irq_expect);
 	return;
 
 sg_err:
@@ -6185,8 +6191,13 @@ int ata_host_activate(struct ata_host *host, int irq,
 	if (rc)
 		return rc;
 
-	for (i = 0; i < host->n_ports; i++)
-		ata_port_desc(host->ports[i], "irq %d", irq);
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap = host->ports[i];
+
+		if (!ata_port_is_dummy(ap))
+			ap->irq_expect = init_irq_expect(irq, host);
+		ata_port_desc(ap, "irq %d%s", irq, ap->irq_expect ? "+" : "");
+	}
 
 	rc = ata_host_register(host, sht);
 	/* if failed, just free the IRQ and leave ports alone */
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index f77a673..f1ae3ec 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -619,8 +619,10 @@ void ata_scsi_error(struct Scsi_Host *host)
 		 * handler doesn't diddle with those qcs.  This must
 		 * be done atomically w.r.t. setting QCFLAG_FAILED.
 		 */
-		if (nr_timedout)
+		if (nr_timedout) {
+			unexpect_irq(ap->irq_expect, true);
 			__ata_port_freeze(ap);
+		}
 
 		spin_unlock_irqrestore(ap->lock, flags);
 
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index efa4a18..cc96f36 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -2388,7 +2388,8 @@ int ata_pci_sff_activate_host(struct ata_host *host,
 	struct device *dev = host->dev;
 	struct pci_dev *pdev = to_pci_dev(dev);
 	const char *drv_name = dev_driver_string(host->dev);
-	int legacy_mode = 0, rc;
+	struct ata_port *ap[2] = { host->ports[0], host->ports[1] };
+	int legacy_mode = 0, i, rc;
 
 	rc = ata_host_start(host);
 	if (rc)
@@ -2422,29 +2423,29 @@ int ata_pci_sff_activate_host(struct ata_host *host,
 		if (rc)
 			goto out;
 
-		ata_port_desc(host->ports[0], "irq %d", pdev->irq);
-		ata_port_desc(host->ports[1], "irq %d", pdev->irq);
+		for (i = 0; i < 2; i++) {
+			if (!ata_port_is_dummy(ap[i]))
+				ap[i]->irq_expect =
+					init_irq_expect(pdev->irq, host);
+			ata_port_desc(ap[i], "irq %d%s",
+				      pdev->irq, ap[i]->irq_expect ? "+" : "");
+		}
 	} else if (legacy_mode) {
-		if (!ata_port_is_dummy(host->ports[0])) {
-			rc = devm_request_irq(dev, ATA_PRIMARY_IRQ(pdev),
-					      irq_handler, IRQF_SHARED,
-					      drv_name, host);
-			if (rc)
-				goto out;
+		unsigned int irqs[2] = { ATA_PRIMARY_IRQ(pdev),
+					 ATA_SECONDARY_IRQ(pdev) };
 
-			ata_port_desc(host->ports[0], "irq %d",
-				      ATA_PRIMARY_IRQ(pdev));
-		}
+		for (i = 0; i < 2; i++) {
+			if (ata_port_is_dummy(ap[i]))
+				continue;
 
-		if (!ata_port_is_dummy(host->ports[1])) {
-			rc = devm_request_irq(dev, ATA_SECONDARY_IRQ(pdev),
-					      irq_handler, IRQF_SHARED,
-					      drv_name, host);
+			rc = devm_request_irq(dev, irqs[i], irq_handler,
+					      IRQF_SHARED, drv_name, host);
 			if (rc)
 				goto out;
 
-			ata_port_desc(host->ports[1], "irq %d",
-				      ATA_SECONDARY_IRQ(pdev));
+			ap[i]->irq_expect = init_irq_expect(irqs[i], host);
+			ata_port_desc(ap[i], "irq %d%s",
+				      irqs[i], ap[i]->irq_expect ? "+" : "");
 		}
 	}
 
diff --git a/include/linux/libata.h b/include/linux/libata.h
index b85f3ff..3f5f159 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -751,6 +751,8 @@ struct ata_port {
 	struct ata_host		*host;
 	struct device 		*dev;
 
+	struct irq_expect	*irq_expect;	/* for irq expecting */
+
 	struct delayed_work	hotplug_task;
 	struct work_struct	scsi_rescan_task;
 
-- 
1.6.4.2

