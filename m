Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886Ab1DDWZa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 18:25:30 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47295 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578Ab1DDWYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 18:24:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=iUwcD5GazAm6k5frZ92Lg/9HUaIx2gV+Lh35FhpSRM2TStxHEpBB9Eljagp1RjZS7Y
         s3ldyvbqLByqHVdZgPkuwmGlGD7ZBTSKgs/z8TtAnCZHFhRSzUZ54ThuzMXegNZCT0pC
         Nddsb/T669JzrrdnooUrqEqqmbWenoHx6Vgow=
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de, rientjes@google.com,
        yinghai@kernel.org, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/14] x86-32, NUMA: Make pgdat allocation use alloc_remap()
Date: Tue,  5 Apr 2011 00:23:57 +0200
Message-Id: <1301955840-7246-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1301955840-7246-1-git-send-email-tj@kernel.org>
References: <1301955840-7246-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pgdat allocation is handled differnetly from other remap allocations -
it's reserved during initialization.  There's no reason to handle this
any differnetly.  Remap allocator is initialized for every node and if
init failed the allocation will fail and pgdat allocation can fall
back to generic code like anyone else.

Remove special init-time pgdat reservation and make allocate_pgdat()
use alloc_remap() like everyone else.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/mm/numa_32.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index 53ec13a..0184a9f 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -160,9 +160,8 @@ static void __init allocate_pgdat(int nid)
 {
 	char buf[16];
 
-	if (node_has_online_mem(nid) && node_remap_start_vaddr[nid])
-		NODE_DATA(nid) = (pg_data_t *)node_remap_start_vaddr[nid];
-	else {
+	NODE_DATA(nid) = alloc_remap(nid, ALIGN(sizeof(pg_data_t), PAGE_SIZE));
+	if (!NODE_DATA(nid)) {
 		unsigned long pgdat_phys;
 		pgdat_phys = memblock_find_in_range(min_low_pfn<<PAGE_SHIFT,
 				 max_pfn_mapped<<PAGE_SHIFT,
@@ -301,7 +300,7 @@ static __init unsigned long init_alloc_remap(int nid, unsigned long offset)
 
 	node_remap_start_vaddr[nid] = remap_va;
 	node_remap_end_vaddr[nid] = remap_va + size;
-	node_remap_alloc_vaddr[nid] = remap_va + ALIGN(sizeof(pg_data_t), PAGE_SIZE);
+	node_remap_alloc_vaddr[nid] = remap_va;
 
 	printk(KERN_DEBUG "remap_alloc: node %d [%08llx-%08llx) -> [%p-%p)\n",
 	       nid, node_pa, node_pa + size, remap_va, remap_va + size);
-- 
1.7.1

