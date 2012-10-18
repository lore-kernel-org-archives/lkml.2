Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569Ab2JRUvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 16:51:18 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:24786 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756450Ab2JRUvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 16:51:13 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org, Tang Chen <tangchen@cn.fujitsu.com>,
        Yinghai Lu <yinghai@kernel.org>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org
Subject: [PATCH 1/3] ACPI: Introduce a new acpi handle to determine HID match.
Date: Thu, 18 Oct 2012 13:50:09 -0700
Message-Id: <1350593430-24470-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
References: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tang Chen <tangchen@cn.fujitsu.com>

We need to find out if one handle is for root bridge, and install notify
handler for it to handle pci root bus hot add.
At that time, root bridge acpi device is not created yet.

So acpi_match_device_ids() will not work.

This patch add a function to check if new acpi handle's HID matches a list
of IDs.  The new api use acpi_device_info instead acpi_device.

-v2: updated changelog, also check length for string info...
     change checking sequence by moving string comaring close to for loop.
					- Yinghai

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
---
 drivers/acpi/scan.c     |   33 +++++++++++++++++++++++++++++++++
 include/acpi/acpi_bus.h |    2 ++
 2 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 5dfec09..33ca993 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -312,6 +312,39 @@ int acpi_match_device_ids(struct acpi_device *device,
 }
 EXPORT_SYMBOL(acpi_match_device_ids);
 
+int acpi_match_object_info_ids(struct acpi_device_info *info,
+			       const struct acpi_device_id *ids)
+{
+	const struct acpi_device_id *id;
+	char *str;
+	u32 len;
+	int i;
+
+	len = info->hardware_id.length;
+	if (len) {
+		str = info->hardware_id.string;
+		if (str)
+			for (id = ids; id->id[0]; id++)
+				if (!strcmp((char *)id->id, str))
+					return 0;
+	}
+
+	for (i = 0; i < info->compatible_id_list.count; i++) {
+		len = info->compatible_id_list.ids[i].length;
+		if (!len)
+			continue;
+		str = info->compatible_id_list.ids[i].string;
+		if (!str)
+			continue;
+		for (id = ids; id->id[0]; id++)
+			if (!strcmp((char *)id->id, str))
+				return 0;
+	}
+
+	return -ENOENT;
+}
+EXPORT_SYMBOL(acpi_match_object_info_ids);
+
 static void acpi_free_ids(struct acpi_device *device)
 {
 	struct acpi_hardware_id *id, *tmp;
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 608f92f..6ac415c 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -374,6 +374,8 @@ int acpi_bus_start(struct acpi_device *device);
 acpi_status acpi_bus_get_ejd(acpi_handle handle, acpi_handle * ejd);
 int acpi_match_device_ids(struct acpi_device *device,
 			  const struct acpi_device_id *ids);
+int acpi_match_object_info_ids(struct acpi_device_info *info,
+			       const struct acpi_device_id *ids);
 int acpi_create_dir(struct acpi_device *);
 void acpi_remove_dir(struct acpi_device *);
 
-- 
1.7.7

