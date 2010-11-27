Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205Ab0K0ImC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 03:42:02 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:51843 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab0K0ImA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 03:42:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bFQ3JKXmaDpK5DLh+G/1njlltnyyTiKy0mQYNQtVqYqcmFZFFyMA+xrPVqDKCcurBI
         wHPUCmSX3w9c628IYe0SWo8QGIbijLVI6V5gIrrt3scsSJi3oG4n9ShgyDAqIaqQRcZy
         HUFMVEURXy1blcgSsQggIjs5kp3RBs/0wYEnU=
Date: Sat, 27 Nov 2010 00:41:53 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Duncan Laurie <dlaurie@chromium.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: serio - clear serio event queue after sysfs
 driver rebind
Message-ID: <20101127084153.GC28745@core.coreip.homeip.net>
References: <1290467390-25302-1-git-send-email-dlaurie@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290467390-25302-1-git-send-email-dlaurie@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Duncan,

On Mon, Nov 22, 2010 at 03:09:50PM -0800, Duncan Laurie wrote:
> When rebinding a serio driver via sysfs drvctl interface it is possible for
> an interrupt to trigger after the disconnect of the existing driver and
> before the binding of the new driver.  This will cause the serio interrupt
> handler to queue a rescan event which will disconnect the new driver
> immediately after it is attached.
> 
> This change clears the serio event queue after processing the drvctl
> request but before releasing the serio mutex, which will clear any queued
> rescans before they can get processed.
> 
> Reproduction involves issuing a rebind of device port from psmouse driver
> to serio_raw driver while generating input to trigger interrupts.  Then
> checking to see if the corresponding i8042/serio4/driver is correctly
> attached to the serio_raw driver instead of psmouse.
> 
> Signed-off-by: Duncan Laurie <dlaurie@chromium.org>
> ---
>  drivers/input/serio/serio.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/input/serio/serio.c b/drivers/input/serio/serio.c
> index 405bf21..a66307e 100644
> --- a/drivers/input/serio/serio.c
> +++ b/drivers/input/serio/serio.c
> @@ -454,6 +454,7 @@ static ssize_t serio_rebind_driver(struct device *dev, struct device_attribute *
>  		serio_disconnect_port(serio);
>  		error = serio_bind_driver(serio, to_serio_driver(drv));
>  		put_driver(drv);
> +		serio_remove_pending_events(serio);

Hmm, makes sense, although should we limit events being removed to
rescan events only?

-- 
Dmitry
