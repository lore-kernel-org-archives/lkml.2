Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121Ab2HII75 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 04:59:57 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64043 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756923Ab2HII7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 04:59:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 06/10] ARM: davinci: don't use broken ntosd2_init_i2c
Date: Thu, 9 Aug 2012 08:00:17 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        Kevin Hilman <khilman@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        Andrey Porodko <panda@chelcom.ru>
References: <1344461278-28245-1-git-send-email-arnd@arndb.de> <1344461278-28245-7-git-send-email-arnd@arndb.de>
In-Reply-To: <1344461278-28245-7-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201208090800.18321.arnd@arndb.de>
X-Provags-ID: V02:K0:G93hVoDpuiIPMvINb8gbN4CBeXdzg/5gP0/4MF3LIvS
 wpBkfu+Ar9Thybtu8oDkHL2qLSVLSG1oDsXjPcrH14LqV9yGk/
 h0U6YWwycvnADP6Xhfmf7kYxZGdbgCiuvurNGVJXvmyCzr83lo
 wUdyvJIDAKg9EHDhLpjlE/CBouT8kkElTngPhI7lcBCspTAMan
 q4d06lugGtiTYJqndX4J9Yxqj7M8gEuNkTTXfD700YdGYwKAEv
 Bgs/8D+exTwKVafnvKAHC5X2vx6d+YQgWZ3GLrTCKqsex67JPy
 plWes1NG3QRy6fAGibmaN9dZaXCyDbbkEz96kRBGt/0ouMe8CB
 0hjJZYwyV3MOcn+VnH68=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On second thought, there is probably no use in keeping the broken function
around, and we can just kill it off. If someone wants to add an i2c
device to the bus, they can always add the init code back as well.

8<-----
Subject: ARM: davinci: don't use broken ntosd2_init_i2c

ntosd2_init_i2c walks the ntosd2_i2c_info array, which it expects to
be populated with at least one member. gcc correctly warns about
the out-of-bounds access here.

Since this can not possibly work, it's better to disable i2c
support entirely on this board.

Without this patch, building davinci_all_defconfig results in:

arch/arm/mach-davinci/board-neuros-osd2.c: In function 'davinci_ntosd2_init':
arch/arm/mach-davinci/board-neuros-osd2.c:187:20: warning: array subscript is above array bounds [-Warray-bounds]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Kevin Hilman <khilman@ti.com>
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Andrey Porodko <panda@chelcom.ru>

diff --git a/arch/arm/mach-davinci/board-neuros-osd2.c b/arch/arm/mach-davinci/board-neuros-osd2.c
index 5de69f2..f6b9fc7 100644
--- a/arch/arm/mach-davinci/board-neuros-osd2.c
+++ b/arch/arm/mach-davinci/board-neuros-osd2.c
@@ -162,38 +162,6 @@ static void __init davinci_ntosd2_map_io(void)
 	dm644x_init();
 }
 
-/*
- I2C initialization
-*/
-static struct davinci_i2c_platform_data ntosd2_i2c_pdata = {
-	.bus_freq	= 20 /* kHz */,
-	.bus_delay	= 100 /* usec */,
-};
-
-static struct i2c_board_info __initdata ntosd2_i2c_info[] =  {
-};
-
-static	int ntosd2_init_i2c(void)
-{
-	int	status;
-
-	davinci_init_i2c(&ntosd2_i2c_pdata);
-	status = gpio_request(NTOSD2_MSP430_IRQ, ntosd2_i2c_info[0].type);
-	if (status == 0) {
-		status = gpio_direction_input(NTOSD2_MSP430_IRQ);
-		if (status == 0) {
-			status = gpio_to_irq(NTOSD2_MSP430_IRQ);
-			if (status > 0) {
-				ntosd2_i2c_info[0].irq = status;
-				i2c_register_board_info(1,
-					ntosd2_i2c_info,
-					ARRAY_SIZE(ntosd2_i2c_info));
-			}
-		}
-	}
-	return status;
-}
-
 static struct davinci_mmc_config davinci_ntosd2_mmc_config = {
 	.wires		= 4,
 	.version	= MMC_CTLR_VERSION_1
@@ -218,7 +186,6 @@ static __init void davinci_ntosd2_init(void)
 {
 	struct clk *aemif_clk;
 	struct davinci_soc_info *soc_info = &davinci_soc_info;
-	int	status;
 
 	aemif_clk = clk_get(NULL, "aemif");
 	clk_enable(aemif_clk);
@@ -242,12 +209,6 @@ static __init void davinci_ntosd2_init(void)
 	platform_add_devices(davinci_ntosd2_devices,
 				ARRAY_SIZE(davinci_ntosd2_devices));
 
-	/* Initialize I2C interface specific for this board */
-	status = ntosd2_init_i2c();
-	if (status < 0)
-		pr_warning("davinci_ntosd2_init: msp430 irq setup failed:"
-						"	 %d\n", status);
-
 	davinci_serial_init(&uart_config);
 	dm644x_init_asp(&dm644x_ntosd2_snd_data);
 
