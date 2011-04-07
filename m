Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188Ab1DGCIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 22:08:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:51014 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932152Ab1DGCIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 22:08:15 -0400
Date: Thu, 7 Apr 2011 02:08:05 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, tj@kernel.org, tglx@linutronix.de,
        rientjes@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tj@kernel.org, tglx@linutronix.de,
        rientjes@google.com
In-Reply-To: <1301955840-7246-12-git-send-email-tj@kernel.org>
References: <1301955840-7246-12-git-send-email-tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/numa] x86-32, numa: Make pgdat allocation use alloc_remap()
Message-ID: <tip-b2e3e4fa3eee752b893687783f2a427106c93423@git.kernel.org>
Git-Commit-ID: b2e3e4fa3eee752b893687783f2a427106c93423
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 07 Apr 2011 02:08:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b2e3e4fa3eee752b893687783f2a427106c93423
Gitweb:     http://git.kernel.org/tip/b2e3e4fa3eee752b893687783f2a427106c93423
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Tue, 5 Apr 2011 00:23:57 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 6 Apr 2011 17:57:39 -0700

x86-32, numa: Make pgdat allocation use alloc_remap()

pgdat allocation is handled differnetly from other remap allocations -
it's reserved during initialization.  There's no reason to handle this
any differnetly.  Remap allocator is initialized for every node and if
init failed the allocation will fail and pgdat allocation can fall
back to generic code like anyone else.

Remove special init-time pgdat reservation and make allocate_pgdat()
use alloc_remap() like everyone else.

Signed-off-by: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/1301955840-7246-12-git-send-email-tj@kernel.org
Acked-by: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
