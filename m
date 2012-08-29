Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab2H2C5Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 22:57:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59391 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab2H2C5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 22:57:23 -0400
Date: Tue, 28 Aug 2012 19:57:21 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Haggai Eran <haggaie@mellanox.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Pekka Enberg <penberg@kernel.org>
cc: LKML <linux-kernel@vger.kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>,
        Shachar Raindel <raindel@mellanox.com>
Subject: [patch v3.6] mm, slab: lock the correct nodelist after reenabling
 irqs
In-Reply-To: <503CA1A2.90104@mellanox.com>
Message-ID: <alpine.DEB.2.00.1208281947100.24229@chino.kir.corp.google.com>
References: <503CA1A2.90104@mellanox.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Aug 2012, Haggai Eran wrote:

> Hi,
> 
> I believe I have encountered a bug in kernel 3.6-rc3. It starts with the
> assertion in mm/slab.c:2629 failing, and then the system hangs. I can
> reproduce this bug by running a large compilation (compiling the kernel
> for instance).
> 
> Here's what I see in netconsole:
> > ------------[ cut here ]------------
> > kernel BUG at mm/slab.c:2629!
> > invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
> 
> I'm attaching netconsole logs I got with kernel 3.6-rc1, which contain a
> little more details after the crash, but for some reason netconsole
> didn't capture the full stack trace of the assertion. I caught a glimpse
> at the console and I saw RIP was at cache_alloc_refill.
> 

It only gets called from cache_alloc_refill().

Looks like a problem in 072bb0aa5e0 ("mm: sl[au]b: add knowledge of 
PFMEMALLOC reserve pages").  cache_grow() can reenable irqs which allows 
this to be scheduled on a different cpu, possibly with a different node.  
So it turns out that we lock the wrong node's list_lock because we don't 
check the new node id when irqs are disabled again.

I doubt you can reliably reproduce this, but the following should fix the 
issue.


mm, slab: lock the correct nodelist after reenabling irqs

cache_grow() can reenable irqs so the cpu (and node) can change, so ensure 
that we take list_lock on the correct nodelist.

Fixes an issue with 072bb0aa5e0 ("mm: sl[au]b: add knowledge of PFMEMALLOC 
reserve pages") where list_lock for the wrong node was taken after growing 
the cache.

Reported-by: Haggai Eran <haggaie@mellanox.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/slab.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/slab.c b/mm/slab.c
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3260,6 +3260,7 @@ force_grow:
 
 		/* cache_grow can reenable interrupts, then ac could change. */
 		ac = cpu_cache_get(cachep);
+		node = numa_mem_id();
 
 		/* no objects in sight? abort */
 		if (!x && (ac->avail == 0 || force_refill))
