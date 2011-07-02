Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab1GBVQO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 17:16:14 -0400
Received: from mail.southpole.se ([193.12.106.18]:45870 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087Ab1GBVQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 17:16:11 -0400
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: OpenRISC Architecture: Patch set version 2 
Date: Sat,  2 Jul 2011 23:15:33 +0200
Message-Id: <1309641352-18714-1-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.7.4.1
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is version 2 of the OpenRISC architecture patch set.  Changes
since version 1 include:

- general cleanups, removing unused code and variables, taking care of
  compiler warnings, etc.
- cleanups for all the errors spotted by checkpatch.pl
- changes in response to the feedback received for version 1 of the patch set
- simplification of the fixmap code
- simplification of the DMA code
- calculate loops_per_jiffy from cpu frequency passed in via devicetree
- rework io.h to use more generic code
- rework the delay code, making it more generic

- also, the module code has been reworked, making it more generic; this is
  not included in this patch as the generic parts are still pending review

Since version 1:
54 files changed, 793 insertions(+), 1900 deletions(-)

Once again, all this code can be found in the 'for-upstream' branch at:

git://openrisc.net/jonas/linux

Note, that there are three patches at the base of the branch that make
some changes to generic kernel code that are necessary for the OpenRISC
patches to work.  Those patches aren't included in this post as they have
already been posted for review earlier.

In this series:

[PATCH v2 01/19] OpenRISC: Boot code
[PATCH v2 02/19] OpenRISC: Device tree
[PATCH v2 03/19] OpenRISC: Memory management
[PATCH v2 04/19] OpenRISC: Signal handling
[PATCH v2 05/19] OpenRISC: Build infrastructure
[PATCH v2 06/19] OpenRISC: PTrace
[PATCH v2 07/19] OpenRISC: DMA
[PATCH v2 08/19] OpenRISC: Timekeeping
[PATCH v2 09/19] OpenRISC: IRQ
[PATCH v2 10/19] OpenRISC: System calls
[PATCH v2 11/19] OpenRISC: Idle/Power management
[PATCH v2 12/19] OpenRISC: Scheduling/Process management
[PATCH v2 13/19] OpenRISC: GPIO
[PATCH v2 14/19] OpenRISC: Module support
[PATCH v2 15/19] OpenRISC: Traps
[PATCH v2 16/19] OpenRISC: Headers
[PATCH v2 17/19] OpenRISC: Library routines
[PATCH v2 18/19] OpenRISC: Miscellaneous
[PATCH v2 19/19] OpenRISC: Add MAINTAINERS entry

Looking forward to further feedback!

/Jonas

Diffstat for entire series:

 MAINTAINERS                              |    8 +
 arch/openrisc/Kconfig                    |  207 ++++
 arch/openrisc/Makefile                   |   66 ++
 arch/openrisc/README.openrisc            |  102 ++
 arch/openrisc/TODO.openrisc              |   18 +
 arch/openrisc/boot/Makefile              |   15 +
 arch/openrisc/boot/dts/atlys.dts         |   78 ++
 arch/openrisc/boot/dts/or1ksim.dts       |   73 ++
 arch/openrisc/configs/or1ksim_defconfig  |   67 ++
 arch/openrisc/include/asm/Kbuild         |   64 ++
 arch/openrisc/include/asm/asm-offsets.h  |    1 +
 arch/openrisc/include/asm/bitops.h       |   59 ++
 arch/openrisc/include/asm/bitops/__ffs.h |   33 +
 arch/openrisc/include/asm/bitops/__fls.h |   33 +
 arch/openrisc/include/asm/bitops/ffs.h   |   32 +
 arch/openrisc/include/asm/bitops/fls.h   |   33 +
 arch/openrisc/include/asm/byteorder.h    |    1 +
 arch/openrisc/include/asm/cache.h        |   29 +
 arch/openrisc/include/asm/cpuinfo.h      |   34 +
 arch/openrisc/include/asm/delay.h        |   24 +
 arch/openrisc/include/asm/dma-mapping.h  |   62 ++
 arch/openrisc/include/asm/elf.h          |  109 ++
 arch/openrisc/include/asm/fixmap.h       |   88 ++
 arch/openrisc/include/asm/gpio.h         |   65 ++
 arch/openrisc/include/asm/io.h           |   51 +
 arch/openrisc/include/asm/irq.h          |   27 +
 arch/openrisc/include/asm/irqflags.h     |   29 +
 arch/openrisc/include/asm/linkage.h      |   25 +
 arch/openrisc/include/asm/memblock.h     |   24 +
 arch/openrisc/include/asm/mmu.h          |   26 +
 arch/openrisc/include/asm/mmu_context.h  |   43 +
 arch/openrisc/include/asm/mutex.h        |   27 +
 arch/openrisc/include/asm/page.h         |  112 +++
 arch/openrisc/include/asm/param.h        |   26 +
 arch/openrisc/include/asm/pgalloc.h      |  142 +++
 arch/openrisc/include/asm/pgtable.h      |  449 +++++++++
 arch/openrisc/include/asm/processor.h    |  112 +++
 arch/openrisc/include/asm/prom.h         |   92 ++
 arch/openrisc/include/asm/ptrace.h       |  124 +++
 arch/openrisc/include/asm/serial.h       |   36 +
 arch/openrisc/include/asm/sigcontext.h   |   38 +
 arch/openrisc/include/asm/spinlock.h     |   24 +
 arch/openrisc/include/asm/spr.h          |   42 +
 arch/openrisc/include/asm/spr_defs.h     |  604 +++++++++++
 arch/openrisc/include/asm/syscall.h      |   77 ++
 arch/openrisc/include/asm/syscalls.h     |   27 +
 arch/openrisc/include/asm/system.h       |   35 +
 arch/openrisc/include/asm/thread_info.h  |  149 +++
 arch/openrisc/include/asm/timex.h        |   36 +
 arch/openrisc/include/asm/tlb.h          |   34 +
 arch/openrisc/include/asm/tlbflush.h     |   72 ++
 arch/openrisc/include/asm/uaccess.h      |  385 +++++++
 arch/openrisc/include/asm/unaligned.h    |   51 +
 arch/openrisc/include/asm/unistd.h       |   29 +
 arch/openrisc/kernel/Makefile            |   14 +
 arch/openrisc/kernel/asm-offsets.c       |   70 ++
 arch/openrisc/kernel/dma.c               |   86 ++
 arch/openrisc/kernel/entry.S             | 1134 +++++++++++++++++++++
 arch/openrisc/kernel/head.S              | 1607 ++++++++++++++++++++++++++++++
 arch/openrisc/kernel/idle.c              |   77 ++
 arch/openrisc/kernel/init_task.c         |   41 +
 arch/openrisc/kernel/irq.c               |  172 ++++
 arch/openrisc/kernel/module.c            |  126 +++
 arch/openrisc/kernel/or32_ksyms.c        |   46 +
 arch/openrisc/kernel/process.c           |  305 ++++++
 arch/openrisc/kernel/prom.c              |  109 ++
 arch/openrisc/kernel/ptrace.c            |  574 +++++++++++
 arch/openrisc/kernel/ptrace.h            |   37 +
 arch/openrisc/kernel/setup.c             |  386 +++++++
 arch/openrisc/kernel/signal.c            |  404 ++++++++
 arch/openrisc/kernel/sys_call_table.c    |   28 +
 arch/openrisc/kernel/sys_or32.c          |   83 ++
 arch/openrisc/kernel/time.c              |  181 ++++
 arch/openrisc/kernel/traps.c             |  367 +++++++
 arch/openrisc/kernel/vmlinux.h           |   12 +
 arch/openrisc/kernel/vmlinux.lds.S       |  115 +++
 arch/openrisc/lib/Makefile               |    5 +
 arch/openrisc/lib/delay.c                |   60 ++
 arch/openrisc/lib/string.S               |  204 ++++
 arch/openrisc/mm/Makefile                |    5 +
 arch/openrisc/mm/fault.c                 |  338 +++++++
 arch/openrisc/mm/init.c                  |  283 ++++++
 arch/openrisc/mm/ioremap.c               |  113 +++
 arch/openrisc/mm/tlb.c                   |  191 ++++
 arch/openrisc/or1ksim.cfg                |  888 +++++++++++++++++
 85 files changed, 12310 insertions(+), 0 deletions(-)
