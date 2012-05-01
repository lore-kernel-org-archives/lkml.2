Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039Ab2EAS3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 14:29:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34754 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962Ab2EAS2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 14:28:39 -0400
Message-Id: <20120501182610.862298529@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 01 May 2012 20:14:33 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@kernel.org, pjt@google.com, vatsa@in.ibm.com,
        suresh.b.siddha@intel.com, efault@gmx.de
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 3/5] x86: Allow specifying node_distance() for numa=fake
References: <20120501181430.007891123@chello.nl>
Content-Disposition: inline; filename=x86-numa-emulation.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allows emulating more interesting NUMA configurations like a quad
socket AMD Magny-Cour:

 "numa=fake=8:10,16,16,22,16,22,16,22,
              16,10,22,16,22,16,22,16,
              16,22,10,16,16,22,16,22,
              22,16,16,10,22,16,22,16,
              16,22,16,22,10,16,16,22,
              22,16,22,16,16,10,22,16,
              16,22,16,22,16,22,10,16,
              22,16,22,16,22,16,16,10"

Which has a non-fully-connected topology.

Cc: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: x86@kernel.org
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/mm/numa_emulation.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/mm/numa_emulation.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/numa_emulation.c
+++ linux-2.6/arch/x86/mm/numa_emulation.c
@@ -339,9 +339,11 @@ void __init numa_emulation(struct numa_m
 	} else {
 		unsigned long n;
 
-		n = simple_strtoul(emu_cmdline, NULL, 0);
+		n = simple_strtoul(emu_cmdline, &emu_cmdline, 0);
 		ret = split_nodes_interleave(&ei, &pi, 0, max_addr, n);
 	}
+	if (*emu_cmdline == ':')
+		emu_cmdline++;
 
 	if (ret < 0)
 		goto no_emu;
@@ -418,7 +420,9 @@ void __init numa_emulation(struct numa_m
 			int physj = emu_nid_to_phys[j];
 			int dist;
 
-			if (physi >= numa_dist_cnt || physj >= numa_dist_cnt)
+			if (get_option(&emu_cmdline, &dist) == 2)
+				;
+			else if (physi >= numa_dist_cnt || physj >= numa_dist_cnt)
 				dist = physi == physj ?
 					LOCAL_DISTANCE : REMOTE_DISTANCE;
 			else


