Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820Ab1FUPSs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 11:18:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:60018 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883Ab1FUPSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 11:18:46 -0400
Date: Tue, 21 Jun 2011 15:18:31 GMT
From: "tip-bot for cpw@sgi.com" <cpw@sgi.com>
Message-ID: <tip-442d3924926c62741912d8a930220af253922007@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        penberg@kernel.org, cpw@sgi.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        penberg@kernel.org, cpw@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110621122242.832589130@sgi.com>
References: <20110621122242.832589130@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86, UV: Remove cpumask_t from the stack
Git-Commit-ID: 442d3924926c62741912d8a930220af253922007
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 21 Jun 2011 15:18:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  442d3924926c62741912d8a930220af253922007
Gitweb:     http://git.kernel.org/tip/442d3924926c62741912d8a930220af253922007
Author:     cpw@sgi.com <cpw@sgi.com>
AuthorDate: Tue, 21 Jun 2011 07:21:31 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 21 Jun 2011 14:50:33 +0200

x86, UV: Remove cpumask_t from the stack

Remove the large stack-resident cpumask_t from
reset_with_ipi()'s stack by allocating one per uvhub.

Due to the limited size of the stack the potentially huge cpumask_t may
cause stack overrun.  We haven't seen it happen yet, but we need to make it
a practice not to push such structures onto the stack.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Link: http://lkml.kernel.org/r/20110621122242.832589130@sgi.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/uv/uv_bau.h |    1 +
 arch/x86/platform/uv/tlb_uv.c    |   19 +++++++++++++++----
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/uv/uv_bau.h b/arch/x86/include/asm/uv/uv_bau.h
index fa6a48e..16ce58c 100644
--- a/arch/x86/include/asm/uv/uv_bau.h
+++ b/arch/x86/include/asm/uv/uv_bau.h
@@ -488,6 +488,7 @@ struct bau_control {
 	struct bau_control	*uvhub_master;
 	struct bau_control	*socket_master;
 	struct ptc_stats	*statp;
+	cpumask_t		*cpumask;
 	unsigned long		timeout_interval;
 	unsigned long		set_bau_on_time;
 	atomic_t		active_descriptor_count;
diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index 191ef28..5265842 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -375,13 +375,13 @@ static void reset_with_ipi(struct pnmask *distribution, struct bau_control *bcp)
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
@@ -391,11 +391,11 @@ static void reset_with_ipi(struct pnmask *distribution, struct bau_control *bcp)
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
 
@@ -1696,6 +1696,16 @@ static void make_per_cpu_thp(struct bau_control *smaster)
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
@@ -1765,6 +1775,7 @@ static int __init summarize_uvhub_sockets(int nuvhubs,
 			socket++;
 			socket_mask = (socket_mask >> 1);
 		}
+		make_per_hub_cpumask(hmaster);
 	}
 	return 0;
 }
