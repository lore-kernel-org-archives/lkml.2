Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967335Ab0GTAEB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 20:04:01 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:64411 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967037Ab0GSX64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 19:58:56 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v25 00/49] Use memblock with x86
Date: Mon, 19 Jul 2010 16:56:09 -0700
Message-Id: <1279583818-14249-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4C44E68C.0098,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New memblock could be used to replace early_res in x86.

Suggested by: David, Ben, and Thomas

-v18: change memblock_find_area to memblock_find_in_range
      kill __memblock_find_area and use memblock_find_area directly
      remove memblock_add_memory
      change memblock_reserve_area to memblock_reserve_range
      change memblock_free_area to memblock_free_range
      don't clear memblock.reserved after converting
      use for_each_memblock to replace for cycle
      rebase to 06/15/2010 powerpc/memblock

-v19: make the patchset only focus on memblock related.
      will submit patches about bootmem/nobootmem seperating and other e820
	 related later after this one.

-v20: put ben change together...
      add memblock_dbg() according to Ingo

-v21: debug print add # for 0x
      removed old bootmem support for x86 according to Ingo, Thomas and HPA
      change MEMBLOCK_ERROR to 0 according to Linus

-v22: change x86 related memblock to memblock_x86_ instead of according to Ingo

-v23: rename lmb to memblock before Ben's cleanup patcheset, and x86 using patches.

-v24: fold memblock_find_base() return change to Ben's patchset
      change to -1 display

-v25: update to mainline with kmemleak fix on nobootmem
      also rename lmb to memblock alread in mainline

First two patches are needed for 2.6.35. need to be applied at first.

todo:
     replace range handling (subtracting) with memblock.

Thanks

Yinghai Lu

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
 arch/x86/Kconfig                         |   15 +-
 arch/x86/include/asm/e820.h              |   20 +-
 arch/x86/include/asm/efi.h               |    2 +-
 arch/x86/include/asm/memblock.h          |   21 +
 arch/x86/kernel/acpi/sleep.c             |    7 +-
 arch/x86/kernel/apic/numaq_32.c          |    3 +-
 arch/x86/kernel/check.c                  |   16 +-
 arch/x86/kernel/e820.c                   |  192 ++------
 arch/x86/kernel/efi.c                    |    5 +-
 arch/x86/kernel/head.c                   |    3 +-
 arch/x86/kernel/head32.c                 |   10 +-
 arch/x86/kernel/head64.c                 |    7 +-
 arch/x86/kernel/mpparse.c                |    5 +-
 arch/x86/kernel/setup.c                  |   78 ++--
 arch/x86/kernel/setup_percpu.c           |   23 +-
 arch/x86/kernel/trampoline.c             |    8 +-
 arch/x86/mm/Makefile                     |    2 +
 arch/x86/mm/init.c                       |    7 +-
 arch/x86/mm/init_32.c                    |   66 +---
 arch/x86/mm/init_64.c                    |   67 +---
 arch/x86/mm/k8topology_64.c              |    4 +-
 arch/x86/mm/memblock.c                   |  359 ++++++++++++++
 arch/x86/mm/memtest.c                    |    7 +-
 arch/x86/mm/numa_32.c                    |   28 +-
 arch/x86/mm/numa_64.c                    |   84 +---
 arch/x86/mm/srat_32.c                    |    3 +-
 arch/x86/mm/srat_64.c                    |   11 +-
 arch/x86/xen/mmu.c                       |    5 +-
 arch/x86/xen/setup.c                     |    3 +-
 include/linux/early_res.h                |   23 -
 include/linux/memblock.h                 |  162 +++++--
 include/linux/mm.h                       |    2 +
 kernel/Makefile                          |    1 -
 kernel/early_res.c                       |  590 -----------------------
 mm/bootmem.c                             |   37 ++-
 mm/memblock.c                            |  764 +++++++++++++++++++-----------
 mm/page_alloc.c                          |   83 ++--
 mm/sparse-vmemmap.c                      |   11 -
 63 files changed, 1526 insertions(+), 1612 deletions(-)
 create mode 100644 arch/x86/include/asm/memblock.h
 create mode 100644 arch/x86/mm/memblock.c
 delete mode 100644 include/linux/early_res.h
 delete mode 100644 kernel/early_res.c
