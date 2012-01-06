Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759309Ab2AFWaO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 17:30:14 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47671 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752940Ab2AFWaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 17:30:12 -0500
Date: Fri, 6 Jan 2012 22:30:09 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@liux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] regmap updates for v3.3
Message-ID: <20120106223007.GA20018@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull the tree below to merge regmap updates for version 3.3.
After the rush of new features in version 3.2 this has been a fairly
quiet cycle for the regmap API, the main change being the wider usage by
drivers and some fixes and tweaks for them.  The main things from a
subsystem point of view are:

 - Addition of a generic interrupt controller driver which should work
   for a range of chips, saving them from having to open code this.
 - Removal of the indexed cache type as it's not got any real advantage
   over the rbtree cache.

This pull request also includes the MFD driver for the DA9052 PMIC as it
is one of the first users of the generic regmap IRQ code and therefore
has a build dependency on it.

The following changes since commit dc47ce90c3a822cd7c9e9339fe4d5f61dcb26b50:

  Linux 3.2-rc5 (2011-12-09 15:09:32 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git for-linus

Ashish Jangam (3):
      MFD: DA9052/53 MFD core module
      MFD: DA9052/53 MFD core module add SPI support v2
      mfd: Clearing events requires event registers to be writable for da9052-core

Lars-Peter Clausen (14):
      regmap: Add helper function for checking if a register range is volatile
      regmap: Support some more block operations on cached devices
      regmap: Fix memory leak in regmap_init error path
      regmap: return ERR_PTR instead of NULL in regmap_init
      regmap: Fix memory leak in regcache_hw_init error path
      regmap: Fix memory leak in regcache_init error path
      regmap: Do not call regcache_exit from regcache_rbtree_init error path
      regmap: Do not call regcache_exit from regcache_lzo_init error path
      regmap: Move initialization of regcache related fields to regcache_init
      regmap: Make reg_config reg_defaults const
      regmap: Try cached read before checking if a hardware read is possible
      regmap: Add support for 10/14 register formating
      regmap: Properly round cache_word_size
      regmap: Drop check whether a register is readable in regcache_read

Mark Brown (25):
      regmap: Add a reusable irq_chip for regmap based interrupt controllers
      regmap: Prepare LZO cache for variable block sizes
      regmap: Fix word wrap in Makefile
      regmap: Fix typo in kerneldoc for regmap_update_bits()
      regmap: Track if the register cache is dirty and suppress unneeded syncs
      regmap: Rename LZO cache type to compressed
      Merge branches 'regmap/irq' and 'regmap/cache' into regmap-next
      regmap: Remove indexed cache type
      regmap: Suppress noop writes in regmap_update_bits()
      regmap: Do debugfs init before cache init
      regmap: Provide debugfs dump of the rbtree cache data
      regmap: Fix rbtreee build when not using debugfs
      regmap: Report if we actually handled an interrupt in regmap-irq
      Merge remote-tracking branch 'regmap/topic/irq' into regmap-next
      regmap: Allow regmap_update_bits() users to detect changes
      regmap: Add trace event for successful cache reads
      regmap: Allow drivers to reinitialise the register cache at runtime
      Merge branch 'topic/cache' of git://git.kernel.org/.../broonie/regmap into regmap-next
      regmap: Add irq_base accessor to regmap_irq
      Merge branch 'regmap/irq' into regmap-next
      Merge branch 'topic/irq' of git://git.kernel.org/.../broonie/regmap into mfd/da9052
      Merge branch 'mfd/da9052' of git://git.kernel.org/.../broonie/misc into regmap-next
      mfd: Declare da9052_regmap_config for the bus drivers
      gpiolib: Mark da9052 driver broken
      mfd: Fix annotations in da9052-core

 drivers/base/regmap/Kconfig            |    3 +
 drivers/base/regmap/Makefile           |    4 +-
 drivers/base/regmap/internal.h         |    6 +-
 drivers/base/regmap/regcache-indexed.c |   64 ---
 drivers/base/regmap/regcache-lzo.c     |   21 +-
 drivers/base/regmap/regcache-rbtree.c  |   61 +++-
 drivers/base/regmap/regcache.c         |   87 +++--
 drivers/base/regmap/regmap-irq.c       |  302 +++++++++++++
 drivers/base/regmap/regmap.c           |  179 ++++++--
 drivers/gpio/Kconfig                   |    2 +-
 drivers/mfd/Kconfig                    |   28 ++
 drivers/mfd/Makefile                   |    5 +
 drivers/mfd/da9052-core.c              |  694 +++++++++++++++++++++++++++++
 drivers/mfd/da9052-i2c.c               |  140 ++++++
 drivers/mfd/da9052-spi.c               |  115 +++++
 include/linux/mfd/da9052/da9052.h      |  131 ++++++
 include/linux/mfd/da9052/pdata.h       |   40 ++
 include/linux/mfd/da9052/reg.h         |  749 ++++++++++++++++++++++++++++++++
 include/linux/regmap.h                 |   59 +++-
 include/trace/events/regmap.h          |    9 +
 20 files changed, 2542 insertions(+), 157 deletions(-)
 delete mode 100644 drivers/base/regmap/regcache-indexed.c
 create mode 100644 drivers/base/regmap/regmap-irq.c
 create mode 100644 drivers/mfd/da9052-core.c
 create mode 100644 drivers/mfd/da9052-i2c.c
 create mode 100644 drivers/mfd/da9052-spi.c
 create mode 100644 include/linux/mfd/da9052/da9052.h
 create mode 100644 include/linux/mfd/da9052/pdata.h
 create mode 100644 include/linux/mfd/da9052/reg.h
