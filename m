Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758332Ab2IEJpB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 05:45:01 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:47222 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751493Ab2IEJoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 05:44:55 -0400
X-IronPort-AV: E=Sophos;i="4.80,373,1344182400"; 
   d="scan'208";a="5789227"
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
Subject: [RFC v9 PATCH 13/21] memory-hotplug: check page type in get_page_bootmem
Date: Wed, 5 Sep 2012 17:25:47 +0800
Message-Id: <1346837155-534-14-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1346837155-534-1-git-send-email-wency@cn.fujitsu.com>
References: <1346837155-534-1-git-send-email-wency@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/05 17:20:02,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/05 17:20:04,
	Serialize complete at 2012/09/05 17:20:04
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

The function get_page_bootmem() may be called more than one time to the same
page. There is no need to set page's type, private if the function is not
the first time called to the page.

Note: the patch is just optimization and does not fix any problem.

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
 mm/memory_hotplug.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index d736df3..26a5012 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -95,10 +95,17 @@ static void release_memory_resource(struct resource *res)
 static void get_page_bootmem(unsigned long info,  struct page *page,
 			     unsigned long type)
 {
-	page->lru.next = (struct list_head *) type;
-	SetPagePrivate(page);
-	set_page_private(page, info);
-	atomic_inc(&page->_count);
+	unsigned long page_type;
+
+	page_type = (unsigned long)page->lru.next;
+	if (page_type < MEMORY_HOTPLUG_MIN_BOOTMEM_TYPE ||
+	    page_type > MEMORY_HOTPLUG_MAX_BOOTMEM_TYPE){
+		page->lru.next = (struct list_head *)type;
+		SetPagePrivate(page);
+		set_page_private(page, info);
+		atomic_inc(&page->_count);
+	} else
+		atomic_inc(&page->_count);
 }
 
 /* reference to __meminit __free_pages_bootmem is valid
-- 
1.7.1

