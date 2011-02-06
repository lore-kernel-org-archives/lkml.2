Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab1BFM3T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 07:29:19 -0500
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:46825 "EHLO
	relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab1BFM3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 07:29:14 -0500
X-Originating-IP: 217.70.178.42
X-Originating-IP: 82.241.209.44
From: Corentin Chary <corentincj@iksaif.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: Corentin Chary <corentincj@iksaif.net>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 03/18] eeepc-wmi: add hotplug code for Eeepc 1000H
Date: Sun,  6 Feb 2011 13:28:28 +0100
Message-Id: <1296995324-5462-4-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <1296995324-5462-1-git-send-email-corentincj@iksaif.net>
References: <1296995324-5462-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement wireless like hotplug handling (code stolen from eeepc-laptop).

Reminder: on some models rfkill is implemented by logically unplugging the
wireless card from the PCI bus. Despite sending ACPI notifications, this does
not appear to be implemented using standard ACPI hotplug - nor does the
firmware provide the _OSC method required to support native PCIe hotplug.
The only sensible choice appears to be to handle the hotplugging directly in
the platform driver.

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/eeepc-wmi.c |  274 +++++++++++++++++++++++++++++++++++++-
 1 files changed, 273 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
index 0d8217d..01bc2b3 100644
--- a/drivers/platform/x86/eeepc-wmi.c
+++ b/drivers/platform/x86/eeepc-wmi.c
@@ -37,9 +37,12 @@
 #include <linux/backlight.h>
 #include <linux/leds.h>
 #include <linux/rfkill.h>
+#include <linux/pci.h>
+#include <linux/pci_hotplug.h>
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
 #include <linux/platform_device.h>
+#include <linux/dmi.h>
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 
@@ -72,6 +75,14 @@ MODULE_ALIAS("wmi:"EEEPC_WMI_MGMT_GUID);
 #define EEEPC_WMI_DEVID_BLUETOOTH	0x00010013
 #define EEEPC_WMI_DEVID_WWAN3G		0x00010019
 
+static bool hotplug_wireless;
+
+module_param(hotplug_wireless, bool, 0444);
+MODULE_PARM_DESC(hotplug_wireless,
+		 "Enable hotplug for wireless device. "
+		 "If your laptop needs that, please report to "
+		 "acpi4asus-user@lists.sourceforge.net.");
+
 static const struct key_entry eeepc_wmi_keymap[] = {
 	/* Sleep already handled via generic ACPI code */
 	{ KE_IGNORE, NOTIFY_BRNDOWN_MIN, { KEY_BRIGHTNESSDOWN } },
@@ -109,6 +120,8 @@ struct eeepc_wmi_debug {
 };
 
 struct eeepc_wmi {
+	bool hotplug_wireless;
+
 	struct input_dev *inputdev;
 	struct backlight_device *backlight_device;
 	struct platform_device *platform_device;
@@ -122,6 +135,9 @@ struct eeepc_wmi {
 	struct rfkill *bluetooth_rfkill;
 	struct rfkill *wwan3g_rfkill;
 
+	struct hotplug_slot *hotplug_slot;
+	struct mutex hotplug_lock;
+
 	struct eeepc_wmi_debug debug;
 };
 
@@ -177,7 +193,8 @@ static acpi_status eeepc_wmi_get_devstate(u32 dev_id, u32 *retval)
 	u32 tmp;
 
 	status = wmi_evaluate_method(EEEPC_WMI_MGMT_GUID,
-			1, EEEPC_WMI_METHODID_DSTS, &input, &output);
+				     1, EEEPC_WMI_METHODID_DSTS,
+				     &input, &output);
 
 	if (ACPI_FAILURE(status))
 		return status;
@@ -334,6 +351,206 @@ static void eeepc_wmi_led_exit(struct eeepc_wmi *eeepc)
 }
 
 /*
+ * PCI hotplug (for wlan rfkill)
+ */
+static bool eeepc_wlan_rfkill_blocked(struct eeepc_wmi *eeepc)
+{
+	u32 retval;
+	acpi_status status;
+
+	status = eeepc_wmi_get_devstate(EEEPC_WMI_DEVID_WLAN, &retval);
+
+	if (ACPI_FAILURE(status))
+		return false;
+
+	return !(retval & 0x1);
+}
+
+static void eeepc_rfkill_hotplug(struct eeepc_wmi *eeepc)
+{
+	struct pci_dev *dev;
+	struct pci_bus *bus;
+	bool blocked = eeepc_wlan_rfkill_blocked(eeepc);
+	bool absent;
+	u32 l;
+
+	if (eeepc->wlan_rfkill)
+		rfkill_set_sw_state(eeepc->wlan_rfkill, blocked);
+
+	mutex_lock(&eeepc->hotplug_lock);
+
+	if (eeepc->hotplug_slot) {
+		bus = pci_find_bus(0, 1);
+		if (!bus) {
+			pr_warning("Unable to find PCI bus 1?\n");
+			goto out_unlock;
+		}
+
+		if (pci_bus_read_config_dword(bus, 0, PCI_VENDOR_ID, &l)) {
+			pr_err("Unable to read PCI config space?\n");
+			goto out_unlock;
+		}
+		absent = (l == 0xffffffff);
+
+		if (blocked != absent) {
+			pr_warning("BIOS says wireless lan is %s, "
+					"but the pci device is %s\n",
+				blocked ? "blocked" : "unblocked",
+				absent ? "absent" : "present");
+			pr_warning("skipped wireless hotplug as probably "
+					"inappropriate for this model\n");
+			goto out_unlock;
+		}
+
+		if (!blocked) {
+			dev = pci_get_slot(bus, 0);
+			if (dev) {
+				/* Device already present */
+				pci_dev_put(dev);
+				goto out_unlock;
+			}
+			dev = pci_scan_single_device(bus, 0);
+			if (dev) {
+				pci_bus_assign_resources(bus);
+				if (pci_bus_add_device(dev))
+					pr_err("Unable to hotplug wifi\n");
+			}
+		} else {
+			dev = pci_get_slot(bus, 0);
+			if (dev) {
+				pci_remove_bus_device(dev);
+				pci_dev_put(dev);
+			}
+		}
+	}
+
+out_unlock:
+	mutex_unlock(&eeepc->hotplug_lock);
+}
+
+static void eeepc_rfkill_notify(acpi_handle handle, u32 event, void *data)
+{
+	struct eeepc_wmi *eeepc = data;
+
+	if (event != ACPI_NOTIFY_BUS_CHECK)
+		return;
+
+	eeepc_rfkill_hotplug(eeepc);
+}
+
+static int eeepc_register_rfkill_notifier(struct eeepc_wmi *eeepc,
+					  char *node)
+{
+	acpi_status status;
+	acpi_handle handle;
+
+	status = acpi_get_handle(NULL, node, &handle);
+
+	if (ACPI_SUCCESS(status)) {
+		status = acpi_install_notify_handler(handle,
+						     ACPI_SYSTEM_NOTIFY,
+						     eeepc_rfkill_notify,
+						     eeepc);
+		if (ACPI_FAILURE(status))
+			pr_warning("Failed to register notify on %s\n", node);
+	} else
+		return -ENODEV;
+
+	return 0;
+}
+
+static void eeepc_unregister_rfkill_notifier(struct eeepc_wmi *eeepc,
+					     char *node)
+{
+	acpi_status status = AE_OK;
+	acpi_handle handle;
+
+	status = acpi_get_handle(NULL, node, &handle);
+
+	if (ACPI_SUCCESS(status)) {
+		status = acpi_remove_notify_handler(handle,
+						     ACPI_SYSTEM_NOTIFY,
+						     eeepc_rfkill_notify);
+		if (ACPI_FAILURE(status))
+			pr_err("Error removing rfkill notify handler %s\n",
+				node);
+	}
+}
+
+static int eeepc_get_adapter_status(struct hotplug_slot *hotplug_slot,
+				    u8 *value)
+{
+	u32 retval;
+	acpi_status status;
+
+	status = eeepc_wmi_get_devstate(EEEPC_WMI_DEVID_WLAN, &retval);
+
+	if (ACPI_FAILURE(status))
+		return -EIO;
+
+	if (!retval || retval == 0x00060000)
+		return -ENODEV;
+	else
+		*value = (retval & 0x1);
+
+	return 0;
+}
+
+static void eeepc_cleanup_pci_hotplug(struct hotplug_slot *hotplug_slot)
+{
+	kfree(hotplug_slot->info);
+	kfree(hotplug_slot);
+}
+
+static struct hotplug_slot_ops eeepc_hotplug_slot_ops = {
+	.owner = THIS_MODULE,
+	.get_adapter_status = eeepc_get_adapter_status,
+	.get_power_status = eeepc_get_adapter_status,
+};
+
+static int eeepc_setup_pci_hotplug(struct eeepc_wmi *eeepc)
+{
+	int ret = -ENOMEM;
+	struct pci_bus *bus = pci_find_bus(0, 1);
+
+	if (!bus) {
+		pr_err("Unable to find wifi PCI bus\n");
+		return -ENODEV;
+	}
+
+	eeepc->hotplug_slot = kzalloc(sizeof(struct hotplug_slot), GFP_KERNEL);
+	if (!eeepc->hotplug_slot)
+		goto error_slot;
+
+	eeepc->hotplug_slot->info = kzalloc(sizeof(struct hotplug_slot_info),
+					    GFP_KERNEL);
+	if (!eeepc->hotplug_slot->info)
+		goto error_info;
+
+	eeepc->hotplug_slot->private = eeepc;
+	eeepc->hotplug_slot->release = &eeepc_cleanup_pci_hotplug;
+	eeepc->hotplug_slot->ops = &eeepc_hotplug_slot_ops;
+	eeepc_get_adapter_status(eeepc->hotplug_slot,
+				 &eeepc->hotplug_slot->info->adapter_status);
+
+	ret = pci_hp_register(eeepc->hotplug_slot, bus, 0, "eeepc-wifi");
+	if (ret) {
+		pr_err("Unable to register hotplug slot - %d\n", ret);
+		goto error_register;
+	}
+
+	return 0;
+
+error_register:
+	kfree(eeepc->hotplug_slot->info);
+error_info:
+	kfree(eeepc->hotplug_slot);
+	eeepc->hotplug_slot = NULL;
+error_slot:
+	return ret;
+}
+
+/*
  * Rfkill devices
  */
 static int eeepc_rfkill_set(void *data, bool blocked)
@@ -404,11 +621,22 @@ static int eeepc_new_rfkill(struct eeepc_wmi *eeepc,
 
 static void eeepc_wmi_rfkill_exit(struct eeepc_wmi *eeepc)
 {
+	eeepc_unregister_rfkill_notifier(eeepc, "\\_SB.PCI0.P0P5");
+	eeepc_unregister_rfkill_notifier(eeepc, "\\_SB.PCI0.P0P6");
+	eeepc_unregister_rfkill_notifier(eeepc, "\\_SB.PCI0.P0P7");
 	if (eeepc->wlan_rfkill) {
 		rfkill_unregister(eeepc->wlan_rfkill);
 		rfkill_destroy(eeepc->wlan_rfkill);
 		eeepc->wlan_rfkill = NULL;
 	}
+	/*
+	 * Refresh pci hotplug in case the rfkill state was changed after
+	 * eeepc_unregister_rfkill_notifier()
+	 */
+	eeepc_rfkill_hotplug(eeepc);
+	if (eeepc->hotplug_slot)
+		pci_hp_deregister(eeepc->hotplug_slot);
+
 	if (eeepc->bluetooth_rfkill) {
 		rfkill_unregister(eeepc->bluetooth_rfkill);
 		rfkill_destroy(eeepc->bluetooth_rfkill);
@@ -425,6 +653,8 @@ static int eeepc_wmi_rfkill_init(struct eeepc_wmi *eeepc)
 {
 	int result = 0;
 
+	mutex_init(&eeepc->hotplug_lock);
+
 	result = eeepc_new_rfkill(eeepc, &eeepc->wlan_rfkill,
 				  "eeepc-wlan", RFKILL_TYPE_WLAN,
 				  EEEPC_WMI_DEVID_WLAN);
@@ -446,6 +676,23 @@ static int eeepc_wmi_rfkill_init(struct eeepc_wmi *eeepc)
 	if (result && result != -ENODEV)
 		goto exit;
 
+	result = eeepc_setup_pci_hotplug(eeepc);
+	/*
+	 * If we get -EBUSY then something else is handling the PCI hotplug -
+	 * don't fail in this case
+	 */
+	if (result == -EBUSY)
+		result = 0;
+
+	eeepc_register_rfkill_notifier(eeepc, "\\_SB.PCI0.P0P5");
+	eeepc_register_rfkill_notifier(eeepc, "\\_SB.PCI0.P0P6");
+	eeepc_register_rfkill_notifier(eeepc, "\\_SB.PCI0.P0P7");
+	/*
+	 * Refresh pci hotplug in case the rfkill state was changed during
+	 * setup.
+	 */
+	eeepc_rfkill_hotplug(eeepc);
+
 exit:
 	if (result && result != -ENODEV)
 		eeepc_wmi_rfkill_exit(eeepc);
@@ -771,6 +1018,28 @@ error_debugfs:
 /*
  * WMI Driver
  */
+static void eeepc_dmi_check(struct eeepc_wmi *eeepc)
+{
+	const char *model;
+
+	model = dmi_get_system_info(DMI_PRODUCT_NAME);
+	if (!model)
+		return;
+
+	/*
+	 * Whitelist for wlan hotplug
+	 *
+	 * Eeepc 1000H needs the current hotplug code to handle
+	 * Fn+F2 correctly. We may add other Eeepc here later, but
+	 * it seems that most of the laptops supported by eeepc-wmi
+	 * don't need to be on this list
+	 */
+	if (strcmp(model, "1000H") == 0) {
+		eeepc->hotplug_wireless = true;
+		pr_info("wlan hotplug enabled\n");
+	}
+}
+
 static struct platform_device * __init eeepc_wmi_add(void)
 {
 	struct eeepc_wmi *eeepc;
@@ -781,6 +1050,9 @@ static struct platform_device * __init eeepc_wmi_add(void)
 	if (!eeepc)
 		return ERR_PTR(-ENOMEM);
 
+	eeepc->hotplug_wireless = hotplug_wireless;
+	eeepc_dmi_check(eeepc);
+
 	/*
 	 * Register the platform device first.  It is used as a parent for the
 	 * sub-devices below.
-- 
1.7.4.rc3

