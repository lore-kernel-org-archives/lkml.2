Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab2GRKIB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 06:08:01 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54084 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778Ab2GRKH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 06:07:58 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <50068AE9.3050804@jp.fujitsu.com>
Date: Wed, 18 Jul 2012 19:07:37 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-acpi@vger.kernel.org>
CC: <rientjes@google.com>, <liuj97@gmail.com>, <len.brown@intel.com>,
        <benh@kernel.crashing.org>, <paulus@samba.org>, <cl@linux.com>,
        <minchan.kim@gmail.com>, <akpm@linux-foundation.org>,
        <kosaki.motohiro@jp.fujitsu.com>, <wency@cn.fujitsu.com>
Subject: [PATCH v4 3/13] memory-hotplug : check whether memory is present
 or not
References: <50068974.1070409@jp.fujitsu.com>
In-Reply-To: <50068974.1070409@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If system supports memory hot-remove, online_pages() may online removed pages.
So online_pages() need to check whether onlining pages are present or not.

CC: David Rientjes <rientjes@google.com>
CC: Jiang Liu <liuj97@gmail.com>
CC: Len Brown <len.brown@intel.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mackerras <paulus@samba.org> 
CC: Christoph Lameter <cl@linux.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> 
CC: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

---
 include/linux/mmzone.h |   21 +++++++++++++++++++++
 mm/memory_hotplug.c    |   13 +++++++++++++
 2 files changed, 34 insertions(+)

Index: linux-3.5-rc6/include/linux/mmzone.h
===================================================================
--- linux-3.5-rc6.orig/include/linux/mmzone.h	2012-07-08 09:23:56.000000000 +0900
+++ linux-3.5-rc6/include/linux/mmzone.h	2012-07-17 16:10:21.588186145 +0900
@@ -1168,6 +1168,27 @@ void sparse_init(void);
 #define sparse_index_init(_sec, _nid)  do {} while (0)
 #endif /* CONFIG_SPARSEMEM */
 
+#ifdef CONFIG_SPARSEMEM
+static inline int pfns_present(unsigned long pfn, unsigned long nr_pages)
+{
+	int i;
+	for (i = 0; i < nr_pages; i++) {
+		if (pfn_present(pfn + 1))
+			continue;
+		else {
+			unlock_memory_hotplug();
+			return -EINVAL;
+		}
+	}
+	return 0;
+}
+#else
+static inline int pfns_present(unsigned long pfn, unsigned long nr_pages)
+{
+	return 0;
+}
+#endif /* CONFIG_SPARSEMEM*/
+
 #ifdef CONFIG_NODES_SPAN_OTHER_NODES
 bool early_pfn_in_nid(unsigned long pfn, int nid);
 #else
Index: linux-3.5-rc6/mm/memory_hotplug.c
===================================================================
--- linux-3.5-rc6.orig/mm/memory_hotplug.c	2012-07-17 14:26:40.000000000 +0900
+++ linux-3.5-rc6/mm/memory_hotplug.c	2012-07-17 16:09:50.070580170 +0900
@@ -467,6 +467,19 @@ int __ref online_pages(unsigned long pfn
 	struct memory_notify arg;
 
 	lock_memory_hotplug();
+	/*
+ 	 * If system supports memory hot-remove, the memory may have been
+ 	 * removed. So we check whether the memory has been removed or not.
+ 	 *
+ 	 * Note: When CONFIG_SPARSEMEM is defined, pfns_present() become
+ 	 *       effective. If CONFIG_SPARSEMEM is not defined, pfns_present()
+ 	 *       always returns 0.
+ 	 */
+	ret = pfns_present(pfn, nr_pages);
+	if (ret) {
+		unlock_memory_hotplug();
+		return ret;
+	}
 	arg.start_pfn = pfn;
 	arg.nr_pages = nr_pages;
 	arg.status_change_nid = -1;

