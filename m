Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884Ab2JSGm7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 02:42:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63773 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752944Ab2JSGlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 02:41:11 -0400
X-IronPort-AV: E=Sophos;i="4.80,612,1344182400"; 
   d="scan'208";a="6029364"
From: wency@cn.fujitsu.com
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: rientjes@google.com, liuj97@gmail.com, len.brown@intel.com,
        benh@kernel.crashing.org, paulus@samba.org, minchan.kim@gmail.com,
        akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, Wen Congyang <wency@cn.fujitsu.com>,
        Christoph Lameter <cl@linux.com>
Subject: [PATCH v3 6/9] memory-hotplug: update mce_bad_pages when removing the memory
Date: Fri, 19 Oct 2012 14:46:39 +0800
Message-Id: <1350629202-9664-7-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1350629202-9664-1-git-send-email-wency@cn.fujitsu.com>
References: <1350629202-9664-1-git-send-email-wency@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/19 14:40:42,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/19 14:40:45,
	Serialize complete at 2012/10/19 14:40:45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wen Congyang <wency@cn.fujitsu.com>

When we hotremove a memory device, we will free the memory to store
struct page. If the page is hwpoisoned page, we should decrease
mce_bad_pages.

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
 mm/sparse.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/mm/sparse.c b/mm/sparse.c
index 0021265..77d6a93 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -774,6 +774,24 @@ out:
 	return ret;
 }
 
+#ifdef CONFIG_MEMORY_FAILURE
+static void clear_hwpoisoned_pages(struct page *memmap, int nr_pages)
+{
+	int i;
+
+	for (i = 0; i < PAGES_PER_SECTION; i++) {
+		if (PageHWPoison(&memmap[i])) {
+			atomic_long_sub(1, &mce_bad_pages);
+			ClearPageHWPoison(&memmap[i]);
+		}
+	}
+}
+#else
+static void clear_hwpoisoned_pages(struct page *memmap, int nr_pages)
+{
+}
+#endif
+
 void sparse_remove_one_section(struct zone *zone, struct mem_section *ms)
 {
 	struct page *memmap = NULL;
@@ -785,6 +803,7 @@ void sparse_remove_one_section(struct zone *zone, struct mem_section *ms)
 						__section_nr(ms));
 		ms->section_mem_map = 0;
 		ms->pageblock_flags = NULL;
+		clear_hwpoisoned_pages(memmap, PAGES_PER_SECTION);
 	}
 
 	free_section_usemap(memmap, usemap);
-- 
1.7.1

