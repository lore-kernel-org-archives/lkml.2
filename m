Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab2KZRBL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:01:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47086 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756027Ab2KZRBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:01:08 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 022/270] mfd: 88pm860x: Move _IO resources out of ioport_ioresource
Date: Mon, 26 Nov 2012 14:55:12 -0200
Message-Id: <1353949160-26803-23-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit c10c2aab634a3c61c46b98875988b2f53040bc9c upstream.

The removal of mach/io.h from most ARM platforms also set the range of
valid IO ports to be empty for most platforms when previously any 32
bit integer had been valid. This makes it impossible to add IO resources
as the added range is smaller than that of the root resource for IO ports.

Since we're not really using IO memory at all fix this by defining our
own root resource outside the normal tree and make that the parent of
all IO resources. This also ensures we won't conflict with read IO ports
if we ever run on a platform which happens to use them.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
Tested-by: Haojian Zhuang <haojian.zhuang@gmail.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/mfd/88pm860x-core.c |   89 +++++++++++++++++++++++++++++--------------
 1 file changed, 61 insertions(+), 28 deletions(-)

diff --git a/drivers/mfd/88pm860x-core.c b/drivers/mfd/88pm860x-core.c
index 87bd5ba..1a9e5f1 100644
--- a/drivers/mfd/88pm860x-core.c
+++ b/drivers/mfd/88pm860x-core.c
@@ -21,40 +21,73 @@
 
 #define INT_STATUS_NUM			3
 
+static struct resource io_parent = {
+	.start = 0,
+	.end   = 0xffffffff,
+	.flags = IORESOURCE_IO,
+};
+
 static struct resource bk_resources[] __devinitdata = {
-	{PM8606_BACKLIGHT1, PM8606_BACKLIGHT1, "backlight-0", IORESOURCE_IO,},
-	{PM8606_BACKLIGHT2, PM8606_BACKLIGHT2, "backlight-1", IORESOURCE_IO,},
-	{PM8606_BACKLIGHT3, PM8606_BACKLIGHT3, "backlight-2", IORESOURCE_IO,},
+	{PM8606_BACKLIGHT1, PM8606_BACKLIGHT1, "backlight-0", IORESOURCE_IO,
+	 &io_parent,},
+	{PM8606_BACKLIGHT2, PM8606_BACKLIGHT2, "backlight-1", IORESOURCE_IO,
+	 &io_parent,},
+	{PM8606_BACKLIGHT3, PM8606_BACKLIGHT3, "backlight-2", IORESOURCE_IO,
+	 &io_parent,},
 };
 
 static struct resource led_resources[] __devinitdata = {
-	{PM8606_LED1_RED,   PM8606_LED1_RED,   "led0-red",   IORESOURCE_IO,},
-	{PM8606_LED1_GREEN, PM8606_LED1_GREEN, "led0-green", IORESOURCE_IO,},
-	{PM8606_LED1_BLUE,  PM8606_LED1_BLUE,  "led0-blue",  IORESOURCE_IO,},
-	{PM8606_LED2_RED,   PM8606_LED2_RED,   "led1-red",   IORESOURCE_IO,},
-	{PM8606_LED2_GREEN, PM8606_LED2_GREEN, "led1-green", IORESOURCE_IO,},
-	{PM8606_LED2_BLUE,  PM8606_LED2_BLUE,  "led1-blue",  IORESOURCE_IO,},
+	{PM8606_LED1_RED,   PM8606_LED1_RED,   "led0-red",   IORESOURCE_IO,
+	 &io_parent,},
+	{PM8606_LED1_GREEN, PM8606_LED1_GREEN, "led0-green", IORESOURCE_IO,
+	 &io_parent,},
+	{PM8606_LED1_BLUE,  PM8606_LED1_BLUE,  "led0-blue",  IORESOURCE_IO,
+	 &io_parent,},
+	{PM8606_LED2_RED,   PM8606_LED2_RED,   "led1-red",   IORESOURCE_IO,
+	 &io_parent,},
+	{PM8606_LED2_GREEN, PM8606_LED2_GREEN, "led1-green", IORESOURCE_IO,
+	 &io_parent,},
+	{PM8606_LED2_BLUE,  PM8606_LED2_BLUE,  "led1-blue",  IORESOURCE_IO,
+	 &io_parent,},
 };
 
 static struct resource regulator_resources[] __devinitdata = {
-	{PM8607_ID_BUCK1, PM8607_ID_BUCK1, "buck-1", IORESOURCE_IO,},
-	{PM8607_ID_BUCK2, PM8607_ID_BUCK2, "buck-2", IORESOURCE_IO,},
-	{PM8607_ID_BUCK3, PM8607_ID_BUCK3, "buck-3", IORESOURCE_IO,},
-	{PM8607_ID_LDO1,  PM8607_ID_LDO1,  "ldo-01", IORESOURCE_IO,},
-	{PM8607_ID_LDO2,  PM8607_ID_LDO2,  "ldo-02", IORESOURCE_IO,},
-	{PM8607_ID_LDO3,  PM8607_ID_LDO3,  "ldo-03", IORESOURCE_IO,},
-	{PM8607_ID_LDO4,  PM8607_ID_LDO4,  "ldo-04", IORESOURCE_IO,},
-	{PM8607_ID_LDO5,  PM8607_ID_LDO5,  "ldo-05", IORESOURCE_IO,},
-	{PM8607_ID_LDO6,  PM8607_ID_LDO6,  "ldo-06", IORESOURCE_IO,},
-	{PM8607_ID_LDO7,  PM8607_ID_LDO7,  "ldo-07", IORESOURCE_IO,},
-	{PM8607_ID_LDO8,  PM8607_ID_LDO8,  "ldo-08", IORESOURCE_IO,},
-	{PM8607_ID_LDO9,  PM8607_ID_LDO9,  "ldo-09", IORESOURCE_IO,},
-	{PM8607_ID_LDO10, PM8607_ID_LDO10, "ldo-10", IORESOURCE_IO,},
-	{PM8607_ID_LDO11, PM8607_ID_LDO11, "ldo-11", IORESOURCE_IO,},
-	{PM8607_ID_LDO12, PM8607_ID_LDO12, "ldo-12", IORESOURCE_IO,},
-	{PM8607_ID_LDO13, PM8607_ID_LDO13, "ldo-13", IORESOURCE_IO,},
-	{PM8607_ID_LDO14, PM8607_ID_LDO14, "ldo-14", IORESOURCE_IO,},
-	{PM8607_ID_LDO15, PM8607_ID_LDO15, "ldo-15", IORESOURCE_IO,},
+	{PM8607_ID_BUCK1, PM8607_ID_BUCK1, "buck-1", IORESOURCE_IO,
+	 &io_parent,},
+	{PM8607_ID_BUCK2, PM8607_ID_BUCK2, "buck-2", IORESOURCE_IO,
+	 &io_parent,},
+	{PM8607_ID_BUCK3, PM8607_ID_BUCK3, "buck-3", IORESOURCE_IO,
+	 &io_parent,},
+	{PM8607_ID_LDO1,  PM8607_ID_LDO1,  "ldo-01", IORESOURCE_IO,
+	 &io_parent,},
+	{PM8607_ID_LDO2,  PM8607_ID_LDO2,  "ldo-02", IORESOURCE_IO,
+	 &io_parent,},
+	{PM8607_ID_LDO3,  PM8607_ID_LDO3,  "ldo-03", IORESOURCE_IO,
+	 &io_parent,},
+	{PM8607_ID_LDO4,  PM8607_ID_LDO4,  "ldo-04", IORESOURCE_IO,
+	 &io_parent,},
+	{PM8607_ID_LDO5,  PM8607_ID_LDO5,  "ldo-05", IORESOURCE_IO,
+	 &io_parent,},
+	{PM8607_ID_LDO6,  PM8607_ID_LDO6,  "ldo-06", IORESOURCE_IO,
+	 &io_parent,},
+	{PM8607_ID_LDO7,  PM8607_ID_LDO7,  "ldo-07", IORESOURCE_IO,
+	 &io_parent,},
+	{PM8607_ID_LDO8,  PM8607_ID_LDO8,  "ldo-08", IORESOURCE_IO,
+	 &io_parent,},
+	{PM8607_ID_LDO9,  PM8607_ID_LDO9,  "ldo-09", IORESOURCE_IO,
+	 &io_parent,},
+	{PM8607_ID_LDO10, PM8607_ID_LDO10, "ldo-10", IORESOURCE_IO,
+	 &io_parent,},
+	{PM8607_ID_LDO11, PM8607_ID_LDO11, "ldo-11", IORESOURCE_IO,
+	 &io_parent,},
+	{PM8607_ID_LDO12, PM8607_ID_LDO12, "ldo-12", IORESOURCE_IO,
+	 &io_parent,},
+	{PM8607_ID_LDO13, PM8607_ID_LDO13, "ldo-13", IORESOURCE_IO,
+	 &io_parent,},
+	{PM8607_ID_LDO14, PM8607_ID_LDO14, "ldo-14", IORESOURCE_IO,
+	 &io_parent,},
+	{PM8607_ID_LDO15, PM8607_ID_LDO15, "ldo-15", IORESOURCE_IO,
+	 &io_parent,},
 };
 
 static struct resource touch_resources[] __devinitdata = {
@@ -91,7 +124,7 @@ static struct resource charger_resources[] __devinitdata = {
 };
 
 static struct resource rtc_resources[] __devinitdata = {
-	{PM8607_IRQ_RTC, PM8607_IRQ_RTC, "rtc", IORESOURCE_IRQ,},
+	{PM8607_IRQ_RTC, PM8607_IRQ_RTC, "rtc", IORESOURCE_IRQ, &io_parent,},
 };
 
 static struct mfd_cell bk_devs[] = {
-- 
1.7.9.5

