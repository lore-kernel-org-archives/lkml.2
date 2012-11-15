Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993271Ab2KOKYz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 05:24:55 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52807 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992441Ab2KOKXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 05:23:02 -0500
From: Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>
To: linux-acpi@vger.kernel.org, isimatu.yasuaki@jp.fujitsu.com,
        wency@cn.fujitsu.com
Cc: rjw@sisk.pl, lenb@kernel.org, toshi.kani@hp.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>
Subject: [RFC PATCH v2 3/3] acpi_memhotplug: Add prepare_remove operation
Date: Thu, 15 Nov 2012 11:22:50 +0100
Message-Id: <1352974970-6643-4-git-send-email-vasilis.liaskovitis@profitbricks.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1352974970-6643-1-git-send-email-vasilis.liaskovitis@profitbricks.com>
References: <1352974970-6643-1-git-send-email-vasilis.liaskovitis@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Offlining and removal of memory is now done in the prepare_remove callback,
not in the remove callback.

The prepare_remove callback will be called when trying to remove a memory device
with the following ways:

1. send eject request by SCI
2. echo 1 >/sys/bus/pci/devices/PNP0C80:XX/eject
3. echo "PNP0C80:00" > /sys/bus/acpi/drivers/acpi_memhotplug/unbind

Signed-off-by: Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>
---
 drivers/acpi/acpi_memhotplug.c |   22 ++++++++++++++++++++--
 1 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
index 92c973a..8615ff3 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -54,6 +54,7 @@ MODULE_LICENSE("GPL");
 
 static int acpi_memory_device_add(struct acpi_device *device);
 static int acpi_memory_device_remove(struct acpi_device *device, int type);
+static int acpi_memory_device_prepare_remove(struct acpi_device *device);
 
 static const struct acpi_device_id memory_device_ids[] = {
 	{ACPI_MEMORY_DEVICE_HID, 0},
@@ -68,6 +69,7 @@ static struct acpi_driver acpi_memory_device_driver = {
 	.ops = {
 		.add = acpi_memory_device_add,
 		.remove = acpi_memory_device_remove,
+		.prepare_remove = acpi_memory_device_prepare_remove,
 		},
 };
 
@@ -499,6 +501,20 @@ static int acpi_memory_device_add(struct acpi_device *device)
 static int acpi_memory_device_remove(struct acpi_device *device, int type)
 {
 	struct acpi_memory_device *mem_device = NULL;
+
+	if (!device || !acpi_driver_data(device))
+		return -EINVAL;
+
+	mem_device = acpi_driver_data(device);
+
+	kfree(mem_device);
+
+	return 0;
+}
+
+static int acpi_memory_device_prepare_remove(struct acpi_device *device)
+{
+	struct acpi_memory_device *mem_device = NULL;
 	int result;
 
 	if (!device || !acpi_driver_data(device))
@@ -506,12 +522,14 @@ static int acpi_memory_device_remove(struct acpi_device *device, int type)
 
 	mem_device = acpi_driver_data(device);
 
+	/*
+	 * offline and remove memory only when the memory device is
+	 * ejected.
+	 */
 	result = acpi_memory_remove_memory(mem_device);
 	if (result)
 		return result;
 
-	kfree(mem_device);
-
 	return 0;
 }
 
-- 
1.7.9

