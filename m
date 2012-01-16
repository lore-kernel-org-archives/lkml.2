Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777Ab2APJEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 04:04:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45068 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677Ab2APJEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 04:04:20 -0500
Date: Mon, 16 Jan 2012 01:03:50 -0800
From: tip-bot for Tejun Heo <tj@kernel.org>
Message-ID: <tip-5d53cb27d849c899136c048ec84c940ac449494b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        konrad.wilk@oracle.com, torvalds@linux-foundation.org,
        benh@kernel.crashing.org, akpm@linux-foundation.org, tj@kernel.org,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, konrad.wilk@oracle.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20120113181412.GA11112@google.com>
References: <20120113181412.GA11112@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] memblock:
  Fix alloc failure due to dumb underflow protection in memblock_find_in_range_node
 ()
Git-Commit-ID: 5d53cb27d849c899136c048ec84c940ac449494b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 16 Jan 2012 01:03:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5d53cb27d849c899136c048ec84c940ac449494b
Gitweb:     http://git.kernel.org/tip/5d53cb27d849c899136c048ec84c940ac449494b
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Fri, 13 Jan 2012 10:14:12 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 16 Jan 2012 08:38:06 +0100

memblock: Fix alloc failure due to dumb underflow protection in memblock_find_in_range_node()

7bd0b0f0da ("memblock: Reimplement memblock allocation using
reverse free area iterator") implemented a simple top-down
allocator using a reverse memblock iterator.  To avoid underflow
in the allocator loop, it simply raised the lower boundary to
the requested size under the assumption that requested size
would be far smaller than available memblocks.

This causes early page table allocation failure under certain
configurations in Xen.  Fix it by checking for underflow directly
instead of bumping up lower bound.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: rjw@sisk.pl
Cc: xen-devel@lists.xensource.com
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20120113181412.GA11112@google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 mm/memblock.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

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
