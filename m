Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab0CRPWN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 11:22:13 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53376 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab0CRPWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 11:22:10 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [V2 PATCH 00/10] of: Consolidate scattered device node pointers in
	struct device
To: davem@davemloft.net, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, michal.simek@petalogix.com,
       linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
       microblaze-uclinux@itee.uq.edu.au
Date: Thu, 18 Mar 2010 09:22:05 -0600
Message-ID: <20100318144836.21082.93040.stgit@angua>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, each of_device has a copy of the device tree node pointer in both
.node, and in .dev.archdata.of_node (microblaze and powerpc) or
.dev.archdata.prom_node (sparc).  Also, other architectures will be adding
CONFIG_OF support, and they will also need a reference to the device tree
node pointer from struct device.

This series consolidates the device node pointer by adding .of_node to
struct device (conditional on CONFIG_OF) and removing the archdata.of_node,
archdata.prom_node and of_device.node users.  The pointer is moved out of
dev_archdata and into struct device proper so that of_node doesn't need to
get manually added to archdata for each architecture that enables CONFIG_OF.

Based on v2.6.34-rc1

Series should be fully bisectable.
 - Patch 1 adds the new device.of_node pointer and sets the value in all the
   needed places.
 - Patches 2-6 eliminate all readers of the old values
 - Patch 7 removes references to the archdata stuff from drivers/of (there
   are no more users at this point)
 - Patches 8-10 finally remove the old versions.

My goal is to get patches 1-5 into linux-next as soon as I've collected acks.
Dave, Michal and Ben, it would be fantastic if you're able to give this
series a spin.  Once I've gotten the okay from you I can then start merging
the driver changes from patch 6 as I receive acks from the various subsystem
maintainers (I'm still maintaining the drivers changes in a large series of
per-subsystem patches so I can add them to linux-next as maintainers
respond, but for this posting I've rolled them all up to make it easy to
handle.)  I'll add the last 4 patches to linux-next once all the driver
changes are committed.

Build tested on powerpc (32 & 64 bit), sparc (32 & 64), microblaze.  Booted
on MPC5200.

Difference from v1:
 - some cleanups and fixed more references to the old properties.
 - rolled all the drivers/ and sound/ changes into a single patch to
   simplify review.
---

Grant Likely (10):
      arch/sparc: Remove obsolete dev_archdata.prom_node and of_devce.node
      arch/microblaze: Remove obsolete dev_archdata.of_node and of_devce.node
      arch/powerpc: Remove obsolete dev_archdata.of_node and of_devce.node
      of: eliminate calls to dev_archdata_set_node()
      of/drivers: Always use struct device.of_node to get node pointer
      arch/microblaze: Always use 'struct device.of_node' to get device node pointer.
      arch/powerpc: Always use 'struct device.of_node' to get device node pointer.
      arch/sparc: Always use 'struct device.of_node' to get device node pointer.
      i2c/of: Allow device node to be passed via i2c_board_info
      driver-core: Add device node pointer to struct device


 arch/microblaze/include/asm/device.h          |   14 ------------
 arch/microblaze/include/asm/of_device.h       |    1 -
 arch/microblaze/kernel/of_device.c            |   11 ++++-----
 arch/microblaze/kernel/of_platform.c          |    4 ++-
 arch/powerpc/include/asm/device.h             |   15 -------------
 arch/powerpc/include/asm/macio.h              |    2 +-
 arch/powerpc/include/asm/of_device.h          |    1 -
 arch/powerpc/kernel/ibmebus.c                 |    4 ++-
 arch/powerpc/kernel/of_device.c               |   11 ++++-----
 arch/powerpc/kernel/of_platform.c             |   16 +++++++-------
 arch/powerpc/kernel/pci-common.c              |    4 ++-
 arch/powerpc/kernel/vio.c                     |   18 ++++++++--------
 arch/powerpc/platforms/52xx/mpc52xx_gpio.c    |    4 ++-
 arch/powerpc/platforms/52xx/mpc52xx_gpt.c     |   16 +++++++-------
 arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c |    6 +++--
 arch/powerpc/platforms/82xx/ep8248e.c         |    6 +++--
 arch/powerpc/platforms/83xx/suspend.c         |    2 +-
 arch/powerpc/platforms/cell/axon_msi.c        |    2 +-
 arch/powerpc/platforms/cell/iommu.c           |    5 ++--
 arch/powerpc/platforms/pasemi/gpio_mdio.c     |    2 +-
 arch/powerpc/platforms/pasemi/setup.c         |    4 ++-
 arch/powerpc/platforms/ps3/system-bus.c       |    2 +-
 arch/powerpc/platforms/pseries/iommu.c        |    2 +-
 arch/powerpc/sysdev/axonram.c                 |    6 +++--
 arch/powerpc/sysdev/bestcomm/bestcomm.c       |    8 +++----
 arch/powerpc/sysdev/fsl_msi.c                 |   14 ++++++------
 arch/powerpc/sysdev/fsl_pmc.c                 |    2 +-
 arch/powerpc/sysdev/pmi.c                     |    2 +-
 arch/sparc/include/asm/device.h               |   15 -------------
 arch/sparc/include/asm/fb.h                   |    2 +-
 arch/sparc/include/asm/floppy_64.h            |    4 ++-
 arch/sparc/include/asm/of_device.h            |    1 -
 arch/sparc/include/asm/parport.h              |    2 +-
 arch/sparc/kernel/auxio_64.c                  |    2 +-
 arch/sparc/kernel/central.c                   |    4 ++-
 arch/sparc/kernel/chmc.c                      |   10 ++++-----
 arch/sparc/kernel/ioport.c                    |    2 +-
 arch/sparc/kernel/of_device_32.c              |   17 +++++++--------
 arch/sparc/kernel/of_device_64.c              |   29 ++++++++++++-------------
 arch/sparc/kernel/of_device_common.c          |    4 ++-
 arch/sparc/kernel/pci.c                       |   14 +++++-------
 arch/sparc/kernel/pci_common.c                |    9 ++++----
 arch/sparc/kernel/pci_fire.c                  |    4 ++-
 arch/sparc/kernel/pci_msi.c                   |   18 ++++++++--------
 arch/sparc/kernel/pci_psycho.c                |    4 ++-
 arch/sparc/kernel/pci_sabre.c                 |    4 ++-
 arch/sparc/kernel/pci_schizo.c                |   14 ++++++------
 arch/sparc/kernel/pci_sun4v.c                 |    8 +++----
 arch/sparc/kernel/power.c                     |    4 ++-
 arch/sparc/kernel/psycho_common.c             |    2 +-
 arch/sparc/kernel/sbus.c                      |   16 +++++++-------
 arch/sparc/kernel/time_32.c                   |    2 +-
 arch/sparc/kernel/time_64.c                   |    6 +++--
 drivers/ata/pata_macio.c                      |    2 +-
 drivers/ata/pata_mpc52xx.c                    |   10 ++++-----
 drivers/ata/pata_of_platform.c                |    2 +-
 drivers/atm/fore200e.c                        |   16 ++++++++------
 drivers/block/xsysace.c                       |    8 +++----
 drivers/cdrom/viocd.c                         |    2 +-
 drivers/char/hw_random/n2-drv.c               |    2 +-
 drivers/char/hw_random/pasemi-rng.c           |    2 +-
 drivers/char/ipmi/ipmi_si_intf.c              |    4 ++-
 drivers/char/viotape.c                        |    2 +-
 drivers/char/xilinx_hwicap/xilinx_hwicap.c    |    6 +++--
 drivers/gpio/pca953x.c                        |    2 +-
 drivers/i2c/busses/i2c-ibm_iic.c              |    4 ++-
 drivers/i2c/busses/i2c-mpc.c                  |   17 ++++++++-------
 drivers/i2c/i2c-core.c                        |    3 +++
 drivers/ide/pmac.c                            |   10 ++++-----
 drivers/infiniband/hw/ehca/ehca_main.c        |   11 +++++----
 drivers/input/serio/i8042-sparcio.h           |    2 +-
 drivers/input/serio/xilinx_ps2.c              |    8 +++----
 drivers/leds/leds-gpio.c                      |    2 +-
 drivers/macintosh/macio_asic.c                |   16 +++++++-------
 drivers/macintosh/macio_sysfs.c               |    6 +++--
 drivers/macintosh/rack-meter.c                |    4 ++-
 drivers/macintosh/therm_pm72.c                |    2 +-
 drivers/mmc/host/of_mmc_spi.c                 |    4 ++-
 drivers/mmc/host/sdhci-of-core.c              |    2 +-
 drivers/mtd/maps/physmap_of.c                 |    6 +++--
 drivers/mtd/maps/sun_uflash.c                 |    2 +-
 drivers/mtd/nand/fsl_elbc_nand.c              |    6 +++--
 drivers/mtd/nand/pasemi_nand.c                |    2 +-
 drivers/net/can/sja1000/sja1000_of_platform.c |    4 ++-
 drivers/net/ehea/ehea_main.c                  |   14 ++++++------
 drivers/net/fec_mpc52xx.c                     |   12 +++++-----
 drivers/net/fec_mpc52xx_phy.c                 |    4 ++-
 drivers/net/greth.c                           |    3 ++-
 drivers/net/ibm_newemac/core.c                |   13 ++++++-----
 drivers/net/ibm_newemac/debug.c               |    9 ++++----
 drivers/net/ibm_newemac/debug.h               |    4 ++-
 drivers/net/ibm_newemac/mal.c                 |   28 ++++++++++++------------
 drivers/net/ibm_newemac/rgmii.c               |   12 +++++-----
 drivers/net/ibm_newemac/tah.c                 |    7 +++---
 drivers/net/ibm_newemac/zmii.c                |    9 ++++----
 drivers/net/ll_temac_main.c                   |   10 ++++-----
 drivers/net/myri_sbus.c                       |    2 +-
 drivers/net/niu.c                             |   10 ++++-----
 drivers/net/phy/mdio-gpio.c                   |    6 +++--
 drivers/net/sunbmac.c                         |    6 +++--
 drivers/net/sunhme.c                          |    8 +++----
 drivers/net/sunlance.c                        |    6 +++--
 drivers/net/sunqe.c                           |    6 +++--
 drivers/net/xilinx_emaclite.c                 |   10 ++++-----
 drivers/of/device.c                           |   20 +++++++++--------
 drivers/of/of_i2c.c                           |    4 ++-
 drivers/of/of_mdio.c                          |    6 +++--
 drivers/of/of_spi.c                           |    2 +-
 drivers/pcmcia/electra_cf.c                   |    2 +-
 drivers/sbus/char/bbc_envctrl.c               |    4 ++-
 drivers/sbus/char/bbc_i2c.c                   |    4 ++-
 drivers/sbus/char/display7seg.c               |    2 +-
 drivers/sbus/char/envctrl.c                   |    2 +-
 drivers/sbus/char/flash.c                     |    4 ++-
 drivers/sbus/char/uctrl.c                     |    2 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                |    2 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c              |    2 +-
 drivers/scsi/qlogicpti.c                      |   10 ++++-----
 drivers/scsi/sun_esp.c                        |   16 +++++++-------
 drivers/serial/apbuart.c                      |    2 +-
 drivers/serial/mpc52xx_uart.c                 |    8 +++----
 drivers/serial/nwpserial.c                    |    2 +-
 drivers/serial/of_serial.c                    |    4 ++-
 drivers/serial/pmac_zilog.c                   |    2 +-
 drivers/serial/sunhv.c                        |    2 +-
 drivers/serial/sunsab.c                       |    6 +++--
 drivers/serial/sunsu.c                        |    6 +++--
 drivers/serial/sunzilog.c                     |    8 +++----
 drivers/serial/uartlite.c                     |    6 +++--
 drivers/spi/mpc52xx_psc_spi.c                 |   11 +++++----
 drivers/spi/mpc52xx_spi.c                     |   14 ++++++------
 drivers/spi/spi_mpc8xxx.c                     |    6 +++--
 drivers/usb/host/ehci-ppc-of.c                |    2 +-
 drivers/usb/host/isp1760-if.c                 |    2 +-
 drivers/usb/host/ohci-ppc-of.c                |    2 +-
 drivers/video/cg6.c                           |    2 +-
 drivers/video/ffb.c                           |    2 +-
 drivers/video/fsl-diu-fb.c                    |    2 +-
 drivers/video/xilinxfb.c                      |   18 ++++++++--------
 drivers/watchdog/cpwd.c                       |    2 +-
 include/linux/device.h                        |    4 +++
 include/linux/i2c.h                           |    4 +++
 sound/aoa/fabrics/layout.c                    |    2 +-
 sound/aoa/soundbus/core.c                     |    8 +++----
 sound/aoa/soundbus/i2sbus/control.c           |    2 +-
 sound/aoa/soundbus/i2sbus/core.c              |    4 ++-
 sound/aoa/soundbus/sysfs.c                    |    4 ++-
 sound/soc/fsl/mpc8610_hpcd.c                  |    2 +-
 sound/sparc/cs4231.c                          |    6 +++--
 sound/sparc/dbri.c                            |    2 +-
 150 files changed, 463 insertions(+), 495 deletions(-)

-- 
Signature
