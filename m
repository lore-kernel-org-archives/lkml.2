Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992712Ab2KOGxn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 01:53:43 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:37757 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S2992535Ab2KOGxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 01:53:40 -0500
X-IronPort-AV: E=Sophos;i="4.83,255,1352044800"; 
   d="scan'208";a="6204045"
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
Subject: [Patch v5 6/7] acpi_memhotplug.c: bind the memory device when the driver is being loaded
Date: Thu, 15 Nov 2012 14:59:36 +0800
Message-Id: <1352962777-24407-7-git-send-email-wency@cn.fujitsu.com>
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

We had introduced acpi_hotmem_initialized to avoid strange add_memory fail
message.  But the memory device may not be used by the kernel, and the
device should be bound when the driver is being loaded.  Remove
acpi_hotmem_initialized to allow that the device can be bound when the
driver is being loaded.

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
 drivers/acpi/acpi_memhotplug.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
index f7e3007..e0f7425 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -87,8 +87,6 @@ struct acpi_memory_device {
 	struct list_head res_list;
 };
 
-static int acpi_hotmem_initialized;
-
 static acpi_status
 acpi_memory_get_resource(struct acpi_resource *resource, void *context)
 {
@@ -433,15 +431,6 @@ static int acpi_memory_device_add(struct acpi_device *device)
 
 	printk(KERN_DEBUG "%s \n", acpi_device_name(device));
 
-	/*
-	 * Early boot code has recognized memory area by EFI/E820.
-	 * If DSDT shows these memory devices on boot, hotplug is not necessary
-	 * for them. So, it just returns until completion of this driver's
-	 * start up.
-	 */
-	if (!acpi_hotmem_initialized)
-		return 0;
-
 	if (!acpi_memory_check_device(mem_device)) {
 		/* call add_memory func */
 		result = acpi_memory_enable_device(mem_device);
@@ -557,7 +546,6 @@ static int __init acpi_memory_device_init(void)
 		return -ENODEV;
 	}
 
-	acpi_hotmem_initialized = 1;
 	return 0;
 }
 
-- 
1.8.0

