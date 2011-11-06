Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348Ab1KFVTL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 16:19:11 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53508 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795Ab1KFVTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 16:19:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] PCI / ACPI / PM: Avoid resuming devices that don't signal PME
Date: Sun, 6 Nov 2011 22:21:46 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111062221.46819.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Modify pci_acpi_wake_dev() to avoid resuming PME-capable devices
whose PME Status bits are not set, which may happen currently if
several devices are associated with the same wakeup GPE and all
of them are notified whenever at least one of them signals PME.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci-acpi.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

Index: linux/drivers/pci/pci-acpi.c
===================================================================
--- linux.orig/drivers/pci/pci-acpi.c
+++ linux/drivers/pci/pci-acpi.c
@@ -45,16 +45,20 @@ static void pci_acpi_wake_dev(acpi_handl
 {
 	struct pci_dev *pci_dev = context;
 
-	if (event == ACPI_NOTIFY_DEVICE_WAKE && pci_dev) {
+	if (event != ACPI_NOTIFY_DEVICE_WAKE || !pci_dev)
+		return;
+
+	if (!pci_dev->pm_cap || !pci_dev->pme_support
+	     || pci_check_pme_status(pci_dev)) {
 		if (pci_dev->pme_poll)
 			pci_dev->pme_poll = false;
 
 		pci_wakeup_event(pci_dev);
-		pci_check_pme_status(pci_dev);
 		pm_runtime_resume(&pci_dev->dev);
-		if (pci_dev->subordinate)
-			pci_pme_wakeup_bus(pci_dev->subordinate);
 	}
+
+	if (pci_dev->subordinate)
+		pci_pme_wakeup_bus(pci_dev->subordinate);
 }
 
 /**
