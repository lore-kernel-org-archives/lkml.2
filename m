Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758653Ab1FVSoM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 14:44:12 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48516 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758348Ab1FVSoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 14:44:10 -0400
Date: Wed, 22 Jun 2011 19:44:08 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: [PATCH 0/8] Generic I2C and SPI register map library
Message-ID: <20110622184407.GC13847@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Cookie: Avoid reality at all costs.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[This reposting of the series should address all the review comments on
the series so far.]

Many I2C and SPI based devices implement register maps on top of the raw
wire interface.  This is generally done in a very standard fashion by
devices, resulting in a lot of very similar code in drivers.  For some
time now ASoC has factored this code out into the subsystem but that's
only useful for audio devices.  The intention with this series is to
generalise the concept so that it can be used throughout the kernel.

It's not intended that this be suitable for all devices - some devices
have things that are hard to generalise like registers with variable
size and paging which are hard to support genericly.  At the minute the
code is focused on the common cases.  It is likely that the same code
could be used with other buses with similar properties to I2C and SPI.

Currently only physical I/O is handled, the intention is that once this
support has been reviewed and merged the generic register cache code
that ASoC includes will also be factored out too.  For devices with read
heavy workloads (especially those that need a lot of read/modify/write
cycles) or which don't support read at all this can provide a useful
performance improvement and for sparse register maps there's a lot of
benefit in relatively complex cache code.

I'm not entirely happy with the implementation currently but am fairly
happy with the external interfaces.

A semi-random set of driver conversions have been included in the series
with various degrees of testing including the subsystem wide ASoC code.
Far more drivers could use the code, these have mostly just been done as
samples in a minimally invasive fashion.

There's a git branch at:

   git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git for-next

but due to various -next dependencies this does not currently include
all of the patches posted here.  I've also created a regmap-asoc branch
there which merges current ASoC code with the regmap code.

Mark Brown (8):
      regmap: Add generic non-memory mapped register access API
      regmap: Add I2C bus support
      regmap: Add SPI bus support
      ASoC: Use new register map API for ASoC generic physical I/O
      mfd: Convert WM831x to use regmap API
      mfd: Convert WM8994 to use new register map API
      mfd: Convert pcf50633 to use new register map API
      regulator: Convert tps65023 to use regmap API

 MAINTAINERS                            |    7 +
 drivers/Kconfig                        |    1 +
 drivers/Makefile                       |    1 +
 drivers/mfd/Kconfig                    |    4 +
 drivers/mfd/pcf50633-core.c            |  114 ++------
 drivers/mfd/wm831x-core.c              |   97 +++----
 drivers/mfd/wm831x-i2c.c               |   56 ----
 drivers/mfd/wm831x-spi.c               |   48 ----
 drivers/mfd/wm8994-core.c              |  175 ++----------
 drivers/regmap/Kconfig                 |    6 +
 drivers/regmap/Makefile                |    3 +
 drivers/regmap/regmap-i2c.c            |  113 ++++++++
 drivers/regmap/regmap-spi.c            |   75 +++++
 drivers/regmap/regmap.c                |  484 ++++++++++++++++++++++++++++++++
 drivers/regulator/Kconfig              |    1 +
 drivers/regulator/tps65023-regulator.c |   98 ++-----
 include/linux/mfd/pcf50633/core.h      |    3 +-
 include/linux/mfd/wm831x/core.h        |    7 +-
 include/linux/mfd/wm8994/core.h        |    9 +-
 include/linux/regmap.h                 |   77 +++++
 include/sound/soc.h                    |    2 +
 sound/soc/Kconfig                      |    1 +
 sound/soc/soc-io.c                     |  316 ++-------------------
 23 files changed, 929 insertions(+), 769 deletions(-)
