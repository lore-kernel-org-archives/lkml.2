Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab2JCJ7H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 05:59:07 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40797 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab2JCJ7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 05:59:05 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <506C0C53.60205@jp.fujitsu.com>
Date: Wed, 3 Oct 2012 18:58:43 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: <x86@kernel.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <linux-acpi@vger.kernel.org>
CC: <rientjes@google.com>, <liuj97@gmail.com>, <len.brown@intel.com>,
        <cl@linux.com>, <minchan.kim@gmail.com>, <akpm@linux-foundation.org>,
        <kosaki.motohiro@jp.fujitsu.com>, <wency@cn.fujitsu.com>
Subject: [PATCH 1/4] acpi,memory-hotplug : add memory offline code to acpi_memory_device_remove()
References: <506C0AE8.40702@jp.fujitsu.com>
In-Reply-To: <506C0AE8.40702@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

The memory device can be removed by 2 ways:
1. send eject request by SCI
2. echo 1 >/sys/bus/pci/devices/PNP0C80:XX/eject

In the 1st case, acpi_memory_disable_device() will be called.
In the 2nd case, acpi_memory_device_remove() will be called.
acpi_memory_device_remove() will also be called when we unbind the
memory device from the driver acpi_memhotplug.

acpi_memory_disable_device() has already implemented a code which
offlines memory and releases acpi_memory_info struct . But
acpi_memory_device_remove() has not implemented it yet.

So the patch implements acpi_memory_remove_memory() for offlining
memory and releasing acpi_memory_info struct. And it is used by both
acpi_memory_device_remove() and acpi_memory_disable_device().

Additionally, if the type is ACPI_BUS_REMOVAL_EJECT in
acpi_memory_device_remove() , it means that the user wants to eject
the memory device. In this case, acpi_memory_device_remove() calls
acpi_memory_remove_memory().

CC: David Rientjes <rientjes@google.com>
CC: Jiang Liu <liuj97@gmail.com>
CC: Len Brown <len.brown@intel.com>
CC: Christoph Lameter <cl@linux.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> 
Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 drivers/acpi/acpi_memhotplug.c |   44 +++++++++++++++++++++++++++++++----------
 1 file changed, 34 insertions(+), 10 deletions(-)

Index: linux-3.6/drivers/acpi/acpi_memhotplug.c
===================================================================
--- linux-3.6.orig/drivers/acpi/acpi_memhotplug.c	2012-10-03 18:55:33.386378909 +0900
+++ linux-3.6/drivers/acpi/acpi_memhotplug.c	2012-10-03 18:55:58.624380688 +0900
@@ -306,24 +306,37 @@ static int acpi_memory_powerdown_device(
 	return 0;
 }
 
-static int acpi_memory_disable_device(struct acpi_memory_device *mem_device)
+static int acpi_memory_remove_memory(struct acpi_memory_device *mem_device)
 {
 	int result;
 	struct acpi_memory_info *info, *n;
 
+	list_for_each_entry_safe(info, n, &mem_device->res_list, list) {
+		if (!info->enabled)
+			return -EBUSY;
+
+		result = remove_memory(info->start_addr, info->length);
+		if (result)
+			return result;
+
+		list_del(&info->list);
+		kfree(info);
+	}
+
+	return 0;
+}
+
+static int acpi_memory_disable_device(struct acpi_memory_device *mem_device)
+{
+	int result;
 
 	/*
 	 * Ask the VM to offline this memory range.
 	 * Note: Assume that this function returns zero on success
 	 */
-	list_for_each_entry_safe(info, n, &mem_device->res_list, list) {
-		if (info->enabled) {
-			result = remove_memory(info->start_addr, info->length);
-			if (result)
-				return result;
-		}
-		kfree(info);
-	}
+	result = acpi_memory_remove_memory(mem_device);
+	if (result)
+		return result;
 
 	/* Power-off and eject the device */
 	result = acpi_memory_powerdown_device(mem_device);
@@ -473,12 +486,23 @@ static int acpi_memory_device_add(struct
 static int acpi_memory_device_remove(struct acpi_device *device, int type)
 {
 	struct acpi_memory_device *mem_device = NULL;
-
+	int result;
 
 	if (!device || !acpi_driver_data(device))
 		return -EINVAL;
 
 	mem_device = acpi_driver_data(device);
+
+	if (type == ACPI_BUS_REMOVAL_EJECT) {
+		/*
+		 * offline and remove memory only when the memory device is
+		 * ejected.
+		 */
+		result = acpi_memory_remove_memory(mem_device);
+		if (result)
+			return result;
+	}
+
 	kfree(mem_device);
 
 	return 0;

