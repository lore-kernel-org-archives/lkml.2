Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab2KUC0w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 21:26:52 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:46892 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab2KUC0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 21:26:50 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Subject: [PATCH 00/42] SH pin control and GPIO rework
Date: Wed, 21 Nov 2012 03:27:01 +0100
Message-Id: <1353464863-10281-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody,

Here's a pretty large patch series that rework pin control and GPIO support
for SH and ARM SH/Renesas Mobile/Car platforms. The patches are based on top
of v3.7-rc6. You can get them from my git tree at

	git://linuxtv.org/pinchartl/fbdev.git pinmux

The idea behind these patches is to move SoC-specific pin control code from
arch/ to drivers/pinctrl/ and use the Linux device model to instantiate the
pin control device. This is required to add device tree support for the pin
control device.

The code has been compile-tested on all modified platforms except SH7264 and
SH7269, and runtime tested on SH7372 (Mackerel), SH73A0 (KZM-A9-GT) and
R8A7740 (Armadillo) so far. I will runtime test it on R8A7779 (Marzen).

The SH7264 and SH7269 platforms have no gpiolib support so the PFC code can't
be compiled for them. As the currently implemented arch-level pinmux support
also depends on generic GPIO, we're moving from a situation where the code
isn't used to a different situation where the code isn't used. I don't
consider that as a regression.

Sorry for the numerous checkpatch warnings, patches that move code around or
rename files don't modify the content to make review easier, and thus carry
warnings from the existing code.

Currently missing from this series are DT bindings. I will send patches for
those a bit later. As they will build on top of this series I would appreciate
reviews (and hopefilly ack's).

Laurent Pinchart (42):
  sh-pfc: Split platform data from the sh_pfc structure
  sh-pfc: Move private definitions and declarations to private header
  sh-pfc: Merge PFC core and pinctrl
  sh-pfc: Merge PFC core and gpio
  sh-pfc: Move platform device and driver to the core
  sh-pfc: Let the compiler decide whether to inline functions
  sh-pfc: Remove check for impossible error condition
  sh-pfc: Sort headers alphabetically
  sh-pfc: Split platform device and platform driver registration
  sh-pfc: Support passing resources through platform device
  ARM: shmobile: Register PFC platform device
  SH: Register PFC platform device
  sh-pfc: Remove platform device registration
  sh-pfc: Remove unused resource and num_resources platform data fields
  ARM: shmobile: Select PINCTRL
  sh: Select PINCTRL for CPU subtypes that require it
  sh-pfc: Move driver from drivers/sh/ to drivers/pinctrl/
  sh-pfc: Support pinmux info in driver data instead of platform data
  sh-pfc: Add r8a7740 pinmux support
  sh-pfc: Add r8a7779 pinmux support
  sh-pfc: Add sh7367 pinmux support
  sh-pfc: Add sh7372 pinmux support
  sh-pfc: Add sh7377 pinmux support
  sh-pfc: Add sh73a0 pinmux support
  ARM: shmobile: pfc: Use driver-provided pinmux info
  sh-pfc: Add sh7203 pinmux support
  sh-pfc: Add sh7264 pinmux support
  sh-pfc: Add sh7269 pinmux support
  sh-pfc: Add sh7720 pinmux support
  sh-pfc: Add sh7722 pinmux support
  sh-pfc: Add sh7723 pinmux support
  sh-pfc: Add sh7724 pinmux support
  sh-pfc: Add sh7734 pinmux support
  sh-pfc: Add sh7757 pinmux support
  sh-pfc: Add sh7785 pinmux support
  sh-pfc: Add sh7786 pinmux support
  sh-pfc: Add shx3 pinmux support
  sh: pinmux: Use driver-provided pinmux info
  sh-pfc: Remove pinmux_info definition
  sh-pfc: Move sh_pfc.h from include/linux/ to driver directory
  ARM: shmobile: r8a7740: Add pin control resources
  ARM: shmobile: sh7372: Add pin control resources

 arch/arm/Kconfig                        |    1 +
 arch/arm/mach-shmobile/Makefile         |    2 +-
 arch/arm/mach-shmobile/devices.c        |   35 +
 arch/arm/mach-shmobile/devices.h        |   26 +
 arch/arm/mach-shmobile/pfc-r8a7740.c    | 2604 +----------------------------
 arch/arm/mach-shmobile/pfc-r8a7779.c    | 2613 +----------------------------
 arch/arm/mach-shmobile/pfc-sh7367.c     | 1706 +-------------------
 arch/arm/mach-shmobile/pfc-sh7372.c     | 1648 +------------------
 arch/arm/mach-shmobile/pfc-sh7377.c     | 1666 +------------------
 arch/arm/mach-shmobile/pfc-sh73a0.c     | 2780 +------------------------------
 arch/sh/Kconfig                         |   12 +
 arch/sh/include/asm/gpio.h              |    2 +-
 arch/sh/include/cpu-common/cpu/pfc.h    |   26 +
 arch/sh/kernel/cpu/Makefile             |    2 +-
 arch/sh/kernel/cpu/pfc.c                |   35 +
 arch/sh/kernel/cpu/sh2a/pinmux-sh7203.c | 1582 +-----------------
 arch/sh/kernel/cpu/sh2a/pinmux-sh7264.c | 2121 +-----------------------
 arch/sh/kernel/cpu/sh2a/pinmux-sh7269.c | 2823 +------------------------------
 arch/sh/kernel/cpu/sh3/pinmux-sh7720.c  | 1226 +-------------
 arch/sh/kernel/cpu/sh4a/pinmux-sh7722.c | 1778 +-------------------
 arch/sh/kernel/cpu/sh4a/pinmux-sh7723.c | 1893 +---------------------
 arch/sh/kernel/cpu/sh4a/pinmux-sh7724.c | 2210 +------------------------
 arch/sh/kernel/cpu/sh4a/pinmux-sh7734.c | 2470 +---------------------------
 arch/sh/kernel/cpu/sh4a/pinmux-sh7757.c | 2267 +------------------------
 arch/sh/kernel/cpu/sh4a/pinmux-sh7785.c | 1294 +--------------
 arch/sh/kernel/cpu/sh4a/pinmux-sh7786.c |  822 +---------
 arch/sh/kernel/cpu/sh4a/pinmux-shx3.c   |  573 +-------
 drivers/pinctrl/Kconfig                 |    1 +
 drivers/pinctrl/Makefile                |    1 +
 drivers/pinctrl/sh-pfc/Kconfig          |  126 ++
 drivers/pinctrl/sh-pfc/Makefile         |   23 +
 drivers/pinctrl/sh-pfc/core.c           |  666 ++++++++
 drivers/pinctrl/sh-pfc/core.h           |   74 +
 drivers/pinctrl/sh-pfc/gpio.c           |  180 ++
 drivers/pinctrl/sh-pfc/pfc-r8a7740.c    | 2612 ++++++++++++++++++++++++++++
 drivers/pinctrl/sh-pfc/pfc-r8a7779.c    | 2624 ++++++++++++++++++++++++++++
 drivers/pinctrl/sh-pfc/pfc-sh7203.c     | 1592 +++++++++++++++++
 drivers/pinctrl/sh-pfc/pfc-sh7264.c     | 2131 +++++++++++++++++++++++
 drivers/pinctrl/sh-pfc/pfc-sh7269.c     | 2834 +++++++++++++++++++++++++++++++
 drivers/pinctrl/sh-pfc/pfc-sh7367.c     | 1722 +++++++++++++++++++
 drivers/pinctrl/sh-pfc/pfc-sh7372.c     | 1658 ++++++++++++++++++
 drivers/pinctrl/sh-pfc/pfc-sh7377.c     | 1683 ++++++++++++++++++
 drivers/pinctrl/sh-pfc/pfc-sh73a0.c     | 2798 ++++++++++++++++++++++++++++++
 drivers/pinctrl/sh-pfc/pfc-sh7720.c     | 1236 ++++++++++++++
 drivers/pinctrl/sh-pfc/pfc-sh7722.c     | 1779 +++++++++++++++++++
 drivers/pinctrl/sh-pfc/pfc-sh7723.c     | 1903 +++++++++++++++++++++
 drivers/pinctrl/sh-pfc/pfc-sh7724.c     | 2225 ++++++++++++++++++++++++
 drivers/pinctrl/sh-pfc/pfc-sh7734.c     | 2475 +++++++++++++++++++++++++++
 drivers/pinctrl/sh-pfc/pfc-sh7757.c     | 2282 +++++++++++++++++++++++++
 drivers/pinctrl/sh-pfc/pfc-sh7785.c     | 1304 ++++++++++++++
 drivers/pinctrl/sh-pfc/pfc-sh7786.c     |  837 +++++++++
 drivers/pinctrl/sh-pfc/pfc-shx3.c       |  582 +++++++
 drivers/pinctrl/sh-pfc/pinctrl.c        |  480 ++++++
 drivers/pinctrl/sh-pfc/sh_pfc.h         |  195 +++
 drivers/sh/Kconfig                      |    1 -
 drivers/sh/Makefile                     |    1 -
 drivers/sh/pfc/Kconfig                  |   26 -
 drivers/sh/pfc/Makefile                 |    3 -
 drivers/sh/pfc/core.c                   |  572 -------
 drivers/sh/pfc/gpio.c                   |  240 ---
 drivers/sh/pfc/pinctrl.c                |  529 ------
 include/linux/sh_pfc.h                  |  236 ---
 62 files changed, 36231 insertions(+), 35617 deletions(-)
 create mode 100644 arch/arm/mach-shmobile/devices.c
 create mode 100644 arch/arm/mach-shmobile/devices.h
 create mode 100644 arch/sh/include/cpu-common/cpu/pfc.h
 create mode 100644 arch/sh/kernel/cpu/pfc.c
 create mode 100644 drivers/pinctrl/sh-pfc/Kconfig
 create mode 100644 drivers/pinctrl/sh-pfc/Makefile
 create mode 100644 drivers/pinctrl/sh-pfc/core.c
 create mode 100644 drivers/pinctrl/sh-pfc/core.h
 create mode 100644 drivers/pinctrl/sh-pfc/gpio.c
 create mode 100644 drivers/pinctrl/sh-pfc/pfc-r8a7740.c
 create mode 100644 drivers/pinctrl/sh-pfc/pfc-r8a7779.c
 create mode 100644 drivers/pinctrl/sh-pfc/pfc-sh7203.c
 create mode 100644 drivers/pinctrl/sh-pfc/pfc-sh7264.c
 create mode 100644 drivers/pinctrl/sh-pfc/pfc-sh7269.c
 create mode 100644 drivers/pinctrl/sh-pfc/pfc-sh7367.c
 create mode 100644 drivers/pinctrl/sh-pfc/pfc-sh7372.c
 create mode 100644 drivers/pinctrl/sh-pfc/pfc-sh7377.c
 create mode 100644 drivers/pinctrl/sh-pfc/pfc-sh73a0.c
 create mode 100644 drivers/pinctrl/sh-pfc/pfc-sh7720.c
 create mode 100644 drivers/pinctrl/sh-pfc/pfc-sh7722.c
 create mode 100644 drivers/pinctrl/sh-pfc/pfc-sh7723.c
 create mode 100644 drivers/pinctrl/sh-pfc/pfc-sh7724.c
 create mode 100644 drivers/pinctrl/sh-pfc/pfc-sh7734.c
 create mode 100644 drivers/pinctrl/sh-pfc/pfc-sh7757.c
 create mode 100644 drivers/pinctrl/sh-pfc/pfc-sh7785.c
 create mode 100644 drivers/pinctrl/sh-pfc/pfc-sh7786.c
 create mode 100644 drivers/pinctrl/sh-pfc/pfc-shx3.c
 create mode 100644 drivers/pinctrl/sh-pfc/pinctrl.c
 create mode 100644 drivers/pinctrl/sh-pfc/sh_pfc.h
 delete mode 100644 drivers/sh/pfc/Kconfig
 delete mode 100644 drivers/sh/pfc/Makefile
 delete mode 100644 drivers/sh/pfc/core.c
 delete mode 100644 drivers/sh/pfc/gpio.c
 delete mode 100644 drivers/sh/pfc/pinctrl.c
 delete mode 100644 include/linux/sh_pfc.h

-- 
Regards,

Laurent Pinchart

