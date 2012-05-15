Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966896Ab2EOVPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 17:15:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36513 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932848Ab2EOVPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 17:15:21 -0400
Date: Tue, 15 May 2012 14:15:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Matthew Garrett'" <mjg@redhat.com>
Subject: Re: [PATCH 2/7] backlight: apple_bl: use pr_debug/err instead of
 printk
Message-Id: <20120515141519.594da6d9.akpm@linux-foundation.org>
In-Reply-To: <000d01cd326f$b9d5d610$2d818230$%han@samsung.com>
References: <000d01cd326f$b9d5d610$2d818230$%han@samsung.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2012 16:52:50 +0900
Jingoo Han <jg1.han@samsung.com> wrote:

> This patch uses pr_debug/err instead of printk to allow dynamic debugging.
> It also fixes checkpatch warnings as below:
> 
> WARNING: Prefer pr_debug(... to printk(KERN_DEBUG, ...
> WARNING: Prefer pr_err(... to printk(KERN_ERR, ...
> 
> ...
>
> --- a/drivers/video/backlight/apple_bl.c
> +++ b/drivers/video/backlight/apple_bl.c
> @@ -61,8 +61,7 @@ static int intel_chipset_send_intensity(struct backlight_device *bd)
>  	int intensity = bd->props.brightness;
>  
>  	if (debug)
> -		printk(KERN_DEBUG DRIVER "setting brightness to %d\n",
> -		       intensity);
> +		pr_debug("setting brightness to %d\n", intensity);

This looks wrong.  It replaces

	apple_backlight: setting brightness to 42

with

	setting brightness to 42

To do this properly we should do

#define pf_fmt "apple_backlight: "

before including printk.h.  Conventionally this is done before
including any headers.

Also, apple_bl.c should explicitly include printk.h.

If doing this, please remove the DRIVER #define altogether.



Please check all the other drivers in this patchset.  If they already
have custom things like DRIVER then remove that, define pr_fmt then
convert all the messages.

In other words, I'm recommending a functional change.  For example,
drivers/video/backlight/generic_bl.c currently prints

	Generic Backlight Driver Initialized

and I'm recommending that we switch this to

	generic_bl: Generic Backlight Driver Initialized



