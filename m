Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab0I3MBT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 08:01:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34704 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754714Ab0I3MBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 08:01:18 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: [PATCH] Assign CPUs to nodes in round-robin manner on Fake NUMA.
Date: Thu, 30 Sep 2010 17:34:10 +0530
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.2-default; KDE/4.3.5; x86_64; ; )
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201009301734.10787.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assign CPUs to nodes in round-robin manner on Fake NUMA.

commit d9c2d5ac6af87b4491bff107113aaf16f6c2b2d9
"x86, numa: Use near(er) online node instead of roundrobin for NUMA"
changed NUMA initialization on Intel to choose the nearest online node or
first node. Fake NUMA would be better of with round-robin initialization,
instead of the all CPUS on first node. Change the choice of first node, back
to round-robin.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 85f69cd..47dd171 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -283,9 +283,7 @@ static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
 	/* Don't do the funky fallback heuristics the AMD version employs
 	   for now. */
 	node = apicid_to_node[apicid];
-	if (node == NUMA_NO_NODE)
-		node = first_node(node_online_map);
-	else if (!node_online(node)) {
+	if (node == NUMA_NO_NODE || !node_online(node)) {
 		/* reuse the value from init_cpu_to_node() */
 		node = cpu_to_node(cpu);
 	}
