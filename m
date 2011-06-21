Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669Ab1FUMYI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 08:24:08 -0400
Received: from relay2.sgi.com ([192.48.179.30]:33406 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754858Ab1FUMWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 08:22:43 -0400
Message-Id: <20110621122242.497700003@sgi.com>
User-Agent: quilt/0.47-1
Date: Tue, 21 Jun 2011 07:21:29 -0500
From: cpw@sgi.com
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, x86@kernel.org
Subject: [patch 4/8 v5] x86, UV: correct reset_with_ipi()
References: <20110621122125.688884227@sgi.com>
Content-Disposition: inline; filename=tlb_uv_ipiresetpnode
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix reset_with_ipi() to look up a cpu for a blade based on the
distribution map being indexed by the potentially sparsely numbered pnode.

This patch is critical to tlb shootdown on a partitioned UV system, or one
with nonconsecutive blade numbers.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---

The distribution map bits represent pnodes relative to the partition base
pnode. Previous to this patch it had been assuming bits based on 0-based,
consecutive blade ids.

 arch/x86/platform/uv/tlb_uv.c |   33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

Index: linux/arch/x86/platform/uv/tlb_uv.c
===================================================================
--- linux.orig/arch/x86/platform/uv/tlb_uv.c
+++ linux/arch/x86/platform/uv/tlb_uv.c
@@ -296,14 +296,18 @@ static void bau_process_message(struct m
 }
 
 /*
- * Determine the first cpu on a uvhub.
+ * Determine the first cpu on a pnode.
  */
-static int uvhub_to_first_cpu(int uvhub)
+static int pnode_to_first_cpu(int pnode, struct bau_control *smaster)
 {
 	int cpu;
-	for_each_present_cpu(cpu)
-		if (uvhub == uv_cpu_to_blade_id(cpu))
+	struct hub_and_pnode *hpp;
+
+	for_each_present_cpu(cpu) {
+		hpp = &smaster->thp[cpu];
+		if (pnode == hpp->pnode)
 			return cpu;
+	}
 	return -1;
 }
 
@@ -366,23 +370,28 @@ static void do_reset(void *ptr)
  * Use IPI to get all target uvhubs to release resources held by
  * a given sending cpu number.
  */
-static void reset_with_ipi(struct bau_targ_hubmask *distribution, int sender)
+static void reset_with_ipi(struct bau_targ_hubmask *distribution,
+						struct bau_control *bcp)
 {
-	int uvhub;
+	int pnode;
+	int apnode;
 	int maskbits;
 	cpumask_t mask;
+	int sender = bcp->cpu;
+	struct bau_control *smaster = bcp->socket_master;
 	struct reset_args reset_args;
 
 	reset_args.sender = sender;
 	cpus_clear(mask);
 	/* find a single cpu for each uvhub in this distribution mask */
 	maskbits = sizeof(struct bau_targ_hubmask) * BITSPERBYTE;
-	for (uvhub = 0; uvhub < maskbits; uvhub++) {
+	/* each bit is a pnode relative to the partition base pnode */
+	for (pnode = 0; pnode < maskbits; pnode++) {
 		int cpu;
-		if (!bau_uvhub_isset(uvhub, distribution))
+		if (!bau_uvhub_isset(pnode, distribution))
 			continue;
-		/* find a cpu for this uvhub */
-		cpu = uvhub_to_first_cpu(uvhub);
+		apnode = pnode + bcp->partition_base_pnode;
+		cpu = pnode_to_first_cpu(apnode, smaster);
 		cpu_set(cpu, mask);
 	}
 
@@ -604,7 +613,7 @@ static void destination_plugged(struct b
 		quiesce_local_uvhub(hmaster);
 
 		spin_lock(&hmaster->queue_lock);
-		reset_with_ipi(&bau_desc->distribution, bcp->cpu);
+		reset_with_ipi(&bau_desc->distribution, bcp);
 		spin_unlock(&hmaster->queue_lock);
 
 		end_uvhub_quiesce(hmaster);
@@ -626,7 +635,7 @@ static void destination_timeout(struct b
 		quiesce_local_uvhub(hmaster);
 
 		spin_lock(&hmaster->queue_lock);
-		reset_with_ipi(&bau_desc->distribution, bcp->cpu);
+		reset_with_ipi(&bau_desc->distribution, bcp);
 		spin_unlock(&hmaster->queue_lock);
 
 		end_uvhub_quiesce(hmaster);

