Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab1BFMdT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 07:33:19 -0500
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:60866 "EHLO
	relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab1BFM3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 07:29:18 -0500
X-Originating-IP: 217.70.178.40
X-Originating-IP: 82.241.209.44
From: Corentin Chary <corentincj@iksaif.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: Corentin Chary <corentincj@iksaif.net>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 04/18] eeepc-wmi: serialize access to wmi method
Date: Sun,  6 Feb 2011 13:28:29 +0100
Message-Id: <1296995324-5462-5-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <1296995324-5462-1-git-send-email-corentincj@iksaif.net>
References: <1296995324-5462-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

\AMW0.WMBC, which is the main method that we use,
is not reentrant. When wireless hotpluging is enabled,
toggling the status of the wireless device using WMBC will
trigger a notification and the notification handler need to
call WMBC again to get the new status of the device, this
will trigger the following error:

ACPI Error (dswload-0802): [_T_0] Namespace lookup failure, AE_ALREADY_EXISTS
ACPI Exception: AE_ALREADY_EXISTS, During name lookup/catalog (20100428/psloop-231)
ACPI Error (psparse-0537): Method parse/execution failed [\AMW0.WMBC] (Node f7023b88), AE_ALREADY_EXISTS
ACPI: Marking method WMBC as Serialized because of AE_ALREADY_EXISTS error

Since there is currently no way to tell the acpi subsystem to mark
a method as serialized, we do it in eeepc-wmi.

Of course, we could let the first call fail, and then it would work,
but it doesn't seems really clean, and it will make the first
WMBC call return a random value.

This patch was tested on EeePc 1000H with a RaLink RT2860
wireless card using the rt2800pci driver. rt2860sta driver
seems to deadlock when we remove the pci device...

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/eeepc-wmi.c |   78 +++++++++++++++++++++++++++++++++++---
 1 files changed, 72 insertions(+), 6 deletions(-)

diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
index 01bc2b3..eb4c0ce 100644
--- a/drivers/platform/x86/eeepc-wmi.c
+++ b/drivers/platform/x86/eeepc-wmi.c
@@ -137,6 +137,9 @@ struct eeepc_wmi {
 
 	struct hotplug_slot *hotplug_slot;
 	struct mutex hotplug_lock;
+	struct mutex wmi_lock;
+	struct workqueue_struct *hotplug_workqueue;
+	struct work_struct hotplug_work;
 
 	struct eeepc_wmi_debug debug;
 };
@@ -370,15 +373,19 @@ static void eeepc_rfkill_hotplug(struct eeepc_wmi *eeepc)
 {
 	struct pci_dev *dev;
 	struct pci_bus *bus;
-	bool blocked = eeepc_wlan_rfkill_blocked(eeepc);
+	bool blocked;
 	bool absent;
 	u32 l;
 
-	if (eeepc->wlan_rfkill)
-		rfkill_set_sw_state(eeepc->wlan_rfkill, blocked);
+	mutex_lock(&eeepc->wmi_lock);
+	blocked = eeepc_wlan_rfkill_blocked(eeepc);
+	mutex_unlock(&eeepc->wmi_lock);
 
 	mutex_lock(&eeepc->hotplug_lock);
 
+	if (eeepc->wlan_rfkill)
+		rfkill_set_sw_state(eeepc->wlan_rfkill, blocked);
+
 	if (eeepc->hotplug_slot) {
 		bus = pci_find_bus(0, 1);
 		if (!bus) {
@@ -435,7 +442,14 @@ static void eeepc_rfkill_notify(acpi_handle handle, u32 event, void *data)
 	if (event != ACPI_NOTIFY_BUS_CHECK)
 		return;
 
-	eeepc_rfkill_hotplug(eeepc);
+	/*
+	 * We can't call directly eeepc_rfkill_hotplug because most
+	 * of the time WMBC is still being executed and not reetrant.
+	 * There is currently no way to tell ACPICA that  we want this
+	 * method to be serialized, we schedule a eeepc_rfkill_hotplug
+	 * call later, in a safer context.
+	 */
+	queue_work(eeepc->hotplug_workqueue, &eeepc->hotplug_work);
 }
 
 static int eeepc_register_rfkill_notifier(struct eeepc_wmi *eeepc,
@@ -508,6 +522,14 @@ static struct hotplug_slot_ops eeepc_hotplug_slot_ops = {
 	.get_power_status = eeepc_get_adapter_status,
 };
 
+static void eeepc_hotplug_work(struct work_struct *work)
+{
+	struct eeepc_wmi *eeepc;
+
+	eeepc = container_of(work, struct eeepc_wmi, hotplug_work);
+	eeepc_rfkill_hotplug(eeepc);
+}
+
 static int eeepc_setup_pci_hotplug(struct eeepc_wmi *eeepc)
 {
 	int ret = -ENOMEM;
@@ -518,6 +540,13 @@ static int eeepc_setup_pci_hotplug(struct eeepc_wmi *eeepc)
 		return -ENODEV;
 	}
 
+	eeepc->hotplug_workqueue =
+		create_singlethread_workqueue("hotplug_workqueue");
+	if (!eeepc->hotplug_workqueue)
+		goto error_workqueue;
+
+	INIT_WORK(&eeepc->hotplug_work, eeepc_hotplug_work);
+
 	eeepc->hotplug_slot = kzalloc(sizeof(struct hotplug_slot), GFP_KERNEL);
 	if (!eeepc->hotplug_slot)
 		goto error_slot;
@@ -547,6 +576,8 @@ error_info:
 	kfree(eeepc->hotplug_slot);
 	eeepc->hotplug_slot = NULL;
 error_slot:
+	destroy_workqueue(eeepc->hotplug_workqueue);
+error_workqueue:
 	return ret;
 }
 
@@ -575,6 +606,34 @@ static void eeepc_rfkill_query(struct rfkill *rfkill, void *data)
 	rfkill_set_sw_state(rfkill, !(retval & 0x1));
 }
 
+static int eeepc_rfkill_wlan_set(void *data, bool blocked)
+{
+	struct eeepc_wmi *eeepc = data;
+	int ret;
+
+	/*
+	 * This handler is enabled only if hotplug is enabled.
+	 * In this case, the eeepc_wmi_set_devstate() will
+	 * trigger a wmi notification and we need to wait
+	 * this call to finish before being able to call
+	 * any wmi method
+	 */
+	mutex_lock(&eeepc->wmi_lock);
+	ret = eeepc_rfkill_set((void *)(long)EEEPC_WMI_DEVID_WLAN, blocked);
+	mutex_unlock(&eeepc->wmi_lock);
+	return ret;
+}
+
+static void eeepc_rfkill_wlan_query(struct rfkill *rfkill, void *data)
+{
+	eeepc_rfkill_query(rfkill, (void *)(long)EEEPC_WMI_DEVID_WLAN);
+}
+
+static const struct rfkill_ops eeepc_rfkill_wlan_ops = {
+	.set_block = eeepc_rfkill_wlan_set,
+	.query = eeepc_rfkill_wlan_query,
+};
+
 static const struct rfkill_ops eeepc_rfkill_ops = {
 	.set_block = eeepc_rfkill_set,
 	.query = eeepc_rfkill_query,
@@ -603,8 +662,12 @@ static int eeepc_new_rfkill(struct eeepc_wmi *eeepc,
 	if (!retval || retval == 0x00060000)
 		return -ENODEV;
 
-	*rfkill = rfkill_alloc(name, &eeepc->platform_device->dev, type,
-			       &eeepc_rfkill_ops, (void *)(long)dev_id);
+	if (dev_id == EEEPC_WMI_DEVID_WLAN && eeepc->hotplug_wireless)
+		*rfkill = rfkill_alloc(name, &eeepc->platform_device->dev, type,
+				       &eeepc_rfkill_wlan_ops, eeepc);
+	else
+		*rfkill = rfkill_alloc(name, &eeepc->platform_device->dev, type,
+				       &eeepc_rfkill_ops, (void *)(long)dev_id);
 
 	if (!*rfkill)
 		return -EINVAL;
@@ -636,6 +699,8 @@ static void eeepc_wmi_rfkill_exit(struct eeepc_wmi *eeepc)
 	eeepc_rfkill_hotplug(eeepc);
 	if (eeepc->hotplug_slot)
 		pci_hp_deregister(eeepc->hotplug_slot);
+	if (eeepc->hotplug_workqueue)
+		destroy_workqueue(eeepc->hotplug_workqueue);
 
 	if (eeepc->bluetooth_rfkill) {
 		rfkill_unregister(eeepc->bluetooth_rfkill);
@@ -654,6 +719,7 @@ static int eeepc_wmi_rfkill_init(struct eeepc_wmi *eeepc)
 	int result = 0;
 
 	mutex_init(&eeepc->hotplug_lock);
+	mutex_init(&eeepc->wmi_lock);
 
 	result = eeepc_new_rfkill(eeepc, &eeepc->wlan_rfkill,
 				  "eeepc-wlan", RFKILL_TYPE_WLAN,
-- 
1.7.4.rc3

