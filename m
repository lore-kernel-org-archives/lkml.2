Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757092Ab1FQFli (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 01:41:38 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:32790 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787Ab1FQFlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 01:41:35 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 17 Jun 2011 14:34:10 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: linux-next: build failure after merge of the final tree (Linus'
 tree related)
Message-Id: <20110617143410.a73d5b67.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110617153809.471769a1.sfr@canb.auug.org.au>
References: <20110617153809.471769a1.sfr@canb.auug.org.au>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jun 2011 15:38:09 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> mm/page_cgroup.c: In function 'page_cgroup_init':
> mm/page_cgroup.c:309:13: error: 'pg_data_t' has no member named 'node_end_pfn'
> 
> Caused by commit 37573e8c7182 ("memcg: fix init_page_cgroup nid with
> sparsemem").  On powerpc, node_end_pfn() is defined to be (NODE_DATA
> (nid)->node_end_pfn) where NODE_DATA(nid) is (node_data[nid]) and
> node_data is struct pglist_data *node_data[].  As far as I can see,
> struct pglist_data has never had a member called node_end_pfn.
> 
> This commit introduces the only use of node_end_pfn() in the generic
> kernel code.  Presumably the powerpc definition needs to be fixed (to
> maybe something like the x86 version).  It looks like the sparc version
> is broken as well.
> 

Sorry, here is a fix I posted today. but no ack yet.
==
>From 507cc95c5ba2351bff16c5421255d1395a3b555b Mon Sep 17 00:00:00 2001
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

So, fixiing page_cgroup.c is an idea...

But node_start_pfn()/node_end_pfn() is a very generic macro and
should be implemented in the same manner for all archs.
(m32r has different implementation...)

This patch removes definitions of node_start/end_pfn() in each archs
and defines a unified one in linux/mmzone.h. It's not under
CONFIG_NEED_MULTIPLE_NODES, now.

A result of macro expansion is here (mm/page_cgroup.c)

for !NUMA
 start_pfn = ((&contig_page_data)->node_start_pfn);
  end_pfn = ({ pg_data_t *__pgdat = (&contig_page_data); __pgdat->node_start_pfn + __pgdat->node_spanned_pages;});

for NUMA (x86-64)
  start_pfn = ((node_data[nid])->node_start_pfn);
  end_pfn = ({ pg_data_t *__pgdat = (node_data[nid]); __pgdat->node_start_pfn + __pgdat->node_spanned_pages;});

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Changelog:
 - fixed to avoid using "nid" twice in node_end_pfn() macro.
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
 include/linux/mmzone.h            |    7 +++++++
 10 files changed, 8 insertions(+), 53 deletions(-)

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
index c928dac..9f7c3eb 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -647,6 +647,13 @@ typedef struct pglist_data {
 #endif
 #define nid_page_nr(nid, pagenr) 	pgdat_page_nr(NODE_DATA(nid),(pagenr))
 
+#define node_start_pfn(nid)	(NODE_DATA(nid)->node_start_pfn)
+
+#define node_end_pfn(nid) ({\
+	pg_data_t *__pgdat = NODE_DATA(nid);\
+	__pgdat->node_start_pfn + __pgdat->node_spanned_pages;\
+})
+
 #include <linux/memory_hotplug.h>
 
 extern struct mutex zonelists_mutex;
-- 
1.7.4.1


