Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab2HDMUt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 08:20:49 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:51709 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078Ab2HDMUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 08:20:44 -0400
From: Jiang Liu <jiang.liu@huawei.com>
To: Yinghai Lu <yinghai@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>
CC: Jiang Liu <jiang.liu@huawei.com>, Tony Luck <tony.luck@intel.com>,
        Huang Ying <ying.huang@intel.com>, Bob Moore <robert.moore@intel.com>,
        Len Brown <lenb@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, <linux-kernel@vger.kernel.org>,
        <linux-acpi@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Jiang Liu <liuj97@gmail.com>, Hanjun Guo <guohanjun@huawei.com>
Subject: [RFC PATCH v2 09/16] ACPIHP: implement utility functions to support  system device hotplug
Date: Sat, 4 Aug 2012 20:13:56 +0800
Message-ID: <1344082443-4608-10-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
In-Reply-To: <1344082443-4608-1-git-send-email-jiang.liu@huawei.com>
References: <1344082443-4608-1-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.108.108.229]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

This patch implements some utility funcitons to support system device hotplug.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
Signed-off-by: Hanjun Guo <guohanjun@huawei.com>
---
 drivers/acpi/hotplug/core.c |   80 +++++++++++++++++++++++++++++++++++++++++++
 include/acpi/acpi_hotplug.h |    9 +++++
 2 files changed, 89 insertions(+)

diff --git a/drivers/acpi/hotplug/core.c b/drivers/acpi/hotplug/core.c
index 5e78867..230375e 100644
--- a/drivers/acpi/hotplug/core.c
+++ b/drivers/acpi/hotplug/core.c
@@ -634,6 +634,86 @@ int acpihp_remove_device_list(struct klist *dev_list)
 }
 EXPORT_SYMBOL_GPL(acpihp_remove_device_list);
 
+bool acpihp_slot_present(struct acpihp_slot *slot)
+{
+	acpi_status status;
+	unsigned long long sta;
+
+	/* A hotplug slot must implement ACPI _STA method */
+	status = acpi_evaluate_integer(slot->handle,
+				       METHOD_NAME__STA, NULL, &sta);
+	if (ACPI_FAILURE(status)) {
+		ACPIHP_WARN("fails to evaluate _STA for %p.\n", slot->name);
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
+	status = acpi_evaluate_integer(slot->handle,
+				       METHOD_NAME__STA, NULL, &sta);
+	if (ACPI_FAILURE(status)) {
+		ACPIHP_WARN("fails to evaluate _STA for %p.\n", slot->name);
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
+		ACPIHP_WARN("slot state %d is invalid.\n", state);
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
index 1d43079..a13d9f0 100644
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
 
 #define ACPIHP_DEBUG(fmt, ...) \
-- 
1.7.9.5


