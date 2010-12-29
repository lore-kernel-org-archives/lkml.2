Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab0L2MXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 07:23:31 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35014 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752096Ab0L2MXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 07:23:14 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 2/2] PCI / PM: Report wakeup events before resuming devices
Date: Wed, 29 Dec 2010 13:22:08 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc8+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        linux-pci@vger.kernel.org
References: <201012291320.22777.rjw@sisk.pl>
In-Reply-To: <201012291320.22777.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012291322.08521.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make wakeup events be reported by the PCI subsystem before attempting
to resume devices or queuing up runtime resume requests for them,
because wakeup events should be reported as soon as they have been
detected.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci-acpi.c |    2 +-
 drivers/pci/pci.c      |    2 +-
 drivers/pci/pcie/pme.c |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/pci/pci-acpi.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-acpi.c
+++ linux-2.6/drivers/pci/pci-acpi.c
@@ -46,9 +46,9 @@ static void pci_acpi_wake_dev(acpi_handl
 	struct pci_dev *pci_dev = context;
 
 	if (event == ACPI_NOTIFY_DEVICE_WAKE && pci_dev) {
+		pci_wakeup_event(pci_dev);
 		pci_check_pme_status(pci_dev);
 		pm_runtime_resume(&pci_dev->dev);
-		pci_wakeup_event(pci_dev);
 		if (pci_dev->subordinate)
 			pci_pme_wakeup_bus(pci_dev->subordinate);
 	}
Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -1311,8 +1311,8 @@ bool pci_check_pme_status(struct pci_dev
 static int pci_pme_wakeup(struct pci_dev *dev, void *ign)
 {
 	if (pci_check_pme_status(dev)) {
-		pm_request_resume(&dev->dev);
 		pci_wakeup_event(dev);
+		pm_request_resume(&dev->dev);
 	}
 	return 0;
 }
Index: linux-2.6/drivers/pci/pcie/pme.c
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/pme.c
+++ linux-2.6/drivers/pci/pcie/pme.c
@@ -103,8 +103,8 @@ static bool pcie_pme_walk_bus(struct pci
 	list_for_each_entry(dev, &bus->devices, bus_list) {
 		/* Skip PCIe devices in case we started from a root port. */
 		if (!pci_is_pcie(dev) && pci_check_pme_status(dev)) {
-			pm_request_resume(&dev->dev);
 			pci_wakeup_event(dev);
+			pm_request_resume(&dev->dev);
 			ret = true;
 		}
 
@@ -206,8 +206,8 @@ static void pcie_pme_handle_request(stru
 		/* The device is there, but we have to check its PME status. */
 		found = pci_check_pme_status(dev);
 		if (found) {
-			pm_request_resume(&dev->dev);
 			pci_wakeup_event(dev);
+			pm_request_resume(&dev->dev);
 		}
 		pci_dev_put(dev);
 	} else if (devfn) {

