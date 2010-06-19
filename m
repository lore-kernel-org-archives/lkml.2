Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368Ab0FSPsU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 11:48:20 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34094 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756305Ab0FSPsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 11:48:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:openpgp:content-type
         :content-transfer-encoding;
        b=hdm0zEgIOVI6ZCVNrttep8T0gsfgZXGCXNA4s1KcYE0gfwBcMlf5ups/MD+wehAhxn
         m77fRXKHZnZwf0geeHzIFUYf5tme0ej6YJHtbY8OM/wkvevZ876QqFJ2DPa3JJmR+Mll
         KJnV1c6CG2j7EFOdn0w0lY/l5kW6wtM1eJJZQ=
Message-ID: <4C1CE6B8.4090504@gmail.com>
Date: Sat, 19 Jun 2010 17:48:08 +0200
From: Martin Fuzzey <mfuzzey@gmail.com>
Reply-To: mfuzzey@gmail.com
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: Luotao Fu <l.fu@pengutronix.de>
CC: Sascha Hauer <kernel@pengutronix.de>, linux-fbdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] imxfb: add flag to avoid disabling clk multiple times
References: <1275561288-20661-1-git-send-email-l.fu@pengutronix.de>
In-Reply-To: <1275561288-20661-1-git-send-email-l.fu@pengutronix.de>
X-Enigmail-Version: 0.95.0
OpenPGP: id=9B2DC6BF;
	url=
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luotao,

Luotao Fu wrote:
> while the imxfb driver blanks the screen. The clock supply to the framebuffer
> controller is disabled. The same callback to disable the fb is, however, also
> used the remove and shutdown hooks of the imxfb platform driver. This means that
> the imxfb driver can run into a WARN in clock_disable while unloading or
> rebooting, if the screen is blanked previously, since the same clock will be
> than eventually disabled multiple times.  This patch adds a flag to make sure
> that the clock will only be disabled, if it was not already disabled before.
>
>   
Actually it's worse than that - you don't need to unload the
driver or reboot to run into this problem because imxfb_blank()
calls imxfb_disable_controller() for cases
    case FB_BLANK_POWERDOWN:
    case FB_BLANK_VSYNC_SUSPEND:
    case FB_BLANK_HSYNC_SUSPEND:
    case FB_BLANK_NORMAL:

Often an X server will call these after successive timeouts
(eg Normal, Suspend, Powerdown) so you can get into the
multiple suspend problem you describe just by waiting long
enough for at least two blank levels to be activated.

Furthermore once this happens, not only does a WARN occur
in clock_disable but the clock usage counter will actually become
negative so it will require multiple wake up requests to switch
the display back on.

I was just about to post a patch for this but I see you beat
me to it :).

Your patch fixes the clock_disable problem but fbi->backlight_power()
and fbi->lcd_power() can still be called multiple times.
Not sure if that is really a problem - they should be idempotent.

I did it by making all of imxfb_disable_controller() do nothing if the
disable was already done like this  (just for illustration not submission,
lines may be mangled):


--- a/drivers/video/imxfb.c
+++ b/drivers/video/imxfb.c
@@ -175,6 +175,7 @@ struct imxfb_info {
 
        struct imx_fb_videomode *mode;
        int                     num_modes;
+       int                     enabled;
 
        void (*lcd_power)(int);
        void (*backlight_power)(int);
@@ -451,6 +452,9 @@ static int imxfb_set_par(struct fb_info *info)
 
 static void imxfb_enable_controller(struct imxfb_info *fbi)
 {
+       if (fbi->enabled)
+               return;
+
        pr_debug("Enabling LCD controller\n");
 
        writel(fbi->screen_dma, fbi->regs + LCDC_SSA);
@@ -470,10 +474,13 @@ static void imxfb_enable_controller(struct
imxfb_info *fbi)
                fbi->backlight_power(1);
        if (fbi->lcd_power)
                fbi->lcd_power(1);
+       fbi->enabled = 1;
 }
 
 static void imxfb_disable_controller(struct imxfb_info *fbi)
 {
+       if (!fbi->enabled)
+               return;
        pr_debug("Disabling LCD controller\n");
 
        if (fbi->backlight_power)
@@ -484,6 +491,7 @@ static void imxfb_disable_controller(struct
imxfb_info *fbi)
        clk_disable(fbi->clk);
 
        writel(0, fbi->regs + LCDC_RMCR);
+       fbi->enabled = 0;
 }
 
 static int imxfb_blank(int blank, struct fb_info *info)


Though this does miss the explicit  clk_disable() in imxfb_remove()


Cheers,

Martin


