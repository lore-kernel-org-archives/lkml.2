Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667Ab1AEAdI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 19:33:08 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52669 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab1AEAdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 19:33:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=QEHgj8S0mNmyuEGRofX8AUHh+Q9drk5xRXujznEipIQdVgsL+OylgjhNwS3fNL6NzT
         Tc8ytFqxLLa5AExv2KHbcDJLewr2zxs/V6lWIglN52R3T8eswcs+b/TOTBWzKyzwmLQr
         XtYcmbX5HvZt8oSvo+dRsuanbkTmc20/yPJEs=
Subject: Re: [PATCH] backlight: l4f00242t03: Fix reset sequence
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Purdie <rpurdie@rpsys.net>, Marek Vasut <marek.vasut@gmail.com>,
        Tejun Heo <tj@kernel.org>, Axel Lin <axel.lin@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20110104155920.1aafcf0c.akpm@linux-foundation.org>
References: <1290964433.3016.2.camel@realization>
	 <20110104155920.1aafcf0c.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Jan 2011 01:32:55 +0100
Message-ID: <1294187575.2509.276.camel@realization>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-04 at 15:59 -0800, Andrew Morton wrote:
> On Sun, 28 Nov 2010 18:13:53 +0100
> Alberto Panizzo <maramaopercheseimorto@gmail.com> wrote:
> 
> > The reset command is part of the init sequence and it take effect
> > only if the lcd is powered.
> > 
> > Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
> > ---
> > 
> > This patch is built on top of:
> > http://userweb.kernel.org/~akpm/mmotm/broken-out/drivers-video-backlight-l4f00242t03c-full-implement-fb-power-states-for-this-lcd.patch
> > 
> >  drivers/video/backlight/l4f00242t03.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/video/backlight/l4f00242t03.c b/drivers/video/backlight/l4f00242t03.c
> > index 5d25743..c04aa90 100644
> > --- a/drivers/video/backlight/l4f00242t03.c
> > +++ b/drivers/video/backlight/l4f00242t03.c
> > @@ -62,6 +62,8 @@ static void l4f00242t03_lcd_init(struct spi_device *spi)
> >  		regulator_enable(priv->core_reg);
> >  	}
> >  
> > +	l4f00242t03_reset(pdata->reset_gpio);
> > +
> >  	gpio_set_value(pdata->data_enable_gpio, 1);
> >  	msleep(60);
> >  	spi_write(spi, (const u8 *)cmd, ARRAY_SIZE(cmd) * sizeof(u16));
> > @@ -225,7 +227,6 @@ static int __devinit l4f00242t03_probe(struct spi_device *spi)
> >  	}
> >  
> >  	/* Init the LCD */
> > -	l4f00242t03_reset(pdata->reset_gpio);
> >  	l4f00242t03_lcd_init(spi);
> >  	priv->lcd_state = FB_BLANK_VSYNC_SUSPEND;
> >  	l4f00242t03_lcd_power_set(priv->ld, FB_BLANK_UNBLANK);
> 
> What were the user-visible effects of the bug which you just fixed?
> 
> Please always include this info when sending a bugfix!  Because without
> that info it's much harder to work out whether we should backport the
> fix into earlier kernels and it's harder for end-users and distro
> maintainers to work out if the patch will fix particular behaviour
> which they or their customers are seeing.
> 

The effect of the bug was that the sequence:
set lcd power_state to FB_BLANK_POWERDOWN
set lcd power_state to FB_BLANK_UNBLANK
Did not produced a complete reboot of the LCD which was showing fuzzy 
colours.

This was not experienced before implementing correctly all the LCD power
states with the patch [1]. Since before the patch [1] the regulators
were not touched and the LCD shutdown was reached with a register 
write. After the patch [1] a complete boot sequence with an initial 
reset is needed for the display every time the LCD is powered up.

drivers-video-backlight-l4f00242t03c-full-implement-fb-power-states-for-this-lcd.patch

Best Regards,
-- 
Alberto!

        Be Persistent!
                - Greg Kroah-Hartman (FOSDEM 2010)

