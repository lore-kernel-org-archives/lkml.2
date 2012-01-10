Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078Ab2AJXQB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 18:16:01 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33630 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757184Ab2AJXP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 18:15:57 -0500
Date: Tue, 10 Jan 2012 15:15:52 -0800
From: Tejun Heo <tj@kernel.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, rjw@sisk.pl, xen-devel@lists.xensource.com
Subject: Re: Bootup regression introduced by
 7bd0b0f0da3b1ec11cbcc798eb0ef747a1184077 ("memblock: Reimplement memblock
 allocation using reverse free area iterato") in v3.3-rc0
Message-ID: <20120110231552.GB26832@google.com>
References: <20120110202838.GA10402@phenom.dumpdata.com>
 <20120110222625.GA26832@google.com>
 <20120110224537.GA6572@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120110224537.GA6572@phenom.dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jan 10, 2012 at 05:45:37PM -0500, Konrad Rzeszutek Wilk wrote:
> (early) [    0.000000] memblock_find: [0x0, 0xfcdd000) size=8409088 align=4096 nid=1024
> (early) [    0.000000] memblock_find: [0x805000, 0xfcdd000) - adjusted
> (early) [    0.000000] memblock_find: cand [0x10567000, 0x100000000) -> (early) [0xfcdd000, 0xfcdd000) (early) - rejected
> (early) [    0.000000] memblock_find: cand [0x1e03000, 0x220a000) -> (early) [0x1e03000, 0x220a000) (early) - rejected
> (early) [    0.000000] memblock_find: cand [0x100000, 0x1000000) -> (early) [0x805000, 0x1000000) (early) - rejected
> (early) [    0.000000] memblock_find: cand [0x10000, 0x9b000) -> (early) [0x805000, 0x805000) (early) - rejected
> (early) [    0.000000] Kernel panic - not syncing: Cannot find space for the kernel page tables

So, it actually is a legitimate alloc failure.  It seems I've tried a
bit too hard at simplifying the allocator.  Does the following fix the
problem?

Thanks.

diff --git a/mm/memblock.c b/mm/memblock.c
index 2f55f19..77b5f22 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -106,14 +106,17 @@ phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t start,
 	if (end == MEMBLOCK_ALLOC_ACCESSIBLE)
 		end = memblock.current_limit;
 
-	/* adjust @start to avoid underflow and allocating the first page */
-	start = max3(start, size, (phys_addr_t)PAGE_SIZE);
+	/* avoid allocating the first page */
+	start = max_t(phys_addr_t, start, PAGE_SIZE);
 	end = max(start, end);
 
 	for_each_free_mem_range_reverse(i, nid, &this_start, &this_end, NULL) {
 		this_start = clamp(this_start, start, end);
 		this_end = clamp(this_end, start, end);
 
+		if (this_end < size)
+			continue;
+
 		cand = round_down(this_end - size, align);
 		if (cand >= this_start)
 			return cand;

