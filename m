Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759961Ab2CGTqe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 14:46:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759950Ab2CGTqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 14:46:24 -0500
From: David Howells <dhowells@redhat.com>
Subject: [RFC][PATCH 00/29] Disintegrate and kill asm/system.h
To: paul.gortmaker@windriver.com, hpa@zytor.com
Cc: torvalds@linux-foundation.org, sfr@canb.auug.org.au, mingo@redhat.com,
        arnd@arndb.de, dhowells@redhat.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Date: Wed, 07 Mar 2012 19:45:50 +0000
Message-ID: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here are a bunch of patches to disintegrate asm/system.h into a set of separate
bits to relieve the problem of circular inclusion dependencies.

The reason for this is that I recently encountered a circular dependency
problem that came about when I produced some patches to optimise get_order() by
rewriting it to use ilog2().  This uses bitops - and on the SH arch
asm/bitops.h drags in asm-generic/get_order.h by a circuituous route involving
asm/system.h.

The main difficulty seems to be asm/system.h.  It holds a number of low level
bits with no/few dependencies that are commonly used (eg. memory barriers) and
a number of bits with more dependencies that aren't used in many places
(eg. switch_to()).

These patches break asm/system.h up into the following core pieces:

     (1) asm/barrier.h

         Move memory barriers here.  This already done for MIPS and Alpha.

     (2) asm/switch_to.h

         Move switch_to() and related stuff here.

     (3) asm/exec.h

         Move arch_align_stack() here.  Other process execution related bits
         could perhaps go here from asm/processor.h.

     (4) asm/atomic.h

         Move xchg() and cmpxchg() here as they're full word atomic ops and
         frequently used by atomic_xchg() and atomic_cmpxchg().

     (5) asm/bug.h

         Move die() and related bits.

     (6) asm/auxvec.h

         Move AT_VECTOR_SIZE_ARCH here.

Other arch headers are created as needed on a per-arch basis.

These patches are somewhat inside-out.  They start by removing all the
inclusions of asm/system.h and then patching up the core files to include the
right headers and then patching up each arch.  Whilst that's the easiest for
actually performing this task (as I can use the compiler to find breakages more
easily), it does mean that the patchset is not bisectable as all arches will be
broken for a greater or lesser span.

I'm not sure what's the best way to get around that.  Possibly by rearranging
things so each arch's asm/system.h is split up, leaving just a file with a
bunch of #includes - and then delete them all later.  That might not work,
however, as it may lead to circular deps until asm/system.h is no longer used.

It could also be done somewhat stepwise - for instance, all the barriers can be
extracted in one go.

Note: I don't have cross compilers for all arches, so for some of them I've
done the disintegration, but I haven't gone through and added the missing
#includes.

Further note: Some of the arches have lots of configurations (eg. ARM, MIPS).
I've compiled *some* of these configs, but by no means all.  It's likely some
of the uncompiled ones will break for lack of appropriate #inclusions.

David
---
David Howells (29):
      Disintegrate asm/system.h for Xtensa
      Disintegrate asm/system.h for X86
      Disintegrate asm/system.h for Unicore32
      Disintegrate asm/system.h for Tile
      Disintegrate asm/system.h for Sparc
      Disintegrate asm/system.h for SH
      Disintegrate asm/system.h for Score
      Disintegrate asm/system.h for S390
      Disintegrate asm/system.h for PowerPC
      Disintegrate asm/system.h for PA-RISC
      Disintegrate asm/system.h for OpenRISC
      Disintegrate asm/system.h for MN10300
      Disintegrate asm/system.h for MIPS
      Disintegrate asm/system.h for Microblaze
      Disintegrate asm/system.h for M68K
      Disintegrate asm/system.h for M32R
      Disintegrate asm/system.h for IA64
      Disintegrate asm/system.h for Hexagon
      Disintegrate asm/system.h for H8300
      Disintegrate asm/system.h for FRV
      Disintegrate asm/system.h for CRIS
      Disintegrate asm/system.h for C6X
      Disintegrate asm/system.h for Blackfin
      Disintegrate asm/system.h for AVR32
      Disintegrate asm/system.h for ARM
      Disintegrate asm/system.h on all arches
      Disintegrate asm/system.h on all arches
      Remove all #inclusions of asm/system.h
      Move all declarations of free_initmem() to linux/mm.h


 arch/alpha/boot/bootp.c                            |    1 
 arch/alpha/boot/bootpz.c                           |    1 
 arch/alpha/boot/head.S                             |    1 
 arch/alpha/boot/main.c                             |    1 
 arch/alpha/include/asm/atomic.h                    |   68 ++
 arch/alpha/include/asm/auxvec.h                    |    2 
 arch/alpha/include/asm/core_lca.h                  |    2 
 arch/alpha/include/asm/core_mcpcia.h               |    1 
 arch/alpha/include/asm/core_t2.h                   |    1 
 arch/alpha/include/asm/elf.h                       |    1 
 arch/alpha/include/asm/exec.h                      |    6 
 arch/alpha/include/asm/fpu.h                       |    2 
 arch/alpha/include/asm/io.h                        |    1 
 arch/alpha/include/asm/irqflags.h                  |    2 
 arch/alpha/include/asm/mce.h                       |   83 +++
 arch/alpha/include/asm/mmu_context.h               |    1 
 arch/alpha/include/asm/pal.h                       |  112 ++++
 arch/alpha/include/asm/pgtable.h                   |    1 
 arch/alpha/include/asm/setup.h                     |   36 +
 arch/alpha/include/asm/special_insns.h             |   41 +
 arch/alpha/include/asm/spinlock.h                  |    1 
 arch/alpha/include/asm/switch_to.h                 |   14 +
 arch/alpha/include/asm/system.h                    |  354 -------------
 arch/alpha/include/asm/xchg.h                      |    2 
 arch/alpha/kernel/core_apecs.c                     |    1 
 arch/alpha/kernel/core_cia.c                       |    1 
 arch/alpha/kernel/core_t2.c                        |    1 
 arch/alpha/kernel/err_impl.h                       |    2 
 arch/alpha/kernel/head.S                           |    6 
 arch/alpha/kernel/irq.c                            |    1 
 arch/alpha/kernel/irq_alpha.c                      |    1 
 arch/alpha/kernel/osf_sys.c                        |    1 
 arch/alpha/kernel/process.c                        |    1 
 arch/alpha/kernel/ptrace.c                         |    1 
 arch/alpha/kernel/setup.c                          |    1 
 arch/alpha/kernel/sys_alcor.c                      |    1 
 arch/alpha/kernel/sys_cabriolet.c                  |    1 
 arch/alpha/kernel/sys_dp264.c                      |    1 
 arch/alpha/kernel/sys_eb64p.c                      |    1 
 arch/alpha/kernel/sys_eiger.c                      |    1 
 arch/alpha/kernel/sys_jensen.c                     |    1 
 arch/alpha/kernel/sys_marvel.c                     |    1 
 arch/alpha/kernel/sys_miata.c                      |    1 
 arch/alpha/kernel/sys_mikasa.c                     |    2 
 arch/alpha/kernel/sys_nautilus.c                   |    1 
 arch/alpha/kernel/sys_noritake.c                   |    2 
 arch/alpha/kernel/sys_rawhide.c                    |    1 
 arch/alpha/kernel/sys_ruffian.c                    |    1 
 arch/alpha/kernel/sys_rx164.c                      |    1 
 arch/alpha/kernel/sys_sable.c                      |    1 
 arch/alpha/kernel/sys_sio.c                        |    1 
 arch/alpha/kernel/sys_sx164.c                      |    2 
 arch/alpha/kernel/sys_takara.c                     |    1 
 arch/alpha/kernel/sys_titan.c                      |    1 
 arch/alpha/kernel/sys_wildfire.c                   |    1 
 arch/alpha/kernel/traps.c                          |    1 
 arch/alpha/kernel/vmlinux.lds.S                    |    2 
 arch/alpha/lib/stacktrace.c                        |    1 
 arch/alpha/mm/fault.c                              |    1 
 arch/alpha/mm/init.c                               |    2 
 arch/alpha/oprofile/common.c                       |    1 
 arch/alpha/oprofile/op_model_ev4.c                 |    1 
 arch/alpha/oprofile/op_model_ev5.c                 |    1 
 arch/alpha/oprofile/op_model_ev6.c                 |    1 
 arch/alpha/oprofile/op_model_ev67.c                |    1 
 arch/arm/common/via82c505.c                        |    1 
 arch/arm/include/asm/atomic.h                      |  290 ++++++++++
 arch/arm/include/asm/barrier.h                     |   64 ++
 arch/arm/include/asm/bitops.h                      |    2 
 arch/arm/include/asm/bug.h                         |   30 +
 arch/arm/include/asm/compiler.h                    |   15 +
 arch/arm/include/asm/cr_reg.h                      |   85 +++
 arch/arm/include/asm/div64.h                       |    2 
 arch/arm/include/asm/dma.h                         |    1 
 arch/arm/include/asm/domain.h                      |    2 
 arch/arm/include/asm/exec.h                        |    6 
 arch/arm/include/asm/io.h                          |    1 
 arch/arm/include/asm/mmu.h                         |    7 
 arch/arm/include/asm/processor.h                   |    1 
 arch/arm/include/asm/switch_to.h                   |   16 +
 arch/arm/include/asm/system.h                      |  543 --------------------
 arch/arm/include/asm/system_info.h                 |   27 +
 arch/arm/include/asm/system_misc.h                 |   35 +
 arch/arm/include/asm/uaccess.h                     |    2 
 arch/arm/kernel/armksyms.c                         |    1 
 arch/arm/kernel/elf.c                              |    1 
 arch/arm/kernel/entry-armv.S                       |    1 
 arch/arm/kernel/fiq.c                              |    1 
 arch/arm/kernel/head-nommu.S                       |    1 
 arch/arm/kernel/head.S                             |    2 
 arch/arm/kernel/hw_breakpoint.c                    |    1 
 arch/arm/kernel/irq.c                              |    1 
 arch/arm/kernel/machine_kexec.c                    |    1 
 arch/arm/kernel/process.c                          |    1 
 arch/arm/kernel/ptrace.c                           |    1 
 arch/arm/kernel/setup.c                            |    4 
 arch/arm/kernel/sleep.S                            |    1 
 arch/arm/kernel/traps.c                            |    2 
 arch/arm/mach-clps711x/p720t-leds.c                |    1 
 arch/arm/mach-ebsa110/core.c                       |    1 
 arch/arm/mach-ebsa110/leds.c                       |    1 
 arch/arm/mach-footbridge/dc21285.c                 |    1 
 arch/arm/mach-footbridge/ebsa285-leds.c            |    1 
 arch/arm/mach-footbridge/netwinder-leds.c          |    1 
 arch/arm/mach-imx/dma-v1.c                         |    1 
 arch/arm/mach-integrator/core.c                    |    1 
 arch/arm/mach-integrator/leds.c                    |    1 
 arch/arm/mach-integrator/pci.c                     |    1 
 arch/arm/mach-integrator/pci_v3.c                  |    1 
 arch/arm/mach-iop33x/uart.c                        |    1 
 arch/arm/mach-ixp2000/core.c                       |    1 
 arch/arm/mach-ixp2000/enp2611.c                    |    1 
 arch/arm/mach-ixp2000/ixdp2400.c                   |    1 
 arch/arm/mach-ixp2000/ixdp2800.c                   |    1 
 arch/arm/mach-ixp2000/ixdp2x00.c                   |    1 
 arch/arm/mach-ixp2000/ixdp2x01.c                   |    1 
 arch/arm/mach-ixp2000/pci.c                        |    1 
 arch/arm/mach-ixp23xx/core.c                       |    1 
 arch/arm/mach-ixp23xx/espresso.c                   |    1 
 arch/arm/mach-ixp23xx/ixdp2351.c                   |    1 
 arch/arm/mach-ixp23xx/pci.c                        |    1 
 arch/arm/mach-ixp23xx/roadrunner.c                 |    1 
 arch/arm/mach-ixp4xx/common-pci.c                  |    1 
 arch/arm/mach-ixp4xx/goramo_mlr.c                  |    1 
 arch/arm/mach-msm/board-sapphire.c                 |    1 
 arch/arm/mach-mxs/system.c                         |    1 
 arch/arm/mach-omap1/leds-h2p2-debug.c              |    1 
 arch/arm/mach-omap1/leds-innovator.c               |    1 
 arch/arm/mach-omap1/leds-osk.c                     |    1 
 arch/arm/mach-omap1/mux.c                          |    1 
 arch/arm/mach-omap1/time.c                         |    1 
 arch/arm/mach-omap1/timer32k.c                     |    1 
 arch/arm/mach-omap2/mux.c                          |    1 
 arch/arm/mach-omap2/omap-mpuss-lowpower.c          |    1 
 arch/arm/mach-omap2/sleep44xx.S                    |    1 
 arch/arm/mach-orion5x/ls-chl-setup.c               |    1 
 arch/arm/mach-orion5x/ls_hgl-setup.c               |    1 
 arch/arm/mach-orion5x/lsmini-setup.c               |    1 
 arch/arm/mach-pnx4008/core.c                       |    1 
 arch/arm/mach-pnx4008/dma.c                        |    1 
 arch/arm/mach-pnx4008/irq.c                        |    1 
 arch/arm/mach-pnx4008/time.c                       |    1 
 arch/arm/mach-pxa/corgi.c                          |    1 
 arch/arm/mach-pxa/generic.c                        |    1 
 arch/arm/mach-pxa/leds-idp.c                       |    1 
 arch/arm/mach-pxa/leds-lubbock.c                   |    1 
 arch/arm/mach-pxa/leds-mainstone.c                 |    1 
 arch/arm/mach-pxa/poodle.c                         |    1 
 arch/arm/mach-realview/core.c                      |    1 
 arch/arm/mach-sa1100/dma.c                         |    1 
 arch/arm/mach-sa1100/generic.c                     |    1 
 arch/arm/mach-sa1100/leds-assabet.c                |    1 
 arch/arm/mach-sa1100/leds-badge4.c                 |    1 
 arch/arm/mach-sa1100/leds-cerf.c                   |    1 
 arch/arm/mach-sa1100/leds-hackkit.c                |    1 
 arch/arm/mach-sa1100/leds-lart.c                   |    1 
 arch/arm/mach-sa1100/pm.c                          |    1 
 arch/arm/mach-shark/leds.c                         |    1 
 arch/arm/mach-shmobile/cpuidle.c                   |    1 
 arch/arm/mach-shmobile/pm-r8a7779.c                |    1 
 arch/arm/mach-shmobile/pm-sh7372.c                 |    1 
 arch/arm/mach-shmobile/suspend.c                   |    1 
 arch/arm/mach-tegra/cpu-tegra.c                    |    1 
 arch/arm/mach-versatile/core.c                     |    1 
 arch/arm/mach-versatile/pci.c                      |    1 
 arch/arm/mach-vexpress/hotplug.c                   |    1 
 arch/arm/mm/alignment.c                            |    3 
 arch/arm/mm/cache-xsc3l2.c                         |    1 
 arch/arm/mm/fault.c                                |    3 
 arch/arm/mm/flush.c                                |    1 
 arch/arm/mm/idmap.c                                |    1 
 arch/arm/mm/ioremap.c                              |    2 
 arch/arm/mm/mmu.c                                  |    2 
 arch/arm/mm/pgd.c                                  |    1 
 arch/arm/mm/proc-fa526.S                           |    1 
 arch/arm/nwfpe/fpa11.c                             |    1 
 arch/arm/plat-iop/i2c.c                            |    1 
 arch/arm/plat-iop/pci.c                            |    1 
 arch/arm/plat-mxc/system.c                         |    1 
 arch/arm/plat-omap/debug-leds.c                    |    1 
 arch/arm/plat-omap/dma.c                           |    1 
 arch/arm/plat-omap/mux.c                           |    1 
 arch/arm/plat-pxa/dma.c                            |    1 
 arch/arm/plat-s3c24xx/dma.c                        |    1 
 arch/arm/plat-samsung/cpu.c                        |    1 
 arch/arm/plat-samsung/time.c                       |    1 
 arch/arm/vfp/vfpmodule.c                           |    2 
 arch/avr32/include/asm/atomic.h                    |  102 ++++
 arch/avr32/include/asm/barrier.h                   |   27 +
 arch/avr32/include/asm/bitops.h                    |    1 
 arch/avr32/include/asm/bug.h                       |    5 
 arch/avr32/include/asm/exec.h                      |   13 
 arch/avr32/include/asm/special_insns.h             |   13 
 arch/avr32/include/asm/switch_to.h                 |   46 ++
 arch/avr32/include/asm/system.h                    |  178 ------
 arch/avr32/mach-at32ap/cpufreq.c                   |    1 
 arch/avr32/oprofile/op_model_avr32.c               |    1 
 arch/blackfin/include/asm/atomic.h                 |  122 ++++
 arch/blackfin/include/asm/barrier.h                |   46 ++
 arch/blackfin/include/asm/exec.h                   |    1 
 arch/blackfin/include/asm/irq_handler.h            |    1 
 arch/blackfin/include/asm/special_insns.h          |   13 
 arch/blackfin/include/asm/switch_to.h              |   39 +
 arch/blackfin/include/asm/system.h                 |  192 -------
 arch/blackfin/kernel/asm-offsets.c                 |    1 
 arch/blackfin/kernel/ipipe.c                       |    1 
 arch/blackfin/kernel/kgdb_test.c                   |    1 
 arch/blackfin/kernel/process.c                     |    1 
 arch/blackfin/kernel/ptrace.c                      |    1 
 arch/blackfin/kernel/reboot.c                      |    1 
 arch/blackfin/kernel/setup.c                       |    1 
 arch/blackfin/kernel/trace.c                       |    1 
 arch/blackfin/kernel/traps.c                       |    1 
 arch/c6x/include/asm/atomic.h                      |   68 ++
 arch/c6x/include/asm/barrier.h                     |   25 +
 arch/c6x/include/asm/bitops.h                      |    1 
 arch/c6x/include/asm/bug.h                         |   19 +
 arch/c6x/include/asm/processor.h                   |    9 
 arch/c6x/include/asm/setup.h                       |    1 
 arch/c6x/include/asm/special_insns.h               |   64 ++
 arch/c6x/include/asm/switch_to.h                   |   31 +
 arch/c6x/include/asm/system.h                      |  168 ------
 arch/c6x/kernel/soc.c                              |    1 
 arch/cris/arch-v10/drivers/ds1302.c                |    1 
 arch/cris/arch-v10/drivers/gpio.c                  |    1 
 arch/cris/arch-v10/drivers/i2c.c                   |    1 
 arch/cris/arch-v10/drivers/pcf8563.c               |    1 
 arch/cris/arch-v10/drivers/sync_serial.c           |    1 
 arch/cris/arch-v10/kernel/debugport.c              |    1 
 arch/cris/arch-v10/kernel/dma.c                    |    1 
 arch/cris/arch-v10/kernel/io_interface_mux.c       |    1 
 arch/cris/arch-v10/kernel/process.c                |    1 
 arch/cris/arch-v10/kernel/ptrace.c                 |    1 
 arch/cris/arch-v10/kernel/setup.c                  |    1 
 arch/cris/arch-v10/kernel/signal.c                 |    1 
 arch/cris/arch-v10/kernel/traps.c                  |    1 
 arch/cris/arch-v32/drivers/i2c.c                   |    1 
 arch/cris/arch-v32/drivers/mach-a3/gpio.c          |    1 
 arch/cris/arch-v32/drivers/mach-fs/gpio.c          |    1 
 arch/cris/arch-v32/kernel/debugport.c              |    1 
 arch/cris/arch-v32/kernel/fasttimer.c              |    1 
 arch/cris/arch-v32/kernel/ptrace.c                 |    1 
 arch/cris/arch-v32/mach-a3/dma.c                   |    1 
 arch/cris/arch-v32/mach-fs/dma.c                   |    1 
 arch/cris/include/arch-v10/arch/elf.h              |    2 
 arch/cris/include/arch-v32/arch/elf.h              |    2 
 arch/cris/include/asm/atomic.h                     |   47 ++
 arch/cris/include/asm/barrier.h                    |   23 +
 arch/cris/include/asm/bitops.h                     |    1 
 arch/cris/include/asm/exec.h                       |    6 
 arch/cris/include/asm/processor.h                  |   11 
 arch/cris/include/asm/switch_to.h                  |   12 
 arch/cris/include/asm/system.h                     |   89 ---
 arch/cris/kernel/irq.c                             |    1 
 arch/cris/kernel/process.c                         |    1 
 arch/cris/kernel/ptrace.c                          |    1 
 arch/cris/kernel/setup.c                           |    1 
 arch/cris/kernel/traps.c                           |    1 
 arch/cris/mm/fault.c                               |    1 
 arch/frv/include/asm/atomic.h                      |   99 ++++
 arch/frv/include/asm/barrier.h                     |   27 +
 arch/frv/include/asm/bug.h                         |    2 
 arch/frv/include/asm/exec.h                        |   17 +
 arch/frv/include/asm/special_insns.h               |   17 +
 arch/frv/include/asm/switch_to.h                   |   35 +
 arch/frv/include/asm/system.h                      |  158 ------
 arch/frv/kernel/debug-stub.c                       |    1 
 arch/frv/kernel/gdb-io.c                           |    1 
 arch/frv/kernel/gdb-stub.c                         |    1 
 arch/frv/kernel/irq-mb93091.c                      |    1 
 arch/frv/kernel/irq-mb93093.c                      |    1 
 arch/frv/kernel/irq-mb93493.c                      |    1 
 arch/frv/kernel/irq.c                              |    1 
 arch/frv/kernel/process.c                          |    1 
 arch/frv/kernel/ptrace.c                           |    1 
 arch/frv/kernel/traps.c                            |    1 
 arch/frv/mm/fault.c                                |    1 
 arch/frv/mm/init.c                                 |    1 
 arch/frv/mm/kmap.c                                 |    1 
 arch/h8300/include/asm/atomic.h                    |   54 ++
 arch/h8300/include/asm/barrier.h                   |   26 +
 arch/h8300/include/asm/bitops.h                    |    1 
 arch/h8300/include/asm/bug.h                       |    4 
 arch/h8300/include/asm/exec.h                      |    6 
 arch/h8300/include/asm/processor.h                 |    5 
 arch/h8300/include/asm/switch_to.h                 |   50 ++
 arch/h8300/include/asm/system.h                    |  140 -----
 arch/h8300/kernel/irq.c                            |    1 
 arch/h8300/kernel/process.c                        |    1 
 arch/h8300/kernel/ptrace.c                         |    1 
 arch/h8300/kernel/traps.c                          |    1 
 arch/h8300/mm/fault.c                              |    1 
 arch/h8300/mm/init.c                               |    1 
 arch/h8300/mm/kmap.c                               |    1 
 arch/h8300/mm/memory.c                             |    1 
 arch/hexagon/include/asm/atomic.h                  |   79 +++
 arch/hexagon/include/asm/barrier.h                 |   41 +
 arch/hexagon/include/asm/bitops.h                  |    1 
 arch/hexagon/include/asm/exec.h                    |   28 +
 arch/hexagon/include/asm/switch_to.h               |   34 +
 arch/hexagon/include/asm/system.h                  |  126 -----
 arch/hexagon/kernel/ptrace.c                       |    1 
 arch/hexagon/kernel/vm_events.c                    |    1 
 arch/ia64/dig/setup.c                              |    1 
 arch/ia64/hp/sim/boot/bootloader.c                 |    1 
 arch/ia64/hp/sim/simeth.c                          |    1 
 arch/ia64/include/asm/acpi.h                       |    1 
 arch/ia64/include/asm/atomic.h                     |    1 
 arch/ia64/include/asm/auxvec.h                     |    2 
 arch/ia64/include/asm/barrier.h                    |   68 ++
 arch/ia64/include/asm/exec.h                       |   14 +
 arch/ia64/include/asm/futex.h                      |    1 
 arch/ia64/include/asm/io.h                         |    1 
 arch/ia64/include/asm/pci.h                        |    8 
 arch/ia64/include/asm/pgtable.h                    |    1 
 arch/ia64/include/asm/processor.h                  |    8 
 arch/ia64/include/asm/sal.h                        |    1 
 arch/ia64/include/asm/setup.h                      |   28 +
 arch/ia64/include/asm/sn/pda.h                     |    1 
 arch/ia64/include/asm/spinlock.h                   |    1 
 arch/ia64/include/asm/switch_to.h                  |   87 +++
 arch/ia64/include/asm/system.h                     |  203 -------
 arch/ia64/include/asm/uv/uv.h                      |    1 
 arch/ia64/kernel/acpi.c                            |    1 
 arch/ia64/kernel/fsys.S                            |    1 
 arch/ia64/kernel/gate.S                            |    1 
 arch/ia64/kernel/gate.lds.S                        |    1 
 arch/ia64/kernel/head.S                            |    1 
 arch/ia64/kernel/iosapic.c                         |    1 
 arch/ia64/kernel/irq_ia64.c                        |    1 
 arch/ia64/kernel/ivt.S                             |    1 
 arch/ia64/kernel/machvec.c                         |    1 
 arch/ia64/kernel/mca.c                             |    1 
 arch/ia64/kernel/mca_drv.c                         |    1 
 arch/ia64/kernel/patch.c                           |    1 
 arch/ia64/kernel/pci-dma.c                         |    1 
 arch/ia64/kernel/perfmon.c                         |    1 
 arch/ia64/kernel/ptrace.c                          |    1 
 arch/ia64/kernel/setup.c                           |    1 
 arch/ia64/kernel/smp.c                             |    1 
 arch/ia64/kernel/smpboot.c                         |    1 
 arch/ia64/kernel/time.c                            |    1 
 arch/ia64/kernel/uncached.c                        |    1 
 arch/ia64/kernel/unwind.c                          |    1 
 arch/ia64/kernel/vmlinux.lds.S                     |    1 
 arch/ia64/mm/fault.c                               |    1 
 arch/ia64/mm/init.c                                |    1 
 arch/ia64/oprofile/backtrace.c                     |    1 
 arch/ia64/pci/pci.c                                |    1 
 arch/ia64/sn/kernel/setup.c                        |    1 
 arch/ia64/sn/kernel/sn2/prominfo_proc.c            |    1 
 arch/ia64/sn/kernel/sn2/sn2_smp.c                  |    1 
 arch/ia64/sn/kernel/sn2/timer.c                    |    1 
 arch/ia64/sn/kernel/tiocx.c                        |    1 
 arch/ia64/xen/xensetup.S                           |    1 
 arch/m32r/include/asm/atomic.h                     |  210 ++++++++
 arch/m32r/include/asm/barrier.h                    |   92 +++
 arch/m32r/include/asm/bitops.h                     |    3 
 arch/m32r/include/asm/dcache_clear.h               |   29 +
 arch/m32r/include/asm/exec.h                       |   14 +
 arch/m32r/include/asm/local.h                      |    1 
 arch/m32r/include/asm/spinlock.h                   |    1 
 arch/m32r/include/asm/switch_to.h                  |   51 ++
 arch/m32r/include/asm/system.h                     |  367 -------------
 arch/m32r/kernel/ptrace.c                          |    1 
 arch/m32r/kernel/traps.c                           |    1 
 arch/m32r/mm/fault-nommu.c                         |    1 
 arch/m32r/mm/fault.c                               |    1 
 arch/m32r/platforms/m32104ut/setup.c               |    1 
 arch/m32r/platforms/m32700ut/setup.c               |    1 
 arch/m32r/platforms/mappi/setup.c                  |    1 
 arch/m32r/platforms/mappi2/setup.c                 |    1 
 arch/m32r/platforms/mappi3/setup.c                 |    1 
 arch/m32r/platforms/oaks32r/setup.c                |    1 
 arch/m32r/platforms/opsput/setup.c                 |    1 
 arch/m32r/platforms/usrv/setup.c                   |    1 
 arch/m68k/amiga/amisound.c                         |    1 
 arch/m68k/amiga/config.c                           |    1 
 arch/m68k/apollo/config.c                          |    1 
 arch/m68k/atari/ataints.c                          |    1 
 arch/m68k/atari/atasound.c                         |    1 
 arch/m68k/atari/config.c                           |    1 
 arch/m68k/bvme6000/config.c                        |    1 
 arch/m68k/bvme6000/rtc.c                           |    1 
 arch/m68k/hp300/time.c                             |    1 
 arch/m68k/include/asm/atomic.h                     |  125 ++++-
 arch/m68k/include/asm/barrier.h                    |   20 +
 arch/m68k/include/asm/exec.h                       |    6 
 arch/m68k/include/asm/sun3xflop.h                  |    1 
 arch/m68k/include/asm/switch_to.h                  |   41 +
 arch/m68k/include/asm/system.h                     |  193 -------
 arch/m68k/kernel/ints.c                            |    1 
 arch/m68k/kernel/irq.c                             |    1 
 arch/m68k/kernel/process_mm.c                      |    1 
 arch/m68k/kernel/process_no.c                      |    1 
 arch/m68k/kernel/ptrace_mm.c                       |    1 
 arch/m68k/kernel/ptrace_no.c                       |    1 
 arch/m68k/kernel/traps.c                           |    1 
 arch/m68k/kernel/vectors.c                         |    1 
 arch/m68k/mac/config.c                             |    1 
 arch/m68k/mac/misc.c                               |    1 
 arch/m68k/mm/fault.c                               |    1 
 arch/m68k/mm/init_mm.c                             |    1 
 arch/m68k/mm/init_no.c                             |    1 
 arch/m68k/mm/kmap.c                                |    1 
 arch/m68k/mm/memory.c                              |    1 
 arch/m68k/mm/motorola.c                            |    1 
 arch/m68k/mm/sun3mmu.c                             |    1 
 arch/m68k/mvme147/config.c                         |    1 
 arch/m68k/mvme16x/config.c                         |    1 
 arch/m68k/mvme16x/rtc.c                            |    1 
 arch/m68k/platform/68328/config.c                  |    1 
 arch/m68k/platform/68328/timers.c                  |    1 
 arch/m68k/platform/68360/config.c                  |    1 
 arch/m68k/platform/68EZ328/config.c                |    1 
 arch/m68k/platform/68VZ328/config.c                |    1 
 arch/m68k/q40/config.c                             |    1 
 arch/m68k/q40/q40ints.c                            |    1 
 arch/m68k/sun3/intersil.c                          |    1 
 arch/m68k/sun3/mmu_emu.c                           |    1 
 arch/m68k/sun3/prom/console.c                      |    1 
 arch/m68k/sun3x/config.c                           |    1 
 arch/m68k/sun3x/time.c                             |    1 
 arch/microblaze/include/asm/atomic.h               |   36 +
 arch/microblaze/include/asm/barrier.h              |   26 +
 arch/microblaze/include/asm/exec.h                 |   14 +
 arch/microblaze/include/asm/processor.h            |   11 
 arch/microblaze/include/asm/setup.h                |    6 
 arch/microblaze/include/asm/switch_to.h            |   24 +
 arch/microblaze/include/asm/system.h               |   97 ----
 arch/microblaze/kernel/cpu/pvr.c                   |    1 
 arch/microblaze/kernel/microblaze_ksyms.c          |    1 
 arch/microblaze/kernel/process.c                   |    1 
 arch/microblaze/kernel/prom.c                      |    1 
 arch/microblaze/kernel/setup.c                     |    1 
 arch/microblaze/kernel/timer.c                     |    1 
 arch/microblaze/kernel/traps.c                     |    1 
 arch/microblaze/lib/memcpy.c                       |    1 
 arch/microblaze/mm/fault.c                         |    1 
 arch/mips/cavium-octeon/setup.c                    |    1 
 arch/mips/cavium-octeon/smp.c                      |    1 
 arch/mips/dec/ecc-berr.c                           |    1 
 arch/mips/dec/kn01-berr.c                          |    1 
 arch/mips/dec/kn02xa-berr.c                        |    1 
 arch/mips/dec/wbflush.c                            |    1 
 arch/mips/emma/markeins/irq.c                      |    1 
 arch/mips/fw/arc/misc.c                            |    1 
 arch/mips/include/asm/atomic.h                     |  125 ++++-
 arch/mips/include/asm/dma.h                        |    1 
 arch/mips/include/asm/exec.h                       |   17 +
 arch/mips/include/asm/mach-au1x00/au1000_dma.h     |    1 
 arch/mips/include/asm/processor.h                  |    7 
 arch/mips/include/asm/setup.h                      |   11 
 arch/mips/include/asm/switch_to.h                  |   85 +++
 arch/mips/include/asm/system.h                     |  235 --------
 arch/mips/include/asm/txx9/jmr3927.h               |    1 
 arch/mips/kernel/cpu-bugs64.c                      |    1 
 arch/mips/kernel/cpu-probe.c                       |    1 
 arch/mips/kernel/irq-rm7000.c                      |    1 
 arch/mips/kernel/irq-rm9000.c                      |    1 
 arch/mips/kernel/irq.c                             |    1 
 arch/mips/kernel/irq_cpu.c                         |    1 
 arch/mips/kernel/mips-mt.c                         |    1 
 arch/mips/kernel/process.c                         |    1 
 arch/mips/kernel/ptrace.c                          |    1 
 arch/mips/kernel/ptrace32.c                        |    1 
 arch/mips/kernel/rtlx.c                            |    1 
 arch/mips/kernel/setup.c                           |    1 
 arch/mips/kernel/signal.c                          |    1 
 arch/mips/kernel/signal32.c                        |    1 
 arch/mips/kernel/signal_n32.c                      |    1 
 arch/mips/kernel/smp-bmips.c                       |    1 
 arch/mips/kernel/smp-cmp.c                         |    1 
 arch/mips/kernel/smp-mt.c                          |    1 
 arch/mips/kernel/smp.c                             |    1 
 arch/mips/kernel/smtc-proc.c                       |    1 
 arch/mips/kernel/smtc.c                            |    1 
 arch/mips/kernel/spram.c                           |    1 
 arch/mips/kernel/syscall.c                         |    1 
 arch/mips/kernel/traps.c                           |    1 
 arch/mips/kernel/unaligned.c                       |    1 
 arch/mips/kernel/vpe.c                             |    1 
 arch/mips/lasat/reset.c                            |    1 
 arch/mips/math-emu/dsemul.c                        |    1 
 arch/mips/mipssim/sim_smtc.c                       |    1 
 arch/mips/mm/c-octeon.c                            |    1 
 arch/mips/mm/c-r3k.c                               |    1 
 arch/mips/mm/c-r4k.c                               |    1 
 arch/mips/mm/c-tx39.c                              |    1 
 arch/mips/mm/fault.c                               |    1 
 arch/mips/mm/page.c                                |    1 
 arch/mips/mm/sc-ip22.c                             |    1 
 arch/mips/mm/sc-mips.c                             |    1 
 arch/mips/mm/sc-r5k.c                              |    1 
 arch/mips/mm/tlb-r3k.c                             |    1 
 arch/mips/mm/tlb-r4k.c                             |    1 
 arch/mips/mm/tlb-r8k.c                             |    1 
 arch/mips/mm/tlbex.c                               |    1 
 arch/mips/mti-malta/malta-init.c                   |    1 
 arch/mips/netlogic/common/irq.c                    |    1 
 arch/mips/pmc-sierra/msp71xx/msp_irq_cic.c         |    1 
 arch/mips/pmc-sierra/msp71xx/msp_irq_per.c         |    1 
 arch/mips/pmc-sierra/msp71xx/msp_irq_slp.c         |    1 
 arch/mips/pmc-sierra/yosemite/irq.c                |    1 
 arch/mips/pmc-sierra/yosemite/prom.c               |    1 
 arch/mips/powertv/asic/irq_asic.c                  |    1 
 arch/mips/powertv/init.c                           |    1 
 arch/mips/rb532/irq.c                              |    1 
 arch/mips/sgi-ip22/ip22-berr.c                     |    1 
 arch/mips/sgi-ip22/ip22-reset.c                    |    1 
 arch/mips/sgi-ip22/ip28-berr.c                     |    1 
 arch/mips/sgi-ip27/ip27-irq.c                      |    1 
 arch/mips/sgi-ip27/ip27-reset.c                    |    1 
 arch/mips/sgi-ip32/ip32-irq.c                      |    1 
 arch/mips/sgi-ip32/ip32-reset.c                    |    1 
 arch/mips/sibyte/bcm1480/irq.c                     |    1 
 arch/mips/sibyte/common/sb_tbprof.c                |    1 
 arch/mips/sibyte/sb1250/bus_watcher.c              |    1 
 arch/mips/sibyte/sb1250/irq.c                      |    1 
 arch/mips/sni/reset.c                              |    1 
 arch/mips/vr41xx/common/irq.c                      |    1 
 arch/mips/vr41xx/common/pmu.c                      |    1 
 arch/mn10300/include/asm/barrier.h                 |   35 +
 arch/mn10300/include/asm/dma.h                     |    1 
 arch/mn10300/include/asm/exec.h                    |   16 +
 arch/mn10300/include/asm/switch_to.h               |   49 ++
 arch/mn10300/include/asm/system.h                  |  102 ----
 arch/mn10300/kernel/entry.S                        |    1 
 arch/mn10300/kernel/fpu.c                          |    1 
 arch/mn10300/kernel/gdb-io-serial.c                |    1 
 arch/mn10300/kernel/gdb-io-ttysm.c                 |    1 
 arch/mn10300/kernel/gdb-stub.c                     |    1 
 arch/mn10300/kernel/mn10300-serial.c               |    1 
 arch/mn10300/kernel/mn10300-watchdog.c             |    1 
 arch/mn10300/kernel/process.c                      |    1 
 arch/mn10300/kernel/ptrace.c                       |    1 
 arch/mn10300/kernel/setup.c                        |    1 
 arch/mn10300/kernel/smp-low.S                      |    2 
 arch/mn10300/kernel/smp.c                          |    1 
 arch/mn10300/kernel/traps.c                        |    1 
 arch/mn10300/lib/bitops.c                          |    1 
 arch/mn10300/mm/fault.c                            |    1 
 arch/mn10300/mm/init.c                             |    1 
 arch/mn10300/mm/misalignment.c                     |    1 
 arch/mn10300/mm/pgtable.c                          |    1 
 arch/mn10300/mm/tlb-smp.c                          |    1 
 arch/mn10300/proc-mn2ws0050/proc-init.c            |    1 
 arch/openrisc/include/asm/system.h                 |   35 -
 arch/openrisc/kernel/idle.c                        |    1 
 arch/openrisc/kernel/process.c                     |    1 
 arch/openrisc/kernel/prom.c                        |    1 
 arch/openrisc/kernel/ptrace.c                      |    1 
 arch/openrisc/kernel/setup.c                       |    1 
 arch/openrisc/kernel/traps.c                       |    1 
 arch/openrisc/mm/init.c                            |    1 
 arch/openrisc/mm/tlb.c                             |    1 
 arch/parisc/include/asm/atomic.h                   |    1 
 arch/parisc/include/asm/barrier.h                  |   35 +
 arch/parisc/include/asm/delay.h                    |    2 
 arch/parisc/include/asm/dma.h                      |    1 
 arch/parisc/include/asm/exec.h                     |    6 
 arch/parisc/include/asm/ldcw.h                     |   48 ++
 arch/parisc/include/asm/processor.h                |    2 
 arch/parisc/include/asm/psw.h                      |   41 +
 arch/parisc/include/asm/special_insns.h            |   40 +
 arch/parisc/include/asm/spinlock.h                 |    1 
 arch/parisc/include/asm/switch_to.h                |   12 
 arch/parisc/include/asm/system.h                   |  165 ------
 arch/parisc/include/asm/thread_info.h              |    1 
 arch/parisc/include/asm/timex.h                    |    1 
 arch/parisc/include/asm/uaccess.h                  |    1 
 arch/parisc/kernel/cache.c                         |    1 
 arch/parisc/kernel/firmware.c                      |    1 
 arch/parisc/kernel/pci.c                           |    1 
 arch/parisc/kernel/ptrace.c                        |    1 
 arch/parisc/kernel/smp.c                           |    1 
 arch/parisc/kernel/traps.c                         |    1 
 arch/parisc/lib/bitops.c                           |    1 
 arch/powerpc/include/asm/atomic.h                  |  300 +++++++++++
 arch/powerpc/include/asm/auxvec.h                  |    2 
 arch/powerpc/include/asm/barrier.h                 |   68 ++
 arch/powerpc/include/asm/bug.h                     |   11 
 arch/powerpc/include/asm/cache.h                   |   16 +
 arch/powerpc/include/asm/debug.h                   |   56 ++
 arch/powerpc/include/asm/dma.h                     |    1 
 arch/powerpc/include/asm/exec.h                    |    9 
 arch/powerpc/include/asm/hw_breakpoint.h           |    2 
 arch/powerpc/include/asm/irq.h                     |    1 
 arch/powerpc/include/asm/processor.h               |   30 +
 arch/powerpc/include/asm/reg_booke.h               |    5 
 arch/powerpc/include/asm/rtas.h                    |    2 
 arch/powerpc/include/asm/setup.h                   |   24 +
 arch/powerpc/include/asm/switch_to.h               |   65 ++
 arch/powerpc/include/asm/system.h                  |  554 --------------------
 arch/powerpc/kernel/align.c                        |    2 
 arch/powerpc/kernel/cputable.c                     |    1 
 arch/powerpc/kernel/crash.c                        |    2 
 arch/powerpc/kernel/idle.c                         |    1 
 arch/powerpc/kernel/irq.c                          |    1 
 arch/powerpc/kernel/kprobes.c                      |    1 
 arch/powerpc/kernel/lparcfg.c                      |    1 
 arch/powerpc/kernel/ppc_ksyms.c                    |    2 
 arch/powerpc/kernel/process.c                      |    3 
 arch/powerpc/kernel/prom.c                         |    1 
 arch/powerpc/kernel/prom_init.c                    |    1 
 arch/powerpc/kernel/ptrace.c                       |    2 
 arch/powerpc/kernel/ptrace32.c                     |    2 
 arch/powerpc/kernel/rtas.c                         |    1 
 arch/powerpc/kernel/setup-common.c                 |    1 
 arch/powerpc/kernel/setup_32.c                     |    1 
 arch/powerpc/kernel/setup_64.c                     |    1 
 arch/powerpc/kernel/signal.c                       |    1 
 arch/powerpc/kernel/signal_32.c                    |    1 
 arch/powerpc/kernel/signal_64.c                    |    1 
 arch/powerpc/kernel/smp.c                          |    2 
 arch/powerpc/kernel/softemu8xx.c                   |    1 
 arch/powerpc/kernel/swsusp.c                       |    2 
 arch/powerpc/kernel/swsusp_64.c                    |    1 
 arch/powerpc/kernel/sys_ppc32.c                    |    1 
 arch/powerpc/kernel/sysfs.c                        |    1 
 arch/powerpc/kernel/traps.c                        |    3 
 arch/powerpc/kernel/vdso.c                         |    1 
 arch/powerpc/kvm/book3s_hv.c                       |    1 
 arch/powerpc/lib/alloc.c                           |    2 
 arch/powerpc/lib/copyuser_power7_vmx.c             |    1 
 arch/powerpc/mm/44x_mmu.c                          |    1 
 arch/powerpc/mm/fault.c                            |    2 
 arch/powerpc/mm/hash_utils_64.c                    |    1 
 arch/powerpc/mm/init_32.c                          |    1 
 arch/powerpc/mm/init_64.c                          |    1 
 arch/powerpc/mm/numa.c                             |    2 
 arch/powerpc/mm/pgtable_32.c                       |    1 
 arch/powerpc/mm/pgtable_64.c                       |    1 
 arch/powerpc/oprofile/common.c                     |    1 
 arch/powerpc/oprofile/op_model_7450.c              |    1 
 arch/powerpc/oprofile/op_model_cell.c              |    1 
 arch/powerpc/oprofile/op_model_fsl_emb.c           |    1 
 arch/powerpc/oprofile/op_model_power4.c            |    1 
 arch/powerpc/oprofile/op_model_rs64.c              |    1 
 arch/powerpc/platforms/82xx/pq2.c                  |    1 
 arch/powerpc/platforms/83xx/km83xx.c               |    1 
 arch/powerpc/platforms/83xx/mpc832x_mds.c          |    1 
 arch/powerpc/platforms/83xx/mpc834x_itx.c          |    1 
 arch/powerpc/platforms/83xx/mpc834x_mds.c          |    1 
 arch/powerpc/platforms/83xx/mpc836x_mds.c          |    1 
 arch/powerpc/platforms/83xx/sbc834x.c              |    1 
 arch/powerpc/platforms/85xx/corenet_ds.c           |    1 
 arch/powerpc/platforms/85xx/ksi8560.c              |    1 
 arch/powerpc/platforms/85xx/mpc8536_ds.c           |    1 
 arch/powerpc/platforms/85xx/mpc85xx_ads.c          |    1 
 arch/powerpc/platforms/85xx/mpc85xx_cds.c          |    1 
 arch/powerpc/platforms/85xx/mpc85xx_ds.c           |    1 
 arch/powerpc/platforms/85xx/mpc85xx_mds.c          |    1 
 arch/powerpc/platforms/85xx/mpc85xx_rdb.c          |    1 
 arch/powerpc/platforms/85xx/p1010rdb.c             |    1 
 arch/powerpc/platforms/85xx/p1023_rds.c            |    1 
 arch/powerpc/platforms/85xx/p2041_rdb.c            |    1 
 arch/powerpc/platforms/85xx/p3041_ds.c             |    1 
 arch/powerpc/platforms/85xx/p4080_ds.c             |    1 
 arch/powerpc/platforms/85xx/p5020_ds.c             |    1 
 arch/powerpc/platforms/85xx/sbc8548.c              |    1 
 arch/powerpc/platforms/85xx/sbc8560.c              |    1 
 arch/powerpc/platforms/85xx/socrates.c             |    1 
 arch/powerpc/platforms/85xx/stx_gp3.c              |    1 
 arch/powerpc/platforms/85xx/tqm85xx.c              |    1 
 arch/powerpc/platforms/85xx/xes_mpc85xx.c          |    1 
 arch/powerpc/platforms/86xx/gef_ppc9a.c            |    1 
 arch/powerpc/platforms/86xx/gef_sbc310.c           |    1 
 arch/powerpc/platforms/86xx/gef_sbc610.c           |    1 
 arch/powerpc/platforms/86xx/mpc8610_hpcd.c         |    1 
 arch/powerpc/platforms/86xx/mpc86xx_hpcn.c         |    1 
 arch/powerpc/platforms/86xx/pic.c                  |    1 
 arch/powerpc/platforms/86xx/sbc8641d.c             |    1 
 arch/powerpc/platforms/8xx/mpc86xads_setup.c       |    1 
 arch/powerpc/platforms/8xx/mpc885ads_setup.c       |    1 
 arch/powerpc/platforms/8xx/tqm8xx_setup.c          |    1 
 arch/powerpc/platforms/cell/smp.c                  |    1 
 arch/powerpc/platforms/embedded6xx/c2k.c           |    1 
 arch/powerpc/platforms/embedded6xx/holly.c         |    1 
 arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c  |    1 
 arch/powerpc/platforms/embedded6xx/prpmc2800.c     |    1 
 arch/powerpc/platforms/embedded6xx/storcenter.c    |    1 
 arch/powerpc/platforms/fsl_uli1575.c               |    1 
 arch/powerpc/platforms/iseries/dt.c                |    1 
 arch/powerpc/platforms/iseries/lpevents.c          |    1 
 arch/powerpc/platforms/iseries/setup.c             |    1 
 arch/powerpc/platforms/iseries/smp.c               |    1 
 arch/powerpc/platforms/iseries/viopath.c           |    1 
 arch/powerpc/platforms/maple/setup.c               |    1 
 arch/powerpc/platforms/maple/time.c                |    1 
 arch/powerpc/platforms/pasemi/setup.c              |    2 
 arch/powerpc/platforms/powermac/bootx_init.c       |    1 
 arch/powerpc/platforms/powermac/cpufreq_32.c       |    2 
 arch/powerpc/platforms/powermac/nvram.c            |    1 
 arch/powerpc/platforms/powermac/setup.c            |    1 
 arch/powerpc/platforms/powermac/time.c             |    1 
 arch/powerpc/platforms/powernv/smp.c               |    1 
 arch/powerpc/platforms/ps3/mm.c                    |    1 
 arch/powerpc/platforms/pseries/dtl.c               |    2 
 arch/powerpc/platforms/pseries/hotplug-cpu.c       |    1 
 arch/powerpc/platforms/pseries/processor_idle.c    |    1 
 arch/powerpc/platforms/pseries/ras.c               |    1 
 arch/powerpc/platforms/pseries/smp.c               |    1 
 arch/powerpc/platforms/wsp/chroma.c                |    1 
 arch/powerpc/platforms/wsp/psr2.c                  |    1 
 arch/powerpc/sysdev/cpm_common.c                   |    1 
 arch/powerpc/sysdev/fsl_soc.c                      |    1 
 arch/powerpc/sysdev/msi_bitmap.c                   |    1 
 arch/powerpc/sysdev/tsi108_dev.c                   |    1 
 arch/powerpc/xmon/xmon.c                           |    1 
 arch/s390/crypto/crypt_s390.h                      |    1 
 arch/s390/include/asm/atomic.h                     |    2 
 arch/s390/include/asm/barrier.h                    |   35 +
 arch/s390/include/asm/ctl_reg.h                    |   76 +++
 arch/s390/include/asm/elf.h                        |    1 
 arch/s390/include/asm/exec.h                       |   12 
 arch/s390/include/asm/facility.h                   |   29 +
 arch/s390/include/asm/mmu.h                        |   14 +
 arch/s390/include/asm/mmu_context.h                |    1 
 arch/s390/include/asm/processor.h                  |   16 +
 arch/s390/include/asm/setup.h                      |   14 +
 arch/s390/include/asm/sigp.h                       |    9 
 arch/s390/include/asm/smp.h                        |    1 
 arch/s390/include/asm/switch_to.h                  |  100 ++++
 arch/s390/include/asm/system.h                     |  281 ----------
 arch/s390/include/asm/uaccess.h                    |    6 
 arch/s390/kernel/compat_signal.c                   |    1 
 arch/s390/kernel/cpcmd.c                           |    1 
 arch/s390/kernel/dis.c                             |    1 
 arch/s390/kernel/early.c                           |    1 
 arch/s390/kernel/machine_kexec.c                   |    1 
 arch/s390/kernel/process.c                         |    2 
 arch/s390/kernel/ptrace.c                          |    2 
 arch/s390/kernel/setup.c                           |    2 
 arch/s390/kernel/signal.c                          |    1 
 arch/s390/kernel/smp.c                             |    1 
 arch/s390/kernel/suspend.c                         |    2 
 arch/s390/kernel/traps.c                           |    1 
 arch/s390/kernel/vdso.c                            |    2 
 arch/s390/kvm/kvm-s390.c                           |    2 
 arch/s390/mm/fault.c                               |    2 
 arch/s390/mm/init.c                                |    2 
 arch/s390/mm/maccess.c                             |    2 
 arch/s390/mm/pgtable.c                             |    1 
 arch/s390/oprofile/hwsampler.c                     |    1 
 arch/score/include/asm/atomic.h                    |   43 ++
 arch/score/include/asm/barrier.h                   |   16 +
 arch/score/include/asm/bug.h                       |   10 
 arch/score/include/asm/exec.h                      |    6 
 arch/score/include/asm/switch_to.h                 |   13 
 arch/score/include/asm/system.h                    |   90 ---
 arch/sh/boards/mach-microdev/irq.c                 |    1 
 arch/sh/include/asm/atomic-irq.h                   |    2 
 arch/sh/include/asm/atomic.h                       |   54 ++
 arch/sh/include/asm/auxvec.h                       |    2 
 arch/sh/include/asm/barrier.h                      |   54 ++
 arch/sh/include/asm/bitops.h                       |    1 
 arch/sh/include/asm/bl_bit.h                       |   10 
 arch/sh/include/asm/bl_bit_32.h                    |   33 +
 arch/sh/include/asm/bl_bit_64.h                    |   38 +
 arch/sh/include/asm/bug.h                          |    5 
 arch/sh/include/asm/cache_insns.h                  |   11 
 arch/sh/include/asm/cache_insns_32.h               |   19 +
 arch/sh/include/asm/cache_insns_64.h               |   23 +
 arch/sh/include/asm/exec.h                         |   10 
 arch/sh/include/asm/futex-irq.h                    |    1 
 arch/sh/include/asm/io.h                           |    1 
 arch/sh/include/asm/processor.h                    |   15 +
 arch/sh/include/asm/ptrace.h                       |    1 
 arch/sh/include/asm/setup.h                        |    1 
 arch/sh/include/asm/switch_to.h                    |   19 +
 arch/sh/include/asm/switch_to_32.h                 |  134 +++++
 arch/sh/include/asm/switch_to_64.h                 |   35 +
 arch/sh/include/asm/system.h                       |  184 -------
 arch/sh/include/asm/system_32.h                    |  236 ---------
 arch/sh/include/asm/system_64.h                    |   79 ---
 arch/sh/include/asm/traps.h                        |   20 +
 arch/sh/include/asm/traps_32.h                     |   68 ++
 arch/sh/include/asm/traps_64.h                     |   24 +
 arch/sh/include/asm/uaccess.h                      |   14 +
 arch/sh/kernel/cpu/init.c                          |    2 
 arch/sh/kernel/cpu/irq/imask.c                     |    1 
 arch/sh/kernel/cpu/sh2a/opcode_helper.c            |    1 
 arch/sh/kernel/cpu/sh4/fpu.c                       |    1 
 arch/sh/kernel/hw_breakpoint.c                     |    1 
 arch/sh/kernel/idle.c                              |    2 
 arch/sh/kernel/io_trapped.c                        |    1 
 arch/sh/kernel/process_32.c                        |    1 
 arch/sh/kernel/process_64.c                        |    1 
 arch/sh/kernel/ptrace_32.c                         |    1 
 arch/sh/kernel/ptrace_64.c                         |    2 
 arch/sh/kernel/reboot.c                            |    2 
 arch/sh/kernel/signal_32.c                         |    1 
 arch/sh/kernel/smp.c                               |    1 
 arch/sh/kernel/traps.c                             |    2 
 arch/sh/kernel/traps_32.c                          |    3 
 arch/sh/kernel/traps_64.c                          |    1 
 arch/sh/math-emu/math.c                            |    1 
 arch/sh/mm/fault_32.c                              |    2 
 arch/sh/mm/fault_64.c                              |    1 
 arch/sh/mm/flush-sh4.c                             |    1 
 arch/sh/mm/pmb.c                                   |    1 
 arch/sh/mm/tlb-pteaex.c                            |    1 
 arch/sh/mm/tlb-sh3.c                               |    1 
 arch/sh/mm/tlb-sh4.c                               |    1 
 arch/sh/mm/tlbflush_64.c                           |    1 
 arch/sparc/include/asm/atomic_32.h                 |   98 ++++
 arch/sparc/include/asm/atomic_64.h                 |  138 +++++
 arch/sparc/include/asm/auxio_32.h                  |    1 
 arch/sparc/include/asm/barrier.h                   |    8 
 arch/sparc/include/asm/barrier_32.h                |   15 +
 arch/sparc/include/asm/barrier_64.h                |   56 ++
 arch/sparc/include/asm/bug.h                       |    3 
 arch/sparc/include/asm/cacheflush_32.h             |    9 
 arch/sparc/include/asm/cacheflush_64.h             |   10 
 arch/sparc/include/asm/cpu_type.h                  |   34 +
 arch/sparc/include/asm/exec.h                      |    6 
 arch/sparc/include/asm/floppy_32.h                 |    1 
 arch/sparc/include/asm/futex_64.h                  |    1 
 arch/sparc/include/asm/io_32.h                     |    1 
 arch/sparc/include/asm/io_64.h                     |    1 
 arch/sparc/include/asm/irqflags_32.h               |    1 
 arch/sparc/include/asm/mmu_context_64.h            |    1 
 arch/sparc/include/asm/ns87303.h                   |    1 
 arch/sparc/include/asm/perfctr.h                   |   23 +
 arch/sparc/include/asm/pgtable_32.h                |    2 
 arch/sparc/include/asm/pgtable_64.h                |    1 
 arch/sparc/include/asm/processor.h                 |    3 
 arch/sparc/include/asm/processor_64.h              |    3 
 arch/sparc/include/asm/ptrace.h                    |    4 
 arch/sparc/include/asm/setup.h                     |   16 +
 arch/sparc/include/asm/switch_to.h                 |    8 
 arch/sparc/include/asm/switch_to_32.h              |  106 ++++
 arch/sparc/include/asm/switch_to_64.h              |   73 +++
 arch/sparc/include/asm/system.h                    |    8 
 arch/sparc/include/asm/system_32.h                 |  284 ----------
 arch/sparc/include/asm/system_64.h                 |  331 ------------
 arch/sparc/include/asm/timer_32.h                  |    3 
 arch/sparc/include/asm/uaccess_64.h                |    1 
 arch/sparc/kernel/auxio_32.c                       |    1 
 arch/sparc/kernel/devices.c                        |    2 
 arch/sparc/kernel/irq.h                            |    1 
 arch/sparc/kernel/irq_64.c                         |    1 
 arch/sparc/kernel/kgdb_32.c                        |    1 
 arch/sparc/kernel/module.c                         |    1 
 arch/sparc/kernel/muldiv.c                         |    1 
 arch/sparc/kernel/nmi.c                            |    1 
 arch/sparc/kernel/pcr.c                            |    1 
 arch/sparc/kernel/perf_event.c                     |    2 
 arch/sparc/kernel/process_32.c                     |    2 
 arch/sparc/kernel/process_64.c                     |    1 
 arch/sparc/kernel/ptrace_32.c                      |    2 
 arch/sparc/kernel/ptrace_64.c                      |    1 
 arch/sparc/kernel/reboot.c                         |    2 
 arch/sparc/kernel/setup_32.c                       |    2 
 arch/sparc/kernel/setup_64.c                       |    2 
 arch/sparc/kernel/signal32.c                       |    1 
 arch/sparc/kernel/signal_32.c                      |    1 
 arch/sparc/kernel/signal_64.c                      |    2 
 arch/sparc/kernel/sigutil_32.c                     |    1 
 arch/sparc/kernel/sigutil_64.c                     |    1 
 arch/sparc/kernel/sparc_ksyms_64.c                 |    2 
 arch/sparc/kernel/time_32.c                        |    1 
 arch/sparc/kernel/traps_32.c                       |    1 
 arch/sparc/kernel/traps_64.c                       |    2 
 arch/sparc/kernel/unaligned_32.c                   |    1 
 arch/sparc/kernel/unaligned_64.c                   |    2 
 arch/sparc/kernel/visemul.c                        |    2 
 arch/sparc/math-emu/math_64.c                      |    1 
 arch/sparc/mm/btfixup.c                            |    1 
 arch/sparc/mm/fault_32.c                           |    1 
 arch/sparc/mm/init_32.c                            |    1 
 arch/sparc/mm/init_64.c                            |    1 
 arch/sparc/mm/init_64.h                            |    2 
 arch/sparc/mm/loadmmu.c                            |    1 
 arch/sparc/mm/tsb.c                                |    1 
 arch/sparc/prom/console_32.c                       |    1 
 arch/sparc/prom/console_64.c                       |    1 
 arch/sparc/prom/misc_32.c                          |    1 
 arch/sparc/prom/misc_64.c                          |    1 
 arch/sparc/prom/p1275.c                            |    1 
 arch/sparc/prom/ranges.c                           |    1 
 arch/tile/include/asm/atomic.h                     |    1 
 arch/tile/include/asm/barrier.h                    |  140 +++++
 arch/tile/include/asm/bitops_32.h                  |    1 
 arch/tile/include/asm/bitops_64.h                  |    1 
 arch/tile/include/asm/cacheflush.h                 |   11 
 arch/tile/include/asm/exec.h                       |   20 +
 arch/tile/include/asm/pgtable.h                    |    1 
 arch/tile/include/asm/setup.h                      |   21 +
 arch/tile/include/asm/spinlock_32.h                |    1 
 arch/tile/include/asm/switch_to.h                  |   72 +++
 arch/tile/include/asm/system.h                     |  261 ---------
 arch/tile/include/asm/timex.h                      |    2 
 arch/tile/include/asm/unaligned.h                  |   15 +
 arch/tile/kernel/process.c                         |    1 
 arch/tile/kernel/regs_32.S                         |    1 
 arch/tile/kernel/regs_64.S                         |    1 
 arch/tile/mm/fault.c                               |    1 
 arch/tile/mm/init.c                                |    1 
 arch/tile/mm/pgtable.c                             |    1 
 arch/um/include/asm/fixmap.h                       |    1 
 arch/unicore32/include/asm/atomic.h                |   58 ++
 arch/unicore32/include/asm/barrier.h               |   28 +
 arch/unicore32/include/asm/bug.h                   |   32 +
 arch/unicore32/include/asm/cr.h                    |   49 ++
 arch/unicore32/include/asm/exec.h                  |   15 +
 arch/unicore32/include/asm/io.h                    |    1 
 arch/unicore32/include/asm/pgtable.h               |    3 
 arch/unicore32/include/asm/setup.h                 |   16 +
 arch/unicore32/include/asm/switch_to.h             |   30 +
 arch/unicore32/include/asm/system.h                |  161 ------
 arch/unicore32/include/asm/uaccess.h               |    1 
 arch/unicore32/kernel/dma.c                        |    1 
 arch/unicore32/kernel/head.S                       |    1 
 arch/unicore32/kernel/hibernate.c                  |    1 
 arch/unicore32/kernel/irq.c                        |    1 
 arch/unicore32/kernel/ksyms.c                      |    1 
 arch/unicore32/kernel/process.c                    |    1 
 arch/unicore32/kernel/traps.c                      |    1 
 arch/unicore32/mm/fault.c                          |    1 
 arch/unicore32/mm/flush.c                          |    1 
 arch/x86/ia32/ia32_aout.c                          |    1 
 arch/x86/include/asm/apic.h                        |    1 
 arch/x86/include/asm/auxvec.h                      |    7 
 arch/x86/include/asm/barrier.h                     |  113 ++++
 arch/x86/include/asm/bug.h                         |    4 
 arch/x86/include/asm/cacheflush.h                  |    1 
 arch/x86/include/asm/elf.h                         |    1 
 arch/x86/include/asm/exec.h                        |    1 
 arch/x86/include/asm/futex.h                       |    1 
 arch/x86/include/asm/i387.h                        |    1 
 arch/x86/include/asm/local.h                       |    1 
 arch/x86/include/asm/mc146818rtc.h                 |    1 
 arch/x86/include/asm/page_types.h                  |    1 
 arch/x86/include/asm/processor.h                   |   31 +
 arch/x86/include/asm/segment.h                     |   58 ++
 arch/x86/include/asm/special_insns.h               |  199 +++++++
 arch/x86/include/asm/stackprotector.h              |    1 
 arch/x86/include/asm/switch_to.h                   |  129 +++++
 arch/x86/include/asm/system.h                      |  523 -------------------
 arch/x86/include/asm/tlbflush.h                    |    2 
 arch/x86/include/asm/virtext.h                     |    1 
 arch/x86/kernel/acpi/cstate.c                      |    1 
 arch/x86/kernel/apm_32.c                           |    1 
 arch/x86/kernel/cpu/mcheck/p5.c                    |    1 
 arch/x86/kernel/cpu/mcheck/therm_throt.c           |    1 
 arch/x86/kernel/cpu/mcheck/winchip.c               |    1 
 arch/x86/kernel/cpu/mtrr/generic.c                 |    1 
 arch/x86/kernel/cpuid.c                            |    1 
 arch/x86/kernel/i8259.c                            |    1 
 arch/x86/kernel/irqinit.c                          |    1 
 arch/x86/kernel/kgdb.c                             |    1 
 arch/x86/kernel/ldt.c                              |    1 
 arch/x86/kernel/machine_kexec_32.c                 |    1 
 arch/x86/kernel/mca_32.c                           |    1 
 arch/x86/kernel/module.c                           |    1 
 arch/x86/kernel/msr.c                              |    1 
 arch/x86/kernel/paravirt.c                         |    1 
 arch/x86/kernel/pci-calgary_64.c                   |    1 
 arch/x86/kernel/process.c                          |    1 
 arch/x86/kernel/process_32.c                       |    2 
 arch/x86/kernel/process_64.c                       |    2 
 arch/x86/kernel/ptrace.c                           |    1 
 arch/x86/kernel/setup.c                            |    1 
 arch/x86/kernel/tce_64.c                           |    1 
 arch/x86/kernel/tls.c                              |    1 
 arch/x86/kernel/traps.c                            |    1 
 arch/x86/mm/init.c                                 |    1 
 arch/x86/mm/init_32.c                              |    1 
 arch/x86/mm/init_64.c                              |    1 
 arch/x86/mm/pgtable_32.c                           |    1 
 arch/x86/power/hibernate_32.c                      |    1 
 arch/xtensa/include/asm/atomic.h                   |  112 ++++
 arch/xtensa/include/asm/barrier.h                  |   29 +
 arch/xtensa/include/asm/bitops.h                   |    1 
 arch/xtensa/include/asm/exec.h                     |   14 +
 arch/xtensa/include/asm/setup.h                    |    2 
 arch/xtensa/include/asm/switch_to.h                |   22 +
 arch/xtensa/include/asm/system.h                   |  184 -------
 arch/xtensa/kernel/process.c                       |    1 
 arch/xtensa/kernel/ptrace.c                        |    1 
 arch/xtensa/kernel/setup.c                         |    1 
 arch/xtensa/kernel/traps.c                         |   19 +
 arch/xtensa/mm/fault.c                             |    1 
 arch/xtensa/mm/tlb.c                               |    1 
 drivers/acpi/processor_driver.c                    |    1 
 drivers/atm/eni.c                                  |    1 
 drivers/atm/firestream.c                           |    1 
 drivers/atm/horizon.c                              |    1 
 drivers/atm/idt77105.c                             |    1 
 drivers/atm/iphase.c                               |    1 
 drivers/atm/suni.c                                 |    1 
 drivers/atm/zatm.c                                 |    1 
 drivers/block/floppy.c                             |    1 
 drivers/block/hd.c                                 |    1 
 drivers/block/nbd.c                                |    1 
 drivers/block/xd.c                                 |    1 
 drivers/bluetooth/bt3c_cs.c                        |    1 
 drivers/bluetooth/btuart_cs.c                      |    1 
 drivers/bluetooth/dtl1_cs.c                        |    1 
 drivers/char/apm-emulation.c                       |    1 
 drivers/char/ds1302.c                              |    1 
 drivers/char/efirtc.c                              |    1 
 drivers/char/genrtc.c                              |    1 
 drivers/char/hpet.c                                |    1 
 drivers/char/ipmi/ipmi_devintf.c                   |    1 
 drivers/char/ipmi/ipmi_msghandler.c                |    1 
 drivers/char/ipmi/ipmi_si_intf.c                   |    1 
 drivers/char/lp.c                                  |    1 
 drivers/char/mbcs.c                                |    1 
 drivers/char/mspec.c                               |    1 
 drivers/char/mwave/3780i.c                         |    1 
 drivers/char/nvram.c                               |    1 
 drivers/char/nwflash.c                             |    1 
 drivers/char/pcmcia/synclink_cs.c                  |    1 
 drivers/char/rtc.c                                 |    1 
 drivers/char/sonypi.c                              |    1 
 drivers/char/xilinx_hwicap/xilinx_hwicap.c         |    1 
 drivers/cpufreq/omap-cpufreq.c                     |    1 
 drivers/cpufreq/powernow-k7.c                      |    1 
 drivers/firewire/core-cdev.c                       |    1 
 drivers/firewire/core-device.c                     |    1 
 drivers/firewire/core-topology.c                   |    1 
 drivers/firewire/ohci.c                            |    1 
 drivers/firewire/sbp2.c                            |    1 
 drivers/i2c/busses/i2c-acorn.c                     |    1 
 drivers/ide/ide-cs.c                               |    1 
 drivers/ide/qd65xx.c                               |    1 
 drivers/infiniband/hw/ehca/ehca_reqs.c             |    1 
 drivers/input/joydev.c                             |    1 
 drivers/input/joystick/amijoy.c                    |    1 
 drivers/input/mouse/amimouse.c                     |    1 
 drivers/input/mouse/atarimouse.c                   |    1 
 drivers/input/serio/hp_sdc.c                       |    1 
 drivers/input/serio/maceps2.c                      |    1 
 drivers/input/serio/rpckbd.c                       |    1 
 drivers/input/serio/sa1111ps2.c                    |    1 
 drivers/isdn/hardware/avm/avm_cs.c                 |    1 
 drivers/isdn/hisax/avma1_cs.c                      |    1 
 drivers/isdn/hisax/elsa_cs.c                       |    1 
 drivers/isdn/hisax/sedlbauer_cs.c                  |    1 
 drivers/isdn/hisax/teles_cs.c                      |    1 
 drivers/isdn/i4l/isdn_bsdcomp.c                    |    1 
 drivers/isdn/pcbit/layer2.c                        |    1 
 drivers/macintosh/macio-adb.c                      |    1 
 drivers/macintosh/therm_adt746x.c                  |    1 
 drivers/macintosh/therm_pm72.c                     |    1 
 drivers/macintosh/therm_windtunnel.c               |    1 
 drivers/macintosh/via-cuda.c                       |    1 
 drivers/macintosh/via-macii.c                      |    1 
 drivers/macintosh/via-pmu.c                        |    1 
 drivers/macintosh/via-pmu68k.c                     |    1 
 drivers/macintosh/windfarm_lm75_sensor.c           |    1 
 drivers/macintosh/windfarm_pm121.c                 |    1 
 drivers/macintosh/windfarm_pm81.c                  |    1 
 drivers/macintosh/windfarm_pm91.c                  |    1 
 drivers/macintosh/windfarm_smu_controls.c          |    1 
 drivers/macintosh/windfarm_smu_sensors.c           |    1 
 drivers/media/dvb/dvb-core/dmxdev.c                |    1 
 drivers/media/dvb/firewire/firedtv-fw.c            |    1 
 drivers/media/dvb/ttpci/av7110.c                   |    1 
 drivers/media/media-devnode.c                      |    1 
 drivers/media/video/ivtv/ivtv-driver.h             |    1 
 drivers/media/video/v4l2-common.c                  |    1 
 drivers/media/video/v4l2-dev.c                     |    1 
 drivers/message/i2o/i2o_scsi.c                     |    1 
 drivers/mfd/mcp-core.c                             |    1 
 drivers/mfd/mcp-sa11x0.c                           |    1 
 drivers/misc/sgi-gru/gru_instructions.h            |    1 
 drivers/misc/sgi-xp/xp.h                           |    1 
 drivers/mmc/card/block.c                           |    1 
 drivers/mtd/devices/pmc551.c                       |    1 
 drivers/mtd/devices/slram.c                        |    1 
 drivers/mtd/maps/pcmciamtd.c                       |    1 
 drivers/mtd/nand/bcm_umi_nand.c                    |    1 
 drivers/net/appletalk/cops.c                       |    1 
 drivers/net/appletalk/ltpc.c                       |    1 
 drivers/net/arcnet/com20020_cs.c                   |    1 
 drivers/net/bonding/bond_main.c                    |    1 
 drivers/net/can/slcan.c                            |    1 
 drivers/net/cris/eth_v10.c                         |    1 
 drivers/net/ethernet/3com/3c574_cs.c               |    1 
 drivers/net/ethernet/3com/3c589_cs.c               |    1 
 drivers/net/ethernet/8390/3c503.c                  |    1 
 drivers/net/ethernet/8390/ac3200.c                 |    1 
 drivers/net/ethernet/8390/apne.c                   |    1 
 drivers/net/ethernet/8390/ax88796.c                |    1 
 drivers/net/ethernet/8390/axnet_cs.c               |    1 
 drivers/net/ethernet/8390/e2100.c                  |    1 
 drivers/net/ethernet/8390/es3210.c                 |    1 
 drivers/net/ethernet/8390/etherh.c                 |    1 
 drivers/net/ethernet/8390/hp-plus.c                |    1 
 drivers/net/ethernet/8390/hp.c                     |    1 
 drivers/net/ethernet/8390/lib8390.c                |    1 
 drivers/net/ethernet/8390/lne390.c                 |    1 
 drivers/net/ethernet/8390/mac8390.c                |    1 
 drivers/net/ethernet/8390/ne-h8300.c               |    1 
 drivers/net/ethernet/8390/ne.c                     |    1 
 drivers/net/ethernet/8390/ne2.c                    |    1 
 drivers/net/ethernet/8390/ne2k-pci.c               |    1 
 drivers/net/ethernet/8390/ne3210.c                 |    1 
 drivers/net/ethernet/8390/pcnet_cs.c               |    1 
 drivers/net/ethernet/8390/smc-mca.c                |    1 
 drivers/net/ethernet/8390/smc-ultra.c              |    1 
 drivers/net/ethernet/8390/smc-ultra32.c            |    1 
 drivers/net/ethernet/8390/stnic.c                  |    1 
 drivers/net/ethernet/8390/wd.c                     |    1 
 drivers/net/ethernet/8390/zorro8390.c              |    1 
 drivers/net/ethernet/alteon/acenic.c               |    1 
 drivers/net/ethernet/amd/7990.c                    |    1 
 drivers/net/ethernet/amd/am79c961a.c               |    1 
 drivers/net/ethernet/amd/amd8111e.c                |    1 
 drivers/net/ethernet/amd/declance.c                |    1 
 drivers/net/ethernet/amd/hplance.c                 |    1 
 drivers/net/ethernet/amd/mvme147.c                 |    1 
 drivers/net/ethernet/amd/nmclan_cs.c               |    1 
 drivers/net/ethernet/amd/sunlance.c                |    1 
 drivers/net/ethernet/broadcom/tg3.c                |    1 
 drivers/net/ethernet/cirrus/cs89x0.c               |    1 
 drivers/net/ethernet/cirrus/mac89x0.c              |    1 
 drivers/net/ethernet/dlink/de600.c                 |    1 
 drivers/net/ethernet/dlink/de620.c                 |    1 
 drivers/net/ethernet/fujitsu/at1700.c              |    1 
 drivers/net/ethernet/fujitsu/eth16i.c              |    1 
 drivers/net/ethernet/fujitsu/fmvj18x_cs.c          |    1 
 drivers/net/ethernet/i825xx/3c507.c                |    1 
 drivers/net/ethernet/i825xx/3c527.c                |    1 
 drivers/net/ethernet/i825xx/eepro.c                |    1 
 drivers/net/ethernet/i825xx/eexpress.c             |    1 
 drivers/net/ethernet/i825xx/ether1.c               |    1 
 drivers/net/ethernet/i825xx/znet.c                 |    1 
 drivers/net/ethernet/korina.c                      |    1 
 drivers/net/ethernet/marvell/mv643xx_eth.c         |    1 
 drivers/net/ethernet/marvell/pxa168_eth.c          |    1 
 drivers/net/ethernet/natsemi/jazzsonic.c           |    1 
 drivers/net/ethernet/natsemi/macsonic.c            |    1 
 drivers/net/ethernet/natsemi/ns83820.c             |    1 
 drivers/net/ethernet/neterion/s2io.c               |    1 
 drivers/net/ethernet/nvidia/forcedeth.c            |    1 
 drivers/net/ethernet/realtek/atp.c                 |    1 
 drivers/net/ethernet/realtek/r8169.c               |    1 
 drivers/net/ethernet/seeq/ether3.c                 |    1 
 drivers/net/ethernet/seeq/seeq8005.c               |    1 
 drivers/net/ethernet/smsc/smc91c92_cs.c            |    1 
 drivers/net/ethernet/sun/cassini.c                 |    1 
 drivers/net/ethernet/sun/sunbmac.c                 |    1 
 drivers/net/ethernet/sun/sungem.c                  |    1 
 drivers/net/ethernet/sun/sunhme.c                  |    1 
 drivers/net/ethernet/sun/sunqe.c                   |    1 
 drivers/net/ethernet/tundra/tsi108_eth.c           |    1 
 drivers/net/ethernet/xircom/xirc2ps_cs.c           |    1 
 drivers/net/hamradio/6pack.c                       |    1 
 drivers/net/hamradio/baycom_par.c                  |    1 
 drivers/net/hamradio/bpqether.c                    |    1 
 drivers/net/hamradio/mkiss.c                       |    1 
 drivers/net/hamradio/scc.c                         |    1 
 drivers/net/hamradio/yam.c                         |    1 
 drivers/net/hippi/rrunner.c                        |    1 
 drivers/net/irda/donauboe.c                        |    1 
 drivers/net/loopback.c                             |    1 
 drivers/net/plip/plip.c                            |    1 
 drivers/net/slip/slhc.c                            |    1 
 drivers/net/slip/slip.c                            |    1 
 drivers/net/tokenring/3c359.c                      |    1 
 drivers/net/tokenring/abyss.c                      |    1 
 drivers/net/tokenring/ibmtr_cs.c                   |    1 
 drivers/net/tokenring/lanstreamer.c                |    1 
 drivers/net/tokenring/madgemc.c                    |    1 
 drivers/net/tokenring/olympic.c                    |    1 
 drivers/net/tokenring/proteon.c                    |    1 
 drivers/net/tokenring/skisa.c                      |    1 
 drivers/net/tokenring/smctr.c                      |    1 
 drivers/net/tokenring/tms380tr.c                   |    1 
 drivers/net/tokenring/tmspci.c                     |    1 
 drivers/net/tun.c                                  |    1 
 drivers/net/wan/dlci.c                             |    1 
 drivers/net/wan/dscc4.c                            |    1 
 drivers/net/wan/hd64570.c                          |    1 
 drivers/net/wan/hd64572.c                          |    1 
 drivers/net/wan/lapbether.c                        |    1 
 drivers/net/wan/sdla.c                             |    1 
 drivers/net/wan/x25_asy.c                          |    1 
 drivers/net/wireless/airo.c                        |    1 
 drivers/net/wireless/airo_cs.c                     |    1 
 drivers/net/wireless/atmel.c                       |    1 
 drivers/net/wireless/atmel_cs.c                    |    1 
 drivers/net/wireless/prism54/islpci_mgt.c          |    1 
 drivers/net/wireless/ray_cs.c                      |    1 
 drivers/net/wireless/wl3501_cs.c                   |    1 
 drivers/nubus/nubus.c                              |    1 
 drivers/parisc/dino.c                              |    1 
 drivers/parisc/iosapic.c                           |    1 
 drivers/parisc/lba_pci.c                           |    1 
 drivers/pcmcia/cs.c                                |    1 
 drivers/pcmcia/i82092.c                            |    1 
 drivers/pcmcia/i82365.c                            |    1 
 drivers/pcmcia/m32r_cfc.c                          |    1 
 drivers/pcmcia/m32r_pcc.c                          |    1 
 drivers/pcmcia/m8xx_pcmcia.c                       |    1 
 drivers/pcmcia/pd6729.c                            |    1 
 drivers/pcmcia/pxa2xx_base.c                       |    1 
 drivers/pcmcia/sa11xx_base.c                       |    1 
 drivers/pcmcia/soc_common.c                        |    1 
 drivers/pcmcia/socket_sysfs.c                      |    1 
 drivers/pcmcia/tcic.c                              |    1 
 drivers/pcmcia/xxs1500_ss.c                        |    1 
 drivers/pnp/pnpbios/bioscalls.c                    |    1 
 drivers/pnp/pnpbios/core.c                         |    1 
 drivers/s390/char/sclp_cmd.c                       |    1 
 drivers/s390/cio/crw.c                             |    1 
 drivers/s390/crypto/ap_bus.c                       |    2 
 drivers/sbus/char/flash.c                          |    1 
 drivers/sbus/char/openprom.c                       |    1 
 drivers/sbus/char/uctrl.c                          |    1 
 drivers/scsi/53c700.c                              |    1 
 drivers/scsi/BusLogic.c                            |    1 
 drivers/scsi/advansys.c                            |    1 
 drivers/scsi/aha152x.c                             |    1 
 drivers/scsi/aha1542.c                             |    1 
 drivers/scsi/aha1740.c                             |    1 
 drivers/scsi/arcmsr/arcmsr_hba.c                   |    1 
 drivers/scsi/arm/acornscsi.c                       |    1 
 drivers/scsi/arm/cumana_1.c                        |    1 
 drivers/scsi/arm/oak.c                             |    1 
 drivers/scsi/atp870u.c                             |    1 
 drivers/scsi/dtc.c                                 |    1 
 drivers/scsi/fd_mcs.c                              |    1 
 drivers/scsi/fdomain.c                             |    1 
 drivers/scsi/g_NCR5380.c                           |    1 
 drivers/scsi/gdth.c                                |    1 
 drivers/scsi/ibmmca.c                              |    1 
 drivers/scsi/in2000.c                              |    1 
 drivers/scsi/mac53c94.c                            |    1 
 drivers/scsi/mac_scsi.c                            |    1 
 drivers/scsi/mesh.c                                |    1 
 drivers/scsi/ncr53c8xx.c                           |    1 
 drivers/scsi/nsp32.c                               |    1 
 drivers/scsi/osst.c                                |    1 
 drivers/scsi/pas16.c                               |    1 
 drivers/scsi/qla1280.c                             |    1 
 drivers/scsi/qlogicpti.c                           |    1 
 drivers/scsi/st.c                                  |    1 
 drivers/scsi/sun3_scsi.c                           |    1 
 drivers/scsi/sun3_scsi_vme.c                       |    1 
 drivers/scsi/sym53c416.c                           |    1 
 drivers/scsi/t128.c                                |    1 
 drivers/scsi/u14-34f.c                             |    1 
 drivers/scsi/ultrastor.c                           |    1 
 drivers/scsi/wd7000.c                              |    1 
 drivers/spi/spi-omap-uwire.c                       |    1 
 drivers/staging/comedi/drivers.c                   |    1 
 drivers/staging/comedi/drivers/cb_pcidas64.c       |    1 
 drivers/staging/comedi/drivers/mite.c              |    1 
 drivers/staging/crystalhd/crystalhd_lnx.h          |    1 
 drivers/staging/crystalhd/crystalhd_misc.h         |    1 
 drivers/staging/et131x/et131x.c                    |    1 
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c   |    1 
 drivers/staging/media/go7007/go7007-driver.c       |    1 
 drivers/staging/media/go7007/go7007-i2c.c          |    1 
 drivers/staging/media/go7007/go7007-v4l2.c         |    1 
 drivers/staging/media/go7007/snd-go7007.c          |    1 
 drivers/staging/media/lirc/lirc_serial.c           |    1 
 drivers/staging/media/lirc/lirc_sir.c              |    1 
 drivers/staging/panel/panel.c                      |    1 
 drivers/staging/sbe-2t3e3/io.c                     |    1 
 .../tidspbridge/include/dspbridge/host_os.h        |    1 
 drivers/staging/wlags49_h2/wl_cs.c                 |    1 
 drivers/staging/wlags49_h2/wl_main.c               |    3 
 drivers/staging/wlags49_h2/wl_netdev.c             |    3 
 drivers/staging/wlags49_h2/wl_pci.c                |    1 
 drivers/staging/wlags49_h2/wl_util.c               |    3 
 drivers/telephony/phonedev.c                       |    1 
 drivers/tty/amiserial.c                            |    1 
 drivers/tty/isicom.c                               |    1 
 drivers/tty/moxa.c                                 |    1 
 drivers/tty/mxser.c                                |    1 
 drivers/tty/n_hdlc.c                               |    1 
 drivers/tty/n_tty.c                                |    1 
 drivers/tty/pty.c                                  |    1 
 drivers/tty/serial/68328serial.c                   |    1 
 drivers/tty/serial/8250/serial_cs.c                |    1 
 drivers/tty/serial/crisv10.c                       |    2 
 drivers/tty/serial/dz.c                            |    1 
 drivers/tty/serial/icom.c                          |    1 
 drivers/tty/serial/msm_serial_hs.c                 |    1 
 drivers/tty/serial/sunhv.c                         |    1 
 drivers/tty/serial/sunsab.c                        |    1 
 drivers/tty/serial/sunsu.c                         |    1 
 drivers/tty/serial/sunzilog.c                      |    1 
 drivers/tty/serial/zs.c                            |    1 
 drivers/tty/synclink.c                             |    1 
 drivers/tty/synclink_gt.c                          |    1 
 drivers/tty/synclinkmp.c                           |    1 
 drivers/tty/tty_io.c                               |    1 
 drivers/tty/tty_ioctl.c                            |    1 
 drivers/tty/vt/vt.c                                |    1 
 drivers/usb/gadget/amd5536udc.c                    |    1 
 drivers/usb/gadget/at91_udc.c                      |    1 
 drivers/usb/gadget/dummy_hcd.c                     |    1 
 drivers/usb/gadget/fsl_udc_core.c                  |    1 
 drivers/usb/gadget/goku_udc.c                      |    1 
 drivers/usb/gadget/langwell_udc.c                  |    1 
 drivers/usb/gadget/mv_udc_core.c                   |    1 
 drivers/usb/gadget/net2272.c                       |    1 
 drivers/usb/gadget/net2280.c                       |    1 
 drivers/usb/gadget/omap_udc.c                      |    1 
 drivers/usb/gadget/printer.c                       |    1 
 drivers/usb/gadget/pxa25x_udc.c                    |    1 
 drivers/usb/gadget/rndis.c                         |    1 
 drivers/usb/gadget/s3c2410_udc.c                   |    1 
 drivers/usb/host/ehci-hcd.c                        |    1 
 drivers/usb/host/isp116x-hcd.c                     |    1 
 drivers/usb/host/isp1362-hcd.c                     |    1 
 drivers/usb/host/ohci-hcd.c                        |    1 
 drivers/usb/host/oxu210hp-hcd.c                    |    1 
 drivers/usb/host/sl811-hcd.c                       |    1 
 drivers/usb/host/u132-hcd.c                        |    1 
 drivers/usb/host/uhci-hcd.c                        |    1 
 drivers/video/amifb.c                              |    1 
 drivers/video/bt431.h                              |    1 
 drivers/video/bt455.h                              |    1 
 drivers/video/console/fbcon.c                      |    1 
 drivers/video/console/newport_con.c                |    1 
 drivers/video/cyber2000fb.c                        |    1 
 drivers/video/dnfb.c                               |    1 
 drivers/video/neofb.c                              |    1 
 drivers/video/pmag-ba-fb.c                         |    1 
 drivers/video/pmagb-b-fb.c                         |    1 
 drivers/video/q40fb.c                              |    1 
 drivers/video/savage/savagefb_driver.c             |    1 
 drivers/virtio/config.c                            |    1 
 drivers/watchdog/advantechwdt.c                    |    1 
 drivers/watchdog/alim7101_wdt.c                    |    1 
 drivers/watchdog/booke_wdt.c                       |    1 
 drivers/watchdog/eurotechwdt.c                     |    1 
 drivers/watchdog/ib700wdt.c                        |    1 
 drivers/watchdog/it87_wdt.c                        |    1 
 drivers/watchdog/machzwd.c                         |    1 
 drivers/watchdog/pc87413_wdt.c                     |    1 
 drivers/watchdog/sbc60xxwdt.c                      |    1 
 drivers/watchdog/sbc7240_wdt.c                     |    1 
 drivers/watchdog/sbc8360.c                         |    1 
 drivers/watchdog/sbc_fitpc2_wdt.c                  |    1 
 drivers/watchdog/sc520_wdt.c                       |    1 
 drivers/watchdog/smsc37b787_wdt.c                  |    1 
 drivers/watchdog/w83627hf_wdt.c                    |    1 
 drivers/watchdog/w83697hf_wdt.c                    |    1 
 drivers/watchdog/w83697ug_wdt.c                    |    1 
 drivers/watchdog/w83877f_wdt.c                     |    1 
 drivers/watchdog/w83977f_wdt.c                     |    1 
 drivers/watchdog/wdt.c                             |    1 
 drivers/watchdog/wdt977.c                          |    1 
 drivers/watchdog/wdt_pci.c                         |    1 
 fs/binfmt_aout.c                                   |    1 
 fs/binfmt_elf.c                                    |    1 
 fs/binfmt_elf_fdpic.c                              |    1 
 fs/binfmt_flat.c                                   |    1 
 fs/coda/inode.c                                    |    1 
 fs/coda/psdev.c                                    |    1 
 fs/coda/upcall.c                                   |    1 
 fs/eventpoll.c                                     |    1 
 fs/exec.c                                          |    1 
 fs/jbd2/commit.c                                   |    1 
 fs/jbd2/journal.c                                  |    1 
 fs/ncpfs/file.c                                    |    1 
 fs/ncpfs/inode.c                                   |    1 
 fs/ncpfs/mmap.c                                    |    1 
 fs/nfs/client.c                                    |    1 
 fs/nfs/direct.c                                    |    1 
 fs/nfs/file.c                                      |    1 
 fs/nfs/getroot.c                                   |    1 
 fs/nfs/inode.c                                     |    1 
 fs/nfs/read.c                                      |    1 
 fs/nfs/super.c                                     |    1 
 fs/proc/inode.c                                    |    1 
 fs/reiserfs/journal.c                              |    1 
 fs/ufs/inode.c                                     |    1 
 fs/ufs/super.c                                     |    1 
 fs/xfs/xfs_buf.h                                   |    1 
 include/acpi/platform/aclinux.h                    |    1 
 include/asm-generic/atomic.h                       |    1 
 include/asm-generic/bitops/atomic.h                |    2 
 include/linux/cnt32_to_63.h                        |    1 
 include/linux/debug_locks.h                        |    1 
 include/linux/efi.h                                |    1 
 include/linux/ide.h                                |    1 
 include/linux/interrupt.h                          |    1 
 include/linux/llist.h                              |    2 
 include/linux/lsm_audit.h                          |    1 
 include/linux/mm.h                                 |    2 
 include/linux/mtd/map.h                            |    1 
 include/linux/parport.h                            |    1 
 include/linux/rwsem.h                              |    1 
 include/linux/sched.h                              |    1 
 include/linux/skbuff.h                             |    1 
 include/linux/spinlock.h                           |    2 
 include/linux/stop_machine.h                       |    1 
 include/linux/tty.h                                |    1 
 include/linux/wait.h                               |    1 
 init/main.c                                        |    1 
 kernel/debug/debug_core.c                          |    1 
 kernel/debug/kdb/kdb_bt.c                          |    1 
 kernel/dma.c                                       |    1 
 kernel/kexec.c                                     |    1 
 kernel/rwsem.c                                     |    1 
 kernel/sched/core.c                                |    1 
 kernel/signal.c                                    |    2 
 kernel/sysctl.c                                    |    4 
 lib/llist.c                                        |    1 
 lib/raid6/altivec.uc                               |    1 
 net/802/fc.c                                       |    1 
 net/802/fddi.c                                     |    1 
 net/802/hippi.c                                    |    1 
 net/802/tr.c                                       |    1 
 net/atm/clip.c                                     |    1 
 net/ax25/af_ax25.c                                 |    1 
 net/ax25/ax25_addr.c                               |    1 
 net/ax25/ax25_dev.c                                |    1 
 net/ax25/ax25_ds_in.c                              |    1 
 net/ax25/ax25_ds_subr.c                            |    1 
 net/ax25/ax25_ds_timer.c                           |    1 
 net/ax25/ax25_iface.c                              |    1 
 net/ax25/ax25_in.c                                 |    1 
 net/ax25/ax25_ip.c                                 |    1 
 net/ax25/ax25_out.c                                |    1 
 net/ax25/ax25_route.c                              |    1 
 net/ax25/ax25_std_in.c                             |    1 
 net/ax25/ax25_std_subr.c                           |    1 
 net/ax25/ax25_std_timer.c                          |    1 
 net/ax25/ax25_subr.c                               |    1 
 net/ax25/ax25_timer.c                              |    1 
 net/ax25/ax25_uid.c                                |    1 
 net/bluetooth/bnep/sock.c                          |    1 
 net/bluetooth/cmtp/sock.c                          |    1 
 net/bluetooth/hci_conn.c                           |    1 
 net/bluetooth/hci_core.c                           |    1 
 net/bluetooth/hci_event.c                          |    1 
 net/bluetooth/hci_sock.c                           |    1 
 net/bluetooth/l2cap_core.c                         |    1 
 net/bluetooth/rfcomm/sock.c                        |    1 
 net/bluetooth/sco.c                                |    1 
 net/core/datagram.c                                |    1 
 net/core/dev.c                                     |    1 
 net/core/filter.c                                  |    1 
 net/core/gen_estimator.c                           |    1 
 net/core/rtnetlink.c                               |    1 
 net/core/scm.c                                     |    1 
 net/core/skbuff.c                                  |    1 
 net/core/sock.c                                    |    1 
 net/core/utils.c                                   |    1 
 net/decnet/af_decnet.c                             |    1 
 net/decnet/dn_dev.c                                |    1 
 net/decnet/dn_nsp_in.c                             |    1 
 net/decnet/dn_nsp_out.c                            |    1 
 net/econet/af_econet.c                             |    1 
 net/ethernet/eth.c                                 |    1 
 net/ipv4/af_inet.c                                 |    1 
 net/ipv4/arp.c                                     |    1 
 net/ipv4/devinet.c                                 |    1 
 net/ipv4/fib_frontend.c                            |    1 
 net/ipv4/fib_semantics.c                           |    1 
 net/ipv4/fib_trie.c                                |    1 
 net/ipv4/icmp.c                                    |    1 
 net/ipv4/igmp.c                                    |    1 
 net/ipv4/ip_input.c                                |    1 
 net/ipv4/ip_output.c                               |    1 
 net/ipv4/ipmr.c                                    |    1 
 net/ipv4/ping.c                                    |    1 
 net/ipv4/route.c                                   |    1 
 net/ipv4/udp.c                                     |    1 
 net/ipv6/af_inet6.c                                |    1 
 net/ipv6/icmp.c                                    |    1 
 net/ipv6/ip6mr.c                                   |    1 
 net/irda/irlan/irlan_client.c                      |    1 
 net/irda/irlan/irlan_common.c                      |    1 
 net/irda/irlan/irlan_provider.c                    |    1 
 net/irda/timer.c                                   |    1 
 net/lapb/lapb_iface.c                              |    1 
 net/lapb/lapb_in.c                                 |    1 
 net/lapb/lapb_out.c                                |    1 
 net/lapb/lapb_subr.c                               |    1 
 net/lapb/lapb_timer.c                              |    1 
 net/netfilter/ipvs/ip_vs_app.c                     |    1 
 net/netfilter/ipvs/ip_vs_proto.c                   |    1 
 net/netfilter/nfnetlink.c                          |    1 
 net/netrom/af_netrom.c                             |    1 
 net/netrom/nr_dev.c                                |    1 
 net/netrom/nr_in.c                                 |    1 
 net/netrom/nr_out.c                                |    1 
 net/netrom/nr_route.c                              |    1 
 net/netrom/nr_subr.c                               |    1 
 net/netrom/nr_timer.c                              |    1 
 net/openvswitch/datapath.c                         |    1 
 net/packet/af_packet.c                             |    1 
 net/rose/af_rose.c                                 |    1 
 net/rose/rose_dev.c                                |    1 
 net/rose/rose_in.c                                 |    1 
 net/rose/rose_link.c                               |    1 
 net/rose/rose_out.c                                |    1 
 net/rose/rose_route.c                              |    1 
 net/rose/rose_subr.c                               |    1 
 net/rose/rose_timer.c                              |    1 
 net/sunrpc/clnt.c                                  |    1 
 security/selinux/include/avc.h                     |    1 
 sound/oss/os.h                                     |    1 
 sound/oss/vidc.c                                   |    1 
 sound/oss/waveartist.c                             |    1 
 sound/pci/asihpi/hpios.h                           |    1 
 sound/pci/aw2/aw2-saa7146.c                        |    1 
 1510 files changed, 7259 insertions(+), 7757 deletions(-)
 create mode 100644 arch/alpha/include/asm/exec.h
 create mode 100644 arch/alpha/include/asm/mce.h
 create mode 100644 arch/alpha/include/asm/special_insns.h
 create mode 100644 arch/alpha/include/asm/switch_to.h
 delete mode 100644 arch/alpha/include/asm/system.h
 create mode 100644 arch/arm/include/asm/barrier.h
 create mode 100644 arch/arm/include/asm/compiler.h
 create mode 100644 arch/arm/include/asm/cr_reg.h
 create mode 100644 arch/arm/include/asm/exec.h
 create mode 100644 arch/arm/include/asm/switch_to.h
 delete mode 100644 arch/arm/include/asm/system.h
 create mode 100644 arch/arm/include/asm/system_info.h
 create mode 100644 arch/arm/include/asm/system_misc.h
 create mode 100644 arch/avr32/include/asm/barrier.h
 create mode 100644 arch/avr32/include/asm/exec.h
 create mode 100644 arch/avr32/include/asm/special_insns.h
 create mode 100644 arch/avr32/include/asm/switch_to.h
 delete mode 100644 arch/avr32/include/asm/system.h
 create mode 100644 arch/blackfin/include/asm/barrier.h
 create mode 100644 arch/blackfin/include/asm/exec.h
 create mode 100644 arch/blackfin/include/asm/special_insns.h
 create mode 100644 arch/blackfin/include/asm/switch_to.h
 delete mode 100644 arch/blackfin/include/asm/system.h
 create mode 100644 arch/c6x/include/asm/atomic.h
 create mode 100644 arch/c6x/include/asm/barrier.h
 create mode 100644 arch/c6x/include/asm/bug.h
 create mode 100644 arch/c6x/include/asm/special_insns.h
 create mode 100644 arch/c6x/include/asm/switch_to.h
 delete mode 100644 arch/c6x/include/asm/system.h
 create mode 100644 arch/cris/include/asm/barrier.h
 create mode 100644 arch/cris/include/asm/exec.h
 create mode 100644 arch/cris/include/asm/switch_to.h
 delete mode 100644 arch/cris/include/asm/system.h
 create mode 100644 arch/frv/include/asm/barrier.h
 create mode 100644 arch/frv/include/asm/exec.h
 create mode 100644 arch/frv/include/asm/special_insns.h
 create mode 100644 arch/frv/include/asm/switch_to.h
 delete mode 100644 arch/frv/include/asm/system.h
 create mode 100644 arch/h8300/include/asm/barrier.h
 create mode 100644 arch/h8300/include/asm/exec.h
 create mode 100644 arch/h8300/include/asm/switch_to.h
 delete mode 100644 arch/h8300/include/asm/system.h
 create mode 100644 arch/hexagon/include/asm/barrier.h
 create mode 100644 arch/hexagon/include/asm/exec.h
 create mode 100644 arch/hexagon/include/asm/switch_to.h
 delete mode 100644 arch/hexagon/include/asm/system.h
 create mode 100644 arch/ia64/include/asm/barrier.h
 create mode 100644 arch/ia64/include/asm/exec.h
 create mode 100644 arch/ia64/include/asm/switch_to.h
 delete mode 100644 arch/ia64/include/asm/system.h
 create mode 100644 arch/m32r/include/asm/barrier.h
 create mode 100644 arch/m32r/include/asm/dcache_clear.h
 create mode 100644 arch/m32r/include/asm/exec.h
 create mode 100644 arch/m32r/include/asm/switch_to.h
 delete mode 100644 arch/m32r/include/asm/system.h
 create mode 100644 arch/m68k/include/asm/barrier.h
 create mode 100644 arch/m68k/include/asm/exec.h
 create mode 100644 arch/m68k/include/asm/switch_to.h
 delete mode 100644 arch/m68k/include/asm/system.h
 create mode 100644 arch/microblaze/include/asm/barrier.h
 create mode 100644 arch/microblaze/include/asm/exec.h
 create mode 100644 arch/microblaze/include/asm/switch_to.h
 delete mode 100644 arch/microblaze/include/asm/system.h
 create mode 100644 arch/mips/include/asm/exec.h
 create mode 100644 arch/mips/include/asm/switch_to.h
 delete mode 100644 arch/mips/include/asm/system.h
 create mode 100644 arch/mn10300/include/asm/barrier.h
 create mode 100644 arch/mn10300/include/asm/exec.h
 create mode 100644 arch/mn10300/include/asm/switch_to.h
 delete mode 100644 arch/mn10300/include/asm/system.h
 delete mode 100644 arch/openrisc/include/asm/system.h
 create mode 100644 arch/parisc/include/asm/barrier.h
 create mode 100644 arch/parisc/include/asm/exec.h
 create mode 100644 arch/parisc/include/asm/ldcw.h
 create mode 100644 arch/parisc/include/asm/special_insns.h
 create mode 100644 arch/parisc/include/asm/switch_to.h
 delete mode 100644 arch/parisc/include/asm/system.h
 create mode 100644 arch/powerpc/include/asm/barrier.h
 create mode 100644 arch/powerpc/include/asm/debug.h
 create mode 100644 arch/powerpc/include/asm/exec.h
 create mode 100644 arch/powerpc/include/asm/switch_to.h
 delete mode 100644 arch/powerpc/include/asm/system.h
 create mode 100644 arch/s390/include/asm/barrier.h
 create mode 100644 arch/s390/include/asm/ctl_reg.h
 create mode 100644 arch/s390/include/asm/exec.h
 create mode 100644 arch/s390/include/asm/facility.h
 create mode 100644 arch/s390/include/asm/switch_to.h
 delete mode 100644 arch/s390/include/asm/system.h
 create mode 100644 arch/score/include/asm/barrier.h
 create mode 100644 arch/score/include/asm/exec.h
 create mode 100644 arch/score/include/asm/switch_to.h
 delete mode 100644 arch/score/include/asm/system.h
 create mode 100644 arch/sh/include/asm/barrier.h
 create mode 100644 arch/sh/include/asm/bl_bit.h
 create mode 100644 arch/sh/include/asm/bl_bit_32.h
 create mode 100644 arch/sh/include/asm/bl_bit_64.h
 create mode 100644 arch/sh/include/asm/cache_insns.h
 create mode 100644 arch/sh/include/asm/cache_insns_32.h
 create mode 100644 arch/sh/include/asm/cache_insns_64.h
 create mode 100644 arch/sh/include/asm/exec.h
 create mode 100644 arch/sh/include/asm/switch_to.h
 create mode 100644 arch/sh/include/asm/switch_to_32.h
 create mode 100644 arch/sh/include/asm/switch_to_64.h
 delete mode 100644 arch/sh/include/asm/system.h
 delete mode 100644 arch/sh/include/asm/system_32.h
 delete mode 100644 arch/sh/include/asm/system_64.h
 create mode 100644 arch/sh/include/asm/traps.h
 create mode 100644 arch/sh/include/asm/traps_32.h
 create mode 100644 arch/sh/include/asm/traps_64.h
 create mode 100644 arch/sparc/include/asm/barrier.h
 create mode 100644 arch/sparc/include/asm/barrier_32.h
 create mode 100644 arch/sparc/include/asm/barrier_64.h
 create mode 100644 arch/sparc/include/asm/cpu_type.h
 create mode 100644 arch/sparc/include/asm/exec.h
 create mode 100644 arch/sparc/include/asm/switch_to.h
 create mode 100644 arch/sparc/include/asm/switch_to_32.h
 create mode 100644 arch/sparc/include/asm/switch_to_64.h
 delete mode 100644 arch/sparc/include/asm/system.h
 delete mode 100644 arch/sparc/include/asm/system_32.h
 delete mode 100644 arch/sparc/include/asm/system_64.h
 create mode 100644 arch/tile/include/asm/barrier.h
 create mode 100644 arch/tile/include/asm/exec.h
 create mode 100644 arch/tile/include/asm/switch_to.h
 delete mode 100644 arch/tile/include/asm/system.h
 create mode 100644 arch/unicore32/include/asm/atomic.h
 create mode 100644 arch/unicore32/include/asm/barrier.h
 create mode 100644 arch/unicore32/include/asm/bug.h
 create mode 100644 arch/unicore32/include/asm/cr.h
 create mode 100644 arch/unicore32/include/asm/exec.h
 create mode 100644 arch/unicore32/include/asm/setup.h
 create mode 100644 arch/unicore32/include/asm/switch_to.h
 delete mode 100644 arch/unicore32/include/asm/system.h
 create mode 100644 arch/x86/include/asm/barrier.h
 create mode 100644 arch/x86/include/asm/exec.h
 create mode 100644 arch/x86/include/asm/special_insns.h
 create mode 100644 arch/x86/include/asm/switch_to.h
 delete mode 100644 arch/x86/include/asm/system.h
 create mode 100644 arch/xtensa/include/asm/barrier.h
 create mode 100644 arch/xtensa/include/asm/exec.h
 create mode 100644 arch/xtensa/include/asm/switch_to.h
 delete mode 100644 arch/xtensa/include/asm/system.h

