Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327Ab2JKGNs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 02:13:48 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47341 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756797Ab2JKGNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 02:13:47 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1210101609170.2689@kaball.uk.xensource.com>
References: <1349827115-16600-1-git-send-email-yinghai@kernel.org>
	<alpine.DEB.2.02.1210101609170.2689@kaball.uk.xensource.com>
Date: Wed, 10 Oct 2012 23:13:45 -0700
X-Google-Sender-Auth: B9bEoX-F4WA3u1K7wznkYko1dm4
Message-ID: <CAE9FiQW952+jHBHxhKu2PX_fpwb8fXVQp2xX0i=HdzgKWuGFCA@mail.gmail.com>
Subject: Re: [PATCH -v3 0/7] x86: Use BRK to pre mapping page table to make
 xen happy
From: Yinghai Lu <yinghai@kernel.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 9:40 AM, Stefano Stabellini
<stefano.stabellini@eu.citrix.com> wrote:
>
> So you are missing the Xen patches entirely in this iteration of the
> series?

please check updated for-x86-mm branch.

[PATCH -v4 00/15] x86: Use BRK to pre mapping page table to make xen happy

on top of current linus/master and tip/x86/mm2, but please zap last
patch in that branch.

1. use brk to mapping first PMD_SIZE range.
2. top down to initialize page table range by range.
3. get rid of calculate page table, and find_early_page_table.
4. remove early_ioremap in page table accessing.

v2: changes, update xen interface about pagetable_reserve, so not
   use pgt_buf_* in xen code directly.
v3: use range top-down to initialize page table, so will not use
   calculating/find early table anymore.
   also reorder the patches sequence.
v4: add mapping_mark_page_ro to fix xen, also move pgt_buf_* to init.c
    and merge alloc_low_page()

could be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
for-x86-mm

Yinghai Lu (15):
  x86, mm: Align start address to correct big page size
  x86, mm: Use big page size for small memory range
  x86, mm: Don't clear page table if next range is ram
  x86, mm: only keep initial mapping for ram
  x86, mm: Break down init_all_memory_mapping
  x86, xen: Add xen_mapping_mark_page_ro
  x86, mm: setup page table in top-down
  x86, mm: Remove early_memremap workaround for page table accessing on 64bit
  x86, mm: Remove parameter in alloc_low_page for 64bit
  x86, mm: Merge alloc_low_page between 64bit and 32bit
  x86, mm: Move min_pfn_mapped back to mm/init.c
  x86, mm, xen: Remove mapping_pagatable_reserve
  x86, mm: Add alloc_low_pages(num)
  x86, mm: only call early_ioremap_page_range_init() one time on 32bit
  x86, mm: Move back pgt_buf_* to mm/init.c

 arch/x86/include/asm/init.h          |    4 -
 arch/x86/include/asm/pgtable.h       |    1 +
 arch/x86/include/asm/pgtable_types.h |    1 -
 arch/x86/include/asm/x86_init.h      |    2 +-
 arch/x86/kernel/setup.c              |    2 +
 arch/x86/kernel/x86_init.c           |    3 +-
 arch/x86/mm/init.c                   |  321 +++++++++++++++-------------------
 arch/x86/mm/init_32.c                |   76 ++++++--
 arch/x86/mm/init_64.c                |  119 ++++---------
 arch/x86/mm/mm_internal.h            |   11 ++
 arch/x86/xen/mmu.c                   |   29 +---
 11 files changed, 249 insertions(+), 320 deletions(-)
 create mode 100644 arch/x86/mm/mm_internal.h
