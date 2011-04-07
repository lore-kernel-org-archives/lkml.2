Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319Ab1DGCFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 22:05:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:50898 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932146Ab1DGCFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 22:05:39 -0400
Date: Thu, 7 Apr 2011 02:05:33 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tj@kernel.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tj@kernel.org, tglx@linutronix.de
In-Reply-To: <1301955840-7246-6-git-send-email-tj@kernel.org>
References: <1301955840-7246-6-git-send-email-tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/numa] x86-32, numa: Rename @node_kva to @node_pa in init_alloc_remap()
Message-ID: <tip-c4d4f577d49c441ab4f1bb6068247dafb366e635@git.kernel.org>
Git-Commit-ID: c4d4f577d49c441ab4f1bb6068247dafb366e635
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 07 Apr 2011 02:05:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c4d4f577d49c441ab4f1bb6068247dafb366e635
Gitweb:     http://git.kernel.org/tip/c4d4f577d49c441ab4f1bb6068247dafb366e635
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Tue, 5 Apr 2011 00:23:51 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 6 Apr 2011 17:57:04 -0700

x86-32, numa: Rename @node_kva to @node_pa in init_alloc_remap()

init_alloc_remap() is about to do more and using _kva suffix for
physical address becomes confusing because the function will be
handling both physical and virtual addresses.  Rename @node_kva to
@node_pa.

This is trivial rename and doesn't cause any behavior difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/1301955840-7246-6-git-send-email-tj@kernel.org
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/mm/numa_32.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index 5039e9b..30933fe 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -267,7 +267,7 @@ void resume_map_numa_kva(pgd_t *pgd_base)
 static __init unsigned long init_alloc_remap(int nid, unsigned long offset)
 {
 	unsigned long size;
-	u64 node_kva;
+	u64 node_pa;
 
 	/*
 	 * The acpi/srat node info can show hot-add memroy zones where
@@ -291,17 +291,17 @@ static __init unsigned long init_alloc_remap(int nid, unsigned long offset)
 	/* now the roundup is correct, convert to PAGE_SIZE pages */
 	size = size * PTRS_PER_PTE;
 
-	node_kva = memblock_find_in_range(node_start_pfn[nid] << PAGE_SHIFT,
-					  (u64)node_end_pfn[nid] << PAGE_SHIFT,
-					  (u64)size << PAGE_SHIFT,
-					  LARGE_PAGE_BYTES);
-	if (node_kva == MEMBLOCK_ERROR)
+	node_pa = memblock_find_in_range(node_start_pfn[nid] << PAGE_SHIFT,
+					 (u64)node_end_pfn[nid] << PAGE_SHIFT,
+					 (u64)size << PAGE_SHIFT,
+					 LARGE_PAGE_BYTES);
+	if (node_pa == MEMBLOCK_ERROR)
 		panic("Can not get kva ram\n");
 
 	node_remap_size[nid] = size;
 	node_remap_offset[nid] = offset;
 	printk(KERN_DEBUG "Reserving %ld pages of KVA for lmem_map of node %d at %llx\n",
-	       size, nid, node_kva >> PAGE_SHIFT);
+	       size, nid, node_pa >> PAGE_SHIFT);
 
 	/*
 	 *  prevent kva address below max_low_pfn want it on system
@@ -315,11 +315,10 @@ static __init unsigned long init_alloc_remap(int nid, unsigned long offset)
 	 *  So memblock_x86_reserve_range here, hope we don't run out
 	 *  of that array
 	 */
-	memblock_x86_reserve_range(node_kva,
-				   node_kva + ((u64)size << PAGE_SHIFT),
+	memblock_x86_reserve_range(node_pa, node_pa + ((u64)size << PAGE_SHIFT),
 				   "KVA RAM");
 
-	node_remap_start_pfn[nid] = node_kva >> PAGE_SHIFT;
+	node_remap_start_pfn[nid] = node_pa >> PAGE_SHIFT;
 
 	return size;
 }
