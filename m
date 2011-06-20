Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab1FTMqP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 08:46:15 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47083 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752248Ab1FTMqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 08:46:13 -0400
Date: Mon, 20 Jun 2011 13:46:08 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: [PATCH 0/8] Generic I2C and SPI register map library
Message-ID: <20110620124608.GB31140@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 drivers/regmap/regmap-i2c.c            |  112 ++++++++
 drivers/regmap/regmap-spi.c            |   75 +++++
 drivers/regmap/regmap.c                |  478 ++++++++++++++++++++++++++++++++
 drivers/regulator/Kconfig              |    1 +
 drivers/regulator/tps65023-regulator.c |   98 ++-----
 include/linux/mfd/pcf50633/core.h      |    3 +-
 include/linux/mfd/wm831x/core.h        |    7 +-
 include/linux/mfd/wm8994/core.h        |    9 +-
 include/linux/regmap.h                 |   75 +++++
 include/sound/soc.h                    |    2 +
 sound/soc/Kconfig                      |    1 +
 sound/soc/soc-io.c                     |  316 ++-------------------
 23 files changed, 920 insertions(+), 769 deletions(-)
