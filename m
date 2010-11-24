Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412Ab0KXUSm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 15:18:42 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:59405 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756365Ab0KXUSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 15:18:41 -0500
Date: Wed, 24 Nov 2010 20:18:34 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: corentincj@iksaif.net, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: eeepc: rfkill on 900A defunct
Message-ID: <20101124201834.GA7760@srcf.ucam.org>
References: <4CED26EF.5000109@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CED26EF.5000109@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hm. As a shorter term fix, can you try this (entirely untested!) 
approach?

diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index b2edfdc..8f817d6 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -574,8 +574,9 @@ static bool eeepc_wlan_rfkill_blocked(struct eeepc_laptop *eeepc)
 	return true;
 }
 
-static void eeepc_rfkill_hotplug(struct eeepc_laptop *eeepc)
+static void eeepc_rfkill_hotplug(struct eeepc_laptop *eeepc, acpi_handle handle)
 {
+	struct pci_dev *port;
 	struct pci_dev *dev;
 	struct pci_bus *bus;
 	bool blocked = eeepc_wlan_rfkill_blocked(eeepc);
@@ -588,9 +589,17 @@ static void eeepc_rfkill_hotplug(struct eeepc_laptop *eeepc)
 	mutex_lock(&eeepc->hotplug_lock);
 
 	if (eeepc->hotplug_slot) {
-		bus = pci_find_bus(0, 1);
+		port = acpi_get_pci_dev(handle);
+
+		if (!port) {
+			pr_warning("Unable to find port\n");
+			goto out_unlock;
+		}
+
+		bus = port->subordinate;
+
 		if (!bus) {
-			pr_warning("Unable to find PCI bus 1?\n");
+			pr_warning("Unable to find PCI bus?\n");
 			goto out_unlock;
 		}
 
@@ -636,6 +645,17 @@ out_unlock:
 	mutex_unlock(&eeepc->hotplug_lock);
 }
 
+static void eeepc_rfkill_hotplug_update(struct eeepc_laptop *eeepc, char *node)
+{
+	acpi_status status = AE_OK;
+	acpi_handle handle;
+
+	status = acpi_get_handle(NULL, node, &handle);
+
+	if (ACPI_SUCCESS(status))
+		eeepc_rfkill_hotplug(eeepc, handle);
+}
+
 static void eeepc_rfkill_notify(acpi_handle handle, u32 event, void *data)
 {
 	struct eeepc_laptop *eeepc = data;
@@ -643,7 +663,7 @@ static void eeepc_rfkill_notify(acpi_handle handle, u32 event, void *data)
 	if (event != ACPI_NOTIFY_BUS_CHECK)
 		return;
 
-	eeepc_rfkill_hotplug(eeepc);
+	eeepc_rfkill_hotplug(eeepc, handle);
 }
 
 static int eeepc_register_rfkill_notifier(struct eeepc_laptop *eeepc,
@@ -661,6 +681,11 @@ static int eeepc_register_rfkill_notifier(struct eeepc_laptop *eeepc,
 						     eeepc);
 		if (ACPI_FAILURE(status))
 			pr_warning("Failed to register notify on %s\n", node);
+		/*
+		 * Refresh pci hotplug in case the rfkill state was
+		 * changed during setup.
+		 */
+		eeepc_rfkill_hotplug(eeepc, handle);
 	} else
 		return -ENODEV;
 
@@ -682,6 +707,12 @@ static void eeepc_unregister_rfkill_notifier(struct eeepc_laptop *eeepc,
 		if (ACPI_FAILURE(status))
 			pr_err("Error removing rfkill notify handler %s\n",
 				node);
+			/*
+			 * Refresh pci hotplug in case the rfkill
+			 * state was changed after
+			 * eeepc_unregister_rfkill_notifier()
+			 */
+		eeepc_rfkill_hotplug(eeepc, handle);
 	}
 }
 
@@ -805,11 +836,7 @@ static void eeepc_rfkill_exit(struct eeepc_laptop *eeepc)
 		rfkill_destroy(eeepc->wlan_rfkill);
 		eeepc->wlan_rfkill = NULL;
 	}
-	/*
-	 * Refresh pci hotplug in case the rfkill state was changed after
-	 * eeepc_unregister_rfkill_notifier()
-	 */
-	eeepc_rfkill_hotplug(eeepc);
+
 	if (eeepc->hotplug_slot)
 		pci_hp_deregister(eeepc->hotplug_slot);
 
@@ -878,11 +905,6 @@ static int eeepc_rfkill_init(struct eeepc_laptop *eeepc)
 	eeepc_register_rfkill_notifier(eeepc, "\\_SB.PCI0.P0P5");
 	eeepc_register_rfkill_notifier(eeepc, "\\_SB.PCI0.P0P6");
 	eeepc_register_rfkill_notifier(eeepc, "\\_SB.PCI0.P0P7");
-	/*
-	 * Refresh pci hotplug in case the rfkill state was changed during
-	 * setup.
-	 */
-	eeepc_rfkill_hotplug(eeepc);
 
 exit:
 	if (result && result != -ENODEV)
@@ -917,8 +939,11 @@ static int eeepc_hotk_restore(struct device *device)
 	struct eeepc_laptop *eeepc = dev_get_drvdata(device);
 
 	/* Refresh both wlan rfkill state and pci hotplug */
-	if (eeepc->wlan_rfkill)
-		eeepc_rfkill_hotplug(eeepc);
+	if (eeepc->wlan_rfkill) {
+		eeepc_rfkill_hotplug_update(eeepc, "\\_SB.PCI0.P0P5");
+		eeepc_rfkill_hotplug_update(eeepc, "\\_SB.PCI0.P0P6");
+		eeepc_rfkill_hotplug_update(eeepc, "\\_SB.PCI0.P0P7");
+	}
 
 	if (eeepc->bluetooth_rfkill)
 		rfkill_set_sw_state(eeepc->bluetooth_rfkill,
-- 
Matthew Garrett | mjg59@srcf.ucam.org
