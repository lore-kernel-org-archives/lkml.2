Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006Ab1GLJQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 05:16:15 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61601 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab1GLJQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 05:16:12 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de,
        benh@kernel.crashing.org, yinghai@kernel.org, davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org
Subject: [PATCHSET x86/mm] memblock, x86: Allow node info in memblock and remove x86 specific memblock code
Date: Tue, 12 Jul 2011 11:15:53 +0200
Message-Id: <1310462166-31469-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

There are multiple ways to represent memory configuration during boot.
Even with the latest incarnation - nobootmem, the configuration isn't
centralized or easy to use.  NUMA information lives in
early_node_map[] while memory config and alloc/reservation live in
memblock.  This leads to ugly code pieces which try to combine the two
separate information sources both in generic and arch specfic parts.

This patchset extends memblock such that it can also host node
information and allows an arch to do away with early_node_map[] and
use memblock as the sole early memory config / allocation mechanism.

For short term, this adds yet another config option -
HAVE_MEMBLOCK_NODE_MAP in this area.  Longer term goal is removing
early_node_map[] completely and convert everyone over to memblock.  As
early_node_map[] usage is limited only to NUMA archs, this should be
easiser than bootmem allocator conversion.  In the end, memblock will
be the only early mem mechanism.

Note that this patchset still leaves good amount of code which can be
removed / cleaned up in not too distant future.  For example, memblock
non-NUMA alloc code can simply be degenerate case of NUMA aware alloc,
which can also be implemented in simpler and more efficient way with
reverse free area iterator.

This patchset first extends memblock so that it can contain node
information and then replaces x86 specific memblock code with the
generic one.

 0001-memblock-Remove-memblock_memory_can_coalesce.patch
 0002-memblock-Reimplement-memblock_add_region.patch
 0003-memblock-Add-optional-region-nid.patch
 0004-x86-Use-HAVE_MEMBLOCK_NODE_MAP.patch
 0005-x86-Use-__memblock_alloc_base-in-early_reserve_e820.patch
 0006-memblock-Implement-for_each_free_mem_range.patch
 0007-x86-Replace-memblock_x86_find_in_range_size-with-for.patch
 0008-memblock-x86-Make-free_all_memory_core_early-explici.patch
 0009-memblock-x86-Replace-__get_free_all_memory_range-wit.patch
 0010-memblock-x86-Reimplement-memblock_find_dma_reserve-u.patch
 0011-x86-Use-absent_pages_in_range-instead-of-memblock_x8.patch
 0012-memblock-x86-Make-ARCH_DISCARD_MEMBLOCK-a-config-opt.patch
 0013-memblock-x86-Replace-memblock_x86_reserve-free_range.patch

0001-0004 implement HAVE_MEMBLOCK_NODE_MAP and use it in x86.

0005-0013 adds generic memblock free area iterator and gradually
replaces x86 specific memblock mechanism with generic one.

This patchset is on top of

  x86/urgent (5da0ef9a85 "x86: Disable AMD_NUMA for 32bit for now")
+ pfn->nid granularity check patches [1]
+ "memblock, x86: Misc cleanups" patchset [2]
+ "memblock, x86: Implement for_each_mem_pfn_range() and use it to improve memblock allocator" patchset [3]

and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-x86-mm-memblock

Diffstat follows.

 arch/x86/Kconfig                |    2
 arch/x86/include/asm/e820.h     |    2
 arch/x86/include/asm/memblock.h |   22 --
 arch/x86/kernel/aperture_64.c   |    2
 arch/x86/kernel/check.c         |   34 +--
 arch/x86/kernel/e820.c          |   55 ++---
 arch/x86/kernel/head.c          |    2
 arch/x86/kernel/head32.c        |    5
 arch/x86/kernel/head64.c        |    5
 arch/x86/kernel/mpparse.c       |   12 -
 arch/x86/kernel/setup.c         |   17 -
 arch/x86/kernel/trampoline.c    |    2
 arch/x86/mm/Makefile            |    2
 arch/x86/mm/init.c              |    6
 arch/x86/mm/init_32.c           |   28 +-
 arch/x86/mm/memblock.c          |  318 ----------------------------
 arch/x86/mm/memtest.c           |   33 +--
 arch/x86/mm/numa.c              |   24 +-
 arch/x86/mm/numa_32.c           |    6
 arch/x86/mm/numa_64.c           |    2
 arch/x86/mm/numa_emulation.c    |   34 +--
 arch/x86/platform/efi/efi.c     |    6
 arch/x86/xen/mmu.c              |   12 -
 arch/x86/xen/setup.c            |    7
 include/linux/bootmem.h         |    2
 include/linux/memblock.h        |   54 ++++
 include/linux/mm.h              |    2
 mm/Kconfig                      |    6
 mm/memblock.c                   |  440 ++++++++++++++++++++++++++++------------
 mm/nobootmem.c                  |   40 ++-
 mm/page_alloc.c                 |   47 ++--
 31 files changed, 554 insertions(+), 675 deletions(-)

Thanks.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/1166521
[2] http://thread.gmane.org/gmane.linux.kernel.cross-arch/10338
[3] http://thread.gmane.org/gmane.linux.kernel.cross-arch/10345
