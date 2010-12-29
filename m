Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423Ab0L2MX2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 07:23:28 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35013 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089Ab0L2MXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 07:23:14 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 1/2] PCI / PM: Use pm_wakeup_event() directly for reporting wakeup events
Date: Wed, 29 Dec 2010 13:21:23 +0100
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
Message-Id: <201012291321.23899.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

After recent changes related to wakeup events pm_wakeup_event()
automatically checks if the given device is configured to signal
wakeup, so pci_wakeup_event() may be a static inline function
calling pm_wakeup_event() directly.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci.c   |   16 ----------------
 drivers/pci/pci.h   |    6 ++++++
 include/linux/pci.h |    1 -
 3 files changed, 6 insertions(+), 17 deletions(-)

Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -1300,22 +1300,6 @@ bool pci_check_pme_status(struct pci_dev
 	return ret;
 }
 
-/*
- * Time to wait before the system can be put into a sleep state after reporting
- * a wakeup event signaled by a PCI device.
- */
-#define PCI_WAKEUP_COOLDOWN	100
-
-/**
- * pci_wakeup_event - Report a wakeup event related to a given PCI device.
- * @dev: Device to report the wakeup event for.
- */
-void pci_wakeup_event(struct pci_dev *dev)
-{
-	if (device_may_wakeup(&dev->dev))
-		pm_wakeup_event(&dev->dev, PCI_WAKEUP_COOLDOWN);
-}
-
 /**
  * pci_pme_wakeup - Wake up a PCI device if its PME Status bit is set.
  * @dev: Device to handle.
Index: linux-2.6/drivers/pci/pci.h
===================================================================
--- linux-2.6.orig/drivers/pci/pci.h
+++ linux-2.6/drivers/pci/pci.h
@@ -74,6 +74,12 @@ extern void pci_pm_init(struct pci_dev *
 extern void platform_pci_wakeup_init(struct pci_dev *dev);
 extern void pci_allocate_cap_save_buffers(struct pci_dev *dev);
 
+static inline void pci_wakeup_event(struct pci_dev *dev)
+{
+	/* Wait 100 ms before the system can be put into a sleep state. */
+	pm_wakeup_event(&dev->dev, 100);
+}
+
 static inline bool pci_is_bridge(struct pci_dev *pci_dev)
 {
 	return !!(pci_dev->subordinate);
Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -820,7 +820,6 @@ int pci_prepare_to_sleep(struct pci_dev 
 int pci_back_from_sleep(struct pci_dev *dev);
 bool pci_dev_run_wake(struct pci_dev *dev);
 bool pci_check_pme_status(struct pci_dev *dev);
-void pci_wakeup_event(struct pci_dev *dev);
 void pci_pme_wakeup_bus(struct pci_bus *bus);
 
 static inline int pci_enable_wake(struct pci_dev *dev, pci_power_t state,

