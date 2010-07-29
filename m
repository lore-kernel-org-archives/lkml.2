Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044Ab0G2TrN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 15:47:13 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:19737 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757946Ab0G2TrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 15:47:06 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v27 00/17] Use memblock with x86
Date: Thu, 29 Jul 2010 12:45:20 -0700
Message-Id: <1280432737-1808-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4C51DA71.0154,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New memblock could be used to replace early_res in x86.

Suggested by: David, Ben, and Thomas

-v25: update to mainline with kmemleak fix on nobootmem
      also rename lmb to memblock alread in mainline

-v26: according to Linus and hpa, seperate the big patchset to small ones.

-v27: rebase to Ben's powerpc/memblock
      add memblock_free_reserved_regions() so don't need to export init regions

this one is x86 related, finally we can remove bootmem code in x86 and early_res code.

Thanks

Yinghai Lu

[PATCH 01/17] memblock: Add memblock_free/reserve_reserved_regions()
[PATCH 02/17] x86, memblock: Add memblock_x86_find_in_range_size()
[PATCH 03/17] bootmem, x86: Add weak version of reserve_bootmem_generic
[PATCH 04/17] x86, memblock: Add memblock_x86_to_bootmem()
[PATCH 05/17] x86,memblock: Add memblock_x86_reserve_range/memblock_x86_free_range
[PATCH 06/17] x86, memblock: Add get_free_all_memory_range()
[PATCH 07/17] x86, memblock: Add memblock_x86_register_active_regions() and memblock_x86_hole_size()
[PATCH 08/17] memblock: Add find_memory_core_early()
[PATCH 09/17] x86, memblock: Add memblock_x86_find_in_range_node()
[PATCH 10/17] x86, memblock: Add memblock_x86_free_memory_in_range()
[PATCH 11/17] x86, memblock: Add memblock_x86_memory_in_range()
[PATCH 12/17] x86, memblock: Use memblock_debug to control debug message print out
[PATCH 13/17] x86: Use memblock to replace early_res
[PATCH 14/17] x86: Replace e820_/_early string with memblock_
[PATCH 15/17] x86: Remove not used early_res code
[PATCH 16/17] x86, memblock: Use memblock_memory_size()/memblock_free_memory_size() to get correct dma_reserve
[PATCH 17/17] x86: remove old bootmem code

 arch/x86/Kconfig                |   15 +-
 arch/x86/include/asm/e820.h     |   20 +-
 arch/x86/include/asm/efi.h      |    2 +-
 arch/x86/include/asm/memblock.h |   21 ++
 arch/x86/kernel/acpi/sleep.c    |    9 +-
 arch/x86/kernel/apic/numaq_32.c |    3 +-
 arch/x86/kernel/check.c         |   16 +-
 arch/x86/kernel/e820.c          |  192 ++++---------
 arch/x86/kernel/efi.c           |    5 +-
 arch/x86/kernel/head.c          |    3 +-
 arch/x86/kernel/head32.c        |   10 +-
 arch/x86/kernel/head64.c        |    7 +-
 arch/x86/kernel/mpparse.c       |    5 +-
 arch/x86/kernel/setup.c         |   78 +++--
 arch/x86/kernel/setup_percpu.c  |    6 -
 arch/x86/kernel/trampoline.c    |   10 +-
 arch/x86/mm/Makefile            |    2 +
 arch/x86/mm/init.c              |   10 +-
 arch/x86/mm/init_32.c           |   66 +-----
 arch/x86/mm/init_64.c           |   67 +-----
 arch/x86/mm/k8topology_64.c     |    4 +-
 arch/x86/mm/memblock.c          |  355 +++++++++++++++++++++++
 arch/x86/mm/memtest.c           |    7 +-
 arch/x86/mm/numa_32.c           |   28 +-
 arch/x86/mm/numa_64.c           |   84 ++-----
 arch/x86/mm/srat_32.c           |    3 +-
 arch/x86/mm/srat_64.c           |   11 +-
 arch/x86/xen/mmu.c              |    5 +-
 arch/x86/xen/setup.c            |    3 +-
 include/linux/early_res.h       |   23 --
 include/linux/memblock.h        |    2 +
 include/linux/mm.h              |    2 +
 kernel/Makefile                 |    1 -
 kernel/early_res.c              |  590 ---------------------------------------
 mm/bootmem.c                    |   13 +-
 mm/memblock.c                   |   24 ++
 mm/page_alloc.c                 |   86 ++++---
 mm/sparse-vmemmap.c             |   11 -
 38 files changed, 677 insertions(+), 1122 deletions(-)
 create mode 100644 arch/x86/include/asm/memblock.h
 create mode 100644 arch/x86/mm/memblock.c
 delete mode 100644 include/linux/early_res.h
 delete mode 100644 kernel/early_res.c

