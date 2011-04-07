Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312Ab1DGCGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 22:06:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:50921 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755224Ab1DGCGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 22:06:06 -0400
Date: Thu, 7 Apr 2011 02:05:56 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, tj@kernel.org, tglx@linutronix.de,
        rientjes@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tj@kernel.org, tglx@linutronix.de,
        rientjes@google.com
In-Reply-To: <1301955840-7246-7-git-send-email-tj@kernel.org>
References: <1301955840-7246-7-git-send-email-tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/numa] x86-32, numa: Make @size in init_aloc_remap() represent bytes
Message-ID: <tip-af7c1a6e8374e05aab4a98ce4d2fb07b66506a02@git.kernel.org>
Git-Commit-ID: af7c1a6e8374e05aab4a98ce4d2fb07b66506a02
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 07 Apr 2011 02:05:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  af7c1a6e8374e05aab4a98ce4d2fb07b66506a02
Gitweb:     http://git.kernel.org/tip/af7c1a6e8374e05aab4a98ce4d2fb07b66506a02
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Tue, 5 Apr 2011 00:23:52 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 6 Apr 2011 17:57:11 -0700

x86-32, numa: Make @size in init_aloc_remap() represent bytes

@size variable in init_alloc_remap() is confusing in that it starts as
number of bytes as its name implies and then becomes number of pages.
Make it consistently represent bytes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/1301955840-7246-7-git-send-email-tj@kernel.org
Acked-by: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/mm/numa_32.c |   18 +++++++-----------
 1 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index 30933fe..99310d2 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -286,22 +286,19 @@ static __init unsigned long init_alloc_remap(int nid, unsigned long offset)
 	size = node_remap_size[nid];
 	size += ALIGN(sizeof(pg_data_t), PAGE_SIZE);
 
-	/* convert size to large (pmd size) pages, rounding up */
-	size = (size + LARGE_PAGE_BYTES - 1) / LARGE_PAGE_BYTES;
-	/* now the roundup is correct, convert to PAGE_SIZE pages */
-	size = size * PTRS_PER_PTE;
+	/* align to large page */
+	size = ALIGN(size, LARGE_PAGE_BYTES);
 
 	node_pa = memblock_find_in_range(node_start_pfn[nid] << PAGE_SHIFT,
 					 (u64)node_end_pfn[nid] << PAGE_SHIFT,
-					 (u64)size << PAGE_SHIFT,
-					 LARGE_PAGE_BYTES);
+					 size, LARGE_PAGE_BYTES);
 	if (node_pa == MEMBLOCK_ERROR)
 		panic("Can not get kva ram\n");
 
-	node_remap_size[nid] = size;
+	node_remap_size[nid] = size >> PAGE_SHIFT;
 	node_remap_offset[nid] = offset;
 	printk(KERN_DEBUG "Reserving %ld pages of KVA for lmem_map of node %d at %llx\n",
-	       size, nid, node_pa >> PAGE_SHIFT);
+	       size >> PAGE_SHIFT, nid, node_pa >> PAGE_SHIFT);
 
 	/*
 	 *  prevent kva address below max_low_pfn want it on system
@@ -315,12 +312,11 @@ static __init unsigned long init_alloc_remap(int nid, unsigned long offset)
 	 *  So memblock_x86_reserve_range here, hope we don't run out
 	 *  of that array
 	 */
-	memblock_x86_reserve_range(node_pa, node_pa + ((u64)size << PAGE_SHIFT),
-				   "KVA RAM");
+	memblock_x86_reserve_range(node_pa, node_pa + size, "KVA RAM");
 
 	node_remap_start_pfn[nid] = node_pa >> PAGE_SHIFT;
 
-	return size;
+	return size >> PAGE_SHIFT;
 }
 
 static void init_remap_allocator(int nid)
