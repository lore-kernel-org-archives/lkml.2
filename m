Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393Ab2JRUz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 16:55:26 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:42653 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756477Ab2JRUvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 16:51:14 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org, Jiang Liu <jiang.liu@huawei.com>,
        Yinghai Lu <yinghai@kernel.org>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org
Subject: [PATCH 2/3] PCI: correctly detect ACPI PCI host bridge objects
Date: Thu, 18 Oct 2012 13:50:11 -0700
Message-Id: <1350593430-24470-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
References: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

The code in pci_root_hp.c depends on function acpi_is_root_bridge()
to check whether an ACPI object is a PCI host bridge or not.
If an ACPI device hasn't been created for the ACPI object yet,
function acpi_is_root_bridge() will return false even if the object
is a PCI host bridge object. That behavior will cause two issues:
1) No ACPI notification handler installed for PCI host bridges absent
   at startup, so hotplug events for those bridges won't be handled.
2) rescan_root_bridge() can't reenumerate offlined PCI host bridges
   because the ACPI devices have been already destroyed.

So use acpi_match_object_info_ids() to correctly detect PCI host bridges.

-v2: update to use acpi_match_object_info_ids() from Tang Chen  - Yinghai

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
---
 drivers/acpi/pci_root_hp.c |   25 ++++++++++++++++++++++++-
 1 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/pci_root_hp.c b/drivers/acpi/pci_root_hp.c
index 2aebf78..3edec7f 100644
--- a/drivers/acpi/pci_root_hp.c
+++ b/drivers/acpi/pci_root_hp.c
@@ -19,6 +19,12 @@ struct acpi_root_bridge {
 	u32 flags;
 };
 
+static const struct acpi_device_id root_device_ids[] = {
+	{"PNP0A03", 0},
+	{"PNP0A08", 0},
+	{"", 0},
+};
+
 /* bridge flags */
 #define ROOT_BRIDGE_HAS_EJ0	(0x00000002)
 #define ROOT_BRIDGE_HAS_PS3	(0x00000080)
@@ -256,6 +262,23 @@ static void handle_hotplug_event_root(acpi_handle handle, u32 type,
 				_handle_hotplug_event_root);
 }
 
+static bool acpi_is_root_bridge_object(acpi_handle handle)
+{
+	struct acpi_device_info *info = NULL;
+	acpi_status status;
+	bool ret;
+
+	status = acpi_get_object_info(handle, &info);
+	if (ACPI_FAILURE(status))
+		return false;
+
+	ret = !acpi_match_object_info_ids(info, root_device_ids);
+
+	kfree(info);
+
+	return ret;
+}
+
 static acpi_status __init
 find_root_bridges(acpi_handle handle, u32 lvl, void *context, void **rv)
 {
@@ -264,7 +287,7 @@ find_root_bridges(acpi_handle handle, u32 lvl, void *context, void **rv)
 				      .pointer = objname };
 	int *count = (int *)context;
 
-	if (!acpi_is_root_bridge(handle))
+	if (!acpi_is_root_bridge_object(handle))
 		return AE_OK;
 
 	(*count)++;
-- 
1.7.7

