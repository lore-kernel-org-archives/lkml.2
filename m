Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992926Ab2KOGzK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 01:55:10 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:37757 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S2992679Ab2KOGxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 01:53:42 -0500
X-IronPort-AV: E=Sophos;i="4.83,255,1352044800"; 
   d="scan'208";a="6204044"
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
        Toshi Kani <toshi.kani@hp.com>, Wen Congyang <wency@cn.fujitsu.com>,
        Jiang Liu <liuj97@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Christoph Lameter <cl@linux.com>
Subject: [Patch v5 5/7] acpi_memhotplug.c: don't allow to eject the memory device if it is being used
Date: Thu, 15 Nov 2012 14:59:35 +0800
Message-Id: <1352962777-24407-6-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352962777-24407-1-git-send-email-wency@cn.fujitsu.com>
References: <1352962777-24407-1-git-send-email-wency@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/15 14:53:25,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/15 14:53:27,
	Serialize complete at 2012/11/15 14:53:27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We eject the memory device even if it is in use.  It is very dangerous,
and it will cause the kernel to be panicked.

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
 drivers/acpi/acpi_memhotplug.c | 42 +++++++++++++++++++++++++++++++++---------
 1 file changed, 33 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
index e52ad5d..f7e3007 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -78,6 +78,7 @@ struct acpi_memory_info {
 	unsigned short caching;	/* memory cache attribute */
 	unsigned short write_protect;	/* memory read/write attribute */
 	unsigned int enabled:1;
+	unsigned int failed:1;
 };
 
 struct acpi_memory_device {
@@ -257,9 +258,23 @@ static int acpi_memory_enable_device(struct acpi_memory_device *mem_device)
 			node = memory_add_physaddr_to_nid(info->start_addr);
 
 		result = add_memory(node, info->start_addr, info->length);
-		if (result)
+
+		/*
+		 * If the memory block has been used by the kernel, add_memory()
+		 * returns -EEXIST. If add_memory() returns the other error, it
+		 * means that this memory block is not used by the kernel.
+		 */
+		if (result && result != -EEXIST) {
+			info->failed = 1;
 			continue;
-		info->enabled = 1;
+		}
+
+		if (!result)
+			info->enabled = 1;
+		/*
+		 * Add num_enable even if add_memory() returns -EEXIST, so the
+		 * device is bound to this driver.
+		 */
 		num_enabled++;
 	}
 	if (!num_enabled) {
@@ -280,21 +295,30 @@ static int acpi_memory_enable_device(struct acpi_memory_device *mem_device)
 
 static int acpi_memory_remove_memory(struct acpi_memory_device *mem_device)
 {
-	int result;
+	int result = 0;
 	struct acpi_memory_info *info, *n;
 
 	list_for_each_entry_safe(info, n, &mem_device->res_list, list) {
-		if (info->enabled) {
-			result = remove_memory(info->start_addr, info->length);
-			if (result)
-				return result;
-		}
+		if (info->failed)
+			/* The kernel does not use this memory block */
+			continue;
+
+		if (!info->enabled)
+			/*
+			 * The kernel uses this memory block, but it may be not
+			 * managed by us.
+			 */
+			return -EBUSY;
+
+		result = remove_memory(info->start_addr, info->length);
+		if (result)
+			return result;
 
 		list_del(&info->list);
 		kfree(info);
 	}
 
-	return 0;
+	return result;
 }
 
 static void acpi_memory_device_notify(acpi_handle handle, u32 event, void *data)
-- 
1.8.0

