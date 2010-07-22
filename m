Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469Ab0GVSZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 14:25:19 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:46275 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756349Ab0GVSZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 14:25:10 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v26 00/31] generic changes for memblock
Date: Thu, 22 Jul 2010 11:20:33 -0700
Message-Id: <1279822864-17154-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4C488C54.0013,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New memblock could be used to replace early_res in x86.

Suggested by: David, Ben, and Thomas

-v25: update to mainline with kmemleak fix on nobootmem
      also rename lmb to memblock alread in mainline

-v26: according to Linus and hpa, seperate the big patchset to small ones.

This one is rebase of Ben's changeset to current mainline/tip

Last 6 are needed for x86 memblock transistion, but change mm/memblock.c

Thanks

Yinghai Lu

[PATCH 01/31] memblock: Rename memblock_region to memblock_type and memblock_property to memblock_region
[PATCH 02/31] memblock: No reason to include asm/memblock.h late
[PATCH 03/31] memblock: Introduce for_each_memblock() and new accessors, and use it
[PATCH 04/31] memblock: Remove nid_range argument, arch provides memblock_nid_range() instead
[PATCH 05/31] memblock: Factor the lowest level alloc function
[PATCH 06/31] memblock: Expose MEMBLOCK_ALLOC_ANYWHERE
[PATCH 07/31] memblock: Introduce default allocation limit and use it to replace explicit ones
[PATCH 08/31] memblock: Remove rmo_size, burry it in arch/powerpc where it belongs
[PATCH 09/31] memblock: Change u64 to phys_addr_t
[PATCH 10/31] memblock: Remove unused memblock.debug struct member
[PATCH 11/31] memblock: Remove memblock_type.size and add memblock.memory_size instead
[PATCH 12/31] memblock: Move memblock arrays to static storage in memblock.c and make their size a variable
[PATCH 13/31] memblock: Add debug markers at the end of the array
[PATCH 14/31] memblock: Make memblock_find_region() out of memblock_alloc_region()
[PATCH 15/31] memblock: Define MEMBLOCK_ERROR internally instead of using ~(phys_addr_t)0
[PATCH 16/31] memblock: Move memblock_init() to the bottom of the file
[PATCH 17/31] memblock: split memblock_find_base() out of __memblock_alloc_base()
[PATCH 18/31] memblock: Move functions around into a more sensible order
[PATCH 19/31] memblock: Add array resizing support
[PATCH 20/31] memblock: Add arch function to control coalescing of memblock memory regions
[PATCH 21/31] memblock: Add "start" argument to memblock_find_base()
[PATCH 22/31] memblock: NUMA allocate can now use early_pfn_map
[PATCH 23/31] memblock: Separate memblock_alloc_nid() and memblock_alloc_try_nid()
[PATCH 24/31] memblock: Make memblock_alloc_try_nid() fallback to MEMBLOCK_ALLOC_ANYWHERE
[PATCH 25/31] memblock: Add debugfs files to dump the arrays content
[PATCH 26/31] memblock: Prepare x86 to use memblock to replace early_res
[PATCH 27/31] memblock: Print new doubled array location info
[PATCH 28/31] memblock: Export MEMBLOCK_ERROR again
[PATCH 29/31] memblock: Prepare to include linux/memblock.h in core file
[PATCH 30/31] memblock: Add ARCH_DISCARD_MEMBLOCK to put memblock code to .init
[PATCH 31/31] memblock: Add memblock_find_in_range()

 arch/microblaze/include/asm/memblock.h   |    3 -
 arch/microblaze/mm/init.c                |   18 +-
 arch/powerpc/include/asm/memblock.h      |    7 -
 arch/powerpc/include/asm/mmu.h           |   12 +
 arch/powerpc/kernel/head_40x.S           |    6 +-
 arch/powerpc/kernel/paca.c               |    2 +-
 arch/powerpc/kernel/prom.c               |   15 +-
 arch/powerpc/kernel/rtas.c               |    2 +-
 arch/powerpc/kernel/setup_32.c           |    2 +-
 arch/powerpc/kernel/setup_64.c           |    2 +-
 arch/powerpc/mm/40x_mmu.c                |   17 +-
 arch/powerpc/mm/44x_mmu.c                |   14 +
 arch/powerpc/mm/fsl_booke_mmu.c          |   12 +-
 arch/powerpc/mm/hash_utils_64.c          |   35 ++-
 arch/powerpc/mm/init_32.c                |   43 +-
 arch/powerpc/mm/init_64.c                |    1 +
 arch/powerpc/mm/mem.c                    |   94 ++---
 arch/powerpc/mm/numa.c                   |   17 +-
 arch/powerpc/mm/ppc_mmu_32.c             |   18 +-
 arch/powerpc/mm/tlb_nohash.c             |   16 +
 arch/powerpc/platforms/embedded6xx/wii.c |    2 +-
 arch/sh/include/asm/memblock.h           |    2 -
 arch/sh/mm/init.c                        |   16 +-
 arch/sparc/include/asm/memblock.h        |    2 -
 arch/sparc/mm/init_64.c                  |   46 +--
 include/linux/memblock.h                 |  162 +++++--
 mm/memblock.c                            |  764 +++++++++++++++++++-----------
 27 files changed, 846 insertions(+), 484 deletions(-)
