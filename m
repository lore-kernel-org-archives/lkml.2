Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852Ab1DMOfo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 10:35:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:35265 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756638Ab1DMOfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 10:35:42 -0400
Date: Wed, 13 Apr 2011 16:35:39 +0200
From: Michal Hocko <mhocko@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jack Steiner <steiner@sgi.com>, Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Paul Menage <menage@google.com>,
        Robin Holt <holt@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: cpusets: randomize node rotor used in cpuset_mem_spread_node()
Message-ID: <20110413143539.GB11051@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I have revisited and fixed the following patch. I am keeping Jack's and
Lee's s-o-b and all others are CCed because I am not exactly sure who
worked on the patch originally.
Can we consider it for re-inclusion?
---
>From 4a2cfbdcfeae9d49ae9ff3486150bec2e4c6107e Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Wed, 13 Apr 2011 16:29:36 +0200
Subject: [PATCH] cpusets: randomize node rotor used in cpuset_mem_spread_node()

[This patch has already been accepted as 0ac0c0d but later reverted
(35926ff) because it itroduced arch specific __node_random which was
defined only for x86 code so it broke other archs.
This is a followup without any arch specific code. Other than that there
are no functional changes.]

Some workloads that create a large number of small files tend to assign
too many pages to node 0 (multi-node systems).  Part of the reason is that
the rotor (in cpuset_mem_spread_node()) used to assign nodes starts at
node 0 for newly created tasks.

This patch changes the rotor to be initialized to a random node number of
the cpuset.

[akpm@linux-foundation.org: fix layout]
[Lee.Schermerhorn@hp.com: Define stub numa_random() for !NUMA configuration]
[mhocko@suse.cz: Make it arch independent]
Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Paul Menage <menage@google.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 include/linux/bitmap.h   |    1 +
 include/linux/nodemask.h |    7 +++++++
 kernel/fork.c            |    4 ++++
 lib/bitmap.c             |    2 +-
 mm/mempolicy.c           |   16 ++++++++++++++++
 5 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index daf8c48..6fb2720 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -141,6 +141,7 @@ extern int bitmap_find_free_region(unsigned long *bitmap, int bits, int order);
 extern void bitmap_release_region(unsigned long *bitmap, int pos, int order);
 extern int bitmap_allocate_region(unsigned long *bitmap, int pos, int order);
 extern void bitmap_copy_le(void *dst, const unsigned long *src, int nbits);
+extern int bitmap_ord_to_pos(const unsigned long *bitmap, int n, int bits);
 
 #define BITMAP_LAST_WORD_MASK(nbits)					\
 (									\
diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
index dba35e4..66ccda9 100644
--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -66,6 +66,8 @@
  * int num_online_nodes()		Number of online Nodes
  * int num_possible_nodes()		Number of all possible Nodes
  *
+ * int node_random(mask)		Random node with set bit in mask
+ *
  * int node_online(node)		Is some node online?
  * int node_possible(node)		Is some node possible?
  *
@@ -430,6 +432,9 @@ static inline void node_set_offline(int nid)
 	node_clear_state(nid, N_ONLINE);
 	nr_online_nodes = num_node_state(N_ONLINE);
 }
+
+extern int node_random(const nodemask_t *maskp);
+
 #else
 
 static inline int node_state(int node, enum node_states state)
@@ -460,6 +465,8 @@ static inline int num_node_state(enum node_states state)
 
 #define node_set_online(node)	   node_set_state((node), N_ONLINE)
 #define node_set_offline(node)	   node_clear_state((node), N_ONLINE)
+
+static inline int node_random(const nodemask_t *mask) { return 0; }
 #endif
 
 #define node_online_map 	node_states[N_ONLINE]
diff --git a/kernel/fork.c b/kernel/fork.c
index e7548de..f59c686 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1119,6 +1119,10 @@ static struct task_struct *copy_process(unsigned long clone_flags,
  	}
 	mpol_fix_fork_child_flag(p);
 #endif
+#ifdef CONFIG_CPUSETS
+	p->cpuset_mem_spread_rotor = node_random(&p->mems_allowed);
+	p->cpuset_slab_spread_rotor = node_random(&p->mems_allowed);
+#endif
 #ifdef CONFIG_TRACE_IRQFLAGS
 	p->irq_events = 0;
 #ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
diff --git a/lib/bitmap.c b/lib/bitmap.c
index 91e0ccf..a4b5217 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -671,7 +671,7 @@ static int bitmap_pos_to_ord(const unsigned long *buf, int pos, int bits)
  *
  * The bit positions 0 through @bits are valid positions in @buf.
  */
-static int bitmap_ord_to_pos(const unsigned long *buf, int ord, int bits)
+int bitmap_ord_to_pos(const unsigned long *buf, int ord, int bits)
 {
 	int pos = 0;
 
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 959a8b8..8e57a72 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -93,6 +93,7 @@
 
 #include <asm/tlbflush.h>
 #include <asm/uaccess.h>
+#include <linux/random.h>
 
 #include "internal.h"
 
@@ -1649,6 +1650,21 @@ static inline unsigned interleave_nid(struct mempolicy *pol,
 		return interleave_nodes(pol);
 }
 
+/*
+ * Return the bit number of a random bit set in the nodemask.
+ * (returns -1 if nodemask is empty)
+ */
+int node_random(const nodemask_t *maskp)
+{
+	int w, bit = -1;
+
+	w = nodes_weight(*maskp);
+	if (w)
+		bit = bitmap_ord_to_pos(maskp->bits,
+			get_random_int() % w, MAX_NUMNODES);
+	return bit;
+}
+
 #ifdef CONFIG_HUGETLBFS
 /*
  * huge_zonelist(@vma, @addr, @gfp_flags, @mpol)
-- 
1.7.4.1

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
