Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab1G1Wr7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 18:47:59 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45702 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534Ab1G1Wr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 18:47:56 -0400
Date: Fri, 29 Jul 2011 01:47:48 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tiger
To: torvalds@linux-foundation.org
cc: cl@linux-foundation.org, akpm@linux-foundation.org, rientjes@google.com,
        hughd@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [GIT PULL] Lockless SLUB slowpaths for v3.1-rc1
Message-ID: <alpine.DEB.2.00.1107290145080.3279@tiger>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This pull request has patches to make SLUB slowpaths lockless like we 
already did for the fastpaths. They have been sitting in linux-next for a 
while now and should be fine. David Rientjes reports improved performance:

   I ran slub/lockless through some stress testing and it seems to be quite
   stable on my testing cluster.  There is about a 2.3% performance
   improvement with the lockless slowpath on the netperf benchmark with
   various thread counts on my 16-core 64GB Opterons, so I'd recommend it to
   be merged into 3.1.

One possible gotcha, though, is that page struct gets bigger on x86_64. Hugh
Dickins writes:

   By the way, if you're thinking of lining up a pull request to Linus
   for 3.1, please make it very clear in that request that these changes
   enlarge the x86_64 struct page from 56 to 64 bytes, for slub alone.

   I remain very uneasy about that (love the cache alignment but...),
   the commit comment is rather vague about it, and I'm not sure that
   anyone else has noticed yet (akpm?).

   Given that Linus wouldn't let Kosaki add 4 bytes to the 32-bit
   vm_area_struct in 3.0, telling him about this upfront does not
   improve your chances that he will pull ;) but does protect you
   from his wrath when he'd later find it sneaked in.

We haven't come up with a solution to keep struct page size the same but 
I think it's a reasonable trade-off.

                         Pekka

The following changes since commit 95b6886526bb510b8370b625a49bc0ab3b8ff10f:
   Linus Torvalds (1):
         Merge branch 'for-linus' of git://git.kernel.org/.../jmorris/security-testing-2.6

are available in the git repository at:

   ssh://master.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git slub/lockless

Christoph Lameter (20):
       slub: Push irq disable into allocate_slab()
       slub: Do not use frozen page flag but a bit in the page counters
       slub: Move page->frozen handling near where the page->freelist handling occurs
       mm: Rearrange struct page
       slub: Add cmpxchg_double_slab()
       slub: explicit list_lock taking
       slub: Pass kmem_cache struct to lock and freeze slab
       slub: Rework allocator fastpaths
       slub: Invert locking and avoid slab lock
       slub: Disable interrupts in free_debug processing
       slub: Avoid disabling interrupts in free slowpath
       slub: Get rid of the another_slab label
       slub: Add statistics for the case that the current slab does not match the node
       slub: fast release on full slab
       slub: Not necessary to check for empty slab on load_freelist
       slub: slabinfo update for cmpxchg handling
       SLUB: Fix build breakage in linux/mm_types.h
       Avoid duplicate _count variables in page_struct
       slub: disable interrupts in cmpxchg_double_slab when falling back to pagelock
       slub: When allocating a new slab also prep the first object

Pekka Enberg (2):
       Merge remote branch 'tip/x86/atomic' into slub/lockless
       Revert "SLUB: Fix build breakage in linux/mm_types.h"

  arch/x86/Kconfig.cpu              |    3 +
  arch/x86/include/asm/cmpxchg_32.h |   48 +++
  arch/x86/include/asm/cmpxchg_64.h |   45 +++
  arch/x86/include/asm/cpufeature.h |    2 +
  include/linux/mm_types.h          |   89 +++--
  include/linux/page-flags.h        |    5 -
  include/linux/slub_def.h          |    3 +
  mm/slub.c                         |  764 +++++++++++++++++++++++++------------
  tools/slub/slabinfo.c             |   59 ++-
  9 files changed, 714 insertions(+), 304 deletions(-)
