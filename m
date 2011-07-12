Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238Ab1GLX1A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 19:27:00 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:42397 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932Ab1GLX07 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 19:26:59 -0400
MIME-Version: 1.0
In-Reply-To: <1310462166-31469-1-git-send-email-tj@kernel.org>
References: <1310462166-31469-1-git-send-email-tj@kernel.org>
Date: Tue, 12 Jul 2011 16:26:57 -0700
X-Google-Sender-Auth: uPeqkrKlRLCTcAXAeoJT3XDle9Y
Message-ID: <CAE9FiQUfHB=EtzDBhPr2ntn__0AC0NcCdi0e7NiwmKb0bZmBbg@mail.gmail.com>
Subject: Re: [PATCHSET x86/mm] memblock, x86: Allow node info in memblock and
 remove x86 specific memblock code
From: Yinghai Lu <yinghai@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de,
        benh@kernel.crashing.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 2:15 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> There are multiple ways to represent memory configuration during boot.
> Even with the latest incarnation - nobootmem, the configuration isn't
> centralized or easy to use.  NUMA information lives in
> early_node_map[] while memory config and alloc/reservation live in
> memblock.  This leads to ugly code pieces which try to combine the two
> separate information sources both in generic and arch specfic parts.
>
> This patchset extends memblock such that it can also host node
> information and allows an arch to do away with early_node_map[] and
> use memblock as the sole early memory config / allocation mechanism.
>
> For short term, this adds yet another config option -
> HAVE_MEMBLOCK_NODE_MAP in this area.  Longer term goal is removing
> early_node_map[] completely and convert everyone over to memblock.  As
> early_node_map[] usage is limited only to NUMA archs, this should be
> easiser than bootmem allocator conversion.  In the end, memblock will
> be the only early mem mechanism.
>
> Note that this patchset still leaves good amount of code which can be
> removed / cleaned up in not too distant future.  For example, memblock
> non-NUMA alloc code can simply be degenerate case of NUMA aware alloc,
> which can also be implemented in simpler and more efficient way with
> reverse free area iterator.
>
> This patchset first extends memblock so that it can contain node
> information and then replaces x86 specific memblock code with the
> generic one.
>
>  0001-memblock-Remove-memblock_memory_can_coalesce.patch
>  0002-memblock-Reimplement-memblock_add_region.patch
>  0003-memblock-Add-optional-region-nid.patch
>  0004-x86-Use-HAVE_MEMBLOCK_NODE_MAP.patch
>  0005-x86-Use-__memblock_alloc_base-in-early_reserve_e820.patch
>  0006-memblock-Implement-for_each_free_mem_range.patch
>  0007-x86-Replace-memblock_x86_find_in_range_size-with-for.patch
>  0008-memblock-x86-Make-free_all_memory_core_early-explici.patch
>  0009-memblock-x86-Replace-__get_free_all_memory_range-wit.patch
>  0010-memblock-x86-Reimplement-memblock_find_dma_reserve-u.patch
>  0011-x86-Use-absent_pages_in_range-instead-of-memblock_x8.patch
>  0012-memblock-x86-Make-ARCH_DISCARD_MEMBLOCK-a-config-opt.patch
>  0013-memblock-x86-Replace-memblock_x86_reserve-free_range.patch
>
> 0001-0004 implement HAVE_MEMBLOCK_NODE_MAP and use it in x86.
>
> 0005-0013 adds generic memblock free area iterator and gradually
> replaces x86 specific memblock mechanism with generic one.

that is great, merge early_node_map into memblock array.

looks it comes with some mismatch section warning...

WARNING: vmlinux.o(.text+0x120ba5): Section mismatch in reference from
the function memblock_set_node() to the variable .init.data:memblock
The function memblock_set_node() references
the variable __initdata memblock.
This is often because memblock_set_node lacks a __initdata
annotation or the annotation of memblock is wrong.

WARNING: vmlinux.o(.text+0x120baa): Section mismatch in reference from
the function memblock_set_node() to the function
.init.text:memblock_double_array()
The function memblock_set_node() references
the function __init memblock_double_array().
This is often because memblock_set_node lacks a __init
annotation or the annotation of memblock_double_array is wrong.

WARNING: vmlinux.o(.text+0x120bb9): Section mismatch in reference from
the function memblock_set_node() to the variable .init.data:memblock
The function memblock_set_node() references
the variable __initdata memblock.
This is often because memblock_set_node lacks a __initdata
annotation or the annotation of memblock is wrong.

WARNING: vmlinux.o(.text+0x120bc4): Section mismatch in reference from
the function memblock_set_node() to the variable .init.data:memblock
The function memblock_set_node() references
the variable __initdata memblock.
This is often because memblock_set_node lacks a __initdata
annotation or the annotation of memblock is wrong.

WARNING: vmlinux.o(.text+0x120bd9): Section mismatch in reference from
the function memblock_set_node() to the variable .init.data:memblock
The function memblock_set_node() references
the variable __initdata memblock.
This is often because memblock_set_node lacks a __initdata
annotation or the annotation of memblock is wrong.

WARNING: vmlinux.o(.text+0x120c10): Section mismatch in reference from
the function memblock_set_node() to the variable .init.data:memblock
The function memblock_set_node() references
the variable __initdata memblock.
This is often because memblock_set_node lacks a __initdata
annotation or the annotation of memblock is wrong.

WARNING: vmlinux.o(.text+0x120c15): Section mismatch in reference from
the function memblock_set_node() to the function
.init.text:memblock_insert_region()
The function memblock_set_node() references
the function __init memblock_insert_region().
This is often because memblock_set_node lacks a __init
annotation or the annotation of memblock_insert_region is wrong.

WARNING: vmlinux.o(.text+0x120c3e): Section mismatch in reference from
the function memblock_set_node() to the variable .init.data:memblock
The function memblock_set_node() references
the variable __initdata memblock.
This is often because memblock_set_node lacks a __initdata
annotation or the annotation of memblock is wrong.

WARNING: vmlinux.o(.text+0x120c43): Section mismatch in reference from
the function memblock_set_node() to the function
.init.text:memblock_insert_region()
The function memblock_set_node() references
the function __init memblock_insert_region().
This is often because memblock_set_node lacks a __init
annotation or the annotation of memblock_insert_region is wrong.

WARNING: vmlinux.o(.text+0x120c59): Section mismatch in reference from
the function memblock_set_node() to the variable .init.data:memblock
The function memblock_set_node() references
the variable __initdata memblock.
This is often because memblock_set_node lacks a __initdata
annotation or the annotation of memblock is wrong.

WARNING: vmlinux.o(.text+0x120c66): Section mismatch in reference from
the function memblock_set_node() to the variable .init.data:memblock
The function memblock_set_node() references
the variable __initdata memblock.
This is often because memblock_set_node lacks a __initdata
annotation or the annotation of memblock is wrong.

WARNING: vmlinux.o(.text+0x120c6b): Section mismatch in reference from
the function memblock_set_node() to the function
.init.text:memblock_merge_regions()
The function memblock_set_node() references
the function __init memblock_merge_regions().
This is often because memblock_set_node lacks a __init
annotation or the annotation of memblock_merge_regions is wrong.

WARNING: vmlinux.o(.meminit.text+0xacc): Section mismatch in reference
from the function __early_pfn_to_nid() to the function
.init.text:__next_mem_pfn_range()
The function __meminit __early_pfn_to_nid() references
a function __init __next_mem_pfn_range().
If __next_mem_pfn_range is only used by __early_pfn_to_nid then
annotate __next_mem_pfn_range with a matching annotation.

WARNING: vmlinux.o(.meminit.text+0xb70): Section mismatch in reference
from the function get_pfn_range_for_nid() to the function
.init.text:__next_mem_pfn_range()
The function __meminit get_pfn_range_for_nid() references
a function __init __next_mem_pfn_range().
If __next_mem_pfn_range is only used by get_pfn_range_for_nid then
annotate __next_mem_pfn_range with a matching annotation.

WARNING: vmlinux.o(.meminit.text+0xbad): Section mismatch in reference
from the function get_pfn_range_for_nid() to the function
.init.text:__next_mem_pfn_range()
The function __meminit get_pfn_range_for_nid() references
a function __init __next_mem_pfn_range().
If __next_mem_pfn_range is only used by get_pfn_range_for_nid then
annotate __next_mem_pfn_range with a matching annotation.

WARNING: vmlinux.o(.meminit.text+0xcc9): Section mismatch in reference
from the function __absent_pages_in_range() to the function
.init.text:__next_mem_pfn_range()
The function __meminit __absent_pages_in_range() references
a function __init __next_mem_pfn_range().
If __next_mem_pfn_range is only used by __absent_pages_in_range then
annotate __next_mem_pfn_range with a matching annotation.

WARNING: vmlinux.o(.meminit.text+0xd1a): Section mismatch in reference
from the function __absent_pages_in_range() to the function
.init.text:__next_mem_pfn_range()
The function __meminit __absent_pages_in_range() references
a function __init __next_mem_pfn_range().
If __next_mem_pfn_range is only used by __absent_pages_in_range then
annotate __next_mem_pfn_range with a matching annotation.
