Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932782Ab2JKBEM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 21:04:12 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60913 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932649Ab2JKBEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 21:04:07 -0400
X-Sasl-enc: p5A+O3n9srmbRil5SUJcUFpjjbOF6IFjk71WtCB7/UOX 1349917445
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [ 010/120] mfd: max8925: Move _IO resources out of ioport_ioresource
Date: Thu, 11 Oct 2012 09:59:22 +0900
Message-Id: <20121011005827.201545471@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011005825.364610894@linuxfoundation.org>
References: <20121011005825.364610894@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit bee6e1fa617b1fb7f6f91033428410e05f5ab0ed upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mfd/max8925-core.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

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
 
@@ -42,6 +49,7 @@ static struct resource touch_resources[]
 		.start	= MAX8925_TSC_IRQ,
 		.end	= MAX8925_ADC_RES_END,
 		.flags	= IORESOURCE_IO,
+		.parent = &io_parent,
 	},
 };
 
@@ -60,6 +68,7 @@ static struct resource power_supply_reso
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


