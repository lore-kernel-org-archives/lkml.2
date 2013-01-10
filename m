Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab3AJQvo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 11:51:44 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:50904 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816Ab3AJQvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 11:51:42 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>
CC: <gregkh@linuxfoundation.org>, <sameo@linux.intel.com>, <tony@atomide.com>,
        <kishon@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <rogerq@ti.com>
Subject: [PATCH 00/14] USB: omap-ehci: Move PHY management to PHY driver
Date: Thu, 10 Jan 2013 18:51:20 +0200
Message-ID: <1357836694-30788-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The OMAP's High Speed Host controller can interface to ULPI/UTMI
PHY's transparently i.e. whithout requiring the device drivers to
access the PHY [1]. However, the OS must ensure that the PHY has
the necessary resources (power/clock/reset) enabled before it is used.

Till now, the omap-ehci driver was managing the power and reset of the PHY
whereas, clock enabling was left to the bootloader or board files.

In this patchset we make the NOP PHY driver (nop-usb-xceiv.c) handle
all the PHY resources that are available so that it can be used by
platforms like OMAP.

The omap-ehci driver instantiates a PHY platform device for each port
that is in PHY mode. It then uses the USB PHY APIs to manage the PHY.

All this results in a much cleaner code and makes USB PHY resource management
work properly on OMAP.

NOTE: Only omap4panda board is adapted for the changes. So USB Host will
break for other boards. Once we have done a priliminary review, I can adapt
other boards as well.

This patchset depends on the series
https://lkml.org/lkml/2013/1/2/144
git://github.com/rogerq/linux.git arm-for-next-usbhost9-part

--
cheeer,
-roger

[1] - In practice we would need to access the PHY to work around Silicon Erratas
      in the OMAP's USB Host IP.

Roger Quadros (14):
  mfd: omap-usb-host: Consolidate OMAP USB-HS platform data
  usb: phy: Add new API usb_get_phy_from_dev()
  usb: xceiv: nop: Manage PHY clock
  usb: phy: nop: Handle power supply regulator for the PHY
  usb: phy: nop: Handle RESET for the PHY
  mfd: omap-usb-host: update nports in platform_data
  usb: ehci-omap: Instantiate PHY devices if required
  mfd: omap-usb-host: Remove PHY reset handling code
  usb: ehci-omap: Remove PHY reset handling code
  usb: ehci-omap: Remove PHY regulator handling code
  ARM: OMAP2+: omap4panda: Provide USB Host's PHY platform data
  ARM: OMAP2+: omap4panda: Adapt HUB power to regulator framework
  ARM: OMAP2+: omap4panda: Adapt HUB reset to regulator framework
  ARM: OMAP2+: omap4panda: Remove irrelevant USB host platform data

 arch/arm/mach-omap2/board-3430sdp.c        |    2 +-
 arch/arm/mach-omap2/board-3630sdp.c        |    2 +-
 arch/arm/mach-omap2/board-am3517crane.c    |    2 +-
 arch/arm/mach-omap2/board-am3517evm.c      |    2 +-
 arch/arm/mach-omap2/board-cm-t35.c         |    2 +-
 arch/arm/mach-omap2/board-cm-t3517.c       |    2 +-
 arch/arm/mach-omap2/board-devkit8000.c     |    2 +-
 arch/arm/mach-omap2/board-igep0020.c       |    4 +-
 arch/arm/mach-omap2/board-omap3beagle.c    |    2 +-
 arch/arm/mach-omap2/board-omap3evm.c       |    2 +-
 arch/arm/mach-omap2/board-omap3pandora.c   |    2 +-
 arch/arm/mach-omap2/board-omap3stalker.c   |    2 +-
 arch/arm/mach-omap2/board-omap3touchbook.c |    2 +-
 arch/arm/mach-omap2/board-omap4panda.c     |  117 +++++++++++++-----
 arch/arm/mach-omap2/board-overo.c          |    2 +-
 arch/arm/mach-omap2/board-zoom.c           |    2 +-
 arch/arm/mach-omap2/usb-host.c             |   30 +----
 arch/arm/mach-omap2/usb.h                  |   21 +---
 drivers/mfd/omap-usb-host.c                |   64 +---------
 drivers/mfd/omap-usb-tll.c                 |    8 +-
 drivers/usb/host/ehci-omap.c               |  182 ++++++++++++++--------------
 drivers/usb/otg/nop-usb-xceiv.c            |   86 +++++++++++++
 drivers/usb/otg/otg.c                      |   36 ++++++
 include/linux/platform_data/usb-omap.h     |   28 ++---
 include/linux/usb/nop-usb-xceiv.h          |    1 +
 include/linux/usb/phy.h                    |    6 +
 26 files changed, 345 insertions(+), 266 deletions(-)

-- 
1.7.4.1

