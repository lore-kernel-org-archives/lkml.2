Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267Ab2KHK7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 05:59:19 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55618 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753491Ab2KHK7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 05:59:01 -0500
X-IronPort-AV: E=Sophos;i="4.80,737,1344182400"; 
   d="scan'208";a="6161804"
From: Wen Congyang <wency@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-acpi@vger.kernel.org, Len Brown <len.brown@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jiang Liu <jiang.liu@huawei.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Toshi Kani <toshi.kani@hp.com>, Wen Congyang <wency@cn.fujitsu.com>,
        Jiang Liu <liuj97@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Christoph Lameter <cl@linux.com>
Subject: [Patch v4 3/7] acpi_memhotplug.c: fix memory leak when memory device is unbound from the module acpi_memhotplug
Date: Thu, 8 Nov 2012 19:04:49 +0800
Message-Id: <1352372693-32411-4-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352372693-32411-1-git-send-email-wency@cn.fujitsu.com>
References: <1352372693-32411-1-git-send-email-wency@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/08 18:58:59,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/08 18:59:01,
	Serialize complete at 2012/11/08 18:59:01
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We allocate memory to store acpi_memory_info, so we should free it before
freeing mem_device.

CC: David Rientjes <rientjes@google.com>
CC: Jiang Liu <liuj97@gmail.com>
CC: Len Brown <len.brown@intel.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mackerras <paulus@samba.org>
CC: Christoph Lameter <cl@linux.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: Rafael J. Wysocki <rjw@sisk.pl>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 drivers/acpi/acpi_memhotplug.c | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
index e573e87..5e5ac80 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -131,12 +131,22 @@ acpi_memory_get_resource(struct acpi_resource *resource, void *context)
 	return AE_OK;
 }
 
+static void
+acpi_memory_free_device_resources(struct acpi_memory_device *mem_device)
+{
+	struct acpi_memory_info *info, *n;
+
+	mutex_lock(&mem_device->list_lock);
+	list_for_each_entry_safe(info, n, &mem_device->res_list, list)
+		kfree(info);
+	INIT_LIST_HEAD(&mem_device->res_list);
+	mutex_unlock(&mem_device->list_lock);
+}
+
 static int
 acpi_memory_get_device_resources(struct acpi_memory_device *mem_device)
 {
 	acpi_status status;
-	struct acpi_memory_info *info, *n;
-
 
 	if (!list_empty(&mem_device->res_list))
 		return 0;
@@ -144,11 +154,7 @@ acpi_memory_get_device_resources(struct acpi_memory_device *mem_device)
 	status = acpi_walk_resources(mem_device->device->handle, METHOD_NAME__CRS,
 				     acpi_memory_get_resource, mem_device);
 	if (ACPI_FAILURE(status)) {
-		mutex_lock(&mem_device->list_lock);
-		list_for_each_entry_safe(info, n, &mem_device->res_list, list)
-			kfree(info);
-		INIT_LIST_HEAD(&mem_device->res_list);
-		mutex_unlock(&mem_device->list_lock);
+		acpi_memory_free_device_resources(mem_device);
 		return -EINVAL;
 	}
 
@@ -447,6 +453,15 @@ static void acpi_memory_device_notify(acpi_handle handle, u32 event, void *data)
 	return;
 }
 
+static void acpi_memory_device_free(struct acpi_memory_device *mem_device)
+{
+	if (!mem_device)
+		return;
+
+	acpi_memory_free_device_resources(mem_device);
+	kfree(mem_device);
+}
+
 static int acpi_memory_device_add(struct acpi_device *device)
 {
 	int result;
@@ -512,7 +527,7 @@ static int acpi_memory_device_remove(struct acpi_device *device, int type)
 	if (result)
 		return result;
 
-	kfree(mem_device);
+	acpi_memory_device_free(mem_device);
 
 	return 0;
 }
-- 
1.8.0

