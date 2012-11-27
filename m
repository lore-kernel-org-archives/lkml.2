Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933448Ab2K0KDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 05:03:18 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:39629 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758585Ab2K0J6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 04:58:18 -0500
X-IronPort-AV: E=Sophos;i="4.83,327,1352044800"; 
   d="scan'208";a="6284833"
From: Wen Congyang <wency@cn.fujitsu.com>
To: x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com,
        sparclinux@vger.kernel.org
Cc: David Rientjes <rientjes@google.com>, Jiang Liu <liuj97@gmail.com>,
        Len Brown <len.brown@intel.com>, benh@kernel.crashing.org,
        paulus@samba.org, Christoph Lameter <cl@linux.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Jianguo Wu <wujianguo@huawei.com>, Wen Congyang <wency@cn.fujitsu.com>
Subject: [Patch v4 02/12] memory-hotplug: check whether all memory blocks are offlined or not when removing memory
Date: Tue, 27 Nov 2012 18:00:12 +0800
Message-Id: <1354010422-19648-3-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1354010422-19648-1-git-send-email-wency@cn.fujitsu.com>
References: <1354010422-19648-1-git-send-email-wency@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/27 17:53:29,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/27 17:57:46,
	Serialize complete at 2012/11/27 17:57:46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

We remove the memory like this:
1. lock memory hotplug
2. offline a memory block
3. unlock memory hotplug
4. repeat 1-3 to offline all memory blocks
5. lock memory hotplug
6. remove memory(TODO)
7. unlock memory hotplug

All memory blocks must be offlined before removing memory. But we don't hold
the lock in the whole operation. So we should check whether all memory blocks
are offlined before step6. Otherwise, kernel maybe panicked.

CC: David Rientjes <rientjes@google.com>
CC: Jiang Liu <liuj97@gmail.com>
CC: Len Brown <len.brown@intel.com>
CC: Christoph Lameter <cl@linux.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
---
 drivers/base/memory.c          |  6 ++++++
 include/linux/memory_hotplug.h |  1 +
 mm/memory_hotplug.c            | 47 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 54 insertions(+)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 86c8821..badb025 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -675,6 +675,12 @@ int offline_memory_block(struct memory_block *mem)
 	return ret;
 }
 
+/* return true if the memory block is offlined, otherwise, return false */
+bool is_memblock_offlined(struct memory_block *mem)
+{
+	return mem->state == MEM_OFFLINE;
+}
+
 /*
  * Initialize the sysfs support for memory devices...
  */
diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 95573ec..38675e9 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -236,6 +236,7 @@ extern int add_memory(int nid, u64 start, u64 size);
 extern int arch_add_memory(int nid, u64 start, u64 size);
 extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages);
 extern int offline_memory_block(struct memory_block *mem);
+extern bool is_memblock_offlined(struct memory_block *mem);
 extern int remove_memory(u64 start, u64 size);
 extern int sparse_add_one_section(struct zone *zone, unsigned long start_pfn,
 								int nr_pages);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index b825dbc..b6d1101 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1054,6 +1054,53 @@ repeat:
 		goto repeat;
 	}
 
+	lock_memory_hotplug();
+
+	/*
+	 * we have offlined all memory blocks like this:
+	 *   1. lock memory hotplug
+	 *   2. offline a memory block
+	 *   3. unlock memory hotplug
+	 *
+	 * repeat step1-3 to offline the memory block. All memory blocks
+	 * must be offlined before removing memory. But we don't hold the
+	 * lock in the whole operation. So we should check whether all
+	 * memory blocks are offlined.
+	 */
+
+	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
+		section_nr = pfn_to_section_nr(pfn);
+		if (!present_section_nr(section_nr))
+			continue;
+
+		section = __nr_to_section(section_nr);
+		/* same memblock? */
+		if (mem)
+			if ((section_nr >= mem->start_section_nr) &&
+			    (section_nr <= mem->end_section_nr))
+				continue;
+
+		mem = find_memory_block_hinted(section, mem);
+		if (!mem)
+			continue;
+
+		ret = is_memblock_offlined(mem);
+		if (!ret) {
+			pr_warn("removing memory fails, because memory "
+				"[%#010llx-%#010llx] is onlined\n",
+				PFN_PHYS(section_nr_to_pfn(mem->start_section_nr)),
+				PFN_PHYS(section_nr_to_pfn(mem->end_section_nr + 1)) - 1);
+
+			kobject_put(&mem->dev.kobj);
+			unlock_memory_hotplug();
+			return ret;
+		}
+	}
+
+	if (mem)
+		kobject_put(&mem->dev.kobj);
+	unlock_memory_hotplug();
+
 	return 0;
 }
 #else
-- 
1.8.0

