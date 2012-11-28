Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab2K1Vsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 16:48:43 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:36933 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788Ab2K1Vsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 16:48:41 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v9 00/46] x86, mm: map ram from top-down with BRK and memblock.
Date: Wed, 28 Nov 2012 13:47:11 -0800
Message-Id: <1354139277-17376-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rebase patchset on top of linus v3.7-rc4. this one replace patches in tip/x86/mm2

this one include patchset : x86, mm: init_memory_mapping cleanup
---
Current kernel init memory mapping between [0, TOML) and [4G, TOMH)
Some AMD systems have mem hole between 4G and TOMH, around 1T.
According to HPA, we should only mapping ram range.
1. Seperate calculate_table_space_size and find_early_page_table out with
   init_memory_mapping.
2. For all ranges, will allocate page table one time
3. init mapping for ram range one by one.
---

pre mapping page table patcheset includes:
1. use brk to mapping first PMD_SIZE range under end of ram.
2. top down to initialize page table range by range.
3. get rid of calculate_page_table, and find_early_page_table.
4. remove early_ioremap in page table accessing.
5. remove workaround in xen to mark page RO.

v2: changes, update xen interface about pagetable_reserve, so not
   use pgt_buf_* in xen code directly.
v3: use range top-down to initialize page table, so will not use
   calculating/find early table anymore.
   also reorder the patches sequence.
v4: add mapping_mark_page_ro to fix xen, also move pgt_buf_* to init.c
    and merge alloc_low_page(), and for 32bit need to add alloc_low_pages
    to fix 32bit kmap setting.
v5: remove mark_page_ro workaround  and add another 5 cleanup patches.
v6: rebase on v3.7-rc4 and add 4 cleanup patches.
v7: fix max_low_pfn_mapped for xen domu memmap that does not have hole under 4g
    add pfn_range_is_mapped() calling for left over.
v8: updated some changelog and add some Acks from Stefano.
    Put v8 on every patch's subject, so hpa would not check old version.
    hope could catch window for v3.8
v9: update some changelog and comments according to Konrad.
    add acks from Konrad.

could be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-x86-mm

Jacob Shin (3):
  x86, mm: if kernel .text .data .bss are not marked as E820_RAM, complain and fix
  x86, mm: Fixup code testing if a pfn is direct mapped
  x86, mm: Only direct map addresses that are marked as E820_RAM

Stefano Stabellini (1):
  x86, mm: Add pointer about Xen mmu requirement for alloc_low_pages

Yinghai Lu (42):
  x86, mm: Add global page_size_mask and probe one time only
  x86, mm: Split out split_mem_range from init_memory_mapping
  x86, mm: Move down find_early_table_space()
  x86, mm: Move init_memory_mapping calling out of setup.c
  x86, mm: Revert back good_end setting for 64bit
  x86, mm: Change find_early_table_space() paramters
  x86, mm: Find early page table buffer together
  x86, mm: Separate out calculate_table_space_size()
  x86, mm: Set memblock initial limit to 1M
  x86, mm: use pfn_range_is_mapped() with CPA
  x86, mm: use pfn_range_is_mapped() with gart
  x86, mm: use pfn_range_is_mapped() with reserve_initrd
  x86, mm: relocate initrd under all mem for 64bit
  x86, mm: Align start address to correct big page size
  x86, mm: Use big page size for small memory range
  x86, mm: Don't clear page table if range is ram
  x86, mm: Break down init_all_memory_mapping
  x86, mm: setup page table in top-down
  x86, mm: Remove early_memremap workaround for page table accessing on 64bit
  x86, mm: Remove parameter in alloc_low_page for 64bit
  x86, mm: Merge alloc_low_page between 64bit and 32bit
  x86, mm: Move min_pfn_mapped back to mm/init.c
  x86, mm, Xen: Remove mapping_pagetable_reserve()
  x86, mm: Add alloc_low_pages(num)
  x86, mm: only call early_ioremap_page_table_range_init() once
  x86, mm: Move back pgt_buf_* to mm/init.c
  x86, mm: Move init_gbpages() out of setup.c
  x86, mm: change low/hignmem_pfn_init to static on 32bit
  x86, mm: Move function declaration into mm_internal.h
  x86, mm: Add check before clear pte above max_low_pfn on 32bit
  x86, mm: use round_up/down in split_mem_range()
  x86, mm: use PFN_DOWN in split_mem_range()
  x86, mm: use pfn instead of pos in split_mem_range
  x86, mm: use limit_pfn for end pfn
  x86, mm: Unifying after_bootmem for 32bit and 64bit
  x86, mm: Move after_bootmem to mm_internel.h
  x86, mm: Use clamp_t() in init_range_memory_mapping
  x86, mm: kill numa_free_all_bootmem()
  x86, mm: kill numa_64.h
  sparc, mm: Remove calling of free_all_bootmem_node()
  mm: Kill NO_BOOTMEM version free_all_bootmem_node()
  x86, mm: Let "memmap=" take more entries one time

 Documentation/kernel-parameters.txt  |    7 +
 arch/sparc/mm/init_64.c              |   24 +-
 arch/x86/include/asm/init.h          |   21 +--
 arch/x86/include/asm/numa.h          |    2 -
 arch/x86/include/asm/numa_64.h       |    6 -
 arch/x86/include/asm/page_types.h    |    2 +
 arch/x86/include/asm/pgtable.h       |    2 +
 arch/x86/include/asm/pgtable_types.h |    1 -
 arch/x86/include/asm/x86_init.h      |   12 -
 arch/x86/kernel/acpi/boot.c          |    1 -
 arch/x86/kernel/amd_gart_64.c        |    5 +-
 arch/x86/kernel/cpu/amd.c            |    9 +-
 arch/x86/kernel/cpu/intel.c          |    1 -
 arch/x86/kernel/e820.c               |   16 ++-
 arch/x86/kernel/setup.c              |  121 ++++-----
 arch/x86/kernel/x86_init.c           |    4 -
 arch/x86/mm/init.c                   |  462 ++++++++++++++++++++++------------
 arch/x86/mm/init_32.c                |  107 +++++---
 arch/x86/mm/init_64.c                |  140 ++++-------
 arch/x86/mm/mm_internal.h            |   19 ++
 arch/x86/mm/numa_64.c                |   13 -
 arch/x86/mm/pageattr.c               |   16 +-
 arch/x86/platform/efi/efi.c          |    7 +-
 arch/x86/xen/mmu.c                   |   28 --
 include/linux/mm.h                   |    1 -
 mm/nobootmem.c                       |   14 -
 26 files changed, 539 insertions(+), 502 deletions(-)
 delete mode 100644 arch/x86/include/asm/numa_64.h
 create mode 100644 arch/x86/mm/mm_internal.h

-- 
1.7.7

