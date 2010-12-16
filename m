Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab0LPQA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 11:00:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33228 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756104Ab0LPQAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 11:00:24 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] PCI / Hotplug: Fix unexpected driver unregister in pciehp_acpi.c
Date: Thu, 16 Dec 2010 16:59:39 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc6+; KDE/4.4.4; x86_64; ; )
Cc: linux-pci@vger.kernel.org,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012161659.39804.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

If pcie_ports_disabled is set, pcie_port_service_register() returns
error code and select_detection_mode() should not attempt to
unregister dummy_driver and use dummy_slots.  It should return
PCIEHP_DETECT_ACPI immediately instead.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/hotplug/pciehp_acpi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/pci/hotplug/pciehp_acpi.c
===================================================================
--- linux-2.6.orig/drivers/pci/hotplug/pciehp_acpi.c
+++ linux-2.6/drivers/pci/hotplug/pciehp_acpi.c
@@ -115,7 +115,8 @@ static struct pcie_port_service_driver _
 static int __init select_detection_mode(void)
 {
 	struct dummy_slot *slot, *tmp;
-	pcie_port_service_register(&dummy_driver);
+	if (pcie_port_service_register(&dummy_driver))
+		return PCIEHP_DETECT_ACPI;
 	pcie_port_service_unregister(&dummy_driver);
 	list_for_each_entry_safe(slot, tmp, &dummy_slots, list) {
 		list_del(&slot->list);
