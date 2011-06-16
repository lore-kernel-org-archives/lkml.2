Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518Ab1FPPyI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 11:54:08 -0400
Received: from relay2.sgi.com ([192.48.179.30]:57171 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756527Ab1FPPxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 11:53:53 -0400
Message-Id: <20110616155353.303890316@sgi.com>
User-Agent: quilt/0.47-1
Date: Thu, 16 Jun 2011 10:10:38 -0500
From: cpw@sgi.com
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, x86@kernel.org, penberg@kernel.org
Subject: [patch 6/8 v4] x86, UV: remove cpumask_t from the stack
References: <20110616151032.729980001@gulag1.americas.sgi.com>
Content-Disposition: inline; filename=tlb_uv_ipiresetcpumask
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the large stack-resident cpumask_t from reset_with_ipi()'s stack
by allocating one per uvhub.

Diffed against 3.0.0-rc3

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
---

Due to the limited size of the stack the potentially huge cpumask_t may
cause stack overrun.  We haven't seen it happen yet, but we need to make it
a practice not to push such structures onto the stack.

 arch/x86/include/asm/uv/uv_bau.h |    1 +
 arch/x86/platform/uv/tlb_uv.c    |   19 +++++++++++++++----
 2 files changed, 16 insertions(+), 4 deletions(-)

Index: linux/arch/x86/include/asm/uv/uv_bau.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv_bau.h
+++ linux/arch/x86/include/asm/uv/uv_bau.h
@@ -488,6 +488,7 @@ struct bau_control {
 	struct bau_control	*uvhub_master;
 	struct bau_control	*socket_master;
 	struct ptc_stats	*statp;
+	cpumask_t		*cpumask;
 	unsigned long		timeout_interval;
 	unsigned long		set_bau_on_time;
 	atomic_t		active_descriptor_count;
Index: linux/arch/x86/platform/uv/tlb_uv.c
===================================================================
--- linux.orig/arch/x86/platform/uv/tlb_uv.c
+++ linux/arch/x86/platform/uv/tlb_uv.c
@@ -375,13 +375,13 @@ static void reset_with_ipi(struct pnmask
 	int pnode;
 	int apnode;
 	int maskbits;
-	cpumask_t mask;
 	int sender = bcp->cpu;
+	cpumask_t *mask = bcp->uvhub_master->cpumask;
 	struct bau_control *smaster = bcp->socket_master;
 	struct reset_args reset_args;
 
 	reset_args.sender = sender;
-	cpus_clear(mask);
+	cpus_clear(*mask);
 	/* find a single cpu for each uvhub in this distribution mask */
 	maskbits = sizeof(struct pnmask) * BITSPERBYTE;
 	/* each bit is a pnode relative to the partition base pnode */
@@ -391,11 +391,11 @@ static void reset_with_ipi(struct pnmask
 			continue;
 		apnode = pnode + bcp->partition_base_pnode;
 		cpu = pnode_to_first_cpu(apnode, smaster);
-		cpu_set(cpu, mask);
+		cpu_set(cpu, *mask);
 	}
 
 	/* IPI all cpus; preemption is already disabled */
-	smp_call_function_many(&mask, do_reset, (void *)&reset_args, 1);
+	smp_call_function_many(mask, do_reset, (void *)&reset_args, 1);
 	return;
 }
 
@@ -1696,6 +1696,16 @@ static void make_per_cpu_thp(struct bau_
 }
 
 /*
+ * Each uvhub is to get a local cpumask.
+ */
+static void make_per_hub_cpumask(struct bau_control *hmaster)
+{
+	int sz = sizeof(cpumask_t);
+
+	hmaster->cpumask = kzalloc_node(sz, GFP_KERNEL, hmaster->osnode);
+}
+
+/*
  * Initialize all the per_cpu information for the cpu's on a given socket,
  * given what has been gathered into the socket_desc struct.
  * And reports the chosen hub and socket masters back to the caller.
@@ -1765,6 +1775,7 @@ static int __init summarize_uvhub_socket
 			socket++;
 			socket_mask = (socket_mask >> 1);
 		}
+		make_per_hub_cpumask(hmaster);
 	}
 	return 0;
 }

