Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965Ab1CNK4M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 06:56:12 -0400
Received: from compulab.co.il ([67.18.134.219]:43453 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272Ab1CNK4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 06:56:11 -0400
Message-ID: <4D7DF391.50302@compulab.co.il>
Date: Mon, 14 Mar 2011 12:53:05 +0200
From: Denis Turischev <denis@compulab.co.il>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        David Brownell <dbrownell@users.sourceforge.net>
Subject: [PATCH 3/3 v2] sch_gpio: expand for Tunnel Creek
References: <4D7CE230.1070004@compulab.co.il> <4D7CE2BB.5010802@compulab.co.il> <4D7CE31E.207@compulab.co.il>
In-Reply-To: <4D7CE31E.207@compulab.co.il>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Almost the same driver for both Poulsbo and Tunnel Creek.
The difference is in quantity of GPIOs powered by the core power
rail and by suspend power supply, default values for some GPIOs, etc.
Detect actual hardware by platform device ID assigned in lpc_sch
and set configuration accordingly.

v2: added include <linux/pci_ids.h> line

Signed-off-by: Denis Turischev <denis@compulab.co.il>
---
 drivers/gpio/Kconfig    |    7 ++++-
 drivers/gpio/sch_gpio.c |   59 +++++++++++++++++++++++++++++++---------------
 2 files changed, 45 insertions(+), 21 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 664660e..7ef9108 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -100,18 +100,21 @@ config GPIO_VR41XX
 	  Say yes here to support the NEC VR4100 series General-purpose I/O Uint

 config GPIO_SCH
-	tristate "Intel SCH GPIO"
+	tristate "Intel SCH/TunnelCreek GPIO"
 	depends on GPIOLIB && PCI
 	select MFD_CORE
 	select LPC_SCH
 	help
-	  Say yes here to support GPIO interface on Intel Poulsbo SCH.
+	  Say yes here to support GPIO interface on Intel Poulsbo SCH
+	  or Intel Tunnel Creek processor.
 	  The Intel SCH contains a total of 14 GPIO pins. Ten GPIOs are
 	  powered by the core power rail and are turned off during sleep
 	  modes (S3 and higher). The remaining four GPIOs are powered by
 	  the Intel SCH suspend power supply. These GPIOs remain
 	  active during S3. The suspend powered GPIOs can be used to wake the
 	  system from the Suspend-to-RAM state.
+	  The Intel Tunnel Creek processor has 5 GPIOs powered by the
+	  core power rail and 9 from suspend power supply.

 	  This driver can also be built as a module. If so, the module
 	  will be called sch-gpio.
diff --git a/drivers/gpio/sch_gpio.c b/drivers/gpio/sch_gpio.c
index 5835213..58e4510 100644
--- a/drivers/gpio/sch_gpio.c
+++ b/drivers/gpio/sch_gpio.c
@@ -25,6 +25,7 @@
 #include <linux/errno.h>
 #include <linux/acpi.h>
 #include <linux/platform_device.h>
+#include <linux/pci_ids.h>

 #include <linux/gpio.h>

@@ -187,7 +188,11 @@ static struct gpio_chip sch_gpio_resume = {
 static int __devinit sch_gpio_probe(struct platform_device *pdev)
 {
 	struct resource *res;
-	int err;
+	int err, id;
+
+	id = pdev->id;
+	if (!id)
+		return -ENODEV;

 	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
 	if (!res)
@@ -198,12 +203,40 @@ static int __devinit sch_gpio_probe(struct platform_device *pdev)

 	gpio_ba = res->start;

-	sch_gpio_core.base = 0;
-	sch_gpio_core.ngpio = 10;
-	sch_gpio_core.dev = &pdev->dev;
+	switch (id) {
+		case PCI_DEVICE_ID_INTEL_SCH_LPC:
+			sch_gpio_core.base = 0;
+			sch_gpio_core.ngpio = 10;
+
+			sch_gpio_resume.base = 10;
+			sch_gpio_resume.ngpio = 4;
+
+			/*
+			 * GPIO[6:0] enabled by default
+			 * GPIO7 is configured by the CMC as SLPIOVR
+			 * Enable GPIO[9:8] core powered gpios explicitly
+			 */
+			outb(0x3, gpio_ba + CGEN + 1);
+			/*
+			 * SUS_GPIO[2:0] enabled by default
+			 * Enable SUS_GPIO3 resume powered gpio explicitly
+			 */
+			outb(0x8, gpio_ba + RGEN);
+			break;
+
+		case PCI_DEVICE_ID_INTEL_ITC_LPC:
+			sch_gpio_core.base = 0;
+			sch_gpio_core.ngpio = 5;
+
+			sch_gpio_resume.base = 5;
+			sch_gpio_resume.ngpio = 9;
+			break;
+
+		default:
+			return -ENODEV;
+	}

-	sch_gpio_resume.base = 10;
-	sch_gpio_resume.ngpio = 4;
+	sch_gpio_core.dev = &pdev->dev;	
 	sch_gpio_resume.dev = &pdev->dev;

 	err = gpiochip_add(&sch_gpio_core);
@@ -214,18 +247,6 @@ static int __devinit sch_gpio_probe(struct platform_device *pdev)
 	if (err < 0)
 		goto err_sch_gpio_resume;

-	/*
-	 * GPIO[6:0] enabled by default
-	 * GPIO7 is configured by the CMC as SLPIOVR
-	 * Enable GPIO[9:8] core powered gpios explicitly
-	 */
-	outb(0x3, gpio_ba + CGEN + 1);
-	/*
-	 * SUS_GPIO[2:0] enabled by default
-	 * Enable SUS_GPIO3 resume powered gpio explicitly
-	 */
-	outb(0x8, gpio_ba + RGEN);
-
 	return 0;

 err_sch_gpio_resume:
-- 
1.7.0.4
