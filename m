Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab0H2JXV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 05:23:21 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:34951 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752135Ab0H2JXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 05:23:19 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Antonino Daplas <adaplas@gmail.com>
Subject: [PATCH] savagefb: fix DDC for Savage 4
Date: Sun, 29 Aug 2010 11:23:06 +0200
User-Agent: KMail/1.9.10
Cc: linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201008291123.08953.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I tested savagefb on 3 different Savage 4 cards:
Diamond Stealth III S520
Number Nine SR9
Datapath Horizon 2S (two savage chips on a PCI card)

it worked except the DDC which did not work on any of them.

Looking at the BIOS code, it does not use MMIO register 0xff20 but CRT
register 0xa0 or 0xb1 - depending on the chip revision and something in
register 0xa6. With this patch, DDC works fine on all 3 cards (even on the
second head of Horizon 2S - although it does not display anything as it's
misconfigured because of missing BIOS).

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.35-rc2/drivers/video/savage/savagefb-i2c.c	2010-06-06 05:43:24.000000000 +0200
+++ linux-2.6.35-rc3/drivers/video/savage/savagefb-i2c.c	2010-08-28 23:54:10.000000000 +0200
@@ -181,6 +181,15 @@
 		par->chan.algo.getscl = prosavage_gpio_getscl;
 		break;
 	case FB_ACCEL_SAVAGE4:
+		par->chan.reg = CR_SERIAL1;
+		if (par->pcidev->revision > 1 && !(VGArCR(0xa6, par) & 0x40))
+			par->chan.reg = CR_SERIAL2;
+		par->chan.ioaddr      = par->mmio.vbase;
+		par->chan.algo.setsda = prosavage_gpio_setsda;
+		par->chan.algo.setscl = prosavage_gpio_setscl;
+		par->chan.algo.getsda = prosavage_gpio_getsda;
+		par->chan.algo.getscl = prosavage_gpio_getscl;
+		break;
 	case FB_ACCEL_SAVAGE2000:
 		par->chan.reg         = 0xff20;
 		par->chan.ioaddr      = par->mmio.vbase;


-- 
Ondrej Zary
