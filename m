Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757665Ab1KJXvM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 18:51:12 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:55640 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360Ab1KJXvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 18:51:11 -0500
Date: Fri, 11 Nov 2011 06:47:17 +0800
From: shencanquan@huawei.com
Subject: [PATCH] acpi: Fix CPU hot removal problem
X-Originating-IP: [10.166.29.43]
To: lenb@kernel.org
Cc: bhelgaas@google.com, xiaowei.yang@huawei.com, hanweidong@huawei.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shen canquan <shencanquan@huawei.com>
Message-id: <1320965237-8628-1-git-send-email-shencanquan@huawei.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.0.4
Content-type: text/plain
Content-transfer-encoding: 7BIT
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shen canquan <shencanquan@huawei.com>

We run linux as a guest in Xen environment. When we used the xen tools (xm
vcpu-set <n>) to hot add and remove vcpu to and from the guest, we
encountered the failure on vcpu removal. We found the reason is that it
did't go to really remove cpu in the cpu removal code path.

This patch adds acpi_bus_hot_remove_device in acpi_process_hotplug_notify to
fix this issue. With this patch, it works fine for us.

Signed-off-by: Canquan Shen <shencanquan@huawei.com>
---
 drivers/acpi/processor_driver.c |   13 +------------
 drivers/acpi/scan.c             |    4 ++--
 include/acpi/acpi_bus.h         |    1 +
 3 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index a4e0f1b..8429688 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -665,18 +665,7 @@ static void acpi_processor_hotplug_notify(acpi_handle handle,
 	case ACPI_NOTIFY_EJECT_REQUEST:
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 				  "received ACPI_NOTIFY_EJECT_REQUEST\n"));
-
-		if (acpi_bus_get_device(handle, &device)) {
-			printk(KERN_ERR PREFIX
-				    "Device don't exist, dropping EJECT\n");
-			break;
-		}
-		pr = acpi_driver_data(device);
-		if (!pr) {
-			printk(KERN_ERR PREFIX
-				    "Driver data is NULL, dropping EJECT\n");
-			return;
-		}
+		acpi_bus_hot_remove_device(handle);
 		break;
 	default:
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 449c556..6dfb4a7 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -83,7 +83,7 @@ acpi_device_modalias_show(struct device *dev, struct device_attribute *attr, cha
 }
 static DEVICE_ATTR(modalias, 0444, acpi_device_modalias_show, NULL);
 
-static void acpi_bus_hot_remove_device(void *context)
+void acpi_bus_hot_remove_device(void *context)
 {
 	struct acpi_device *device;
 	acpi_handle handle = context;
@@ -129,7 +129,7 @@ static void acpi_bus_hot_remove_device(void *context)
 	 * TBD: _EJD support.
 	 */
 	status = acpi_evaluate_object(handle, "_EJ0", &arg_list, NULL);
-	if (ACPI_FAILURE(status))
+	if (ACPI_FAILURE(status) && (status != AE_NOT_FOUND))
 		printk(KERN_WARNING PREFIX
 				"Eject device failed\n");
 
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 6cd5b64..756e8d1 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -342,6 +342,7 @@ int acpi_match_device_ids(struct acpi_device *device,
 			  const struct acpi_device_id *ids);
 int acpi_create_dir(struct acpi_device *);
 void acpi_remove_dir(struct acpi_device *);
+void acpi_bus_hot_remove_device(void *context);
 
 /*
  * Bind physical devices with ACPI devices
-- 
1.7.6.msysgit.0

