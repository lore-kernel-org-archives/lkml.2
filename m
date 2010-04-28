Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab0D1NMK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 09:12:10 -0400
Received: from relay1.sgi.com ([192.48.179.29]:36509 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043Ab0D1NMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 09:12:08 -0400
Date: Wed, 28 Apr 2010 08:12:04 -0500
From: Jack Steiner <steiner@sgi.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] - Randomize node rotor used in cpuset_mem_spread_node()
Message-ID: <20100428131158.GA2648@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some workloads that create a large number of small files tend to assign
too many pages to node 0 (multi-node systems). Part of the reason is that
the rotor (in cpuset_mem_spread_node()) used to assign nodes starts
at node 0 for newly created tasks.

This patch changes the rotor to be initialized to a random node number
of the cpuset.

Signed-off-by: Jack Steiner <steiner@sgi.com>


---
 arch/x86/mm/numa.c       |   17 +++++++++++++++++
 include/linux/bitmap.h   |    1 +
 include/linux/nodemask.h |    5 +++++
 kernel/fork.c            |    4 ++++
 lib/bitmap.c             |   19 +++++++++++++++++++
 5 files changed, 46 insertions(+)

Index: linux/arch/x86/mm/numa.c
===================================================================
--- linux.orig/arch/x86/mm/numa.c	2010-04-27 16:46:32.272216927 -0500
+++ linux/arch/x86/mm/numa.c	2010-04-28 08:07:09.394972376 -0500
@@ -2,6 +2,7 @@
 #include <linux/topology.h>
 #include <linux/module.h>
 #include <linux/bootmem.h>
+#include <linux/random.h>
 
 #ifdef CONFIG_DEBUG_PER_CPU_MAPS
 # define DBG(x...) printk(KERN_DEBUG x)
@@ -65,3 +66,19 @@ const struct cpumask *cpumask_of_node(in
 }
 EXPORT_SYMBOL(cpumask_of_node);
 #endif
+
+/*
+ * Return the bit number of a random bit set in the nodemask.
+ *   (returns -1 if nodemask is empty)
+ */
+int __node_random(const nodemask_t *maskp)
+{
+	int w, bit = -1;
+
+	w = nodes_weight(maskp->bits);
+	if (w)
+		bit = bitmap_find_nth_bit(maskp->bits,
+				get_random_int() % w, MAX_NUMNODES);
+	return bit;
+}
+EXPORT_SYMBOL(__node_random);
Index: linux/include/linux/bitmap.h
===================================================================
--- linux.orig/include/linux/bitmap.h	2010-04-27 16:46:32.272216927 -0500
+++ linux/include/linux/bitmap.h	2010-04-27 16:46:36.402929137 -0500
@@ -130,6 +130,7 @@ extern int bitmap_find_free_region(unsig
 extern void bitmap_release_region(unsigned long *bitmap, int pos, int order);
 extern int bitmap_allocate_region(unsigned long *bitmap, int pos, int order);
 extern void bitmap_copy_le(void *dst, const unsigned long *src, int nbits);
+extern int bitmap_find_nth_bit(const unsigned long *bitmap, int n, int bits);
 
 #define BITMAP_LAST_WORD_MASK(nbits)					\
 (									\
Index: linux/include/linux/nodemask.h
===================================================================
--- linux.orig/include/linux/nodemask.h	2010-04-27 16:46:32.272216927 -0500
+++ linux/include/linux/nodemask.h	2010-04-27 16:46:36.430899232 -0500
@@ -71,6 +71,8 @@
  *
  * int any_online_node(mask)		First online node in mask
  *
+ * int node_random(mask)		Random node that is set in mask
+ *
  * node_set_online(node)		set bit 'node' in node_online_map
  * node_set_offline(node)		clear bit 'node' in node_online_map
  *
@@ -264,6 +266,9 @@ static inline int __first_unset_node(con
 			find_first_zero_bit(maskp->bits, MAX_NUMNODES));
 }
 
+#define node_random(mask) __node_random(&(mask))
+extern int __node_random(const nodemask_t *maskp);
+
 #define NODE_MASK_LAST_WORD BITMAP_LAST_WORD_MASK(MAX_NUMNODES)
 
 #if MAX_NUMNODES <= BITS_PER_LONG
Index: linux/kernel/fork.c
===================================================================
--- linux.orig/kernel/fork.c	2010-04-27 16:46:32.276200259 -0500
+++ linux/kernel/fork.c	2010-04-28 08:06:37.106967112 -0500
@@ -1097,6 +1097,10 @@ static struct task_struct *copy_process(
  	}
 	mpol_fix_fork_child_flag(p);
 #endif
+#ifdef CONFIG_CPUSETS
+	p->cpuset_mem_spread_rotor = node_random(p->mems_allowed);
+	p->cpuset_slab_spread_rotor = node_random(p->mems_allowed);
+#endif
 #ifdef CONFIG_TRACE_IRQFLAGS
 	p->irq_events = 0;
 #ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
Index: linux/lib/bitmap.c
===================================================================
--- linux.orig/lib/bitmap.c	2010-04-27 16:46:32.272216927 -0500
+++ linux/lib/bitmap.c	2010-04-27 16:46:36.570946439 -0500
@@ -1022,3 +1022,22 @@ void bitmap_copy_le(void *dst, const uns
 	}
 }
 EXPORT_SYMBOL(bitmap_copy_le);
+
+/**
+ * bitmap_find_nth_bit(buf, ord, bits)
+ *	@buf: pointer to bitmap
+ *	@n: ordinal bit position (n-th set bit, n >= 0)
+ * @nbits: number of bits in the bitmap
+ *
+ * find the Nth bit that is set in the bitmap
+ * Value of @n should be in range 0 <= @n < weight(buf), else
+ * results are undefined.
+ *
+ * The bit positions 0 through @bits are valid positions in @buf.
+ */
+int bitmap_find_nth_bit(const unsigned long *bitmap, int n, int bits)
+{
+	return bitmap_ord_to_pos(bitmap, n, bits);
+}
+EXPORT_SYMBOL(bitmap_find_nth_bit);
+
