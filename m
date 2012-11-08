Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab2KHK7e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 05:59:34 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55618 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753889Ab2KHK7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 05:59:04 -0500
X-IronPort-AV: E=Sophos;i="4.80,737,1344182400"; 
   d="scan'208";a="6161806"
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
Subject: [Patch v4 5/7] acpi_memhotplug.c: don't allow to eject the memory device if it is being used
Date: Thu, 8 Nov 2012 19:04:51 +0800
Message-Id: <1352372693-32411-6-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352372693-32411-1-git-send-email-wency@cn.fujitsu.com>
References: <1352372693-32411-1-git-send-email-wency@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/08 18:58:59,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/08 18:59:02,
	Serialize complete at 2012/11/08 18:59:02
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
 drivers/acpi/acpi_memhotplug.c | 46 +++++++++++++++++++++++++++++++++---------
 1 file changed, 36 insertions(+), 10 deletions(-)

diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
index 8914399..1fb1342 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -78,6 +78,7 @@ struct acpi_memory_info {
 	unsigned short caching;	/* memory cache attribute */
 	unsigned short write_protect;	/* memory read/write attribute */
 	unsigned int enabled:1;
+	unsigned int failed:1;
 };
 
 struct acpi_memory_device {
@@ -266,9 +267,23 @@ static int acpi_memory_enable_device(struct acpi_memory_device *mem_device)
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
 	mutex_unlock(&mem_device->list_lock);
@@ -324,25 +339,36 @@ static int acpi_memory_powerdown_device(struct acpi_memory_device *mem_device)
 
 static int acpi_memory_remove_memory(struct acpi_memory_device *mem_device)
 {
-	int result;
+	int result = 0;
 	struct acpi_memory_info *info, *n;
 
 	mutex_lock(&mem_device->list_lock);
 	list_for_each_entry_safe(info, n, &mem_device->res_list, list) {
-		if (info->enabled) {
-			result = remove_memory(info->start_addr, info->length);
-			if (result) {
-				mutex_unlock(&mem_device->list_lock);
-				return result;
-			}
+		if (info->failed)
+			/* The kernel does not use this memory block */
+			continue;
+
+		if (!info->enabled) {
+			/*
+			 * The kernel uses this memory block, but it may be not
+			 * managed by us.
+			 */
+			result = -EBUSY;
+			goto out;
 		}
 
+		result = remove_memory(info->start_addr, info->length);
+		if (result)
+			goto out;
+
 		list_del(&info->list);
 		kfree(info);
 	}
+
+out:
 	mutex_unlock(&mem_device->list_lock);
 
-	return 0;
+	return result;
 }
 
 static int acpi_memory_disable_device(struct acpi_memory_device *mem_device)
-- 
1.8.0

