Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab2KWRvi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 12:51:38 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64017 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924Ab2KWRuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 12:50:50 -0500
From: Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>
To: linux-acpi@vger.kernel.org, isimatu.yasuaki@jp.fujitsu.com,
        wency@cn.fujitsu.com
Cc: rjw@sisk.pl, lenb@kernel.org, toshi.kani@hp.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org,
        Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>
Subject: [RFC PATCH v3 2/3] acpi_memhotplug: Add prepare_remove operation
Date: Fri, 23 Nov 2012 18:50:36 +0100
Message-Id: <1353693037-21704-3-git-send-email-vasilis.liaskovitis@profitbricks.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1353693037-21704-1-git-send-email-vasilis.liaskovitis@profitbricks.com>
References: <1353693037-21704-1-git-send-email-vasilis.liaskovitis@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Offlining and removal of memory is now done in the prepare_remove callback,
not in the remove callback.

The prepare_remove callback will be called when trying to remove a memory device
with the following ways:

1. send eject request by SCI
2. echo 1 >/sys/bus/pci/devices/PNP0C80:XX/eject

Note that unbinding the acpi driver from a memory device with:
echo "PNP0C80:XX" > /sys/bus/acpi/drivers/acpi_memhotplug/unbind

will no longer try to remove the memory. This is in compliance with normal
unbind driver core semantics, see the discussion in v2 of this patchset:
https://lkml.org/lkml/2012/11/16/649

After a successful unbind of the driver:
- OSPM ejects of the memory device cannot proceed, as acpi_eject_store will
return -ENODEV on missing driver.
- SCI ejects of the memory device also cannot proceed, as they will also get
a "driver data is NULL" error.
So the memory can continue to be used safely after unbind.

Signed-off-by: Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>
---
 drivers/acpi/acpi_memhotplug.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
index eb30e5a..d0cfbd9 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -55,6 +55,7 @@ MODULE_LICENSE("GPL");
 
 static int acpi_memory_device_add(struct acpi_device *device);
 static int acpi_memory_device_remove(struct acpi_device *device, int type);
+static int acpi_memory_device_prepare_remove(struct acpi_device *device);
 
 static const struct acpi_device_id memory_device_ids[] = {
 	{ACPI_MEMORY_DEVICE_HID, 0},
@@ -69,6 +70,7 @@ static struct acpi_driver acpi_memory_device_driver = {
 	.ops = {
 		.add = acpi_memory_device_add,
 		.remove = acpi_memory_device_remove,
+		.prepare_remove = acpi_memory_device_prepare_remove,
 		},
 };
 
@@ -448,6 +450,20 @@ static int acpi_memory_device_add(struct acpi_device *device)
 static int acpi_memory_device_remove(struct acpi_device *device, int type)
 {
 	struct acpi_memory_device *mem_device = NULL;
+
+	if (!device || !acpi_driver_data(device))
+		return -EINVAL;
+
+	mem_device = acpi_driver_data(device);
+
+	acpi_memory_device_free(mem_device);
+
+	return 0;
+}
+
+static int acpi_memory_device_prepare_remove(struct acpi_device *device)
+{
+	struct acpi_memory_device *mem_device = NULL;
 	int result;
 
 	if (!device || !acpi_driver_data(device))
@@ -459,8 +475,6 @@ static int acpi_memory_device_remove(struct acpi_device *device, int type)
 	if (result)
 		return result;
 
-	acpi_memory_device_free(mem_device);
-
 	return 0;
 }
 
-- 
1.7.9

