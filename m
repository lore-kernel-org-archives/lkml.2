Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301Ab2JZKsc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 06:48:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:21852 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758251Ab2JZKsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 06:48:10 -0400
X-IronPort-AV: E=Sophos;i="4.80,654,1344182400"; 
   d="scan'208";a="6078655"
From: wency@cn.fujitsu.com
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Cc: liuj97@gmail.com, len.brown@intel.com, akpm@linux-foundation.org,
        kosaki.motohiro@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        rjw@sisk.pl, laijs@cn.fujitsu.com,
        David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Wen Congyang <wency@cn.fujitsu.com>
Subject: [PATCH v3 3/3] acpi,memory-hotplug : add memory offline code to acpi_memory_device_remove()
Date: Fri, 26 Oct 2012 18:31:03 +0800
Message-Id: <1351247463-5653-4-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1351247463-5653-1-git-send-email-wency@cn.fujitsu.com>
References: <1351247463-5653-1-git-send-email-wency@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/26 18:24:49,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/26 18:24:54,
	Serialize complete at 2012/10/26 18:24:54
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
memory device from the driver acpi_memhotplug or a driver initialization
fails.

acpi_memory_disable_device() has already implemented a code which
offlines memory and releases acpi_memory_info struct. But
acpi_memory_device_remove() has not implemented it yet.

So the patch move offlining memory and releasing acpi_memory_info struct
codes to a new function acpi_memory_remove_memory(). And it is used by both
acpi_memory_device_remove() and acpi_memory_disable_device().

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
 drivers/acpi/acpi_memhotplug.c | 31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
index 666dac6..92c973a 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -316,16 +316,11 @@ static int acpi_memory_powerdown_device(struct acpi_memory_device *mem_device)
 	return 0;
 }
 
-static int acpi_memory_disable_device(struct acpi_memory_device *mem_device)
+static int acpi_memory_remove_memory(struct acpi_memory_device *mem_device)
 {
 	int result;
 	struct acpi_memory_info *info, *n;
 
-
-	/*
-	 * Ask the VM to offline this memory range.
-	 * Note: Assume that this function returns zero on success
-	 */
 	mutex_lock(&mem_device->list_lock);
 	list_for_each_entry_safe(info, n, &mem_device->res_list, list) {
 		if (info->enabled) {
@@ -333,10 +328,27 @@ static int acpi_memory_disable_device(struct acpi_memory_device *mem_device)
 			if (result)
 				return result;
 		}
+
+		list_del(&info->list);
 		kfree(info);
 	}
 	mutex_unlock(&mem_device->list_lock);
 
+	return 0;
+}
+
+static int acpi_memory_disable_device(struct acpi_memory_device *mem_device)
+{
+	int result;
+
+	/*
+	 * Ask the VM to offline this memory range.
+	 * Note: Assume that this function returns zero on success
+	 */
+	result = acpi_memory_remove_memory(mem_device);
+	if (result)
+		return result;
+
 	/* Power-off and eject the device */
 	result = acpi_memory_powerdown_device(mem_device);
 	if (result) {
@@ -487,12 +499,17 @@ static int acpi_memory_device_add(struct acpi_device *device)
 static int acpi_memory_device_remove(struct acpi_device *device, int type)
 {
 	struct acpi_memory_device *mem_device = NULL;
-
+	int result;
 
 	if (!device || !acpi_driver_data(device))
 		return -EINVAL;
 
 	mem_device = acpi_driver_data(device);
+
+	result = acpi_memory_remove_memory(mem_device);
+	if (result)
+		return result;
+
 	kfree(mem_device);
 
 	return 0;
-- 
1.8.0

