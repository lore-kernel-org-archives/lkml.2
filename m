Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251Ab1BCOPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 09:15:47 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:60597 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932208Ab1BCOPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 09:15:46 -0500
Date: Thu, 3 Feb 2011 15:15:33 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch] memcg: add memcg sanity checks at allocating and freeing
 pages
Message-ID: <20110203141533.GH2286@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

This patch add checks at allocating or freeing a page whether the page is used
(iow, charged) from the view point of memcg.

This check may be useful in debugging a problem and we did similar checks
before the commit 52d4b9ac(memcg: allocate all page_cgroup at boot).

This patch adds some overheads at allocating or freeing memory, so it's enabled
only when CONFIG_DEBUG_VM is enabled.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/memcontrol.h |   17 +++++++++++++++++
 mm/memcontrol.c            |   30 ++++++++++++++++++++++++++++++
 mm/page_alloc.c            |    8 ++++++--
 3 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index a1a1e53..3da48ae 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -150,6 +150,10 @@ u64 mem_cgroup_get_limit(struct mem_cgroup *mem);
 void mem_cgroup_split_huge_fixup(struct page *head, struct page *tail);
 #endif
 
+#ifdef CONFIG_DEBUG_VM
+bool mem_cgroup_bad_page_check(struct page *page);
+void mem_cgroup_print_bad_page(struct page *page);
+#endif
 #else /* CONFIG_CGROUP_MEM_RES_CTLR */
 struct mem_cgroup;
 
@@ -346,5 +350,18 @@ static inline void mem_cgroup_split_huge_fixup(struct page *head,
 
 #endif /* CONFIG_CGROUP_MEM_CONT */
 
+#if !defined(CONFIG_CGROUP_MEM_RES_CTLR) || !defined(CONFIG_DEBUG_VM)
+static inline bool
+mem_cgroup_bad_page_check(struct page *page)
+{
+	return false;
+}
+
+static inline void
+mem_cgroup_print_bad_page(struct page *page)
+{
+}
+#endif
+
 #endif /* _LINUX_MEMCONTROL_H */
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6abaa10..2ed1b33 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3016,6 +3016,36 @@ int mem_cgroup_shmem_charge_fallback(struct page *page,
 	return ret;
 }
 
+#ifdef CONFIG_DEBUG_VM
+static struct page_cgroup *lookup_page_cgroup_used(struct page *page)
+{
+	struct page_cgroup *pc;
+
+	pc = lookup_page_cgroup(page);
+	if (likely(pc) && PageCgroupUsed(pc))
+		return pc;
+	return NULL;
+}
+
+bool mem_cgroup_bad_page_check(struct page *page)
+{
+	if (mem_cgroup_disabled())
+		return false;
+
+	return lookup_page_cgroup_used(page) != NULL;
+}
+
+void mem_cgroup_print_bad_page(struct page *page)
+{
+	struct page_cgroup *pc;
+
+	pc = lookup_page_cgroup_used(page);
+	if (pc)
+		printk(KERN_ALERT "pc:%p pc->flags:%ld pc->mem_cgroup:%p\n",
+		       pc, pc->flags, pc->mem_cgroup);
+}
+#endif
+
 static DEFINE_MUTEX(set_limit_mutex);
 
 static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 26df268..60e58b0 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -53,6 +53,7 @@
 #include <linux/compaction.h>
 #include <trace/events/kmem.h>
 #include <linux/ftrace_event.h>
+#include <linux/memcontrol.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -565,7 +566,8 @@ static inline int free_pages_check(struct page *page)
 	if (unlikely(page_mapcount(page) |
 		(page->mapping != NULL)  |
 		(atomic_read(&page->_count) != 0) |
-		(page->flags & PAGE_FLAGS_CHECK_AT_FREE))) {
+		(page->flags & PAGE_FLAGS_CHECK_AT_FREE) |
+		(mem_cgroup_bad_page_check(page)))) {
 		bad_page(page);
 		return 1;
 	}
@@ -750,7 +752,8 @@ static inline int check_new_page(struct page *page)
 	if (unlikely(page_mapcount(page) |
 		(page->mapping != NULL)  |
 		(atomic_read(&page->_count) != 0)  |
-		(page->flags & PAGE_FLAGS_CHECK_AT_PREP))) {
+		(page->flags & PAGE_FLAGS_CHECK_AT_PREP) |
+		(mem_cgroup_bad_page_check(page)))) {
 		bad_page(page);
 		return 1;
 	}
@@ -5693,4 +5696,5 @@ void dump_page(struct page *page)
 		page, atomic_read(&page->_count), page_mapcount(page),
 		page->mapping, page->index);
 	dump_page_flags(page->flags);
+	mem_cgroup_print_bad_page(page);
 }
-- 
1.7.4

