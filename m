Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462Ab0HOTv3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 15:51:29 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:52061 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751391Ab0HOTv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 15:51:27 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: [PATCH] cyber2000fb: palette corruption at higher clocks
Date: Sun, 15 Aug 2010 21:51:11 +0200
User-Agent: KMail/1.9.10
Cc: linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1648
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201008152151.14175.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I'm implementing EDID support for cyber2000fb and found a weird bug in
cyber2000fb driver. My monitor EDID reports 1280x1024@75Hz as best mode. When
this mode is set, console palette is not set properly - sometimes the
background is white, sometimes yellow and text colors are also messed up.
This does not happen at 1280x1024@60Hz.

When I run "reset", it fixes the palette. But when I run it immediately after
loading the driver (i.e. "modprobe cyber2000fb mode_option=1280x1024-8@75 &&
reset"), it does not help. "sleep 0.6" needs to be added before "reset" to
make it work.

It seems that the HW needs some time before setting the palette - maybe the
PLL needs more time to lock at higher speeds? Does anyone have some HW docs
to check this? This patch fixes the problem but without knowing what register
to check for PLL lock(?), the delay might be excessive.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.35-rc3-/drivers/video/cyber2000fb.c	2010-08-15 21:13:39.000000000 +0200
+++ linux-2.6.35-rc3/drivers/video/cyber2000fb.c	2010-08-15 21:25:20.000000000 +0200
@@ -506,6 +506,9 @@ static void cyber2000fb_set_timing(struc
 	cyber2000_grphw(0xb9, 0x80, cfb);
 	cyber2000_grphw(0xb9, 0x00, cfb);
 
+	/* wait (for the PLL?) to avoid palette corruption at higher clocks */
+	msleep(1000);
+
 	cfb->ramdac_ctrl = hw->ramdac;
 	cyber2000fb_write_ramdac_ctrl(cfb);
 



-- 
Ondrej Zary
