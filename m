Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463Ab1BPMVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 07:21:50 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36104 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932287Ab1BPMVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 07:21:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=dLOmNmufV47mx7DHT1YBJTBf09/sloa+qpTuN5nb0XaRCBg9dRldCXugUdcF507TCz
         1486+fPYzjbIvJhCGf8QCCOMygl/uloFCu+kaAc+gQMRYbcwzlaTEuwUWJQzqJAqz60c
         q5KfYPehFJYMNxc+LnBOPmdk94XABC9KVZtAo=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, mingo@elte.hu, hpa@linux.intel.com,
        ankita@in.ibm.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 17/33] x86-64, NUMA: Remove %NULL @nodeids handling from compute_hash_shift()
Date: Wed, 16 Feb 2011 13:20:51 +0100
Message-Id: <1297858867-25981-18-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297858867-25981-1-git-send-email-tj@kernel.org>
References: <1297858867-25981-1-git-send-email-tj@kernel.org>
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
index e211c00..243d18d 100644
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
@@ -706,6 +701,7 @@ static int __init split_nodes_size_interleave(u64 addr, u64 max_addr, u64 size)
 static int __init numa_emulation(unsigned long start_pfn,
 			unsigned long last_pfn, int acpi, int amd)
 {
+	static int nodeid[NR_NODE_MEMBLKS] __initdata;
 	u64 addr = start_pfn << PAGE_SHIFT;
 	u64 max_addr = last_pfn << PAGE_SHIFT;
 	int num_nodes;
@@ -730,7 +726,11 @@ static int __init numa_emulation(unsigned long start_pfn,
 
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

