Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163Ab0KROIF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 09:08:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:41274 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756591Ab0KROID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 09:08:03 -0500
Date: Thu, 18 Nov 2010 14:07:20 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, torvalds@linux-foundation.org,
        shaohua.li@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, torvalds@linux-foundation.org, tglx@linutronix.de,
        shaohua.li@intel.com, mingo@elte.hu
In-Reply-To: <4CDEDE59.40603@kernel.org>
References: <4CDEDE59.40603@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Use online node real index in calulate_tbl_offset()
Message-ID: <tip-9223081f54e3dc5045fe41a475165d9003c9a779@git.kernel.org>
Git-Commit-ID: 9223081f54e3dc5045fe41a475165d9003c9a779
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 18 Nov 2010 14:07:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9223081f54e3dc5045fe41a475165d9003c9a779
Gitweb:     http://git.kernel.org/tip/9223081f54e3dc5045fe41a475165d9003c9a779
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Sat, 13 Nov 2010 10:52:09 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 18 Nov 2010 10:10:50 +0100

x86: Use online node real index in calulate_tbl_offset()

Found a NUMA system that doesn't have RAM installed at the first
socket which hangs while executing init scripts.

bisected it to:

 | commit 932967202182743c01a2eee4bdfa2c42697bc586
 | Author: Shaohua Li <shaohua.li@intel.com>
 | Date:   Wed Oct 20 11:07:03 2010 +0800
 |
 |     x86: Spread tlb flush vector between nodes

It turns out when first socket is not online it could have cpus on
node1 tlb_offset set to bigger than NUM_INVALIDATE_TLB_VECTORS.

That could affect systems like 4 sockets, but socket 2 doesn't
have installed, sockets 3 will get too big tlb_offset.

Need to use real online node idx.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Shaohua Li <shaohua.li@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <4CDEDE59.40603@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/tlb.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 12cdbb1..6acc724 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -223,7 +223,7 @@ void native_flush_tlb_others(const struct cpumask *cpumask,
 
 static void __cpuinit calculate_tlb_offset(void)
 {
-	int cpu, node, nr_node_vecs;
+	int cpu, node, nr_node_vecs, idx = 0;
 	/*
 	 * we are changing tlb_vector_offset for each CPU in runtime, but this
 	 * will not cause inconsistency, as the write is atomic under X86. we
@@ -239,7 +239,7 @@ static void __cpuinit calculate_tlb_offset(void)
 		nr_node_vecs = NUM_INVALIDATE_TLB_VECTORS/nr_online_nodes;
 
 	for_each_online_node(node) {
-		int node_offset = (node % NUM_INVALIDATE_TLB_VECTORS) *
+		int node_offset = (idx % NUM_INVALIDATE_TLB_VECTORS) *
 			nr_node_vecs;
 		int cpu_offset = 0;
 		for_each_cpu(cpu, cpumask_of_node(node)) {
@@ -248,6 +248,7 @@ static void __cpuinit calculate_tlb_offset(void)
 			cpu_offset++;
 			cpu_offset = cpu_offset % nr_node_vecs;
 		}
+		idx++;
 	}
 }
 
