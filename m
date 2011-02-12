Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449Ab1BLRNJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 12:13:09 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65372 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab1BLRLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 12:11:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=FvNGW7iZB3jkzrLH4SZJ3QVe5AkvZG34at9G4H8ogJUjyaY2PcFpjf3iet7/rhWnNZ
         mjgQKYC78O8l1+/5K4LT3PT4psA0uJq7xTkGHwWLOaiBc5CDjLXHLg1acQLBOevQiWqo
         LxCuAvwtFOQudRTuYTFmAwWxkvgaZMzptjTio=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, mingo@elte.hu, hpa@linux.intel.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 17/26] x86-64, NUMA: Remove %NULL @nodeids handling from compute_hash_shift()
Date: Sat, 12 Feb 2011 18:10:54 +0100
Message-Id: <1297530663-26234-18-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297530663-26234-1-git-send-email-tj@kernel.org>
References: <1297530663-26234-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

numa_emulation() called compute_hash_shift() with %NULL @nodeids which
meant identity mapping between index and nodeid.  Make
numa_emulation() build identity array and drop %NULL @nodeids handling
from populate_memnodemap() and thus from compute_hash_shift().  This
is to prepare for transition to using memblks instead.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Shaohui Zheng <shaohui.zheng@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/numa_64.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index be173c4..1d79cd8 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -63,12 +63,7 @@ static int __init populate_memnodemap(const struct bootnode *nodes,
 		do {
 			if (memnodemap[addr >> shift] != NUMA_NO_NODE)
 				return -1;
-
-			if (!nodeids)
-				memnodemap[addr >> shift] = i;
-			else
-				memnodemap[addr >> shift] = nodeids[i];
-
+			memnodemap[addr >> shift] = nodeids[i];
 			addr += (1UL << shift);
 		} while (addr < end);
 		res = 1;
@@ -704,6 +699,7 @@ static int __init split_nodes_size_interleave(u64 addr, u64 max_addr, u64 size)
 static int __init numa_emulation(unsigned long start_pfn,
 			unsigned long last_pfn, int acpi, int amd)
 {
+	static int nodeid[NR_NODE_MEMBLKS] __initdata;
 	u64 addr = start_pfn << PAGE_SHIFT;
 	u64 max_addr = last_pfn << PAGE_SHIFT;
 	int num_nodes;
@@ -728,7 +724,11 @@ static int __init numa_emulation(unsigned long start_pfn,
 
 	if (num_nodes < 0)
 		return num_nodes;
-	memnode_shift = compute_hash_shift(nodes, num_nodes, NULL);
+
+	for (i = 0; i < ARRAY_SIZE(nodeid); i++)
+		nodeid[i] = i;
+
+	memnode_shift = compute_hash_shift(nodes, num_nodes, nodeid);
 	if (memnode_shift < 0) {
 		memnode_shift = 0;
 		printk(KERN_ERR "No NUMA hash function found.  NUMA emulation "
-- 
1.7.1

