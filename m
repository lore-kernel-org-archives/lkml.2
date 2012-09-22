Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434Ab2IVNd0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 09:33:26 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38361 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab2IVNdY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 09:33:24 -0400
MIME-Version: 1.0
In-Reply-To: <CAK=WgbYMjeGb7X9V7G-27iL=p4PhAL+CFsJxAo=F7LJ+2c0fCg@mail.gmail.com>
References: <1348158776-23858-1-git-send-email-sjur.brandeland@stericsson.com>
	<CAK=WgbZbuf6PYkT4vcpP4VAejT8mN4CO3PFB9Ng-74Q=4iKTrQ@mail.gmail.com>
	<CAJK669YswMUghd6nMA+nnuWsMZps4zNoLP0-6fD29Pa3+CzX-g@mail.gmail.com>
	<CAK=WgbYMjeGb7X9V7G-27iL=p4PhAL+CFsJxAo=F7LJ+2c0fCg@mail.gmail.com>
Date: Sat, 22 Sep 2012 15:33:23 +0200
Message-ID: <CAJK669Z3YSW85wMXK7if3X8Zb9i1+v_Z2d-UZ1oueYRG4oCDNQ@mail.gmail.com>
Subject: Re: [PATCHv4] remoteproc: Add STE modem driver for remoteproc
From: =?UTF-8?Q?Sjur_Br=C3=A6ndeland?= <sjurbren@gmail.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

>>> It might be safer though to invoke ->setup() in probe/remove, instead
>>> of in start/stop (just like you essentially did before).
>>>
>>> This way we don't assume that stop is always called before remove (as
>>> assumption that might be implicitly valid today, but may break in the
>>> future).
>>>
>>> If you want, I can just change that before applying.
>>
>> Sounds good, please just go ahead and change this before applying.
>> Thank you.
>
> I'm going to squash the below into the patch - please ack before I
> apply and push - thanks!

Looks good, thanks.

Acked-by: Sjur Brændeland <sjur.brandeland@stericsson.om>

>
> diff --git a/drivers/remoteproc/ste_modem_rproc.c
> b/drivers/remoteproc/ste_modem_rproc.c
> index fcc8677..a7743c0 100644
> --- a/drivers/remoteproc/ste_modem_rproc.c
> +++ b/drivers/remoteproc/ste_modem_rproc.c
> @@ -190,9 +190,6 @@ static int sproc_start(struct rproc *rproc)
>
>         sproc_dbg(sproc, "start ste-modem\n");
>
> -       /* Provide callback functions to modem device */
> -       sproc->mdev->ops.setup(sproc->mdev, &sproc_dev_cb);
> -
>         /* Sanity test the max_notifyid */
>         if (rproc->max_notifyid > SPROC_MAX_NOTIFY_ID) {
>                 sproc_err(sproc, "Notification IDs too high:%d\n",
> @@ -220,9 +217,6 @@ static int sproc_stop(struct rproc *rproc)
>         struct sproc *sproc = rproc->priv;
>         sproc_dbg(sproc, "stop ste-modem\n");
>
> -       /* Reset device callback functions */
> -       sproc->mdev->ops.setup(sproc->mdev, NULL);
> -
>         return sproc->mdev->ops.power(sproc->mdev, false);
>  }
>
> @@ -241,6 +235,9 @@ static int sproc_drv_remove(struct platform_device *pdev)
>
>         sproc_dbg(sproc, "remove ste-modem\n");
>
> +       /* Reset device callback functions */
> +       sproc->mdev->ops.setup(sproc->mdev, NULL);
> +
>         /* Unregister as remoteproc device */
>         rproc_del(sproc->rproc);
>         rproc_put(sproc->rproc);
> @@ -260,6 +257,13 @@ static int sproc_probe(struct platform_device *pdev)
>         int err;
>
>         dev_dbg(&mdev->pdev.dev, "probe ste-modem\n");
> +
> +       if (!mdev->ops.setup || !mdev->ops.kick || !mdev->ops.kick_subscribe ||
> +           !mdev->ops.power) {
> +               dev_err(&mdev->pdev.dev, "invalid mdev ops\n");
> +               return -EINVAL;
> +       }
> +
>         rproc = rproc_alloc(&mdev->pdev.dev, mdev->pdev.name, &sproc_ops,
>                             SPROC_MODEM_FIRMWARE, sizeof(*sproc));
>         if (!rproc)
> @@ -270,6 +274,9 @@ static int sproc_probe(struct platform_device *pdev)
>         sproc->rproc = rproc;
>         mdev->drv_data = sproc;
>
> +       /* Provide callback functions to modem device */
> +       sproc->mdev->ops.setup(sproc->mdev, &sproc_dev_cb);
> +
>         /* Set the STE-modem specific firmware handler */
>         rproc->fw_ops = &sproc_fw_ops;
