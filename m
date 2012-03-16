Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422854Ab2CPOx1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 10:53:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:36576 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422808Ab2CPOxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 10:53:20 -0400
Message-Id: <20120316144241.812642744@chello.nl>
User-Agent: quilt/0.48-1
Date: Fri, 16 Mar 2012 15:40:54 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Dan Smith <danms@us.ibm.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 26/26] sched, numa: A few debug bits
References: <20120316144028.036474157@chello.nl>
Content-Disposition: inline; filename=numa-debug.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These shouldn't ever get in.. 

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched/numa.c |   41 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 36 insertions(+), 5 deletions(-)

--- a/kernel/sched/numa.c
+++ b/kernel/sched/numa.c
@@ -219,7 +219,9 @@ static u64 process_cpu_runtime(struct nu
 	rcu_read_lock();
 	t = p = ne_owner(ne);
 	if (p) do {
-		runtime += t->se.sum_exec_runtime; // @#$#@ 32bit
+		u64 tmp = t->se.sum_exec_runtime;
+		trace_printk("pid: %d ran: %llu ns\n", t->pid, tmp);
+		runtime += tmp; // @#$#@ 32bit
 	} while ((t = next_thread(t)) != p);
 	rcu_read_unlock();
 
@@ -518,7 +520,8 @@ static void update_node_load(struct node
 	 * If there was NUMA_FOREIGN load, that means this node was at its
 	 * maximum memory capacity, record that.
 	 */
-	set_max_mem_load(node_pages_load(nq->node));
+	set_max_mem_load(node_pages_load(nq->node) +
+			node_page_state(nq->node, NR_FREE_PAGES));
 }
 
 enum numa_balance_type {
@@ -556,6 +559,10 @@ static int find_busiest_node(int this_no
 		cpu_load = nq->remote_cpu_load;
 		mem_load = nq->remote_mem_load;
 
+		trace_printk("node_load(%d/%d): cpu: %ld, mem: %ld abs_cpu: %ld abs_mem: %ld\n",
+				node, this_node, cpu_load, mem_load,
+				nq->cpu_load, node_pages_load(node));
+
 		/*
 		 * If this node is overloaded on memory, we don't want more
 		 * tasks, bail!
@@ -580,6 +587,12 @@ static int find_busiest_node(int this_no
 		}
 	}
 
+	trace_printk("cpu_node: %d, cpu_load: %ld, mem_load: %ld, sum_cpu_load: %ld\n",
+			cpu_node, max_cpu_load, cpu_mem_load, sum_cpu_load);
+
+	trace_printk("mem_node: %d, cpu_load: %ld, mem_load: %ld, sum_mem_load: %ld\n",
+			mem_node, mem_cpu_load, max_mem_load, sum_mem_load);
+
 	/*
 	 * Nobody had overload of any kind, cool we're done!
 	 */
@@ -626,6 +639,9 @@ static int find_busiest_node(int this_no
 		imb->mem = (long)(node_pages_load(node) - imb->mem_load) / 2;
 	}
 
+	trace_printk("busiest_node: %d, cpu_imb: %ld, mem_imb: %ld, type: %d\n",
+			node, imb->cpu, imb->mem, imb->type);
+
 	return node;
 }
 
@@ -663,6 +679,9 @@ static void move_processes(struct node_q
 				     struct numa_entity,
 				     numa_entry);
 
+		trace_printk("numa_migrate(%d <- %d): candidate: %p\n",
+				this_nq->node, busiest_nq->node, ne);
+
 		ne_cpu = ne->nops->cpu_load(ne);
 		ne_mem = ne->nops->mem_load(ne);
 
@@ -672,20 +691,27 @@ static void move_processes(struct node_q
 			 * on the other end.
 			 */
 			if ((imb->type & NUMA_BALANCE_CPU) &&
-			    imb->cpu - cpu_moved < ne_cpu / 2)
+			    imb->cpu - cpu_moved < ne_cpu / 2) {
+				trace_printk("fail cpu: %ld %ld %ld\n", imb->cpu, cpu_moved, ne_cpu);
 				goto next;
+			}
 
 			/*
 			 * Avoid migrating ne's when we'll know we'll push our
 			 * node over the memory limit.
 			 */
 			if (max_mem_load &&
-			    imb->mem_load + mem_moved + ne_mem > max_mem_load)
+			    imb->mem_load + mem_moved + ne_mem > max_mem_load) {
+				trace_printk("fail mem: %ld %ld %ld %ld\n",
+						imb->mem_load, mem_moved, ne_mem, max_mem_load);
 				goto next;
+			}
 		}
 
-		if (!can_move_ne(ne))
+		if (!can_move_ne(ne)) {
+			trace_printk("%p, can_move_ne() fail\n", ne);
 			goto next;
+		}
 
 		__dequeue_ne(busiest_nq, ne);
 		__enqueue_ne(this_nq, ne);
@@ -702,6 +728,11 @@ static void move_processes(struct node_q
 		cpu_moved += ne_cpu;
 		mem_moved += ne_mem;
 
+		trace_printk("numa_migrate(%d <- %d): cpu_load: %ld mem_load: %ld, "
+				"cpu_moved: %ld, mem_moved: %ld\n",
+				this_nq->node, busiest_nq->node,
+				ne_cpu, ne_mem, cpu_moved, mem_moved);
+
 		if (imb->cpu - cpu_moved <= 0 &&
 		    imb->mem - mem_moved <= 0)
 			break;


