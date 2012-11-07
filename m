Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab2KGQYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 11:24:54 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:31520 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab2KGQYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 11:24:52 -0500
Date: Wed, 7 Nov 2012 11:11:44 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jacob Shin <jacob.shin@amd.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v3 0/7] x86: Use BRK to pre mapping page table to make
 xen happy
Message-ID: <20121107161144.GA18353@phenom.dumpdata.com>
References: <1349827115-16600-1-git-send-email-yinghai@kernel.org>
 <alpine.DEB.2.02.1210101609170.2689@kaball.uk.xensource.com>
 <CAE9FiQW952+jHBHxhKu2PX_fpwb8fXVQp2xX0i=HdzgKWuGFCA@mail.gmail.com>
 <20121030134442.GB27463@phenom.dumpdata.com>
 <CAE9FiQVXzOQG2XmA5Y_DX1JCGg_-LdM9tG3Chq7-7rNvUseRhg@mail.gmail.com>
 <CAE9FiQW+B8_vBT4A10ab4iOAQD9b-Ef84dsSX7p3nVQSN2w0=Q@mail.gmail.com>
 <a58d5329-a1db-418b-9caa-06b7a79051ec@email.android.com>
 <CAE9FiQWUiNqv-fd_4Y79eq+-w6wU34nEwn76+QJ7TWw7uCLaaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQWUiNqv-fd_4Y79eq+-w6wU34nEwn76+QJ7TWw7uCLaaQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2012 at 12:25:12PM -0800, Yinghai Lu wrote:
> On Sat, Nov 3, 2012 at 2:37 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> > I am travelling at the moment... I hope to be able to look at it Sunday.
> >>
> >>can you put for-x86-mm-test to tip for more testing?
> >>
> >>or you want to rebase the whole patchset?
> 
> All,
> 
> please check branch that is rebased on top of 3.7-rc4.
> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
> for-x86-mm

I did a overnight test and it passed that. Let me do a couple of more of bootups
with various memory configurations (1GB, 2GB, 3333M, 4G, 8GB, 16GB, 32GB) to
get a good feel.

Thanks!
> 
> Stefano, Konrad,
> please check them with xen parts, and give your acked-by or
> Reviewed-by accordingly.
> 
> Thanks
> 
> Yinghai
> 
> 
> >From 1b66ccf15ff4bd0200567e8d70446a8763f96ee7 Mon Sep 17 00:00:00 2001
> From: Yinghai Lu <yinghai@kernel.org>
> Date: Mon, 5 Nov 2012 11:54:12 -0800
> Subject: [PATCH v6 00/42] x86, mm: map ram from top-down with BRK and memblock.
> 
> rebase patchset together tip/x86/mm2 on top of linus v3.7-rc4
> 
> so this one include patchset : x86, mm: init_memory_mapping cleanup
> in tip/x86/mm2
> ---
> Current kernel init memory mapping between [0, TOML) and [4G, TOMH)
> Some AMD systems have mem hole between 4G and TOMH, around 1T.
> According to HPA, we should only mapping ram range.
> 1. Seperate calculate_table_space_size and find_early_page_table out with
>    init_memory_mapping.
> 2. For all ranges, will allocate page table one time
> 3. init mapping for ram range one by one.
> ---
> 
> pre mapping page table patcheset includes:
> 1. use brk to mapping first PMD_SIZE range under end of ram.
> 2. top down to initialize page table range by range.
> 3. get rid of calculate_page_table, and find_early_page_table.
> 4. remove early_ioremap in page table accessing.
> 5. remove workaround in xen to mark page RO.
> 
> v2: changes, update xen interface about pagetable_reserve, so not
>    use pgt_buf_* in xen code directly.
> v3: use range top-down to initialize page table, so will not use
>    calculating/find early table anymore.
>    also reorder the patches sequence.
> v4: add mapping_mark_page_ro to fix xen, also move pgt_buf_* to init.c
>     and merge alloc_low_page(), and for 32bit need to add alloc_low_pages
>     to fix 32bit kmap setting.
> v5: remove mark_page_ro workaround  and add another 5 cleanup patches.
> v6: rebase on v3.7-rc4 and add 4 cleanup patches.
> 
> could be found at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
> for-x86-mm
> 
> 1b66ccf: mm: Kill NO_BOOTMEM version free_all_bootmem_node()
> 0332736: sparc, mm: Remove calling of free_all_bootmem_node()
> 0f88d27: x86, mm: kill numa_64.h
> 10c4c68: x86, mm: kill numa_free_all_bootmem()
> 0187d6e: x86, mm: Let "memmap=" take more entries one time
> 2c20fd0: x86, mm: Use clamp_t() in init_range_memory_mapping
> 770db30: x86, mm: Move after_bootmem to mm_internel.h
> d9bd282: x86, mm: Unifying after_bootmem for 32bit and 64bit
> 003d654: x86, mm: use limit_pfn for end pfn
> 29f27b8: x86, mm: use pfn instead of pos in split_mem_range
> 8edaab8: x86, mm: use PFN_DOWN in split_mem_range()
> e652c73: x86, mm: use round_up/down in split_mem_range()
> 5fd1391: x86, mm: Add check before clear pte above max_low_pfn on 32bit
> f4fd136: x86, mm: Move function declaration into mm_internal.h
> ea421df: x86, mm: change low/hignmem_pfn_init to static on 32bit
> 867525b: x86, mm: Move init_gbpages() out of setup.c
> 97fb23a: x86, mm: Move back pgt_buf_* to mm/init.c
> ba55b2f: x86, mm: only call early_ioremap_page_table_range_init() once
> bb6d2d9: x86, mm: Add pointer about Xen mmu requirement for alloc_low_pages
> 6bc7e9f: x86, mm: Add alloc_low_pages(num)
> d90df25: x86, mm, Xen: Remove mapping_pagetable_reserve()
> f6699d2: x86, mm: Move min_pfn_mapped back to mm/init.c
> 675697b: x86, mm: Merge alloc_low_page between 64bit and 32bit
> a14a382: x86, mm: Remove parameter in alloc_low_page for 64bit
> a0d7a52: x86, mm: Remove early_memremap workaround for page table
> accessing on 64bit
> 384a79d: x86, mm: setup page table in top-down
> 16252f2: x86, mm: Break down init_all_memory_mapping
> 255a0bf: x86, mm: Don't clear page table if range is ram
> 4bc70c5: x86, mm: Use big page size for small memory range
> dc62aa8: x86, mm: Align start address to correct big page size
> 18f374c: x86: Only direct map addresses that are marked as E820_RAM
> 150387c: x86: Fixup code testing if a pfn is direct mapped
> 45cb049: x86: if kernel .text .data .bss are not marked as E820_RAM,
> complain and fix
> 8d0b8bd: x86, mm: Set memblock initial limit to 1M
> 6c712cf: x86, mm: Separate out calculate_table_space_size()
> 33b0520: x86, mm: Find early page table buffer together
> a95ff4b: x86, mm: Change find_early_table_space() paramters
> ea564f8: x86, mm: Revert back good_end setting for 64bit
> 912c686: x86, mm: Move init_memory_mapping calling out of setup.c
> 47cfa63: x86, mm: Move down find_early_table_space()
> 060ed6c: x86, mm: Split out split_mem_range from init_memory_mapping
> 2ad38b5: x86, mm: Add global page_size_mask and probe one time only
> 
>  arch/sparc/mm/init_64.c              |   24 +-
>  arch/x86/include/asm/init.h          |   21 +--
>  arch/x86/include/asm/numa.h          |    2 -
>  arch/x86/include/asm/numa_64.h       |    6 -
>  arch/x86/include/asm/page_types.h    |    2 +
>  arch/x86/include/asm/pgtable.h       |    2 +
>  arch/x86/include/asm/pgtable_types.h |    1 -
>  arch/x86/include/asm/x86_init.h      |   12 -
>  arch/x86/kernel/acpi/boot.c          |    1 -
>  arch/x86/kernel/cpu/amd.c            |    9 +-
>  arch/x86/kernel/cpu/intel.c          |    1 -
>  arch/x86/kernel/e820.c               |   16 ++-
>  arch/x86/kernel/setup.c              |   70 ++----
>  arch/x86/kernel/x86_init.c           |    4 -
>  arch/x86/mm/init.c                   |  445 ++++++++++++++++++++++------------
>  arch/x86/mm/init_32.c                |  106 +++++---
>  arch/x86/mm/init_64.c                |  140 ++++-------
>  arch/x86/mm/mm_internal.h            |   19 ++
>  arch/x86/mm/numa_64.c                |   13 -
>  arch/x86/platform/efi/efi.c          |    7 +-
>  arch/x86/xen/mmu.c                   |   28 ---
>  include/linux/mm.h                   |    1 -
>  mm/nobootmem.c                       |   14 -
>  23 files changed, 480 insertions(+), 464 deletions(-)
>  delete mode 100644 arch/x86/include/asm/numa_64.h
>  create mode 100644 arch/x86/mm/mm_internal.h
> 
> -- 
> 1.7.7
