Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833Ab1FUOjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 10:39:48 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51960 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883Ab1FUOjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 10:39:44 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [PATCH v6 00/18] MFD/ASoC/Input: TWL4030/TWL60X0 changes
Date: Tue, 21 Jun 2011 16:38:58 +0300
Message-ID: <1308663556-29120-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.5.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Changes since v5:
- Use alloc_workqueue in the twl6040-vibra driver (comment from Tejun Heo)
- Allow user to change the headset power mode, but if the change is not allowed
  by the use case the change is not written to the HW (comment from Mark Brown)

Mark: I have added your acks for the patches, except for patch 15, where you
requested a change.

Intro message from the v5 series:
The series will do five major things, and they are in one series, because they
pretty much depending on each other, so it is easier to handle them together.

1. Move the common pmic related configurations out from the board files.
New twl-common.c/h file has been created for this purpose.
OMAP3 board files received two patches (pdata, and regualtor changes), OMAP4
board files has been changed with one patch.

2. Rename the twl4030-codec MFD driver to twl4030-audio
Since the ASoC multicomponent introduction (2.6.37) the twl4030-codec MFD dirver
had been using twl4030-audio to register (twl4030-codec is the ASoC codec
driver). The documentation refers to this part of twl as audio block, so it is
better to rename the driver as well to avoid confusion.

3. Introduction of MFD driver for twl6040.
The TWL6040 audio IC has codec and vibra functionality.
Convert the existing ASoC codec driver to use the new MFD driver's interface.

4. Vibrator driver for TWL6040 (Input/ForceFeedback driver)
The driver itself, and support for the vibrators in SDP4430 board.

5. Updates for twl6040 ASoC codec driver
HS ramp configuration, new ABE dais, updated sample rate constraints, SDP4430
configuration.

Regards,
Peter

---
Axel Castaneda Gonzalez (1):
  ASoC: twl6040: Configure ramp step based on platform

Liam Girdwood (3):
  ASoC: twl6040: add all ABE DAIs
  ASoC: twl6040: Support other sample rates in constraints.
  ASoC: twl6040: set default constraints.

Misael Lopez Cruz (5):
  mfd: twl6040: Add initial support
  ASoC: twl6040: Convert into TWL6040 MFD child
  input: Add initial support for TWL6040 vibrator
  ASoC: twl6040: Remove pll and headset mode dependency
  OMAP4: SDP4430: Add twl6040 codec platform support

Peter Ujfalusi (9):
  OMAP: New twl-common for common TWL configuration
  OMAP4: Move common twl6030 configuration to twl-common
  OMAP3: Move common twl configuration to twl-common
  OMAP3: Move common regulator configuration to twl-common
  MFD: twl4030-codec: Rename internals from codec to audio
  MFD: twl4030-codec -> twl4030-audio: Rename the driver
  MFD: twl4030-audio: Rename platform data
  MFD: twl6040: Change platform data for soc codec driver
  OMAP4: SDP4430: Add twl6040 vibrator platform support

 arch/arm/mach-omap2/Makefile                       |    2 +-
 arch/arm/mach-omap2/board-3430sdp.c                |   89 +---
 arch/arm/mach-omap2/board-4430sdp.c                |  187 ++----
 arch/arm/mach-omap2/board-cm-t35.c                 |   48 +--
 arch/arm/mach-omap2/board-devkit8000.c             |   37 +--
 arch/arm/mach-omap2/board-igep0020.c               |   44 +--
 arch/arm/mach-omap2/board-ldp.c                    |   15 +-
 arch/arm/mach-omap2/board-omap3beagle.c            |   60 +--
 arch/arm/mach-omap2/board-omap3evm.c               |   67 +--
 arch/arm/mach-omap2/board-omap3pandora.c           |   59 +--
 arch/arm/mach-omap2/board-omap3stalker.c           |   70 +--
 arch/arm/mach-omap2/board-omap3touchbook.c         |   57 +--
 arch/arm/mach-omap2/board-omap4panda.c             |  149 +-----
 arch/arm/mach-omap2/board-overo.c                  |   59 +--
 arch/arm/mach-omap2/board-rm680.c                  |    8 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c       |   44 +--
 arch/arm/mach-omap2/board-zoom-peripherals.c       |   88 +---
 arch/arm/mach-omap2/common-board-devices.c         |   21 -
 arch/arm/mach-omap2/common-board-devices.h         |   26 +-
 arch/arm/mach-omap2/twl-common.c                   |  304 ++++++++++
 arch/arm/mach-omap2/twl-common.h                   |   59 ++
 arch/arm/plat-omap/include/plat/irqs.h             |   12 +-
 drivers/input/misc/Kconfig                         |   13 +-
 drivers/input/misc/Makefile                        |    1 +
 drivers/input/misc/twl4030-vibra.c                 |   12 +-
 drivers/input/misc/twl6040-vibra.c                 |  416 +++++++++++++
 drivers/mfd/Kconfig                                |    8 +-
 drivers/mfd/Makefile                               |    3 +-
 drivers/mfd/twl-core.c                             |   13 +-
 drivers/mfd/twl4030-audio.c                        |  277 +++++++++
 drivers/mfd/twl4030-codec.c                        |  277 ---------
 drivers/mfd/twl6040-core.c                         |  601 +++++++++++++++++++
 drivers/mfd/twl6040-irq.c                          |  205 +++++++
 include/linux/i2c/twl.h                            |   25 +-
 .../linux/mfd/{twl4030-codec.h => twl4030-audio.h} |   16 +-
 include/linux/mfd/twl6040.h                        |  261 ++++++++
 sound/soc/codecs/Kconfig                           |    3 +-
 sound/soc/codecs/twl4030.c                         |   22 +-
 sound/soc/codecs/twl6040.c                         |  628 ++++++++------------
 sound/soc/codecs/twl6040.h                         |  118 ----
 sound/soc/omap/sdp3430.c                           |    2 +-
 sound/soc/omap/sdp4430.c                           |    2 +
 sound/soc/omap/zoom2.c                             |    2 +-
 43 files changed, 2635 insertions(+), 1775 deletions(-)
 create mode 100644 arch/arm/mach-omap2/twl-common.c
 create mode 100644 arch/arm/mach-omap2/twl-common.h
 create mode 100644 drivers/input/misc/twl6040-vibra.c
 create mode 100644 drivers/mfd/twl4030-audio.c
 delete mode 100644 drivers/mfd/twl4030-codec.c
 create mode 100644 drivers/mfd/twl6040-core.c
 create mode 100644 drivers/mfd/twl6040-irq.c
 rename include/linux/mfd/{twl4030-codec.h => twl4030-audio.h} (96%)
 create mode 100644 include/linux/mfd/twl6040.h

-- 
1.7.5.3

