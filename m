Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326Ab0DUFkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 01:40:06 -0400
Received: from mail-yx0-f191.google.com ([209.85.210.191]:36750 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab0DUFkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 01:40:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Yg06GnDfn6vhdbhVVEYWmYazBDImKRj5hOsNU5TJtZyolx2PHSWH/5nx1X/1GWbBiI
         4IS46+5rUfH4gmknI68xf/5DDljIn8LJ69/o4HP9h2lJnElaWqGkVqw6IeRk8jdPLRma
         OeQWK6pg4RuQly7MCYnec1oSQFfvsR6Y5DQq4=
Date: Tue, 20 Apr 2010 22:39:58 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: linux-kernel@vger.kernel.org, pingc@wacom.com, Anton@anikin.name,
       stable@kernel.org, stable-commits@vger.kernel.org
Subject: Re: patch input-wacom-switch-mode-upon-system-resume.patch added to
 2.6.33-stable tree
Message-ID: <20100421053958.GB4364@core.coreip.homeip.net>
References: <1271697023113@kroah.org>
 <201004191024.43397.dmitry.torokhov@gmail.com>
 <20100419172856.GA6965@suse.de>
 <4BCE34CC.9030506@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BCE34CC.9030506@canonical.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 04:12:12PM -0700, Stefan Bader wrote:
> Greg KH wrote:
> > On Mon, Apr 19, 2010 at 10:24:41AM -0700, Dmitry Torokhov wrote:
> >> Greg,
> >>
> >> On Monday 19 April 2010 10:10:23 am gregkh@suse.de wrote:
> >>> This is a note to let you know that we have just queued up the patch titled
> >>>
> >>>     Subject: Input: wacom - switch mode upon system resume
> >>>
> >>> to the 2.6.33-stable tree.  Its filename is
> >>>
> >>>     input-wacom-switch-mode-upon-system-resume.patch
> >>>
> >> Could you add this to .32 as well, please?
> > 
> > I looked, and it didn't seem to apply at all.  Can someone backport it
> > to .32 and I will be glad to apply it.
> > 
> 
> That would be my backport for .32, maybe Ping or Dmitry can sanity check.
> 

Yep, that exactly what Ping sent earlier, but since she favors wierd
mailers with HTML I guess her patch was dropped by vger filters ;)

Thanks Stefan.

Greg, please apply.

> Stefan
> 
> > thanks,
> > 
> > greg k-h
> > --
> > To unsubscribe from this list: send the line "unsubscribe stable-commits" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

> From 7021bbc3685fc147eb47deee345801ffb007a7e9 Mon Sep 17 00:00:00 2001
> From: Ping Cheng <pingc@wacom.com>
> Date: Tue, 13 Apr 2010 23:07:52 -0700
> Subject: [PATCH] Input: wacom - switch mode upon system resume
> 
> commit 014f61504af276ba9d9544d8a7401d8f8526eb73 upstream
> 
> When Wacom devices wake up from a sleep, the switch mode command
> (wacom_query_tablet_data) is needed before wacom_open is called.
> wacom_query_tablet_data should not be executed inside wacom_open
> since wacom_open is called more than once during probe.
> 
> wacom_retrieve_hid_descriptor is removed from wacom_resume due
> to the fact that the required descriptors are stored properly
> upon system resume.
> 
> Reported-and-tested-by: Anton Anikin <Anton@Anikin.name>
> Signed-off-by: Ping Cheng <pingc@wacom.com>
> Cc: stable@kernel.org
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
> ---
>  drivers/input/tablet/wacom_sys.c |   10 +++++++---
>  1 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
> index b5b69cc..5be07f9 100644
> --- a/drivers/input/tablet/wacom_sys.c
> +++ b/drivers/input/tablet/wacom_sys.c
> @@ -562,11 +562,15 @@ static int wacom_resume(struct usb_interface *intf)
>  	int rv;
>  
>  	mutex_lock(&wacom->lock);
> -	if (wacom->open) {
> +
> +	/* switch to wacom mode first */
> +	wacom_query_tablet_data(intf, features);
> +
> +	if (wacom->open)
>  		rv = usb_submit_urb(wacom->irq, GFP_NOIO);
> -		wacom_query_tablet_data(intf);
> -	} else
> +	else
>  		rv = 0;
> +
>  	mutex_unlock(&wacom->lock);
>  
>  	return rv;
> -- 
> 1.6.3.3
> 


-- 
Dmitry
