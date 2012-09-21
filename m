Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888Ab2IUP5c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 11:57:32 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54142 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756527Ab2IUP5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 11:57:15 -0400
From: Cyril Chemparathy <cyril@ti.com>
To: <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>, <catalin.marinas@arm.com>, <davidb@codeaurora.org>,
        <frank.rowand@am.sony.com>, <hsweeten@visionengravers.com>,
        <linus.walleij@linaro.org>, <marc.zyngier@arm.com>, <nico@linaro.org>,
        <paul.gortmaker@windriver.com>, <plagnioj@jcrosoft.com>,
        <rabin@rab.in>, <rmallon@gmail.com>, <rob.herring@calxeda.com>,
        <sboyd@codeaurora.org>, <sjg@chromium.org>, <tglx@linutronix.de>,
        <tj@kernel.org>, <vincent.guittot@linaro.org>, <vitalya@ti.com>,
        <will.deacon@arm.com>, <grant.likely@secretlab.ca>,
        Cyril Chemparathy <cyril@ti.com>
Subject: [PATCH v3 RESEND 00/17] LPAE fixes and extensions for Keystone
Date: Fri, 21 Sep 2012 11:55:58 -0400
Message-ID: <1348242975-19184-1-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is a repost of the LPAE related changes in preparation for the
introduction of the Keystone sub-architecture.  Earlier postings of this
series can be found at [1], [2], and [3].

I would very much appreciate feedback and/or next steps towards including
these in linux-next.

These patches are also available in git:
git://git.kernel.org/pub/scm/linux/kernel/git/cchemparathy/linux-keystone.git upstream/keystone-lpae-v3

[1] http://comments.gmane.org/gmane.linux.kernel/1341497
[2] http://comments.gmane.org/gmane.linux.kernel/1332069
[3] http://comments.gmane.org/gmane.linux.kernel/1356716

Series changelog:

(01/22) ARM: add mechanism for late code patching
  (v3)	ability to patch multiple sequential instructions with the IMM8 patch
	type
  (v3)	error handling at module patch time
  (v3)	reuse __patch_text() from kprobes code
  (v2)	pulled runtime patching code into separate source files
  (v2)	reordered arguments to patch macros for consistency with assembly
	"Rd, Rt, imm" ordering
  (v2)	added support for mov immediate patching
  (v2)	cache flush patched instructions instead of entire kernel code
  (v2)	pack patch table to reduce table volume
  (v2)	add to module vermagic to reflect abi change
  (v2)	misc. cleanups in naming and structure

(02/22) ARM: add self test for runtime patch mechanism
  (v3)	added tests for both even and odd shifts of immediate values
  (v2)	added init-time tests to verify instruction encoding

(03/22) ARM: use late patch framework for phys-virt patching
  (v3)	fixed commit description for unconditional init of __pv_* symbols
  (v2)	move __pv_offset and __pv_phys_offset to C code
  (v2)	restore conditional init of __pv_offset and __pv_phys_offset

(04/22) ARM: LPAE: use phys_addr_t on virt <--> phys conversion
  (v3)	unchanged from v2
  (v2)	fix patched __phys_to_virt() to use 32-bit operand
  (v2)	convert non-patch __phys_to_virt and __virt_to_phys to inlines to retain
	type checking

(05/22) ARM: LPAE: support 64-bit virt_to_phys patching
  (v3)	added explicit patch stub for 64-bit to clean up compiler generated
	code, both 64-bit and 32-bit cases generate optimal code with this
  (v2)	use phys_addr_t instead of split high/low phys_offsets
  (v2)	use mov immediate instead of add to zero when patching in high order
	physical address bits
  (v2)	fix __pv_phys_offset handling for big-endian
  (v2)	remove set_phys_offset()

(06/22) ARM: LPAE: use signed arithmetic for mask definitions
(07/22) ARM: LPAE: use phys_addr_t in alloc_init_pud()
(08/22) ARM: LPAE: use phys_addr_t in free_memmap()
  (v3)	unchanged from v2
  (v2)	unchanged from v1

(09/22) ARM: LPAE: use phys_addr_t for initrd location and size
  (v3)	unchanged from v2
  (v2)	revert to unsigned long for initrd size

(10/22) ARM: LPAE: use phys_addr_t in switch_mm()
  (v3)	remove unnecessary handling for !LPAE in proc-v7-3level
  (v2)	use phys_addr_t instead of u64 in switch_mm()
  (v2)	revert on changes to v6 and v7-2level
  (v2)	fix register mapping for big-endian in v7-3level

(11/22) ARM: LPAE: use 64-bit accessors for TTBR registers
  (v3)	remove unnecessary condition code clobber
  (v2)	restore comment in cpu_set_reserved_ttbr0()

(12/22) ARM: LPAE: define ARCH_LOW_ADDRESS_LIMIT for bootmem
(13/22) ARM: LPAE: factor out T1SZ and TTBR1 computations
  (v3)	unchanged from v2
  (v2)	unchanged from v1

(14/22) ARM: LPAE: accomodate >32-bit addresses for page table base
  (v3)	unchanged from v2
  (v2)	apply arch_pgd_shift only on lpae
  (v2)	move arch_pgd_shift definition to asm/memory.h
  (v2)	revert on changes to non-lpae procs
  (v2)	add check to ensure that the pgd physical address is aligned at an
	ARCH_PGD_SHIFT boundary

(15/22) ARM: mm: use physical addresses in highmem sanity checks
(16/22) ARM: mm: cleanup checks for membank overlap with vmalloc area
(17/22) ARM: mm: clean up membank size limit checks
  (v3)	unchanged from v2
  (v2)	unchanged from v1


Cyril Chemparathy (14):
  ARM: add mechanism for late code patching
  ARM: add self test for runtime patch mechanism
  ARM: use late patch framework for phys-virt patching
  ARM: LPAE: use phys_addr_t on virt <--> phys conversion
  ARM: LPAE: support 64-bit virt_to_phys patching
  ARM: LPAE: use signed arithmetic for mask definitions
  ARM: LPAE: use phys_addr_t in switch_mm()
  ARM: LPAE: use 64-bit accessors for TTBR registers
  ARM: LPAE: define ARCH_LOW_ADDRESS_LIMIT for bootmem
  ARM: LPAE: factor out T1SZ and TTBR1 computations
  ARM: LPAE: accomodate >32-bit addresses for page table base
  ARM: mm: use physical addresses in highmem sanity checks
  ARM: mm: cleanup checks for membank overlap with vmalloc area
  ARM: mm: clean up membank size limit checks

Vitaly Andrianov (3):
  ARM: LPAE: use phys_addr_t in alloc_init_pud()
  ARM: LPAE: use phys_addr_t in free_memmap()
  ARM: LPAE: use phys_addr_t for initrd location and size

 arch/arm/Kconfig                            |   16 ++
 arch/arm/include/asm/memory.h               |  101 +++++++---
 arch/arm/include/asm/module.h               |    7 +
 arch/arm/include/asm/page.h                 |    2 +-
 arch/arm/include/asm/pgtable-3level-hwdef.h |   10 +
 arch/arm/include/asm/pgtable-3level.h       |    6 +-
 arch/arm/include/asm/proc-fns.h             |   28 ++-
 arch/arm/include/asm/runtime-patch.h        |  208 +++++++++++++++++++++
 arch/arm/kernel/Makefile                    |    1 +
 arch/arm/kernel/armksyms.c                  |    4 -
 arch/arm/kernel/head.S                      |  107 +++--------
 arch/arm/kernel/module.c                    |   14 +-
 arch/arm/kernel/runtime-patch.c             |  268 +++++++++++++++++++++++++++
 arch/arm/kernel/setup.c                     |   15 ++
 arch/arm/kernel/smp.c                       |   11 +-
 arch/arm/kernel/vmlinux.lds.S               |   13 +-
 arch/arm/mm/context.c                       |    9 +-
 arch/arm/mm/init.c                          |   19 +-
 arch/arm/mm/mmu.c                           |   49 ++---
 arch/arm/mm/proc-v7-3level.S                |   41 ++--
 20 files changed, 728 insertions(+), 201 deletions(-)
 create mode 100644 arch/arm/include/asm/runtime-patch.h
 create mode 100644 arch/arm/kernel/runtime-patch.c

-- 
1.7.9.5

