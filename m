Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab2DPLUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 07:20:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38043 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005Ab2DPLUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 07:20:34 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Mike Sterling <Mike.Sterling@microsoft.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 2/2] UBUNTU: SAUCE: ata_piix: defer disks to the Hyper-V drivers by default
Date: Mon, 16 Apr 2012 12:20:29 +0100
Message-Id: <1334575229-7493-3-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1334575229-7493-1-git-send-email-apw@canonical.com>
References: <20120414170223.24f6ea31@pyramind.ukuu.org.uk>
 <1334575229-7493-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we are hosted on a Microsoft Hyper-V hypervisor the guest disks
are exposed both via the Hyper-V paravirtualised drivers and via an
emulated SATA disk drive.  In this case we want to use the paravirtualised
drivers if we can as they are much more efficient.  Note that the Hyper-V
paravirtualised drivers only expose the virtual hard disk devices, the
CDROM/DVD devices must still be enumerated.

Mark the host controller ATA_HOST_IGNORE_ATA to prevent enumeration of
disk devices.

BugLink: http://bugs.launchpad.net/bugs/929545
BugLink: http://bugs.launchpad.net/bugs/942316
Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 drivers/ata/ata_piix.c |   38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 68013f9..05e0ffa 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -1552,6 +1552,41 @@ static bool piix_broken_system_poweroff(struct pci_dev *pdev)
 	return false;
 }
 
+static int prefer_ms_hyperv = 1;
+module_param(prefer_ms_hyperv, int, 0);
+
+static void piix_ignore_devices_quirk(struct ata_host *host)
+{
+	static const struct dmi_system_id ignore_devices[] = {
+		{
+			/* On Hyper-V hypervisors the disks are exposed on
+			 * both the emulated SATA controller and on the
+			 * paravirtualised drivers.  The CD/DVD devices
+			 * are only exposed on the emulated controller.
+			 * Request we * ignore ATA devices on this host.
+			 */
+			.ident = "Hyper-V Virtual Machine",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR,
+						"Microsoft Corporation"),
+				DMI_MATCH(DMI_PRODUCT_NAME, "Virtual Machine"),
+			},
+			.driver_data = (void *)ATA_HOST_IGNORE_ATA,
+		},
+
+		{ }	/* terminate list */
+	};
+	const struct dmi_system_id *dmi = dmi_first_match(ignore_devices);
+
+	if (dmi) {
+		unsigned long flags = (unsigned long)dmi->driver_data;
+
+		host->flags |= flags;
+		dev_info(host->dev, "%s detected, device ignore set %08lx\n",
+			dmi->ident, flags);
+	}
+}
+
 /**
  *	piix_init_one - Register PIIX ATA PCI device with kernel services
  *	@pdev: PCI device to register
@@ -1667,6 +1702,9 @@ static int __devinit piix_init_one(struct pci_dev *pdev,
 	}
 	host->flags |= ATA_HOST_PARALLEL_SCAN;
 
+	/* Allow hosts to specify device types to ignore when scanning. */
+	piix_ignore_devices_quirk(host);
+
 	pci_set_master(pdev);
 	return ata_pci_sff_activate_host(host, ata_bmdma_interrupt, sht);
 }
-- 
1.7.9.5

