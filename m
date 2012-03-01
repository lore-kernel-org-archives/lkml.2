Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758996Ab2CAMZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 07:25:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37646 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758924Ab2CAMZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 07:25:38 -0500
Date: Thu, 1 Mar 2012 04:24:43 -0800
From: tip-bot for Tejun Heo <tj@kernel.org>
Message-ID: <tip-847854f5988a04fe7e02d2fdd4fa0df9f96360fe@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca, hpa@zytor.com,
        mingo@redhat.com, torvalds@linux-foundation.org, davem@davemloft.net,
        rob.herring@calxeda.com, akpm@linux-foundation.org, tj@kernel.org,
        mroos@linux.ee, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        davem@davemloft.net, rob.herring@calxeda.com,
        akpm@linux-foundation.org, mroos@linux.ee, tj@kernel.org,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <alpine.SOC.1.00.1202130942030.1488@math.ut.ee>
References: <20120228205621.GC3252@dhcp-172-17-108-109.mtv.corp.google.com>
	<alpine.SOC.1.00.1202130942030.1488@math.ut.ee>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] memblock:
  Fix size aligning of memblock_alloc_base_nid()
Git-Commit-ID: 847854f5988a04fe7e02d2fdd4fa0df9f96360fe
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 01 Mar 2012 04:25:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  847854f5988a04fe7e02d2fdd4fa0df9f96360fe
Gitweb:     http://git.kernel.org/tip/847854f5988a04fe7e02d2fdd4fa0df9f96360fe
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Wed, 29 Feb 2012 05:56:21 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 1 Mar 2012 10:53:18 +0100

memblock: Fix size aligning of memblock_alloc_base_nid()

memblock allocator aligns @size to @align to reduce the amount
of fragmentation.  Commit:

 7bd0b0f0da ("memblock: Reimplement memblock allocation using reverse free area iterator")

Broke it by incorrectly relocating @size aligning to
memblock_find_in_range_node().  As the aligned size is not
propagated back to memblock_alloc_base_nid(), the actually
reserved size isn't aligned.

While this increases memory use for memblock reserved array,
this shouldn't cause any critical failure; however, it seems
that the size aligning was hiding a use-beyond-allocation bug in
sparc64 and losing the aligning causes boot failure.

The underlying problem is currently being debugged but this is a
proper fix in itself, it's already pretty late in -rc cycle for
boot failures and reverting the change for debugging isn't
difficult. Restore the size aligning moving it to
memblock_alloc_base_nid().

Reported-by: Meelis Roos <mroos@linux.ee>
Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20120228205621.GC3252@dhcp-172-17-108-109.mtv.corp.google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <alpine.SOC.1.00.1202130942030.1488@math.ut.ee>
---
 mm/memblock.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 77b5f22..99f2855 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -99,9 +99,6 @@ phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t start,
 	phys_addr_t this_start, this_end, cand;
 	u64 i;
 
-	/* align @size to avoid excessive fragmentation on reserved array */
-	size = round_up(size, align);
-
 	/* pump up @end */
 	if (end == MEMBLOCK_ALLOC_ACCESSIBLE)
 		end = memblock.current_limit;
@@ -731,6 +728,9 @@ static phys_addr_t __init memblock_alloc_base_nid(phys_addr_t size,
 {
 	phys_addr_t found;
 
+	/* align @size to avoid excessive fragmentation on reserved array */
+	size = round_up(size, align);
+
 	found = memblock_find_in_range_node(0, max_addr, size, align, nid);
 	if (found && !memblock_reserve(found, size))
 		return found;
