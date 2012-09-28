Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031400Ab2I1Thr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:37:47 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:38829 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965316Ab2I1Tho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:37:44 -0400
From: Matt Porter <mporter@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>, Benoit Cousson <b-cousson@ti.com>,
        Paul Walmsley <paul@pwsan.com>, Sekhar Nori <nsekhar@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>
Subject: [PATCH v2 0/7] uio_pruss cleanup and platform support
Date: Fri, 28 Sep 2012 15:37:45 -0400
Message-Id: <1348861072-14507-1-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v1:
	- Replaced uio_pruss private SRAM API use with genalloc
	- Added DA850 platform device and clock support
	- Added DA850 L3 RAM gen_pool support
	- Split out DT binding

This series enables uio_pruss on both DA850 and AM33xx. The driver
previously was not enabled by any platform and the private SRAM API
was accessing an invalid SRAM bank for use on DA850. For AM33xx,
DT, pinctrl, and runtime PM support are added since AM33xx only
boots via DT.

The AM33xx support requires some help in hwmod due to the following
comment in arch/arm/mach-omap2/omap_hwmod.c:
	/*
	 * If an IP block contains HW reset lines and any of them are
	 * asserted, we let integration code associated with that
	 * block handle the enable.  We've received very little
	 * information on what those driver authors need, and until
	 * detailed information is provided and the driver code is
	 * posted to the public lists, this is probably the best we
	 * can do.
	 */

The approach to deal with the hardware reset (for at least the pruss
hwmod) was to add a generic omap property to properly define this
hardware. The implementation simply deasserts any rst lines that
are called out in the property when the omap_device is
instantiated. This is not the ideal implementation as the sequence is
a bit wrong for pruss since the busy check during the hard reset
will fail, even though it fails in a benign manner. Ideally, we would
want the implementation to observe the ti,deassert-hard-reset property
and use that in omap_hwmod.c:_enable() *after* the module is unidled
and the clocks active. However, this is actually functional for purposes
of getting the uio_pruss driver up and running.

Matt Porter (7):
  uio: uio_pruss: replace private SRAM API with genalloc
  uio: uio_pruss: add support for am33xx
  uio: dt: add TI PRUSS binding
  ARM: davinci: Add support for an L3RAM gen_pool
  ARM: davinci: Add support for PRUSS on DA850
  ARM: omap: add DT support for deasserting hardware reset lines
  ARM: dts: AM33xx PRUSS support

 .../devicetree/bindings/arm/omap/omap.txt          |    2 +
 Documentation/devicetree/bindings/uio/pruss.txt    |   17 +++
 arch/arm/boot/dts/am335x-bone.dts                  |    4 +
 arch/arm/boot/dts/am33xx.dtsi                      |   11 ++
 arch/arm/mach-davinci/board-da850-evm.c            |   12 +++
 arch/arm/mach-davinci/da850.c                      |    9 ++
 arch/arm/mach-davinci/devices-da8xx.c              |   66 ++++++++++++
 arch/arm/mach-davinci/include/mach/common.h        |    2 +
 arch/arm/mach-davinci/include/mach/da8xx.h         |    3 +
 arch/arm/mach-davinci/include/mach/sram.h          |    3 +
 arch/arm/mach-davinci/sram.c                       |   28 ++++-
 arch/arm/plat-omap/omap_device.c                   |   25 ++++-
 drivers/uio/Kconfig                                |    5 +-
 drivers/uio/uio_pruss.c                            |  108 +++++++++++++++-----
 include/linux/platform_data/uio_pruss.h            |    3 +-
 15 files changed, 269 insertions(+), 29 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/uio/pruss.txt

-- 
1.7.9.5

