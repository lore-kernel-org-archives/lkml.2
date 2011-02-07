Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989Ab1BGMwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 07:52:14 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:41713 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab1BGMwN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 07:52:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jmH0FWRKmopb8J3zPbUWTamwLQvsse7ehqkk9IPQ1fHsoJNo+q6oFM3thAzsLqKqkM
         GDjjk9lzEUg5FO6BvdK7fhNHl5P64RoA1UXR8cjxNAZoymgic6EfaxGjKYJIu2mG+Nno
         C6Pg2T9oP+ek/a4yjwq4DeGantNiJLxVs+voc=
MIME-Version: 1.0
In-Reply-To: <20110207074017.GA25749@core.coreip.homeip.net>
References: <AANLkTi=vBv_a+X3MrgyDevss9H92vBJ51eON_qyMJW4=@mail.gmail.com>
	<20110206165524.GG22170@cathedrallabs.org>
	<AANLkTimZq3-zuiA940dK7AmszBW-TEHP0JHz7FGHSmgu@mail.gmail.com>
	<20110206172317.GI22170@cathedrallabs.org>
	<20110207074017.GA25749@core.coreip.homeip.net>
Date: Mon, 7 Feb 2011 13:52:12 +0100
Message-ID: <AANLkTikdLn3tBxYjSiWjnhv1L9duUNkpQBrAk5L9PafZ@mail.gmail.com>
Subject: Re: [PATCH] uinput strnlen bugfix
From: David Herrmann <dh.herrmann@googlemail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Aristeu Rozanski <aris@cathedrallabs.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
>  drivers/input/misc/uinput.c |   13 ++++++-------
>  1 files changed, 6 insertions(+), 7 deletions(-)
>
>
> diff --git a/drivers/input/misc/uinput.c b/drivers/input/misc/uinput.c
> index 82542a1..c0888e3 100644
> --- a/drivers/input/misc/uinput.c
> +++ b/drivers/input/misc/uinput.c
> @@ -347,8 +347,7 @@ static int uinput_setup_device(struct uinput_device *udev, const char __user *bu
>  {
>        struct uinput_user_dev  *user_dev;
>        struct input_dev        *dev;
> -       char                    *name;
> -       int                     i, size;
> +       int                     i;
>        int                     retval;
>
>        if (count != sizeof(struct uinput_user_dev))
> @@ -373,19 +372,19 @@ static int uinput_setup_device(struct uinput_device *udev, const char __user *bu
>
>        udev->ff_effects_max = user_dev->ff_effects_max;
>
> -       size = strnlen(user_dev->name, UINPUT_MAX_NAME_SIZE) + 1;
> -       if (!size) {
> +       /* Ensure name is filled in */
> +       if (!user_dev->name[0]) {
>                retval = -EINVAL;
>                goto exit;
>        }
>
>        kfree(dev->name);
> -       dev->name = name = kmalloc(size, GFP_KERNEL);
> -       if (!name) {
> +       dev->name = kstrndup(user_dev->name, UINPUT_MAX_NAME_SIZE,
> +                            GFP_KERNEL);
> +       if (!dev->name) {
>                retval = -ENOMEM;
>                goto exit;
>        }
> -       strlcpy(name, user_dev->name, size);
>
>        dev->id.bustype = user_dev->id.bustype;
>        dev->id.vendor  = user_dev->id.vendor;
>

This is definitely a better solution, yes. Thank you.
Signed-off-by: David Herrmann <dh.herrmann@gmail.com>

David
