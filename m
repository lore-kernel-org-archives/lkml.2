Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab1IXGLE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 02:11:04 -0400
Received: from szxga04-in.huawei.com ([119.145.14.67]:49181 "EHLO
	szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab1IXGLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 02:11:02 -0400
Date: Sat, 24 Sep 2011 14:10:48 +0800
From: "canquan.shen" <shencanquan@huawei.com>
Subject: [PATCH v5] acpi: Fix CPU hot removal problem
X-Originating-IP: [10.166.80.130]
To: len.brown@intel.com
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "shemminger@vyatta.com" <shemminger@vyatta.com>,
        "yakui.zhao@intel.com" <yakui.zhao@intel.com>,
        "xiaowei.yang@huawei.com" <xiaowei.yang@huawei.com>,
        hanweidong <hanweidong@huawei.com>, linqiangmin@huawei.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        khalid.aziz@hp.com
Message-id: <4E7D7468.4040506@huawei.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:6.0.2) Gecko/20110902
 Thunderbird/6.0.2
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We run linux as a guest in Xen environment. When we used the xen tools
(xm vcpu-set <n>) to hot add and remove vcpu to and from the guest, we
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

diff --git a/drivers/acpi/processor_driver.c 
b/drivers/acpi/processor_driver.c
index a4e0f1b..8429688 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -665,18 +665,7 @@ static void 
acpi_processor_hotplug_notify(acpi_handle handle,
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
@@ -83,7 +83,7 @@ acpi_device_modalias_show(struct device *dev, struct 
device_attribute *attr, cha
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

