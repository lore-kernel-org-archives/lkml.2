Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956Ab2KWIl6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 03:41:58 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:40236 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662Ab2KWIl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 03:41:57 -0500
MIME-Version: 1.0
In-Reply-To: <1352187498-9754-1-git-send-email-qingx@marvell.com>
References: <1352187498-9754-1-git-send-email-qingx@marvell.com>
Date: Fri, 23 Nov 2012 16:41:56 +0800
Message-ID: <CAN1soZyGVaASo2zakxr9EgMdSqVvQyVt0bLDOmFNmN9+NhXWUg@mail.gmail.com>
Subject: Re: [PATCH 2/7] mfd: max8925: fix mfd device register failure
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Qing Xu <qingx@marvell.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, cxie4@marvell.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 6, 2012 at 3:38 PM, Qing Xu <qingx@marvell.com> wrote:
> From: Qing Xu <qingx@marvell.com>
>
> we encounter rtc/power/touch driver registry failure, root cause
> it is resources confilict in insert_resouce, solved by changing
> mfd_add_devices 5th parameter to NULL
>
Since resources are not used in power/rtc driver and touch driver
isn't implemented,
it's OK to avoid use resources. Please remove those resources in
max8925-core.c also.


> Signed-off-by: Qing Xu <qingx@marvell.com>
> ---
>  drivers/mfd/max8925-core.c |   22 ++++++++++------------
>  1 files changed, 10 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/mfd/max8925-core.c b/drivers/mfd/max8925-core.c
> index dcc218a..b1eacae 100644
> --- a/drivers/mfd/max8925-core.c
> +++ b/drivers/mfd/max8925-core.c
> @@ -873,7 +873,7 @@ int __devinit max8925_device_init(struct max8925_chip *chip,
>
>         ret = mfd_add_devices(chip->dev, 0, &rtc_devs[0],
>                               ARRAY_SIZE(rtc_devs),
> -                             &rtc_resources[0], chip->irq_base, NULL);
> +                             NULL, chip->irq_base, NULL);
>         if (ret < 0) {
>                 dev_err(chip->dev, "Failed to add rtc subdev\n");
>                 goto out;
> @@ -881,7 +881,7 @@ int __devinit max8925_device_init(struct max8925_chip *chip,
>
>         ret = mfd_add_devices(chip->dev, 0, &onkey_devs[0],
>                               ARRAY_SIZE(onkey_devs),
> -                             &onkey_resources[0], 0, NULL);
> +                             NULL, 0, NULL);
>         if (ret < 0) {
>                 dev_err(chip->dev, "Failed to add onkey subdev\n");
>                 goto out_dev;
> @@ -900,21 +900,19 @@ int __devinit max8925_device_init(struct max8925_chip *chip,
>                 goto out_dev;
>         }
>
> -       if (pdata && pdata->power) {
> -               ret = mfd_add_devices(chip->dev, 0, &power_devs[0],
> -                                       ARRAY_SIZE(power_devs),
> -                                       &power_supply_resources[0], 0, NULL);
> -               if (ret < 0) {
> -                       dev_err(chip->dev, "Failed to add power supply "
> -                               "subdev\n");
> -                       goto out_dev;
> -               }
> +       ret = mfd_add_devices(chip->dev, 0, &power_devs[0],
> +                               ARRAY_SIZE(power_devs),
> +                               NULL, 0, NULL);
> +       if (ret < 0) {
> +               dev_err(chip->dev, "Failed to add power supply "
> +                       "subdev, err = %d\n", ret);
> +               goto out_dev;
>         }
>
>         if (pdata && pdata->touch) {
>                 ret = mfd_add_devices(chip->dev, 0, &touch_devs[0],
>                                       ARRAY_SIZE(touch_devs),
> -                                     &touch_resources[0], 0, NULL);
> +                                     NULL, chip->tsc_irq_base, NULL);
>                 if (ret < 0) {
>                         dev_err(chip->dev, "Failed to add touch subdev\n");
>                         goto out_dev;
> --
> 1.7.0.4
>
