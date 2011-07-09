Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389Ab1GIEu6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 00:50:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58897 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750756Ab1GIEu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 00:50:57 -0400
Date: Sat, 9 Jul 2011 13:49:28 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg KH <greg@kroah.com>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        Graeme Gregory <gg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] regmap: Generic I2C and SPI register map library
Message-ID: <20110709044923.GB13074@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a version of a series I've been posting for most of this release
cycle which abstracts out a bunch of widely duplicated code for doing
register I/O on devices with control slow buses like I2C and SPI.  As
well as saving us code for the register I/O itself this should also make
it easier to factor out further higher level code for this class of
devices.

Previously the patches had created a new directory under drivers/ but
one of the comments on the last review was that we should move to
drivers/base and another was that we should get this into mainline so
I've done that move and am now sending the patches to you.

The code is in a subdirectory because I'm anticipating it'll grow quite
a bit as we add facilities like fancy cache mechanisms on top of it.
The bus code isn't moved into the buses as I'm not currently entirely
happy with the internal interface to that and want to avoid cross tree
issues for the time being, I am pretty happy with the interfaces offered
to drivers though.

I realise it's a bit late in the cycle but it'd be really good if we
could get this merged in the next merge window, or accepted for about
then so we can create a stable branch we can merge into subsystem trees
in order to get drivers using this merged for 3.2.  As there's only one
user included the series it should be pretty low risk.

A more verbose cover letter:

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

A bunch more drivers have been converted to use this framework,
including the existing ASoC register I/O code, but due to various -next
dependencies these don't apply easily so I've omitted them from this
posting of the series.

There's a git branch at:

   git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git for-next

I've also created a regmap-asoc branch there which merges current ASoC
code with the regmap code.

The following changes since commit fe0d42203cb5616eeff68b14576a0f7e2dd56625:

  Linux 3.0-rc6 (2011-07-04 15:56:24 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git for-next

Mark Brown (4):
      regmap: Add generic non-memory mapped register access API
      regmap: Add I2C bus support
      regmap: Add SPI bus support
      regulator: Convert tps65023 to use regmap API

 MAINTAINERS                            |    7 +
 drivers/base/Kconfig                   |    2 +
 drivers/base/Makefile                  |    1 +
 drivers/base/regmap/Kconfig            |    6 +
 drivers/base/regmap/Makefile           |    3 +
 drivers/base/regmap/regmap-i2c.c       |  113 ++++++++
 drivers/base/regmap/regmap-spi.c       |   75 +++++
 drivers/base/regmap/regmap.c           |  481 ++++++++++++++++++++++++++++++++
 drivers/regulator/Kconfig              |    1 +
 drivers/regulator/tps65023-regulator.c |   98 ++-----
 include/linux/regmap.h                 |   76 +++++
 11 files changed, 792 insertions(+), 71 deletions(-)
 create mode 100644 drivers/base/regmap/Kconfig
 create mode 100644 drivers/base/regmap/Makefile
 create mode 100644 drivers/base/regmap/regmap-i2c.c
 create mode 100644 drivers/base/regmap/regmap-spi.c
 create mode 100644 drivers/base/regmap/regmap.c
 create mode 100644 include/linux/regmap.h
