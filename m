Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab0EVIB2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 04:01:28 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:52250 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab0EVIB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 04:01:26 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sat, 22 May 2010 02:01:05 -0600
X-Google-Sender-Auth: ZcTiqLwL1tfbazQhGxJ1hRgeHZ4
Message-ID: <AANLkTinhSv7X7su3VMPamdncR1-YBMtwpwgIpxz0v8ls@mail.gmail.com>
Subject: [git pull] OF cleanups
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, Michal Simek <monstr@monstr.eu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This tree *looks* big and scary, but it is really just mechanical
changes moving some of the OF related pointers around and eliminated
duplicates.  The only real functional change is the i2c patch which
changes the method for passing the node pointer when registering i2c
devices from the tree.  The rest is just marching through and
converting users to the new pointer locations.  Any mistakes made or
drivers missed will fail at compile time in obvious ways (but
hopefully between linux-next and my own testing I've caught all the
users).

It's been tested in linux-next, plus a merge with your current tree to
resolve a merge conflict and a compile error.

The following changes since commit f4b87dee923342505e1ddba8d34ce9de33e75050:
  Randy Dunlap (1):
        fbmem: avoid printk format warning with 32-bit resources

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 next-devicetree

Grant Likely (13):
      of/flattree: make of_fdt.h safe to unconditionally include.
      of/flattree: Make unflatten_device_tree() safe to call from any arch
      of: protect contents of of_platform.h and of_device.h
      driver-core: Add device node pointer to struct device
      i2c/of: Allow device node to be passed via i2c_board_info
      of: Always use 'struct device.of_node' to get device node pointer.
      of: eliminate of_device->node and dev_archdata->{of,prom}_node
      arch/powerpc: Move dma_mask from of_device into pdev_archdata
      arch/microblaze: Move dma_mask from of_device into pdev_archdata
      drivercore: Add of_match_table to the common device drivers
      of: Remove duplicate fields from of_platform_driver
      of: change of_match_device to work with struct device
      Merge remote branch 'origin' into secretlab/next-devicetree

 arch/microblaze/include/asm/device.h          |   16 +----------
 arch/microblaze/include/asm/of_device.h       |    3 +-
 arch/microblaze/kernel/of_device.c            |   13 ++++-----
 arch/microblaze/kernel/of_platform.c          |    6 ++--
 arch/powerpc/include/asm/device.h             |   16 +----------
 arch/powerpc/include/asm/macio.h              |    2 +-
 arch/powerpc/include/asm/of_device.h          |    3 +-
 arch/powerpc/kernel/ibmebus.c                 |    6 ++--
 arch/powerpc/kernel/of_device.c               |   13 ++++-----
 arch/powerpc/kernel/of_platform.c             |   21 +++++++-------
 arch/powerpc/kernel/pci-common.c              |    4 +-
 arch/powerpc/kernel/vio.c                     |   20 +++++++-------
 arch/powerpc/platforms/52xx/mpc52xx_gpio.c    |   18 ++++++++----
 arch/powerpc/platforms/52xx/mpc52xx_gpt.c     |   23 +++++++++-------
 arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c |   14 +++++----
 arch/powerpc/platforms/82xx/ep8248e.c         |    9 +++---
 arch/powerpc/platforms/83xx/suspend.c         |    9 ++++--
 arch/powerpc/platforms/cell/axon_msi.c        |    9 +++---
 arch/powerpc/platforms/cell/iommu.c           |    5 +--
 arch/powerpc/platforms/pasemi/gpio_mdio.c     |    9 +++---
 arch/powerpc/platforms/pasemi/setup.c         |    4 +-
 arch/powerpc/platforms/ps3/system-bus.c       |    2 +-
 arch/powerpc/platforms/pseries/iommu.c        |    2 +-
 arch/powerpc/sysdev/axonram.c                 |   14 +++++-----
 arch/powerpc/sysdev/bestcomm/bestcomm.c       |   18 +++++-------
 arch/powerpc/sysdev/fsl_msi.c                 |   21 ++++++++------
 arch/powerpc/sysdev/fsl_pmc.c                 |    9 ++++--
 arch/powerpc/sysdev/fsl_rio.c                 |   37 +++++++++++++-----------
 arch/powerpc/sysdev/pmi.c                     |    9 +++---
 arch/powerpc/sysdev/qe_lib/qe.c               |    7 +++-
 arch/sparc/include/asm/device.h               |   15 ----------
 arch/sparc/include/asm/fb.h                   |    2 +-
 arch/sparc/include/asm/floppy_64.h            |    4 +-
 arch/sparc/include/asm/of_device.h            |    1 -
 arch/sparc/include/asm/parport.h              |    9 ++++--
 arch/sparc/kernel/apc.c                       |    7 +++-
 arch/sparc/kernel/auxio_64.c                  |    9 +++---
 arch/sparc/kernel/central.c                   |   18 +++++++-----
 arch/sparc/kernel/chmc.c                      |   17 +++++++-----
 arch/sparc/kernel/ioport.c                    |    2 +-
 arch/sparc/kernel/of_device_32.c              |   17 +++++------
 arch/sparc/kernel/of_device_64.c              |   29 +++++++++----------
 arch/sparc/kernel/of_device_common.c          |    4 +-
 arch/sparc/kernel/pci.c                       |   14 ++++-----
 arch/sparc/kernel/pci_common.c                |    9 +++---
 arch/sparc/kernel/pci_fire.c                  |   11 +++++---
 arch/sparc/kernel/pci_msi.c                   |   18 ++++++------
 arch/sparc/kernel/pci_psycho.c                |   11 +++++---
 arch/sparc/kernel/pci_sabre.c                 |   11 +++++---
 arch/sparc/kernel/pci_schizo.c                |   21 ++++++++------
 arch/sparc/kernel/pci_sun4v.c                 |   15 ++++++----
 arch/sparc/kernel/pmc.c                       |    7 +++-
 arch/sparc/kernel/power.c                     |   11 ++++---
 arch/sparc/kernel/psycho_common.c             |    2 +-
 arch/sparc/kernel/sbus.c                      |   16 +++++-----
 arch/sparc/kernel/time_32.c                   |    9 +++---
 arch/sparc/kernel/time_64.c                   |   27 ++++++++++--------
 drivers/ata/pata_macio.c                      |    2 +-
 drivers/ata/pata_mpc52xx.c                    |   14 ++++-----
 drivers/ata/pata_of_platform.c                |    9 ++++--
 drivers/ata/sata_fsl.c                        |   11 +++++---
 drivers/atm/fore200e.c                        |   23 +++++++++------
 drivers/block/swim3.c                         |    2 +-
 drivers/block/xsysace.c                       |   13 ++++-----
 drivers/cdrom/viocd.c                         |    2 +-
 drivers/char/hw_random/n2-drv.c               |    9 ++++--
 drivers/char/hw_random/pasemi-rng.c           |    9 ++++--
 drivers/char/ipmi/ipmi_si_intf.c              |   11 +++++---
 drivers/char/viotape.c                        |    2 +-
 drivers/char/xilinx_hwicap/xilinx_hwicap.c    |   11 +++----
 drivers/crypto/amcc/crypto4xx_core.c          |    7 +++-
 drivers/crypto/talitos.c                      |    9 ++++--
 drivers/dma/fsldma.c                          |   17 +++++++-----
 drivers/dma/ppc4xx/adma.c                     |    2 +-
 drivers/edac/mpc85xx_edac.c                   |   30 ++++++++------------
 drivers/edac/ppc4xx_edac.c                    |   10 +++---
 drivers/gpio/pca953x.c                        |    2 +-
 drivers/hwmon/ultra45_env.c                   |    7 +++-
 drivers/i2c/busses/i2c-cpm.c                  |   30 ++++++++++----------
 drivers/i2c/busses/i2c-ibm_iic.c              |   11 +++++---
 drivers/i2c/busses/i2c-mpc.c                  |   25 +++++++++--------
 drivers/i2c/i2c-core.c                        |    3 ++
 drivers/ide/pmac.c                            |   10 +++---
 drivers/infiniband/hw/ehca/ehca_main.c        |   18 +++++++-----
 drivers/input/misc/sparcspkr.c                |   14 +++++++---
 drivers/input/serio/i8042-sparcio.h           |    9 ++++--
 drivers/input/serio/xilinx_ps2.c              |   15 ++++++----
 drivers/leds/leds-gpio.c                      |    4 +-
 drivers/macintosh/macio_asic.c                |   28 +++++++++----------
 drivers/macintosh/macio_sysfs.c               |    6 ++--
 drivers/macintosh/mediabay.c                  |    2 +-
 drivers/macintosh/rack-meter.c                |    4 +-
 drivers/macintosh/smu.c                       |    7 +++-
 drivers/macintosh/therm_pm72.c                |    9 ++++--
 drivers/macintosh/therm_windtunnel.c          |    7 +++-
 drivers/mmc/host/of_mmc_spi.c                 |    4 +-
 drivers/mmc/host/sdhci-of-core.c              |    9 ++++--
 drivers/mtd/maps/physmap_of.c                 |   13 +++++---
 drivers/mtd/maps/sun_uflash.c                 |    9 ++++--
 drivers/mtd/nand/fsl_elbc_nand.c              |   11 ++++---
 drivers/mtd/nand/fsl_upm.c                    |    7 +++-
 drivers/mtd/nand/ndfc.c                       |   15 +++++-----
 drivers/mtd/nand/pasemi_nand.c                |    9 ++++--
 drivers/mtd/nand/socrates_nand.c              |    7 +++-
 drivers/net/can/mscan/mpc5xxx_can.c           |    8 +++--
 drivers/net/can/sja1000/sja1000_of_platform.c |   12 +++++---
 drivers/net/ehea/ehea_main.c                  |   21 ++++++++------
 drivers/net/fec_mpc52xx.c                     |   20 +++++++------
 drivers/net/fec_mpc52xx_phy.c                 |   11 +++++---
 drivers/net/fs_enet/fs_enet-main.c            |   15 ++++++----
 drivers/net/fs_enet/mac-fcc.c                 |    8 +++---
 drivers/net/fs_enet/mac-fec.c                 |    4 +-
 drivers/net/fs_enet/mac-scc.c                 |    6 ++--
 drivers/net/fs_enet/mii-bitbang.c             |    7 +++-
 drivers/net/fs_enet/mii-fec.c                 |   13 +++++---
 drivers/net/fsl_pq_mdio.c                     |    9 ++++--
 drivers/net/gianfar.c                         |   16 ++++++-----
 drivers/net/greth.c                           |    3 +-
 drivers/net/ibm_newemac/core.c                |   21 ++++++++------
 drivers/net/ibm_newemac/debug.c               |    9 +++---
 drivers/net/ibm_newemac/debug.h               |    4 +-
 drivers/net/ibm_newemac/mal.c                 |   36 +++++++++++++-----------
 drivers/net/ibm_newemac/rgmii.c               |   20 +++++++------
 drivers/net/ibm_newemac/tah.c                 |   15 ++++++----
 drivers/net/ibm_newemac/zmii.c                |   17 +++++++-----
 drivers/net/ll_temac_main.c                   |   12 ++++----
 drivers/net/myri_sbus.c                       |    9 ++++--
 drivers/net/niu.c                             |   17 +++++++-----
 drivers/net/phy/mdio-gpio.c                   |   13 +++++---
 drivers/net/sunbmac.c                         |   13 +++++---
 drivers/net/sunhme.c                          |   15 ++++++----
 drivers/net/sunlance.c                        |   13 +++++---
 drivers/net/sunqe.c                           |   13 +++++---
 drivers/net/ucc_geth.c                        |    9 ++++--
 drivers/net/xilinx_emaclite.c                 |   17 +++++++-----
 drivers/of/device.c                           |   25 ++++++++---------
 drivers/of/fdt.c                              |   15 ++++++++++
 drivers/of/of_i2c.c                           |    4 +-
 drivers/of/of_mdio.c                          |    6 ++--
 drivers/of/of_spi.c                           |    2 +-
 drivers/of/platform.c                         |   13 ++-------
 drivers/parport/parport_sunbpp.c              |    7 +++-
 drivers/pcmcia/electra_cf.c                   |    9 ++++--
 drivers/pcmcia/m8xx_pcmcia.c                  |    7 +++-
 drivers/sbus/char/bbc_envctrl.c               |    4 +-
 drivers/sbus/char/bbc_i2c.c                   |   11 +++++---
 drivers/sbus/char/display7seg.c               |    9 ++++--
 drivers/sbus/char/envctrl.c                   |    9 ++++--
 drivers/sbus/char/flash.c                     |   11 +++++---
 drivers/sbus/char/uctrl.c                     |    9 ++++--
 drivers/scsi/ibmvscsi/ibmvfc.c                |    2 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c              |    2 +-
 drivers/scsi/qlogicpti.c                      |   17 +++++++-----
 drivers/scsi/sun_esp.c                        |   23 +++++++++-------
 drivers/serial/apbuart.c                      |   10 +++---
 drivers/serial/cpm_uart/cpm_uart_core.c       |    9 ++++--
 drivers/serial/mpc52xx_uart.c                 |   15 +++++-----
 drivers/serial/nwpserial.c                    |    2 +-
 drivers/serial/of_serial.c                    |   12 +++++---
 drivers/serial/pmac_zilog.c                   |    2 +-
 drivers/serial/sunhv.c                        |    9 ++++--
 drivers/serial/sunsab.c                       |   13 +++++---
 drivers/serial/sunsu.c                        |   13 +++++---
 drivers/serial/sunzilog.c                     |   15 ++++++----
 drivers/serial/uartlite.c                     |   11 +++----
 drivers/serial/ucc_uart.c                     |   10 ++++---
 drivers/spi/mpc52xx_psc_spi.c                 |   15 +++++-----
 drivers/spi/mpc52xx_spi.c                     |   22 ++++++++-------
 drivers/spi/spi_mpc8xxx.c                     |   15 ++++++----
 drivers/spi/spi_ppc4xx.c                      |    2 +-
 drivers/spi/xilinx_spi_of.c                   |    2 +-
 drivers/usb/gadget/fsl_qe_udc.c               |    7 +++-
 drivers/usb/host/ehci-ppc-of.c                |   11 +++----
 drivers/usb/host/ehci-xilinx-of.c             |    9 +++---
 drivers/usb/host/fhci-hcd.c                   |   11 +++++---
 drivers/usb/host/isp1760-if.c                 |    9 ++++--
 drivers/usb/host/ohci-ppc-of.c                |   15 +++-------
 drivers/video/bw2.c                           |    7 +++-
 drivers/video/cg14.c                          |    7 +++-
 drivers/video/cg3.c                           |    7 +++-
 drivers/video/cg6.c                           |    9 ++++--
 drivers/video/ffb.c                           |    9 ++++--
 drivers/video/fsl-diu-fb.c                    |   10 ++++---
 drivers/video/leo.c                           |    7 +++-
 drivers/video/mb862xx/mb862xxfb.c             |    8 +++--
 drivers/video/p9100.c                         |    7 +++-
 drivers/video/platinumfb.c                    |    9 ++++--
 drivers/video/sunxvr1000.c                    |    9 ++++--
 drivers/video/tcx.c                           |    7 +++-
 drivers/video/xilinxfb.c                      |   23 +++++++--------
 drivers/watchdog/cpwd.c                       |    9 ++++--
 drivers/watchdog/gef_wdt.c                    |    8 +++--
 drivers/watchdog/mpc8xxx_wdt.c                |    8 +++---
 drivers/watchdog/riowd.c                      |    7 +++-
 include/linux/device.h                        |    8 +++++
 include/linux/i2c.h                           |    4 +++
 include/linux/of_device.h                     |    4 ++-
 include/linux/of_fdt.h                        |    4 +++
 include/linux/of_platform.h                   |    6 +---
 sound/aoa/fabrics/layout.c                    |    2 +-
 sound/aoa/soundbus/core.c                     |    8 +++---
 sound/aoa/soundbus/i2sbus/control.c           |    2 +-
 sound/aoa/soundbus/i2sbus/core.c              |    8 +++---
 sound/aoa/soundbus/sysfs.c                    |    4 +-
 sound/soc/fsl/mpc5200_dma.c                   |    6 ++--
 sound/soc/fsl/mpc5200_psc_ac97.c              |    2 +-
 sound/soc/fsl/mpc5200_psc_i2s.c               |    4 +-
 sound/soc/fsl/mpc8610_hpcd.c                  |   10 ++++---
 sound/sparc/amd7930.c                         |    7 +++-
 sound/sparc/cs4231.c                          |   13 +++++---
 sound/sparc/dbri.c                            |    9 ++++--
 211 files changed, 1254 insertions(+), 974 deletions(-)


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
