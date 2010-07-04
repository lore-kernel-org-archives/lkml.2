Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743Ab0GDHBO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 03:01:14 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63935 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755493Ab0GDHBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 03:01:11 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v22 00/23] Use lmb with x86
Date: Sat,  3 Jul 2010 23:56:04 -0700
Message-Id: <1278226587-31213-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4C30317F.0072,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New lmb could be used to replace early_res in x86.

Suggested by: David, Ben, and Thomas

-v18: change lmb_find_area to lmb_find_in_range
      kill __lmb_find_area and use lmb_find_area directly
      remove lmb_add_memory
      change lmb_reserve_area to lmb_reserve_range
      change lmb_free_area to lmb_free_range
      don't clear lmb.reserved after converting
      use for_each_lmb to replace for cycle
      rebase to 06/15/2010 powerpc/lmb

-v19: make the patchset only focus on lmb related.
      will submit patches about bootmem/nobootmem seperating and other e820
	 related later after this one.

-v20: put ben change together...
      add lmb_dbg() according to Ingo

-v21: debug print add # for 0x
      removed old bootmem support for x86 according to Ingo, Thomas and HPA
      change LMB_ERROR to 0 according to Linus

-v22: change x86 related lmb to lmb_x86_ instead of according to Ingo

patch 19: has to be done in one shoot to switch from early_res to lmb.

please pull from powerpc/lmb, and apply this patchset.

todo:
     replace range handling (subtracting) with lmb.

Thanks

Yinghai Lu

Ben's lmb changes in powerpc/lmb:

 arch/microblaze/include/asm/lmb.h        |    3 -
 arch/microblaze/mm/init.c                |   18 +-
 arch/powerpc/include/asm/lmb.h           |    7 -
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
 arch/sh/include/asm/lmb.h                |    2 -
 arch/sh/mm/init.c                        |   16 +-
 arch/sparc/include/asm/lmb.h             |    2 -
 arch/sparc/mm/init_64.c                  |   46 +--
 include/linux/lmb.h                      |  142 ++++--
 lib/lmb.c                                |  745 +++++++++++++++++++-----------
 27 files changed, 808 insertions(+), 483 deletions(-)

x86_lmb changes:

 arch/x86/Kconfig                |   15 +-
 arch/x86/include/asm/e820.h     |   20 +-
 arch/x86/include/asm/efi.h      |    2 +-
 arch/x86/include/asm/lmb.h      |   21 ++
 arch/x86/kernel/acpi/sleep.c    |    7 +-
 arch/x86/kernel/apic/numaq_32.c |    3 +-
 arch/x86/kernel/check.c         |   16 +-
 arch/x86/kernel/e820.c          |  192 ++++----------
 arch/x86/kernel/efi.c           |    5 +-
 arch/x86/kernel/head.c          |    3 +-
 arch/x86/kernel/head32.c        |   10 +-
 arch/x86/kernel/head64.c        |    7 +-
 arch/x86/kernel/mpparse.c       |    5 +-
 arch/x86/kernel/setup.c         |   78 +++--
 arch/x86/kernel/setup_percpu.c  |    6 -
 arch/x86/kernel/trampoline.c    |    8 +-
 arch/x86/mm/Makefile            |    2 +
 arch/x86/mm/init.c              |    7 +-
 arch/x86/mm/init_32.c           |   66 +-----
 arch/x86/mm/init_64.c           |   67 +-----
 arch/x86/mm/k8topology_64.c     |    4 +-
 arch/x86/mm/lmb.c               |  359 ++++++++++++++++++++++++
 arch/x86/mm/memtest.c           |    7 +-
 arch/x86/mm/numa_32.c           |   28 +-
 arch/x86/mm/numa_64.c           |   84 ++-----
 arch/x86/mm/srat_32.c           |    3 +-
 arch/x86/mm/srat_64.c           |   11 +-
 arch/x86/xen/mmu.c              |    5 +-
 arch/x86/xen/setup.c            |    3 +-
 include/linux/early_res.h       |   23 --
 include/linux/lmb.h             |   20 ++
 include/linux/mm.h              |    2 +
 kernel/Makefile                 |    1 -
 kernel/early_res.c              |  584 ---------------------------------------
 lib/lmb.c                       |   68 +++--
 mm/bootmem.c                    |   11 +-
 mm/page_alloc.c                 |   72 +++--
 mm/sparse-vmemmap.c             |   11 -
 38 files changed, 702 insertions(+), 1134 deletions(-)
 create mode 100644 arch/x86/include/asm/lmb.h
 create mode 100644 arch/x86/mm/lmb.c
 delete mode 100644 include/linux/early_res.h
 delete mode 100644 kernel/early_res.c

total:
 arch/powerpc/platforms/embedded6xx/wii.c |    2 +-
 arch/sh/include/asm/lmb.h                |    2 -
 arch/sh/mm/init.c                        |   16 +-
 arch/sparc/include/asm/lmb.h             |    2 -
 arch/sparc/mm/init_64.c                  |   46 +--
 arch/x86/Kconfig                         |   15 +-
 arch/x86/include/asm/e820.h              |   20 +-
 arch/x86/include/asm/efi.h               |    2 +-
 arch/x86/include/asm/lmb.h               |   21 +
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
 arch/x86/kernel/setup_percpu.c           |    6 -
 arch/x86/kernel/trampoline.c             |    8 +-
 arch/x86/mm/Makefile                     |    2 +
 arch/x86/mm/init.c                       |    7 +-
 arch/x86/mm/init_32.c                    |   66 +---
 arch/x86/mm/init_64.c                    |   67 +---
 arch/x86/mm/k8topology_64.c              |    4 +-
 arch/x86/mm/lmb.c                        |  359 ++++++++++++++
 arch/x86/mm/memtest.c                    |    7 +-
 arch/x86/mm/numa_32.c                    |   28 +-
 arch/x86/mm/numa_64.c                    |   84 +---
 arch/x86/mm/srat_32.c                    |    3 +-
 arch/x86/mm/srat_64.c                    |   11 +-
 arch/x86/xen/mmu.c                       |    5 +-
 arch/x86/xen/setup.c                     |    3 +-
 include/linux/early_res.h                |   23 -
 include/linux/lmb.h                      |  162 +++++--
 include/linux/mm.h                       |    2 +
 kernel/Makefile                          |    1 -
 kernel/early_res.c                       |  584 -----------------------
 lib/lmb.c                                |  755 +++++++++++++++++++-----------
 mm/bootmem.c                             |   11 +-
 mm/page_alloc.c                          |   72 ++-
 mm/sparse-vmemmap.c                      |   11 -
 63 files changed, 1481 insertions(+), 1588 deletions(-)
 create mode 100644 arch/x86/include/asm/lmb.h
 create mode 100644 arch/x86/mm/lmb.c
 delete mode 100644 include/linux/early_res.h
 delete mode 100644 kernel/early_res.c

