Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506Ab1BGNZi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 08:25:38 -0500
Received: from lobo.ruivo.org ([173.14.175.98]:38292 "EHLO lobo.ruivo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191Ab1BGNZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 08:25:37 -0500
Date: Mon, 7 Feb 2011 08:25:18 -0500
From: Aristeu Rozanski <aris@cathedrallabs.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: David Herrmann <dh.herrmann@googlemail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uinput strnlen bugfix
Message-ID: <20110207132518.GJ22170@cathedrallabs.org>
References: <AANLkTi=vBv_a+X3MrgyDevss9H92vBJ51eON_qyMJW4=@mail.gmail.com>
 <20110206165524.GG22170@cathedrallabs.org>
 <AANLkTimZq3-zuiA940dK7AmszBW-TEHP0JHz7FGHSmgu@mail.gmail.com>
 <20110206172317.GI22170@cathedrallabs.org>
 <20110207074017.GA25749@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110207074017.GA25749@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 06, 2011 at 11:40:17PM -0800, Dmitry Torokhov wrote:
> Hmm, not particularly fond with the construct, how about below instead?
> 
> Btw, having "Signed-off-by: " from David would be nice.
> 
> Thanks.
> 
> -- 
> Dmitry
> 
> Input: uinput - fix setting up device name
> 
> From: David Herrmann <dh.herrmann@googlemail.com>
> 
> The check for non-empty device name was botched since we tried to account
> for extra space for the terminating zero at the same time. Convert to
> kstrndup() to avoid this problem.
> 
> Acked-by: Aristeu Rozanski <aris@ruivo.org>
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> ---
> 
>  drivers/input/misc/uinput.c |   13 ++++++-------
>  1 files changed, 6 insertions(+), 7 deletions(-)
> 
> 
> diff --git a/drivers/input/misc/uinput.c b/drivers/input/misc/uinput.c
> index 82542a1..c0888e3 100644
> --- a/drivers/input/misc/uinput.c
> +++ b/drivers/input/misc/uinput.c
> @@ -347,8 +347,7 @@ static int uinput_setup_device(struct uinput_device *udev, const char __user *bu
>  {
>  	struct uinput_user_dev	*user_dev;
>  	struct input_dev	*dev;
> -	char			*name;
> -	int			i, size;
> +	int			i;
>  	int			retval;
>  
>  	if (count != sizeof(struct uinput_user_dev))
> @@ -373,19 +372,19 @@ static int uinput_setup_device(struct uinput_device *udev, const char __user *bu
>  
>  	udev->ff_effects_max = user_dev->ff_effects_max;
>  
> -	size = strnlen(user_dev->name, UINPUT_MAX_NAME_SIZE) + 1;
> -	if (!size) {
> +	/* Ensure name is filled in */
> +	if (!user_dev->name[0]) {
>  		retval = -EINVAL;
>  		goto exit;
>  	}
>  
>  	kfree(dev->name);
> -	dev->name = name = kmalloc(size, GFP_KERNEL);
> -	if (!name) {
> +	dev->name = kstrndup(user_dev->name, UINPUT_MAX_NAME_SIZE,
> +			     GFP_KERNEL);
> +	if (!dev->name) {
>  		retval = -ENOMEM;
>  		goto exit;
>  	}
> -	strlcpy(name, user_dev->name, size);
>  
>  	dev->id.bustype	= user_dev->id.bustype;
>  	dev->id.vendor	= user_dev->id.vendor;
even better
ACK

-- 
Aristeu

