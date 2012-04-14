Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab2DNPxp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 11:53:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33566 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262Ab2DNPxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 11:53:20 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Mike Sterling <Mike.Sterling@microsoft.com>
Subject: [PATCH 2/2] ata_piix: defer disks to the Hyper-V drivers by default
Date: Sat, 14 Apr 2012 16:53:16 +0100
Message-Id: <1334418796-11473-3-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1334418796-11473-1-git-send-email-apw@canonical.com>
References: <4F87351E.9040905@pobox.com>
 <1334418796-11473-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we are hosted on a Microsoft Hyper-V hypervisor the guest disks
are exposed both via the Hyper-V paravirtualised drivers and via an
emulated SATA disk drive.  In this case we want to use the paravirtualised
drivers if we can as they are much more efficient.  Note that the Hyper-V
paravirtualised drivers only expose the virtual hard disk devices, the
CDROM/DVD devices must still be enumerated.

Mark the host controller ATA_HOST_IGNORE_ATA to prevent enumeration
of disk devices.

BugLink: http://bugs.launchpad.net/bugs/929545
BugLink: http://bugs.launchpad.net/bugs/942316
Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 drivers/ata/ata_piix.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 68013f9..b52d8ab 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -94,6 +94,9 @@
 #include <scsi/scsi_host.h>
 #include <linux/libata.h>
 #include <linux/dmi.h>
+#ifdef CONFIG_X86
+#include <asm/hypervisor.h>
+#endif
 
 #define DRV_NAME	"ata_piix"
 #define DRV_VERSION	"2.13"
@@ -1567,6 +1570,11 @@ static bool piix_broken_system_poweroff(struct pci_dev *pdev)
  *	Zero on success, or -ERRNO value.
  */
 
+#ifdef CONFIG_X86
+static int prefer_ms_hyperv = 1;
+module_param(prefer_ms_hyperv, int, 0);
+#endif
+
 static int __devinit piix_init_one(struct pci_dev *pdev,
 				   const struct pci_device_id *ent)
 {
@@ -1667,6 +1675,18 @@ static int __devinit piix_init_one(struct pci_dev *pdev,
 	}
 	host->flags |= ATA_HOST_PARALLEL_SCAN;
 
+#ifdef CONFIG_X86
+	/* On Hyper-V hypervisors the disks are exposed on both the emulated
+	 * SATA controller and on the paravirtualised drivers.  The CD/DVD
+	 * devices are only exposed on the emulated controller.  Request we
+	 * ignore ATA devices on this host.
+	 */
+	if (prefer_ms_hyperv && x86_hyper == &x86_hyper_ms_hyperv) {
+		host->flags |= ATA_HOST_IGNORE_ATA;
+		dev_info(&pdev->dev, "Hyper-V hypervisor detected, ignoring ATA disks\n");
+	}
+#endif
+
 	pci_set_master(pdev);
 	return ata_pci_sff_activate_host(host, ata_bmdma_interrupt, sht);
 }
-- 
1.7.9.5

