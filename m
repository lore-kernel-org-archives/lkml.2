Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699Ab2HGQUy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 12:20:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51364 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755670Ab2HGQUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 12:20:50 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Yijing Wang <wangyijing@huawei.com>, Xinwei Hu <huxinwei@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>
Subject: [RFC PATCH v1 15/22] PCI/eeepc: use PCI bus lock to avoid race conditions
Date: Wed,  8 Aug 2012 00:10:55 +0800
Message-Id: <1344355862-2726-16-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344355862-2726-1-git-send-email-jiang.liu@huawei.com>
References: <1344355862-2726-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses PCI bus lock mechanism to avoid race conditions when doing
PCI device hotplug through eeepc driver. It also fixes a PCI device reference
count leakage issue because acpi_get_pci_dev() holds a reference to the
device returned.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/platform/x86/eeepc-laptop.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index dab91b4..25c4176 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -606,16 +606,16 @@ static void eeepc_rfkill_hotplug(struct eeepc_laptop *eeepc, acpi_handle handle)
 			goto out_unlock;
 		}
 
-		bus = port->subordinate;
+		bus = pci_lock_subordinate(port, PCI_BUS_STATE_WORKING);
 
 		if (!bus) {
 			pr_warn("Unable to find PCI bus 1?\n");
-			goto out_unlock;
+			goto out_put_dev;
 		}
 
 		if (pci_bus_read_config_dword(bus, 0, PCI_VENDOR_ID, &l)) {
 			pr_err("Unable to read PCI config space?\n");
-			goto out_unlock;
+			goto out_unlock_bus;
 		}
 
 		absent = (l == 0xffffffff);
@@ -627,7 +627,7 @@ static void eeepc_rfkill_hotplug(struct eeepc_laptop *eeepc, acpi_handle handle)
 				absent ? "absent" : "present");
 			pr_warn("skipped wireless hotplug as probably "
 				"inappropriate for this model\n");
-			goto out_unlock;
+			goto out_unlock_bus;
 		}
 
 		if (!blocked) {
@@ -635,7 +635,7 @@ static void eeepc_rfkill_hotplug(struct eeepc_laptop *eeepc, acpi_handle handle)
 			if (dev) {
 				/* Device already present */
 				pci_dev_put(dev);
-				goto out_unlock;
+				goto out_unlock_bus;
 			}
 			dev = pci_scan_single_device(bus, 0);
 			if (dev) {
@@ -650,6 +650,11 @@ static void eeepc_rfkill_hotplug(struct eeepc_laptop *eeepc, acpi_handle handle)
 				pci_dev_put(dev);
 			}
 		}
+
+out_unlock_bus:
+		pci_bus_unlock(bus);
+out_put_dev:
+		pci_dev_put(port);
 	}
 
 out_unlock:
@@ -757,7 +762,7 @@ static struct hotplug_slot_ops eeepc_hotplug_slot_ops = {
 static int eeepc_setup_pci_hotplug(struct eeepc_laptop *eeepc)
 {
 	int ret = -ENOMEM;
-	struct pci_bus *bus = pci_find_bus(0, 1);
+	struct pci_bus *bus = pci_get_bus(0, 1);
 
 	if (!bus) {
 		pr_err("Unable to find wifi PCI bus\n");
@@ -785,6 +790,8 @@ static int eeepc_setup_pci_hotplug(struct eeepc_laptop *eeepc)
 		goto error_register;
 	}
 
+	pci_bus_put(bus);
+
 	return 0;
 
 error_register:
@@ -793,6 +800,7 @@ error_info:
 	kfree(eeepc->hotplug_slot);
 	eeepc->hotplug_slot = NULL;
 error_slot:
+	pci_bus_put(bus);
 	return ret;
 }
 
-- 
1.7.9.5

