Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069Ab0CQUEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 16:04:34 -0400
Received: from havoc.gtf.org ([69.61.125.42]:37227 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755854Ab0CQUEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 16:04:32 -0400
Date: Wed, 17 Mar 2010 16:04:31 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20100317200431.GA24631@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The ATA timeout bug is still being worked, testers welcome.  Patch posted
to linux-ide and LKML was also posted to the tracking bug,
http://bugzilla.kernel.org/show_bug.cgi?id=15537


In the meantime, here are some other minor bug fixes,


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ahci.c |   66 +++++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 52 insertions(+), 14 deletions(-)

Shane Huang (1):
      ahci: pp->active_link is not reliable when FBS is enabled

Tejun Heo (2):
      ahci: add missing nv IDs
      ahci: use BIOS date in broken_suspend list

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 6bd930b..fdc9bcb 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -641,6 +641,21 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(NVIDIA, 0x055a), board_ahci_yesncq },	/* MCP67 */
 	{ PCI_VDEVICE(NVIDIA, 0x055b), board_ahci_yesncq },	/* MCP67 */
 	{ PCI_VDEVICE(NVIDIA, 0x0580), board_ahci_yesncq },	/* Linux ID */
+	{ PCI_VDEVICE(NVIDIA, 0x0581), board_ahci_yesncq },	/* Linux ID */
+	{ PCI_VDEVICE(NVIDIA, 0x0582), board_ahci_yesncq },	/* Linux ID */
+	{ PCI_VDEVICE(NVIDIA, 0x0583), board_ahci_yesncq },	/* Linux ID */
+	{ PCI_VDEVICE(NVIDIA, 0x0584), board_ahci_yesncq },	/* Linux ID */
+	{ PCI_VDEVICE(NVIDIA, 0x0585), board_ahci_yesncq },	/* Linux ID */
+	{ PCI_VDEVICE(NVIDIA, 0x0586), board_ahci_yesncq },	/* Linux ID */
+	{ PCI_VDEVICE(NVIDIA, 0x0587), board_ahci_yesncq },	/* Linux ID */
+	{ PCI_VDEVICE(NVIDIA, 0x0588), board_ahci_yesncq },	/* Linux ID */
+	{ PCI_VDEVICE(NVIDIA, 0x0589), board_ahci_yesncq },	/* Linux ID */
+	{ PCI_VDEVICE(NVIDIA, 0x058a), board_ahci_yesncq },	/* Linux ID */
+	{ PCI_VDEVICE(NVIDIA, 0x058b), board_ahci_yesncq },	/* Linux ID */
+	{ PCI_VDEVICE(NVIDIA, 0x058c), board_ahci_yesncq },	/* Linux ID */
+	{ PCI_VDEVICE(NVIDIA, 0x058d), board_ahci_yesncq },	/* Linux ID */
+	{ PCI_VDEVICE(NVIDIA, 0x058e), board_ahci_yesncq },	/* Linux ID */
+	{ PCI_VDEVICE(NVIDIA, 0x058f), board_ahci_yesncq },	/* Linux ID */
 	{ PCI_VDEVICE(NVIDIA, 0x07f0), board_ahci_yesncq },	/* MCP73 */
 	{ PCI_VDEVICE(NVIDIA, 0x07f1), board_ahci_yesncq },	/* MCP73 */
 	{ PCI_VDEVICE(NVIDIA, 0x07f2), board_ahci_yesncq },	/* MCP73 */
@@ -2263,7 +2278,7 @@ static void ahci_port_intr(struct ata_port *ap)
 	struct ahci_port_priv *pp = ap->private_data;
 	struct ahci_host_priv *hpriv = ap->host->private_data;
 	int resetting = !!(ap->pflags & ATA_PFLAG_RESETTING);
-	u32 status, qc_active;
+	u32 status, qc_active = 0;
 	int rc;
 
 	status = readl(port_mmio + PORT_IRQ_STAT);
@@ -2321,11 +2336,22 @@ static void ahci_port_intr(struct ata_port *ap)
 		}
 	}
 
-	/* pp->active_link is valid iff any command is in flight */
-	if (ap->qc_active && pp->active_link->sactive)
-		qc_active = readl(port_mmio + PORT_SCR_ACT);
-	else
-		qc_active = readl(port_mmio + PORT_CMD_ISSUE);
+	/* pp->active_link is not reliable once FBS is enabled, both
+	 * PORT_SCR_ACT and PORT_CMD_ISSUE should be checked because
+	 * NCQ and non-NCQ commands may be in flight at the same time.
+	 */
+	if (pp->fbs_enabled) {
+		if (ap->qc_active) {
+			qc_active = readl(port_mmio + PORT_SCR_ACT);
+			qc_active |= readl(port_mmio + PORT_CMD_ISSUE);
+		}
+	} else {
+		/* pp->active_link is valid iff any command is in flight */
+		if (ap->qc_active && pp->active_link->sactive)
+			qc_active = readl(port_mmio + PORT_SCR_ACT);
+		else
+			qc_active = readl(port_mmio + PORT_CMD_ISSUE);
+	}
 
 	rc = ata_qc_complete_multiple(ap, qc_active);
 
@@ -3022,6 +3048,14 @@ static bool ahci_broken_suspend(struct pci_dev *pdev)
 		 * On HP dv[4-6] and HDX18 with earlier BIOSen, link
 		 * to the harddisk doesn't become online after
 		 * resuming from STR.  Warn and fail suspend.
+		 *
+		 * http://bugzilla.kernel.org/show_bug.cgi?id=12276
+		 *
+		 * Use dates instead of versions to match as HP is
+		 * apparently recycling both product and version
+		 * strings.
+		 *
+		 * http://bugzilla.kernel.org/show_bug.cgi?id=15462
 		 */
 		{
 			.ident = "dv4",
@@ -3030,7 +3064,7 @@ static bool ahci_broken_suspend(struct pci_dev *pdev)
 				DMI_MATCH(DMI_PRODUCT_NAME,
 					  "HP Pavilion dv4 Notebook PC"),
 			},
-			.driver_data = "F.30", /* cutoff BIOS version */
+			.driver_data = "20090105",	/* F.30 */
 		},
 		{
 			.ident = "dv5",
@@ -3039,7 +3073,7 @@ static bool ahci_broken_suspend(struct pci_dev *pdev)
 				DMI_MATCH(DMI_PRODUCT_NAME,
 					  "HP Pavilion dv5 Notebook PC"),
 			},
-			.driver_data = "F.16", /* cutoff BIOS version */
+			.driver_data = "20090506",	/* F.16 */
 		},
 		{
 			.ident = "dv6",
@@ -3048,7 +3082,7 @@ static bool ahci_broken_suspend(struct pci_dev *pdev)
 				DMI_MATCH(DMI_PRODUCT_NAME,
 					  "HP Pavilion dv6 Notebook PC"),
 			},
-			.driver_data = "F.21",	/* cutoff BIOS version */
+			.driver_data = "20090423",	/* F.21 */
 		},
 		{
 			.ident = "HDX18",
@@ -3057,7 +3091,7 @@ static bool ahci_broken_suspend(struct pci_dev *pdev)
 				DMI_MATCH(DMI_PRODUCT_NAME,
 					  "HP HDX18 Notebook PC"),
 			},
-			.driver_data = "F.23",	/* cutoff BIOS version */
+			.driver_data = "20090430",	/* F.23 */
 		},
 		/*
 		 * Acer eMachines G725 has the same problem.  BIOS
@@ -3065,6 +3099,8 @@ static bool ahci_broken_suspend(struct pci_dev *pdev)
 		 * work.  Inbetween, there are V1.06, V2.06 and V3.03
 		 * that we don't have much idea about.  For now,
 		 * blacklist anything older than V3.04.
+		 *
+		 * http://bugzilla.kernel.org/show_bug.cgi?id=15104
 		 */
 		{
 			.ident = "G725",
@@ -3072,19 +3108,21 @@ static bool ahci_broken_suspend(struct pci_dev *pdev)
 				DMI_MATCH(DMI_SYS_VENDOR, "eMachines"),
 				DMI_MATCH(DMI_PRODUCT_NAME, "eMachines G725"),
 			},
-			.driver_data = "V3.04",	/* cutoff BIOS version */
+			.driver_data = "20091216",	/* V3.04 */
 		},
 		{ }	/* terminate list */
 	};
 	const struct dmi_system_id *dmi = dmi_first_match(sysids);
-	const char *ver;
+	int year, month, date;
+	char buf[9];
 
 	if (!dmi || pdev->bus->number || pdev->devfn != PCI_DEVFN(0x1f, 2))
 		return false;
 
-	ver = dmi_get_system_info(DMI_BIOS_VERSION);
+	dmi_get_date(DMI_BIOS_DATE, &year, &month, &date);
+	snprintf(buf, sizeof(buf), "%04d%02d%02d", year, month, date);
 
-	return !ver || strcmp(ver, dmi->driver_data) < 0;
+	return strcmp(buf, dmi->driver_data) < 0;
 }
 
 static bool ahci_broken_online(struct pci_dev *pdev)
