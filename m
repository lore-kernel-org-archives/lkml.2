Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab1LSXMf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 18:12:35 -0500
Received: from d1.icnet.pl ([212.160.220.21]:36215 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058Ab1LSXMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 18:12:31 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Grant Likely <grant.likely@secretlab.ca>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-input@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-fbdev@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH v2 0/7] ARM: OMAP1: ams-delta: replace custom I/O with GPIO
Date: Tue, 20 Dec 2011 00:08:50 +0100
Message-Id: <cover.1324331816.git.jkrzyszt@tis.icnet.pl>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1323634328-856-1-git-send-email-jkrzyszt@tis.icnet.pl>
References: <1323634328-856-1-git-send-email-jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Amstrad Delta board has two extra output ports used for driving
input lines of different on-board devices. Those ports are now
controlled with custom functions, provided by the board arch code and
used by several device drivers.

The idea behind the series is to replace those custom I/O functions
with gpiolib API. This way, existing drivers can be made less platform
dependent, and some of them perhaps even superseded with generic GPIO
based drivers after the board platform device descriptions are
converted. Moreover, should a new driver for the on-board Smart Card
controller ever be created, it could be designed as a generic GPIO
based driver, not a custom one.

Changes against initial version:
* the initial patch, which tried to move the gpio-generic driver
  initialization up to the postcore_initcall level, replaced with an
  alternative solution, moving the on-board devices initialization down
  to late_initcall; thanks to Tony Lindgren who suggested this solution,
* dropped patches introducing changes to the modem and ASoC device
  handling; those will be addressed in a separate patch series,
* final cleanups also dropped until those remaining devices are updated,
* the serio driver now takes care of one more GPIO pin which, even if
  not used, belongs to the device interface and affects its functioning,
* misc code and changelog cosmetic cleanups,
* rebased on top of 3.2-rc6.


Thanks to those who reviewed the initial submission and responded with
their comments or Acks.

Janusz


Janusz Krzysztofik (7):
  ARM: OMAP1: ams-delta: register latch dependent devices later
  ARM: OMAP1: ams-delta: convert latches to basic_mmio_gpio
  ARM: OMAP1: ams-delta: supersede custom led device by leds-gpio
  LED: drop leds-ams-delta driver
  MTD: NAND: ams-delta: use GPIO instead of custom I/O
  omapfb: lcd_ams_delta: drive control lines over GPIO
  input: serio: ams-delta: toggle keyboard power over GPIO

 arch/arm/mach-omap1/Kconfig                       |    2 +
 arch/arm/mach-omap1/board-ams-delta.c             |  226 +++++++++++++++++----
 arch/arm/plat-omap/include/plat/board-ams-delta.h |   48 ++---
 drivers/input/serio/ams_delta_serio.c             |   51 +++--
 drivers/leds/Kconfig                              |    7 -
 drivers/leds/Makefile                             |    1 -
 drivers/leds/leds-ams-delta.c                     |  137 -------------
 drivers/mtd/nand/ams-delta.c                      |   74 +++++--
 drivers/video/omap/lcd_ams_delta.c                |   27 ++-
 sound/soc/omap/ams-delta.c                        |    4 +
 10 files changed, 318 insertions(+), 259 deletions(-)
 delete mode 100644 drivers/leds/leds-ams-delta.c

-- 
1.7.3.4

