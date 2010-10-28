Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759621Ab0J1Xkp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 19:40:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:42779 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759139Ab0J1Xkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 19:40:41 -0400
Date: Thu, 28 Oct 2010 23:40:12 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, jeremy@goop.org, hpa@zytor.com,
        mingo@redhat.com, konrad.wilk@oracle.com, yinghai@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, jeremy@goop.org,
        linux-kernel@vger.kernel.org, yinghai@kernel.org,
        konrad.wilk@oracle.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <4CC9A9C9.8020700@kernel.org>
References: <4CC9A9C9.8020700@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, memblock: Fix early_node_mem with big reserved region.
Message-ID: <tip-419db274bed4269f475a8e78cbe9c917192cfe8b@git.kernel.org>
Git-Commit-ID: 419db274bed4269f475a8e78cbe9c917192cfe8b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 28 Oct 2010 23:40:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  419db274bed4269f475a8e78cbe9c917192cfe8b
Gitweb:     http://git.kernel.org/tip/419db274bed4269f475a8e78cbe9c917192cfe8b
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 28 Oct 2010 09:50:17 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 28 Oct 2010 15:52:36 -0700

x86, memblock: Fix early_node_mem with big reserved region.

Xen can reserve huge amounts of memory for pre-ballooning, but that
still shows as RAM in the e820 memory map.  early_node_mem could not
find range because of start/end adjusting, and will go through the
fallback path.  However, the fallback patch is still using
memblock_x86_find_range_node(), and it is partially top-down because
it go through active_range entries from low to high.

Let's use memblock_find_in_range instead memblock_x86_find_range_node.
So get real top down in fallback path.

We may still need to make memblock_x86_find_range_node to do overall
top_down work.

Reported-by: Jeremy Fitzhardinge <jeremy@goop.org>
Tested-by: Jeremy Fitzhardinge <jeremy@goop.org>
Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <4CC9A9C9.8020700@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/numa_64.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 60f4985..7ffc9b7 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -178,11 +178,8 @@ static void * __init early_node_mem(int nodeid, unsigned long start,
 
 	/* extend the search scope */
 	end = max_pfn_mapped << PAGE_SHIFT;
-	if (end > (MAX_DMA32_PFN<<PAGE_SHIFT))
-		start = MAX_DMA32_PFN<<PAGE_SHIFT;
-	else
-		start = MAX_DMA_PFN<<PAGE_SHIFT;
-	mem = memblock_x86_find_in_range_node(nodeid, start, end, size, align);
+	start = MAX_DMA_PFN << PAGE_SHIFT;
+	mem = memblock_find_in_range(start, end, size, align);
 	if (mem != MEMBLOCK_ERROR)
 		return __va(mem);
 
