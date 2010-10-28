Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759443Ab0J1Qz4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 12:55:56 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:51492 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759423Ab0J1Qzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 12:55:51 -0400
Message-ID: <4CC9A9C9.8020700@kernel.org>
Date: Thu, 28 Oct 2010 09:50:17 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.14) Gecko/20101013 SUSE/3.0.9 Thunderbird/3.0.9
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] x86, memblock: Fix early_node_mem with big reserved region.
References: <4CC753AD.1090403@goop.org> <4CC7BD6D.2030104@kernel.org> <4CC889AF.1020402@goop.org>
In-Reply-To: <4CC889AF.1020402@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Jeremy said Xen could reserve huge mem but still show as ram in e820.
early_node_mem could not find range because of start/end adjusting.
and will go through fallback path. but fallback is still using 
memblock_x86_find_range_node(), and it is partially top-down because it
go through active_range entries from low to high.

Let's use memblock_find_in_range instead memblock_x86_find_range_node.
So get real top down in fallback path.

This is for 2.6.37.

And We may still need to make memblock_x86_find_range_node to do overall
top_down work.

Reported-by: Jeremy Fitzhardinge <jeremy@goop.org>
Tested-by: Jeremy Fitzhardinge <jeremy@goop.org>
Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/mm/numa_64.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

Index: linux-2.6/arch/x86/mm/numa_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/numa_64.c
+++ linux-2.6/arch/x86/mm/numa_64.c
@@ -178,11 +178,8 @@ static void * __init early_node_mem(int
 
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
 
