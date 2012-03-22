Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030548Ab2CVArO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 20:47:14 -0400
Received: from gate.crashing.org ([63.228.1.57]:36075 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030510Ab2CVArK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 20:47:10 -0400
Message-ID: <1332377206.2982.60.camel@pasglop>
Subject: [git pull] Please pull powerpc.git next branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Thu, 22 Mar 2012 11:46:46 +1100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here's the powerpc batch for this merge window. It is going to be a bit
more nasty than usual as in touching things outside of arch/powerpc
mostly due to the big iSeriesectomy :-) We finally got rid of the bugger
(legacy iSeries support) which was a PITA to maintain and that nobody
really used anymore.

Here are some of the highlights:

 - Legacy iSeries is gone. Thanks Stephen ! There's still some bits and
pieces remaining if you do a grep -ir series arch/powerpc but they are
harmless and will be removed in the next few weeks hopefully.

 - The 'fadump' functionality (Firmware Assisted Dump) replaces the
previous (equivalent) "pHyp assisted dump"... it's a rewrite of a
mechanism to get the hypervisor to do crash dumps on pSeries, the new
implementation hopefully being much more reliable. Thanks Mahesh
Salgaonkar.

 - The "EEH" code (pSeries PCI error handling & recovery) got a big
spring cleaning, motivated by the need to be able to implement a new
backend for it on top of some new different type of firwmare. The work
isn't complete yet, but a good chunk of the cleanups is there. Note that
this adds a field to struct device_node which is not very nice and which
Grant objects to. I will have a patch soon that moves that to a powerpc
private data structure (hopefully before rc1) and we'll improve things
further later on (hopefully getting rid of the need for that pointer
completely). Thanks Gavin Shan.

 - I dug into our exception & interrupt handling code to improve the way
we do lazy interrupt handling (and make it work properly with "edge"
triggered interrupt sources), and while at it found & fixed a wagon of
issues in those areas, including adding support for page fault retry &
fatal signals on page faults.

 - Your usual random batch of small fixes & updates, including a bunch
of new embedded boards, both Freescale and APM based ones, etc...

Cheers,
Ben.

The following changes since commit 203738e548cefc3fc3c2f73a9063176c9f3583d5:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2012-02-26 12:47:17 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git next

for you to fetch changes up to dfbc2d75c1bd47c3186fa91f1655ea2f3825b0ec:

  powerpc/ps3: Do not adjust the wrapper load address (2012-03-21 11:16:13 +1100)

----------------------------------------------------------------
Akinobu Mita (1):
      powerpc/pmac: Use string library in nvram code

Andrea Gelmini (1):
      Documentation/powerpc/mpc52xx.txt: Checkpatch cleanup

Anton Blanchard (2):
      atomic: Allow atomic_inc_not_zero to be overridden
      powerpc/atomic: Implement atomic*_inc_not_zero

Benjamin Herrenschmidt (21):
      Merge remote-tracking branch 'origin/master' into next
      powerpc/mpic: Fix allocation of reverse-map for multi-ISU mpics
      powerpc: Remove legacy iSeries bits from assembly files
      powerpc: Use the same interrupt prolog for perfmon as other interrupts
      powerpc: Rework runlatch code
      powerpc: Improve 64-bit syscall entry/exit
      powerpc: Improve behaviour of irq tracing on 64-bit exception entry
      powerpc: Call do_page_fault() with interrupts off
      powerpc: Disable interrupts in 64-bit kernel FP and vector faults
      powerpc: Add support for page fault retry and fatal signals
      powerpc/xmon: Add display of soft & hard irq states
      powerpc: Fix register clobbering when accumulating stolen time
      powerpc: Fix 64-bit BookE FP unavailable exceptions
      powerpc: Replace mfmsr instructions with load from PACA kernel_msr field
      powerpc: Rework lazy-interrupt handling
      Merge branch 'eeh' into next
      powerpc/hvc_udbg: Don't crash when udbg_putc is NULL
      powerpc: Fix power4/970 idle code regression with lockdep
      Merge remote-tracking branch 'jwb/next' into next
      Merge remote-tracking branch 'kumar/next' into next
      powerpc/spufs: Fix double unlocks

Claudiu Manoil (2):
      powerpc/85xx: Fix compiler error with THIS_MODULE and related
      powerpc/85xx: Add missing config option for CACHE SRAM code

Danny Kukawka (2):
      arch/powerpc/kvm/book3s_hv.c: included linux/sched.h twice
      arch/powerpc/platforms/powernv/setup.c: included asm/xics.h twice

Diana CRACIUN (1):
      powerpc/fsl: Added aliased MSIIR register address to MSI node in dts

Gavin Shan (21):
      powerpc/eeh: Cleanup comments in the EEH core
      powerpc/eeh: Cleanup function names in the EEH core
      powerpc/eeh: Platform dependent EEH operations
      powerpc/eeh: pseries platform EEH initialization
      powerpc/eeh: pseries platform EEH operations
      powerpc/eeh: pseries platform EEH PE address retrieval
      powerpc/eeh: pseries platform PE state retrieval
      powerpc/eeh: pseries platform EEH wait PE state
      powerpc/eeh: pseries platform EEH reset PE
      powerpc/eeh: pseries platform EEH error log retrieval
      powerpc/eeh: pseries platform EEH configure bridge
      powerpc/pseries: Cleanup comments in EEH aux components
      powerpc/eeh: Cleanup function names in EEH aux components
      powerpc/eeh: Introduce EEH device
      powerpc/eeh: Replace pci_dn with eeh_dev for EEH sysfs
      powerpc/eeh: Replace pci_dn with eeh_dev for EEH address cache
      powerpc/eeh: Replace pci_dn with eeh_dev for EEH core
      powerpc/eeh: Replace pci_dn with eeh_dev for EEH aux components
      powerpc/eeh: Replace pci_dn with eeh_dev for EEH on pSeries
      powerpc/eeh: Introduce struct eeh_stats for EEH
      powerpc/eeh: pseries platform config space access in EEH

Grant Likely (2):
      powerpc: Make SPARSE_IRQ required
      powerpc/5200: convert mpc5200 to use of_platform_populate()

Gustavo Zacarias (1):
      powerpc/85xx: fix typo in p1010rdb.dtsi

Heiko Schocher (3):
      powerpc/mpc5200: update mpc5200_defconfig to fit for charon board
      powerpc/mpc52xx: add a4m072 board support
      powerpc/mpc5200: add options to mpc5200_defconfig

Ira Snyder (2):
      carma-fpga: fix lockdep warning
      carma-fpga: fix race between data dumping and DMA callback

Jerry Huang (2):
      powerpc/85xx: add P1020MBG-PC platform support
      powerpc/85xx: add P1020UTM-PC platform support

Jia Hongtao (3):
      powerpc/85xx: Clean up partition nodes in dts for MPC8572DS
      powerpc: add support for MPIC message register API
      powerpc: document the FSL MPIC message register binding

Jimi Xenidis (1):
      powerpc/icswx: Fix race condition with IPI setting ACOP

Joe Perches (1):
      powerpc: Use vsprintf extention %pf with builtin_return_address

Josh Boyer (1):
      MAINTAINERS: Update PowerPC 4xx tree

Kumar Gala (2):
      powerpc/fsl-booke: Fixup calc_cam_sz to support MMU v2
      powerpc: Add initial e6500 cpu support

Kyle Moffett (6):
      powerpc/mpic: Fix use of "flags" variable in mpic_alloc()
      fsl/mpic: Document and use the "big-endian" device-tree flag
      fsl/mpic: Create and document the "single-cpu-affinity" device-tree flag
      powerpc/mpic: Remove MPIC_BROKEN_FRR_NIRQS and duplicate irq_count
      powerpc/mpic: Add "last-interrupt-source" property to override hardware
      powerpc/mpic: Remove duplicate MPIC_WANTS_RESET flag

Liu Gang (2):
      powerpc/srio: Fix the relocation errors when building with 64bit
      powerpc/srio: Fix the compile errors when building with 64bit

Liu Shuo (2):
      powerpc/fsl_msi: return proper error value when ioremap failed.
      powerpc/dts: fix the compatible string of sec 4.0

Mahesh Salgaonkar (10):
      fadump: Add documentation for firmware-assisted dump.
      fadump: Reserve the memory for firmware assisted dump.
      fadump: Register for firmware assisted dump.
      fadump: Initialize elfcore header and add PT_LOAD program headers.
      fadump: Convert firmware-assisted cpu state dump data into elf notes.
      fadump: Add PT_NOTE program header for vmcoreinfo
      fadump: Introduce cleanup routine to invalidate /proc/vmcore.
      fadump: Invalidate registration and release reserved memory for general use.
      fadump: Invalidate the fadump registration during machine shutdown.
      fadump: Remove the phyp assisted dump code.

Martyn Welch (4):
      powerpc: Add GE FPGA config option
      gpio: Move GE GPIO driver to reside within GPIO subsystem
      powerpc: Move GE PIC drivers
      powerpc/85xx: Board support for GE IMP3A

Masanari Iida (1):
      macintosh: Fix typo in mediabay.c

Matt Fleming (1):
      powerpc: Use set_current_blocked() and block_sigmask()

Michael Ellerman (1):
      powerpc/perf: Move perf core & PMU code into a subdirectory

Nishanth Aravamudan (1):
      powerpc/prom: Remove limit on maximum size of properties

Paul Gortmaker (2):
      powerpc/85xx: fix Kconfig warning about missing 8250 dependency
      powerpc/83xx: mpc836x - fix failed phy detection for ucc ethernet on MDS

Prabhakar Kushwaha (1):
      NAND Machine support for Integrated Flash Controller

Ramneek Mehresh (1):
      powerpc/85xx: Add usb controller version info

Sebastian Andrzej Siewior (2):
      powerpc/85xx: p2020rdb - move the NAND address.
      powerpc/85xx: p2020rdb & p1010rdb - lower spi flash freq to 40Mhz

Stephen Rothwell (15):
      powerpc: remove CONFIG_PPC_ISERIES from the architecture Kconfig files
      powerpc: Remove the main legacy iSerie platform code
      net: powerpc: remove the legacy iSeries ethernet driver
      powerpc: remove the legacy iSeries part of ibmvscsi
      tty: powerpc: remove hvc_iseries
      tty: powerpc: remove SERIAL_ICOM dependency on PPC_ISERIES
      driver-core: remove legacy iSeries hack
      powerpc: clean up vio.c
      powerpc: Remove some of the legacy iSeries specific device drivers
      tty/hvc_vio: FW_FEATURE_ISERIES is no longer selectable
      powerpc: Remove FW_FEATURE ISERIES from arch code
      init: Remove CONFIG_PPC_ISERIES
      powerpc: Remove the remaining CONFIG_PPC_ISERIES pieces
      powerpc: Remove the rest of the legacy iSeries include files
      powerpc/ps3: Do not adjust the wrapper load address

Tang Yuantian (2):
      powerpc/85xx: Adds Support for P2020RDB-PC board
      powerpc/85xx: Add p2020rdb-pc dts support

Timur Tabi (4):
      powerpc/85xx: create 32-bit DTS for the P1022DS
      powerpc/85xx: p1022ds: disable the NOR flash node if video is enabled
      powerpc/85xx: p1022ds: enable monitor switching via pixis indirect mode
      powerpc/85xx: allow CONFIG_PHYS_64BIT to be selectable

Vinh Nguyen Huu Tuong (3):
      powerpc/44x: The bug fixed support for APM821xx SoC and Bluestone board
      powerpc/44x: Add support PCI-E for APM821xx SoC and Bluestone board
      powerpc/44x: Add additional device support for APM821xx SoC and Bluestone board

Xie Xiaobo (2):
      powerpc/85xx: Add some DTS nodes and attributes for mpc8536ds
      powerpc/85xx: Add magic-packet properties for etsec

Xu Jiucheng (2):
      powerpc/85xx: Added dts for P1021RDB-PC board
      powerpc/85xx: Added P1021RDB-PC Platform support

Zhao Chenhui (3):
      powerpc/85xx: mpc8548cds - fix alias in mpc8548si-pre.dtsi
      powerpc/85xx: Refactor mpc8548cds device tree
      powerpc/85xx: mpc8548cds - add 36-bit dts

Zhicheng Fan (6):
      powerpc/85xx: Add p1025rdb platform support
      powerpc/85xx: Add dts for p1025rdb board
      powerpc/85xx: Add p1020rdb-pc platform support
      powerpc/85xx: Add dts for p1020rdb-pc board
      powerpc/85xx: Abstract common define of signal multiplex control for qe
      powerpc/85xx: Add Quicc Engine support for p1025rdb

chenhui zhao (5):
      powerpc/85xx: l2sram - Add compatible entry for mpc8548 L2 controller
      powerpc/85xx: mpc85xxcds - Fix PCI I/O space resource of PCI bridge
      powerpc/85xx: mpc8548cds - Add NOR flash node to dts
      powerpc/85xx: mpc8548cds - Add RapidIO node to dts
      powerpc/85xx: mpc8548cds - Add FPGA node to dts

 .../devicetree/bindings/powerpc/fsl/mpic-msgr.txt  |   63 +
 .../devicetree/bindings/powerpc/fsl/mpic.txt       |   22 +-
 .../devicetree/bindings/powerpc/fsl/msi-pic.txt    |    6 +-
 Documentation/powerpc/firmware-assisted-dump.txt   |  270 +++
 Documentation/powerpc/mpc52xx.txt                  |   12 +-
 Documentation/powerpc/phyp-assisted-dump.txt       |  127 --
 MAINTAINERS                                        |    2 +-
 arch/powerpc/Kconfig                               |   18 +-
 arch/powerpc/Kconfig.debug                         |    7 -
 arch/powerpc/Makefile                              |    1 +
 arch/powerpc/boot/Makefile                         |   11 +-
 arch/powerpc/boot/dts/a4m072.dts                   |  168 ++
 arch/powerpc/boot/dts/bluestone.dts                |  127 ++-
 arch/powerpc/boot/dts/fsl/mpc8536si-post.dtsi      |    4 +-
 arch/powerpc/boot/dts/fsl/mpc8548si-post.dtsi      |   16 +
 arch/powerpc/boot/dts/fsl/mpc8548si-pre.dtsi       |    4 +-
 arch/powerpc/boot/dts/fsl/p1010si-post.dtsi        |    3 +
 arch/powerpc/boot/dts/fsl/p1020si-post.dtsi        |    6 +
 arch/powerpc/boot/dts/fsl/p1021si-post.dtsi        |    7 +
 arch/powerpc/boot/dts/fsl/p1022si-post.dtsi        |   12 +-
 arch/powerpc/boot/dts/fsl/p1023si-post.dtsi        |    3 +
 arch/powerpc/boot/dts/fsl/p2020si-post.dtsi        |    3 +
 arch/powerpc/boot/dts/fsl/p2041si-post.dtsi        |    2 +
 arch/powerpc/boot/dts/fsl/p3041si-post.dtsi        |    2 +
 arch/powerpc/boot/dts/fsl/p3060si-post.dtsi        |    6 +
 arch/powerpc/boot/dts/fsl/p5020si-post.dtsi        |    2 +
 arch/powerpc/boot/dts/fsl/pq3-etsec1-0.dtsi        |    3 +-
 arch/powerpc/boot/dts/fsl/pq3-etsec1-1.dtsi        |    3 +-
 arch/powerpc/boot/dts/fsl/pq3-etsec1-2.dtsi        |    3 +-
 arch/powerpc/boot/dts/fsl/pq3-etsec1-3.dtsi        |    3 +-
 arch/powerpc/boot/dts/fsl/pq3-mpic.dtsi            |    3 +
 arch/powerpc/boot/dts/fsl/pq3-sec4.4-0.dtsi        |   10 +-
 arch/powerpc/boot/dts/fsl/qoriq-mpic.dtsi          |    6 +-
 arch/powerpc/boot/dts/ge_imp3a.dts                 |  255 +++
 arch/powerpc/boot/dts/mpc836x_mds.dts              |    4 +
 arch/powerpc/boot/dts/mpc8536ds.dts                |    6 +-
 arch/powerpc/boot/dts/mpc8536ds.dtsi               |   93 ++
 arch/powerpc/boot/dts/mpc8536ds_36b.dts            |    8 +-
 arch/powerpc/boot/dts/mpc8548cds.dts               |  306 ----
 arch/powerpc/boot/dts/mpc8548cds.dtsi              |  306 ++++
 arch/powerpc/boot/dts/mpc8548cds_32b.dts           |   86 +
 arch/powerpc/boot/dts/mpc8548cds_36b.dts           |   86 +
 arch/powerpc/boot/dts/mpc8572ds.dtsi               |   50 +-
 arch/powerpc/boot/dts/p1010rdb.dtsi                |    4 +-
 arch/powerpc/boot/dts/p1020rdb-pc.dtsi             |  247 +++
 arch/powerpc/boot/dts/p1020rdb-pc_32b.dts          |   90 +
 arch/powerpc/boot/dts/p1020rdb-pc_36b.dts          |   90 +
 arch/powerpc/boot/dts/p1020rdb-pc_camp_core0.dts   |   64 +
 arch/powerpc/boot/dts/p1020rdb-pc_camp_core1.dts   |  142 ++
 arch/powerpc/boot/dts/p1021rdb.dts                 |   96 ++
 arch/powerpc/boot/dts/p1021rdb.dtsi                |  236 +++
 arch/powerpc/boot/dts/p1021rdb_36b.dts             |   96 ++
 arch/powerpc/boot/dts/p1022ds.dts                  |  274 ----
 arch/powerpc/boot/dts/p1022ds.dtsi                 |  234 +++
 arch/powerpc/boot/dts/p1022ds_32b.dts              |  103 ++
 arch/powerpc/boot/dts/p1022ds_36b.dts              |  103 ++
 arch/powerpc/boot/dts/p1025rdb.dtsi                |  286 ++++
 arch/powerpc/boot/dts/p1025rdb_32b.dts             |  135 ++
 arch/powerpc/boot/dts/p1025rdb_36b.dts             |   88 +
 arch/powerpc/boot/dts/p2020rdb-pc.dtsi             |  241 +++
 arch/powerpc/boot/dts/p2020rdb-pc_32b.dts          |   96 ++
 arch/powerpc/boot/dts/p2020rdb-pc_36b.dts          |   96 ++
 arch/powerpc/boot/dts/p2020rdb.dts                 |    4 +-
 arch/powerpc/boot/wrapper                          |   22 +-
 arch/powerpc/configs/85xx/ge_imp3a_defconfig       |  257 +++
 arch/powerpc/configs/86xx/gef_ppc9a_defconfig      |    1 +
 arch/powerpc/configs/86xx/gef_sbc310_defconfig     |    1 +
 arch/powerpc/configs/86xx/gef_sbc610_defconfig     |    2 +
 arch/powerpc/configs/iseries_defconfig             |  236 ---
 arch/powerpc/configs/mpc5200_defconfig             |   27 +-
 arch/powerpc/configs/mpc85xx_defconfig             |    1 +
 arch/powerpc/configs/mpc85xx_smp_defconfig         |    1 +
 arch/powerpc/include/asm/abs_addr.h                |   21 +-
 arch/powerpc/include/asm/atomic.h                  |   59 +-
 arch/powerpc/include/asm/cputable.h                |   12 +-
 arch/powerpc/include/asm/device.h                  |    3 +
 arch/powerpc/include/asm/dma.h                     |    4 -
 arch/powerpc/include/asm/eeh.h                     |  134 ++-
 arch/powerpc/include/asm/eeh_event.h               |   33 +-
 arch/powerpc/include/asm/exception-64s.h           |  113 +-
 arch/powerpc/include/asm/fadump.h                  |  218 +++
 arch/powerpc/include/asm/firmware.h                |    9 -
 arch/powerpc/include/asm/fsl_guts.h                |    6 +-
 arch/powerpc/include/asm/hw_irq.h                  |   63 +-
 arch/powerpc/include/asm/irqflags.h                |   37 +-
 arch/powerpc/include/asm/iseries/alpaca.h          |   31 -
 arch/powerpc/include/asm/iseries/hv_call.h         |  111 --
 arch/powerpc/include/asm/iseries/hv_call_event.h   |  201 ---
 arch/powerpc/include/asm/iseries/hv_call_sc.h      |   50 -
 arch/powerpc/include/asm/iseries/hv_call_xm.h      |   61 -
 arch/powerpc/include/asm/iseries/hv_lp_config.h    |  128 --
 arch/powerpc/include/asm/iseries/hv_lp_event.h     |  162 --
 arch/powerpc/include/asm/iseries/hv_types.h        |  112 --
 arch/powerpc/include/asm/iseries/iommu.h           |   37 -
 arch/powerpc/include/asm/iseries/it_lp_queue.h     |   78 -
 arch/powerpc/include/asm/iseries/lpar_map.h        |   85 -
 arch/powerpc/include/asm/iseries/mf.h              |   51 -
 arch/powerpc/include/asm/iseries/vio.h             |  265 ---
 arch/powerpc/include/asm/lppaca.h                  |    8 -
 arch/powerpc/include/asm/mpic.h                    |    9 +-
 arch/powerpc/include/asm/mpic_msgr.h               |  132 ++
 arch/powerpc/include/asm/paca.h                    |    2 +-
 arch/powerpc/include/asm/phyp_dump.h               |   47 -
 arch/powerpc/include/asm/ppc-pci.h                 |   89 +-
 arch/powerpc/include/asm/ppc_asm.h                 |    2 +
 arch/powerpc/include/asm/reg.h                     |   22 +-
 arch/powerpc/include/asm/reg_booke.h               |    1 +
 arch/powerpc/include/asm/spinlock.h                |    5 +-
 arch/powerpc/include/asm/system.h                  |   38 +
 arch/powerpc/include/asm/thread_info.h             |    9 +-
 arch/powerpc/include/asm/time.h                    |   15 -
 arch/powerpc/kernel/Makefile                       |   10 +-
 arch/powerpc/kernel/asm-offsets.c                  |   16 +-
 arch/powerpc/kernel/cputable.c                     |   20 +-
 arch/powerpc/kernel/dbell.c                        |    2 +
 arch/powerpc/kernel/entry_64.S                     |  250 ++--
 arch/powerpc/kernel/exceptions-64e.S               |  236 ++-
 arch/powerpc/kernel/exceptions-64s.S               |  314 +---
 arch/powerpc/kernel/fadump.c                       | 1315 +++++++++++++++
 arch/powerpc/kernel/head_32.S                      |    4 +-
 arch/powerpc/kernel/head_40x.S                     |    4 +-
 arch/powerpc/kernel/head_64.S                      |   62 +-
 arch/powerpc/kernel/head_8xx.S                     |    4 +-
 arch/powerpc/kernel/head_booke.h                   |    4 +-
 arch/powerpc/kernel/head_fsl_booke.S               |    2 +-
 arch/powerpc/kernel/idle.c                         |    6 +-
 arch/powerpc/kernel/idle_book3e.S                  |   25 +-
 arch/powerpc/kernel/idle_power4.S                  |   24 +-
 arch/powerpc/kernel/idle_power7.S                  |   23 +-
 arch/powerpc/kernel/iommu.c                        |    8 +-
 arch/powerpc/kernel/irq.c                          |  212 ++-
 arch/powerpc/kernel/isa-bridge.c                   |    3 -
 arch/powerpc/kernel/lparcfg.c                      |  108 +--
 arch/powerpc/kernel/misc.S                         |    1 -
 arch/powerpc/kernel/of_platform.c                  |    6 +-
 arch/powerpc/kernel/paca.c                         |   12 +-
 arch/powerpc/kernel/pci-common.c                   |   15 -
 arch/powerpc/kernel/process.c                      |   27 +-
 arch/powerpc/kernel/prom.c                         |   98 +-
 arch/powerpc/kernel/prom_init.c                    |   15 -
 arch/powerpc/kernel/rtas_pci.c                     |    3 +
 arch/powerpc/kernel/setup-common.c                 |   14 +
 arch/powerpc/kernel/signal.c                       |   13 +-
 arch/powerpc/kernel/signal_32.c                    |   11 +-
 arch/powerpc/kernel/sysfs.c                        |    7 +-
 arch/powerpc/kernel/time.c                         |  116 +--
 arch/powerpc/kernel/traps.c                        |    6 +
 arch/powerpc/kernel/vio.c                          |   18 +-
 arch/powerpc/kernel/vmlinux.lds.S                  |    5 -
 arch/powerpc/kvm/book3s_hv.c                       |    1 -
 arch/powerpc/lib/locks.c                           |   24 +-
 arch/powerpc/mm/fault.c                            |  181 ++-
 arch/powerpc/mm/fsl_booke_mmu.c                    |   19 +-
 arch/powerpc/mm/hash_utils_64.c                    |   20 +-
 arch/powerpc/mm/icswx.c                            |   23 +-
 arch/powerpc/mm/icswx.h                            |    6 +
 arch/powerpc/mm/pgtable_32.c                       |    2 +-
 arch/powerpc/mm/slb.c                              |    6 -
 arch/powerpc/mm/slb_low.S                          |   16 -
 arch/powerpc/mm/stab.c                             |    9 -
 arch/powerpc/oprofile/common.c                     |    3 -
 arch/powerpc/perf/Makefile                         |   14 +
 .../{kernel/perf_callchain.c => perf/callchain.c}  |    2 +-
 .../{kernel/perf_event.c => perf/core-book3s.c}    |    0
 .../perf_event_fsl_emb.c => perf/core-fsl-emb.c}   |    0
 arch/powerpc/{kernel => perf}/e500-pmu.c           |    0
 arch/powerpc/{kernel => perf}/mpc7450-pmu.c        |    0
 arch/powerpc/{kernel => perf}/power4-pmu.c         |    0
 arch/powerpc/{kernel => perf}/power5+-pmu.c        |    0
 arch/powerpc/{kernel => perf}/power5-pmu.c         |    0
 arch/powerpc/{kernel => perf}/power6-pmu.c         |    2 +-
 arch/powerpc/{kernel => perf}/power7-pmu.c         |    0
 arch/powerpc/{kernel => perf}/ppc970-pmu.c         |    2 +-
 arch/powerpc/platforms/44x/Kconfig                 |    1 +
 arch/powerpc/platforms/44x/currituck.c             |    2 +-
 arch/powerpc/platforms/44x/iss4xx.c                |    3 +-
 arch/powerpc/platforms/44x/ppc44x_simple.c         |    2 +-
 arch/powerpc/platforms/52xx/mpc5200_simple.c       |    1 +
 arch/powerpc/platforms/52xx/mpc52xx_common.c       |   10 +-
 arch/powerpc/platforms/85xx/Kconfig                |   27 +-
 arch/powerpc/platforms/85xx/Makefile               |    1 +
 arch/powerpc/platforms/85xx/corenet_ds.c           |    4 +-
 arch/powerpc/platforms/85xx/ge_imp3a.c             |  246 +++
 arch/powerpc/platforms/85xx/ksi8560.c              |    3 +-
 arch/powerpc/platforms/85xx/mpc8536_ds.c           |    4 +-
 arch/powerpc/platforms/85xx/mpc85xx_ads.c          |    3 +-
 arch/powerpc/platforms/85xx/mpc85xx_cds.c          |   84 +-
 arch/powerpc/platforms/85xx/mpc85xx_ds.c           |    6 +-
 arch/powerpc/platforms/85xx/mpc85xx_mds.c          |   40 +-
 arch/powerpc/platforms/85xx/mpc85xx_rdb.c          |  222 +++-
 arch/powerpc/platforms/85xx/p1010rdb.c             |    5 +-
 arch/powerpc/platforms/85xx/p1022_ds.c             |  207 +++-
 arch/powerpc/platforms/85xx/p1023_rds.c            |    5 +-
 arch/powerpc/platforms/85xx/sbc8548.c              |    3 +-
 arch/powerpc/platforms/85xx/sbc8560.c              |    3 +-
 arch/powerpc/platforms/85xx/socrates.c             |    3 +-
 arch/powerpc/platforms/85xx/stx_gp3.c              |    3 +-
 arch/powerpc/platforms/85xx/tqm85xx.c              |    2 +-
 arch/powerpc/platforms/85xx/xes_mpc85xx.c          |    4 +-
 arch/powerpc/platforms/86xx/Kconfig                |    3 +
 arch/powerpc/platforms/86xx/Makefile               |    7 +-
 arch/powerpc/platforms/86xx/gef_ppc9a.c            |    2 +-
 arch/powerpc/platforms/86xx/gef_sbc310.c           |    2 +-
 arch/powerpc/platforms/86xx/gef_sbc610.c           |    2 +-
 arch/powerpc/platforms/86xx/pic.c                  |    5 +-
 arch/powerpc/platforms/Kconfig                     |   11 +-
 arch/powerpc/platforms/Makefile                    |    1 -
 arch/powerpc/platforms/cell/setup.c                |    3 +-
 arch/powerpc/platforms/cell/spufs/inode.c          |    1 +
 arch/powerpc/platforms/cell/spufs/syscalls.c       |    2 -
 arch/powerpc/platforms/chrp/setup.c                |    3 +-
 arch/powerpc/platforms/embedded6xx/holly.c         |    6 +-
 arch/powerpc/platforms/embedded6xx/linkstation.c   |    3 +-
 arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c  |    6 +-
 arch/powerpc/platforms/embedded6xx/storcenter.c    |    3 +-
 arch/powerpc/platforms/iseries/Kconfig             |   38 -
 arch/powerpc/platforms/iseries/Makefile            |    9 -
 arch/powerpc/platforms/iseries/call_hpt.h          |  102 --
 arch/powerpc/platforms/iseries/call_pci.h          |  309 ----
 arch/powerpc/platforms/iseries/call_sm.h           |   37 -
 arch/powerpc/platforms/iseries/dt.c                |  643 --------
 arch/powerpc/platforms/iseries/exception.S         |  311 ----
 arch/powerpc/platforms/iseries/exception.h         |   58 -
 arch/powerpc/platforms/iseries/htab.c              |  257 ---
 arch/powerpc/platforms/iseries/hvcall.S            |   94 --
 arch/powerpc/platforms/iseries/hvlog.c             |   35 -
 arch/powerpc/platforms/iseries/hvlpconfig.c        |   39 -
 arch/powerpc/platforms/iseries/iommu.c             |  260 ---
 arch/powerpc/platforms/iseries/ipl_parms.h         |   68 -
 arch/powerpc/platforms/iseries/irq.c               |  400 -----
 arch/powerpc/platforms/iseries/irq.h               |   13 -
 arch/powerpc/platforms/iseries/it_exp_vpd_panel.h  |   51 -
 arch/powerpc/platforms/iseries/it_lp_naca.h        |   80 -
 arch/powerpc/platforms/iseries/ksyms.c             |   21 -
 arch/powerpc/platforms/iseries/lpardata.c          |  318 ----
 arch/powerpc/platforms/iseries/lpevents.c          |  341 ----
 arch/powerpc/platforms/iseries/main_store.h        |  165 --
 arch/powerpc/platforms/iseries/mf.c                | 1275 ---------------
 arch/powerpc/platforms/iseries/misc.S              |   26 -
 arch/powerpc/platforms/iseries/naca.h              |   24 -
 arch/powerpc/platforms/iseries/pci.c               |  919 -----------
 arch/powerpc/platforms/iseries/pci.h               |   58 -
 arch/powerpc/platforms/iseries/proc.c              |  120 --
 arch/powerpc/platforms/iseries/processor_vpd.h     |   85 -
 arch/powerpc/platforms/iseries/release_data.h      |   63 -
 arch/powerpc/platforms/iseries/setup.c             |  722 ---------
 arch/powerpc/platforms/iseries/setup.h             |   27 -
 arch/powerpc/platforms/iseries/smp.c               |   88 -
 arch/powerpc/platforms/iseries/spcomm_area.h       |   34 -
 arch/powerpc/platforms/iseries/vio.c               |  556 -------
 arch/powerpc/platforms/iseries/viopath.c           |  677 --------
 arch/powerpc/platforms/iseries/vpd_areas.h         |   88 -
 arch/powerpc/platforms/maple/setup.c               |    2 +-
 arch/powerpc/platforms/pasemi/setup.c              |    2 +-
 arch/powerpc/platforms/powermac/nvram.c            |   42 +-
 arch/powerpc/platforms/powermac/pic.c              |    1 -
 arch/powerpc/platforms/powernv/pci.c               |    1 +
 arch/powerpc/platforms/powernv/setup.c             |    1 -
 arch/powerpc/platforms/pseries/Kconfig             |    2 +-
 arch/powerpc/platforms/pseries/Makefile            |    4 +-
 arch/powerpc/platforms/pseries/eeh.c               | 1044 ++++++-------
 arch/powerpc/platforms/pseries/eeh_cache.c         |   44 +-
 arch/powerpc/platforms/pseries/eeh_dev.c           |  102 ++
 arch/powerpc/platforms/pseries/eeh_driver.c        |  213 ++--
 arch/powerpc/platforms/pseries/eeh_event.c         |   55 +-
 arch/powerpc/platforms/pseries/eeh_pseries.c       |  565 +++++++
 arch/powerpc/platforms/pseries/eeh_sysfs.c         |   25 +-
 arch/powerpc/platforms/pseries/lpar.c              |    1 +
 arch/powerpc/platforms/pseries/msi.c               |    2 +-
 arch/powerpc/platforms/pseries/pci_dlpar.c         |    3 +
 arch/powerpc/platforms/pseries/phyp_dump.c         |  513 ------
 arch/powerpc/platforms/pseries/processor_idle.c    |   18 +-
 arch/powerpc/platforms/pseries/setup.c             |   12 +-
 arch/powerpc/sysdev/Kconfig                        |    4 +
 arch/powerpc/sysdev/Makefile                       |    4 +
 arch/powerpc/sysdev/fsl_85xx_cache_sram.c          |    1 +
 arch/powerpc/sysdev/fsl_85xx_l2ctlr.c              |    4 +
 arch/powerpc/sysdev/fsl_msi.c                      |    1 +
 arch/powerpc/sysdev/fsl_rio.c                      |    4 +-
 arch/powerpc/sysdev/fsl_rmu.c                      |   42 +-
 arch/powerpc/sysdev/ge/Makefile                    |    1 +
 .../86xx/gef_pic.c => sysdev/ge/ge_pic.c}          |    2 +-
 .../86xx/gef_pic.h => sysdev/ge/ge_pic.h}          |    0
 arch/powerpc/sysdev/mpic.c                         |  107 +-
 arch/powerpc/sysdev/mpic_msgr.c                    |  282 ++++
 arch/powerpc/sysdev/mpic_msi.c                     |    4 +-
 arch/powerpc/sysdev/ppc4xx_pci.c                   |   70 +
 arch/powerpc/xmon/xmon.c                           |   33 +-
 drivers/base/driver.c                              |   30 -
 drivers/block/viodasd.c                            |  809 ---------
 drivers/cdrom/viocd.c                              |  739 ---------
 drivers/char/viotape.c                             | 1041 ------------
 drivers/gpio/Kconfig                               |   11 +
 drivers/gpio/Makefile                              |    1 +
 .../86xx/gef_gpio.c => drivers/gpio/gpio-ge.c      |   30 +-
 drivers/macintosh/mediabay.c                       |    2 +-
 drivers/misc/carma/carma-fpga.c                    |  114 +-
 drivers/mtd/nand/Kconfig                           |   10 +
 drivers/mtd/nand/Makefile                          |    1 +
 drivers/mtd/nand/fsl_ifc_nand.c                    | 1072 ++++++++++++
 drivers/net/ethernet/ibm/Kconfig                   |    4 -
 drivers/net/ethernet/ibm/Makefile                  |    1 -
 drivers/net/ethernet/ibm/iseries_veth.c            | 1710 --------------------
 drivers/scsi/Kconfig                               |    3 +-
 drivers/scsi/ibmvscsi/Makefile                     |    1 -
 drivers/scsi/ibmvscsi/ibmvscsi.c                   |   12 +-
 drivers/scsi/ibmvscsi/ibmvscsi.h                   |    1 -
 drivers/scsi/ibmvscsi/iseries_vscsi.c              |  173 --
 drivers/tty/hvc/Kconfig                            |   14 +-
 drivers/tty/hvc/Makefile                           |    1 -
 drivers/tty/hvc/hvc_iseries.c                      |  599 -------
 drivers/tty/hvc/hvc_udbg.c                         |    8 +-
 drivers/tty/hvc/hvc_vio.c                          |    4 -
 drivers/tty/serial/Kconfig                         |    2 +-
 drivers/watchdog/Kconfig                           |    2 +-
 fs/proc/vmcore.c                                   |   23 +
 include/linux/atomic.h                             |    2 +
 include/linux/device.h                             |    4 -
 include/linux/of.h                                 |   10 +
 include/linux/pci.h                                |    7 +
 init/do_mounts_rd.c                                |    4 +-
 321 files changed, 11235 insertions(+), 19006 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/powerpc/fsl/mpic-msgr.txt
 create mode 100644 Documentation/powerpc/firmware-assisted-dump.txt
 delete mode 100644 Documentation/powerpc/phyp-assisted-dump.txt
 create mode 100644 arch/powerpc/boot/dts/a4m072.dts
 create mode 100644 arch/powerpc/boot/dts/ge_imp3a.dts
 delete mode 100644 arch/powerpc/boot/dts/mpc8548cds.dts
 create mode 100644 arch/powerpc/boot/dts/mpc8548cds.dtsi
 create mode 100644 arch/powerpc/boot/dts/mpc8548cds_32b.dts
 create mode 100644 arch/powerpc/boot/dts/mpc8548cds_36b.dts
 create mode 100644 arch/powerpc/boot/dts/p1020rdb-pc.dtsi
 create mode 100644 arch/powerpc/boot/dts/p1020rdb-pc_32b.dts
 create mode 100644 arch/powerpc/boot/dts/p1020rdb-pc_36b.dts
 create mode 100644 arch/powerpc/boot/dts/p1020rdb-pc_camp_core0.dts
 create mode 100644 arch/powerpc/boot/dts/p1020rdb-pc_camp_core1.dts
 create mode 100644 arch/powerpc/boot/dts/p1021rdb.dts
 create mode 100644 arch/powerpc/boot/dts/p1021rdb.dtsi
 create mode 100644 arch/powerpc/boot/dts/p1021rdb_36b.dts
 delete mode 100644 arch/powerpc/boot/dts/p1022ds.dts
 create mode 100644 arch/powerpc/boot/dts/p1022ds.dtsi
 create mode 100644 arch/powerpc/boot/dts/p1022ds_32b.dts
 create mode 100644 arch/powerpc/boot/dts/p1022ds_36b.dts
 create mode 100644 arch/powerpc/boot/dts/p1025rdb.dtsi
 create mode 100644 arch/powerpc/boot/dts/p1025rdb_32b.dts
 create mode 100644 arch/powerpc/boot/dts/p1025rdb_36b.dts
 create mode 100644 arch/powerpc/boot/dts/p2020rdb-pc.dtsi
 create mode 100644 arch/powerpc/boot/dts/p2020rdb-pc_32b.dts
 create mode 100644 arch/powerpc/boot/dts/p2020rdb-pc_36b.dts
 create mode 100644 arch/powerpc/configs/85xx/ge_imp3a_defconfig
 delete mode 100644 arch/powerpc/configs/iseries_defconfig
 create mode 100644 arch/powerpc/include/asm/fadump.h
 delete mode 100644 arch/powerpc/include/asm/iseries/alpaca.h
 delete mode 100644 arch/powerpc/include/asm/iseries/hv_call.h
 delete mode 100644 arch/powerpc/include/asm/iseries/hv_call_event.h
 delete mode 100644 arch/powerpc/include/asm/iseries/hv_call_sc.h
 delete mode 100644 arch/powerpc/include/asm/iseries/hv_call_xm.h
 delete mode 100644 arch/powerpc/include/asm/iseries/hv_lp_config.h
 delete mode 100644 arch/powerpc/include/asm/iseries/hv_lp_event.h
 delete mode 100644 arch/powerpc/include/asm/iseries/hv_types.h
 delete mode 100644 arch/powerpc/include/asm/iseries/iommu.h
 delete mode 100644 arch/powerpc/include/asm/iseries/it_lp_queue.h
 delete mode 100644 arch/powerpc/include/asm/iseries/lpar_map.h
 delete mode 100644 arch/powerpc/include/asm/iseries/mf.h
 delete mode 100644 arch/powerpc/include/asm/iseries/vio.h
 create mode 100644 arch/powerpc/include/asm/mpic_msgr.h
 delete mode 100644 arch/powerpc/include/asm/phyp_dump.h
 create mode 100644 arch/powerpc/kernel/fadump.c
 create mode 100644 arch/powerpc/perf/Makefile
 rename arch/powerpc/{kernel/perf_callchain.c => perf/callchain.c} (99%)
 rename arch/powerpc/{kernel/perf_event.c => perf/core-book3s.c} (100%)
 rename arch/powerpc/{kernel/perf_event_fsl_emb.c => perf/core-fsl-emb.c} (100%)
 rename arch/powerpc/{kernel => perf}/e500-pmu.c (100%)
 rename arch/powerpc/{kernel => perf}/mpc7450-pmu.c (100%)
 rename arch/powerpc/{kernel => perf}/power4-pmu.c (100%)
 rename arch/powerpc/{kernel => perf}/power5+-pmu.c (100%)
 rename arch/powerpc/{kernel => perf}/power5-pmu.c (100%)
 rename arch/powerpc/{kernel => perf}/power6-pmu.c (99%)
 rename arch/powerpc/{kernel => perf}/power7-pmu.c (100%)
 rename arch/powerpc/{kernel => perf}/ppc970-pmu.c (99%)
 create mode 100644 arch/powerpc/platforms/85xx/ge_imp3a.c
 delete mode 100644 arch/powerpc/platforms/iseries/Kconfig
 delete mode 100644 arch/powerpc/platforms/iseries/Makefile
 delete mode 100644 arch/powerpc/platforms/iseries/call_hpt.h
 delete mode 100644 arch/powerpc/platforms/iseries/call_pci.h
 delete mode 100644 arch/powerpc/platforms/iseries/call_sm.h
 delete mode 100644 arch/powerpc/platforms/iseries/dt.c
 delete mode 100644 arch/powerpc/platforms/iseries/exception.S
 delete mode 100644 arch/powerpc/platforms/iseries/exception.h
 delete mode 100644 arch/powerpc/platforms/iseries/htab.c
 delete mode 100644 arch/powerpc/platforms/iseries/hvcall.S
 delete mode 100644 arch/powerpc/platforms/iseries/hvlog.c
 delete mode 100644 arch/powerpc/platforms/iseries/hvlpconfig.c
 delete mode 100644 arch/powerpc/platforms/iseries/iommu.c
 delete mode 100644 arch/powerpc/platforms/iseries/ipl_parms.h
 delete mode 100644 arch/powerpc/platforms/iseries/irq.c
 delete mode 100644 arch/powerpc/platforms/iseries/irq.h
 delete mode 100644 arch/powerpc/platforms/iseries/it_exp_vpd_panel.h
 delete mode 100644 arch/powerpc/platforms/iseries/it_lp_naca.h
 delete mode 100644 arch/powerpc/platforms/iseries/ksyms.c
 delete mode 100644 arch/powerpc/platforms/iseries/lpardata.c
 delete mode 100644 arch/powerpc/platforms/iseries/lpevents.c
 delete mode 100644 arch/powerpc/platforms/iseries/main_store.h
 delete mode 100644 arch/powerpc/platforms/iseries/mf.c
 delete mode 100644 arch/powerpc/platforms/iseries/misc.S
 delete mode 100644 arch/powerpc/platforms/iseries/naca.h
 delete mode 100644 arch/powerpc/platforms/iseries/pci.c
 delete mode 100644 arch/powerpc/platforms/iseries/pci.h
 delete mode 100644 arch/powerpc/platforms/iseries/proc.c
 delete mode 100644 arch/powerpc/platforms/iseries/processor_vpd.h
 delete mode 100644 arch/powerpc/platforms/iseries/release_data.h
 delete mode 100644 arch/powerpc/platforms/iseries/setup.c
 delete mode 100644 arch/powerpc/platforms/iseries/setup.h
 delete mode 100644 arch/powerpc/platforms/iseries/smp.c
 delete mode 100644 arch/powerpc/platforms/iseries/spcomm_area.h
 delete mode 100644 arch/powerpc/platforms/iseries/vio.c
 delete mode 100644 arch/powerpc/platforms/iseries/viopath.c
 delete mode 100644 arch/powerpc/platforms/iseries/vpd_areas.h
 create mode 100644 arch/powerpc/platforms/pseries/eeh_dev.c
 create mode 100644 arch/powerpc/platforms/pseries/eeh_pseries.c
 delete mode 100644 arch/powerpc/platforms/pseries/phyp_dump.c
 create mode 100644 arch/powerpc/sysdev/ge/Makefile
 rename arch/powerpc/{platforms/86xx/gef_pic.c => sysdev/ge/ge_pic.c} (99%)
 rename arch/powerpc/{platforms/86xx/gef_pic.h => sysdev/ge/ge_pic.h} (100%)
 create mode 100644 arch/powerpc/sysdev/mpic_msgr.c
 delete mode 100644 drivers/block/viodasd.c
 delete mode 100644 drivers/cdrom/viocd.c
 delete mode 100644 drivers/char/viotape.c
 rename arch/powerpc/platforms/86xx/gef_gpio.c => drivers/gpio/gpio-ge.c (83%)
 create mode 100644 drivers/mtd/nand/fsl_ifc_nand.c
 delete mode 100644 drivers/net/ethernet/ibm/iseries_veth.c
 delete mode 100644 drivers/scsi/ibmvscsi/iseries_vscsi.c
 delete mode 100644 drivers/tty/hvc/hvc_iseries.c



