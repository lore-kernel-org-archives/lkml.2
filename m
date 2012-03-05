Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab2CEQGn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 11:06:43 -0500
Received: from d1.icnet.pl ([212.160.220.21]:36538 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754365Ab2CEQGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 11:06:40 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Tony Lindgren <tony@atomide.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Subject: [PATCH v3 0/3] Amstrad Delta: access MODEM_RESET GPIO pin over a regulator
Date: Mon,  5 Mar 2012 17:05:09 +0100
Message-Id: <1330963512-20413-1-git-send-email-jkrzyszt@tis.icnet.pl>
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

This is v3 of this series, with Mark's Ack for ASoC subtree touching
changes already collected, rebased on top of linux-omap/ams-delta tip,
commit da564a05b3aefe403062411b67d64b7e992718f7.

There were initially 4 patches in the series, but patch 2/4, "ASoC:
cx20442: add bias control over a platform provided regulator", has been
since then applied by Liam to the ASoC tree (thanks!) and is already
present in mainline (commit f75a8ff67d161b5166a2c2360bb2ffaefd5eb853),
hence omitted from this submission.

v2 -> v3 changes:
* fix section mismatch issue present in previous versions of patch 1/3.

v2 changes against initial version:
* in both the codec and the modem callbacks, don't track the regulator
  enable/disable state, compare new target bias level (the codec case)
  or power state (the modem case) with the old value instead; thanks to
  Mark Brown who suggested this solution,
* a few other minor changes, mostly stylistic.

Janusz Krzysztofik (3):
  ARM: OMAP1: ams-delta: set up regulator over modem reset GPIO pin
  ARM: OMAP1: ams-delta: update the modem to use regulator API
  ASoC: OMAP: ams-delta: drop .set_bias_level callback

 arch/arm/mach-omap1/Kconfig                       |    2 +
 arch/arm/mach-omap1/board-ams-delta.c             |   94 +++++++++++++++++++--
 arch/arm/plat-omap/include/plat/board-ams-delta.h |    1 -
 sound/soc/omap/ams-delta.c                        |   32 -------
 4 files changed, 87 insertions(+), 42 deletions(-)

-- 
1.7.3.4

