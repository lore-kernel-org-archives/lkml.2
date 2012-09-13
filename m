Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758551Ab2IMQXc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 12:23:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56343 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754578Ab2IMQXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 12:23:30 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Corentin Chary <corentincj@iksaif.net>, Matthew Garrett <mjg@redhat.com>
Cc: Jiang Liu <liuj97@gmail.com>, Jiang Liu <jiang.liu@huawei.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH] eeepc-laptop: fix device reference count leakage in eeepc_rfkill_hotplug()
Date: Fri, 14 Sep 2012 00:21:59 +0800
Message-Id: <1347553319-6867-1-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a device reference count leakage issue in function
eeepc_rfkill_hotplug().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/platform/x86/eeepc-laptop.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index dab91b4..5ca2641 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -610,12 +610,12 @@ static void eeepc_rfkill_hotplug(struct eeepc_laptop *eeepc, acpi_handle handle)
 
 		if (!bus) {
 			pr_warn("Unable to find PCI bus 1?\n");
-			goto out_unlock;
+			goto out_put_dev;
 		}
 
 		if (pci_bus_read_config_dword(bus, 0, PCI_VENDOR_ID, &l)) {
 			pr_err("Unable to read PCI config space?\n");
-			goto out_unlock;
+			goto out_put_dev;
 		}
 
 		absent = (l == 0xffffffff);
@@ -627,7 +627,7 @@ static void eeepc_rfkill_hotplug(struct eeepc_laptop *eeepc, acpi_handle handle)
 				absent ? "absent" : "present");
 			pr_warn("skipped wireless hotplug as probably "
 				"inappropriate for this model\n");
-			goto out_unlock;
+			goto out_put_dev;
 		}
 
 		if (!blocked) {
@@ -635,7 +635,7 @@ static void eeepc_rfkill_hotplug(struct eeepc_laptop *eeepc, acpi_handle handle)
 			if (dev) {
 				/* Device already present */
 				pci_dev_put(dev);
-				goto out_unlock;
+				goto out_put_dev;
 			}
 			dev = pci_scan_single_device(bus, 0);
 			if (dev) {
@@ -650,6 +650,8 @@ static void eeepc_rfkill_hotplug(struct eeepc_laptop *eeepc, acpi_handle handle)
 				pci_dev_put(dev);
 			}
 		}
+out_put_dev:
+		pci_dev_put(port);
 	}
 
 out_unlock:
-- 
1.7.9.5

