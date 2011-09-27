Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab1I0UaY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 16:30:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195Ab1I0UaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 16:30:19 -0400
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Mark Salter <msalter@redhat.com>
Subject: [PATCH v3 00/24] C6X: New architecture
Date: Tue, 27 Sep 2011 16:29:41 -0400
Message-Id: <1317155405-26235-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is v3 of the C6X architecture patch series. Patches are
available in 'upstream-v3' branch at:

    git@linux-c6x.org:/git/projects/linux-c6x-upstreaming

A prebuilt GNU toolchain can be found at:

    http://www.codesourcery.com/sgpp/lite/c6000/portal/release1882

The toolchain bits have also been contributed upstream.

This architecture supports members of the Texas Instruments family
of C6x single and multicore DSPs. The multicore DSPs do not support
cache coherancy, so are not suitable for SMP. Also, these are no-mmu
processors. This core architecture is VLIW with an instruction set
optimized for DSP applications (lots of registers, bit manipulation
instructions, fast multiply, no divide). For details see:

  http://processors.wiki.ti.com/index.php/Main_Page


Changes from the previous patchset are:

 * Added a patch for asm-generic/io.h to fix iounmap decl.

 * Removed the soc-64xx.c files and soc probe code. The only
   remaining code that makes decisions based on SoC-model is
   the clkdev code. That should go away once generic clock
   binding is available and clock code makes better use of
   devicetree.

 * Split out SoC-specific DTSI files from the platform DTS files

 * Added device tree binding documentation

 * Other device tree cleanups per feedback from Grant

 * Cleaned up timer and interrupt code per feedback from tglx

 * Created a generalized Device State Config (DSCR) driver with
   SoC-specific details moved into the device tree

 * Removed obsolete IRQF_DISABLED

 * Removed Power State Controller (PSC) code for now. Will
   reintroduce it when needed by drivers.

 * Add missing iounmap to EMIF driver

 * Removed unneeded (by GCC) apply_relocate() from module support

 * Removed deprecated sys_mmap

 * Fixed race to idle in cpu_idle loop

 * Removed superfluous c6x_power_off

 * Cleaned up Kconfig/Makefile issues pointed out by Sam

 * Use force_sigsegv to avoid SIGSEGV loops

 * Added additional comment to generic strnlen_user patch

Mark Salter (24):
  fix default __strnlen_user macro
  fixed generic page.h for non-zero PAGE_OFFSET
  add ELF machine define for TI C6X DSPs
  add missing __iomem to generic iounmap declaration
  C6X: build infrastructure
  C6X: early boot code
  C6X: devicetree support
  C6X: memory management and DMA support
  C6X: process management
  C6X: signal management
  C6X: time management
  C6X: interrupt handling
  C6X: syscalls
  C6X: traps
  C6X: clocks
  C6X: cache control
  C6X: loadable module support
  C6X: ptrace support
  C6X: headers
  C6X: library code
  C6X: general SoC support
  C6X: EMIF - External Memory Interface
  C6X: DSCR - Device State Configuration Registers
  C6X: MAINTAINERS

 Documentation/devicetree/bindings/c6x/clocks.txt   |   40 +
 Documentation/devicetree/bindings/c6x/dscr.txt     |  127 +++
 Documentation/devicetree/bindings/c6x/emifa.txt    |   62 ++
 .../devicetree/bindings/c6x/interrupt.txt          |  104 +++
 Documentation/devicetree/bindings/c6x/soc.txt      |   28 +
 Documentation/devicetree/bindings/c6x/timer64.txt  |   26 +
 MAINTAINERS                                        |    8 +
 arch/c6x/Kconfig                                   |  173 +++++
 arch/c6x/Makefile                                  |   52 ++
 arch/c6x/boot/Makefile                             |   22 +
 arch/c6x/boot/dts/dsk6455.dts                      |   62 ++
 arch/c6x/boot/dts/evmc6457.dts                     |   48 ++
 arch/c6x/boot/dts/evmc6472.dts                     |   73 ++
 arch/c6x/boot/dts/evmc6474.dts                     |   58 ++
 arch/c6x/boot/dts/tms320c6455.dtsi                 |   96 +++
 arch/c6x/boot/dts/tms320c6457.dtsi                 |   68 ++
 arch/c6x/boot/dts/tms320c6472.dtsi                 |  134 ++++
 arch/c6x/boot/dts/tms320c6474.dtsi                 |   89 +++
 arch/c6x/boot/install-dtb.c                        |  333 ++++++++
 arch/c6x/configs/dsk6455_defconfig                 |   43 +
 arch/c6x/configs/evmc6457_defconfig                |   40 +
 arch/c6x/configs/evmc6472_defconfig                |   41 +
 arch/c6x/configs/evmc6474_defconfig                |   41 +
 arch/c6x/include/asm/Kbuild                        |   55 ++
 arch/c6x/include/asm/asm-offsets.h                 |    1 +
 arch/c6x/include/asm/bitops.h                      |  105 +++
 arch/c6x/include/asm/byteorder.h                   |   12 +
 arch/c6x/include/asm/cache.h                       |   90 +++
 arch/c6x/include/asm/cacheflush.h                  |   65 ++
 arch/c6x/include/asm/checksum.h                    |  115 +++
 arch/c6x/include/asm/clkdev.h                      |   22 +
 arch/c6x/include/asm/clock.h                       |  148 ++++
 arch/c6x/include/asm/delay.h                       |   67 ++
 arch/c6x/include/asm/dma-mapping.h                 |   91 +++
 arch/c6x/include/asm/dscr.h                        |   34 +
 arch/c6x/include/asm/elf.h                         |  113 +++
 arch/c6x/include/asm/ftrace.h                      |    6 +
 arch/c6x/include/asm/hardirq.h                     |   20 +
 arch/c6x/include/asm/irq.h                         |  302 ++++++++
 arch/c6x/include/asm/irqflags.h                    |   72 ++
 arch/c6x/include/asm/linkage.h                     |   30 +
 arch/c6x/include/asm/megamod-pic.h                 |    9 +
 arch/c6x/include/asm/memblock.h                    |    4 +
 arch/c6x/include/asm/mmu.h                         |   18 +
 arch/c6x/include/asm/module.h                      |   33 +
 arch/c6x/include/asm/mutex.h                       |    6 +
 arch/c6x/include/asm/page.h                        |   11 +
 arch/c6x/include/asm/pgtable.h                     |   81 ++
 arch/c6x/include/asm/processor.h                   |  132 ++++
 arch/c6x/include/asm/procinfo.h                    |   28 +
 arch/c6x/include/asm/prom.h                        |    1 +
 arch/c6x/include/asm/ptrace.h                      |  177 +++++
 arch/c6x/include/asm/sections.h                    |   12 +
 arch/c6x/include/asm/setup.h                       |   32 +
 arch/c6x/include/asm/sigcontext.h                  |   80 ++
 arch/c6x/include/asm/signal.h                      |   17 +
 arch/c6x/include/asm/soc.h                         |   35 +
 arch/c6x/include/asm/string.h                      |   21 +
 arch/c6x/include/asm/syscalls.h                    |   55 ++
 arch/c6x/include/asm/system.h                      |  168 ++++
 arch/c6x/include/asm/thread_info.h                 |  121 +++
 arch/c6x/include/asm/timer64.h                     |    6 +
 arch/c6x/include/asm/timex.h                       |   38 +
 arch/c6x/include/asm/tlb.h                         |    8 +
 arch/c6x/include/asm/traps.h                       |   36 +
 arch/c6x/include/asm/uaccess.h                     |  107 +++
 arch/c6x/include/asm/unaligned.h                   |  288 +++++++
 arch/c6x/include/asm/unistd.h                      |   26 +
 arch/c6x/kernel/Makefile                           |   12 +
 arch/c6x/kernel/asm-offsets.c                      |  123 +++
 arch/c6x/kernel/c6x_ksyms.c                        |   68 ++
 arch/c6x/kernel/devicetree.c                       |   53 ++
 arch/c6x/kernel/dma.c                              |  168 ++++
 arch/c6x/kernel/entry.S                            |  803 ++++++++++++++++++++
 arch/c6x/kernel/head.S                             |   84 ++
 arch/c6x/kernel/irq.c                              |  730 ++++++++++++++++++
 arch/c6x/kernel/module.c                           |  129 ++++
 arch/c6x/kernel/process.c                          |  263 +++++++
 arch/c6x/kernel/ptrace.c                           |  207 +++++
 arch/c6x/kernel/setup.c                            |  499 ++++++++++++
 arch/c6x/kernel/signal.c                           |  377 +++++++++
 arch/c6x/kernel/soc.c                              |   78 ++
 arch/c6x/kernel/switch_to.S                        |   74 ++
 arch/c6x/kernel/sys_c6x.c                          |   73 ++
 arch/c6x/kernel/time.c                             |   65 ++
 arch/c6x/kernel/traps.c                            |  423 ++++++++++
 arch/c6x/kernel/vectors.S                          |   81 ++
 arch/c6x/kernel/vmlinux.lds.S                      |  162 ++++
 arch/c6x/lib/Makefile                              |    7 +
 arch/c6x/lib/csum_64plus.S                         |  404 ++++++++++
 arch/c6x/lib/divi.S                                |   53 ++
 arch/c6x/lib/divremi.S                             |   46 ++
 arch/c6x/lib/divremu.S                             |   87 +++
 arch/c6x/lib/divu.S                                |   98 +++
 arch/c6x/lib/llshl.S                               |   37 +
 arch/c6x/lib/llshr.S                               |   38 +
 arch/c6x/lib/llshru.S                              |   38 +
 arch/c6x/lib/memcpy_64plus.S                       |   46 ++
 arch/c6x/lib/mpyll.S                               |   49 ++
 arch/c6x/lib/negll.S                               |   31 +
 arch/c6x/lib/pop_rts.S                             |   32 +
 arch/c6x/lib/push_rts.S                            |   31 +
 arch/c6x/lib/remi.S                                |   64 ++
 arch/c6x/lib/remu.S                                |   82 ++
 arch/c6x/lib/strasgi.S                             |   89 +++
 arch/c6x/lib/strasgi_64plus.S                      |   39 +
 arch/c6x/mm/Makefile                               |    5 +
 arch/c6x/mm/dma-coherent.c                         |  142 ++++
 arch/c6x/mm/init.c                                 |  112 +++
 arch/c6x/platforms/Kconfig                         |   41 +
 arch/c6x/platforms/Makefile                        |   12 +
 arch/c6x/platforms/cache.c                         |  445 +++++++++++
 arch/c6x/platforms/dscr.c                          |  598 +++++++++++++++
 arch/c6x/platforms/emif.c                          |   88 +++
 arch/c6x/platforms/megamod-pic.c                   |  349 +++++++++
 arch/c6x/platforms/platform.c                      |   17 +
 arch/c6x/platforms/pll.c                           |  444 +++++++++++
 arch/c6x/platforms/plldata.c                       |  404 ++++++++++
 arch/c6x/platforms/timer64.c                       |  188 +++++
 include/asm-generic/io.h                           |    2 +-
 include/asm-generic/page.h                         |   10 +-
 include/asm-generic/uaccess.h                      |    7 +-
 include/linux/elf-em.h                             |    1 +
 123 files changed, 13269 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/c6x/clocks.txt
 create mode 100644 Documentation/devicetree/bindings/c6x/dscr.txt
 create mode 100644 Documentation/devicetree/bindings/c6x/emifa.txt
 create mode 100644 Documentation/devicetree/bindings/c6x/interrupt.txt
 create mode 100644 Documentation/devicetree/bindings/c6x/soc.txt
 create mode 100644 Documentation/devicetree/bindings/c6x/timer64.txt
 create mode 100644 arch/c6x/Kconfig
 create mode 100644 arch/c6x/Makefile
 create mode 100644 arch/c6x/boot/Makefile
 create mode 100644 arch/c6x/boot/dts/dsk6455.dts
 create mode 100644 arch/c6x/boot/dts/evmc6457.dts
 create mode 100644 arch/c6x/boot/dts/evmc6472.dts
 create mode 100644 arch/c6x/boot/dts/evmc6474.dts
 create mode 100644 arch/c6x/boot/dts/tms320c6455.dtsi
 create mode 100644 arch/c6x/boot/dts/tms320c6457.dtsi
 create mode 100644 arch/c6x/boot/dts/tms320c6472.dtsi
 create mode 100644 arch/c6x/boot/dts/tms320c6474.dtsi
 create mode 100644 arch/c6x/boot/install-dtb.c
 create mode 100644 arch/c6x/configs/dsk6455_defconfig
 create mode 100644 arch/c6x/configs/evmc6457_defconfig
 create mode 100644 arch/c6x/configs/evmc6472_defconfig
 create mode 100644 arch/c6x/configs/evmc6474_defconfig
 create mode 100644 arch/c6x/include/asm/Kbuild
 create mode 100644 arch/c6x/include/asm/asm-offsets.h
 create mode 100644 arch/c6x/include/asm/bitops.h
 create mode 100644 arch/c6x/include/asm/byteorder.h
 create mode 100644 arch/c6x/include/asm/cache.h
 create mode 100644 arch/c6x/include/asm/cacheflush.h
 create mode 100644 arch/c6x/include/asm/checksum.h
 create mode 100644 arch/c6x/include/asm/clkdev.h
 create mode 100644 arch/c6x/include/asm/clock.h
 create mode 100644 arch/c6x/include/asm/delay.h
 create mode 100644 arch/c6x/include/asm/dma-mapping.h
 create mode 100644 arch/c6x/include/asm/dscr.h
 create mode 100644 arch/c6x/include/asm/elf.h
 create mode 100644 arch/c6x/include/asm/ftrace.h
 create mode 100644 arch/c6x/include/asm/hardirq.h
 create mode 100644 arch/c6x/include/asm/irq.h
 create mode 100644 arch/c6x/include/asm/irqflags.h
 create mode 100644 arch/c6x/include/asm/linkage.h
 create mode 100644 arch/c6x/include/asm/megamod-pic.h
 create mode 100644 arch/c6x/include/asm/memblock.h
 create mode 100644 arch/c6x/include/asm/mmu.h
 create mode 100644 arch/c6x/include/asm/module.h
 create mode 100644 arch/c6x/include/asm/mutex.h
 create mode 100644 arch/c6x/include/asm/page.h
 create mode 100644 arch/c6x/include/asm/pgtable.h
 create mode 100644 arch/c6x/include/asm/processor.h
 create mode 100644 arch/c6x/include/asm/procinfo.h
 create mode 100644 arch/c6x/include/asm/prom.h
 create mode 100644 arch/c6x/include/asm/ptrace.h
 create mode 100644 arch/c6x/include/asm/sections.h
 create mode 100644 arch/c6x/include/asm/setup.h
 create mode 100644 arch/c6x/include/asm/sigcontext.h
 create mode 100644 arch/c6x/include/asm/signal.h
 create mode 100644 arch/c6x/include/asm/soc.h
 create mode 100644 arch/c6x/include/asm/string.h
 create mode 100644 arch/c6x/include/asm/syscalls.h
 create mode 100644 arch/c6x/include/asm/system.h
 create mode 100644 arch/c6x/include/asm/thread_info.h
 create mode 100644 arch/c6x/include/asm/timer64.h
 create mode 100644 arch/c6x/include/asm/timex.h
 create mode 100644 arch/c6x/include/asm/tlb.h
 create mode 100644 arch/c6x/include/asm/traps.h
 create mode 100644 arch/c6x/include/asm/uaccess.h
 create mode 100644 arch/c6x/include/asm/unaligned.h
 create mode 100644 arch/c6x/include/asm/unistd.h
 create mode 100644 arch/c6x/kernel/Makefile
 create mode 100644 arch/c6x/kernel/asm-offsets.c
 create mode 100644 arch/c6x/kernel/c6x_ksyms.c
 create mode 100644 arch/c6x/kernel/devicetree.c
 create mode 100644 arch/c6x/kernel/dma.c
 create mode 100644 arch/c6x/kernel/entry.S
 create mode 100644 arch/c6x/kernel/head.S
 create mode 100644 arch/c6x/kernel/irq.c
 create mode 100644 arch/c6x/kernel/module.c
 create mode 100644 arch/c6x/kernel/process.c
 create mode 100644 arch/c6x/kernel/ptrace.c
 create mode 100644 arch/c6x/kernel/setup.c
 create mode 100644 arch/c6x/kernel/signal.c
 create mode 100644 arch/c6x/kernel/soc.c
 create mode 100644 arch/c6x/kernel/switch_to.S
 create mode 100644 arch/c6x/kernel/sys_c6x.c
 create mode 100644 arch/c6x/kernel/time.c
 create mode 100644 arch/c6x/kernel/traps.c
 create mode 100644 arch/c6x/kernel/vectors.S
 create mode 100644 arch/c6x/kernel/vmlinux.lds.S
 create mode 100644 arch/c6x/lib/Makefile
 create mode 100644 arch/c6x/lib/csum_64plus.S
 create mode 100644 arch/c6x/lib/divi.S
 create mode 100644 arch/c6x/lib/divremi.S
 create mode 100644 arch/c6x/lib/divremu.S
 create mode 100644 arch/c6x/lib/divu.S
 create mode 100644 arch/c6x/lib/llshl.S
 create mode 100644 arch/c6x/lib/llshr.S
 create mode 100644 arch/c6x/lib/llshru.S
 create mode 100644 arch/c6x/lib/memcpy_64plus.S
 create mode 100644 arch/c6x/lib/mpyll.S
 create mode 100644 arch/c6x/lib/negll.S
 create mode 100644 arch/c6x/lib/pop_rts.S
 create mode 100644 arch/c6x/lib/push_rts.S
 create mode 100644 arch/c6x/lib/remi.S
 create mode 100644 arch/c6x/lib/remu.S
 create mode 100644 arch/c6x/lib/strasgi.S
 create mode 100644 arch/c6x/lib/strasgi_64plus.S
 create mode 100644 arch/c6x/mm/Makefile
 create mode 100644 arch/c6x/mm/dma-coherent.c
 create mode 100644 arch/c6x/mm/init.c
 create mode 100644 arch/c6x/platforms/Kconfig
 create mode 100644 arch/c6x/platforms/Makefile
 create mode 100644 arch/c6x/platforms/cache.c
 create mode 100644 arch/c6x/platforms/dscr.c
 create mode 100644 arch/c6x/platforms/emif.c
 create mode 100644 arch/c6x/platforms/megamod-pic.c
 create mode 100644 arch/c6x/platforms/platform.c
 create mode 100644 arch/c6x/platforms/pll.c
 create mode 100644 arch/c6x/platforms/plldata.c
 create mode 100644 arch/c6x/platforms/timer64.c

-- 
1.7.6.2

