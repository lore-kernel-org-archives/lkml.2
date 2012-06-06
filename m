Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab2FFIRE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 04:17:04 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:5537 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752046Ab2FFIPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 04:15:22 -0400
X-IronPort-AV: E=Sophos;i="4.75,722,1330876800"; 
   d="scan'208";a="5122727"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Tejun Heo <tj@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 3/7] highmem: remove set_page_address()
Date: Wed, 6 Jun 2012 16:14:57 +0800
Message-Id: <1338970501-5098-3-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1338970501-5098-1-git-send-email-laijs@cn.fujitsu.com>
References: <1338970501-5098-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/06 16:15:57,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/06 16:16:04,
	Serialize complete at 2012/06/06 16:16:04
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First, highmem.c:set_page_address() is not used by any one outside.
o	So we can make it as a static/internal function in highmem.c.

Second, highmem.c:set_page_address() allocated struct page_address_map
from page_address_maps[], but page_address_maps[] is just sufficient for
kmap() usages, it means, if set_page_address() is called from outside,
it will break kmap() and trigger a BUG_ON().
o	So we should make it as a static/internal function in highmem.c.

Result:

highmem.c:set_page_address() is renamed to set_high_page_address()
and it becomes internal function. (it will be changed again in later patch)

page_alloc.c also calls a different variant of set_page_address(),
we rename it to set_page_virtual_address().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/mm.h |    4 +---
 mm/highmem.c       |   10 ++++++----
 mm/page_alloc.c    |    2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 134abf3..8e0a1c1 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -747,7 +747,7 @@ static __always_inline void *lowmem_page_address(const struct page *page)
 
 #if defined(WANT_PAGE_VIRTUAL)
 #define page_address(page) ((page)->virtual)
-#define set_page_address(page, address)			\
+#define set_page_virtual_address(page, address)		\
 	do {						\
 		(page)->virtual = (address);		\
 	} while(0)
@@ -756,13 +756,11 @@ static __always_inline void *lowmem_page_address(const struct page *page)
 
 #if defined(HASHED_PAGE_VIRTUAL)
 void *page_address(const struct page *page);
-void set_page_address(struct page *page, void *virtual);
 void page_address_init(void);
 #endif
 
 #if !defined(HASHED_PAGE_VIRTUAL) && !defined(WANT_PAGE_VIRTUAL)
 #define page_address(page) lowmem_page_address(page)
-#define set_page_address(page, address)  do { } while(0)
 #define page_address_init()  do { } while(0)
 #endif
 
diff --git a/mm/highmem.c b/mm/highmem.c
index 54c0521..b6ce085 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -92,6 +92,8 @@ static DECLARE_WAIT_QUEUE_HEAD(pkmap_map_wait);
 		do { spin_unlock(&kmap_lock); (void)(flags); } while (0)
 #endif
 
+static void set_high_page_address(struct page *page, void *virtual);
+
 static void flush_all_zero_pkmaps(void)
 {
 	int i;
@@ -126,7 +128,7 @@ static void flush_all_zero_pkmaps(void)
 		pte_clear(&init_mm, (unsigned long)page_address(page),
 			  &pkmap_page_table[i]);
 
-		set_page_address(page, NULL);
+		set_high_page_address(page, NULL);
 		need_flush = 1;
 	}
 	if (need_flush)
@@ -188,7 +190,7 @@ start:
 		   &(pkmap_page_table[last_pkmap_nr]), mk_pte(page, kmap_prot));
 
 	pkmap_count[last_pkmap_nr] = 1;
-	set_page_address(page, (void *)vaddr);
+	set_high_page_address(page, (void *)vaddr);
 
 	return vaddr;
 }
@@ -365,11 +367,11 @@ done:
 EXPORT_SYMBOL(page_address);
 
 /**
- * set_page_address - set a page's virtual address
+ * set_high_page_address - set a page's virtual address
  * @page: &struct page to set
  * @virtual: virtual address to use
  */
-void set_page_address(struct page *page, void *virtual)
+static void set_high_page_address(struct page *page, void *virtual)
 {
 	unsigned long flags;
 	struct page_address_slot *pas;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 476ae3e..75d171b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3727,7 +3727,7 @@ void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
 #ifdef WANT_PAGE_VIRTUAL
 		/* The shift won't overflow because ZONE_NORMAL is below 4G. */
 		if (!is_highmem_idx(zone))
-			set_page_address(page, __va(pfn << PAGE_SHIFT));
+			set_page_virtual_address(page, __va(pfn << PAGE_SHIFT));
 #endif
 	}
 }
-- 
1.7.7

