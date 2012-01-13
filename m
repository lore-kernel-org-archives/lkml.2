Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690Ab2AMSOX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 13:14:23 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58173 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758623Ab2AMSOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 13:14:18 -0500
Date: Fri, 13 Jan 2012 10:14:12 -0800
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, rjw@sisk.pl, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3.3-rc] memblock: Fix alloc failure due to dumb underflow
 protection in memblock_find_in_range_node()
Message-ID: <20120113181412.GA11112@google.com>
References: <20120110202838.GA10402@phenom.dumpdata.com>
 <20120110222625.GA26832@google.com>
 <20120110224537.GA6572@phenom.dumpdata.com>
 <20120110231552.GB26832@google.com>
 <20120111200435.GA8680@phenom.dumpdata.com>
 <20120113142703.GA7707@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120113142703.GA7707@phenom.dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

7bd0b0f0da "memblock: Reimplement memblock allocation using reverse
free area iterator" implemented simple top-down allocator using
reverse memblock iterator.  To avoid underflow in the allocator loop,
it simply raised the lower boundary to the requested size under the
assumption that requested size would be far smaller than available
memblocks.

This causes early page table allocation failure under certain
configurations.  Fix it by checking for underflow directly instead of
bumping up lower bound.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
LKML-Reference: <20120110202838.GA10402@phenom.dumpdata.com>
---
Sorry, I wrote the patch description and everything but forgot to
actually send it out. :)

Ingo, the new memblock allocator went too far with simplification and
caused unnecessary allocation failure.  The fix is fairly obvious and
simple.  Can you please route this patch?

Thanks.

 mm/memblock.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

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
