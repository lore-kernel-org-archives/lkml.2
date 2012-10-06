Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab2JFPcX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 11:32:23 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34290 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab2JFPcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 11:32:19 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: Hanjun Guo <guohanjun@huawei.com>, Yijing Wang <wangyijing@huawei.com>,
        Gong Chen <gong.chen@linux.intel.com>,
        Jiang Liu <jiang.liu@huawei.com>, Tony Luck <tony.luck@intel.com>,
        Huang Ying <ying.huang@intel.com>, Bob Moore <robert.moore@intel.com>,
        Len Brown <lenb@kernel.org>,
        "Srivatsa S . Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [RFC PATCH v3 10/28] ACPIHP: implement utility functions to support system device hotplug
Date: Sat,  6 Oct 2012 23:27:18 +0800
Message-Id: <1349537256-21670-11-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349537256-21670-1-git-send-email-jiang.liu@huawei.com>
References: <1349537256-21670-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements some utility functions to support system device hotplug.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Hanjun Guo <guohanjun@huawei.com>
---
 drivers/acpi/hotplug/core.c |   77 +++++++++++++++++++++++++++++++++++++++++++
 include/acpi/acpi_hotplug.h |    9 +++++
 2 files changed, 86 insertions(+)

diff --git a/drivers/acpi/hotplug/core.c b/drivers/acpi/hotplug/core.c
index ffd3b54..ffc9e40 100644
--- a/drivers/acpi/hotplug/core.c
+++ b/drivers/acpi/hotplug/core.c
@@ -605,6 +605,83 @@ int acpihp_remove_device_list(struct klist *dev_list)
 }
 EXPORT_SYMBOL_GPL(acpihp_remove_device_list);
 
+bool acpihp_slot_present(struct acpihp_slot *slot)
+{
+	acpi_status status;
+	unsigned long long sta;
+
+	status = acpihp_slot_get_status(slot, &sta);
+	if (ACPI_FAILURE(status)) {
+		ACPIHP_SLOT_WARN(slot, "fails to get status.\n");
+		return false;
+	}
+
+	return !!(sta & ACPI_STA_DEVICE_PRESENT);
+}
+EXPORT_SYMBOL_GPL(acpihp_slot_present);
+
+bool acpihp_slot_powered(struct acpihp_slot *slot)
+{
+	acpi_status status;
+	unsigned long long sta;
+
+	/* hotplug slot must implement _STA method */
+	status = acpihp_slot_get_status(slot, &sta);
+	if (ACPI_FAILURE(status)) {
+		ACPIHP_SLOT_WARN(slot, "fails to get status.\n");
+		return false;
+	}
+
+	if ((sta & ACPI_STA_DEVICE_PRESENT) &&
+	    ((sta & ACPI_STA_DEVICE_ENABLED) ||
+	    (sta & ACPI_STA_DEVICE_FUNCTIONING)))
+		return true;
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(acpihp_slot_powered);
+
+void acpihp_slot_set_flag(struct acpihp_slot *slot, u32 flags)
+{
+	mutex_lock(&slot->slot_mutex);
+	slot->flags |= flags;
+	mutex_unlock(&slot->slot_mutex);
+}
+EXPORT_SYMBOL_GPL(acpihp_slot_set_flag);
+
+void acpihp_slot_clear_flag(struct acpihp_slot *slot, u32 flags)
+{
+	mutex_lock(&slot->slot_mutex);
+	slot->flags &= ~flags;
+	mutex_unlock(&slot->slot_mutex);
+}
+EXPORT_SYMBOL_GPL(acpihp_slot_clear_flag);
+
+u32 acpihp_slot_get_flag(struct acpihp_slot *slot, u32 flags)
+{
+	mutex_lock(&slot->slot_mutex);
+	flags &= slot->flags;
+	mutex_unlock(&slot->slot_mutex);
+
+	return flags;
+}
+EXPORT_SYMBOL_GPL(acpihp_slot_get_flag);
+
+void acpihp_slot_change_state(struct acpihp_slot *slot,
+			      enum acpihp_slot_state state)
+{
+	if (state < ACPIHP_SLOT_STATE_UNKNOWN ||
+	    state > ACPIHP_SLOT_STATE_MAX) {
+		ACPIHP_SLOT_WARN(slot, "slot state %d is invalid.\n", state);
+		BUG_ON(state);
+	}
+
+	mutex_lock(&slot->slot_mutex);
+	slot->state = state;
+	mutex_unlock(&slot->slot_mutex);
+}
+EXPORT_SYMBOL_GPL(acpihp_slot_change_state);
+
 /* SYSFS interfaces */
 static ssize_t acpihp_slot_object_show(struct device *d,
 		struct device_attribute *attr, char *buf)
diff --git a/include/acpi/acpi_hotplug.h b/include/acpi/acpi_hotplug.h
index 97febcb..0506f73 100644
--- a/include/acpi/acpi_hotplug.h
+++ b/include/acpi/acpi_hotplug.h
@@ -289,6 +289,15 @@ extern int acpihp_slot_remove_device(struct acpihp_slot *slot,
 				     struct device *dev);
 extern int acpihp_remove_device_list(struct klist *dev_list);
 
+/* Utility Functions */
+extern bool acpihp_slot_present(struct acpihp_slot *slot);
+extern bool acpihp_slot_powered(struct acpihp_slot *slot);
+extern void acpihp_slot_set_flag(struct acpihp_slot *slot, u32 flags);
+extern void acpihp_slot_clear_flag(struct acpihp_slot *slot, u32 flags);
+extern u32 acpihp_slot_get_flag(struct acpihp_slot *slot, u32 flags);
+extern void acpihp_slot_change_state(struct acpihp_slot *slot,
+				     enum acpihp_slot_state state);
+
 extern int acpihp_debug;
 
 #define ACPIHP_WARN(fmt, ...) \
-- 
1.7.9.5

