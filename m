Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab2H1KEa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 06:04:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56189 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752575Ab2H1J76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 05:59:58 -0400
X-IronPort-AV: E=Sophos;i="4.77,841,1336320000"; 
   d="scan'208";a="5739724"
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
Subject: [RFC v8 PATCH 19/20] memory-hotplug: remove sysfs file of node
Date: Tue, 28 Aug 2012 18:00:26 +0800
Message-Id: <1346148027-24468-20-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1346148027-24468-1-git-send-email-wency@cn.fujitsu.com>
References: <1346148027-24468-1-git-send-email-wency@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/28 17:55:07,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/28 17:55:18,
	Serialize complete at 2012/08/28 17:55:18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wen Congyang <wency@cn.fujitsu.com>

This patch introduces a new function try_offline_node() to
remove sysfs file of node when all memory sections of this
node are removed. If some memory sections of this node are
not removed, this function does nothing.

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
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 mm/memory_hotplug.c |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 493298f..fb8af64 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1286,6 +1286,37 @@ int offline_memory(u64 start, u64 size)
 	return 0;
 }
 
+/* offline the node if all memory sections of this node are removed */
+static void try_offline_node(int nid)
+{
+	unsigned long start_pfn = NODE_DATA(nid)->node_start_pfn;
+	unsigned long end_pfn = start_pfn + NODE_DATA(nid)->node_spanned_pages;
+	unsigned long pfn;
+
+	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
+		unsigned long section_nr = pfn_to_section_nr(pfn);
+
+		if (!present_section_nr(section_nr))
+			continue;
+
+		if (pfn_to_nid(pfn) != nid)
+			continue;
+
+		/*
+		 * some memory sections of this node are not removed, and we
+		 * can't offline node now.
+		 */
+		return;
+	}
+
+	/*
+	 * all memory sections of this node are removed, we can offline this
+	 * node now.
+	 */
+	node_set_offline(nid);
+	unregister_one_node(nid);
+}
+
 int __ref remove_memory(int nid, u64 start, u64 size)
 {
 	int ret = 0;
@@ -1306,6 +1337,8 @@ int __ref remove_memory(int nid, u64 start, u64 size)
 	firmware_map_remove(start, start + size, "System RAM");
 
 	arch_remove_memory(start, size);
+
+	try_offline_node(nid);
 out:
 	unlock_memory_hotplug();
 	return ret;
-- 
1.7.1

