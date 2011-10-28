Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948Ab1J1DVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 23:21:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:42903 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754897Ab1J1DVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 23:21:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,416,1315206000"; 
   d="scan'208";a="78819812"
Subject: [RFC] ata port runtime pm
From: Lin Ming <ming.m.lin@intel.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
        Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Priyanka Gupta <ankaguptaca@gmail.com>,
        Zhang Rui <rui.zhang@intel.com>, "Huang, Ying" <ying.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Oct 2011 11:21:12 +0800
Message-ID: <1319772072.24236.0.camel@minggr>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all

I send this out early to get feedback how to do ata port runtime pm.

There was some discussion early this year trying to add runtime pm
support to sata_mv controller driver.
http://marc.info/?l=linux-ide&m=129403126729115&w=2

Here I focus on ata port runtime pm, not controller.

In below conceptual patch, I did

0. Set autosuspend delay to 3 minutes for ata port
1. Split a new function ata_port_request_pm from ata_host_request_pm
2. Add device_type "ata_port_type" which implements callbacks for
   runtime pm core
3. Resume port in ata_scsi_queuecmd if needed
4. Request auto suspend in ata_scsi_queuecmd

CAUTION: this patch DOES NOT work at all.
I just threw it out for discussion.

Any idea?
Thanks.

Lin Ming
---
 drivers/ata/libata-core.c |  126 +++++++++++++++++++++++++++++++++------------
 drivers/ata/libata-scsi.c |    6 ++
 2 files changed, 99 insertions(+), 33 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 4a3a5ae..e0c1a15 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -66,6 +66,7 @@
 #include <asm/byteorder.h>
 #include <linux/cdrom.h>
 #include <linux/ratelimit.h>
+#include <linux/pm_runtime.h>
 
 #include "libata.h"
 #include "libata-transport.h"
@@ -5234,51 +5235,62 @@ bool ata_link_offline(struct ata_link *link)
 }
 
 #ifdef CONFIG_PM
-static int ata_host_request_pm(struct ata_host *host, pm_message_t mesg,
+static int ata_port_request_pm(struct ata_port *ap, pm_message_t mesg,
 			       unsigned int action, unsigned int ehi_flags,
 			       int wait)
 {
+	struct ata_link *link;
 	unsigned long flags;
-	int i, rc;
+	int rc;
 
-	for (i = 0; i < host->n_ports; i++) {
-		struct ata_port *ap = host->ports[i];
-		struct ata_link *link;
+	/* Previous resume operation might still be in
+	 * progress.  Wait for PM_PENDING to clear.
+	 */
+	if (ap->pflags & ATA_PFLAG_PM_PENDING) {
+		ata_port_wait_eh(ap);
+		WARN_ON(ap->pflags & ATA_PFLAG_PM_PENDING);
+	}
 
-		/* Previous resume operation might still be in
-		 * progress.  Wait for PM_PENDING to clear.
-		 */
-		if (ap->pflags & ATA_PFLAG_PM_PENDING) {
-			ata_port_wait_eh(ap);
-			WARN_ON(ap->pflags & ATA_PFLAG_PM_PENDING);
-		}
+	/* request PM ops to EH */
+	spin_lock_irqsave(ap->lock, flags);
 
-		/* request PM ops to EH */
-		spin_lock_irqsave(ap->lock, flags);
+	ap->pm_mesg = mesg;
+	if (wait) {
+		rc = 0;
+		ap->pm_result = &rc;
+	}
 
-		ap->pm_mesg = mesg;
-		if (wait) {
-			rc = 0;
-			ap->pm_result = &rc;
-		}
+	ap->pflags |= ATA_PFLAG_PM_PENDING;
+	ata_for_each_link(link, ap, HOST_FIRST) {
+		link->eh_info.action |= action;
+		link->eh_info.flags |= ehi_flags;
+	}
 
-		ap->pflags |= ATA_PFLAG_PM_PENDING;
-		ata_for_each_link(link, ap, HOST_FIRST) {
-			link->eh_info.action |= action;
-			link->eh_info.flags |= ehi_flags;
-		}
+	ata_port_schedule_eh(ap);
 
-		ata_port_schedule_eh(ap);
+	spin_unlock_irqrestore(ap->lock, flags);
 
-		spin_unlock_irqrestore(ap->lock, flags);
+	/* wait and check result */
+	if (wait) {
+		ata_port_wait_eh(ap);
+		WARN_ON(ap->pflags & ATA_PFLAG_PM_PENDING);
+	}
 
-		/* wait and check result */
-		if (wait) {
-			ata_port_wait_eh(ap);
-			WARN_ON(ap->pflags & ATA_PFLAG_PM_PENDING);
-			if (rc)
-				return rc;
-		}
+	return rc;
+}
+
+static int ata_host_request_pm(struct ata_host *host, pm_message_t mesg,
+			       unsigned int action, unsigned int ehi_flags,
+			       int wait)
+{
+	int i, rc;
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap = host->ports[i];
+
+		rc = ata_port_request_pm(ap, mesg, action, ehi_flags, wait);
+		if (rc)
+			return rc;
 	}
 
 	return 0;
@@ -5874,6 +5886,45 @@ void ata_host_init(struct ata_host *host, struct device *dev,
 	host->ops = ops;
 }
 
+#define to_ata_port(d) container_of(d, struct ata_port, tdev)
+
+static int ata_port_runtime_suspend(struct device *dev)
+{
+	struct ata_port *ap = to_ata_port(dev);
+	struct Scsi_Host *shost = ap->scsi_host;
+	int rc;
+
+	/* TODO: sync with hardware access */
+
+	if (shost->host_busy)
+		return -EBUSY;
+
+	rc = ata_port_request_pm(ap, PMSG_SUSPEND, 0, ATA_EHI_QUIET, 1);
+	return rc;
+}
+
+static int ata_port_runtime_resume(struct device *dev)
+{
+	struct ata_port *ap = to_ata_port(dev);
+	int rc;
+
+	rc = ata_port_request_pm(ap, PMSG_ON, ATA_EH_RESET,
+		ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET, 1);
+	return rc;
+}
+
+static const struct dev_pm_ops ata_port_pm_ops = {
+	.runtime_suspend = ata_port_runtime_suspend,
+	.runtime_resume = ata_port_runtime_resume,
+};
+
+static struct device_type ata_port_type = {
+	.name = "ata_port",
+#ifdef CONFIG_PM
+	.pm = &ata_port_pm_ops,
+#endif
+};
+
 int ata_port_probe(struct ata_port *ap)
 {
 	int rc = 0;
@@ -5903,6 +5954,15 @@ int ata_port_probe(struct ata_port *ap)
 		rc = ata_bus_probe(ap);
 		DPRINTK("ata%u: bus probe end\n", ap->print_id);
 	}
+
+	ap->tdev.type = &ata_port_type;
+	pm_runtime_set_active(&ap->tdev);
+	pm_runtime_use_autosuspend(&ap->tdev);
+	/* 3 minutes idle to auto suspend */
+	pm_runtime_set_autosuspend_delay(&ap->tdev, 180*1000);
+	pm_runtime_enable(&ap->tdev);
+	pm_request_autosuspend(&ap->tdev);
+
 	return rc;
 }
 
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 46d087f..88fc7fe 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -48,6 +48,7 @@
 #include <linux/hdreg.h>
 #include <linux/uaccess.h>
 #include <linux/suspend.h>
+#include <linux/pm_runtime.h>
 #include <asm/unaligned.h>
 
 #include "libata.h"
@@ -3208,6 +3209,11 @@ int ata_scsi_queuecmd(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
 
 	ap = ata_shost_to_port(shost);
 
+	if (pm_runtime_suspended(&ap->tdev))
+		pm_runtime_resume(&ap->tdev);
+	pm_runtime_mark_last_busy(&ap->tdev);
+	pm_request_autosuspend(&ap->tdev);
+
 	spin_lock_irqsave(ap->lock, irq_flags);
 
 	ata_scsi_dump_cdb(ap, cmd);



