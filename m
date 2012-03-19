Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161852Ab2CSGAc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 02:00:32 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:29458 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161491Ab2CSFsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:48:04 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org
Subject: [PATCH -v3 28/47] PCI, ACPI: Add pci_root_hp hot removal notification support.
Date: Sun, 18 Mar 2012 22:46:17 -0700
Message-Id: <1332135996-13860-29-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
References: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4F66C891.0047,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing hot_remove support for root device.

How to use it?
Find out root bus number to acpi root name mapping from dmesg or /sys

  echo "\_SB.PCIB 3" > /proc/acpi/sci/notify
to remove root bus

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
---
 drivers/acpi/pci_root_hp.c |   61 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 61 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/pci_root_hp.c b/drivers/acpi/pci_root_hp.c
index e07c31b..214adcb 100644
--- a/drivers/acpi/pci_root_hp.c
+++ b/drivers/acpi/pci_root_hp.c
@@ -73,6 +73,12 @@ static void add_acpi_root_bridge(acpi_handle handle)
 	list_add(&bridge->list, &acpi_root_bridge_list);
 }
 
+static void remove_acpi_root_bridge(struct acpi_root_bridge *bridge)
+{
+	list_del(&bridge->list);
+	kfree(bridge);
+}
+
 struct acpi_root_hp_work {
 	struct work_struct work;
 	acpi_handle handle;
@@ -143,6 +149,55 @@ static void handle_root_bridge_insertion(acpi_handle handle)
 		printk(KERN_ERR "cannot start bridge\n");
 }
 
+static int acpi_root_evaluate_object(acpi_handle handle, char *cmd, int val)
+{
+	acpi_status status;
+	struct acpi_object_list arg_list;
+	union acpi_object arg;
+
+	arg_list.count = 1;
+	arg_list.pointer = &arg;
+	arg.type = ACPI_TYPE_INTEGER;
+	arg.integer.value = val;
+
+	status = acpi_evaluate_object(handle, cmd, &arg_list, NULL);
+	if (ACPI_FAILURE(status)) {
+		printk(KERN_WARNING "%s: %s to %d failed\n",
+				 __func__, cmd, val);
+		return -1;
+	}
+
+	return 0;
+}
+
+static void handle_root_bridge_removal(acpi_handle handle,
+		 struct acpi_root_bridge *bridge)
+{
+	u32 flags = 0;
+	struct acpi_device *device;
+
+	if (bridge) {
+		flags = bridge->flags;
+		remove_acpi_root_bridge(bridge);
+	}
+
+	if (!acpi_bus_get_device(handle, &device)) {
+		int ret_val = acpi_bus_trim(device, 1);
+
+		printk(KERN_DEBUG "acpi_bus_trim return %x\n", ret_val);
+	}
+
+	if (flags & ROOT_BRIDGE_HAS_PS3) {
+		acpi_status status;
+
+		status = acpi_evaluate_object(handle, "_PS3", NULL, NULL);
+		if (ACPI_FAILURE(status))
+			printk(KERN_WARNING "%s: _PS3 failed\n", __func__);
+	}
+	if (flags & ROOT_BRIDGE_HAS_EJ0)
+		acpi_root_evaluate_object(handle, "_EJ0", 1);
+}
+
 static void _handle_hotplug_event_root(struct work_struct *work)
 {
 	struct acpi_root_bridge *bridge;
@@ -183,6 +238,12 @@ static void _handle_hotplug_event_root(struct work_struct *work)
 		}
 		break;
 
+	case ACPI_NOTIFY_EJECT_REQUEST:
+		/* request device eject */
+		printk(KERN_DEBUG "%s: Device eject notify on %s\n", __func__,
+				 objname);
+		handle_root_bridge_removal(handle, bridge);
+		break;
 	default:
 		printk(KERN_WARNING "notify_handler: unknown event type 0x%x for %s\n",
 				 type, objname);
-- 
1.7.7

