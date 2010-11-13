Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336Ab0KMSx2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 13:53:28 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:33046 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755998Ab0KMSx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 13:53:27 -0500
Message-ID: <4CDEDE59.40603@kernel.org>
Date: Sat, 13 Nov 2010 10:52:09 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101026 SUSE/3.0.10 Thunderbird/3.0.10
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Shaohua Li <shaohua.li@intel.com>
Subject: [PATCH] x86: Use online node real index in calulate_tbl_offset()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- resending, hope in can make into -rc2.

Found one numa system that doesn't have ram installed with first socket
hang during executing init scripts.

bisect to:

|commit 932967202182743c01a2eee4bdfa2c42697bc586
|Author: Shaohua Li <shaohua.li@intel.com>
|Date:   Wed Oct 20 11:07:03 2010 +0800
|
|    x86: Spread tlb flush vector between nodes

It turns out when first socket is not online could have cpus on node1
tlb_offset set to bigger than NUM_INVALIDATE_TLB_VECTORS.

that could affect systems like 4 sockets, but socket 2 doesn't
have installed, sockets 3 will get too big tlb_offset.

Need to use real online node idx.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Shaohua Li <shaohua.li@intel.com>

---
 arch/x86/mm/tlb.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/mm/tlb.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/tlb.c
+++ linux-2.6/arch/x86/mm/tlb.c
@@ -223,7 +223,7 @@ void native_flush_tlb_others(const struc
 
 static void __cpuinit calculate_tlb_offset(void)
 {
-	int cpu, node, nr_node_vecs;
+	int cpu, node, nr_node_vecs, idx = 0;
 	/*
 	 * we are changing tlb_vector_offset for each CPU in runtime, but this
 	 * will not cause inconsistency, as the write is atomic under X86. we
@@ -239,7 +239,7 @@ static void __cpuinit calculate_tlb_offs
 		nr_node_vecs = NUM_INVALIDATE_TLB_VECTORS/nr_online_nodes;
 
 	for_each_online_node(node) {
-		int node_offset = (node % NUM_INVALIDATE_TLB_VECTORS) *
+		int node_offset = (idx % NUM_INVALIDATE_TLB_VECTORS) *
 			nr_node_vecs;
 		int cpu_offset = 0;
 		for_each_cpu(cpu, cpumask_of_node(node)) {
@@ -248,6 +248,7 @@ static void __cpuinit calculate_tlb_offs
 			cpu_offset++;
 			cpu_offset = cpu_offset % nr_node_vecs;
 		}
+		idx++;
 	}
 }
 
