Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932861Ab0KSWTw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:19:52 -0500
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:51858 "HELO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932830Ab0KSWTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 17:19:48 -0500
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: spi-devel-general@lists.sourceforge.net,
        Grant Likely <grant.likely@secretlab.ca>,
        David Brownell <dbrownell@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org, Michael Buesch <mb@bu3sch.de>
Subject: [PATCH][RFC] spi-gpio: implement spidelay() for platforms that configure SLOWER_SPI_GPIO
Date: Fri, 19 Nov 2010 17:19:45 -0500
Message-Id: <1290205185-11956-1-git-send-email-bengardiner@nanometrics.ca>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a Kconfig option, SLOWER_SPI_GPIO, that enables a spidelay
implementation of ndelay when defined.

This is based off of the patch proposed by Michael Buesch [1]. Whereas that
patch required slave's set their spi_device.max_speed_hz and
spi_transfer.speed_hz to 0 to obtain 'as fast as we can transfers' this patch
keeps the default of 'as fast as we can' for any GPIO SPI master unless the
proposed Kconfig option is enabled.

Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>
Reviewed-by: Dan Sharon <dansharon@nanometrics.ca>
Reviewed-by: Chris Cordahi <chriscordahi@nanometrics.ca>
CC: Michael Buesch <mb@bu3sch.de>

[1] http://article.gmane.org/gmane.comp.embedded.openwrt.devel/2854

---

This patch was rebased to 6656b3fc8aba2eb7ca00c06c7fe4917938b0b652 of
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

Testing was performed using the GPIOs of a da850evm. I registered an spi-gpio
instance and a slave device with a transfer speed of 500Hz (the slowest
possible speed on ARM since the udelay max is 2ms):

...
static struct spi_gpio_platform_data bb_spi_gpio_pdata = {
       .sck            = SPIG_CLK,
       .mosi           = SPIG_SIMO,
       .miso           = SPIG_SOMI,
       .num_chipselect = 1,
};

static struct platform_device bb_spi_gpio = {
       .name           = "spi_gpio",
       .id             = 0,
       .dev            = {
               .platform_data  = &bb_spi_gpio_pdata,
       },
};

static struct spi_board_info bb_spi_devices[] = {
       {
               .modalias       = "spidev",
               .max_speed_hz   = 500,
               .bus_num        = 0,
               .chip_select    = 0,
               .mode           = SPI_MODE_0,
       },
};
...

Without SLOWER_SPI_GPIO=y a spi transfer using 'echo a > /dev/spidev0.0'
resulted in a ~700kHz SCLK signal. 
With SLOWER_SPI_GPIO=y a spi transfer using 'echo a > /dev/spidev0.0'
resulted in a ~500Hz SCLK signal.

---

 drivers/spi/Kconfig    |   17 +++++++++++++++++
 drivers/spi/spi_gpio.c |    5 +++++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 78f9fd0..0570dcd 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -143,6 +143,23 @@ config SPI_GPIO
 	  GPIO operations, you should be able to leverage that for better
 	  speed with a custom version of this driver; see the source code.
 
+config SLOWER_SPI_GPIO
+	bool "Enable delays in the GPIO-based bitbanging SPI Master"
+	default n
+	depends on SPI_GPIO
+	help
+	  The GPIO bitbanging SPI master driver will run without any delays if this
+	  option is not set. This option will enable the use of delays in the
+	  operation of the GPIO bitbanging SPI master implementation to honour the
+	  maximum speed of very slow devices.
+
+	  To configure slow speed devices your board-specific setup logic must also
+	  provide platform data assigning the speed for a device on a given chip
+	  select of the GPIO bitbanging SPI master.
+
+	  If your platform requires SPI buses driven at slow speeds select yes. If
+	  in doubt, select no.
+
 config SPI_IMX_VER_IMX1
 	def_bool y if SOC_IMX1
 
diff --git a/drivers/spi/spi_gpio.c b/drivers/spi/spi_gpio.c
index 63e51b0..b31fddd 100644
--- a/drivers/spi/spi_gpio.c
+++ b/drivers/spi/spi_gpio.c
@@ -19,6 +19,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/delay.h>
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
 
@@ -119,6 +120,9 @@ static inline int getmiso(const struct spi_device *spi)
 
 #undef pdata
 
+#if defined(CONFIG_SLOWER_SPI_GPIO)
+#define spidelay(nsecs) ndelay(nsecs)
+#else
 /*
  * NOTE:  this clocks "as fast as we can".  It "should" be a function of the
  * requested device clock.  Software overhead means we usually have trouble
@@ -126,6 +130,7 @@ static inline int getmiso(const struct spi_device *spi)
  * we'll just assume we never need additional per-bit slowdowns.
  */
 #define spidelay(nsecs)	do {} while (0)
+#endif
 
 #include "spi_bitbang_txrx.h"
 
-- 
1.7.0.4

