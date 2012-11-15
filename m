Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992777Ab2KOGxu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 01:53:50 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:37757 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S2992535Ab2KOGxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 01:53:45 -0500
X-IronPort-AV: E=Sophos;i="4.83,255,1352044800"; 
   d="scan'208";a="6204040"
From: Wen Congyang <wency@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-acpi@vger.kernel.org, Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jiang Liu <jiang.liu@huawei.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Toshi Kani <toshi.kani@hp.com>, Jiang Liu <liuj97@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Christoph Lameter <cl@linux.com>,
        Wen Congyang <wency@cn.fujitsu.com>
Subject: [Patch v5 1/7] acpi,memory-hotplug : add memory offline code to acpi_memory_device_remove()
Date: Thu, 15 Nov 2012 14:59:31 +0800
Message-Id: <1352962777-24407-2-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352962777-24407-1-git-send-email-wency@cn.fujitsu.com>
References: <1352962777-24407-1-git-send-email-wency@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/15 14:53:25,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/15 14:53:26,
	Serialize complete at 2012/11/15 14:53:26
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
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mackerras <paulus@samba.org>
CC: Christoph Lameter <cl@linux.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Rafael J. Wysocki <rjw@sisk.pl>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 drivers/acpi/acpi_memhotplug.c | 31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
index 24c807f..2918be1 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -306,25 +306,37 @@ static int acpi_memory_powerdown_device(struct acpi_memory_device *mem_device)
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
 	list_for_each_entry_safe(info, n, &mem_device->res_list, list) {
 		if (info->enabled) {
 			result = remove_memory(info->start_addr, info->length);
 			if (result)
 				return result;
 		}
+
+		list_del(&info->list);
 		kfree(info);
 	}
 
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
@@ -473,12 +485,17 @@ static int acpi_memory_device_add(struct acpi_device *device)
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

