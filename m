Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020Ab1L3DHQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 22:07:16 -0500
Received: from d1.icnet.pl ([212.160.220.21]:50768 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754168Ab1L3DHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 22:07:11 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Tony Lindgren <tony@atomide.com>
Cc: Jarkko Nikula <jarkko.nikula@bitmer.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Subject: [PATCH v2 0/4] Amstrad Delta: access MODEM_RESET GPIO pin over a regulator
Date: Fri, 30 Dec 2011 04:04:52 +0100
Message-Id: <1325214296-2888-1-git-send-email-jkrzyszt@tis.icnet.pl>
X-Mailer: git-send-email 1.7.3.4
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Amstrad Delta on-board latch2 bit named MODEM_NRESET, now available
as a GPIO pin AMS_DELTA_GPIO_PIN_NMODEM_RESET, is used to power up/down
(bring into/out of a reset state) two distinct on-board devices
simultaneously: the modem, and the voice codec. As a consequence, that
bit is, or can be, manipulated concurrently by two drivers, or their
platform provided hooks.

Instead of updating those drivers to use the gpiolib API as a new method
of controlling the MODEM_NRESET pin state, like it was done to other
drivers accessing latch2 pins, and still being vulnerable to potential
concurrency conflicts, or trying to solve that sharing issue with a
custom piece of code, set up a fixed regulator device on top of that
GPIO pin and update both drivers to manipulate that regulator, not the
GPIO pin directly.

Changes against initial version:
* in both the codec and the modem callbacks, don't track the regulator
  enable/disable state, compare new targert bias level (the codec case)
  or power state (the modem case) with the old value instead; thanks to
  Mark Brown who suggested this solution,
* a few other minor changes, mostly stylistic.

Janusz Krzysztofik (4):
  ARM: OMAP1: ams-delta: set up regulator over modem reset GPIO pin
  ASoC: cx20442: add bias control over a platform provided regulator
  ARM: OMAP1: ams-delta: update the modem to use regulator API
  ASoC: OMAP: ams-delta: drop .set_bias_level callback

 arch/arm/mach-omap1/Kconfig                       |    2 +
 arch/arm/mach-omap1/board-ams-delta.c             |   94 +++++++++++++++++++--
 arch/arm/plat-omap/include/plat/board-ams-delta.h |    1 -
 sound/soc/codecs/cx20442.c                        |   48 ++++++++++-
 sound/soc/omap/ams-delta.c                        |   34 --------
 5 files changed, 133 insertions(+), 46 deletions(-)

-- 
1.7.3.4

