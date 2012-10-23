Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932964Ab2JWNMD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:12:03 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:10004 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932720Ab2JWNL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:11:56 -0400
X-IronPort-AV: E=Sophos;i="4.80,635,1344182400"; 
   d="scan'208";a="6052697"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: yinghai@kernel.org, bhelgaas@google.com, lenb@kernel.org,
        jiang.liu@huawei.com, izumi.taku@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Improve container_notify_cb() to support container hot-remove.
Date: Tue, 23 Oct 2012 21:10:39 +0800
Message-Id: <1350997839-13260-3-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1350997839-13260-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1350997839-13260-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/23 21:11:11,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/23 21:11:13,
	Serialize complete at 2012/10/23 21:11:13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a new function container_device_remove() to do
the container hot-remove job. It works like the following:

1. call acpi_bus_trim(device, 0) to stop the container device.
2. generate the KOBJ_OFFLINE uevent. (Did I do this correct ?)
3. call acpi_bus_hot_remove_device(), which will call acpi_bus_trim(device, 1)
   to remove the container.

This patch is based on Lu Yinghai's work.
git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-split-pci-root-hp-2

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 drivers/acpi/container.c |   58 ++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 49 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/container.c b/drivers/acpi/container.c
index 643657a..1de4672 100644
--- a/drivers/acpi/container.c
+++ b/drivers/acpi/container.c
@@ -180,6 +180,35 @@ static int container_device_add(struct acpi_device **device, acpi_handle handle)
 	return result;
 }
 
+static int container_device_remove(struct acpi_device *device)
+{
+	int ret;
+	struct acpi_eject_event *ej_event;
+
+	ej_event = kmalloc(sizeof(*ej_event), GFP_KERNEL);
+	if (!ej_event)
+		return -ENOMEM;
+
+	ej_event->device = device;
+	ej_event->event = ACPI_NOTIFY_EJECT_REQUEST;
+
+	/* stop container device at first */
+	ret = acpi_bus_trim(device, 0);
+	printk(KERN_WARNING "acpi_bus_trim stop return %x\n", ret);
+	if (ret)
+		return ret;
+
+	/* event originated from ACPI eject notification */
+	device->flags.eject_pending = 1;
+
+	/* send the uevent before remove the device */
+	kobject_uevent(&device->dev.kobj, KOBJ_OFFLINE);
+
+	acpi_bus_hot_remove_device(ej_event);
+
+	return 0;
+}
+
 static void __container_notify_cb(struct work_struct *work)
 {
 	struct acpi_device *device = NULL;
@@ -195,6 +224,9 @@ static void __container_notify_cb(struct work_struct *work)
 	handle = hp_work->handle;
 	type = hp_work->type;
 
+	present = is_device_present(handle);
+	status = acpi_bus_get_device(handle, &device);
+
 	switch (type) {
 	case ACPI_NOTIFY_BUS_CHECK:
 		/* Fall through */
@@ -203,13 +235,14 @@ static void __container_notify_cb(struct work_struct *work)
 		       (type == ACPI_NOTIFY_BUS_CHECK) ?
 		       "ACPI_NOTIFY_BUS_CHECK" : "ACPI_NOTIFY_DEVICE_CHECK");
 
-		present = is_device_present(handle);
-		status = acpi_bus_get_device(handle, &device);
 		if (!present) {
 			if (ACPI_SUCCESS(status)) {
 				/* device exist and this is a remove request */
-				device->flags.eject_pending = 1;
-				kobject_uevent(&device->dev.kobj, KOBJ_OFFLINE);
+				result = container_device_remove(device);
+				if (result) {
+					printk(KERN_WARNING "Failed to remove container\n");
+					break;
+				}
 				return;
 			}
 			break;
@@ -229,12 +262,19 @@ static void __container_notify_cb(struct work_struct *work)
 		break;
 
 	case ACPI_NOTIFY_EJECT_REQUEST:
-		if (!acpi_bus_get_device(handle, &device) && device) {
-			device->flags.eject_pending = 1;
-			kobject_uevent(&device->dev.kobj, KOBJ_OFFLINE);
-			return;
+		printk(KERN_WARNING "Container driver received %s event\n",
+			"ACPI_NOTIFY_EJECT_REQUEST");
+
+		if (!present || ACPI_FAILURE(status) || !device)
+			break;
+
+		result = container_device_remove(device);
+		if (result) {
+			printk(KERN_WARNING "Failed to remove container\n");
+			break;
 		}
-		break;
+
+		return;
 
 	default:
 		/* non-hotplug event; possibly handled by other handler */
-- 
1.7.1

