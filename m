Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab0FPFo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 01:44:29 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:26401 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756023Ab0FPFoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 01:44:21 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v18 00/37] Use lmb with x86
Date: Tue, 15 Jun 2010 22:42:09 -0700
Message-Id: <1276666966-14259-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090206.4C18649E.0119,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New lmb could be used to replace early_res in x86.

Suggested by: David, Ben, and Thomas

-v6: change sequence as requested by Thomas
-v7: seperate them to more patches
-v8: add boundary checking to make sure not free partial page.
-v9: use lmb_debug to control print out of reserve_lmb.
     add e820 clean up, and e820 become __initdata
-v10:use lmb.rmo_size and ARCH_DISCARD_LMB according to Michael
     change name to lmb_find_area/reserve_lmb_area/free_lmb_area,
      according to Michael
     update find_lmb_area to use __lmb_alloc_base according to ben
-v11:move find_lmb_area_size back to x86.
     x86 has own find_lmb_area, and could be disabled by ARCH_LMB_FIND_AREA
      because _lmb_find_base has different behavoir from x86's old one.
      one from high to high and one from low to high
      need more test
     tested for x86 32bit/64bit, numa/nonuma, nobootmem/bootmem.
-v12:refresh the series with current tip
     seperate nobootmem.c, so could remove some #ifdef
     still keep CONFIG_NO_BOOTMEM, in x86 .c, and could use the as tags
     so other lmb could refer them to use NO_BOOTMEM.

-v14:refresh to current tip

-v15:remove x86 version lmb_find_area
     remove other nobootmem and x86 e820 from this patchset

-v16: rebase to Ben's cleanup powerpc/lmb
     move back most func back to arch/x86/mm/lmb.c

-v17: remove exposing of lmb_add_region
     seperate first lmb core related patch to several small patches.

-v18: change lmb_find_area to lmb_find_in_range
      kill __lmb_find_area and use lmb_find_area directly
      remove lmb_add_memory
      change lmb_reserve_area to lmb_reserve_range
      change lmb_free_area to lmb_free_range
      don't clear lmb.reserved after converting
      use for_each_lmb to replace for cycle
      rebase to 06/15/2010 powerpc/lmb

this patcheset is based on tip/master+powerpc/lmb

todo:
     replace range handling (subtracting) with lmb.

Thanks

Yinghai Lu

 arch/x86/Kconfig                |   17 +-
 arch/x86/include/asm/e820.h     |   37 ++--
 arch/x86/include/asm/efi.h      |    2 +-
 arch/x86/include/asm/gart.h     |   22 --
 arch/x86/include/asm/lmb.h      |   21 ++
 arch/x86/kernel/acpi/sleep.c    |    7 +-
 arch/x86/kernel/aperture_64.c   |   22 ++
 arch/x86/kernel/apic/numaq_32.c |    3 +-
 arch/x86/kernel/check.c         |   16 +-
 arch/x86/kernel/cpu/centaur.c   |   53 +----
 arch/x86/kernel/e820.c          |  331 ++++++++++++----------
 arch/x86/kernel/efi.c           |    7 +-
 arch/x86/kernel/head.c          |    3 +-
 arch/x86/kernel/head32.c        |   10 +-
 arch/x86/kernel/head64.c        |    7 +-
 arch/x86/kernel/mpparse.c       |    5 +-
 arch/x86/kernel/setup.c         |   88 ++++---
 arch/x86/kernel/setup_percpu.c  |    6 -
 arch/x86/kernel/tboot.c         |   22 +-
 arch/x86/kernel/trampoline.c    |    8 +-
 arch/x86/mm/Makefile            |    2 +
 arch/x86/mm/init.c              |    7 +-
 arch/x86/mm/init_32.c           |   31 +-
 arch/x86/mm/init_64.c           |   38 +--
 arch/x86/mm/k8topology_64.c     |    4 +-
 arch/x86/mm/lmb.c               |  465 +++++++++++++++++++++++++++++++
 arch/x86/mm/memtest.c           |    7 +-
 arch/x86/mm/numa_32.c           |   25 +-
 arch/x86/mm/numa_64.c           |   45 ++--
 arch/x86/mm/srat_32.c           |    3 +-
 arch/x86/mm/srat_64.c           |   13 +-
 arch/x86/xen/mmu.c              |    5 +-
 arch/x86/xen/setup.c            |    7 +-
 drivers/char/agp/amd64-agp.c    |   39 +++-
 include/linux/early_res.h       |   23 --
 include/linux/lmb.h             |   17 ++
 include/linux/mm.h              |    4 +-
 kernel/Makefile                 |    1 -
 kernel/early_res.c              |  584 ---------------------------------------
 lib/lmb.c                       |   65 +++--
 lib/swiotlb.c                   |   16 +-
 mm/Makefile                     |    8 +-
 mm/bootmem.c                    |  165 +----------
 mm/nobootmem.c                  |  415 +++++++++++++++++++++++++++
 mm/page_alloc.c                 |   71 ++---
 mm/sparse-vmemmap.c             |   11 -
 46 files changed, 1476 insertions(+), 1282 deletions(-)
 create mode 100644 arch/x86/include/asm/lmb.h
 create mode 100644 arch/x86/mm/lmb.c
 delete mode 100644 include/linux/early_res.h
 delete mode 100644 kernel/early_res.c
 create mode 100644 mm/nobootmem.c
