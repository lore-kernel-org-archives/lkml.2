Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422699Ab2JLKc6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 06:32:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:43149 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757951Ab2JLKcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 06:32:55 -0400
X-IronPort-AV: E=Sophos;i="4.80,576,1344182400"; 
   d="scan'208";a="5989987"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: yinghai@kernel.org, lenb@kernel.org, bhelgaas@google.com,
        izumi.taku@jp.fujitsu.com, jiang.liu@huawei.com,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Subject: [PATCH 2/3] Do not use acpi_device to find pci root bridge in _init code.
Date: Fri, 12 Oct 2012 18:31:29 +0800
Message-Id: <1350037890-5899-3-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1350037890-5899-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1350037890-5899-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/12 18:32:26,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/12 18:32:29,
	Serialize complete at 2012/10/12 18:32:29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the kernel is being initialized, and some hardwares are not added
to system, there won't be acpi_device structs for these devices. But
acpi_is_root_bridge() depends on acpi_device struct. As a result, all
the not-added root bridge will not be judged as a root bridge in
find_root_bridges(). And further more, no handle_hotplug_event_root()
notifier will be installed for them.

This patch introduces a new api to find all root bridges in system by
getting HID directly from ACPI namespace, not depending on acpi_device
struct.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 drivers/acpi/pci_root.c |   27 ++++++++++++++++++++++-----
 1 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 7d0fb03..3819bee 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -128,9 +128,6 @@ EXPORT_SYMBOL_GPL(acpi_get_pci_rootbridge_handle);
 /**
  * acpi_is_root_bridge - determine whether an ACPI CA node is a PCI root bridge
  * @handle - the ACPI CA node in question.
- *
- * Note: we could make this API take a struct acpi_device * instead, but
- * for now, it's more convenient to operate on an acpi_handle.
  */
 int acpi_is_root_bridge(acpi_handle handle)
 {
@@ -138,8 +135,28 @@ int acpi_is_root_bridge(acpi_handle handle)
 	struct acpi_device *device;
 
 	ret = acpi_bus_get_device(handle, &device);
-	if (ret)
-		return 0;
+	if (ret) {
+		/**
+		 * If a device is not added to the system yet, there won't be
+		 * an acpi_device struct for it. But it doesn't mean it is not
+		 * a PCI root bridge. In this case we need to get HID and CID
+		 * from ACPI namespace directly.
+		 */
+		struct acpi_device_info *info;
+		acpi_status status;
+		status = acpi_get_object_info(handle, &info);
+		if (ACPI_FAILURE(status)) {
+			printk(KERN_ERR PREFIX "%s: Error reading"
+					       "device info\n", __func__);
+			return 0;
+		}
+
+		ret = acpi_match_object_info_ids(info, root_device_ids);
+		if (ret)
+			return 0;
+		else
+			return 1;
+	}
 
 	ret = acpi_match_device_ids(device, root_device_ids);
 	if (ret)
-- 
1.7.1

