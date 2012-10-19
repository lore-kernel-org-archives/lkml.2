Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab2JSGlP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 02:41:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:4068 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752094Ab2JSGlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 02:41:10 -0400
X-IronPort-AV: E=Sophos;i="4.80,612,1344182400"; 
   d="scan'208";a="6029360"
From: wency@cn.fujitsu.com
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: rientjes@google.com, liuj97@gmail.com, len.brown@intel.com,
        benh@kernel.crashing.org, paulus@samba.org, minchan.kim@gmail.com,
        akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, Wen Congyang <wency@cn.fujitsu.com>
Subject: [PATCH v3 1/9] suppress "Device memoryX does not have a release() function" warning
Date: Fri, 19 Oct 2012 14:46:34 +0800
Message-Id: <1350629202-9664-2-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1350629202-9664-1-git-send-email-wency@cn.fujitsu.com>
References: <1350629202-9664-1-git-send-email-wency@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/19 14:40:42,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/19 14:40:44,
	Serialize complete at 2012/10/19 14:40:44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

When calling remove_memory_block(), the function shows following message at
device_release().

"Device 'memory528' does not have a release() function, it is broken and must
be fixed."

The reason is memory_block's device struct does not have a release() function.

So the patch registers memory_block_release() to the device's release() function
for suppressing the warning message. Additionally, the patch moves kfree(mem)
into the release function since the release function is prepared as a means
to free a memory_block struct.

CC: Jiang Liu <liuj97@gmail.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 drivers/base/memory.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 86c8821..7eb1211 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -70,6 +70,13 @@ void unregister_memory_isolate_notifier(struct notifier_block *nb)
 }
 EXPORT_SYMBOL(unregister_memory_isolate_notifier);
 
+static void memory_block_release(struct device *dev)
+{
+	struct memory_block *mem = container_of(dev, struct memory_block, dev);
+
+	kfree(mem);
+}
+
 /*
  * register_memory - Setup a sysfs device for a memory block
  */
@@ -80,6 +87,7 @@ int register_memory(struct memory_block *memory)
 
 	memory->dev.bus = &memory_subsys;
 	memory->dev.id = memory->start_section_nr / sections_per_block;
+	memory->dev.release = memory_block_release;
 
 	error = device_register(&memory->dev);
 	return error;
@@ -635,7 +643,6 @@ int remove_memory_block(unsigned long node_id, struct mem_section *section,
 		mem_remove_simple_file(mem, phys_device);
 		mem_remove_simple_file(mem, removable);
 		unregister_memory(mem);
-		kfree(mem);
 	} else
 		kobject_put(&mem->dev.kobj);
 
-- 
1.7.1

