Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab1ARTYH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 14:24:07 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:42394 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852Ab1ARTWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 14:22:23 -0500
From: Cyril Chemparathy <cyril@ti.com>
To: davinci-linux-open-source@linux.davincidsp.com,
        spi-devel-general@lists.sourceforge.net, sameo@linux.intel.com,
        rpurdie@rpsys.net, dbrownell@users.sourceforge.net
Cc: c-park@ti.com, linux-arm-kernel@lists.arm.linux.org.uk,
        linux-kernel@vger.kernel.org, Cyril Chemparathy <cyril@ti.com>
Subject: [PATCH v8 00/11]  tnetv107x ssp drivers
Date: Tue, 18 Jan 2011 14:21:34 -0500
Message-Id: <1295378505-15221-1-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TI's sequencer serial port (TI-SSP) is a jack-of-all-trades type of serial port
device.  It has a built-in programmable execution engine that can be programmed
to operate as almost any serial bus (I2C, SPI, EasyScale, and others).

This patch series implements a driver stack that looks like the following:

                             +--------+
                             | eeprom | . . .
                             +--------+
   +-----------+             +--------------+ +---------+
   | regulator | . . .       |   i2c-gpio   | | 1-wire  | . . .
   +-----------+             +--------------+ +---------+
   +----------------------+  +--------------------------------+
   |       ssp-spi        |  |           ssp-gpio             |
   +----------------------+  +--------------------------------+
   +----------------------------------------------------------+
   |                            ssp                           |
   +----------------------------------------------------------+

Changes between v8 and v7 of this series:
  - Reorder commits, removed regulator driver patch (already upstreamed)
  - Renamed static function definitions to keep namespace clean (mfd, gpio)
  - Removed instance pdata in mfd driver

Changes between v7 and v6 of this series:
  - Workaround for iosel2 register not reading back set bits.
  - Update backlight status once probe succeeds.

Changes between v6 and v5 of this series:
  - Changed initcalls to module_init() across all drivers.  This series now
    uses a late_initcall() in the board to delay initialization of gpio and
    regulator dependent devices.

Changes between v5 and v4 of this series:
  - Moved drivers from misc/gpio/spi to mfd
  - Removed implicit init-time iosel setup
  - Minor cleanups in backlight driver

Changes between v3 and v4 of this series:
  - Replaced polled wait for sequence termination with interrupt
  - Improved locking within SSP driver
  - Other minor cleanups

Changes between v2 and v3 of this series:
  - Minor cleanups in Kconfig and Makefile ordering

Changes between v1 and v2 of this series:
  - Replaced open()/close() semantics with dynamic platform_device
    registration on SSP probe.
  - Removed user-land interface to regulator registers
  - More sensible regulator constraints
  - Other minor cleanups


Cyril Chemparathy (11):
  mfd: add driver for sequencer serial port
  spi: add ti-ssp spi master driver
  gpio: add ti-ssp gpio driver
  backlight: add support for tps6116x controller
  davinci: add tnetv107x ssp platform device
  davinci: add ssp config for tnetv107x evm board
  davinci: add spi devices on tnetv107x evm
  davinci: add tnetv107x evm regulators
  davinci: add tnetv107x evm ti-ssp gpio device
  davinci: add tnetv107x evm backlight device
  davinci: add tnetv107x evm i2c eeprom device

 arch/arm/mach-davinci/board-tnetv107x-evm.c    |  197 ++++++++++
 arch/arm/mach-davinci/devices-tnetv107x.c      |   25 ++
 arch/arm/mach-davinci/include/mach/tnetv107x.h |    2 +
 arch/arm/mach-davinci/tnetv107x.c              |    2 +-
 drivers/gpio/Kconfig                           |   10 +
 drivers/gpio/Makefile                          |    1 +
 drivers/gpio/ti-ssp-gpio.c                     |  207 ++++++++++
 drivers/mfd/Kconfig                            |   11 +
 drivers/mfd/Makefile                           |    1 +
 drivers/mfd/ti-ssp.c                           |  476 ++++++++++++++++++++++++
 drivers/spi/Kconfig                            |   10 +
 drivers/spi/Makefile                           |    1 +
 drivers/spi/ti-ssp-spi.c                       |  402 ++++++++++++++++++++
 drivers/video/backlight/Kconfig                |    7 +
 drivers/video/backlight/Makefile               |    2 +-
 drivers/video/backlight/tps6116x.c             |  299 +++++++++++++++
 include/linux/mfd/ti_ssp.h                     |   97 +++++
 17 files changed, 1748 insertions(+), 2 deletions(-)
 create mode 100644 drivers/gpio/ti-ssp-gpio.c
 create mode 100644 drivers/mfd/ti-ssp.c
 create mode 100644 drivers/spi/ti-ssp-spi.c
 create mode 100644 drivers/video/backlight/tps6116x.c
 create mode 100644 include/linux/mfd/ti_ssp.h

