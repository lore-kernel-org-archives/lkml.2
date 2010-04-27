Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab0D0URJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 16:17:09 -0400
Received: from legolas.restena.lu ([158.64.1.34]:50057 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab0D0URG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 16:17:06 -0400
Date: Tue, 27 Apr 2010 22:16:48 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Oliver Neukum <oliver@neukum.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, Nicu Pavel <npavel@ituner.com>,
       Jaya Kumar <jayakumar.lkml@gmail.com>,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>
Subject: Re: [PATCH 2/2] hid: add PM support to PicoLCD device
Message-ID: <20100427221648.39735c41@neptune.home>
In-Reply-To: <alpine.LNX.2.00.1004271525330.9849@pobox.suse.cz>
References: <20100425214003.7e87c6a3@neptune.home>
	<20100425214306.5d7be049@neptune.home>
	<alpine.LNX.2.00.1004271525330.9849@pobox.suse.cz>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 April 2010 Jiri Kosina <jkosina@suse.cz> wrote:
> On Sun, 25 Apr 2010, Bruno Prémont wrote:
> 
> > Add PM support in order to turn off backlight on suspend, restore
> > it on resume and especially restore complete state on reset-resume.
> > 
> > Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
> > ---
> >  drivers/hid/hid-picolcd.c |   61 +++++++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 61 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/hid/hid-picolcd.c b/drivers/hid/hid-picolcd.c
> > index aa6f2e1..c652390 100644
> > --- a/drivers/hid/hid-picolcd.c
> > +++ b/drivers/hid/hid-picolcd.c
> > @@ -852,6 +852,20 @@ static inline int picolcd_resume_backlight(struct picolcd_data *data)
> >  	return picolcd_set_brightness(data->backlight);
> >  }
> >  
> > +#ifdef CONFIG_PM
> > +static void picolcd_suspend_backlight(struct picolcd_data *data)
> > +{
> > +	int bl_power = data->lcd_power;
> > +	if (!data->backlight)
> > +		return;
> > +
> > +	data->backlight->props.power = FB_BLANK_POWERDOWN;
> > +	picolcd_set_brightness(data->backlight);
> > +	data->lcd_power = data->backlight->props.power = bl_power;
> > +}
> > +#else
> > +#define picolcd_suspend_backlight(a)
> > +#endif /* CONFIG_PM */
> 
> Stylistic thing -- it would be nice if this was actually 
> 
> static inline void picolcd_suspend_backlight(struct picolcd_data *data)
> {
> 	return 0;
> }
> 
> But why do you need to have it defined in !CONFIG_PM situation anyway? 
> It's not used otherwise at all.

Yeah, I could drop the #else branch (of #ifconfig CONFIG_PM).

Is gcc quiet about defined but unused static inline functions?
It's in order to avoid those warnings that I used #define bla().
(same in other occasions of stubs returning void.

Might be I forgot the inline keyword for the case I got the warning
about defined but unused function. Will check tomorrow.

> >  #else
> >  static inline int picolcd_init_backlight(struct picolcd_data *data,
> >  		struct hid_report *report)
> > @@ -865,6 +879,7 @@ static inline int picolcd_resume_backlight(struct picolcd_data *data)
> >  {
> >  	return 0;
> >  }
> > +#define picolcd_suspend_backlight(a)
> 
> Any why is it defined once more here?

Thats in the case where CONFIG_HID_PICOLCD_BACKLIGHT is not defined.
c.f. the #else at the beginning of this quote.


Thanks,
Bruno
