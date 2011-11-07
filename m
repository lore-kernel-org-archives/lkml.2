Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710Ab1KGQRQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 11:17:16 -0500
Received: from service87.mimecast.com ([91.220.42.44]:49508 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab1KGQRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 11:17:15 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v8 00/16] ARM: Add support for the Large Physical Address Extensions
Date: Mon,  7 Nov 2011 16:16:42 +0000
Message-Id: <1320682618-1182-1-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.4.2.g597a6
X-OriginalArrivalTime: 07 Nov 2011 16:17:09.0826 (UTC) FILETIME=[B35CBA20:01CC9D68]
X-MC-Unique: 111110716171201901
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id pA7GHO0A015263

Hi,

This is version 8 of the set of patches adding support for the Large
Physical Address Extensions on the ARM architecture (available with the
Cortex-A15 and Cortex-A7 processors).

This patch set against latest mainline is available on this branch:

git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux.git for-next

The full set of patches against Linux 3.1 (together with other ARM
architecture developments) is available on this tree (rebased to latest
mainline regularly):

git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-arm-arch.git

The patch set also includes Russell's nopud patch with an additional
fix-up to be reviewed (they are not in mainline yet but LPAE depends on
them).

My plan is to submit these patches for upstreaming during the upcoming
merging window (for 3.3-rc1). Please let me know of any comments you may
have.


Changelog (from v7):

- Several patches already merged upstream.
- #ifdef's ARM_LPAE removed in pgable.h by moving page walking macros to
  separate 2level.h and 3level.h files (pgalloc.h still has two #ifdef's
  as it's not worth creating separate files for a few lines).
- pmd_addr_end() re-introduced for the 2-level page tables as we use
  pgtable-nopud.h which has a more complex macro that is not eliminated
  by the compiler (following Russell's feedback).
- alignment and debug fault codes moved to system.h near the
  hook_fault_code() function prototype.
- FSR bits and fsr_fs() moved to header file.
- exceptions_init() #ifdef'ed out entirely.
- fsr_info and ifsr_info arrays moved to separate files for 2-level and
  3-level page table formats.
- Kconfig ARM_LPAE help improved.
- proc-v7.S code that differs with LPAE has been factored out into
  proc-2level.S and proc-3level.S files to avoid lots of #ifdef's but
  also share the common code. Functions implemented differently are
  cpu_v7_switch_mm, cpu_v7_set_pte_ext and TTB setting via a new asm
  macro.
- suspend/resume code in proc-v7.S has been modified to preserve TTBCR
  which is non-zero with LPAE.
- Fix to ignore RAM banks beyond 4G when HIGHMEM is not enabled.


Catalin Marinas (12):
  ARM: pgtable: Fix compiler warning in ioremap.c introduced by nopud
  ARM: LPAE: Move page table maintenance macros to pgtable-2level.h
  ARM: LPAE: Move the FSR definitions to separate files
  ARM: LPAE: Factor out classic-MMU specific code into proc-v7-2level.S
  ARM: LPAE: Introduce the 3-level page table format definitions
  ARM: LPAE: Page table maintenance for the 3-level format
  ARM: LPAE: MMU setup for the 3-level page table format
  ARM: LPAE: Invalidate the TLB before freeing the PMD
  ARM: LPAE: Add fault handling support
  ARM: LPAE: Add context switching support
  ARM: LPAE: Add identity mapping support for the 3-level page table
    format
  ARM: LPAE: Add the Kconfig entries

Russell King (1):
  ARM: pgtable: switch to use pgtable-nopud.h

Will Deacon (3):
  ARM: LPAE: add ISBs around MMU enabling code
  ARM: LPAE: mark memory banks with start > ULONG_MAX as highmem
  ARM: LPAE: add support for ATAG_MEM64

 arch/arm/Kconfig                            |    2 +-
 arch/arm/boot/compressed/head.S             |    1 +
 arch/arm/include/asm/assembler.h            |   11 ++
 arch/arm/include/asm/page.h                 |    4 +
 arch/arm/include/asm/pgalloc.h              |   26 ++++-
 arch/arm/include/asm/pgtable-2level.h       |   41 ++++++
 arch/arm/include/asm/pgtable-3level-hwdef.h |   82 +++++++++++++
 arch/arm/include/asm/pgtable-3level-types.h |   70 +++++++++++
 arch/arm/include/asm/pgtable-3level.h       |  155 ++++++++++++++++++++++++
 arch/arm/include/asm/pgtable-hwdef.h        |    4 +
 arch/arm/include/asm/pgtable.h              |   43 +------
 arch/arm/include/asm/proc-fns.h             |   21 +++
 arch/arm/include/asm/setup.h                |    8 ++
 arch/arm/include/asm/system.h               |    8 ++
 arch/arm/include/asm/tlb.h                  |   12 ++-
 arch/arm/kernel/head.S                      |   45 +++++++-
 arch/arm/kernel/hw_breakpoint.c             |    8 +-
 arch/arm/kernel/setup.c                     |   23 ++++
 arch/arm/kernel/sleep.S                     |    2 +
 arch/arm/mm/Kconfig                         |   17 +++
 arch/arm/mm/alignment.c                     |    2 +-
 arch/arm/mm/context.c                       |   19 +++-
 arch/arm/mm/fault.c                         |  111 +++--------------
 arch/arm/mm/fault.h                         |   27 ++++-
 arch/arm/mm/fsr-2level.c                    |   78 ++++++++++++
 arch/arm/mm/fsr-3level.c                    |   68 +++++++++++
 arch/arm/mm/idmap.c                         |   36 +++++-
 arch/arm/mm/ioremap.c                       |   39 ++++---
 arch/arm/mm/mmu.c                           |   46 +++++++-
 arch/arm/mm/pgd.c                           |   51 +++++++-
 arch/arm/mm/proc-macros.S                   |    5 +-
 arch/arm/mm/proc-v7-2level.S                |  171 ++++++++++++++++++++++++++
 arch/arm/mm/proc-v7-3level.S                |  149 +++++++++++++++++++++++
 arch/arm/mm/proc-v7.S                       |  175 +++------------------------
 34 files changed, 1238 insertions(+), 322 deletions(-)
 create mode 100644 arch/arm/include/asm/pgtable-3level-hwdef.h
 create mode 100644 arch/arm/include/asm/pgtable-3level-types.h
 create mode 100644 arch/arm/include/asm/pgtable-3level.h
 create mode 100644 arch/arm/mm/fsr-2level.c
 create mode 100644 arch/arm/mm/fsr-3level.c
 create mode 100644 arch/arm/mm/proc-v7-2level.S
 create mode 100644 arch/arm/mm/proc-v7-3level.S


