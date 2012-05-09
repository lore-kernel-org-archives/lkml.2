Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759635Ab2EIOaS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:30:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41012 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759581Ab2EIOaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:30:13 -0400
Date: Wed, 9 May 2012 07:29:02 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-r74n3n8hhuc2ynbrnp3vt954@git.kernel.org>
Cc: mingo@kernel.org, torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        cmetcalf@tilera.com, tony.luck@intel.com, sivanich@sgi.com,
        akpm@linux-foundation.org, ralf@linux-mips.org, greg.pearson@hp.com,
        ink@jurassic.park.msu.ru, tglx@linutronix.de,
        kamezawa.hiroyu@jp.fujitsu.com, rth@twiddle.net,
        linux-kernel@vger.kernel.org, hpa@zytor.com, anton@samba.org,
        paulus@samba.org, lethal@linux-sh.org, davem@davemloft.net,
        dhowells@redhat.com, benh@kernel.crashing.org, fenghua.yu@intel.com,
        mattst88@gmail.com
Reply-To: mingo@kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, cmetcalf@tilera.com,
        tony.luck@intel.com, sivanich@sgi.com, akpm@linux-foundation.org,
        ralf@linux-mips.org, greg.pearson@hp.com, ink@jurassic.park.msu.ru,
        tglx@linutronix.de, rth@twiddle.net, kamezawa.hiroyu@jp.fujitsu.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
        anton@samba.org, lethal@linux-sh.org, davem@davemloft.net,
        benh@kernel.crashing.org, dhowells@redhat.com, mattst88@gmail.com,
        fenghua.yu@intel.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa:
  Rewrite the CONFIG_NUMA sched domain support
Git-Commit-ID: cb83b629bae0327cf9f44f096adc38d150ceb913
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 09 May 2012 07:29:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cb83b629bae0327cf9f44f096adc38d150ceb913
Gitweb:     http://git.kernel.org/tip/cb83b629bae0327cf9f44f096adc38d150ceb913
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 17 Apr 2012 15:49:36 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 May 2012 15:00:55 +0200

sched/numa: Rewrite the CONFIG_NUMA sched domain support

The current code groups up to 16 nodes in a level and then puts an
ALLNODES domain spanning the entire tree on top of that. This doesn't
reflect the numa topology and esp for the smaller not-fully-connected
machines out there today this might make a difference.

Therefore, build a proper numa topology based on node_distance().

Since there's no fixed numa layers anymore, the static SD_NODE_INIT
and SD_ALLNODES_INIT aren't usable anymore, the new code tries to
construct something similar and scales some values either on the
number of cpus in the domain and/or the node_distance() ratio.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Anton Blanchard <anton@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: David Howells <dhowells@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: linux-alpha@vger.kernel.org
Cc: linux-ia64@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mips@linux-mips.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-sh@vger.kernel.org
Cc: Matt Turner <mattst88@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: sparclinux@vger.kernel.org
Cc: Tony Luck <tony.luck@intel.com>
Cc: x86@kernel.org
Cc: Dimitri Sivanich <sivanich@sgi.com>
Cc: Greg Pearson <greg.pearson@hp.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: bob.picco@oracle.com
Cc: chris.mason@oracle.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-r74n3n8hhuc2ynbrnp3vt954@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/ia64/include/asm/topology.h           |   25 ---
 arch/mips/include/asm/mach-ip27/topology.h |   17 --
 arch/powerpc/include/asm/topology.h        |   36 ----
 arch/sh/include/asm/topology.h             |   25 ---
 arch/sparc/include/asm/topology_64.h       |   19 --
 arch/tile/include/asm/topology.h           |   26 ---
 arch/x86/include/asm/topology.h            |   38 ----
 include/linux/topology.h                   |   37 ----
 kernel/sched/core.c                        |  280 ++++++++++++++++++----------
 9 files changed, 185 insertions(+), 318 deletions(-)

diff --git a/arch/ia64/include/asm/topology.h b/arch/ia64/include/asm/topology.h
index 09f6467..a2496e4 100644
--- a/arch/ia64/include/asm/topology.h
+++ b/arch/ia64/include/asm/topology.h
@@ -70,31 +70,6 @@ void build_cpu_to_node_map(void);
 	.nr_balance_failed	= 0,			\
 }
 
-/* sched_domains SD_NODE_INIT for IA64 NUMA machines */
-#define SD_NODE_INIT (struct sched_domain) {		\
-	.parent			= NULL,			\
-	.child			= NULL,			\
-	.groups			= NULL,			\
-	.min_interval		= 8,			\
-	.max_interval		= 8*(min(num_online_cpus(), 32U)), \
-	.busy_factor		= 64,			\
-	.imbalance_pct		= 125,			\
-	.cache_nice_tries	= 2,			\
-	.busy_idx		= 3,			\
-	.idle_idx		= 2,			\
-	.newidle_idx		= 0,			\
-	.wake_idx		= 0,			\
-	.forkexec_idx		= 0,			\
-	.flags			= SD_LOAD_BALANCE	\
-				| SD_BALANCE_NEWIDLE	\
-				| SD_BALANCE_EXEC	\
-				| SD_BALANCE_FORK	\
-				| SD_SERIALIZE,		\
-	.last_balance		= jiffies,		\
-	.balance_interval	= 64,			\
-	.nr_balance_failed	= 0,			\
-}
-
 #endif /* CONFIG_NUMA */
 
 #ifdef CONFIG_SMP
diff --git a/arch/mips/include/asm/mach-ip27/topology.h b/arch/mips/include/asm/mach-ip27/topology.h
index 1b1a7d1..b2cf641 100644
--- a/arch/mips/include/asm/mach-ip27/topology.h
+++ b/arch/mips/include/asm/mach-ip27/topology.h
@@ -36,23 +36,6 @@ extern unsigned char __node_distances[MAX_COMPACT_NODES][MAX_COMPACT_NODES];
 
 #define node_distance(from, to)	(__node_distances[(from)][(to)])
 
-/* sched_domains SD_NODE_INIT for SGI IP27 machines */
-#define SD_NODE_INIT (struct sched_domain) {		\
-	.parent			= NULL,			\
-	.child			= NULL,			\
-	.groups			= NULL,			\
-	.min_interval		= 8,			\
-	.max_interval		= 32,			\
-	.busy_factor		= 32,			\
-	.imbalance_pct		= 125,			\
-	.cache_nice_tries	= 1,			\
-	.flags			= SD_LOAD_BALANCE |	\
-				  SD_BALANCE_EXEC,	\
-	.last_balance		= jiffies,		\
-	.balance_interval	= 1,			\
-	.nr_balance_failed	= 0,			\
-}
-
 #include <asm-generic/topology.h>
 
 #endif /* _ASM_MACH_TOPOLOGY_H */
diff --git a/arch/powerpc/include/asm/topology.h b/arch/powerpc/include/asm/topology.h
index c971858..852ed1b 100644
--- a/arch/powerpc/include/asm/topology.h
+++ b/arch/powerpc/include/asm/topology.h
@@ -18,12 +18,6 @@ struct device_node;
  */
 #define RECLAIM_DISTANCE 10
 
-/*
- * Avoid creating an extra level of balancing (SD_ALLNODES) on the largest
- * POWER7 boxes which have a maximum of 32 nodes.
- */
-#define SD_NODES_PER_DOMAIN 32
-
 #include <asm/mmzone.h>
 
 static inline int cpu_to_node(int cpu)
@@ -51,36 +45,6 @@ static inline int pcibus_to_node(struct pci_bus *bus)
 				 cpu_all_mask :				\
 				 cpumask_of_node(pcibus_to_node(bus)))
 
-/* sched_domains SD_NODE_INIT for PPC64 machines */
-#define SD_NODE_INIT (struct sched_domain) {				\
-	.min_interval		= 8,					\
-	.max_interval		= 32,					\
-	.busy_factor		= 32,					\
-	.imbalance_pct		= 125,					\
-	.cache_nice_tries	= 1,					\
-	.busy_idx		= 3,					\
-	.idle_idx		= 1,					\
-	.newidle_idx		= 0,					\
-	.wake_idx		= 0,					\
-	.forkexec_idx		= 0,					\
-									\
-	.flags			= 1*SD_LOAD_BALANCE			\
-				| 0*SD_BALANCE_NEWIDLE			\
-				| 1*SD_BALANCE_EXEC			\
-				| 1*SD_BALANCE_FORK			\
-				| 0*SD_BALANCE_WAKE			\
-				| 1*SD_WAKE_AFFINE			\
-				| 0*SD_PREFER_LOCAL			\
-				| 0*SD_SHARE_CPUPOWER			\
-				| 0*SD_POWERSAVINGS_BALANCE		\
-				| 0*SD_SHARE_PKG_RESOURCES		\
-				| 1*SD_SERIALIZE			\
-				| 0*SD_PREFER_SIBLING			\
-				,					\
-	.last_balance		= jiffies,				\
-	.balance_interval	= 1,					\
-}
-
 extern int __node_distance(int, int);
 #define node_distance(a, b) __node_distance(a, b)
 
diff --git a/arch/sh/include/asm/topology.h b/arch/sh/include/asm/topology.h
index 88e7340..b0a282d 100644
--- a/arch/sh/include/asm/topology.h
+++ b/arch/sh/include/asm/topology.h
@@ -3,31 +3,6 @@
 
 #ifdef CONFIG_NUMA
 
-/* sched_domains SD_NODE_INIT for sh machines */
-#define SD_NODE_INIT (struct sched_domain) {		\
-	.parent			= NULL,			\
-	.child			= NULL,			\
-	.groups			= NULL,			\
-	.min_interval		= 8,			\
-	.max_interval		= 32,			\
-	.busy_factor		= 32,			\
-	.imbalance_pct		= 125,			\
-	.cache_nice_tries	= 2,			\
-	.busy_idx		= 3,			\
-	.idle_idx		= 2,			\
-	.newidle_idx		= 0,			\
-	.wake_idx		= 0,			\
-	.forkexec_idx		= 0,			\
-	.flags			= SD_LOAD_BALANCE	\
-				| SD_BALANCE_FORK	\
-				| SD_BALANCE_EXEC	\
-				| SD_BALANCE_NEWIDLE	\
-				| SD_SERIALIZE,		\
-	.last_balance		= jiffies,		\
-	.balance_interval	= 1,			\
-	.nr_balance_failed	= 0,			\
-}
-
 #define cpu_to_node(cpu)	((void)(cpu),0)
 #define parent_node(node)	((void)(node),0)
 
diff --git a/arch/sparc/include/asm/topology_64.h b/arch/sparc/include/asm/topology_64.h
index 8b9c556..1754390 100644
--- a/arch/sparc/include/asm/topology_64.h
+++ b/arch/sparc/include/asm/topology_64.h
@@ -31,25 +31,6 @@ static inline int pcibus_to_node(struct pci_bus *pbus)
 	 cpu_all_mask : \
 	 cpumask_of_node(pcibus_to_node(bus)))
 
-#define SD_NODE_INIT (struct sched_domain) {		\
-	.min_interval		= 8,			\
-	.max_interval		= 32,			\
-	.busy_factor		= 32,			\
-	.imbalance_pct		= 125,			\
-	.cache_nice_tries	= 2,			\
-	.busy_idx		= 3,			\
-	.idle_idx		= 2,			\
-	.newidle_idx		= 0, 			\
-	.wake_idx		= 0,			\
-	.forkexec_idx		= 0,			\
-	.flags			= SD_LOAD_BALANCE	\
-				| SD_BALANCE_FORK	\
-				| SD_BALANCE_EXEC	\
-				| SD_SERIALIZE,		\
-	.last_balance		= jiffies,		\
-	.balance_interval	= 1,			\
-}
-
 #else /* CONFIG_NUMA */
 
 #include <asm-generic/topology.h>
diff --git a/arch/tile/include/asm/topology.h b/arch/tile/include/asm/topology.h
index 6fdd0c8..7a7ce39 100644
--- a/arch/tile/include/asm/topology.h
+++ b/arch/tile/include/asm/topology.h
@@ -78,32 +78,6 @@ static inline const struct cpumask *cpumask_of_node(int node)
 	.balance_interval	= 32,					\
 }
 
-/* sched_domains SD_NODE_INIT for TILE architecture */
-#define SD_NODE_INIT (struct sched_domain) {				\
-	.min_interval		= 16,					\
-	.max_interval		= 512,					\
-	.busy_factor		= 32,					\
-	.imbalance_pct		= 125,					\
-	.cache_nice_tries	= 1,					\
-	.busy_idx		= 3,					\
-	.idle_idx		= 1,					\
-	.newidle_idx		= 2,					\
-	.wake_idx		= 1,					\
-	.flags			= 1*SD_LOAD_BALANCE			\
-				| 1*SD_BALANCE_NEWIDLE			\
-				| 1*SD_BALANCE_EXEC			\
-				| 1*SD_BALANCE_FORK			\
-				| 0*SD_BALANCE_WAKE			\
-				| 0*SD_WAKE_AFFINE			\
-				| 0*SD_PREFER_LOCAL			\
-				| 0*SD_SHARE_CPUPOWER			\
-				| 0*SD_SHARE_PKG_RESOURCES		\
-				| 1*SD_SERIALIZE			\
-				,					\
-	.last_balance		= jiffies,				\
-	.balance_interval	= 128,					\
-}
-
 /* By definition, we create nodes based on online memory. */
 #define node_has_online_mem(nid) 1
 
diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index b9676ae..095b215 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -92,44 +92,6 @@ extern void setup_node_to_cpumask_map(void);
 
 #define pcibus_to_node(bus) __pcibus_to_node(bus)
 
-#ifdef CONFIG_X86_32
-# define SD_CACHE_NICE_TRIES	1
-# define SD_IDLE_IDX		1
-#else
-# define SD_CACHE_NICE_TRIES	2
-# define SD_IDLE_IDX		2
-#endif
-
-/* sched_domains SD_NODE_INIT for NUMA machines */
-#define SD_NODE_INIT (struct sched_domain) {				\
-	.min_interval		= 8,					\
-	.max_interval		= 32,					\
-	.busy_factor		= 32,					\
-	.imbalance_pct		= 125,					\
-	.cache_nice_tries	= SD_CACHE_NICE_TRIES,			\
-	.busy_idx		= 3,					\
-	.idle_idx		= SD_IDLE_IDX,				\
-	.newidle_idx		= 0,					\
-	.wake_idx		= 0,					\
-	.forkexec_idx		= 0,					\
-									\
-	.flags			= 1*SD_LOAD_BALANCE			\
-				| 1*SD_BALANCE_NEWIDLE			\
-				| 1*SD_BALANCE_EXEC			\
-				| 1*SD_BALANCE_FORK			\
-				| 0*SD_BALANCE_WAKE			\
-				| 1*SD_WAKE_AFFINE			\
-				| 0*SD_PREFER_LOCAL			\
-				| 0*SD_SHARE_CPUPOWER			\
-				| 0*SD_POWERSAVINGS_BALANCE		\
-				| 0*SD_SHARE_PKG_RESOURCES		\
-				| 1*SD_SERIALIZE			\
-				| 0*SD_PREFER_SIBLING			\
-				,					\
-	.last_balance		= jiffies,				\
-	.balance_interval	= 1,					\
-}
-
 extern int __node_distance(int, int);
 #define node_distance(a, b) __node_distance(a, b)
 
diff --git a/include/linux/topology.h b/include/linux/topology.h
index e26db03..4f59bf3 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -70,7 +70,6 @@ int arch_update_cpu_topology(void);
  * Below are the 3 major initializers used in building sched_domains:
  * SD_SIBLING_INIT, for SMT domains
  * SD_CPU_INIT, for SMP domains
- * SD_NODE_INIT, for NUMA domains
  *
  * Any architecture that cares to do any tuning to these values should do so
  * by defining their own arch-specific initializer in include/asm/topology.h.
@@ -176,48 +175,12 @@ int arch_update_cpu_topology(void);
 }
 #endif
 
-/* sched_domains SD_ALLNODES_INIT for NUMA machines */
-#define SD_ALLNODES_INIT (struct sched_domain) {			\
-	.min_interval		= 64,					\
-	.max_interval		= 64*num_online_cpus(),			\
-	.busy_factor		= 128,					\
-	.imbalance_pct		= 133,					\
-	.cache_nice_tries	= 1,					\
-	.busy_idx		= 3,					\
-	.idle_idx		= 3,					\
-	.flags			= 1*SD_LOAD_BALANCE			\
-				| 1*SD_BALANCE_NEWIDLE			\
-				| 0*SD_BALANCE_EXEC			\
-				| 0*SD_BALANCE_FORK			\
-				| 0*SD_BALANCE_WAKE			\
-				| 0*SD_WAKE_AFFINE			\
-				| 0*SD_SHARE_CPUPOWER			\
-				| 0*SD_POWERSAVINGS_BALANCE		\
-				| 0*SD_SHARE_PKG_RESOURCES		\
-				| 1*SD_SERIALIZE			\
-				| 0*SD_PREFER_SIBLING			\
-				,					\
-	.last_balance		= jiffies,				\
-	.balance_interval	= 64,					\
-}
-
-#ifndef SD_NODES_PER_DOMAIN
-#define SD_NODES_PER_DOMAIN 16
-#endif
-
 #ifdef CONFIG_SCHED_BOOK
 #ifndef SD_BOOK_INIT
 #error Please define an appropriate SD_BOOK_INIT in include/asm/topology.h!!!
 #endif
 #endif /* CONFIG_SCHED_BOOK */
 
-#ifdef CONFIG_NUMA
-#ifndef SD_NODE_INIT
-#error Please define an appropriate SD_NODE_INIT in include/asm/topology.h!!!
-#endif
-
-#endif /* CONFIG_NUMA */
-
 #ifdef CONFIG_USE_PERCPU_NUMA_NODE_ID
 DECLARE_PER_CPU(int, numa_node);
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 6001e5c..b4f2096 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5560,7 +5560,8 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 			break;
 		}
 
-		if (cpumask_intersects(groupmask, sched_group_cpus(group))) {
+		if (!(sd->flags & SD_OVERLAP) &&
+		    cpumask_intersects(groupmask, sched_group_cpus(group))) {
 			printk(KERN_CONT "\n");
 			printk(KERN_ERR "ERROR: repeated CPUs\n");
 			break;
@@ -5898,92 +5899,6 @@ static int __init isolated_cpu_setup(char *str)
 
 __setup("isolcpus=", isolated_cpu_setup);
 
-#ifdef CONFIG_NUMA
-
-/**
- * find_next_best_node - find the next node to include in a sched_domain
- * @node: node whose sched_domain we're building
- * @used_nodes: nodes already in the sched_domain
- *
- * Find the next node to include in a given scheduling domain. Simply
- * finds the closest node not already in the @used_nodes map.
- *
- * Should use nodemask_t.
- */
-static int find_next_best_node(int node, nodemask_t *used_nodes)
-{
-	int i, n, val, min_val, best_node = -1;
-
-	min_val = INT_MAX;
-
-	for (i = 0; i < nr_node_ids; i++) {
-		/* Start at @node */
-		n = (node + i) % nr_node_ids;
-
-		if (!nr_cpus_node(n))
-			continue;
-
-		/* Skip already used nodes */
-		if (node_isset(n, *used_nodes))
-			continue;
-
-		/* Simple min distance search */
-		val = node_distance(node, n);
-
-		if (val < min_val) {
-			min_val = val;
-			best_node = n;
-		}
-	}
-
-	if (best_node != -1)
-		node_set(best_node, *used_nodes);
-	return best_node;
-}
-
-/**
- * sched_domain_node_span - get a cpumask for a node's sched_domain
- * @node: node whose cpumask we're constructing
- * @span: resulting cpumask
- *
- * Given a node, construct a good cpumask for its sched_domain to span. It
- * should be one that prevents unnecessary balancing, but also spreads tasks
- * out optimally.
- */
-static void sched_domain_node_span(int node, struct cpumask *span)
-{
-	nodemask_t used_nodes;
-	int i;
-
-	cpumask_clear(span);
-	nodes_clear(used_nodes);
-
-	cpumask_or(span, span, cpumask_of_node(node));
-	node_set(node, used_nodes);
-
-	for (i = 1; i < SD_NODES_PER_DOMAIN; i++) {
-		int next_node = find_next_best_node(node, &used_nodes);
-		if (next_node < 0)
-			break;
-		cpumask_or(span, span, cpumask_of_node(next_node));
-	}
-}
-
-static const struct cpumask *cpu_node_mask(int cpu)
-{
-	lockdep_assert_held(&sched_domains_mutex);
-
-	sched_domain_node_span(cpu_to_node(cpu), sched_domains_tmpmask);
-
-	return sched_domains_tmpmask;
-}
-
-static const struct cpumask *cpu_allnodes_mask(int cpu)
-{
-	return cpu_possible_mask;
-}
-#endif /* CONFIG_NUMA */
-
 static const struct cpumask *cpu_cpu_mask(int cpu)
 {
 	return cpumask_of_node(cpu_to_node(cpu));
@@ -6020,6 +5935,7 @@ struct sched_domain_topology_level {
 	sched_domain_init_f init;
 	sched_domain_mask_f mask;
 	int		    flags;
+	int		    numa_level;
 	struct sd_data      data;
 };
 
@@ -6213,10 +6129,6 @@ sd_init_##type(struct sched_domain_topology_level *tl, int cpu) 	\
 }
 
 SD_INIT_FUNC(CPU)
-#ifdef CONFIG_NUMA
- SD_INIT_FUNC(ALLNODES)
- SD_INIT_FUNC(NODE)
-#endif
 #ifdef CONFIG_SCHED_SMT
  SD_INIT_FUNC(SIBLING)
 #endif
@@ -6338,15 +6250,191 @@ static struct sched_domain_topology_level default_topology[] = {
 	{ sd_init_BOOK, cpu_book_mask, },
 #endif
 	{ sd_init_CPU, cpu_cpu_mask, },
-#ifdef CONFIG_NUMA
-	{ sd_init_NODE, cpu_node_mask, SDTL_OVERLAP, },
-	{ sd_init_ALLNODES, cpu_allnodes_mask, },
-#endif
 	{ NULL, },
 };
 
 static struct sched_domain_topology_level *sched_domain_topology = default_topology;
 
+#ifdef CONFIG_NUMA
+
+static int sched_domains_numa_levels;
+static int sched_domains_numa_scale;
+static int *sched_domains_numa_distance;
+static struct cpumask ***sched_domains_numa_masks;
+static int sched_domains_curr_level;
+
+static inline unsigned long numa_scale(unsigned long x, int level)
+{
+	return x * sched_domains_numa_distance[level] / sched_domains_numa_scale;
+}
+
+static inline int sd_local_flags(int level)
+{
+	if (sched_domains_numa_distance[level] > REMOTE_DISTANCE)
+		return 0;
+
+	return SD_BALANCE_EXEC | SD_BALANCE_FORK | SD_WAKE_AFFINE;
+}
+
+static struct sched_domain *
+sd_numa_init(struct sched_domain_topology_level *tl, int cpu)
+{
+	struct sched_domain *sd = *per_cpu_ptr(tl->data.sd, cpu);
+	int level = tl->numa_level;
+	int sd_weight = cpumask_weight(
+			sched_domains_numa_masks[level][cpu_to_node(cpu)]);
+
+	*sd = (struct sched_domain){
+		.min_interval		= sd_weight,
+		.max_interval		= 2*sd_weight,
+		.busy_factor		= 32,
+		.imbalance_pct		= 100 + numa_scale(25, level),
+		.cache_nice_tries	= 2,
+		.busy_idx		= 3,
+		.idle_idx		= 2,
+		.newidle_idx		= 0,
+		.wake_idx		= 0,
+		.forkexec_idx		= 0,
+
+		.flags			= 1*SD_LOAD_BALANCE
+					| 1*SD_BALANCE_NEWIDLE
+					| 0*SD_BALANCE_EXEC
+					| 0*SD_BALANCE_FORK
+					| 0*SD_BALANCE_WAKE
+					| 0*SD_WAKE_AFFINE
+					| 0*SD_PREFER_LOCAL
+					| 0*SD_SHARE_CPUPOWER
+					| 0*SD_POWERSAVINGS_BALANCE
+					| 0*SD_SHARE_PKG_RESOURCES
+					| 1*SD_SERIALIZE
+					| 0*SD_PREFER_SIBLING
+					| sd_local_flags(level)
+					,
+		.last_balance		= jiffies,
+		.balance_interval	= sd_weight,
+	};
+	SD_INIT_NAME(sd, NUMA);
+	sd->private = &tl->data;
+
+	/*
+	 * Ugly hack to pass state to sd_numa_mask()...
+	 */
+	sched_domains_curr_level = tl->numa_level;
+
+	return sd;
+}
+
+static const struct cpumask *sd_numa_mask(int cpu)
+{
+	return sched_domains_numa_masks[sched_domains_curr_level][cpu_to_node(cpu)];
+}
+
+static void sched_init_numa(void)
+{
+	int next_distance, curr_distance = node_distance(0, 0);
+	struct sched_domain_topology_level *tl;
+	int level = 0;
+	int i, j, k;
+
+	sched_domains_numa_scale = curr_distance;
+	sched_domains_numa_distance = kzalloc(sizeof(int) * nr_node_ids, GFP_KERNEL);
+	if (!sched_domains_numa_distance)
+		return;
+
+	/*
+	 * O(nr_nodes^2) deduplicating selection sort -- in order to find the
+	 * unique distances in the node_distance() table.
+	 *
+	 * Assumes node_distance(0,j) includes all distances in
+	 * node_distance(i,j) in order to avoid cubic time.
+	 *
+	 * XXX: could be optimized to O(n log n) by using sort()
+	 */
+	next_distance = curr_distance;
+	for (i = 0; i < nr_node_ids; i++) {
+		for (j = 0; j < nr_node_ids; j++) {
+			int distance = node_distance(0, j);
+			if (distance > curr_distance &&
+					(distance < next_distance ||
+					 next_distance == curr_distance))
+				next_distance = distance;
+		}
+		if (next_distance != curr_distance) {
+			sched_domains_numa_distance[level++] = next_distance;
+			sched_domains_numa_levels = level;
+			curr_distance = next_distance;
+		} else break;
+	}
+	/*
+	 * 'level' contains the number of unique distances, excluding the
+	 * identity distance node_distance(i,i).
+	 *
+	 * The sched_domains_nume_distance[] array includes the actual distance
+	 * numbers.
+	 */
+
+	sched_domains_numa_masks = kzalloc(sizeof(void *) * level, GFP_KERNEL);
+	if (!sched_domains_numa_masks)
+		return;
+
+	/*
+	 * Now for each level, construct a mask per node which contains all
+	 * cpus of nodes that are that many hops away from us.
+	 */
+	for (i = 0; i < level; i++) {
+		sched_domains_numa_masks[i] =
+			kzalloc(nr_node_ids * sizeof(void *), GFP_KERNEL);
+		if (!sched_domains_numa_masks[i])
+			return;
+
+		for (j = 0; j < nr_node_ids; j++) {
+			struct cpumask *mask = kzalloc_node(cpumask_size(), GFP_KERNEL, j);
+			if (!mask)
+				return;
+
+			sched_domains_numa_masks[i][j] = mask;
+
+			for (k = 0; k < nr_node_ids; k++) {
+				if (node_distance(cpu_to_node(j), k) >
+						sched_domains_numa_distance[i])
+					continue;
+
+				cpumask_or(mask, mask, cpumask_of_node(k));
+			}
+		}
+	}
+
+	tl = kzalloc((ARRAY_SIZE(default_topology) + level) *
+			sizeof(struct sched_domain_topology_level), GFP_KERNEL);
+	if (!tl)
+		return;
+
+	/*
+	 * Copy the default topology bits..
+	 */
+	for (i = 0; default_topology[i].init; i++)
+		tl[i] = default_topology[i];
+
+	/*
+	 * .. and append 'j' levels of NUMA goodness.
+	 */
+	for (j = 0; j < level; i++, j++) {
+		tl[i] = (struct sched_domain_topology_level){
+			.init = sd_numa_init,
+			.mask = sd_numa_mask,
+			.flags = SDTL_OVERLAP,
+			.numa_level = j,
+		};
+	}
+
+	sched_domain_topology = tl;
+}
+#else
+static inline void sched_init_numa(void)
+{
+}
+#endif /* CONFIG_NUMA */
+
 static int __sdt_alloc(const struct cpumask *cpu_map)
 {
 	struct sched_domain_topology_level *tl;
@@ -6840,6 +6928,8 @@ void __init sched_init_smp(void)
 	alloc_cpumask_var(&non_isolated_cpus, GFP_KERNEL);
 	alloc_cpumask_var(&fallback_doms, GFP_KERNEL);
 
+	sched_init_numa();
+
 	get_online_cpus();
 	mutex_lock(&sched_domains_mutex);
 	init_sched_domains(cpu_active_mask);
