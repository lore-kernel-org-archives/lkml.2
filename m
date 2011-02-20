Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab1BTRyV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 12:54:21 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53469 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab1BTRyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 12:54:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=cBuMe4Le/VQIMXu04EPFlAe2BcCZiR/XrEeZT9moG4qfUdhnYtCvLX5DtiPKlcN2cq
         f6YqwF32shiMhy0/G4nGVUgwmJirM6VUsRa+SfrkLZvovT0FXe1uFUbu3n9lRibdUu10
         GYgM9uTI9EdMQK4ZDOhNLn5pDBR1w02IlcCdE=
Date: Sun, 20 Feb 2011 20:53:49 +0300
From: Dan Carpenter <error27@gmail.com>
To: Javier Martinez Canillas <martinez.javier@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Randy Dunlap <randy.dunlap@oracle.com>, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnaud Patard <apatard@mandriva.com>
Subject: Re: [PATCH 1/2] Staging: xgifb: Remove CRIT[FLAGS | BEGIN | END]
 defines usage
Message-ID: <20110220175349.GD1898@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Javier Martinez Canillas <martinez.javier@gmail.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Randy Dunlap <randy.dunlap@oracle.com>, devel@driverdev.osuosl.org,
	kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
	Arnaud Patard <apatard@mandriva.com>
References: <1298220798-2942-1-git-send-email-martinez.javier@gmail.com>
 <1298220798-2942-2-git-send-email-martinez.javier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298220798-2942-2-git-send-email-martinez.javier@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Javier,

Your idea was good but there are a couple problems with this patch.  I'm
afraid you're going to need to fix it and resend.

You put the patch description in the 0/2 patch.  It was a pretty decent
patch description.  Unfortunately the 0/2 descriptions get thrown away,
and do not get included in the final git log.  So they should go with
the individual patches.

On Sun, Feb 20, 2011 at 05:53:17PM +0100, Javier Martinez Canillas wrote:
>  int fbcon_XGI_sync(struct fb_info *info)
>  {
> -    if(!XGIfb_accel) return 0;
> -    CRITFLAGS
> +	unsigned long critflags = 0;

It's better to just call it "flags" instead of "critflags" so that it's
consistent with the rest of the kernel.

It's also not a good idea to initialize it to zero.  I know that gcc
prints a warning, but you can't just set it to zero to silence the
warning. Also this change should have been mentioned in the patch
description.  Every behavior change should be described in the change
log.

>  
> -    XGI310Sync();
> +	if (!XGIfb_accel)
> +		return 0;
> +
> +	XGI310Sync();
>  
> -   CRITEND
> -   return 0;
> +	spin_unlock_irqrestore(&xgi_video_info.lockaccel, critflags);

I know you didn't introduce it, but this makes no sense at all.  It's a
random unlock, and in the original code critflags was uninitialized.

The only reason this works is because XGIfb_accel is always 0.  So you 
can remove this function, and remove all the code that depends on
XGIfb_accel.  (In a separate patch of course).

regards,
dan carpenter


