Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732Ab0KRSGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 13:06:35 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46913 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932443Ab0KRSGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 13:06:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rTBqMpEXRZMB4PLNBMW9wHf7W0TEguMwkpKM6Pywplhed6Kgj2J3Bo3PUSeE+SXTD2
         S2NBf+krTgPKIIWgRGgdDWp7sqco9qJffgEBlevFM9C/m6PFjyZrQ1dejWMNUhPmaxUA
         TBI2jPtRJUhhPdIQxdt2tF1NZfE/t3tbfNxwI=
Date: Thu, 18 Nov 2010 10:06:24 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mattia Dongili <malattia@linux.it>
Cc: Norbert Preining <preining@logic.at>, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-input@vger.kernel.org
Subject: Re: regression since 2.6.36: backlight in sony-laptop not working
Message-ID: <20101118180624.GA574@core.coreip.homeip.net>
References: <20101111235000.GA6651@gamma.logic.tuwien.ac.at>
 <20101112034423.GA7407@srcf.ucam.org>
 <20101112035027.GD26742@gamma.logic.tuwien.ac.at>
 <20101112035732.GB7574@srcf.ucam.org>
 <20101112042243.GE2852@kamineko.org>
 <20101117063006.GF29129@gamma.logic.tuwien.ac.at>
 <20101117063338.GG29129@gamma.logic.tuwien.ac.at>
 <20101117065252.GA7046@core.coreip.homeip.net>
 <20101118110445.GB4107@kamineko.org>
 <20101118133420.GA3177@kamineko.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101118133420.GA3177@kamineko.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 10:34:20PM +0900, Mattia Dongili wrote:
> On Thu, Nov 18, 2010 at 08:04:45PM +0900, Mattia Dongili wrote:
> > On Tue, Nov 16, 2010 at 10:52:52PM -0800, Dmitry Torokhov wrote:
> > > On Wed, Nov 17, 2010 at 03:33:38PM +0900, Norbert Preining wrote:
> > > > > - recompiled a input-kbd binary with a relaxed version check
> > > > > 	-	if (EV_VERSION != version) {
> > > > > 	+	if (EV_VERSION > version) {
> > > > >   in input.c, line 104 of input-utils.
> > > > 
> > > > Furthermore, although both of you referred to the fact that udev keymap
> > > > is working, I checked that Debian/sid uses udev kbd rules, but it 
> > > > stopped working ...
> > > > 
> > > 
> > > Seems to be working here (I also verified that the keycodces are
> > > actually emitted with evtest):
> > > 
> > > [root@dtor-d630 ~]# /lib/udev/keymap /dev/input/event3 0x87 wlan
> > > setting scancode 0x87 to key code 238
> > > [root@dtor-d630 ~]# /lib/udev/keymap /dev/input/event3 0x87 battery
> > > setting scancode 0x87 to key code 236
> > > [root@dtor-d630 ~]# uname -r
> > > 2.6.37-rc1+
> > > [root@dtor-d630 ~]# 
> > 
> > ok I got the error. I'll see why the EVIOCSKEYCODE syscall is returning
> > -EINVAL.
> 
> there is a typo in the large scancode support patch. This patch makes 
> /lib/udev/keymap work again here on 2.6.37-rc2.
> 

Applied, thanks Mattia.

> commit a33950b5baa848ff7851b9efd4c5e2eaafd370f2
> Author: Mattia Dongili <malattia@linux.it>
> Date:   Thu Nov 18 22:20:36 2010 +0900
> 
>     Input: fix typo in keycode validation supporting large scancodes
>     
>     Check the input_keymap_entry keycode size (u32) instead of the device's
>     (void*).
>     Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=22722
>     
>     Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
>     Cc: Dmitry Torokhov <dtor@mail.ru>
>     Signed-off-by: Mattia Dongili <malattia@linux.it>
> 
> diff --git a/drivers/input/input.c b/drivers/input/input.c
> index 7f26ca6..5edc41a 100644
> --- a/drivers/input/input.c
> +++ b/drivers/input/input.c
> @@ -753,7 +753,7 @@ static int input_default_setkeycode(struct input_dev *dev,
>  	if (index >= dev->keycodemax)
>  		return -EINVAL;
>  
> -	if (dev->keycodesize < sizeof(dev->keycode) &&
> +	if (dev->keycodesize < sizeof(ke->keycode) &&
>  			(ke->keycode >> (dev->keycodesize * 8)))
>  		return -EINVAL;
>  
> -- 
> mattia
> :wq!

-- 
Dmitry
