Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819Ab1GWHVk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 03:21:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35297 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751731Ab1GWHVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 03:21:34 -0400
Date: Sat, 23 Jul 2011 08:21:30 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant@secretlab.ca>,
        Liam Girdwood <lrg@ti.com>, Wolfram Sang <w.sang@pengutronix.de>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [GIT PULL] regmap: Generic I2C and SPI register map library
Message-ID: <20110723072129.GC31413@opensource.wolfsonmicro.com>
References: <20110722135247.GA27855@opensource.wolfsonmicro.com>
 <CA+55aFw-8ShsN2M-7dXCOEFhOx4xVQhN2rtzwJWV=rcwvPgF9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw-8ShsN2M-7dXCOEFhOx4xVQhN2rtzwJWV=rcwvPgF9g@mail.gmail.com>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 03:02:01PM -0700, Linus Torvalds wrote:

> so now that thing turns on REGMAP_I2C and compiles in the code WITHOUT
> EVEN ASKING. It's enough to enable i2c.

Providing some device in the system enabled regmap; the issue here was
that dependencies of selected symbols don't work terribly reliably and
originally the API was written to support the common idiom of bus
neutral core drivers which don't know which bus they're working with but
the code got refactored since then and the Kconfig didn't keep up.

Anyway, I've changed the code with the diff below and pushed out again,
pull request below the diff:

diff --git a/drivers/base/regmap/Kconfig b/drivers/base/regmap/Kconfig
index 54b5854..fabbf6c 100644
--- a/drivers/base/regmap/Kconfig
+++ b/drivers/base/regmap/Kconfig
@@ -3,12 +3,11 @@
 # subsystems should select the appropriate symbols.
 
 config REGMAP
+	default y if (REGMAP_I2C || REGMAP_SPI)
 	bool
 
 config REGMAP_I2C
 	tristate
-	default I2C
 
 config REGMAP_SPI
 	tristate
-	default SPI_MASTER
diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 8128db3..c7fd2c0 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -235,7 +235,7 @@ config REGULATOR_TPS6105X
 config REGULATOR_TPS65023
 	tristate "TI TPS65023 Power regulators"
 	depends on I2C
-	select REGMAP
+	select REGMAP_I2C
 	help
 	  This driver supports TPS65023 voltage regulator chips. TPS65023 provides
 	  three step-down converters and two general-purpose LDO voltage regulators.


The following changes since commit 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe:

  Linux 3.0 (2011-07-21 19:17:23 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git for-linus

Mark Brown (4):
      regmap: Add generic non-memory mapped register access API
      regmap: Add I2C bus support
      regmap: Add SPI bus support
      regulator: Convert tps65023 to use regmap API

 MAINTAINERS                            |    7 +
 drivers/base/Kconfig                   |    2 +
 drivers/base/Makefile                  |    1 +
 drivers/base/regmap/Kconfig            |   13 +
 drivers/base/regmap/Makefile           |    3 +
 drivers/base/regmap/regmap-i2c.c       |  115 ++++++++
 drivers/base/regmap/regmap-spi.c       |   72 +++++
 drivers/base/regmap/regmap.c           |  455 ++++++++++++++++++++++++++++++++
 drivers/regulator/Kconfig              |    1 +
 drivers/regulator/tps65023-regulator.c |   97 ++-----
 include/linux/regmap.h                 |   82 ++++++
 11 files changed, 778 insertions(+), 70 deletions(-)
 create mode 100644 drivers/base/regmap/Kconfig
 create mode 100644 drivers/base/regmap/Makefile
 create mode 100644 drivers/base/regmap/regmap-i2c.c
 create mode 100644 drivers/base/regmap/regmap-spi.c
 create mode 100644 drivers/base/regmap/regmap.c
 create mode 100644 include/linux/regmap.h
