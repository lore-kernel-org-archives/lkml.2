Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829Ab0HBKY7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 06:24:59 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41212 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab0HBKY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 06:24:57 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 2 Aug 2010 19:20:06 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        vgoyal@redhat.com, m-ikeda@ds.jp.nec.com, gthelen@google.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm 5/5] memcg: use spinlock in page_cgroup instead of
 bit_spinlock
Message-Id: <20100802192006.a395889a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100802191113.05c982e4.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100802191113.05c982e4.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

This patch replaces bit_spinlock with spinlock. In general,
spinlock has good functinality than bit_spin_lock and we should use
it if we have a room for it. In 64bit arch, we have extra 4bytes.
Let's use it.
expected effects:
 - use better codes.
 - ticket lock on x86-64
 - para-vitualization aware lock
etc..

Chagelog: 20090729
 - fixed page_cgroup_is_locked().

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
--
---
 include/linux/page_cgroup.h |   33 ++++++++++++++++++++++++++++++++-
 mm/memcontrol.c             |    2 +-
 mm/page_cgroup.c            |    3 +++
 3 files changed, 36 insertions(+), 2 deletions(-)

Index: mmotm-0727/include/linux/page_cgroup.h
===================================================================
--- mmotm-0727.orig/include/linux/page_cgroup.h
+++ mmotm-0727/include/linux/page_cgroup.h
@@ -10,8 +10,14 @@
  * All page cgroups are allocated at boot or memory hotplug event,
  * then the page cgroup for pfn always exists.
  */
+#ifdef CONFIG_64BIT
+#define PCG_HAS_SPINLOCK
+#endif
 struct page_cgroup {
 	unsigned long flags;
+#ifdef PCG_HAS_SPINLOCK
+	spinlock_t	lock;
+#endif
 	unsigned short mem_cgroup;	/* ID of assigned memory cgroup */
 	unsigned short blk_cgroup;	/* Not Used..but will be. */
 	struct page *page;
@@ -36,7 +42,9 @@ struct page_cgroup *lookup_page_cgroup(s
 
 enum {
 	/* flags for mem_cgroup */
-	PCG_LOCK,  /* page cgroup is locked */
+#ifndef PCG_HAS_SPINLOCK
+	PCG_LOCK,  /* page cgroup is locked (see below also.)*/
+#endif
 	PCG_CACHE, /* charged as cache */
 	PCG_USED, /* this object is in use. */
 	PCG_ACCT_LRU, /* page has been accounted for */
@@ -65,8 +73,6 @@ static inline void ClearPageCgroup##unam
 static inline int TestClearPageCgroup##uname(struct page_cgroup *pc)	\
 	{ return test_and_clear_bit(PCG_##lname, &pc->flags);  }
 
-TESTPCGFLAG(Locked, LOCK)
-
 /* Cache flag is set only once (at allocation) */
 TESTPCGFLAG(Cache, CACHE)
 CLEARPCGFLAG(Cache, CACHE)
@@ -95,6 +101,22 @@ static inline enum zone_type page_cgroup
 	return page_zonenum(pc->page);
 }
 
+#ifdef PCG_HAS_SPINLOCK
+static inline void lock_page_cgroup(struct page_cgroup *pc)
+{
+	spin_lock(&pc->lock);
+}
+static inline void unlock_page_cgroup(struct page_cgroup *pc)
+{
+	spin_unlock(&pc->lock);
+}
+
+static inline bool page_cgroup_is_locked(struct page_cgroup *pc)
+{
+	return spin_is_locked(&pc->lock);
+}
+
+#else
 static inline void lock_page_cgroup(struct page_cgroup *pc)
 {
 	bit_spin_lock(PCG_LOCK, &pc->flags);
@@ -105,6 +127,14 @@ static inline void unlock_page_cgroup(st
 	bit_spin_unlock(PCG_LOCK, &pc->flags);
 }
 
+static inline void page_cgroup_is_locked(struct page_cgrou *pc)
+{
+	bit_spin_is_locked(PCG_LOCK, &pc->flags);
+}
+TESTPCGFLAG(Locked, LOCK)
+
+#endif
+
 #else /* CONFIG_CGROUP_MEM_RES_CTLR */
 struct page_cgroup;
 
Index: mmotm-0727/mm/page_cgroup.c
===================================================================
--- mmotm-0727.orig/mm/page_cgroup.c
+++ mmotm-0727/mm/page_cgroup.c
@@ -18,6 +18,9 @@ __init_page_cgroup(struct page_cgroup *p
 	pc->mem_cgroup = 0;
 	pc->page = pfn_to_page(pfn);
 	INIT_LIST_HEAD(&pc->lru);
+#ifdef PCG_HAS_SPINLOCK
+	spin_lock_init(&pc->lock);
+#endif
 }
 static unsigned long total_usage;
 
Index: mmotm-0727/mm/memcontrol.c
===================================================================
--- mmotm-0727.orig/mm/memcontrol.c
+++ mmotm-0727/mm/memcontrol.c
@@ -1999,7 +1999,7 @@ static void __mem_cgroup_move_account(st
 	int i;
 	VM_BUG_ON(from == to);
 	VM_BUG_ON(PageLRU(pc->page));
-	VM_BUG_ON(!PageCgroupLocked(pc));
+	VM_BUG_ON(!page_cgroup_is_locked(pc));
 	VM_BUG_ON(!PageCgroupUsed(pc));
 	VM_BUG_ON(id_to_memcg(pc->mem_cgroup) != from);
 

