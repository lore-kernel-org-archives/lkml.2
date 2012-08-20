Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab2HTJav (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 05:30:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:13029 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751444Ab2HTJaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 05:30:46 -0400
X-IronPort-AV: E=Sophos;i="4.77,796,1336320000"; 
   d="scan'208";a="5672993"
From: wency@cn.fujitsu.com
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com
Cc: rientjes@google.com, liuj97@gmail.com, len.brown@intel.com,
        benh@kernel.crashing.org, paulus@samba.org, cl@linux.com,
        minchan.kim@gmail.com, akpm@linux-foundation.org,
        kosaki.motohiro@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        Wen Congyang <wency@cn.fujitsu.com>
Subject: [RFC V7 PATCH 05/19] memory-hotplug: check whether memory is present or not
Date: Mon, 20 Aug 2012 17:35:28 +0800
Message-Id: <1345455342-27752-6-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1345455342-27752-1-git-send-email-wency@cn.fujitsu.com>
References: <1345455342-27752-1-git-send-email-wency@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/20 17:30:42,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/20 17:30:45,
	Serialize complete at 2012/08/20 17:30:45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

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
 include/linux/mmzone.h |   19 +++++++++++++++++++
 mm/memory_hotplug.c    |   13 +++++++++++++
 2 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 2daa54f..ac3ae30 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1180,6 +1180,25 @@ void sparse_init(void);
 #define sparse_index_init(_sec, _nid)  do {} while (0)
 #endif /* CONFIG_SPARSEMEM */
 
+#ifdef CONFIG_SPARSEMEM
+static inline int pfns_present(unsigned long pfn, unsigned long nr_pages)
+{
+	int i;
+	for (i = 0; i < nr_pages; i++) {
+		if (pfn_present(pfn + i))
+			continue;
+		else
+			return -EINVAL;
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
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 80cded7..3f1d7c5 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -467,6 +467,19 @@ int __ref online_pages(unsigned long pfn, unsigned long nr_pages)
 	struct memory_notify arg;
 
 	lock_memory_hotplug();
+	/*
+	 * If system supports memory hot-remove, the memory may have been
+	 * removed. So we check whether the memory has been removed or not.
+	 *
+	 * Note: When CONFIG_SPARSEMEM is defined, pfns_present() become
+	 *       effective. If CONFIG_SPARSEMEM is not defined, pfns_present()
+	 *       always returns 0.
+	 */
+	ret = pfns_present(pfn, nr_pages);
+	if (ret) {
+		unlock_memory_hotplug();
+		return ret;
+	}
 	arg.start_pfn = pfn;
 	arg.nr_pages = nr_pages;
 	arg.status_change_nid = -1;
-- 
1.7.1

