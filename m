Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397Ab2HCIAV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 04:00:21 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:24808 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750784Ab2HCIAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 04:00:17 -0400
X-IronPort-AV: E=Sophos;i="4.77,705,1336320000"; 
   d="scan'208";a="5544581"
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
Subject: [RFC PATCH V6 13/19] memory-hotplug: check page type in get_page_bootmem
Date: Fri, 3 Aug 2012 15:49:15 +0800
Message-Id: <1343980161-14254-14-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1343980161-14254-1-git-send-email-wency@cn.fujitsu.com>
References: <1343980161-14254-1-git-send-email-wency@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/03 15:45:24,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/03 15:45:26,
	Serialize complete at 2012/08/03 15:45:26
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

There is a possibility that get_page_bootmem() is called to the same page many
times. So when get_page_bootmem is called to the same page, the function only
increments page->_count.

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
index 5f9f8c7..710e593 100644
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
+	page_type = (unsigned long) page->lru.next;
+	if (type < MEMORY_HOTPLUG_MIN_BOOTMEM_TYPE ||
+	    type > MEMORY_HOTPLUG_MAX_BOOTMEM_TYPE){
+		page->lru.next = (struct list_head *) type;
+		SetPagePrivate(page);
+		set_page_private(page, info);
+		atomic_inc(&page->_count);
+	} else
+		atomic_inc(&page->_count);
 }
 
 /* reference to __meminit __free_pages_bootmem is valid
-- 
1.7.1

