Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255Ab2JWK3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 06:29:20 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:8589 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751252Ab2JWKZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 06:25:17 -0400
X-IronPort-AV: E=Sophos;i="4.80,635,1344182400"; 
   d="scan'208";a="6052008"
From: wency@cn.fujitsu.com
To: x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com,
        sparclinux@vger.kernel.org
Cc: rientjes@google.com, liuj97@gmail.com, len.brown@intel.com,
        benh@kernel.crashing.org, paulus@samba.org, cl@linux.com,
        minchan.kim@gmail.com, akpm@linux-foundation.org,
        kosaki.motohiro@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        Wen Congyang <wency@cn.fujitsu.com>
Subject: [PATCH v2 01/12] memory-hotplug: try to offline the memory twice to avoid dependence
Date: Tue, 23 Oct 2012 18:30:39 +0800
Message-Id: <1350988250-31294-2-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1350988250-31294-1-git-send-email-wency@cn.fujitsu.com>
References: <1350988250-31294-1-git-send-email-wency@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/23 18:24:42,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/23 18:24:44,
	Serialize complete at 2012/10/23 18:24:44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wen Congyang <wency@cn.fujitsu.com>

memory can't be offlined when CONFIG_MEMCG is selected.
For example: there is a memory device on node 1. The address range
is [1G, 1.5G). You will find 4 new directories memory8, memory9, memory10,
and memory11 under the directory /sys/devices/system/memory/.

If CONFIG_MEMCG is selected, we will allocate memory to store page cgroup
when we online pages. When we online memory8, the memory stored page cgroup
is not provided by this memory device. But when we online memory9, the memory
stored page cgroup may be provided by memory8. So we can't offline memory8
now. We should offline the memory in the reversed order.

When the memory device is hotremoved, we will auto offline memory provided
by this memory device. But we don't know which memory is onlined first, so
offlining memory may fail. In such case, iterate twice to offline the memory.
1st iterate: offline every non primary memory block.
2nd iterate: offline primary (i.e. first added) memory block.

This idea is suggested by KOSAKI Motohiro.

CC: David Rientjes <rientjes@google.com>
CC: Jiang Liu <liuj97@gmail.com>
CC: Len Brown <len.brown@intel.com>
CC: Christoph Lameter <cl@linux.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 mm/memory_hotplug.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 56b758a..600e200 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1019,10 +1019,13 @@ int remove_memory(u64 start, u64 size)
 	unsigned long start_pfn, end_pfn;
 	unsigned long pfn, section_nr;
 	int ret;
+	int return_on_error = 0;
+	int retry = 0;
 
 	start_pfn = PFN_DOWN(start);
 	end_pfn = start_pfn + PFN_DOWN(size);
 
+repeat:
 	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
 		section_nr = pfn_to_section_nr(pfn);
 		if (!present_section_nr(section_nr))
@@ -1041,14 +1044,23 @@ int remove_memory(u64 start, u64 size)
 
 		ret = offline_memory_block(mem);
 		if (ret) {
-			kobject_put(&mem->dev.kobj);
-			return ret;
+			if (return_on_error) {
+				kobject_put(&mem->dev.kobj);
+				return ret;
+			} else {
+				retry = 1;
+			}
 		}
 	}
 
 	if (mem)
 		kobject_put(&mem->dev.kobj);
 
+	if (retry) {
+		return_on_error = 1;
+		goto repeat;
+	}
+
 	return 0;
 }
 #else
-- 
1.7.1

