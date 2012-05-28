Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab2E1FJ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 01:09:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:32734 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411Ab2E1FJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 01:09:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="145291392"
From: Lin Ming <ming.m.lin@intel.com>
To: Jeff Garzik <jgarzik@pobox.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Aaron Lu <aaron.lu@amd.com>, Holger Macht <holger@homac.de>,
        Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH v4 04/13] libata: use correct PCI devices
Date: Mon, 28 May 2012 13:08:31 +0800
Message-Id: <1338181720-4149-5-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1338181720-4149-1-git-send-email-ming.m.lin@intel.com>
References: <1338181720-4149-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Holger Macht <holger@homac.de>

Commit 9a6d6a2ddabbd32c07f6a38b659e5f3db319fa5a made ata ports parent
devices of scsi hosts, so we need to go yet another level up to be able
to use the correct PCI devices.

Signed-off-by: Holger Macht <holger@homac.de>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/ata/libata-acpi.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 762e0c8..df4e21a 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -976,7 +976,7 @@ static int ata_acpi_bind_host(struct device *dev, int host, acpi_handle *handle)
 	if (ap->flags & ATA_FLAG_ACPI_SATA)
 		return -ENODEV;
 
-	*handle = acpi_get_child(DEVICE_ACPI_HANDLE(dev->parent), ap->port_no);
+	*handle = acpi_get_child(DEVICE_ACPI_HANDLE(dev->parent->parent), ap->port_no);
 
 	if (!*handle)
 		return -ENODEV;
@@ -1010,13 +1010,13 @@ static int ata_acpi_find_device(struct device *dev, acpi_handle *handle)
 	unsigned int host, channel, id, lun;
 
 	if (sscanf(dev_name(dev), "host%u", &host) == 1) {
-		if (!is_pci_ata(dev->parent))
+		if (!is_pci_ata(dev->parent->parent))
 			return -ENODEV;
 
 		return ata_acpi_bind_host(dev, host, handle);
 	} else if (sscanf(dev_name(dev), "%d:%d:%d:%d",
 			&host, &channel, &id, &lun) == 4) {
-		if (!is_pci_ata(dev->parent->parent->parent))
+		if (!is_pci_ata(dev->parent->parent->parent->parent))
 			return -ENODEV;
 
 		return ata_acpi_bind_device(dev, channel, id, handle);
-- 
1.7.2.5

