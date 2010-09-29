Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574Ab0I2Tfw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 15:35:52 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:51021 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782Ab0I2Tfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 15:35:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:to:from:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=D4oWsR2gle5ynmKbt2N3TI6xFhyi5a3wQb3vk4k5utaRyG3oq5GCtecrkQIy7CH2Md
         dlKF2st1xkdc7JUrXlp2CfLrDcsV0LYZ3PpaTPK0z5VwdJQgKj1/qxiPEY8LYBmuKIW7
         xj2uRhiiW3jjErQrhOhJD3Re29jUBmqq3Co04=
Subject: [PATCH 6/9] ARM: S3C64XX: add nand support for mach-mini6410
To: linux-arm-kernel@lists.infradead.org
From: Darius Augulis <augulis.darius@gmail.com>
Cc: kgene.kim@samsung.com, paulius.zaleckas@gmail.com,
        linux-kernel@vger.kernel.org, ben-linux@fluff.org
Date: Wed, 29 Sep 2010 22:35:47 +0300
Message-ID: <20100929193539.25307.9193.stgit@darius-desktop>
In-Reply-To: <20100929192354.25307.40197.stgit@darius-desktop>
References: <20100929192354.25307.40197.stgit@darius-desktop>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add nand device support and mtd partition
table for mini6410

Signed-off-by: Darius Augulis <augulis.darius@gmail.com>
---
 arch/arm/mach-s3c64xx/Kconfig         |    1 +
 arch/arm/mach-s3c64xx/mach-mini6410.c |   41 +++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-s3c64xx/Kconfig b/arch/arm/mach-s3c64xx/Kconfig
index bbeb4ca..3bbd204 100644
--- a/arch/arm/mach-s3c64xx/Kconfig
+++ b/arch/arm/mach-s3c64xx/Kconfig
@@ -105,6 +105,7 @@ config MACH_MINI6410
 	select S3C_DEV_HSMMC1
 	select S3C64XX_SETUP_SDHCI
 	select S3C_DEV_USB_HOST
+	select S3C_DEV_NAND
 	help
 	  Machine support for the FriendlyARM MINI6410
 
diff --git a/arch/arm/mach-s3c64xx/mach-mini6410.c b/arch/arm/mach-s3c64xx/mach-mini6410.c
index 425e65d..7408d55 100644
--- a/arch/arm/mach-s3c64xx/mach-mini6410.c
+++ b/arch/arm/mach-s3c64xx/mach-mini6410.c
@@ -18,6 +18,8 @@
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/dm9000.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/partitions.h>
 #include <linux/serial_core.h>
 #include <linux/types.h>
 
@@ -32,6 +34,7 @@
 
 #include <plat/cpu.h>
 #include <plat/devs.h>
+#include <plat/nand.h>
 #include <plat/regs-serial.h>
 
 #define UCON (S3C2410_UCON_DEFAULT | S3C2410_UCON_UCLK)
@@ -103,11 +106,47 @@ static struct platform_device mini6410_device_eth = {
 	},
 };
 
+static struct mtd_partition mini6410_nand_part[] = {
+	[0] = {
+		.name	= "uboot",
+		.size	= SZ_1M,
+		.offset	= 0,
+	},
+	[1] = {
+		.name	= "kernel",
+		.size	= SZ_2M,
+		.offset	= SZ_1M,
+	},
+	[2] = {
+		.name	= "rootfs",
+		.size	= MTDPART_SIZ_FULL,
+		.offset	= SZ_1M + SZ_2M,
+	},
+};
+
+static struct s3c2410_nand_set mini6410_nand_sets[] = {
+	[0] = {
+		.name		= "nand",
+		.nr_chips	= 1,
+		.nr_partitions	= ARRAY_SIZE(mini6410_nand_part),
+		.partitions	= mini6410_nand_part,
+	},
+};
+
+static struct s3c2410_platform_nand mini6410_nand_info = {
+	.tacls		= 25,
+	.twrph0		= 55,
+	.twrph1		= 40,
+	.nr_sets	= ARRAY_SIZE(mini6410_nand_sets),
+	.sets		= mini6410_nand_sets,
+};
+
 static struct platform_device *mini6410_devices[] __initdata = {
 	&mini6410_device_eth,
 	&s3c_device_hsmmc0,
 	&s3c_device_hsmmc1,
 	&s3c_device_ohci,
+	&s3c_device_nand,
 };
 
 static void __init mini6410_map_io(void)
@@ -121,6 +160,8 @@ static void __init mini6410_machine_init(void)
 {
 	u32 cs1;
 
+	s3c_nand_set_platdata(&mini6410_nand_info);
+
 	/* configure nCS1 width to 16 bits */
 
 	cs1 = __raw_readl(S3C64XX_SROM_BW) &

