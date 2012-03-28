Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174Ab2C1LBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 07:01:19 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49803 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757771Ab2C1LBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 07:01:17 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F72EF10.3060209@jp.fujitsu.com>
Date: Wed, 28 Mar 2012 19:59:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Han Ying <yinghan@google.com>, Glauber Costa <glommer@parallels.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Suleiman Souhlal <suleiman@google.com>
Subject: [RFC][[PATCH 4/6] memcg: remove mem_cgroup pointer from page_cgroup
References: <4F72EB84.7080000@jp.fujitsu.com>
In-Reply-To: <4F72EB84.7080000@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch removes pc->mem_cgroup and merge the pointer into flags as

63                           4     0
  | pointer to memcg..........|flags|

After this, memory cgroup's overhead is 8(4)bytes per a page.

Changelog:
 - added BUILD_BUG_ON()
 - update comments in Kconfig

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/page_cgroup.h |   21 +++++++++------------
 init/Kconfig                |    2 +-
 2 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
index 3f3b4ff..7e3a3c7 100644
--- a/include/linux/page_cgroup.h
+++ b/include/linux/page_cgroup.h
@@ -3,6 +3,10 @@
 
 #include <linux/smp.h>
 
+/*
+ * These flags are encoded into low bits of unsigned long,
+ * ORed with a pointer to mem_cgroup.
+ */
 enum {
 	/* flags for mem_cgroup */
 	PCG_LOCK,  /* Lock for pc->mem_cgroup and following bits. */
@@ -12,6 +16,8 @@ enum {
 	__NR_PCG_FLAGS,
 };
 
+#define PCG_FLAGS_MASK	((1 << __NR_PCG_FLAGS) - 1)
+
 #ifndef __GENERATING_BOUNDS_H
 #include <generated/bounds.h>
 
@@ -27,7 +33,6 @@ enum {
  */
 struct page_cgroup {
 	unsigned long flags;
-	struct mem_cgroup *mem_cgroup;
 };
 
 void __meminit pgdat_page_cgroup_init(struct pglist_data *pgdat);
@@ -93,7 +98,7 @@ extern struct mem_cgroup*  root_mem_cgroup;
 static inline struct mem_cgroup* pc_to_mem_cgroup(struct page_cgroup *pc)
 {
 	if (likely(!PageCgroupReset(pc)))
-		return pc->mem_cgroup;
+		return (struct mem_cgroup*)(pc->flags & ~PCG_FLAGS_MASK);
 	return root_mem_cgroup;
 }
 
@@ -101,16 +106,8 @@ static inline void
 pc_set_mem_cgroup_and_flags(struct page_cgroup *pc, struct mem_cgroup *memcg,
 			unsigned long flags)
 {
-	pc->mem_cgroup = memcg;
-	/*
-	 * We access a page_cgroup asynchronously without lock_page_cgroup().
-	 * Especially when a page_cgroup is taken from a page, pc's mem_cgroup
-	 * is accessed after testing USED bit. To make pc's mem_cgroup visible
-	 * before USED bit, we need memory barrier here.
-	 * See mem_cgroup_add_lru_list(), etc.
-	 */
-	smp_wmb();
-	pc->flags = flags;
+	BUILD_BUG_ON(__NR_PCG_FLAGS > 5); /* assume 32byte alignment. */
+	pc->flags = (unsigned long)memcg | flags;
 }
 
 #else /* CONFIG_CGROUP_MEM_RES_CTLR */
diff --git a/init/Kconfig b/init/Kconfig
index 6cfd71d..e0bfe92 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -651,7 +651,7 @@ config CGROUP_MEM_RES_CTLR
 
 	  Note that setting this option increases fixed memory overhead
 	  associated with each page of memory in the system. By this,
-	  20(40)bytes/PAGE_SIZE on 32(64)bit system will be occupied by memory
+	  4(8)bytes/PAGE_SIZE on 32(64)bit system will be occupied by memory
 	  usage tracking struct at boot. Total amount of this is printed out
 	  at boot.
 
-- 
1.7.4.1


