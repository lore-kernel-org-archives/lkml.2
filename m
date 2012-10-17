Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777Ab2JQMER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 08:04:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:33626 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754638Ab2JQMDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 08:03:20 -0400
X-IronPort-AV: E=Sophos;i="4.80,600,1344182400"; 
   d="scan'208";a="6017131"
From: wency@cn.fujitsu.com
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: rientjes@google.com, liuj97@gmail.com, len.brown@intel.com,
        benh@kernel.crashing.org, paulus@samba.org, minchan.kim@gmail.com,
        akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, Wen Congyang <wency@cn.fujitsu.com>,
        Christoph Lameter <cl@linux.com>
Subject: [PATCH v2 2/5] memory-hotplug: update mce_bad_pages when removing the memory
Date: Wed, 17 Oct 2012 20:08:52 +0800
Message-Id: <1350475735-26136-3-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1350475735-26136-1-git-send-email-wency@cn.fujitsu.com>
References: <1350475735-26136-1-git-send-email-wency@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/17 20:02:55,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/17 20:02:57,
	Serialize complete at 2012/10/17 20:02:57
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
 mm/sparse.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/mm/sparse.c b/mm/sparse.c
index fac95f2..24072e4 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -773,6 +773,23 @@ out:
 	return ret;
 }
 
+#ifdef CONFIG_MEMORY_FAILURE
+static void clear_hwpoisoned_pages(struct page *memmap, int nr_pages)
+{
+	int i;
+
+	if (!memmap)
+		return;
+
+	for (i = 0; i < PAGES_PER_SECTION; i++) {
+		if (PageHWPoison(&memmap[i])) {
+			atomic_long_sub(1, &mce_bad_pages);
+			ClearPageHWPoison(&memmap[i]);
+		}
+	}
+}
+#endif
+
 void sparse_remove_one_section(struct zone *zone, struct mem_section *ms)
 {
 	struct page *memmap = NULL;
@@ -786,6 +803,10 @@ void sparse_remove_one_section(struct zone *zone, struct mem_section *ms)
 		ms->pageblock_flags = NULL;
 	}
 
+#ifdef CONFIG_MEMORY_FAILURE
+	clear_hwpoisoned_pages(memmap, PAGES_PER_SECTION);
+#endif
+
 	free_section_usemap(memmap, usemap);
 }
 #endif
-- 
1.7.1

