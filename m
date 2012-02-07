Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482Ab2BGNBc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 08:01:32 -0500
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:57160 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756194Ab2BGNBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 08:01:31 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dmitry Torokhov <dtor@mail.ru>
Cc: Misael Lopez Cruz <misael.lopez@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 0/7] MFD: twl6040: Conversion to i2c driver
Date: Tue,  7 Feb 2012 15:01:11 +0200
Message-Id: <1328619678-26080-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Changes since v1 (RFC series):
- make use of regmap in the converted twl6040 driver [1]
- use module_i2c_driver to reduce line of code
- Use regulator_bulk functions for now in the twl6040 mfd driver. [2]

[1] Initially I'm not using the register cache offered by regmap, it will come
as a followup series

[2] When the driver supports more power levels, the bulk_enable/disable will be
removed, and the VIO/V2V1 supplies are going to be handled separately. As of now
it is better to enable them with the bulk call.

Still in the to-do list:
Implement proper regulator support on SDP4430, and PandaBoard for the needed
supplies by the twl6040.
The supply source is the same on both boards:
TWL6040 VDD2V1 <- TWL6030 V2V1 SMPS
TWL6040 VDDVIO <- TWL6030 V1V8 SMPS

There seams to be no control implemented in the regulator driver for these SMPS
regulators, so this need to be done first.

The reason that I'm sending this series (even when I know that the proper
regulator support is missing for SDP4430/PandaBoard) is to get feedback for the
rest of the series, so I can include the fixes in the v3 series.

------
Intro mail from the original series:

This series will convert the twl6040 MFD driver to an i2c driver.
Compared to older twl4030/5030/TPS the twl6040 is a standalone audio IC. It is
better if the twl6040-core (and all of it's child devices) does not depend on
the twl-core since it has nothing to with it.

With this conversion the dependency on twl can be dropped from the twl6040
driver stack (core, vibra, audio).

Between the first and second patch the audio will not probe on OMAP4, but I felt
it is better this way at least for the first RFC series to not have too big
change within one patch. The two patch can be squashed together later if no
objections.

Regards,
Peter
---
Peter Ujfalusi (7):
  MFD: twl-core: Detach twl6040 from the pmic mfd driver
  MFD: twl6040: Convert to i2c driver, and separate it from twl core
  ASoC: twl6040: Remove dependency on twl4030 from Kconfig
  OMAP: 4430sdp: Correct fixed regulator device ID
  OMAP: sdp4430: Add fixed regulator for twl6040 needs
  OMAP: omap4panda: Add fixed regulator for twl6040 needs
  MFD: TWL6040: Add regulator support for VIO, V2V1 supplies

 arch/arm/mach-omap2/board-4430sdp.c    |   77 ++++++++++++++--
 arch/arm/mach-omap2/board-generic.c    |    2 +-
 arch/arm/mach-omap2/board-omap4panda.c |   75 ++++++++++++++--
 arch/arm/mach-omap2/twl-common.c       |   37 +++++++-
 arch/arm/mach-omap2/twl-common.h       |   10 +--
 drivers/input/misc/Kconfig             |    1 -
 drivers/input/misc/twl6040-vibra.c     |    4 +-
 drivers/mfd/Kconfig                    |    2 +-
 drivers/mfd/twl-core.c                 |   58 +++++++-----
 drivers/mfd/twl6040-core.c             |  155 +++++++++++++++++++++----------
 include/linux/i2c/twl.h                |   12 ---
 include/linux/mfd/twl6040.h            |   29 ++++++
 sound/soc/codecs/Kconfig               |    2 +-
 sound/soc/codecs/twl6040.c             |    3 +-
 14 files changed, 345 insertions(+), 122 deletions(-)

-- 
1.7.8.4

