Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab1HBSba (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 14:31:30 -0400
Received: from mail.windriver.com ([147.11.1.11]:63972 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862Ab1HBSbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 14:31:20 -0400
Date: Tue, 2 Aug 2011 14:30:19 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: <mingo@elte.hu>, <linux-kernel@vger.kernel.org>,
        <akpm@linux-foundation.org>, <linux-arch@vger.kernel.org>,
        <sfr@canb.auug.org.au>
Subject: Re: [RFC/PULL 00/11] introduce export.h; reduce module.h usage
Message-ID: <20110802183019.GB8393@windriver.com>
References: <1311830178-30314-1-git-send-email-paul.gortmaker@windriver.com>
 <CA+55aFwtyfzaFABHKD+OMWsojGov0JLmnrZimhVaOcrer=tJjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFwtyfzaFABHKD+OMWsojGov0JLmnrZimhVaOcrer=tJjQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: [RFC/PULL 00/11] introduce export.h; reduce module.h usage] On 28/07/2011 (Thu 06:19) Linus Torvalds wrote:

> On Wed, Jul 27, 2011 at 10:16 PM, Paul Gortmaker
> <paul.gortmaker@windriver.com> wrote:
> >
> > For all 160 commits, the branch "module.h-split", available here:
> >
> >        git://git.kernel.org/pub/scm/linux/kernel/git/paulg/linux.git
> >
> > has the complete content.  I've put the header changes after all the
> > patches from the top 5 categories, so that people bisecting non related
> > issues at a later date don't get hit with a commit zone with build failures.
> 
> Ok, sounds good. Two questions:
> 
>  - how much testing (randconfig? different architectures?) has this gotten?
> 
>  - how much does this actually improve compile times (for a "normal"
> build or a "allmodconfig" one)?
> 
> It certainly sounds like the RightThing(tm) to do, but I'd like to
> know that there is real actual improvements to build times and that
> the pain won't be too bad...

Now that it has done time in linux-next, let me address the testing
and (hopefully lack of) pain part.

-testing (locally and via next) expanded to less common arch, incl. sh,
 m68k, ia64, alpha, avr32, etc. Arch owners should have little to no work.

-built every in-tree arch/*/config/*_defconfig for arm, mips, powerpc, sh
 to get coverage on target specific files.  Re-ran this several times.

-build failures in linux-next are now *less* than before module.h tree was
 added (I ended up finding/fixing some things that weren't module fallout)

-randconfig coverage: over 2000 builds, searched all build logs looking
 for module related fallout. Arch coverage was as follows:

      build:  104     powerpc
      build:  130     mips
      build:  141     arm
      build: 1000     sparc  [typically builds fast w/ a randconfig]
      build:  171     x86_64
      build:  179     x86
      build:  157     sh
      build:  274     m68k

Given it is summmer, vacation, later in the merge window, I'd not blame
you if you decided you'd rather defer the pull to 3.2.  But if you don't,
thanks to Stephen's work, here is exatly what you can expect after pull.

Patches for things pending in next, but not yet in your tree:
   md: include export.h to use EXPORT_SYMBOL (new files in persistent-data)
   block: bsg-lib.c needs export.h (Jens may fix; block tree interaction)

Patches for files recently added to your tree but not in my baseline:
   power: max8998_charger.c needs module.h
   regulator: aat2870 needs module.h
   power_supply: max8997_charger.c need to include module.h

The latter group I could have fixed if I rebased to latest, but I didn't
want to invalidate my latest testing.  If you see commits with a recent
"applied" time, note that they are only the result of cosmetic header
updates, etc.  -- since I've consistently confirmed that:

    "git diff validated-tested-branch cosmetic-updated-branch"

comes up empty so that I know the testing value is 100% preserved.

If you don't want it now, it would be nice to get my one first inert
commit which creates export.h in the tree.  Then I could start feeding
some of the other bits through maintainer trees for 3.2.

Thanks,
Paul.

---

The following changes since commit 250f8e3db646028353a2a737ddb7a894c97a1098:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial (2011-07-30 10:51:11 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulg/linux.git module.h-split

Heiko Carstens (1):
      s390: add missing module.h/export.h includes

Mark Brown (1):
      cpufreq: Fix build of s3c64xx cpufreq driver for header change

Paul Gortmaker (194):
      module.h: split out the EXPORT_SYMBOL into export.h
      range: fix bogus misuse of module.h to get printk()
      vermagic: delete senseless include of <linux/module.h>
      mm: delete various needless include <linux/module.h>
      mm: Add export.h for EXPORT_SYMBOL to active symbol exporters
      kernel: Map most files to use export.h instead of module.h
      kernel: Add <linux/module.h> to files using it implicitly
      kernel: fix implicit use of kmod.h in power/suspend.c
      kernel: fix two implicit header assumptions in irq_work.c
      kernel: sys.c implicitly relies on kmod.h for usermodehelper
      kernel: ksysfs.c is implicitly using stat.h
      kernel: params/rcutiny needs module.h not moduleparam.h
      kernel: Fix files explicitly needing EXPORT_SYMBOL infrastructure
      net: rfkill/input.c explicitly needs to include module.h
      net: Add export.h for EXPORT_SYMBOL/THIS_MODULE to non-modules
      fs: add export.h to files using EXPORT_SYMBOL/THIS_MODULE macros
      fs: add module.h to files that were implicitly using it
      acpi: add module.h to files implicitly using/relying on it.
      acpi: revector aclinux.h from module.h to export.h
      acpi: sysfs.c needs module.h and not just moduleparam.h
      x86: fix implicit include of <linux/topology.h> in vsyscall_64
      x86: Fix files explicitly requiring export.h for EXPORT_SYMBOL/THIS_MODULE
      x86: fix up files really needing to include module.h
      x86: efi_32.c is implicitly getting asm/desc.h via module.h
      powerpc: io-workarounds.c was implicitly getting init_mm
      powerpc: add export.h to files making use of EXPORT_SYMBOL
      powerpc: Fix up modules that should be including module.h
      powerpc: Fix up implicit stat.h users
      powerpc: Fix up implicit sched.h users
      powerpc: cell/beat_wrapper.h is implicitly using memcpy functions
      powerpc: fix implicit notifier use in converting to export.h
      powerpc: fix implicit use of cache.h in kernel/firmware.c
      powerpc: fix implicit use of mutex.h by include/asm/spu.h
      powerpc: fix two implicit header uses in pseries/plpar_wrappers.h
      powerpc: convert hvconsole.c to export.h ; fix implicit use of errno.h
      powerpc: various straight conversions from module.h --> export.h
      powerpc: remove non-required uses of include <linux/module.h>
      arm: add elf.h to arch/arm/kernel/ptrace.c
      arm: fix implicit memset usage in mach-omap2 platform
      arm: fix implicit usage of string.h in kernel/leds.c
      arm: fix implicit use of asm/sizes.h in plat-s5p/plat-samsung
      arm: fix implicit use of page.h in mach-bcmring/mach-jornada
      arm: fix implicit use of PAGE_SHIFT in collie.c
      arm: fix implicit use of hardware.h in ehci-mxc.c
      arm: fix implicit use of moduleparam in mach-mx31*.c
      arm: fix implicit use of sched.h in bcmring/dma.c
      arm: add slab.h to plat-samsung files for GFP_KERNEL
      arm: add asm/vga.h to mach-footbridge/dc21285.c
      arm fix implicit asm/vga.h use in mach-orion5x/pci.c
      arm: remove several unnecessary module.h include instances
      arm: convert core files from module.h to export.h
      arm: Add export.h to ARM specific files as required.
      arm: fix implicit users by adding module.h to arch/arm as required.
      sparc: fix implicit use of spitfire.h in pcr.c and of_device_64.c
      sparc: add export.h to various arch/sparc/[kernel|mm] files
      sparc: move symbol exporters to use export.h not module.h
      sparc: remove several unnecessary module.h include instances
      sparc: Add module.h to files previously implicitly using it.
      mips: fix implicit use of asm/elf.h in kernel/cpu-probe.c
      mips: fix implicit smp.h usage in loongson/common/platform.c
      mips: vr41xx/ implicitly uses smp.h in giu.c and rtc.c
      mips: migrate core kernel file from module.h --> export.h
      mips: remove needless include of module.h from core kernel files.
      mips: add export.h to files using EXPORT_SYMBOL/THIS_MODULE
      ia64: Add export.h to arch/ia64 specific files as required
      m68k: Add export.h to the m68k specific files as required
      avr32: add export.h to arch/avr32 for EXPORT_SYMBOL/THIS_MODULE
      parisc: Add export.h to files needing EXPORT_SYMBOL/THIS_MODULE
      alpha: fix implicit stat.h usage in pci-sysfs.c
      alpha: Add export.h for THIS_MODULE/EXPORT_SYMBOL
      sh: fix implicit use of stat.h in arch/sh specific files
      sh: Add module.h to arch/sh specific files as required.
      sh: Add export.h to arch/sh specific files as required.
      drivers/net: Add module.h to drivers who were implicitly using it
      drivers/net: Add export.h to mlx4 files using EXPORT_SYMBOL
      crypto: add module.h to those files that are explicitly using it
      mtd: Add export.h for EXPORT_SYMBOL/THIS_MODULE where needed
      mtd: Add module.h to drivers users that were implicitly using it.
      block: add export.h to files using EXPORT_SYMBOL/THIS_MODULE macros
      block: Fix files that are modules and hence need module.h
      of_platform.h: delete needless include <linux/module.h>
      of: of_pci.c needs export.h since it uses EXPORT_SYMBOLS
      drivers/base: transport_class explicitly requires EXPORT_SYMBOL
      drivers: power_supply_sysfs.c needs stat.h
      drivers/input: Add module.h to modular drivers implicitly using it
      hid: Add module.h to fix up implicit users of it
      hid: Fix up files needing export.h for EXPORT_SYMBOL
      md: Add module.h to all files using it implicitly
      md: Add in export.h for files using EXPORT_SYMBOL
      sound: fix drivers needing module.h not moduleparam.h
      sound: Add module.h to the previously silent sound users
      sound: Add export.h for THIS_MODULE/EXPORT_SYMBOL where needed
      pci: Fix files needing export.h since they use EXPORT_SYMBOL
      pci: add module.h to files implicitly relying on its presence.
      scsi: Fix files needing export.h since they use EXPORT_SYMBOL
      scsi: Fix up files implicitly depending on module.h inclusion
      usb: Add module.h to drivers/usb consumers who really use it.
      usb: Add export.h for EXPORT_SYMBOL/THIS_MODULE where needed
      usb: fix implicit usage of gfp.h in host/xhci-hub.c
      tty: Add module.h to drivers/tty users who just expect it there.
      tty: Add export.h for EXPORT_SYMBOL/THIS_MODULE to exporters
      rtc: Add module.h to implicit users in drivers/rtc
      i2c: add export.h to i2c-boardinfo.c for EXPORT_SYMBOL
      cpufreq: cpufreq_stats.c is a module, and should include module.h
      selinux: netlink.c uses THIS_MODULE; give it assoc. header
      video: Add export.h for THIS_MODULE/EXPORT_SYMBOL to drivers/video
      video: Add module.h to drivers/video files who really use it.
      infiniband: Fix up users implicitly relying on getting stat.h
      infiniband: Fix up module files that need to include module.h
      infiniband: add in export.h for files using EXPORT_SYMBOL/THIS_MODULE
      ide/ata: Add export.h for EXPORT_SYMBOL/THIS_MODULE where needed
      ide/ata: Add module.h to the implicit modular users
      drivers/base: Fix various files needing export.h for EXPORT_SYMBOL
      drivers/base: dma-coherent.c is a module and needs module.h
      drivers/base: base.h implicitly depends on <linux/notifier.h>
      drivers/char: Add module.h to those who were using it implicitly
      drivers/char: Add export.h for THIS_MODULE to ttyprintk.c
      drivers/char: Fix implicit use of err.h in ramoops.c
      drivers/clocksource: Add module.h to those who were using it implicitly
      drivers/dca: Add module.h to dca-core.c
      drivers/dca: Add export.h for THIS_MODULE to dca-sysfs.c
      drivers/dma: Add module.h to ipu/ipu_idmac.c
      drivers/dma: Add export.h to ste_dma40.c
      drivers/edac: Add module.h to mce_amd_inj.c
      drivers/firewire: Add export.h for EXPORT_SYMBOL to core-iso.c
      drivers/firmware: Add module.h to google/gsmi.c
      drivers/firmware: Add export.h for EXPORT_SYMBOL to sigma.c
      drivers/gpio: Fix drivers who are implicit users of module.h
      drivers/hwmon: add module.h to ultra45_env.c
      drivers/isdn: Add export.h for THIS_MODULE to capi/kcapi_proc.c
      drivers/leds: Add module.h to files using it implicitly
      drivers/leds: Add export.h for THIS_MODULE to leds-cobalt-raq.c
      drivers/media: Add export.h for EXPORT_SYMBOL/THIS_MODULE as required
      drivers/media: Add module.h to all files using it implicitly
      drivers/memstick: Add module.h to the prev. implicit modular users
      drivers/message: Add module.h to i2o/pci.c
      drivers/misc: Add module.h to files who are really modular.
      drivers/misc: Add export.h for EXPORT_SYMBOL to atmel_tclib.c
      drivers/power: Add module.h to the actual modules in drivers/power
      drivers/rapidio: Fix up it implicitly relying on getting stat.h
      drivers/sh: Add export.h for EXPORT_SYMBOL to intc/virq.c
      drivers/w1: Add export.h for EXPORT_SYMBOL to w1_family.c
      drivers/zorro: Add export.h to proc.c
      ssb: Add module.h to the real modules in drivers/ssb
      ssb: Add export.h to files using EXPORT_SYMBOL/THIS_MODULE
      uio: Add module.h to implicit drivers/uio users
      bcma: add module.h to the modular portions of this driver
      bcma: fix implicit use of export.h contents
      mfd: Add module.h to the implicit drivers/mfd users
      mfd: Add export.h for EXPORT_SYMBOL/THIS_MODULE as required
      mmc: Add module.h to drivers/mmc users assuming implicit presence.
      mmc: Add export.h for EXPORT_SYMBOL/THIS_MODULE as required
      mmc: Fix implicit use of stat.h header in associated files
      staging: ft1000_proc needs asm/io.h for inw/outw on sparc
      staging: fix implicit use of slab.h in dt3155v4l/dt3155v4l.c
      staging: Add module.h to drivers/staging users
      staging: Add export.h for THIS_MODULE/EXPORT_SYMBOL to drivers/staging users.
      scsi: Add module.h to drivers/scsi users who really need it.
      scsi: Add export.h for EXPORT_SYMBOL/THIS_MODULE as required
      xen: Add module.h to modular drivers/xen users.
      xen: Add export.h for THIS_MODULE/EXPORT_SYMBOL to various xen users.
      xen: fix implicit stat.h/module.h include usage in xen-selfballoon.c
      kvm: fix implicit use of stat.h header file
      kvm: iommu.c file requires the full module.h present.
      lguest: add export.h to lguest_device.c for THIS_MODULE
      virtio: Add module.h to drivers/virtio users.
      pci: Add module.h to hotplug/pciehp_acpi.c
      pci: pci-sysfs.c needs export.h for THIS_MODULE
      regulator: Add export.h for THIS_MODULE to dummy.c
      regulator: Add module.h to drivers/regulator users as required
      regulator: Fix implicit use of notifier.h by driver.h
      spi: Add module.h to implicit users in drivers/spi
      spi: spi-au1550.c was implicitly using module.h
      spi: Add export.h for THIS_MODULE/EXPORT_SYMBOL to spi.c
      drivers/of: Add module.h to of_spi.c
      drivers/uwb: fix implicit use of stat.h
      uwb: Add module.h to the real uwb modular users.
      uwb: Add export.h for EXPORT_SYMBOL/THIS_MODULE as required
      drm: Add export.h for EXPORT_SYMBOL to ttm/ttm_tt.c
      pcmcia: add module.h to db1xxx_ss.c since it is modular.
      pcmcia: Add export.h to drivers/pcmcia as required.
      lib: dma-debug needs export.h for EXPORT_SYMBOL
      sysdev.h: dont include <linux/module.h> for no reason
      net: inet_timewait_sock doesnt need <linux/module.h>
      device_cgroup.h: delete needless include <linux/module.h>
      crypto.h: remove unused crypto_tfm_alg_modname() inline
      linux/stop_machine.h: fix implicit use of smp.h for smp_processor_id
      pm_runtime.h: explicitly requires notifier.h
      uwb.h: fix implicit use of asm/page.h for PAGE_SIZE
      net: sch_generic remove redundant use of <linux/module.h>
      include: convert various register fcns to macros to avoid include chaining
      include: replace linux/module.h with "struct module" wherever possible
      sh: Fix conflicting definitions of ptrace_triggered
      arm: fix compile failure in orion5x/dns323-setup.c

Randy Dunlap (2):
      i2c: Add module.h to modular files prev. implicitly getting it
      drivers/sfi: sfi_acpi.c needs sysfs.h

Stephen Rothwell (4):
      powerpc: include export.h for files using EXPORT_SYMBOL/THIS_MODULE
      drivers/media: ir-raw.c needs kmod.h for request_module
      drivers/of: include export.h for EXPORT_SYMBOL_GPL in of_pci_irq.c
      linux/dmaengine.h needs bitmap.h and asm/page.h

 arch/alpha/kernel/core_irongate.c                  |    1 +
 arch/alpha/kernel/pci-sysfs.c                      |    1 +
 arch/alpha/kernel/setup.c                          |    1 +
 arch/arm/common/it8152.c                           |    1 +
 arch/arm/common/scoop.c                            |    1 +
 arch/arm/kernel/armksyms.c                         |    2 +-
 arch/arm/kernel/bios32.c                           |    2 +-
 arch/arm/kernel/devtree.c                          |    2 +-
 arch/arm/kernel/elf.c                              |    2 +-
 arch/arm/kernel/io.c                               |    2 +-
 arch/arm/kernel/irq.c                              |    1 -
 arch/arm/kernel/leds.c                             |    3 +-
 arch/arm/kernel/perf_event.c                       |    2 +-
 arch/arm/kernel/pj4-cp0.c                          |    1 -
 arch/arm/kernel/process.c                          |    2 +-
 arch/arm/kernel/ptrace.c                           |    1 +
 arch/arm/kernel/return_address.c                   |    2 +-
 arch/arm/kernel/setup.c                            |    2 +-
 arch/arm/kernel/stacktrace.c                       |    2 +-
 arch/arm/kernel/sys_arm.c                          |    2 +-
 arch/arm/kernel/time.c                             |    2 +-
 arch/arm/kernel/unwind.c                           |    2 +-
 arch/arm/kernel/xscale-cp0.c                       |    1 -
 arch/arm/mach-at91/cpuidle.c                       |    1 +
 arch/arm/mach-bcmring/dma.c                        |    1 +
 arch/arm/mach-bcmring/mm.c                         |    1 +
 arch/arm/mach-davinci/board-dm644x-evm.c           |    1 +
 arch/arm/mach-davinci/board-dm646x-evm.c           |    1 +
 arch/arm/mach-davinci/cdce949.c                    |    1 +
 arch/arm/mach-davinci/cpufreq.c                    |    1 +
 arch/arm/mach-davinci/cpuidle.c                    |    1 +
 arch/arm/mach-ep93xx/core.c                        |    1 +
 arch/arm/mach-exynos4/dev-sysmmu.c                 |    1 +
 arch/arm/mach-footbridge/dc21285.c                 |    1 +
 arch/arm/mach-imx/mach-mx31lilly.c                 |    1 +
 arch/arm/mach-imx/mach-mx31lite.c                  |    1 +
 arch/arm/mach-imx/mach-mx31moboard.c               |    1 +
 arch/arm/mach-iop13xx/pci.c                        |    1 +
 arch/arm/mach-ixp2000/core.c                       |    1 +
 arch/arm/mach-ixp4xx/common-pci.c                  |    1 +
 arch/arm/mach-ixp4xx/common.c                      |    1 +
 arch/arm/mach-kirkwood/cpuidle.c                   |    1 +
 arch/arm/mach-msm/io.c                             |    1 +
 arch/arm/mach-netx/xc.c                            |    1 +
 arch/arm/mach-omap1/board-ams-delta.c              |    1 +
 arch/arm/mach-omap1/board-sx1.c                    |    1 +
 arch/arm/mach-omap1/board-voiceblue.c              |    1 +
 arch/arm/mach-omap1/mailbox.c                      |    1 +
 arch/arm/mach-omap2/board-omap3evm.c               |    1 +
 arch/arm/mach-omap2/clockdomain.c                  |    1 +
 arch/arm/mach-omap2/display.c                      |    1 +
 arch/arm/mach-omap2/gpmc-onenand.c                 |    1 +
 arch/arm/mach-omap2/pm.c                           |    1 +
 arch/arm/mach-omap2/prcm.c                         |    1 +
 arch/arm/mach-omap2/usb-tusb6010.c                 |    2 +
 arch/arm/mach-omap2/voltage.c                      |    1 +
 arch/arm/mach-orion5x/dns323-setup.c               |    2 +-
 arch/arm/mach-orion5x/pci.c                        |    1 +
 arch/arm/mach-pxa/corgi.c                          |    1 +
 arch/arm/mach-pxa/poodle.c                         |    1 +
 arch/arm/mach-pxa/spitz.c                          |    1 +
 arch/arm/mach-s3c2410/mach-h1940.c                 |    1 +
 arch/arm/mach-s3c64xx/dev-audio.c                  |    1 +
 arch/arm/mach-sa1100/collie.c                      |    1 +
 arch/arm/mach-sa1100/jornada720.c                  |    1 +
 arch/arm/mach-shmobile/clock.c                     |    1 +
 arch/arm/mach-tegra/pcie.c                         |    1 +
 arch/arm/mm/fault-armv.c                           |    1 -
 arch/arm/mm/init.c                                 |    1 +
 arch/arm/plat-iop/gpio.c                           |    1 +
 arch/arm/plat-iop/time.c                           |    1 +
 arch/arm/plat-omap/clock.c                         |    1 +
 arch/arm/plat-omap/mailbox.c                       |    1 +
 arch/arm/plat-s3c24xx/devs.c                       |    1 +
 arch/arm/plat-s5p/dev-ehci.c                       |    1 +
 arch/arm/plat-s5p/dev-onenand.c                    |    2 +
 arch/arm/plat-samsung/dev-adc.c                    |    2 +
 arch/arm/plat-samsung/dev-asocdma.c                |    1 +
 arch/arm/plat-samsung/dev-backlight.c              |    1 +
 arch/arm/plat-samsung/dev-ide.c                    |    2 +
 arch/arm/plat-samsung/dev-nand.c                   |    1 +
 arch/arm/plat-samsung/dev-pwm.c                    |    1 +
 arch/arm/plat-samsung/dev-rtc.c                    |    1 +
 arch/arm/plat-samsung/dev-ts.c                     |    2 +
 arch/arm/plat-samsung/dev-usb.c                    |    1 +
 arch/arm/plat-samsung/dev-wdt.c                    |    3 +
 arch/arm/plat-samsung/platformdata.c               |    1 +
 arch/arm/vfp/vfpmodule.c                           |    1 -
 arch/avr32/mach-at32ap/clock.c                     |    1 +
 arch/avr32/mach-at32ap/cpufreq.c                   |    1 +
 arch/avr32/mach-at32ap/intc.c                      |    1 +
 arch/avr32/mach-at32ap/pio.c                       |    1 +
 arch/avr32/mm/dma-coherent.c                       |    1 +
 arch/ia64/hp/common/hwsw_iommu.c                   |    1 +
 arch/ia64/kernel/dma-mapping.c                     |    1 +
 arch/ia64/kernel/topology.c                        |    1 +
 arch/ia64/sn/kernel/io_init.c                      |    1 +
 arch/ia64/sn/pci/pcibr/pcibr_dma.c                 |    1 +
 arch/ia64/sn/pci/pcibr/pcibr_provider.c            |    1 +
 arch/ia64/sn/pci/tioca_provider.c                  |    1 +
 arch/m68k/atari/time.c                             |    1 +
 arch/m68k/kernel/dma_mm.c                          |    1 +
 arch/m68k/kernel/dma_no.c                          |    1 +
 arch/mips/bcm47xx/gpio.c                           |    1 +
 arch/mips/bcm47xx/setup.c                          |    1 +
 arch/mips/cavium-octeon/csrc-octeon.c              |    1 +
 arch/mips/cavium-octeon/dma-octeon.c               |    1 +
 arch/mips/cavium-octeon/flash_setup.c              |    1 +
 arch/mips/kernel/8250-platform.c                   |    1 -
 arch/mips/kernel/cpu-probe.c                       |    3 +-
 arch/mips/kernel/i8253.c                           |    2 +-
 arch/mips/kernel/init_task.c                       |    2 +-
 arch/mips/kernel/irq-msc01.c                       |    1 -
 arch/mips/kernel/irq.c                             |    1 -
 arch/mips/kernel/mips-mt.c                         |    2 +-
 arch/mips/kernel/mips_ksyms.c                      |    2 +-
 arch/mips/kernel/module.c                          |    1 -
 arch/mips/kernel/process.c                         |    2 +-
 arch/mips/kernel/prom.c                            |    2 +-
 arch/mips/kernel/reset.c                           |    2 +-
 arch/mips/kernel/rtlx.c                            |    1 -
 arch/mips/kernel/setup.c                           |    2 +-
 arch/mips/kernel/spinlock_test.c                   |    2 +-
 arch/mips/kernel/stacktrace.c                      |    2 +-
 arch/mips/kernel/time.c                            |    2 +-
 arch/mips/kernel/traps.c                           |    1 -
 arch/mips/kernel/unaligned.c                       |    1 -
 arch/mips/kernel/vpe.c                             |    1 -
 arch/mips/loongson/common/platform.c               |    1 +
 arch/mips/pci/pci-ip27.c                           |    1 +
 arch/mips/pci/pci.c                                |    1 +
 arch/mips/powertv/pci/fixup-powertv.c              |    1 +
 arch/mips/powertv/powertv-usb.c                    |    1 +
 arch/mips/rb532/gpio.c                             |    1 +
 arch/mips/rb532/setup.c                            |    1 +
 arch/mips/txx9/generic/spi_eeprom.c                |    1 +
 arch/mips/txx9/rbtx4939/setup.c                    |    1 +
 arch/mips/vr41xx/common/giu.c                      |    1 +
 arch/mips/vr41xx/common/rtc.c                      |    1 +
 arch/parisc/kernel/drivers.c                       |    1 +
 arch/parisc/kernel/pci-dma.c                       |    1 +
 arch/parisc/kernel/setup.c                         |    1 +
 arch/parisc/lib/iomap.c                            |    1 +
 arch/powerpc/include/asm/lv1call.h                 |    1 +
 arch/powerpc/include/asm/machdep.h                 |    1 +
 arch/powerpc/include/asm/spu.h                     |    1 +
 arch/powerpc/kernel/btext.c                        |    2 +-
 arch/powerpc/kernel/clock.c                        |    2 +-
 arch/powerpc/kernel/cputable.c                     |    2 +-
 arch/powerpc/kernel/crash.c                        |    1 +
 arch/powerpc/kernel/dma-iommu.c                    |    1 +
 arch/powerpc/kernel/dma.c                          |    1 +
 arch/powerpc/kernel/firmware.c                     |    3 +-
 arch/powerpc/kernel/hw_breakpoint.c                |    1 -
 arch/powerpc/kernel/ibmebus.c                      |    2 +
 arch/powerpc/kernel/init_task.c                    |    2 +-
 arch/powerpc/kernel/io-workarounds.c               |    1 +
 arch/powerpc/kernel/io.c                           |    2 +-
 arch/powerpc/kernel/iomap.c                        |    1 +
 arch/powerpc/kernel/irq.c                          |    2 +-
 arch/powerpc/kernel/isa-bridge.c                   |    1 +
 arch/powerpc/kernel/kvm.c                          |    1 +
 arch/powerpc/kernel/module.c                       |    1 -
 arch/powerpc/kernel/of_platform.c                  |    2 +-
 arch/powerpc/kernel/paca.c                         |    2 +-
 arch/powerpc/kernel/pci-common.c                   |    1 +
 arch/powerpc/kernel/pci_32.c                       |    1 +
 arch/powerpc/kernel/pci_64.c                       |    1 +
 arch/powerpc/kernel/pci_dn.c                       |    1 +
 arch/powerpc/kernel/pci_of_scan.c                  |    1 +
 arch/powerpc/kernel/pmc.c                          |    2 +-
 arch/powerpc/kernel/ppc_ksyms.c                    |    2 +-
 arch/powerpc/kernel/process.c                      |    2 +-
 arch/powerpc/kernel/prom.c                         |    2 +-
 arch/powerpc/kernel/prom_parse.c                   |    1 -
 arch/powerpc/kernel/ptrace.c                       |    1 -
 arch/powerpc/kernel/rtas.c                         |    2 +-
 arch/powerpc/kernel/setup-common.c                 |    2 +-
 arch/powerpc/kernel/setup_64.c                     |    2 +-
 arch/powerpc/kernel/signal_64.c                    |    1 -
 arch/powerpc/kernel/smp.c                          |    2 +-
 arch/powerpc/kernel/stacktrace.c                   |    2 +-
 arch/powerpc/kernel/swsusp_64.c                    |    1 +
 arch/powerpc/kernel/sysfs.c                        |    2 +-
 arch/powerpc/kernel/time.c                         |    2 +-
 arch/powerpc/kernel/vdso.c                         |    1 -
 arch/powerpc/kernel/vio.c                          |    3 +-
 arch/powerpc/kvm/44x.c                             |    1 +
 arch/powerpc/kvm/book3s.c                          |    1 +
 arch/powerpc/kvm/book3s_exports.c                  |    2 +-
 arch/powerpc/kvm/book3s_hv.c                       |    1 +
 arch/powerpc/kvm/book3s_hv_builtin.c               |    1 +
 arch/powerpc/kvm/book3s_pr.c                       |    1 +
 arch/powerpc/kvm/powerpc.c                         |    1 -
 arch/powerpc/lib/checksum_wrappers_64.c            |    2 +-
 arch/powerpc/lib/devres.c                          |    2 +-
 arch/powerpc/lib/locks.c                           |    2 +-
 arch/powerpc/lib/rheap.c                           |    2 +-
 arch/powerpc/mm/dma-noncoherent.c                  |    1 +
 arch/powerpc/mm/hash_utils_64.c                    |    1 +
 arch/powerpc/mm/mem.c                              |    2 +-
 arch/powerpc/mm/mmu_context_hash32.c               |    1 +
 arch/powerpc/mm/mmu_context_hash64.c               |    2 +-
 arch/powerpc/mm/numa.c                             |    2 +-
 arch/powerpc/mm/pgtable_64.c                       |    1 +
 arch/powerpc/mm/slice.c                            |    2 +-
 arch/powerpc/mm/tlb_hash32.c                       |    1 +
 arch/powerpc/mm/tlb_nohash.c                       |    1 +
 arch/powerpc/platforms/44x/warp.c                  |    1 +
 arch/powerpc/platforms/512x/clock.c                |    1 +
 arch/powerpc/platforms/52xx/mpc52xx_common.c       |    1 +
 arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c      |    1 +
 arch/powerpc/platforms/83xx/suspend.c              |    1 +
 arch/powerpc/platforms/85xx/mpc85xx_cds.c          |    1 -
 arch/powerpc/platforms/85xx/mpc85xx_mds.c          |    1 -
 arch/powerpc/platforms/85xx/sbc8548.c              |    1 -
 arch/powerpc/platforms/86xx/gef_gpio.c             |    1 +
 arch/powerpc/platforms/8xx/tqm8xx_setup.c          |    1 -
 arch/powerpc/platforms/cell/axon_msi.c             |    1 +
 arch/powerpc/platforms/cell/beat.c                 |    2 +-
 arch/powerpc/platforms/cell/beat_spu_priv1.c       |    2 -
 arch/powerpc/platforms/cell/beat_wrapper.h         |    1 +
 arch/powerpc/platforms/cell/cbe_cpufreq.c          |    1 +
 arch/powerpc/platforms/cell/cbe_cpufreq_pmi.c      |    1 +
 arch/powerpc/platforms/cell/cbe_powerbutton.c      |    1 +
 arch/powerpc/platforms/cell/cbe_regs.c             |    2 +-
 arch/powerpc/platforms/cell/celleb_setup.c         |    1 +
 arch/powerpc/platforms/cell/cpufreq_spudemand.c    |    1 +
 arch/powerpc/platforms/cell/interrupt.c            |    2 +-
 arch/powerpc/platforms/cell/pmu.c                  |    1 +
 arch/powerpc/platforms/cell/qpace_setup.c          |    1 +
 arch/powerpc/platforms/cell/setup.c                |    1 +
 arch/powerpc/platforms/cell/smp.c                  |    1 -
 arch/powerpc/platforms/cell/spu_callbacks.c        |    2 +-
 arch/powerpc/platforms/cell/spu_fault.c            |    2 +-
 arch/powerpc/platforms/cell/spu_manage.c           |    2 +-
 arch/powerpc/platforms/cell/spu_notify.c           |    3 +-
 arch/powerpc/platforms/cell/spu_priv1_mmio.c       |    1 -
 arch/powerpc/platforms/cell/spufs/backing_ops.c    |    1 -
 arch/powerpc/platforms/cell/spufs/context.c        |    2 +-
 arch/powerpc/platforms/cell/spufs/coredump.c       |    1 -
 arch/powerpc/platforms/cell/spufs/fault.c          |    1 -
 arch/powerpc/platforms/cell/spufs/file.c           |    2 +-
 arch/powerpc/platforms/cell/spufs/hw_ops.c         |    1 -
 arch/powerpc/platforms/cell/spufs/sched.c          |    1 -
 arch/powerpc/platforms/cell/spufs/switch.c         |    2 +-
 arch/powerpc/platforms/cell/spufs/syscalls.c       |    2 +-
 arch/powerpc/platforms/embedded6xx/holly.c         |    1 +
 arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c  |    1 +
 arch/powerpc/platforms/iseries/hvlpconfig.c        |    2 +-
 arch/powerpc/platforms/iseries/iommu.c             |    2 +-
 arch/powerpc/platforms/iseries/ksyms.c             |    2 +-
 arch/powerpc/platforms/iseries/lpardata.c          |    1 -
 arch/powerpc/platforms/iseries/lpevents.c          |    2 +-
 arch/powerpc/platforms/iseries/mf.c                |    1 +
 arch/powerpc/platforms/iseries/pci.c               |    1 -
 arch/powerpc/platforms/iseries/setup.c             |    1 +
 arch/powerpc/platforms/iseries/smp.c               |    1 -
 arch/powerpc/platforms/iseries/vio.c               |    2 +-
 arch/powerpc/platforms/iseries/viopath.c           |    2 +-
 arch/powerpc/platforms/maple/setup.c               |    1 +
 arch/powerpc/platforms/pasemi/cpufreq.c            |    1 +
 arch/powerpc/platforms/pasemi/dma_lib.c            |    3 +-
 arch/powerpc/platforms/pasemi/setup.c              |    1 +
 arch/powerpc/platforms/powermac/backlight.c        |    1 +
 arch/powerpc/platforms/powermac/feature.c          |    1 +
 arch/powerpc/platforms/powermac/low_i2c.c          |    2 +-
 arch/powerpc/platforms/powermac/nvram.c            |    2 +-
 arch/powerpc/platforms/powermac/pic.c              |    1 -
 arch/powerpc/platforms/powermac/setup.c            |    1 +
 arch/powerpc/platforms/ps3/exports.c               |    2 -
 arch/powerpc/platforms/ps3/interrupt.c             |    2 +-
 arch/powerpc/platforms/ps3/mm.c                    |    2 +-
 arch/powerpc/platforms/ps3/os-area.c               |    1 +
 arch/powerpc/platforms/ps3/setup.c                 |    1 +
 arch/powerpc/platforms/ps3/spu.c                   |    1 +
 arch/powerpc/platforms/ps3/system-bus.c            |    2 +-
 arch/powerpc/platforms/pseries/eeh.c               |    2 +
 arch/powerpc/platforms/pseries/eeh_event.c         |    1 +
 arch/powerpc/platforms/pseries/eeh_sysfs.c         |    1 +
 arch/powerpc/platforms/pseries/hotplug-cpu.c       |    1 +
 arch/powerpc/platforms/pseries/hvconsole.c         |    3 +-
 arch/powerpc/platforms/pseries/io_event_irq.c      |    2 +-
 arch/powerpc/platforms/pseries/iommu.c             |    1 +
 arch/powerpc/platforms/pseries/lpar.c              |    1 +
 arch/powerpc/platforms/pseries/mobility.c          |    1 +
 arch/powerpc/platforms/pseries/pci_dlpar.c         |    1 +
 arch/powerpc/platforms/pseries/plpar_wrappers.h    |    3 +
 arch/powerpc/platforms/pseries/setup.c             |    2 +-
 arch/powerpc/platforms/pseries/smp.c               |    1 -
 arch/powerpc/platforms/pseries/suspend.c           |    1 +
 arch/powerpc/sysdev/bestcomm/sram.c                |    2 +-
 arch/powerpc/sysdev/cpm_common.c                   |    1 +
 arch/powerpc/sysdev/dcr.c                          |    1 +
 arch/powerpc/sysdev/fsl_gtm.c                      |    1 +
 arch/powerpc/sysdev/fsl_lbc.c                      |    3 +-
 arch/powerpc/sysdev/fsl_pmc.c                      |    1 +
 arch/powerpc/sysdev/fsl_rio.c                      |    2 +-
 arch/powerpc/sysdev/fsl_soc.c                      |    2 +-
 arch/powerpc/sysdev/mpc5xxx_clocks.c               |    1 +
 arch/powerpc/sysdev/mpc8xx_pic.c                   |    1 -
 arch/powerpc/sysdev/mv64x60_pci.c                  |    1 +
 arch/powerpc/sysdev/pmi.c                          |    1 +
 arch/powerpc/sysdev/ppc4xx_msi.c                   |    1 +
 arch/powerpc/sysdev/qe_lib/gpio.c                  |    1 +
 arch/powerpc/sysdev/qe_lib/ucc.c                   |    2 +-
 arch/powerpc/sysdev/qe_lib/ucc_fast.c              |    2 +-
 arch/powerpc/sysdev/qe_lib/ucc_slow.c              |    2 +-
 arch/powerpc/sysdev/qe_lib/usb.c                   |    1 +
 arch/powerpc/sysdev/rtc_cmos_setup.c               |    1 +
 arch/powerpc/sysdev/scom.c                         |    1 +
 arch/powerpc/sysdev/simple_gpio.c                  |    1 -
 arch/powerpc/sysdev/tsi108_dev.c                   |    2 +-
 arch/powerpc/xmon/xmon.c                           |    2 +-
 arch/s390/crypto/sha_common.c                      |    1 +
 arch/s390/mm/init.c                                |    1 +
 arch/sh/drivers/dma/dma-sysfs.c                    |    1 +
 arch/sh/drivers/pci/pci.c                          |    1 +
 arch/sh/include/asm/ptrace.h                       |    2 +-
 arch/sh/kernel/cpu/shmobile/cpuidle.c              |    1 +
 arch/sh/kernel/perf_event.c                        |    1 +
 arch/sh/kernel/topology.c                          |    1 +
 arch/sh/mm/init.c                                  |    1 +
 arch/sparc/include/asm/termios.h                   |    1 -
 arch/sparc/kernel/auxio_32.c                       |    1 +
 arch/sparc/kernel/btext.c                          |    1 -
 arch/sparc/kernel/central.c                        |    1 +
 arch/sparc/kernel/cpu.c                            |    2 +-
 arch/sparc/kernel/cpumap.c                         |    2 +-
 arch/sparc/kernel/dma.c                            |    1 -
 arch/sparc/kernel/ebus.c                           |    2 +-
 arch/sparc/kernel/hvapi.c                          |    2 +-
 arch/sparc/kernel/idprom.c                         |    2 +-
 arch/sparc/kernel/iommu.c                          |    2 +-
 arch/sparc/kernel/irq_32.c                         |    1 +
 arch/sparc/kernel/irq_64.c                         |    1 -
 arch/sparc/kernel/ldc.c                            |    2 +-
 arch/sparc/kernel/leon_kernel.c                    |    1 -
 arch/sparc/kernel/leon_pci_grpci2.c                |    1 -
 arch/sparc/kernel/nmi.c                            |    2 +-
 arch/sparc/kernel/of_device_32.c                   |    1 -
 arch/sparc/kernel/of_device_64.c                   |    3 +-
 arch/sparc/kernel/of_device_common.c               |    2 +-
 arch/sparc/kernel/pci.c                            |    2 +-
 arch/sparc/kernel/pci_fire.c                       |    1 +
 arch/sparc/kernel/pci_psycho.c                     |    1 +
 arch/sparc/kernel/pci_sabre.c                      |    1 +
 arch/sparc/kernel/pci_schizo.c                     |    1 +
 arch/sparc/kernel/pci_sun4v.c                      |    1 +
 arch/sparc/kernel/pcic.c                           |    1 +
 arch/sparc/kernel/pcr.c                            |    3 +-
 arch/sparc/kernel/pmc.c                            |    1 +
 arch/sparc/kernel/power.c                          |    2 +-
 arch/sparc/kernel/process_64.c                     |    2 +-
 arch/sparc/kernel/prom_32.c                        |    1 -
 arch/sparc/kernel/prom_64.c                        |    1 -
 arch/sparc/kernel/prom_common.c                    |    2 +-
 arch/sparc/kernel/reboot.c                         |    2 +-
 arch/sparc/kernel/sbus.c                           |    1 +
 arch/sparc/kernel/setup_32.c                       |    1 +
 arch/sparc/kernel/setup_64.c                       |    1 +
 arch/sparc/kernel/smp_64.c                         |    2 +-
 arch/sparc/kernel/sparc_ksyms_64.c                 |    2 +-
 arch/sparc/kernel/stacktrace.c                     |    2 +-
 arch/sparc/kernel/sys_sparc32.c                    |    1 -
 arch/sparc/kernel/sys_sparc_64.c                   |    2 +-
 arch/sparc/kernel/time_64.c                        |    2 +-
 arch/sparc/kernel/traps_32.c                       |    1 +
 arch/sparc/kernel/unaligned_32.c                   |    1 -
 arch/sparc/kernel/vio.c                            |    1 +
 arch/sparc/kernel/viohs.c                          |    2 +-
 arch/sparc/mm/fault_32.c                           |    1 -
 arch/sparc/mm/generic_32.c                         |    1 +
 arch/sparc/mm/generic_64.c                         |    1 +
 arch/sparc/mm/highmem.c                            |    1 +
 arch/sparc/mm/hugetlbpage.c                        |    1 -
 arch/x86/crypto/aes_glue.c                         |    1 +
 arch/x86/crypto/aesni-intel_glue.c                 |    1 +
 arch/x86/kernel/cpu/amd.c                          |    1 +
 arch/x86/kernel/cpu/mcheck/therm_throt.c           |    1 +
 arch/x86/kernel/devicetree.c                       |    1 +
 arch/x86/kernel/e820.c                             |    1 +
 arch/x86/kernel/hpet.c                             |    1 +
 arch/x86/kernel/irq.c                              |    1 +
 arch/x86/kernel/pci-dma.c                          |    1 +
 arch/x86/kernel/probe_roms.c                       |    4 +-
 arch/x86/kernel/rtc.c                              |    1 +
 arch/x86/kernel/smp.c                              |    1 +
 arch/x86/kernel/time.c                             |    1 +
 arch/x86/kernel/topology.c                         |    1 +
 arch/x86/kernel/vsyscall_64.c                      |    1 +
 arch/x86/pci/i386.c                                |    1 +
 arch/x86/pci/legacy.c                              |    1 +
 arch/x86/platform/efi/efi.c                        |    1 +
 arch/x86/platform/efi/efi_32.c                     |    1 +
 arch/x86/platform/mrst/vrtc.c                      |    1 +
 arch/x86/platform/olpc/olpc-xo1-pm.c               |    1 +
 arch/x86/platform/uv/bios_uv.c                     |    1 +
 arch/x86/power/cpu.c                               |    1 +
 arch/x86/video/fbdev.c                             |    1 +
 block/blk-integrity.c                              |    1 +
 block/ioctl.c                                      |    1 +
 crypto/async_tx/async_memcpy.c                     |    1 +
 crypto/async_tx/async_pq.c                         |    1 +
 crypto/async_tx/async_raid6_recov.c                |    1 +
 crypto/async_tx/async_tx.c                         |    1 +
 crypto/async_tx/async_xor.c                        |    1 +
 crypto/async_tx/raid6test.c                        |    1 +
 crypto/crypto_wq.c                                 |    1 +
 crypto/md4.c                                       |    1 +
 crypto/proc.c                                      |    1 +
 crypto/vmac.c                                      |    1 +
 crypto/xcbc.c                                      |    1 +
 drivers/acpi/acpica/hwsleep.c                      |    1 +
 drivers/acpi/ec_sys.c                              |    1 +
 drivers/acpi/sbshc.c                               |    1 +
 drivers/acpi/sysfs.c                               |    2 +-
 drivers/ata/libata-eh.c                            |    1 +
 drivers/ata/libata-pmp.c                           |    1 +
 drivers/ata/libata-scsi.c                          |    1 +
 drivers/ata/libata-sff.c                           |    1 +
 drivers/base/base.h                                |    1 +
 drivers/base/dma-coherent.c                        |    1 +
 drivers/base/dma-mapping.c                         |    1 +
 drivers/base/hypervisor.c                          |    1 +
 drivers/base/power/generic_ops.c                   |    1 +
 drivers/base/power/main.c                          |    1 +
 drivers/base/power/runtime.c                       |    1 +
 drivers/base/power/sysfs.c                         |    1 +
 drivers/base/power/trace.c                         |    1 +
 drivers/base/power/wakeup.c                        |    1 +
 drivers/base/transport_class.c                     |    1 +
 drivers/bcma/core.c                                |    1 +
 drivers/bcma/driver_chipcommon.c                   |    1 +
 drivers/bcma/driver_pci.c                          |    1 +
 drivers/bcma/host_pci.c                            |    1 +
 drivers/bcma/main.c                                |    1 +
 drivers/block/aoe/aoechr.c                         |    1 +
 drivers/block/ps3disk.c                            |    1 +
 drivers/block/ps3vram.c                            |    1 +
 drivers/block/virtio_blk.c                         |    1 +
 drivers/char/hw_random/virtio-rng.c                |    1 +
 drivers/char/ramoops.c                             |    1 +
 drivers/char/ttyprintk.c                           |    1 +
 drivers/char/virtio_console.c                      |    1 +
 drivers/clocksource/sh_cmt.c                       |    1 +
 drivers/clocksource/sh_mtu2.c                      |    1 +
 drivers/clocksource/sh_tmu.c                       |    1 +
 drivers/cpufreq/cpufreq_stats.c                    |    1 +
 drivers/cpufreq/s3c64xx-cpufreq.c                  |    1 +
 drivers/crypto/mv_cesa.c                           |    1 +
 drivers/dca/dca-core.c                             |    1 +
 drivers/dca/dca-sysfs.c                            |    1 +
 drivers/dma/intel_mid_dma.c                        |    1 +
 drivers/dma/ipu/ipu_idmac.c                        |    1 +
 drivers/dma/ste_dma40.c                            |    1 +
 drivers/edac/mce_amd_inj.c                         |    1 +
 drivers/firewire/core-iso.c                        |    1 +
 drivers/firmware/google/gsmi.c                     |    1 +
 drivers/firmware/sigma.c                           |    1 +
 drivers/gpio/gpio-74x164.c                         |    1 +
 drivers/gpio/gpio-ep93xx.c                         |    1 +
 drivers/gpio/gpio-mc33880.c                        |    1 +
 drivers/gpio/gpio-mcp23s08.c                       |    1 +
 drivers/gpio/gpio-ml-ioh.c                         |    1 +
 drivers/gpio/gpio-mpc5200.c                        |    1 +
 drivers/gpio/gpio-mxc.c                            |    1 +
 drivers/gpio/gpio-mxs.c                            |    1 +
 drivers/gpio/gpio-pcf857x.c                        |    1 +
 drivers/gpio/gpio-pch.c                            |    1 +
 drivers/gpio/gpio-xilinx.c                         |    1 +
 drivers/gpu/drm/ttm/ttm_tt.c                       |    1 +
 drivers/hid/hid-axff.c                             |    1 +
 drivers/hid/hid-debug.c                            |    1 +
 drivers/hid/hid-dr.c                               |    1 +
 drivers/hid/hid-emsff.c                            |    1 +
 drivers/hid/hid-gaff.c                             |    1 +
 drivers/hid/hid-holtekff.c                         |    1 +
 drivers/hid/hid-picolcd.c                          |    1 +
 drivers/hid/hid-pl.c                               |    1 +
 drivers/hid/hid-roccat-common.c                    |    1 +
 drivers/hid/hid-roccat.c                           |    1 +
 drivers/hid/hid-sjoy.c                             |    1 +
 drivers/hid/hid-tmff.c                             |    1 +
 drivers/hid/hid-zpff.c                             |    1 +
 drivers/hid/usbhid/hid-quirks.c                    |    1 +
 drivers/hwmon/ultra45_env.c                        |    1 +
 drivers/i2c/busses/i2c-pxa-pci.c                   |    1 +
 drivers/i2c/busses/i2c-sh7760.c                    |    1 +
 drivers/i2c/busses/i2c-tegra.c                     |    1 +
 drivers/i2c/i2c-boardinfo.c                        |    1 +
 drivers/ide/buddha.c                               |    1 +
 drivers/ide/cmd640.c                               |    1 +
 drivers/ide/ide-acpi.c                             |    1 +
 drivers/ide/ide-atapi.c                            |    1 +
 drivers/ide/ide-disk_proc.c                        |    1 +
 drivers/ide/ide-dma-sff.c                          |    1 +
 drivers/ide/ide-dma.c                              |    1 +
 drivers/ide/ide-eh.c                               |    1 +
 drivers/ide/ide-floppy_proc.c                      |    1 +
 drivers/ide/ide-io-std.c                           |    1 +
 drivers/ide/ide-ioctls.c                           |    1 +
 drivers/ide/ide-legacy.c                           |    1 +
 drivers/ide/ide-lib.c                              |    1 +
 drivers/ide/ide-pnp.c                              |    1 +
 drivers/ide/ide-taskfile.c                         |    1 +
 drivers/ide/ide-xfer-mode.c                        |    1 +
 drivers/ide/macide.c                               |    1 +
 drivers/ide/pmac.c                                 |    1 +
 drivers/ide/q40ide.c                               |    1 +
 drivers/ide/setup-pci.c                            |    1 +
 drivers/ide/tc86c001.c                             |    1 +
 drivers/idle/intel_idle.c                          |    1 +
 drivers/infiniband/core/cm.c                       |    1 +
 drivers/infiniband/core/fmr_pool.c                 |    1 +
 drivers/infiniband/core/mad.c                      |    1 +
 drivers/infiniband/core/multicast.c                |    1 +
 drivers/infiniband/core/packer.c                   |    1 +
 drivers/infiniband/core/sysfs.c                    |    1 +
 drivers/infiniband/core/ud_header.c                |    1 +
 drivers/infiniband/core/umem.c                     |    1 +
 drivers/infiniband/core/uverbs_marshall.c          |    1 +
 drivers/infiniband/core/verbs.c                    |    1 +
 drivers/infiniband/hw/ipath/ipath_diag.c           |    1 +
 drivers/infiniband/hw/ipath/ipath_file_ops.c       |    1 +
 drivers/infiniband/hw/ipath/ipath_sysfs.c          |    1 +
 drivers/infiniband/hw/ipath/ipath_verbs.c          |    1 +
 drivers/infiniband/hw/mthca/mthca_catas.c          |    1 +
 drivers/infiniband/hw/mthca/mthca_cmd.c            |    1 +
 drivers/infiniband/hw/mthca/mthca_provider.c       |    2 +
 drivers/infiniband/hw/qib/qib_diag.c               |    1 +
 drivers/infiniband/hw/qib/qib_file_ops.c           |    1 +
 drivers/infiniband/hw/qib/qib_iba7220.c            |    1 +
 drivers/infiniband/hw/qib/qib_iba7322.c            |    1 +
 drivers/infiniband/hw/qib/qib_pcie.c               |    1 +
 drivers/infiniband/hw/qib/qib_sd7220.c             |    1 +
 drivers/infiniband/hw/qib/qib_verbs.c              |    1 +
 drivers/input/input-compat.c                       |    1 +
 drivers/input/input-mt.c                           |    1 +
 drivers/input/input-polldev.c                      |    1 +
 drivers/input/joystick/as5011.c                    |    1 +
 drivers/input/keyboard/nomadik-ske-keypad.c        |    1 +
 drivers/input/keyboard/tnetv107x-keypad.c          |    1 +
 drivers/input/misc/ad714x.c                        |    1 +
 drivers/input/misc/adxl34x.c                       |    1 +
 drivers/input/misc/ati_remote2.c                   |    1 +
 drivers/input/misc/cma3000_d0x.c                   |    1 +
 drivers/input/misc/dm355evm_keys.c                 |    1 +
 drivers/input/misc/kxtj9.c                         |    1 +
 drivers/input/mouse/hgpk.c                         |    1 +
 drivers/input/sparse-keymap.c                      |    1 +
 drivers/input/touchscreen/ad7877.c                 |    1 +
 drivers/input/touchscreen/ad7879-spi.c             |    1 +
 drivers/input/touchscreen/ad7879.c                 |    1 +
 drivers/input/touchscreen/ads7846.c                |    1 +
 drivers/input/touchscreen/bu21013_ts.c             |    1 +
 drivers/isdn/capi/kcapi_proc.c                     |    1 +
 drivers/leds/dell-led.c                            |    1 +
 drivers/leds/leds-88pm860x.c                       |    1 +
 drivers/leds/leds-asic3.c                          |    1 +
 drivers/leds/leds-atmel-pwm.c                      |    1 +
 drivers/leds/leds-cobalt-raq.c                     |    1 +
 drivers/leds/leds-fsg.c                            |    1 +
 drivers/leds/leds-gpio.c                           |    1 +
 drivers/leds/leds-lm3530.c                         |    1 +
 drivers/leds/leds-locomo.c                         |    1 +
 drivers/leds/leds-lt3593.c                         |    1 +
 drivers/leds/leds-net48xx.c                        |    1 +
 drivers/leds/leds-net5501.c                        |    1 +
 drivers/leds/leds-ns2.c                            |    1 +
 drivers/leds/leds-s3c24xx.c                        |    1 +
 drivers/leds/leds-wm831x-status.c                  |    1 +
 drivers/leds/leds-wm8350.c                         |    1 +
 drivers/leds/leds-wrap.c                           |    1 +
 drivers/lguest/lguest_device.c                     |    1 +
 drivers/md/dm-exception-store.c                    |    1 +
 drivers/md/dm-log-userspace-base.c                 |    1 +
 drivers/md/dm-path-selector.c                      |    1 +
 drivers/md/dm-raid.c                               |    1 +
 drivers/md/dm-round-robin.c                        |    1 +
 drivers/md/dm-service-time.c                       |    1 +
 drivers/md/dm-snap-persistent.c                    |    1 +
 drivers/md/dm-snap-transient.c                     |    1 +
 drivers/md/dm-uevent.c                             |    1 +
 drivers/md/faulty.c                                |    1 +
 drivers/md/linear.c                                |    1 +
 drivers/md/md.c                                    |    1 +
 drivers/md/multipath.c                             |    1 +
 drivers/md/raid0.c                                 |    1 +
 drivers/md/raid1.c                                 |    1 +
 drivers/md/raid10.c                                |    1 +
 drivers/md/raid5.c                                 |    1 +
 drivers/media/common/saa7146_core.c                |    1 +
 drivers/media/common/saa7146_fops.c                |    1 +
 drivers/media/common/saa7146_hlp.c                 |    1 +
 drivers/media/common/saa7146_video.c               |    1 +
 drivers/media/common/tuners/tuner-types.c          |    1 +
 drivers/media/dvb/frontends/dibx000_common.c       |    1 +
 drivers/media/dvb/siano/sms-cards.c                |    1 +
 drivers/media/dvb/siano/smsendian.c                |    1 +
 drivers/media/dvb/siano/smssdio.c                  |    1 +
 drivers/media/dvb/siano/smsusb.c                   |    1 +
 drivers/media/media-device.c                       |    1 +
 drivers/media/radio/radio-timb.c                   |    1 +
 drivers/media/radio/radio-wl1273.c                 |    1 +
 drivers/media/radio/si4713-i2c.c                   |    1 +
 drivers/media/radio/wl128x/fmdrv_v4l2.c            |    2 +
 drivers/media/rc/ir-jvc-decoder.c                  |    1 +
 drivers/media/rc/ir-lirc-codec.c                   |    1 +
 drivers/media/rc/ir-nec-decoder.c                  |    1 +
 drivers/media/rc/ir-raw.c                          |    2 +
 drivers/media/rc/ir-rc5-decoder.c                  |    1 +
 drivers/media/rc/ir-rc5-sz-decoder.c               |    1 +
 drivers/media/rc/ir-rc6-decoder.c                  |    1 +
 drivers/media/rc/ir-sony-decoder.c                 |    1 +
 drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c    |    1 +
 drivers/media/rc/keymaps/rc-alink-dtu-m.c          |    1 +
 drivers/media/rc/keymaps/rc-anysee.c               |    1 +
 drivers/media/rc/keymaps/rc-apac-viewcomp.c        |    1 +
 drivers/media/rc/keymaps/rc-asus-pc39.c            |    1 +
 drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c |    1 +
 drivers/media/rc/keymaps/rc-avermedia-a16d.c       |    1 +
 drivers/media/rc/keymaps/rc-avermedia-cardbus.c    |    1 +
 drivers/media/rc/keymaps/rc-avermedia-dvbt.c       |    1 +
 drivers/media/rc/keymaps/rc-avermedia-m135a.c      |    1 +
 .../media/rc/keymaps/rc-avermedia-m733a-rm-k6.c    |    1 +
 drivers/media/rc/keymaps/rc-avermedia-rm-ks.c      |    1 +
 drivers/media/rc/keymaps/rc-avermedia.c            |    1 +
 drivers/media/rc/keymaps/rc-avertv-303.c           |    1 +
 drivers/media/rc/keymaps/rc-azurewave-ad-tu700.c   |    1 +
 drivers/media/rc/keymaps/rc-behold-columbus.c      |    1 +
 drivers/media/rc/keymaps/rc-behold.c               |    1 +
 drivers/media/rc/keymaps/rc-budget-ci-old.c        |    1 +
 drivers/media/rc/keymaps/rc-cinergy-1400.c         |    1 +
 drivers/media/rc/keymaps/rc-cinergy.c              |    1 +
 drivers/media/rc/keymaps/rc-dib0700-nec.c          |    1 +
 drivers/media/rc/keymaps/rc-dib0700-rc5.c          |    1 +
 drivers/media/rc/keymaps/rc-digitalnow-tinytwin.c  |    1 +
 drivers/media/rc/keymaps/rc-digittrade.c           |    1 +
 drivers/media/rc/keymaps/rc-dm1105-nec.c           |    1 +
 drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c      |    1 +
 drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c   |    1 +
 drivers/media/rc/keymaps/rc-em-terratec.c          |    1 +
 drivers/media/rc/keymaps/rc-encore-enltv-fm53.c    |    1 +
 drivers/media/rc/keymaps/rc-encore-enltv.c         |    1 +
 drivers/media/rc/keymaps/rc-encore-enltv2.c        |    1 +
 drivers/media/rc/keymaps/rc-evga-indtube.c         |    1 +
 drivers/media/rc/keymaps/rc-eztv.c                 |    1 +
 drivers/media/rc/keymaps/rc-flydvb.c               |    1 +
 drivers/media/rc/keymaps/rc-flyvideo.c             |    1 +
 drivers/media/rc/keymaps/rc-fusionhdtv-mce.c       |    1 +
 drivers/media/rc/keymaps/rc-gadmei-rm008z.c        |    1 +
 drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c   |    1 +
 drivers/media/rc/keymaps/rc-gotview7135.c          |    1 +
 drivers/media/rc/keymaps/rc-hauppauge.c            |    1 +
 drivers/media/rc/keymaps/rc-imon-mce.c             |    1 +
 drivers/media/rc/keymaps/rc-imon-pad.c             |    1 +
 drivers/media/rc/keymaps/rc-iodata-bctv7e.c        |    1 +
 drivers/media/rc/keymaps/rc-kaiomy.c               |    1 +
 drivers/media/rc/keymaps/rc-kworld-315u.c          |    1 +
 .../media/rc/keymaps/rc-kworld-plus-tv-analog.c    |    1 +
 drivers/media/rc/keymaps/rc-leadtek-y04g0051.c     |    1 +
 drivers/media/rc/keymaps/rc-lirc.c                 |    1 +
 drivers/media/rc/keymaps/rc-lme2510.c              |    1 +
 drivers/media/rc/keymaps/rc-manli.c                |    1 +
 drivers/media/rc/keymaps/rc-msi-digivox-ii.c       |    1 +
 drivers/media/rc/keymaps/rc-msi-digivox-iii.c      |    1 +
 drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c  |    1 +
 drivers/media/rc/keymaps/rc-msi-tvanywhere.c       |    1 +
 drivers/media/rc/keymaps/rc-nebula.c               |    1 +
 .../media/rc/keymaps/rc-nec-terratec-cinergy-xs.c  |    1 +
 drivers/media/rc/keymaps/rc-norwood.c              |    1 +
 drivers/media/rc/keymaps/rc-npgtech.c              |    1 +
 drivers/media/rc/keymaps/rc-pctv-sedna.c           |    1 +
 drivers/media/rc/keymaps/rc-pinnacle-color.c       |    1 +
 drivers/media/rc/keymaps/rc-pinnacle-grey.c        |    1 +
 drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c     |    1 +
 drivers/media/rc/keymaps/rc-pixelview-002t.c       |    1 +
 drivers/media/rc/keymaps/rc-pixelview-mk12.c       |    1 +
 drivers/media/rc/keymaps/rc-pixelview-new.c        |    1 +
 drivers/media/rc/keymaps/rc-pixelview.c            |    1 +
 .../media/rc/keymaps/rc-powercolor-real-angel.c    |    1 +
 drivers/media/rc/keymaps/rc-proteus-2309.c         |    1 +
 drivers/media/rc/keymaps/rc-purpletv.c             |    1 +
 drivers/media/rc/keymaps/rc-pv951.c                |    1 +
 drivers/media/rc/keymaps/rc-rc6-mce.c              |    1 +
 .../media/rc/keymaps/rc-real-audio-220-32-keys.c   |    1 +
 drivers/media/rc/keymaps/rc-streamzap.c            |    1 +
 drivers/media/rc/keymaps/rc-tbs-nec.c              |    1 +
 drivers/media/rc/keymaps/rc-technisat-usb2.c       |    1 +
 drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c  |    1 +
 drivers/media/rc/keymaps/rc-terratec-slim-2.c      |    1 +
 drivers/media/rc/keymaps/rc-terratec-slim.c        |    1 +
 drivers/media/rc/keymaps/rc-tevii-nec.c            |    1 +
 drivers/media/rc/keymaps/rc-tivo.c                 |    1 +
 drivers/media/rc/keymaps/rc-total-media-in-hand.c  |    1 +
 drivers/media/rc/keymaps/rc-trekstor.c             |    1 +
 drivers/media/rc/keymaps/rc-tt-1500.c              |    1 +
 drivers/media/rc/keymaps/rc-twinhan1027.c          |    1 +
 drivers/media/rc/keymaps/rc-videomate-m1f.c        |    1 +
 drivers/media/rc/keymaps/rc-videomate-s350.c       |    1 +
 drivers/media/rc/keymaps/rc-videomate-tv-pvr.c     |    1 +
 drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c |    1 +
 drivers/media/rc/keymaps/rc-winfast.c              |    1 +
 drivers/media/rc/rc-main.c                         |    1 +
 drivers/media/video/adp1653.c                      |    1 +
 drivers/media/video/ak881x.c                       |    1 +
 drivers/media/video/cpia2/cpia2_usb.c              |    1 +
 drivers/media/video/cx25840/cx25840-ir.c           |    1 +
 drivers/media/video/davinci/dm355_ccdc.c           |    1 +
 drivers/media/video/davinci/dm644x_ccdc.c          |    1 +
 drivers/media/video/hdpvr/hdpvr-i2c.c              |    1 +
 drivers/media/video/hexium_gemini.c                |    1 +
 drivers/media/video/hexium_orion.c                 |    1 +
 drivers/media/video/imx074.c                       |    1 +
 drivers/media/video/m5mols/m5mols_core.c           |    1 +
 drivers/media/video/mt9m001.c                      |    1 +
 drivers/media/video/mt9m111.c                      |    1 +
 drivers/media/video/mt9t031.c                      |    1 +
 drivers/media/video/mt9v011.c                      |    1 +
 drivers/media/video/mt9v022.c                      |    1 +
 drivers/media/video/mt9v032.c                      |    1 +
 drivers/media/video/mxb.c                          |    1 +
 drivers/media/video/noon010pc30.c                  |    1 +
 drivers/media/video/omap24xxcam.c                  |    1 +
 drivers/media/video/ov6650.c                       |    1 +
 drivers/media/video/pvrusb2/pvrusb2-devattr.c      |    1 +
 drivers/media/video/pvrusb2/pvrusb2-hdw.c          |    1 +
 drivers/media/video/pvrusb2/pvrusb2-i2c-core.c     |    1 +
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c         |    1 +
 drivers/media/video/rj54n1cb0c.c                   |    1 +
 drivers/media/video/sh_mobile_csi2.c               |    1 +
 drivers/media/video/sh_vou.c                       |    1 +
 drivers/media/video/sr030pc30.c                    |    1 +
 drivers/media/video/tcm825x.c                      |    1 +
 drivers/media/video/timblogiw.c                    |    1 +
 drivers/media/video/tvp514x.c                      |    1 +
 drivers/media/video/tvp5150.c                      |    1 +
 drivers/media/video/tvp7002.c                      |    1 +
 drivers/media/video/usbvision/usbvision-cards.c    |    1 +
 drivers/media/video/v4l2-ctrls.c                   |    1 +
 drivers/media/video/v4l2-device.c                  |    1 +
 drivers/media/video/v4l2-event.c                   |    1 +
 drivers/media/video/v4l2-fh.c                      |    1 +
 drivers/media/video/v4l2-int-device.c              |    1 +
 drivers/media/video/v4l2-subdev.c                  |    1 +
 drivers/memstick/core/memstick.c                   |    1 +
 drivers/memstick/core/mspro_block.c                |    1 +
 drivers/memstick/host/jmb38x_ms.c                  |    1 +
 drivers/memstick/host/tifm_ms.c                    |    1 +
 drivers/message/i2o/pci.c                          |    1 +
 drivers/mfd/ab3100-core.c                          |    1 +
 drivers/mfd/ab3550-core.c                          |    1 +
 drivers/mfd/ab8500-debugfs.c                       |    1 +
 drivers/mfd/ab8500-sysctrl.c                       |    1 +
 drivers/mfd/abx500-core.c                          |    1 +
 drivers/mfd/asic3.c                                |    1 +
 drivers/mfd/dm355evm_msp.c                         |    1 +
 drivers/mfd/max8997.c                              |    1 +
 drivers/mfd/mfd-core.c                             |    1 +
 drivers/mfd/pcf50633-irq.c                         |    1 +
 drivers/mfd/tmio_core.c                            |    1 +
 drivers/mfd/twl-core.c                             |    1 +
 drivers/mfd/twl6030-irq.c                          |    1 +
 drivers/mfd/wl1273-core.c                          |    1 +
 drivers/mfd/wm8400-core.c                          |    1 +
 drivers/misc/ab8500-pwm.c                          |    1 +
 drivers/misc/atmel-ssc.c                           |    1 +
 drivers/misc/atmel_tclib.c                         |    1 +
 drivers/misc/bh1780gli.c                           |    1 +
 drivers/misc/kgdbts.c                              |    1 +
 drivers/misc/ti-st/st_kim.c                        |    1 +
 drivers/misc/tifm_7xx1.c                           |    1 +
 drivers/misc/tifm_core.c                           |    1 +
 drivers/mmc/card/mmc_test.c                        |    1 +
 drivers/mmc/core/bus.c                             |    2 +
 drivers/mmc/core/debugfs.c                         |    1 +
 drivers/mmc/core/host.c                            |    1 +
 drivers/mmc/core/mmc.c                             |    1 +
 drivers/mmc/core/mmc_ops.c                         |    1 +
 drivers/mmc/core/quirks.c                          |    1 +
 drivers/mmc/core/sd.c                              |    1 +
 drivers/mmc/core/sd_ops.c                          |    1 +
 drivers/mmc/core/sdio_bus.c                        |    1 +
 drivers/mmc/core/sdio_io.c                         |    1 +
 drivers/mmc/core/sdio_irq.c                        |    1 +
 drivers/mmc/host/mmc_spi.c                         |    1 +
 drivers/mmc/host/mxs-mmc.c                         |    1 +
 drivers/mmc/host/sdhci-of-esdhc.c                  |    1 +
 drivers/mmc/host/sdhci-of-hlwd.c                   |    1 +
 drivers/mmc/host/sdhci-pci.c                       |    1 +
 drivers/mmc/host/sdhci-pltfm.c                     |    1 +
 drivers/mmc/host/sdhci-pxav2.c                     |    1 +
 drivers/mmc/host/sdhci-pxav3.c                     |    1 +
 drivers/mmc/host/sdhci-s3c.c                       |    1 +
 drivers/mmc/host/sdhci-spear.c                     |    1 +
 drivers/mmc/host/sdhci-tegra.c                     |    1 +
 drivers/mmc/host/sdhci.c                           |    1 +
 drivers/mmc/host/sdricoh_cs.c                      |    1 +
 drivers/mmc/host/sh_mmcif.c                        |    1 +
 drivers/mmc/host/sh_mobile_sdhi.c                  |    1 +
 drivers/mmc/host/tifm_sd.c                         |    1 +
 drivers/mmc/host/via-sdmmc.c                       |    1 +
 drivers/mtd/ar7part.c                              |    1 +
 drivers/mtd/cmdlinepart.c                          |    1 +
 drivers/mtd/lpddr/lpddr_cmds.c                     |    1 +
 drivers/mtd/mtdblock_ro.c                          |    1 +
 drivers/mtd/mtdsuper.c                             |    1 +
 drivers/mtd/nand/cafe_nand.c                       |    1 +
 drivers/mtd/nand/cmx270_nand.c                     |    1 +
 drivers/mtd/nand/diskonchip.c                      |    1 +
 drivers/mtd/nand/nand_bbt.c                        |    1 +
 drivers/mtd/nand/omap2.c                           |    1 +
 drivers/mtd/nand/sm_common.c                       |    1 +
 drivers/mtd/onenand/onenand_bbt.c                  |    1 +
 drivers/mtd/redboot.c                              |    1 +
 drivers/mtd/rfd_ftl.c                              |    1 +
 drivers/mtd/ubi/vmt.c                              |    1 +
 drivers/net/mlx4/alloc.c                           |    1 +
 drivers/net/mlx4/catas.c                           |    1 +
 drivers/net/mlx4/cmd.c                             |    1 +
 drivers/net/mlx4/cq.c                              |    1 +
 drivers/net/mlx4/eq.c                              |    1 +
 drivers/net/mlx4/fw.c                              |    1 +
 drivers/net/mlx4/intf.c                            |    1 +
 drivers/net/mlx4/mr.c                              |    1 +
 drivers/net/mlx4/pd.c                              |    1 +
 drivers/net/mlx4/port.c                            |    1 +
 drivers/net/mlx4/qp.c                              |    1 +
 drivers/net/mlx4/srq.c                             |    1 +
 drivers/net/phy/realtek.c                          |    1 +
 drivers/net/wireless/b43/pcmcia.c                  |    1 +
 drivers/of/of_pci.c                                |    1 +
 drivers/of/of_pci_irq.c                            |    1 +
 drivers/of/of_spi.c                                |    1 +
 drivers/parisc/ccio-dma.c                          |    1 +
 drivers/parisc/sba_iommu.c                         |    1 +
 drivers/pci/hotplug-pci.c                          |    1 +
 drivers/pci/hotplug/pciehp_acpi.c                  |    1 +
 drivers/pci/hotplug/pcihp_slot.c                   |    1 +
 drivers/pci/hotplug/rpadlpar_core.c                |    1 +
 drivers/pci/htirq.c                                |    1 +
 drivers/pci/iov.c                                  |    1 +
 drivers/pci/irq.c                                  |    1 +
 drivers/pci/msi.c                                  |    1 +
 drivers/pci/pci-sysfs.c                            |    1 +
 drivers/pci/quirks.c                               |    1 +
 drivers/pci/rom.c                                  |    1 +
 drivers/pci/setup-res.c                            |    1 +
 drivers/pci/slot.c                                 |    1 +
 drivers/pci/vpd.c                                  |    1 +
 drivers/pcmcia/db1xxx_ss.c                         |    1 +
 drivers/pcmcia/pxa2xx_cm_x255.c                    |    1 +
 drivers/pcmcia/pxa2xx_cm_x270.c                    |    1 +
 drivers/platform/x86/intel_scu_ipc.c               |    1 +
 drivers/platform/x86/msi-wmi.c                     |    1 +
 drivers/platform/x86/wmi.c                         |    1 +
 drivers/power/max17042_battery.c                   |    1 +
 drivers/power/max8903_charger.c                    |    1 +
 drivers/power/power_supply_sysfs.c                 |    1 +
 drivers/ps3/ps3stor_lib.c                          |    1 +
 drivers/ps3/sys-manager-core.c                     |    1 +
 drivers/rapidio/switches/idt_gen2.c                |    1 +
 drivers/regulator/88pm8607.c                       |    1 +
 drivers/regulator/ab8500.c                         |    1 +
 drivers/regulator/bq24022.c                        |    1 +
 drivers/regulator/da903x.c                         |    1 +
 drivers/regulator/db8500-prcmu.c                   |    1 +
 drivers/regulator/dummy.c                          |    1 +
 drivers/regulator/fixed.c                          |    1 +
 drivers/regulator/lp3971.c                         |    1 +
 drivers/regulator/lp3972.c                         |    1 +
 drivers/regulator/max8925-regulator.c              |    1 +
 drivers/regulator/max8997.c                        |    1 +
 drivers/regulator/mc13783-regulator.c              |    1 +
 drivers/regulator/mc13892-regulator.c              |    1 +
 drivers/regulator/mc13xxx-regulator-core.c         |    1 +
 drivers/regulator/tps6586x-regulator.c             |    1 +
 drivers/regulator/userspace-consumer.c             |    1 +
 drivers/regulator/virtual.c                        |    1 +
 drivers/regulator/wm8400-regulator.c               |    1 +
 drivers/rtc/interface.c                            |    1 +
 drivers/rtc/rtc-dm355evm.c                         |    1 +
 drivers/rtc/rtc-ds1305.c                           |    1 +
 drivers/rtc/rtc-ds1511.c                           |    1 +
 drivers/rtc/rtc-ds1553.c                           |    1 +
 drivers/rtc/rtc-ds1672.c                           |    1 +
 drivers/rtc/rtc-ds1742.c                           |    1 +
 drivers/rtc/rtc-em3027.c                           |    1 +
 drivers/rtc/rtc-isl12022.c                         |    1 +
 drivers/rtc/rtc-mv.c                               |    1 +
 drivers/rtc/rtc-pcf2123.c                          |    1 +
 drivers/rtc/rtc-pcf8563.c                          |    1 +
 drivers/rtc/rtc-rs5c348.c                          |    1 +
 drivers/rtc/rtc-rs5c372.c                          |    1 +
 drivers/rtc/rtc-stk17ta8.c                         |    1 +
 drivers/rtc/rtc-tx4939.c                           |    1 +
 drivers/rtc/rtc-x1205.c                            |    1 +
 drivers/s390/char/fs3270.c                         |    1 +
 drivers/s390/char/sclp_cpi_sys.c                   |    1 +
 drivers/s390/char/vmur.c                           |    1 +
 drivers/s390/cio/chp.c                             |    2 +
 drivers/s390/cio/qdio_debug.c                      |    2 +
 drivers/s390/kvm/kvm_virtio.c                      |    1 +
 drivers/s390/scsi/zfcp_ccw.c                       |    1 +
 drivers/s390/scsi/zfcp_dbf.c                       |    1 +
 drivers/s390/scsi/zfcp_scsi.c                      |    1 +
 drivers/scsi/a2091.c                               |    1 +
 drivers/scsi/a3000.c                               |    1 +
 drivers/scsi/aacraid/aachba.c                      |    1 +
 drivers/scsi/bfa/bfad_debugfs.c                    |    1 +
 drivers/scsi/bfa/bfad_im.c                         |    2 +
 drivers/scsi/device_handler/scsi_dh.c              |    1 +
 drivers/scsi/device_handler/scsi_dh_alua.c         |    1 +
 drivers/scsi/device_handler/scsi_dh_emc.c          |    1 +
 drivers/scsi/device_handler/scsi_dh_hp_sw.c        |    1 +
 drivers/scsi/device_handler/scsi_dh_rdac.c         |    1 +
 drivers/scsi/gvp11.c                               |    1 +
 drivers/scsi/libfc/fc_disc.c                       |    1 +
 drivers/scsi/libfc/fc_elsct.c                      |    1 +
 drivers/scsi/libfc/fc_exch.c                       |    1 +
 drivers/scsi/libfc/fc_libfc.c                      |    1 +
 drivers/scsi/libfc/fc_lport.c                      |    1 +
 drivers/scsi/libfc/fc_npiv.c                       |    1 +
 drivers/scsi/libfc/fc_rport.c                      |    1 +
 drivers/scsi/libsas/sas_scsi_host.c                |    1 +
 drivers/scsi/libsas/sas_task.c                     |    1 +
 drivers/scsi/libsrp.c                              |    1 +
 drivers/scsi/lpfc/lpfc_attr.c                      |    1 +
 drivers/scsi/lpfc/lpfc_debugfs.c                   |    1 +
 drivers/scsi/lpfc/lpfc_init.c                      |    1 +
 drivers/scsi/lpfc/lpfc_scsi.c                      |    1 +
 drivers/scsi/mac53c94.c                            |    1 +
 drivers/scsi/megaraid/megaraid_mbox.c              |    1 +
 drivers/scsi/osd/osd_initiator.c                   |    1 +
 drivers/scsi/ps3rom.c                              |    1 +
 drivers/scsi/scsi_lib.c                            |    1 +
 drivers/scsi/scsi_lib_dma.c                        |    1 +
 drivers/scsi/scsi_pm.c                             |    1 +
 drivers/scsi/sr_ioctl.c                            |    1 +
 drivers/sfi/sfi_core.h                             |    3 +
 drivers/sh/intc/core.c                             |    1 +
 drivers/sh/intc/virq.c                             |    1 +
 drivers/sh/maple/maple.c                           |    1 +
 drivers/spi/spi-altera.c                           |    1 +
 drivers/spi/spi-au1550.c                           |    1 +
 drivers/spi/spi-bitbang.c                          |    1 +
 drivers/spi/spi-butterfly.c                        |    1 +
 drivers/spi/spi-dw-mmio.c                          |    1 +
 drivers/spi/spi-dw-pci.c                           |    1 +
 drivers/spi/spi-dw.c                               |    1 +
 drivers/spi/spi-gpio.c                             |    1 +
 drivers/spi/spi-oc-tiny.c                          |    1 +
 drivers/spi/spi-omap-uwire.c                       |    1 +
 drivers/spi/spi-orion.c                            |    1 +
 drivers/spi/spi-pxa2xx-pci.c                       |    1 +
 drivers/spi/spi-s3c24xx.c                          |    1 +
 drivers/spi/spi-sh-msiof.c                         |    1 +
 drivers/spi/spi-sh-sci.c                           |    1 +
 drivers/spi/spi-ti-ssp.c                           |    1 +
 drivers/spi/spi-tle62x0.c                          |    1 +
 drivers/spi/spi-txx9.c                             |    1 +
 drivers/spi/spi.c                                  |    1 +
 drivers/ssb/b43_pci_bridge.c                       |    1 +
 drivers/ssb/driver_chipcommon.c                    |    1 +
 drivers/ssb/driver_chipcommon_pmu.c                |    1 +
 drivers/ssb/driver_gige.c                          |    1 +
 drivers/ssb/driver_pcicore.c                       |    1 +
 drivers/ssb/embedded.c                             |    1 +
 drivers/ssb/main.c                                 |    1 +
 drivers/ssb/pcihost_wrapper.c                      |    1 +
 drivers/staging/altera-stapl/altera.c              |    1 +
 drivers/staging/brcm80211/brcmutil/wifi.c          |    1 +
 drivers/staging/dt3155v4l/dt3155v4l.c              |    2 +
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c |    1 +
 drivers/staging/iio/accel/adis16201_core.c         |    1 +
 drivers/staging/iio/accel/adis16203_core.c         |    1 +
 drivers/staging/iio/accel/adis16204_core.c         |    1 +
 drivers/staging/iio/accel/adis16209_core.c         |    1 +
 drivers/staging/iio/accel/adis16220_core.c         |    1 +
 drivers/staging/iio/accel/adis16240_core.c         |    1 +
 drivers/staging/iio/accel/kxsd9.c                  |    1 +
 drivers/staging/iio/accel/lis3l02dq_core.c         |    1 +
 drivers/staging/iio/accel/sca3000_core.c           |    1 +
 drivers/staging/iio/adc/ad7150.c                   |    1 +
 drivers/staging/iio/adc/ad7152.c                   |    1 +
 drivers/staging/iio/adc/ad7291.c                   |    1 +
 drivers/staging/iio/adc/ad7298_core.c              |    1 +
 drivers/staging/iio/adc/ad7314.c                   |    1 +
 drivers/staging/iio/adc/ad7476_core.c              |    1 +
 drivers/staging/iio/adc/ad7606_core.c              |    1 +
 drivers/staging/iio/adc/ad7745.c                   |    1 +
 drivers/staging/iio/adc/ad7780.c                   |    1 +
 drivers/staging/iio/adc/ad7816.c                   |    1 +
 drivers/staging/iio/adc/ad7887_core.c              |    1 +
 drivers/staging/iio/adc/ad799x_core.c              |    1 +
 drivers/staging/iio/adc/adt7310.c                  |    1 +
 drivers/staging/iio/adc/adt7410.c                  |    1 +
 drivers/staging/iio/adc/adt75.c                    |    1 +
 drivers/staging/iio/adc/max1363_core.c             |    1 +
 drivers/staging/iio/addac/adt7316-i2c.c            |    1 +
 drivers/staging/iio/addac/adt7316.c                |    1 +
 drivers/staging/iio/dac/ad5446.c                   |    1 +
 drivers/staging/iio/dac/ad5504.c                   |    1 +
 drivers/staging/iio/dac/ad5624r_spi.c              |    1 +
 drivers/staging/iio/dac/ad5686.c                   |    1 +
 drivers/staging/iio/dac/ad5791.c                   |    1 +
 drivers/staging/iio/dds/ad5930.c                   |    1 +
 drivers/staging/iio/dds/ad9832.c                   |    1 +
 drivers/staging/iio/dds/ad9834.c                   |    1 +
 drivers/staging/iio/dds/ad9850.c                   |    1 +
 drivers/staging/iio/dds/ad9852.c                   |    1 +
 drivers/staging/iio/dds/ad9910.c                   |    1 +
 drivers/staging/iio/dds/ad9951.c                   |    1 +
 drivers/staging/iio/gyro/adis16060_core.c          |    1 +
 drivers/staging/iio/gyro/adis16080_core.c          |    1 +
 drivers/staging/iio/gyro/adis16130_core.c          |    1 +
 drivers/staging/iio/gyro/adis16260_core.c          |    1 +
 drivers/staging/iio/gyro/adxrs450_core.c           |    1 +
 drivers/staging/iio/imu/adis16400_core.c           |    1 +
 drivers/staging/iio/industrialio-ring.c            |    1 +
 drivers/staging/iio/light/tsl2583.c                |    1 +
 drivers/staging/iio/meter/ade7753.c                |    1 +
 drivers/staging/iio/meter/ade7754.c                |    1 +
 drivers/staging/iio/meter/ade7758_core.c           |    1 +
 drivers/staging/iio/meter/ade7759.c                |    1 +
 drivers/staging/iio/meter/ade7854-i2c.c            |    1 +
 drivers/staging/iio/meter/ade7854-spi.c            |    1 +
 drivers/staging/iio/meter/ade7854.c                |    1 +
 drivers/staging/iio/resolver/ad2s120x.c            |    1 +
 drivers/staging/iio/resolver/ad2s1210.c            |    1 +
 drivers/staging/iio/resolver/ad2s90.c              |    1 +
 drivers/staging/iio/trigger.h                      |    1 +
 .../staging/intel_sst/intel_sst_drv_interface.c    |    1 +
 drivers/staging/line6/audio.c                      |    1 +
 drivers/staging/olpc_dcon/olpc_dcon.c              |    1 +
 drivers/staging/sm7xx/smtcfb.c                     |    2 +
 drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c      |    1 +
 drivers/staging/usbip/stub_dev.c                   |    1 +
 drivers/staging/usbip/stub_main.c                  |    1 +
 drivers/staging/usbip/usbip_event.c                |    1 +
 drivers/tty/hvc/hvc_iseries.c                      |    1 +
 drivers/tty/hvc/hvc_vio.c                          |    1 +
 drivers/tty/serial/jsm/jsm_driver.c                |    2 +-
 drivers/tty/serial/kgdboc.c                        |    1 +
 drivers/tty/serial/max3100.c                       |    1 +
 drivers/tty/serial/max3107-aava.c                  |    1 +
 drivers/tty/serial/max3107.c                       |    1 +
 drivers/tty/serial/nwpserial.c                     |    1 +
 drivers/tty/serial/timbuart.c                      |    1 +
 drivers/tty/serial/xilinx_uartps.c                 |    1 +
 drivers/tty/vt/vc_screen.c                         |    1 +
 drivers/uio/uio_pdrv.c                             |    1 +
 drivers/uio/uio_pdrv_genirq.c                      |    1 +
 drivers/usb/c67x00/c67x00-drv.c                    |    1 +
 drivers/usb/core/driver.c                          |    1 +
 drivers/usb/core/notify.c                          |    1 +
 drivers/usb/gadget/cdc2.c                          |    1 +
 drivers/usb/gadget/composite.c                     |    1 +
 drivers/usb/gadget/dbgp.c                          |    1 +
 drivers/usb/gadget/f_fs.c                          |    1 +
 drivers/usb/gadget/f_obex.c                        |    1 +
 drivers/usb/gadget/f_sourcesink.c                  |    1 +
 drivers/usb/gadget/file_storage.c                  |    1 +
 drivers/usb/gadget/fusb300_udc.c                   |    1 +
 drivers/usb/gadget/gmidi.c                         |    1 +
 drivers/usb/gadget/u_serial.c                      |    1 +
 drivers/usb/host/ehci-mxc.c                        |    1 +
 drivers/usb/host/fsl-mph-dr-of.c                   |    1 +
 drivers/usb/host/isp1760-if.c                      |    1 +
 drivers/usb/host/pci-quirks.c                      |    1 +
 drivers/usb/host/whci/debug.c                      |    1 +
 drivers/usb/host/whci/hcd.c                        |    1 +
 drivers/usb/host/xhci-hub.c                        |    1 +
 drivers/usb/host/xhci-pci.c                        |    1 +
 drivers/usb/mon/mon_bin.c                          |    1 +
 drivers/usb/mon/mon_stat.c                         |    1 +
 drivers/usb/mon/mon_text.c                         |    1 +
 drivers/usb/otg/gpio_vbus.c                        |    1 +
 drivers/usb/otg/otg.c                              |    1 +
 drivers/usb/otg/ulpi.c                             |    1 +
 drivers/usb/serial/aircable.c                      |    1 +
 drivers/usb/serial/qcserial.c                      |    1 +
 drivers/usb/storage/option_ms.c                    |    1 +
 drivers/usb/storage/protocol.c                     |    1 +
 drivers/usb/storage/sierra_ms.c                    |    1 +
 drivers/usb/storage/transport.c                    |    1 +
 drivers/usb/storage/uas.c                          |    1 +
 drivers/usb/wusbcore/devconnect.c                  |    1 +
 drivers/usb/wusbcore/mmc.c                         |    1 +
 drivers/usb/wusbcore/rh.c                          |    1 +
 drivers/usb/wusbcore/security.c                    |    1 +
 drivers/usb/wusbcore/wa-hc.c                       |    1 +
 drivers/usb/wusbcore/wa-rpipe.c                    |    1 +
 drivers/usb/wusbcore/wa-xfer.c                     |    1 +
 drivers/uwb/est.c                                  |    1 +
 drivers/uwb/i1480/dfu/dfu.c                        |    1 +
 drivers/uwb/ie.c                                   |    1 +
 drivers/uwb/lc-dev.c                               |    2 +
 drivers/uwb/neh.c                                  |    1 +
 drivers/uwb/pal.c                                  |    1 +
 drivers/uwb/radio.c                                |    1 +
 drivers/uwb/reset.c                                |    1 +
 drivers/uwb/rsv.c                                  |    1 +
 drivers/uwb/scan.c                                 |    1 +
 drivers/uwb/umc-bus.c                              |    1 +
 drivers/uwb/umc-dev.c                              |    1 +
 drivers/uwb/umc-drv.c                              |    1 +
 drivers/uwb/whci.c                                 |    1 +
 drivers/video/atmel_lcdfb.c                        |    1 +
 drivers/video/backlight/88pm860x_bl.c              |    1 +
 drivers/video/backlight/adp5520_bl.c               |    1 +
 drivers/video/backlight/ams369fg06.c               |    1 +
 drivers/video/backlight/da903x_bl.c                |    1 +
 drivers/video/backlight/l4f00242t03.c              |    1 +
 drivers/video/backlight/ld9040.c                   |    1 +
 drivers/video/backlight/lms283gf05.c               |    1 +
 drivers/video/backlight/max8925_bl.c               |    1 +
 drivers/video/backlight/s6e63m0.c                  |    1 +
 drivers/video/backlight/wm831x_bl.c                |    1 +
 drivers/video/carminefb.c                          |    1 +
 drivers/video/cobalt_lcdfb.c                       |    1 +
 drivers/video/fb_ddc.c                             |    3 +-
 drivers/video/fb_notify.c                          |    1 +
 drivers/video/mb862xx/mb862xx-i2c.c                |    1 +
 drivers/video/mb862xx/mb862xxfbdrv.c               |    1 +
 drivers/video/msm/mdp.c                            |    1 +
 drivers/video/omap/lcd_mipid.c                     |    1 +
 drivers/video/omap/omapfb_main.c                   |    1 +
 drivers/video/omap2/dss/dispc.c                    |    1 +
 drivers/video/omap2/dss/dpi.c                      |    1 +
 drivers/video/omap2/dss/dsi.c                      |    1 +
 drivers/video/omap2/dss/dss.c                      |    1 +
 drivers/video/omap2/dss/rfbi.c                     |    1 +
 drivers/video/omap2/dss/sdi.c                      |    1 +
 drivers/video/omap2/omapfb/omapfb-ioctl.c          |    1 +
 drivers/video/savage/savagefb_accel.c              |    1 +
 drivers/video/sh_mipi_dsi.c                        |    1 +
 drivers/video/sh_mobile_lcdcfb.c                   |    1 +
 drivers/video/via/via-gpio.c                       |    1 +
 drivers/video/w100fb.c                             |    1 +
 drivers/virtio/virtio.c                            |    1 +
 drivers/virtio/virtio_balloon.c                    |    1 +
 drivers/virtio/virtio_ring.c                       |    1 +
 drivers/w1/w1_family.c                             |    1 +
 drivers/xen/balloon.c                              |    1 +
 drivers/xen/manage.c                               |    1 +
 drivers/xen/swiotlb-xen.c                          |    1 +
 drivers/xen/xen-pciback/conf_space.c               |    1 +
 drivers/xen/xen-selfballoon.c                      |    2 +
 drivers/xen/xenbus/xenbus_client.c                 |    1 +
 drivers/xen/xenbus/xenbus_probe.c                  |    1 +
 drivers/xen/xenbus/xenbus_probe_backend.c          |    1 +
 drivers/xen/xenbus/xenbus_probe_frontend.c         |    1 +
 drivers/zorro/proc.c                               |    1 +
 fs/bio-integrity.c                                 |    1 +
 fs/exofs/super.c                                   |    1 +
 fs/gfs2/ops_fstype.c                               |    1 +
 fs/ioprio.c                                        |    1 +
 fs/jfs/jfs_logmgr.c                                |    1 +
 fs/logfs/super.c                                   |    1 +
 fs/nfsd/nfssvc.c                                   |    1 +
 fs/proc/vmcore.c                                   |    1 +
 include/acpi/platform/aclinux.h                    |    2 +-
 include/drm/drmP.h                                 |    3 +-
 include/linux/bcma/bcma.h                          |    7 +-
 include/linux/blkdev.h                             |    2 +-
 include/linux/cpuidle.h                            |    3 +-
 include/linux/crypto.h                             |    6 --
 include/linux/device.h                             |   15 ++-
 include/linux/device_cgroup.h                      |    1 -
 include/linux/dmaengine.h                          |    2 +
 include/linux/export.h                             |   89 ++++++++++++++++++++
 include/linux/firmware.h                           |    2 +-
 include/linux/ftrace.h                             |    2 +-
 include/linux/gameport.h                           |   17 ++--
 include/linux/hid.h                                |    9 +-
 include/linux/i2c.h                                |   10 +-
 include/linux/ipmi.h                               |    3 +-
 include/linux/ipmi_smi.h                           |    1 -
 include/linux/mdio-bitbang.h                       |    3 +-
 include/linux/module.h                             |   68 +---------------
 include/linux/mtd/mtd.h                            |    3 +-
 include/linux/of_platform.h                        |    1 -
 include/linux/pci_hotplug.h                        |   10 +--
 include/linux/pm_runtime.h                         |    1 +
 include/linux/regulator/driver.h                   |    1 +
 include/linux/serio.h                              |   20 +++--
 include/linux/ssb/ssb.h                            |    7 +-
 include/linux/stop_machine.h                       |    1 +
 include/linux/sunrpc/svc_xprt.h                    |    3 +-
 include/linux/sysdev.h                             |    1 -
 include/linux/textsearch.h                         |    3 +-
 include/linux/uio_driver.h                         |   12 ++--
 include/linux/usb.h                                |    9 +-
 include/linux/uwb.h                                |    1 +
 include/linux/uwb/umc.h                            |    7 +-
 include/linux/vermagic.h                           |    1 -
 include/linux/vlynq.h                              |    3 +-
 include/media/saa7146.h                            |    3 +-
 include/media/v4l2-int-device.h                    |    3 +-
 include/net/inet_timewait_sock.h                   |    1 -
 include/net/lib80211.h                             |    3 +-
 include/net/sch_generic.h                          |    1 -
 include/net/sock.h                                 |    2 +-
 include/sound/core.h                               |    2 +-
 include/trace/define_trace.h                       |    2 +-
 include/trace/events/module.h                      |    2 +-
 include/xen/xenbus.h                               |    1 +
 kernel/async.c                                     |    2 +-
 kernel/audit.c                                     |    2 +-
 kernel/auditsc.c                                   |    2 +-
 kernel/capability.c                                |    2 +-
 kernel/cgroup_freezer.c                            |    2 +-
 kernel/compat.c                                    |    1 +
 kernel/cpu.c                                       |    2 +-
 kernel/cpuset.c                                    |    2 +-
 kernel/crash_dump.c                                |    2 +-
 kernel/cred.c                                      |    2 +-
 kernel/debug/kdb/kdb_debugger.c                    |    1 +
 kernel/dma.c                                       |    2 +-
 kernel/events/core.c                               |    1 +
 kernel/exit.c                                      |    3 +-
 kernel/fork.c                                      |    3 +-
 kernel/freezer.c                                   |    2 +-
 kernel/futex.c                                     |    2 +-
 kernel/groups.c                                    |    2 +-
 kernel/hrtimer.c                                   |    2 +-
 kernel/hung_task.c                                 |    2 +-
 kernel/irq_work.c                                  |    4 +-
 kernel/kfifo.c                                     |    2 +-
 kernel/kprobes.c                                   |    2 +-
 kernel/ksysfs.c                                    |    3 +-
 kernel/kthread.c                                   |    2 +-
 kernel/latencytop.c                                |    2 +-
 kernel/lockdep.c                                   |    2 +-
 kernel/lockdep_proc.c                              |    2 +-
 kernel/module.c                                    |    2 +-
 kernel/mutex-debug.c                               |    2 +-
 kernel/mutex.c                                     |    2 +-
 kernel/notifier.c                                  |    2 +-
 kernel/nsproxy.c                                   |    2 +-
 kernel/padata.c                                    |    2 +-
 kernel/params.c                                    |    4 +-
 kernel/pid.c                                       |    2 +-
 kernel/posix-timers.c                              |    2 +-
 kernel/power/hibernate.c                           |    1 +
 kernel/power/main.c                                |    1 +
 kernel/power/suspend.c                             |    2 +
 kernel/printk.c                                    |    2 +-
 kernel/profile.c                                   |    2 +-
 kernel/ptrace.c                                    |    2 +-
 kernel/range.c                                     |    2 +-
 kernel/rcupdate.c                                  |    2 +-
 kernel/rcutiny.c                                   |    4 +-
 kernel/rcutorture.c                                |    3 +-
 kernel/rcutree.c                                   |    2 +-
 kernel/rcutree_trace.c                             |    3 +-
 kernel/relay.c                                     |    2 +-
 kernel/resource.c                                  |    2 +-
 kernel/rtmutex-debug.c                             |    2 +-
 kernel/rtmutex-tester.c                            |    2 +-
 kernel/rtmutex.c                                   |    2 +-
 kernel/rwsem.c                                     |    2 +-
 kernel/sched.c                                     |    2 +-
 kernel/sched_clock.c                               |    2 +-
 kernel/semaphore.c                                 |    2 +-
 kernel/signal.c                                    |    2 +-
 kernel/smp.c                                       |    2 +-
 kernel/softirq.c                                   |    2 +-
 kernel/spinlock.c                                  |    2 +-
 kernel/srcu.c                                      |    2 +-
 kernel/stacktrace.c                                |    2 +-
 kernel/stop_machine.c                              |    2 +-
 kernel/sys.c                                       |    3 +-
 kernel/sysctl.c                                    |    2 +-
 kernel/time.c                                      |    2 +-
 kernel/time/posix-clock.c                          |    1 +
 kernel/timer.c                                     |    2 +-
 kernel/trace/blktrace.c                            |    1 +
 kernel/trace/ftrace.c                              |    1 +
 kernel/trace/trace_syscalls.c                      |    1 +
 kernel/up.c                                        |    2 +-
 kernel/user-return-notifier.c                      |    2 +-
 kernel/user.c                                      |    2 +-
 kernel/user_namespace.c                            |    2 +-
 kernel/utsname.c                                   |    2 +-
 kernel/utsname_sysctl.c                            |    2 +-
 kernel/wait.c                                      |    2 +-
 kernel/watchdog.c                                  |    3 +-
 kernel/workqueue.c                                 |    2 +-
 lib/dma-debug.c                                    |    1 +
 lib/raid6/algos.c                                  |    1 +
 lib/raid6/mktables.c                               |    1 +
 lib/raid6/recov.c                                  |    1 +
 mm/fremap.c                                        |    1 -
 mm/memcontrol.c                                    |    1 +
 mm/memory-failure.c                                |    1 +
 mm/mmzone.c                                        |    1 -
 mm/quicklist.c                                     |    1 -
 mm/sparse-vmemmap.c                                |    1 -
 mm/swap_state.c                                    |    1 -
 mm/swapfile.c                                      |    1 -
 net/caif/cfpkt_skbuff.c                            |    1 +
 net/netfilter/ipset/pfxlen.c                       |    1 +
 net/rfkill/input.c                                 |    1 +
 security/selinux/netlink.c                         |    1 +
 sound/core/control.c                               |    1 +
 sound/core/device.c                                |    1 +
 sound/core/hwdep.c                                 |    1 +
 sound/core/info.c                                  |    1 +
 sound/core/info_oss.c                              |    1 +
 sound/core/init.c                                  |    1 +
 sound/core/isadma.c                                |    1 +
 sound/core/jack.c                                  |    1 +
 sound/core/memory.c                                |    1 +
 sound/core/misc.c                                  |    1 +
 sound/core/oss/mixer_oss.c                         |    1 +
 sound/core/rawmidi.c                               |    1 +
 sound/core/rtctimer.c                              |    2 +-
 sound/core/seq/oss/seq_oss.c                       |    2 +-
 sound/core/seq/oss/seq_oss_init.c                  |    2 +-
 sound/core/seq/oss/seq_oss_synth.c                 |    1 +
 sound/core/seq/seq.c                               |    2 +-
 sound/core/seq/seq_clientmgr.c                     |    1 +
 sound/core/seq/seq_device.c                        |    1 +
 sound/core/seq/seq_dummy.c                         |    2 +-
 sound/core/seq/seq_info.c                          |    1 +
 sound/core/seq/seq_lock.c                          |    1 +
 sound/core/seq/seq_memory.c                        |    1 +
 sound/core/seq/seq_midi.c                          |    2 +-
 sound/core/seq/seq_midi_emul.c                     |    1 +
 sound/core/seq/seq_midi_event.c                    |    1 +
 sound/core/seq/seq_ports.c                         |    1 +
 sound/core/seq/seq_system.c                        |    1 +
 sound/core/seq/seq_virmidi.c                       |    1 +
 sound/core/sound.c                                 |    2 +-
 sound/core/sound_oss.c                             |    1 +
 sound/core/timer.c                                 |    2 +-
 sound/core/vmaster.c                               |    1 +
 sound/drivers/mpu401/mpu401.c                      |    2 +-
 sound/drivers/mpu401/mpu401_uart.c                 |    1 +
 sound/drivers/mtpav.c                              |    1 +
 sound/drivers/mts64.c                              |    1 +
 sound/drivers/opl3/opl3_lib.c                      |    1 +
 sound/drivers/opl3/opl3_oss.c                      |    1 +
 sound/drivers/opl3/opl3_seq.c                      |    1 +
 sound/drivers/opl3/opl3_synth.c                    |    1 +
 sound/drivers/opl4/opl4_lib.c                      |    1 +
 sound/drivers/opl4/opl4_proc.c                     |    1 +
 sound/drivers/opl4/opl4_seq.c                      |    1 +
 sound/drivers/portman2x4.c                         |    1 +
 sound/drivers/serial-u16550.c                      |    2 +-
 sound/drivers/virmidi.c                            |    2 +-
 sound/firewire/iso-resources.c                     |    1 +
 sound/firewire/packets-buffer.c                    |    1 +
 sound/i2c/i2c.c                                    |    1 +
 sound/i2c/other/ak4xxx-adda.c                      |    1 +
 sound/i2c/other/pt2258.c                           |    1 +
 sound/i2c/other/tea575x-tuner.c                    |    1 +
 sound/i2c/tea6330t.c                               |    1 +
 sound/isa/sb/emu8000.c                             |    1 +
 sound/isa/sb/emu8000_callback.c                    |    1 +
 sound/isa/sb/emu8000_patch.c                       |    1 +
 sound/isa/sb/emu8000_synth.c                       |    1 +
 sound/isa/wavefront/wavefront_fx.c                 |    1 +
 sound/isa/wavefront/wavefront_synth.c              |    1 +
 sound/pci/als4000.c                                |    2 +-
 sound/pci/asihpi/hpioctl.c                         |    1 +
 sound/pci/ctxfi/xfi.c                              |    1 +
 sound/pci/oxygen/oxygen_io.c                       |    1 +
 sound/soc/tegra/tegra_asoc_utils.c                 |    1 +
 sound/synth/emux/emux.c                            |    1 +
 sound/synth/emux/emux_oss.c                        |    1 +
 sound/synth/emux/emux_seq.c                        |    2 +-
 sound/synth/emux/emux_synth.c                      |    1 +
 sound/synth/emux/soundfont.c                       |    1 +
 sound/synth/util_mem.c                             |    1 +
 sound/usb/6fire/firmware.c                         |    1 +
 sound/usb/midi.c                                   |    1 +
 virt/kvm/iommu.c                                   |    2 +
 1381 files changed, 1514 insertions(+), 428 deletions(-)
 create mode 100644 include/linux/export.h
