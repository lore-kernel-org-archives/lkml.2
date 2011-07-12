Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999Ab1GLIqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 04:46:45 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53344 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab1GLIqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 04:46:42 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de,
        benh@kernel.crashing.org, yinghai@kernel.org, davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org
Subject: [PATCHSET x86/mm] memblock, x86: Implement for_each_mem_pfn_range() and use it to improve memblock allocator
Date: Tue, 12 Jul 2011 10:46:27 +0200
Message-Id: <1310460395-30913-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Currently, page_alloc internal functions walk early_node_map[]
directly while external users can walk it with callback based
work_with_active_regions().

Callback based walking is awkward to use and iterating
early_node_map[] directly hinders scheduled move of node information
to memblock.  This patchset implements for_each_mem_pfn_range() which
is easier for and used by both internal and external users, and
provides indirection layer so that node memory information can be
moved elsewhere.

This patchset is composed of two parts.  The first half implements the
new iterator and converts all internal and external users other than
the ones which directly manipulate early_node_map[].

The second half uses the new iterator to improve memblock_nid_range(),
implement proper top-down memblock allocation and replaces x86
specific memblock allocator with it.

Most of the changes are in mm/page_alloc,memblock.c and under x86 but
there are small updates to sparc and powerpc.  They shouldn't change
any behavior but I've only compile tested them.

 0001-bootmem-Replace-work_with_active_regions-with-for_ea.patch
 0002-bootmem-Reimplement-__absent_pages_in_range-using-fo.patch
 0003-bootmem-Use-for_each_mem_pfn_range-in-page_alloc.c.patch
 0004-memblock-Improve-generic-memblock_nid_range-using-fo.patch
 0005-memblock-Don-t-allow-archs-to-override-memblock_nid_.patch
 0006-memblock-Make-memblock_alloc_-try_-nid-top-down.patch
 0007-memblock-Separate-out-memblock_find_in_range_node.patch
 0008-memblock-x86-Replace-memblock_x86_find_in_range_node.patch

0001 implements for_each_mem_pfn_range() and replaces
work_with_active_regions() with it.

0002-0003 apply for_each_mem_pfn_range() in page_alloc.c.

0004-0008 implement proper top-down allocation for memblock and
replace x86 specific memblock allocator with it.

This patchset is on top of

  x86/urgent (5da0ef9a85 "x86: Disable AMD_NUMA for 32bit for now")
+ pfn->nid granularity check patches [1]
+ "memblock, x86: Misc cleanups" patchset [2]

and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-x86-mm-iter

This patchset simplifies early_node_map[] walking and removes
duplicate x86 specific implementation and removes just shy of 200
lines.

 arch/powerpc/mm/numa.c          |   50 +-----
 arch/sparc/mm/init_64.c         |    4
 arch/x86/include/asm/memblock.h |    1
 arch/x86/mm/memblock.c          |   38 ----
 arch/x86/mm/numa.c              |    9 -
 drivers/pci/intel-iommu.c       |   24 +-
 include/linux/memblock.h        |    5
 include/linux/mm.h              |   24 ++
 mm/memblock.c                   |   90 ++++-------
 mm/nobootmem.c                  |    3
 mm/page_alloc.c                 |  326 +++++++++++-----------------------------
 11 files changed, 190 insertions(+), 384 deletions(-)

Thanks.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/1166521
[2] http://thread.gmane.org/gmane.linux.kernel.cross-arch/10338
