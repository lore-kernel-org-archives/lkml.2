Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845Ab0HPUKM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 16:10:12 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:53641 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753573Ab0HPUKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 16:10:10 -0400
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: [PATCH] [RFC] cyber2000fb: avoid palette corruption at higher clocks
Cc: linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Content-Disposition: inline
From: Ondrej Zary <linux@rainbow-software.org>
Date: Mon, 16 Aug 2010 22:09:54 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008162209.56902.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When 1280x1024@75Hz mode is set, console palette is not set properly -
sometimes the background is white, sometimes yellow and text colors are also
messed up. This does not happen at 1280x1024@60Hz and below.

It seems that the HW needs some time before setting the palette - maybe the
PLL needs more time to lock at higher speeds. This patch fixes the problem but
without knowing what register to check for PLL lock(?), the delay might be
excessive.

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
