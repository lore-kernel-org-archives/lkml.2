Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876Ab0GBOnA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 10:43:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:59965 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755764Ab0GBOm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 10:42:58 -0400
Message-ID: <4C2DFAB0.3020703@kernel.org>
Date: Fri, 02 Jul 2010 16:41:52 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: mingo@elte.hu, tglx@linutronix.de, bphilips@suse.de, yinghai@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       stern@rowland.harvard.edu, gregkh@suse.de, khali@linux-fr.org
Subject: Re: [PATCH 11/12] libata: use IRQ expecting
References: <1276443098-20653-1-git-send-email-tj@kernel.org> <1276443098-20653-12-git-send-email-tj@kernel.org> <4C23F6C1.7070603@garzik.org> <4C245E50.7090701@kernel.org> <4C2577F2.4030005@garzik.org> <4C25BAD2.4070705@kernel.org> <4C25C551.8000404@garzik.org> <4C25CC18.2070507@kernel.org>
In-Reply-To: <4C25CC18.2070507@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 02 Jul 2010 14:41:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jeff.

So, something like the following.  This should be applied on top of
the two previous libata patches.  The amount of code in the hot path
is very small.  Compared to the cpu actually taking an interrupt and
accessing hardware, it should be negligible, and this will give us
working and acceptably performing systems in the presence of most
types of IRQ problems.

Thanks.

Subject: [PATCH] libata: use IRQ expecting

Legacy ATA is very susceptible to IRQ delivery problems in both
directions - lost and spurious interrupts.  In traditional PATA, the
IRQ line is ultimately out of the controller and driver's control.

Even relatively new SATA controllers share this problem as many still
emulate the traditional IDE interface which doesn't have reliable way
to indicate interrupt pending state and there also is an issue
regarding the interpretation of nIEN on both sides of the cable.

Controllers with native interface have fewer problems compared to the
ones which use SFF but they still are affected by IRQ misrouting or
broken MSI implementations.

IRQ delivery problems on ATA are particularly nasty because it
commonly hosts installation and/or booting.

Most of these problems can be worked around by using the new IRQ
expecting mechanism without adding any noticeable overhead.  In ATA,
almost all operations are initiated by the host and the controller
signals progress or completion using IRQ.  IRQ expecting can easily be
added in libata core and applied to all libata drivers.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/ata/libata-core.c |   55 ++++++++++++++++++++++++++++++----------------
 drivers/ata/libata-eh.c   |    4 ++-
 drivers/ata/libata-sff.c  |   37 +++++++++++++++---------------
 include/linux/libata.h    |    2 +
 4 files changed, 60 insertions(+), 38 deletions(-)

Index: work/drivers/ata/libata-core.c
===================================================================
--- work.orig/drivers/ata/libata-core.c
+++ work/drivers/ata/libata-core.c
@@ -4958,22 +4958,7 @@ static void ata_verify_xfer(struct ata_q
 	dev->flags &= ~ATA_DFLAG_DUBIOUS_XFER;
 }

-/**
- *	ata_qc_complete - Complete an active ATA command
- *	@qc: Command to complete
- *
- *	Indicate to the mid and upper layers that an ATA command has
- *	completed, with either an ok or not-ok status.
- *
- *	Refrain from calling this function multiple times when
- *	successfully completing multiple NCQ commands.
- *	ata_qc_complete_multiple() should be used instead, which will
- *	properly update IRQ expect state.
- *
- *	LOCKING:
- *	spin_lock_irqsave(host lock)
- */
-void ata_qc_complete(struct ata_queued_cmd *qc)
+static void ata_qc_complete_raw(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;

@@ -5052,6 +5037,27 @@ void ata_qc_complete(struct ata_queued_c
 }

 /**
+ *	ata_qc_complete - Complete an active ATA command
+ *	@qc: Command to complete
+ *
+ *	Indicate to the mid and upper layers that an ATA command has
+ *	completed, with either an ok or not-ok status.
+ *
+ *	Refrain from calling this function multiple times when
+ *	successfully completing multiple NCQ commands.
+ *	ata_qc_complete_multiple() should be used instead, which will
+ *	properly update IRQ expect state.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ */
+void ata_qc_complete(struct ata_queued_cmd *qc)
+{
+	unexpect_irq(qc->ap->irq_expect, false);
+	ata_qc_complete_raw(qc);
+}
+
+/**
  *	ata_qc_complete_multiple - Complete multiple qcs successfully
  *	@ap: port in question
  *	@qc_active: new qc_active mask
@@ -5076,6 +5082,8 @@ int ata_qc_complete_multiple(struct ata_
 	int nr_done = 0;
 	u32 done_mask;

+	unexpect_irq(ap->irq_expect, false);
+
 	done_mask = ap->qc_active ^ qc_active;

 	if (unlikely(done_mask & qc_active)) {
@@ -5090,12 +5098,15 @@ int ata_qc_complete_multiple(struct ata_

 		qc = ata_qc_from_tag(ap, tag);
 		if (qc) {
-			ata_qc_complete(qc);
+			ata_qc_complete_raw(qc);
 			nr_done++;
 		}
 		done_mask &= ~(1 << tag);
 	}

+	if (ap->qc_active)
+		expect_irq(ap->irq_expect);
+
 	return nr_done;
 }

@@ -5162,6 +5173,7 @@ void ata_qc_issue(struct ata_queued_cmd
 	qc->err_mask |= ap->ops->qc_issue(qc);
 	if (unlikely(qc->err_mask))
 		goto err;
+	expect_irq(ap->irq_expect);
 	return;

 sg_err:
@@ -6194,8 +6206,13 @@ int ata_host_activate(struct ata_host *h
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
Index: work/drivers/ata/libata-eh.c
===================================================================
--- work.orig/drivers/ata/libata-eh.c
+++ work/drivers/ata/libata-eh.c
@@ -619,8 +619,10 @@ void ata_scsi_error(struct Scsi_Host *ho
 		 * handler doesn't diddle with those qcs.  This must
 		 * be done atomically w.r.t. setting QCFLAG_FAILED.
 		 */
-		if (nr_timedout)
+		if (nr_timedout) {
+			unexpect_irq(ap->irq_expect, true);
 			__ata_port_freeze(ap);
+		}

 		spin_unlock_irqrestore(ap->lock, flags);

Index: work/include/linux/libata.h
===================================================================
--- work.orig/include/linux/libata.h
+++ work/include/linux/libata.h
@@ -751,6 +751,8 @@ struct ata_port {
 	struct ata_host		*host;
 	struct device 		*dev;

+	struct irq_expect	*irq_expect;	/* for irq expecting */
+
 	struct delayed_work	hotplug_task;
 	struct work_struct	scsi_rescan_task;

Index: work/drivers/ata/libata-sff.c
===================================================================
--- work.orig/drivers/ata/libata-sff.c
+++ work/drivers/ata/libata-sff.c
@@ -2388,7 +2388,8 @@ int ata_pci_sff_activate_host(struct ata
 	struct device *dev = host->dev;
 	struct pci_dev *pdev = to_pci_dev(dev);
 	const char *drv_name = dev_driver_string(host->dev);
-	int legacy_mode = 0, rc;
+	struct ata_port *ap[2] = { host->ports[0], host->ports[1] };
+	int legacy_mode = 0, i, rc;

 	rc = ata_host_start(host);
 	if (rc)
@@ -2422,29 +2423,29 @@ int ata_pci_sff_activate_host(struct ata
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


