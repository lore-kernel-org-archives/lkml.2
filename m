Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993360Ab2KOLAM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 06:00:12 -0500
Received: from mga01.intel.com ([192.55.52.88]:48467 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993220Ab2KOLAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 06:00:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,255,1352102400"; 
   d="scan'208";a="249477824"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: lenb@kernel.org, rafael.j.wysocki@intel.com,
        broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, bhelgaas@google.com,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v2 0/3] ACPI 5 support for GPIO, SPI and I2C
Date: Thu, 15 Nov 2012 13:03:14 +0200
Message-Id: <1352977397-2280-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a second revision of the ACPI 5 patches originally introduced here:

	https://lkml.org/lkml/2012/11/3/17

The series enables ACPI 5 enumeration of SPI and I2C devices and adds GPIO
translation support for the GPIO resources.

One can then enable ACPI support in a SPI or I2C driver adding something
like:

	#ifdef CONFIG_ACPI
	static struct acpi_device_id mydrv_acpi_match[] = {
		{ "SPI0001", 0 },
		...
		{ }
	};
	MODULE_DEVICE_TABLE(acpi, mydrv_acpi_match);
	#endif

	static struct spi_driver mydrv = {
		...
		.driver = {
			.acpi_match_table = ACPI_PTR(mydrv_acpi_match),
		},
	};

to the existing driver. If more complex configuration is needed, like
getting GPIOs, calling some method, etc. there is dev->acpi_handle for
that.

Changes to the original version:
	[gpio]
	- CONFIG_GPIO_ACPI instead of CONFIG_ACPI_GPIO
	- removed redundant test in acpi_gpiochip_find()

	[spi and i2c]
	- switched to use ACPI centralized _CRS evaluation framework
	  introduced by Rafael 
	- dropped request_module() call
	- dropped the acpi_enumerate_spi/i2c_device()
	- added required includes and dropped <linux/acpi.h> from
	  acpi_i2c.h

The series applies on top of Rafael's
git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git linux-next

There is a dependency to linux-pm.git/linux-next so I think it would be
better if these will be merged via that tree.

Mathias Nyman (1):
  gpio / ACPI: add ACPI support

Mika Westerberg (2):
  spi / ACPI: add ACPI enumeration support
  i2c / ACPI: add ACPI enumeration support

 drivers/acpi/Kconfig        |    6 ++
 drivers/acpi/Makefile       |    1 +
 drivers/acpi/acpi_i2c.c     |  212 +++++++++++++++++++++++++++++++++++++++++++
 drivers/gpio/Kconfig        |    4 +
 drivers/gpio/Makefile       |    1 +
 drivers/gpio/gpiolib-acpi.c |   56 ++++++++++++
 drivers/i2c/i2c-core.c      |   10 ++
 drivers/spi/spi.c           |  201 +++++++++++++++++++++++++++++++++++++++-
 include/linux/acpi_gpio.h   |   19 ++++
 include/linux/acpi_i2c.h    |   27 ++++++
 10 files changed, 536 insertions(+), 1 deletion(-)
 create mode 100644 drivers/acpi/acpi_i2c.c
 create mode 100644 drivers/gpio/gpiolib-acpi.c
 create mode 100644 include/linux/acpi_gpio.h
 create mode 100644 include/linux/acpi_i2c.h

-- 
1.7.10.4

