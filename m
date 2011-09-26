Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471Ab1IZKhq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 06:37:46 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:54621 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab1IZKho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 06:37:44 -0400
X-AuditID: cbfee61a-b7cf1ae00000208e-7d-4e8055f66a85
From: Inki Dae <inki.dae@samsung.com>
To: "'Lars-Peter Clausen'" <lars@metafoo.de>
Cc: FlorianSchandinat@gmx.de, linux-fbdev@vger.kernel.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com
References: <1315544581-16379-1-git-send-email-inki.dae@samsung.com>
 <4E71E374.2090901@metafoo.de>
In-reply-to: <4E71E374.2090901@metafoo.de>
Subject: RE: [PATCH] FB: add early fb blank feature.
Date: Mon, 26 Sep 2011 19:36:58 +0900
Message-id: <002e01cc7c38$381b0750$a85115f0$%dae@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Content-language: ko
Thread-index: Acxzm+cG4D6EeePoTlq4MiEu7i+xPwIiHIpQ
X-OriginalArrivalTime: 26 Sep 2011 10:38:36.0190 (UTC)
 FILETIME=[72245BE0:01CC7C38]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Lars-Peter Clausen.

Sorry for being late.

> -----Original Message-----
> From: Lars-Peter Clausen [mailto:lars@metafoo.de]
> Sent: Thursday, September 15, 2011 8:37 PM
> To: Inki Dae
> Cc: FlorianSchandinat@gmx.de; linux-fbdev@vger.kernel.org; akpm@linux-
> foundation.org; linux-kernel@vger.kernel.org; kyungmin.park@samsung.com
> Subject: Re: [PATCH] FB: add early fb blank feature.
> 
> Hi
> 
> I have a LCD panel with an similar issue, and I think the idea to
> introduce a
> early fb blank event is the right solution. I have some comments and
> questions
> on this particular implementation though.
> 
> On 09/09/2011 07:03 AM, Inki Dae wrote:
> > this patch adds early fb blank feature that this is a callback of
> > lcd panel driver would be called prior to fb driver's one.
> > in case of MIPI-DSI based video mode LCD Panel, for lcd power off,
> > the power off commands should be transferred to lcd panel with display
> > and mipi-dsi controller enabled because the commands is set to lcd panel
> > at vsync porch period. on the other hand, in opposite case, the callback
> > of fb driver should be called prior to lcd panel driver's one because of
> > same issue. now we could handle call order to fb blank properly.
> >
> > the order is as the following:
> >
> > at fb_blank function of fbmem.c
> >   -> fb_early_notifier_call_chain()
> >      -> lcd panel driver's early_set_power()
> >   -> info->fbops->fb_blank()
> >      -> fb driver's fb_blank()
> >   -> fb_notifier_call_chain()
> >      -> lcd panel driver's set_power()
> >
> 
> I wonder if we really need the lcd_ops early_set_power callback. I can't
> really
> imagine a situation where you need to power the LCD down only after the
> LCD
> controller has been shutdown.
> 

if fb_blank mode is changed to FB_BLANK_POWERDOWN then display controller
would be off(clock disable). On the other hand, lcd panel would be still on.
at this time, you could see some issue like sparkling on lcd panel because
video clock to be delivered to ldi module of lcd panel was disabled.

> So I wonder if we couldn't just have the set_power callback, but listen to
> both
> events and call set_power for early blank events with code !=
> FB_BLANK_UNBLANK
> and for normal blank events with code == FB_BLANK_UNBLANK?
> 

with this feaure, if a event is FB_BLANK_POWERDOWN then early_set_power()
callback would be called for lcd panel to be off and if FB_BLANK_UNBLANK or
FB_BLANK_NORMAL then set_power() callback would be called for lcd panel to
be on.

> > note that early fb blank mode is valid only if lcd_ops->early_blank_mode
> is 1.
> > if the value is 0 then early fb blank callback would be ignored.
> >
> > this patch is based on git repository below:
> > git://github.com/schandinat/linux-2.6.git
> > branch: fbdev-next
> > commit-id: a67472ad1ae040f073e45048cbc5a01195f2e3f5
> >
> > Signed-off-by: Inki Dae <inki.dae@samsung.com>
> > Signed-off-by: KyungMin Park <kyungmin.park@samsung.com>
> > ---
> >  drivers/video/backlight/lcd.c |   77
> ++++++++++++++++++++++++++++++++++++++--
> >  drivers/video/fb_notify.c     |   31 ++++++++++++++++
> >  drivers/video/fbmem.c         |   25 +++++++------
> >  include/linux/fb.h            |    4 ++
> >  include/linux/lcd.h           |   61 ++++++++++++++++++++++++--------
> 
> In my opinion this should be split into two patches, one adding the early
> blank
> event, one adding support for it to the LCD framework.
> 

You are right. this patch should be split into two patches. Thank you.

> >  5 files changed, 167 insertions(+), 31 deletions(-)
> >
> > [...]
> > diff --git a/drivers/video/fb_notify.c b/drivers/video/fb_notify.c
> > index 8c02038..3930c7c 100644
> > --- a/drivers/video/fb_notify.c
> > +++ b/drivers/video/fb_notify.c
> > @@ -13,9 +13,20 @@
> >  #include <linux/fb.h>
> >  #include <linux/notifier.h>
> >
> > +static BLOCKING_NOTIFIER_HEAD(fb_early_notifier_list);
> >  static BLOCKING_NOTIFIER_HEAD(fb_notifier_list);
> >
> >  /**
> > + *	fb_register_early_client - register a client early notifier
> > + *	@nb: notifier block to callback on events
> > + */
> > +int fb_register_early_client(struct notifier_block *nb)
> > +{
> > +	return blocking_notifier_chain_register(&fb_early_notifier_list,
> nb);
> > +}
> > +EXPORT_SYMBOL(fb_register_early_client);
> > +
> 
> Why do we need a new notifier chain? Can't we introduce a new event for
> the
> existing chain?
> 

Suppose that we have only fb_notifier_list. Once lcd_device_register() is
called by lcd panel driver, existing two notifiers would be added
fb_notifier_list and when fb_blank is called by user process, some callback
registered to the fb_notifier_list would be called two times, one is
set_power() and another one is early_set_power(). as you know, this is not
the thing we want. If there is any missing point, please give me your
comment.


> > +/**
> >   *	fb_register_client - register a client notifier
> >   *	@nb: notifier block to callback on events
> >   */
> > @@ -26,6 +37,16 @@ int fb_register_client(struct notifier_block *nb)
> >  EXPORT_SYMBOL(fb_register_client);
> >
> >  /**
> > + *	fb_unregister_early_client - unregister a client early notifier
> > + *	@nb: notifier block to callback on events
> > + */
> > +int fb_unregister_early_client(struct notifier_block *nb)
> > +{
> > +	return blocking_notifier_chain_unregister(&fb_early_notifier_list,
> nb);
> > +}
> > +EXPORT_SYMBOL(fb_unregister_early_client);
> > +
> > +/**
> >   *	fb_unregister_client - unregister a client notifier
> >   *	@nb: notifier block to callback on events
> >   */
> > @@ -36,6 +57,16 @@ int fb_unregister_client(struct notifier_block *nb)
> >  EXPORT_SYMBOL(fb_unregister_client);
> >
> >  /**
> > + * fb_early_notifier_call_chain - early notify clients of fb_events
> > + *
> > + */
> > +int fb_early_notifier_call_chain(unsigned long val, void *v)
> > +{
> > +	return blocking_notifier_call_chain(&fb_early_notifier_list, val,
> v);
> > +}
> > +EXPORT_SYMBOL_GPL(fb_early_notifier_call_chain);
> > +
> > +/**
> >   * fb_notifier_call_chain - notify clients of fb_events
> >   *
> >   */
> > diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
> > index ad93629..cf22516 100644
> > --- a/drivers/video/fbmem.c
> > +++ b/drivers/video/fbmem.c
> > @@ -1031,24 +1031,25 @@ fb_set_var(struct fb_info *info, struct
> fb_var_screeninfo *var)
> >
> >  int
> >  fb_blank(struct fb_info *info, int blank)
> > -{
> > - 	int ret = -EINVAL;
> > +{
> > +	struct fb_event event;
> > +	int ret = -EINVAL;
> >
> > - 	if (blank > FB_BLANK_POWERDOWN)
> > - 		blank = FB_BLANK_POWERDOWN;
> > +	if (blank > FB_BLANK_POWERDOWN)
> > +		blank = FB_BLANK_POWERDOWN;
> >
> > -	if (info->fbops->fb_blank)
> > - 		ret = info->fbops->fb_blank(blank, info);
> > +	event.info = info;
> > +	event.data = &blank;
> >
> > - 	if (!ret) {
> > -		struct fb_event event;
> > +	fb_early_notifier_call_chain(FB_EVENT_BLANK, &event);
> >
> > -		event.info = info;
> > -		event.data = &blank;
> > +	if (info->fbops->fb_blank)
> > +		ret = info->fbops->fb_blank(blank, info);
> 
> I think we have to handle the case where the fb_blank callback fails and
> should
> somehow revert the effects of the early blank event.
> 

You are right. it should be reverted with fail. thank you.

> 
> > +
> > +	if (!ret)
> >  		fb_notifier_call_chain(FB_EVENT_BLANK, &event);
> > -	}
> >
> 
> 
> 
> > - 	return ret;
> > +	return ret;
> >  }
> >
> >  static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
> > diff --git a/include/linux/fb.h b/include/linux/fb.h
> > index 1d6836c..1d7d995 100644
> > --- a/include/linux/fb.h
> > +++ b/include/linux/fb.h
> > @@ -562,6 +562,10 @@ struct fb_blit_caps {
> >  	u32 flags;
> >  };
> >
> > +extern int fb_register_early_client(struct notifier_block *nb);
> > +extern int fb_unregister_early_client(struct notifier_block *nb);
> > +extern int fb_early_notifier_call_chain(unsigned long val, void *v);
> > +
> >  extern int fb_register_client(struct notifier_block *nb);
> >  extern int fb_unregister_client(struct notifier_block *nb);
> >  extern int fb_notifier_call_chain(unsigned long val, void *v);
> > diff --git a/include/linux/lcd.h b/include/linux/lcd.h
> > index 8877123..930d1cc 100644
> > --- a/include/linux/lcd.h
> > +++ b/include/linux/lcd.h
> > @@ -37,10 +37,21 @@ struct lcd_properties {
> >  };
> >
> >  struct lcd_ops {
> > -	/* Get the LCD panel power status (0: full on, 1..3: controller
> > -	   power on, flat panel power off, 4: full off), see FB_BLANK_XXX */
> > +	/*
> > +	 * Get the LCD panel power status (0: full on, 1..3: controller
> > +	 * power on, flat panel power off, 4: full off), see FB_BLANK_XXX
> > +	 */
> >  	int (*get_power)(struct lcd_device *);
> > -	/* Enable or disable power to the LCD (0: on; 4: off, see
> FB_BLANK_XXX) */
> > +	/*
> > +	 * Get the current contrast setting (0-max_contrast) and
> 
> ???
> 

Ah, I missed it. this is a comment wrong so I will remove it. thank you.

> > +	 * Enable or disable power to the LCD (0: on; 4: off, see
> FB_BLANK_XXX)
> > +	 * this callback would be called proir to fb driver's fb_blank
> callback.
> > +	 */
> > +	int (*early_set_power)(struct lcd_device *, int power);
> > +	/*
> > +	 * Get the current contrast setting (0-max_contrast)
> > +	 * Enable or disable power to the LCD (0: on; 4: off, see
> FB_BLANK_XXX)
> > +	 */
> >  	int (*set_power)(struct lcd_device *, int power);
> >  	/* Get the current contrast setting (0-max_contrast) */
> >  	int (*get_contrast)(struct lcd_device *);
> > @@ -48,21 +59,35 @@ struct lcd_ops {
> >          int (*set_contrast)(struct lcd_device *, int contrast);
> >  	/* Set LCD panel mode (resolutions ...) */
> >  	int (*set_mode)(struct lcd_device *, struct fb_videomode *);
> > -	/* Check if given framebuffer device is the one LCD is bound to;
> > -	   return 0 if not, !=0 if it is. If NULL, lcd always matches the
fb.
> */
> > +	/*
> > +	 * Check if given framebuffer device is the one LCD is bound to;
> > +	 * return 0 if not, !=0 if it is. If NULL, lcd always matches the
> fb.
> > +	 */
> >  	int (*check_fb)(struct lcd_device *, struct fb_info *);
> > +
> > +	/*
> > +	 * indicate whether enabling early blank mode or not.
> > +	 * (0: disable; 1: enable);
> > +	 * if enabled, lcd blank callback would be called prior
> > +	 * to fb blank callback.
> > +	 */
> > +	unsigned int early_blank_mode;
> 
> I think it should be sufficient to check early_set_power for NULL instead
> of
> adding this additional flag.
> 

You are right. I will modify it. thank you.

> >  };
> >
> >  struct lcd_device {
> >  	struct lcd_properties props;
> > -	/* This protects the 'ops' field. If 'ops' is NULL, the driver that
> > -	   registered this device has been unloaded, and if
> class_get_devdata()
> > -	   points to something in the body of that driver, it is also
> invalid. */
> > +	/*
> > +	 * This protects the 'ops' field. If 'ops' is NULL, the driver that
> > +	 * registered this device has been unloaded, and if
> class_get_devdata()
> > +	 * points to something in the body of that driver, it is also
> invalid.
> > +	 */
> >  	struct mutex ops_lock;
> >  	/* If this is NULL, the backing module is unloaded */
> >  	struct lcd_ops *ops;
> >  	/* Serialise access to set_power method */
> >  	struct mutex update_lock;
> > +	/* The framebuffer early notifier block */
> > +	struct notifier_block fb_early_notif;
> >  	/* The framebuffer notifier block */
> >  	struct notifier_block fb_notif;
> >
> > @@ -72,16 +97,22 @@ struct lcd_device {
> >  struct lcd_platform_data {
> >  	/* reset lcd panel device. */
> >  	int (*reset)(struct lcd_device *ld);
> > -	/* on or off to lcd panel. if 'enable' is 0 then
> > -	   lcd power off and 1, lcd power on. */
> > +	/*
> > +	 * on or off to lcd panel. if 'enable' is 0 then
> > +	 * lcd power off and 1, lcd power on.
> > +	 */
> >  	int (*power_on)(struct lcd_device *ld, int enable);
> >
> > -	/* it indicates whether lcd panel was enabled
> > -	   from bootloader or not. */
> > +	/*
> > +	 * it indicates whether lcd panel was enabled
> > +	 * from bootloader or not.
> > +	 */
> >  	int lcd_enabled;
> > -	/* it means delay for stable time when it becomes low to high
> > -	   or high to low that is dependent on whether reset gpio is
> > -	   low active or high active. */
> > +	/*
> > +	 * it means delay for stable time when it becomes low to high
> > +	 * or high to low that is dependent on whether reset gpio is
> > +	 * low active or high active.
> > +	 */
> 
> The formatting cleanup patches should go into a separate patch.

Ok, get it. and I will re-send this patch. thank you again. :)

