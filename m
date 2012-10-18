Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765Ab2JRUvd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 16:51:33 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:42625 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756444Ab2JRUvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 16:51:12 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v5 00/19] x86: Use BRK to pre mapping page table to make xen happy
Date: Thu, 18 Oct 2012 13:50:08 -0700
Message-Id: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on top of current linus/master and tip/x86/mm2, but please zap last patch in that branch.

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
v5: remove mark_page_ro workaround.
    Add another 5 cleanup patches.

could be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-x86-mm

Yinghai Lu (19):
  x86, mm: Align start address to correct big page size
  x86, mm: Use big page size for small memory range
  x86, mm: Don't clear page table if range is ram
  x86, mm: only keep initial mapping for ram
  x86, mm: Break down init_all_memory_mapping
  x86, mm: setup page table in top-down
  x86, mm: Remove early_memremap workaround for page table accessing on 64bit
  x86, mm: Remove parameter in alloc_low_page for 64bit
  x86, mm: Merge alloc_low_page between 64bit and 32bit
  x86, mm: Move min_pfn_mapped back to mm/init.c
  x86, mm, xen: Remove mapping_pagatable_reserve
  x86, mm: Add alloc_low_pages(num)
  x86, mm: only call early_ioremap_page_table_range_init() once
  x86, mm: Move back pgt_buf_* to mm/init.c
  x86, mm: Move init_gbpages() out of setup.c
  x86, mm: change low/hignmem_pfn_init to static on 32bit
  x86, mm: Move function declaration into mm_internal.h
  x86, mm: Let "memmap=" take more entries one time
  x86, mm: Add check before clear pte above max_low_pfn on 32bit

 arch/x86/include/asm/init.h          |   20 +--
 arch/x86/include/asm/pgtable.h       |    1 +
 arch/x86/include/asm/pgtable_types.h |    1 -
 arch/x86/include/asm/x86_init.h      |   12 --
 arch/x86/kernel/e820.c               |   16 ++-
 arch/x86/kernel/setup.c              |   17 +--
 arch/x86/kernel/x86_init.c           |    4 -
 arch/x86/mm/init.c                   |  355 +++++++++++++++++-----------------
 arch/x86/mm/init_32.c                |   85 ++++++---
 arch/x86/mm/init_64.c                |  119 +++--------
 arch/x86/mm/mm_internal.h            |   17 ++
 arch/x86/xen/mmu.c                   |   28 ---
 12 files changed, 308 insertions(+), 367 deletions(-)
 create mode 100644 arch/x86/mm/mm_internal.h

-- 
1.7.7

