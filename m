Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab1FPIfV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 04:35:21 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39546 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab1FPIfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 04:35:17 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 16 Jun 2011 17:28:19 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, mgorman@suse.de
Subject: Re: mmotm 2011-06-15-16-56 uploaded (mm/page_cgroup.c)
Message-Id: <20110616172819.1e2d325c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110615214917.a7dce8e6.randy.dunlap@oracle.com>
References: <201106160034.p5G0Y4dr028904@imap1.linux-foundation.org>
	<20110615214917.a7dce8e6.randy.dunlap@oracle.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jun 2011 21:49:17 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Wed, 15 Jun 2011 16:56:49 -0700 akpm@linux-foundation.org wrote:
> 
> > The mm-of-the-moment snapshot 2011-06-15-16-56 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> >    git://zen-kernel.org/kernel/mmotm.git
> > or
> >    git://git.cmpxchg.org/linux-mmotm.git
> > 
> > It contains the following patches against 3.0-rc3:
> 
> 
> (x86_64 build:)
> 
> mm/page_cgroup.c: In function 'page_cgroup_init':
> mm/page_cgroup.c:308: error: implicit declaration of function 'node_start_pfn'
> mm/page_cgroup.c:309: error: implicit declaration of function 'node_end_pfn'
> 
> 

Bug fix is here. Added CC to Mel to get review.
==
>From add3b670119f1c1f762194b432d3997d595bc213 Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 16 Jun 2011 17:28:07 +0900
Subject: [PATCH] Fix node_start/end_pfn() definition for mm/page_cgroup.c

commit 21a3c96 uses node_start/end_pfn(nid) for detection start/end
of nodes. But, it's not defined in linux/mmzone.h but defined in
/arch/???/include/mmzone.h which is included only under
CONFIG_NEED_MULTIPLE_NODES=y.

Then, we see
mm/page_cgroup.c: In function 'page_cgroup_init':
mm/page_cgroup.c:308: error: implicit declaration of function 'node_start_pfn'
mm/page_cgroup.c:309: error: implicit declaration of function 'node_end_pfn'

So, fixing page_cgroup.c is an idea...

But node_start_pfn()/node_end_pfn() is a very generic macro and
should be implemented in the same manner for all archs.
(m32r has different implementation...)

This patch removes definitions of node_start/end_pfn() in each archs
and defines a unified one in linux/mmzone.h. It's not under
CONFIG_NEED_MULTIPLE_NODES, now.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 arch/alpha/include/asm/mmzone.h   |    1 -
 arch/m32r/include/asm/mmzone.h    |    8 +-------
 arch/parisc/include/asm/mmzone.h  |    7 -------
 arch/powerpc/include/asm/mmzone.h |    7 -------
 arch/sh/include/asm/mmzone.h      |    4 ----
 arch/sparc/include/asm/mmzone.h   |    2 --
 arch/tile/include/asm/mmzone.h    |   11 -----------
 arch/x86/include/asm/mmzone_32.h  |   11 -----------
 arch/x86/include/asm/mmzone_64.h  |    3 ---
 include/linux/mmzone.h            |    3 +++
 10 files changed, 4 insertions(+), 53 deletions(-)

diff --git a/arch/alpha/include/asm/mmzone.h b/arch/alpha/include/asm/mmzone.h
index 8af56ce..445dc42 100644
--- a/arch/alpha/include/asm/mmzone.h
+++ b/arch/alpha/include/asm/mmzone.h
@@ -56,7 +56,6 @@ PLAT_NODE_DATA_LOCALNR(unsigned long p, int n)
  * Given a kernel address, find the home node of the underlying memory.
  */
 #define kvaddr_to_nid(kaddr)	pa_to_nid(__pa(kaddr))
-#define node_start_pfn(nid)	(NODE_DATA(nid)->node_start_pfn)
 
 /*
  * Given a kaddr, LOCAL_BASE_ADDR finds the owning node of the memory
diff --git a/arch/m32r/include/asm/mmzone.h b/arch/m32r/include/asm/mmzone.h
index 9f3b5ac..115ced3 100644
--- a/arch/m32r/include/asm/mmzone.h
+++ b/arch/m32r/include/asm/mmzone.h
@@ -14,12 +14,6 @@ extern struct pglist_data *node_data[];
 #define NODE_DATA(nid)		(node_data[nid])
 
 #define node_localnr(pfn, nid)	((pfn) - NODE_DATA(nid)->node_start_pfn)
-#define node_start_pfn(nid)	(NODE_DATA(nid)->node_start_pfn)
-#define node_end_pfn(nid)						\
-({									\
-	pg_data_t *__pgdat = NODE_DATA(nid);				\
-	__pgdat->node_start_pfn + __pgdat->node_spanned_pages - 1;	\
-})
 
 #define pmd_page(pmd)		(pfn_to_page(pmd_val(pmd) >> PAGE_SHIFT))
 /*
@@ -44,7 +38,7 @@ static __inline__ int pfn_to_nid(unsigned long pfn)
 	int node;
 
 	for (node = 0 ; node < MAX_NUMNODES ; node++)
-		if (pfn >= node_start_pfn(node) && pfn <= node_end_pfn(node))
+		if (pfn >= node_start_pfn(node) && pfn < node_end_pfn(node))
 			break;
 
 	return node;
diff --git a/arch/parisc/include/asm/mmzone.h b/arch/parisc/include/asm/mmzone.h
index 9608d2c..e67eb9c 100644
--- a/arch/parisc/include/asm/mmzone.h
+++ b/arch/parisc/include/asm/mmzone.h
@@ -14,13 +14,6 @@ extern struct node_map_data node_data[];
 
 #define NODE_DATA(nid)          (&node_data[nid].pg_data)
 
-#define node_start_pfn(nid)	(NODE_DATA(nid)->node_start_pfn)
-#define node_end_pfn(nid)						\
-({									\
-	pg_data_t *__pgdat = NODE_DATA(nid);				\
-	__pgdat->node_start_pfn + __pgdat->node_spanned_pages;		\
-})
-
 /* We have these possible memory map layouts:
  * Astro: 0-3.75, 67.75-68, 4-64
  * zx1: 0-1, 257-260, 4-256
diff --git a/arch/powerpc/include/asm/mmzone.h b/arch/powerpc/include/asm/mmzone.h
index fd3fd58..7b58917 100644
--- a/arch/powerpc/include/asm/mmzone.h
+++ b/arch/powerpc/include/asm/mmzone.h
@@ -38,13 +38,6 @@ u64 memory_hotplug_max(void);
 #define memory_hotplug_max() memblock_end_of_DRAM()
 #endif
 
-/*
- * Following are macros that each numa implmentation must define.
- */
-
-#define node_start_pfn(nid)	(NODE_DATA(nid)->node_start_pfn)
-#define node_end_pfn(nid)	(NODE_DATA(nid)->node_end_pfn)
-
 #else
 #define memory_hotplug_max() memblock_end_of_DRAM()
 #endif /* CONFIG_NEED_MULTIPLE_NODES */
diff --git a/arch/sh/include/asm/mmzone.h b/arch/sh/include/asm/mmzone.h
index 8887baf..15a8496 100644
--- a/arch/sh/include/asm/mmzone.h
+++ b/arch/sh/include/asm/mmzone.h
@@ -9,10 +9,6 @@
 extern struct pglist_data *node_data[];
 #define NODE_DATA(nid)		(node_data[nid])
 
-#define node_start_pfn(nid)	(NODE_DATA(nid)->node_start_pfn)
-#define node_end_pfn(nid)	(NODE_DATA(nid)->node_start_pfn + \
-				 NODE_DATA(nid)->node_spanned_pages)
-
 static inline int pfn_to_nid(unsigned long pfn)
 {
 	int nid;
diff --git a/arch/sparc/include/asm/mmzone.h b/arch/sparc/include/asm/mmzone.h
index e8c6487..99d9b9f 100644
--- a/arch/sparc/include/asm/mmzone.h
+++ b/arch/sparc/include/asm/mmzone.h
@@ -8,8 +8,6 @@
 extern struct pglist_data *node_data[];
 
 #define NODE_DATA(nid)		(node_data[nid])
-#define node_start_pfn(nid)	(NODE_DATA(nid)->node_start_pfn)
-#define node_end_pfn(nid)	(NODE_DATA(nid)->node_end_pfn)
 
 extern int numa_cpu_lookup_table[];
 extern cpumask_t numa_cpumask_lookup_table[];
diff --git a/arch/tile/include/asm/mmzone.h b/arch/tile/include/asm/mmzone.h
index c6344c4..9d3dbce 100644
--- a/arch/tile/include/asm/mmzone.h
+++ b/arch/tile/include/asm/mmzone.h
@@ -40,17 +40,6 @@ static inline int pfn_to_nid(unsigned long pfn)
 	return highbits_to_node[__pfn_to_highbits(pfn)];
 }
 
-/*
- * Following are macros that each numa implmentation must define.
- */
-
-#define node_start_pfn(nid)	(NODE_DATA(nid)->node_start_pfn)
-#define node_end_pfn(nid)						\
-({									\
-	pg_data_t *__pgdat = NODE_DATA(nid);				\
-	__pgdat->node_start_pfn + __pgdat->node_spanned_pages;		\
-})
-
 #define kern_addr_valid(kaddr)	virt_addr_valid((void *)kaddr)
 
 static inline int pfn_valid(int pfn)
diff --git a/arch/x86/include/asm/mmzone_32.h b/arch/x86/include/asm/mmzone_32.h
index 5e83a41..224e8c5 100644
--- a/arch/x86/include/asm/mmzone_32.h
+++ b/arch/x86/include/asm/mmzone_32.h
@@ -48,17 +48,6 @@ static inline int pfn_to_nid(unsigned long pfn)
 #endif
 }
 
-/*
- * Following are macros that each numa implmentation must define.
- */
-
-#define node_start_pfn(nid)	(NODE_DATA(nid)->node_start_pfn)
-#define node_end_pfn(nid)						\
-({									\
-	pg_data_t *__pgdat = NODE_DATA(nid);				\
-	__pgdat->node_start_pfn + __pgdat->node_spanned_pages;		\
-})
-
 static inline int pfn_valid(int pfn)
 {
 	int nid = pfn_to_nid(pfn);
diff --git a/arch/x86/include/asm/mmzone_64.h b/arch/x86/include/asm/mmzone_64.h
index b3f88d7..129d9aa 100644
--- a/arch/x86/include/asm/mmzone_64.h
+++ b/arch/x86/include/asm/mmzone_64.h
@@ -13,8 +13,5 @@ extern struct pglist_data *node_data[];
 
 #define NODE_DATA(nid)		(node_data[nid])
 
-#define node_start_pfn(nid)	(NODE_DATA(nid)->node_start_pfn)
-#define node_end_pfn(nid)       (NODE_DATA(nid)->node_start_pfn +	\
-				 NODE_DATA(nid)->node_spanned_pages)
 #endif
 #endif /* _ASM_X86_MMZONE_64_H */
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index c928dac..892862e 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -647,6 +647,9 @@ typedef struct pglist_data {
 #endif
 #define nid_page_nr(nid, pagenr) 	pgdat_page_nr(NODE_DATA(nid),(pagenr))
 
+#define node_start_pfn(nid)	(NODE_DATA(nid)->node_start_pfn)
+#define node_end_pfn(nid)	(node_start_pfn(nid) + node_spanned_pages(nid))
+
 #include <linux/memory_hotplug.h>
 
 extern struct mutex zonelists_mutex;
-- 
1.7.4.1


