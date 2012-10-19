Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030215Ab2JSKHT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 06:07:19 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:40716 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267Ab2JSKHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 06:07:17 -0400
MIME-Version: 1.0
In-Reply-To: <507DF099.1010504@gmail.com>
References: <507DF099.1010504@gmail.com>
Date: Fri, 19 Oct 2012 12:07:16 +0200
Message-ID: <CACRpkdbgrDZ+mzy4YaGtyHTm-P2nsEL6bwB7WS=OsZ1VF4crmQ@mail.gmail.com>
Subject: Re: [RFC PATCH] gpiolib: Refactor gpio_export
From: Linus Walleij <linus.walleij@linaro.org>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 1:41 AM, Ryan Mallon <rmallon@gmail.com> wrote:

> The gpio_export function uses nested if statements and the status
> variable to handle the failure cases. This makes the function logic
> difficult to follow. Refactor the code to abort immediately on failure
> using goto. This makes the code slightly longer, but significantly
> reduces the nesting and number of split lines and makes the code easier
> to read.
>
> Signed-off-by: Ryan Mallon

Very good initiative!

> +++ b/drivers/gpio/gpiolib.c
> @@ -702,68 +702,74 @@ int gpio_export(unsigned gpio, bool direction_may_change)
>  {
>         unsigned long           flags;
>         struct gpio_desc        *desc;
> -       int                     status = -EINVAL;
> +       int                     status;
>         const char              *ioname = NULL;
> +       struct device           *dev;
>
>         /* can't export until sysfs is available ... */
>         if (!gpio_class.p) {
>                 pr_debug("%s: called too early!\n", __func__);
> -               return -ENOENT;
> +               status = -ENOENT;
> +               goto fail;

Why bother with all the goto:s here since there are no resources
to clean up? Just pr_debug() and return -ENOENT; is good enough.

I don't quite see the point.

Arguably this should be pr_err() or something BTW, just debug()
may hide serious bugs.

> -       if (!gpio_is_valid(gpio))
> -               goto done;
> +       if (!gpio_is_valid(gpio)) {
> +               status = -EINVAL;
> +               goto fail;
> +       }

Why not just pr_err(..); return -EINVAL; ?

> -       if (test_bit(FLAG_REQUESTED, &desc->flags)
> -                       && !test_bit(FLAG_EXPORT, &desc->flags)) {
> -               status = 0;
> -               if (!desc->chip->direction_input
> -                               || !desc->chip->direction_output)
> -                       direction_may_change = false;
> +       if (!test_bit(FLAG_REQUESTED, &desc->flags) ||
> +            test_bit(FLAG_EXPORT, &desc->flags)) {
> +               spin_unlock_irqrestore(&gpio_lock, flags);
> +               status = -ENOENT;
> +               goto fail;

I would just print and return here as well.

> +
> +       if (!desc->chip->direction_input || !desc->chip->direction_output)
> +               direction_may_change = false;
>         spin_unlock_irqrestore(&gpio_lock, flags);
>
>         if (desc->chip->names && desc->chip->names[gpio - desc->chip->base])
>                 ioname = desc->chip->names[gpio - desc->chip->base];
>
> -       if (status == 0) {
> -               struct device   *dev;
> -
> -               dev = device_create(&gpio_class, desc->chip->dev, MKDEV(0, 0),
> -                               desc, ioname ? ioname : "gpio%u", gpio);
> -               if (!IS_ERR(dev)) {
> -                       status = sysfs_create_group(&dev->kobj,
> -                                               &gpio_attr_group);
> -
> -                       if (!status && direction_may_change)
> -                               status = device_create_file(dev,
> -                                               &dev_attr_direction);
> -
> -                       if (!status && gpio_to_irq(gpio) >= 0
> -                                       && (direction_may_change
> -                                               || !test_bit(FLAG_IS_OUT,
> -                                                       &desc->flags)))
> -                               status = device_create_file(dev,
> -                                               &dev_attr_edge);
> -
> -                       if (status != 0)
> -                               device_unregister(dev);
> -               } else
> -                       status = PTR_ERR(dev);
> -               if (status == 0)
> -                       set_bit(FLAG_EXPORT, &desc->flags);
> +       dev = device_create(&gpio_class, desc->chip->dev, MKDEV(0, 0),
> +                           desc, ioname ? ioname : "gpio%u", gpio);
> +       if (IS_ERR(dev)) {
> +               status = PTR_ERR(dev);
> +               goto fail_unlock;

Since this involves clean-up in the form of unlocking the mutex this
goto is fine however.

Same for unregister_device:.

Yours,
Linus Walleij
