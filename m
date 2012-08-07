Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200Ab2HGSmz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 14:42:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54908 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756172Ab2HGSmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 14:42:52 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Haojian Zhuang <haojian.zhuang@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <rmk@arm.linux.org.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        stable@vger.kernel.org (v3.4+)
Subject: [PATCH 1/7] mfd: max8925: Move _IO resources out of ioport_ioresource
Date: Tue,  7 Aug 2012 19:42:43 +0100
Message-Id: <1344364969-32489-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The removal of mach/io.h from most ARM platforms also set the range of
valid IO ports to be empty for most platforms when previously any 32
bit integer had been valid. This makes it impossible to add IO resources
as the added range is smaller than that of the root resource for IO ports.

Since we're not really using IO memory at all fix this by defining our
own root resource outside the normal tree and make that the parent of
all IO resources. This also ensures we won't conflict with read IO ports
if we ever run on a platform which happens to use them.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: stable@vger.kernel.org (v3.4+)
---
 drivers/mfd/max8925-core.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/mfd/max8925-core.c b/drivers/mfd/max8925-core.c
index 825a7f0..6aa3a22 100644
--- a/drivers/mfd/max8925-core.c
+++ b/drivers/mfd/max8925-core.c
@@ -18,12 +18,19 @@
 #include <linux/mfd/core.h>
 #include <linux/mfd/max8925.h>
 
+static struct resource io_parent = {
+	.start = 0,
+	.end   = 0xffffffff,
+	.flags = IORESOURCE_IO,
+};
+
 static struct resource backlight_resources[] = {
 	{
 		.name	= "max8925-backlight",
 		.start	= MAX8925_WLED_MODE_CNTL,
 		.end	= MAX8925_WLED_CNTL,
 		.flags	= IORESOURCE_IO,
+		.parent = &io_parent,
 	},
 };
 
@@ -42,6 +49,7 @@ static struct resource touch_resources[] = {
 		.start	= MAX8925_TSC_IRQ,
 		.end	= MAX8925_ADC_RES_END,
 		.flags	= IORESOURCE_IO,
+		.parent = &io_parent,
 	},
 };
 
@@ -60,6 +68,7 @@ static struct resource power_supply_resources[] = {
 		.start	= MAX8925_CHG_IRQ1,
 		.end	= MAX8925_CHG_IRQ1_MASK,
 		.flags	= IORESOURCE_IO,
+		.parent = &io_parent,
 	},
 };
 
@@ -118,6 +127,7 @@ static struct mfd_cell onkey_devs[] = {
 	.start	= MAX8925_##_start,		\
 	.end	= MAX8925_##_end,		\
 	.flags	= IORESOURCE_IO,		\
+	.parent = &io_parent,			\
 }
 
 static struct resource regulator_resources[] = {
-- 
1.7.10.4

