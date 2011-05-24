Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509Ab1EXVji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:39:38 -0400
Received: from service87.mimecast.com ([94.185.240.25]:34546 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757161Ab1EXVjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:39:36 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH v6 00/18] ARM: Add support for the Large Physical Address Extensions
Date: Tue, 24 May 2011 22:39:06 +0100
Message-Id: <1306273164-18217-1-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.4.2.g597a6
X-OriginalArrivalTime: 24 May 2011 21:39:44.0130 (UTC) FILETIME=[1870E620:01CC1A5B]
X-MC-Unique: 111052422393300401
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id p4OLiLTo005110

Hi,

This set of patches adds support for the Large Physical Extensions on
the ARM architecture (available with the Cortex-A15 processor). LPAE
comes with a 3-level page table format (compared to 2-level for the
classic one), allowing up to 40-bit physical address space.

The ARM LPAE documentation is available from (free registration needed):

http://infocenter.arm.com/help/topic/com.arm.doc.ddi0406b_virtualization_extns/index.html

The full set of patches on top Linux 2.6.39 (LPAE, support for an
emulated Versatile Express with Cortex-A15 tile and generic timers) is
available on this branch:

git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-2.6-cm.git arm-lpae


Changelog:

- Rebased on top of Linux 2.6.39.
- Russell's nopud patch included in the branch above (but not posted as
  part of the LPAE series).
- The reserved ASID 0 is no longer used during context switching. The
  ASID fixes posted separately by Will Deacon have been included in the
  branch above.
- Fixes for ISBs during MMU enabling.
- Separate proc-v7lpae.S file to avoid unreadable asm code (there are a
  few other #ifdefs in head.S but not that many to require a dedicated
  LPAE() macro).


Catalin Marinas (14):
  ARM: LPAE: Use long long printk format for displaying the pud
  ARM: LPAE: Use unsigned long for __phys_to_virt and __virt_to_phys
  ARM: LPAE: Use PMD_(SHIFT|SIZE|MASK) instead of PGDIR_*
  ARM: LPAE: Factor out 2-level page table definitions into separate
    files
  ARM: LPAE: Add (pte|pmd|pgd|pgprot)val_t type definitions as u32
  ARM: LPAE: Use a mask for physical addresses in page table entries
  ARM: LPAE: Introduce the 3-level page table format definitions
  ARM: LPAE: Page table maintenance for the 3-level format
  ARM: LPAE: MMU setup for the 3-level page table format
  ARM: LPAE: Invalidate the TLB before freeing the PMD
  ARM: LPAE: Add fault handling support
  ARM: LPAE: Add context switching support
  ARM: LPAE: Add identity mapping support for the 3-level page table
    format
  ARM: LPAE: Add the Kconfig entries

Will Deacon (4):
  ARM: LPAE: add ISBs around MMU enabling code
  ARM: LPAE: Use generic dma_addr_t type definition
  ARM: LPAE: mark memory banks with start > ULONG_MAX as highmem
  ARM: LPAE: add support for ATAG_MEM64

 arch/arm/Kconfig                            |    2 +-
 arch/arm/boot/compressed/head.S             |    1 +
 arch/arm/include/asm/assembler.h            |   11 +
 arch/arm/include/asm/memory.h               |    4 +-
 arch/arm/include/asm/page.h                 |   44 +---
 arch/arm/include/asm/pgalloc.h              |   28 ++-
 arch/arm/include/asm/pgtable-2level-hwdef.h |   93 ++++++
 arch/arm/include/asm/pgtable-2level-types.h |   67 +++++
 arch/arm/include/asm/pgtable-2level.h       |  143 +++++++++
 arch/arm/include/asm/pgtable-3level-hwdef.h |   82 ++++++
 arch/arm/include/asm/pgtable-3level-types.h |   69 +++++
 arch/arm/include/asm/pgtable-3level.h       |  107 +++++++
 arch/arm/include/asm/pgtable-hwdef.h        |   81 +-----
 arch/arm/include/asm/pgtable.h              |  211 +++++---------
 arch/arm/include/asm/proc-fns.h             |   25 ++
 arch/arm/include/asm/setup.h                |   10 +-
 arch/arm/include/asm/tlb.h                  |   11 +-
 arch/arm/include/asm/tlbflush.h             |    4 +-
 arch/arm/include/asm/types.h                |   11 +-
 arch/arm/kernel/compat.c                    |    4 +-
 arch/arm/kernel/head.S                      |  119 ++++++---
 arch/arm/kernel/module.c                    |    2 +-
 arch/arm/kernel/setup.c                     |   12 +-
 arch/arm/kernel/sleep.S                     |    2 +
 arch/arm/mm/Kconfig                         |   13 +
 arch/arm/mm/Makefile                        |    4 +
 arch/arm/mm/alignment.c                     |    8 +-
 arch/arm/mm/context.c                       |   34 ++-
 arch/arm/mm/dma-mapping.c                   |    6 +-
 arch/arm/mm/fault.c                         |   82 +++++-
 arch/arm/mm/idmap.c                         |   36 +++-
 arch/arm/mm/ioremap.c                       |    8 +-
 arch/arm/mm/mm.h                            |    4 +-
 arch/arm/mm/mmu.c                           |   51 +++-
 arch/arm/mm/pgd.c                           |   51 +++-
 arch/arm/mm/proc-macros.S                   |    5 +-
 arch/arm/mm/proc-v7lpae.S                   |  422 +++++++++++++++++++++++++++
 37 files changed, 1517 insertions(+), 350 deletions(-)
 create mode 100644 arch/arm/include/asm/pgtable-2level-hwdef.h
 create mode 100644 arch/arm/include/asm/pgtable-2level-types.h
 create mode 100644 arch/arm/include/asm/pgtable-2level.h
 create mode 100644 arch/arm/include/asm/pgtable-3level-hwdef.h
 create mode 100644 arch/arm/include/asm/pgtable-3level-types.h
 create mode 100644 arch/arm/include/asm/pgtable-3level.h
 create mode 100644 arch/arm/mm/proc-v7lpae.S


