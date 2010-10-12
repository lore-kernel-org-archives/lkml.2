Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256Ab0JLXhP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 19:37:15 -0400
Received: from claw.goop.org ([74.207.240.146]:47643 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247Ab0JLXhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 19:37:13 -0400
Message-ID: <4CB4F11F.4090104@goop.org>
Date: Tue, 12 Oct 2010 16:37:03 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 0/4] memblock related fixes for -tip
References: <4CAA4DC1.6000104@kernel.org> <4CB4ABE2.3010300@goop.org> <4CB4CF4D.5020706@kernel.org>
In-Reply-To: <4CB4CF4D.5020706@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 10/12/2010 02:12 PM, Yinghai Lu wrote:
> On 10/12/2010 11:41 AM, Jeremy Fitzhardinge wrote:
>>  On 10/04/2010 02:57 PM, Yinghai Lu wrote:
>>> Please check memblock related patches
>>>
>>> [PATCH 1/4] memblock: Fix big size with find_region()
>>> [PATCH -v5 2/4] x86, memblock: Fix crashkernel allocation
>>> [PATCH 3/4] x86, memblock: Remove __memblock_x86_find_in_range_size()
>>> [PATCH 4/4] x86, mm, memblock, 32bit: Make add_highpages honor early reserved ranges
>>>
>>> first one should get into core/memblock branch, and others should be in x86/mm/memeblock branch
>>
>> BTW, the memblock changes prevent the kernel from booting under Xen; it
>> crashes while setting up the linear maps.  I haven't worked out what's
>> failing yet, aside from bisecting it down to one of a9ce6bc151000 or
>> 72d7c3b33c9808 (they don't compile in isolation so I had to skip them,
>> but both are likely looking, but unfortunately large, complex and hard
>> to further subdivide).
>>
>> I'll look further into this, but just a heads-up for the upcoming merge
>> window.
>>
> please use 
>
> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-2.6-yinghai.git memblock
>
> to find which commit cause xen broken.
>
> two xen related patch are folded into first converting commit.

Note that ce883cfc65c51e24 doesn't compile:

/home/jeremy/git/upstream/arch/x86/kernel/e820.c: In function
‘find_e820_area_size’:
/home/jeremy/git/upstream/arch/x86/kernel/e820.c:764: error: expected
‘;’ before ‘return’

However, I can fix it with the obvious fix, and the Xen boot failure
bisects to this change.

The specific crash is when constructing the initial pagetable, when Xen
tries to remap a newly allocated pagetable page read-only, and finds the
allocated page isn't mapped within the linear map. Since it is in the
middle of creating the linear map, I guess its quite possible that the
allocation order has changed, and it starts allocating pages which are
not yet mapped, whereas before it was allocating already-mapped ones.

I'll see if I can confirm this hypothesis and see if I can work around
it (is poses some problems, because it means that when the pages later
become mapped, I need to make sure they get mapped RO).

J

> Thanks
>
>
> 1e5f012: x86: Remove old bootmem code
> f2c0394: x86, memblock: Use memblock_memory_size()/memblock_free_memory_size() to get correct dma_reserve
> 291e26f: x86: Remove not used early_res code
> 75cd1e9: x86, memblock: Replace e820_/_early string with memblock_
> ce883cf: x86: Use memblock to replace early_res
> c9d219e: x86, memblock: Add __get_free_all_memory_range()
> b2d0276: x86, memblock: Use memblock_debug to control debug message print out
> 945eabb: x86, memblock: Add memblock_x86_memory_in_range()
> 9c6c086: x86, memblock: Add memblock_x86_free_memory_in_range()
> 2310711: x86, memblock: Add memblock_x86_find_in_range_node()
> 6b4ffee: memblock: Add find_memory_core_early()
> 1d168bf: x86, memblock: Add memblock_x86_register_active_regions() and memblock_x86_hole_size()
> 8d39571: x86, memblock: Add get_free_all_memory_range()
> 46d5782: x86, memblock: Add memblock_x86_reserve_range/memblock_x86_free_range
> c6ade77: x86, memblock: Add memblock_x86_to_bootmem()
> 4a268b8: bootmem, x86: Add weak version of reserve_bootmem_generic
> 36d3afc: x86, memblock: Remove __memblock_x86_find_in_range_size()
> b352f42: x86, memblock: Add memblock_x86_find_in_range_size()
> a4c00b4: memblock: Allow memblock_init to be called early
> c795896: memblock: Fix wraparound in find_region()
> 3ecfe12: memblock: Add memblock_free/reserve_reserved_regions()
> 17462d5: memblock: Add memblock_find_in_range()
> 1e833c5: memblock: Option for the architecture to put memblock into the .init section
> f8266e2: memblock: Protect memblock.h with CONFIG_HAVE_MEMBLOCK
> 5b31325: memblock: Make MEMBLOCK_ERROR be 0
> df92f4d: memblock: Export MEMBLOCK_ERROR
> ddf01ef: memblock: Improve debug output when resizing the reserve array
> 3647f0b: memblock: Expose some memblock bits for use by x86
> 0526300: memblock: Add debugfs files to dump the arrays content
> 6fd15ab: memblock: Make memblock_alloc_try_nid() fallback to MEMBLOCK_ALLOC_ANYWHERE
> ab3744c: memblock: Separate memblock_alloc_nid() and memblock_alloc_try_nid()
> 79263d1: memblock: NUMA allocate can now use early_pfn_map
> fa21133: memblock: Add "start" argument to memblock_find_base()
> d1d5099: memblock: Add arch function to control coalescing of memblock memory regions
> 2979e28: memblock: Add array resizing support
> de17e60: memblock: Move functions around into a more sensible order
> ac239c8: memblock: split memblock_find_base() out of __memblock_alloc_base()
> 763d5f3: memblock: Move memblock_init() to the bottom of the file
> 674f2ff: memblock: Define MEMBLOCK_ERROR internally instead of using ~(phys_addr_t)0
> cf273c9: memblock: Make memblock_find_region() out of memblock_alloc_region()
> 5c2eb99: memblock: Add debug markers at the end of the array
> 68e694c: memblock: Move memblock arrays to static storage in memblock.c and make their size a variable
> cbfff22: memblock: Remove memblock_type.size and add memblock.memory_size instead
> 9ae0df1: memblock: Remove unused memblock.debug struct member
> 564bb2b: memblock: Change u64 to phys_addr_t
> e3c49f3: memblock: Remove rmo_size, burry it in arch/powerpc where it belongs
> 5f8a4aa: memblock: Introduce default allocation limit and use it to replace explicit ones
> 3608b50: memblock: Expose MEMBLOCK_ALLOC_ANYWHERE
> 676caa9: memblock: Factor the lowest level alloc function
> 19ad550: memblock: Remove nid_range argument, arch provides memblock_nid_range() instead
> 3dd4d87: memblock: Remove memblock_find()
> 01f4bff: memblock: Remove obsolete accessors
> b01b184: memblock/arm: Use new accessors
> 6283930: memblock/powerpc: Use new accessors
> 51e6c6e: memblock/sparc: Use new accessors
> 7c1720c: memblock/sh: Use new accessors
> 4967561: memblock/microblaze: Use new accessors
> cb3f592: memblock: Introduce for_each_memblock() and new accessors
> 8ccbd40: memblock/arm: Use memblock_region_is_memory() for omap fb
> 6617ae1: memblock/arm: pfn_valid uses memblock_is_memory()
> b25a6d2: memblock: Implement memblock_is_memory and memblock_is_region_memory
> 2b77abd: memblock: No reason to include asm/memblock.h late
> 62c5c92: memblock: Rename memblock_region to memblock_type and memblock_property to memblock_region
>

