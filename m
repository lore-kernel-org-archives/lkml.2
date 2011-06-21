Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755Ab1FUPRu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 11:17:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:59981 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476Ab1FUPRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 11:17:49 -0400
Date: Tue, 21 Jun 2011 15:17:36 GMT
From: "tip-bot for cpw@sgi.com" <cpw@sgi.com>
Message-ID: <tip-485f07d349a3e5059413b886a3bc1996c4b3d14d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com, cpw@sgi.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        cpw@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110621122242.497700003@sgi.com>
References: <20110621122242.497700003@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86, UV: Correct reset_with_ipi()
Git-Commit-ID: 485f07d349a3e5059413b886a3bc1996c4b3d14d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 21 Jun 2011 15:17:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  485f07d349a3e5059413b886a3bc1996c4b3d14d
Gitweb:     http://git.kernel.org/tip/485f07d349a3e5059413b886a3bc1996c4b3d14d
Author:     cpw@sgi.com <cpw@sgi.com>
AuthorDate: Tue, 21 Jun 2011 07:21:29 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 21 Jun 2011 14:50:32 +0200

x86, UV: Correct reset_with_ipi()

Fix reset_with_ipi() to look up a cpu for a blade based on the
distribution map being indexed by the potentially sparsely
numbered pnode.

This patch is critical to tlb shootdown on a partitioned UV
system, or one with nonconsecutive blade numbers.

The distribution map bits represent pnodes relative to the partition base
pnode. Previous to this patch it had been assuming bits based on 0-based,
consecutive blade ids.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Link: http://lkml.kernel.org/r/20110621122242.497700003@sgi.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/platform/uv/tlb_uv.c |   33 +++++++++++++++++++++------------
 1 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index 7623b08..4b28e09 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -296,14 +296,18 @@ static void bau_process_message(struct msg_desc *mdp,
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
 
@@ -604,7 +613,7 @@ static void destination_plugged(struct bau_desc *bau_desc,
 		quiesce_local_uvhub(hmaster);
 
 		spin_lock(&hmaster->queue_lock);
-		reset_with_ipi(&bau_desc->distribution, bcp->cpu);
+		reset_with_ipi(&bau_desc->distribution, bcp);
 		spin_unlock(&hmaster->queue_lock);
 
 		end_uvhub_quiesce(hmaster);
@@ -626,7 +635,7 @@ static void destination_timeout(struct bau_desc *bau_desc,
 		quiesce_local_uvhub(hmaster);
 
 		spin_lock(&hmaster->queue_lock);
-		reset_with_ipi(&bau_desc->distribution, bcp->cpu);
+		reset_with_ipi(&bau_desc->distribution, bcp);
 		spin_unlock(&hmaster->queue_lock);
 
 		end_uvhub_quiesce(hmaster);
