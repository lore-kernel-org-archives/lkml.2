Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992803Ab2KOGxw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 01:53:52 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:22739 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S2992718Ab2KOGxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 01:53:46 -0500
X-IronPort-AV: E=Sophos;i="4.83,255,1352044800"; 
   d="scan'208";a="6204043"
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
Subject: [Patch v5 4/7] acpi_memhotplug.c: free memory device if acpi_memory_enable_device() failed
Date: Thu, 15 Nov 2012 14:59:34 +0800
Message-Id: <1352962777-24407-5-git-send-email-wency@cn.fujitsu.com>
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

If acpi_memory_enable_device() fails, acpi_memory_enable_device() will
return a non-zero value, which means we fail to bind the memory device to
this driver.  So we should free memory device before
acpi_memory_device_add() returns.

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
 drivers/acpi/acpi_memhotplug.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
index c5e7b6d..e52ad5d 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -421,9 +421,11 @@ static int acpi_memory_device_add(struct acpi_device *device)
 	if (!acpi_memory_check_device(mem_device)) {
 		/* call add_memory func */
 		result = acpi_memory_enable_device(mem_device);
-		if (result)
+		if (result) {
 			printk(KERN_ERR PREFIX
 				"Error in acpi_memory_enable_device\n");
+			acpi_memory_device_free(mem_device);
+		}
 	}
 	return result;
 }
-- 
1.8.0

