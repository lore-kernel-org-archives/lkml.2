Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab2BPTy2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 14:54:28 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36032 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588Ab2BPTy0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 14:54:26 -0500
MIME-Version: 1.0
In-Reply-To: <1329339646-19472-1-git-send-email-swarren@nvidia.com>
References: <1329339646-19472-1-git-send-email-swarren@nvidia.com>
Date: Thu, 16 Feb 2012 20:54:26 +0100
Message-ID: <CACRpkdZT+wYopQOJ5Ody1kCgVuxZTTCxq-Q6DLg-uF-FW8bX6w@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: Store mapping table as a list of chunks
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Overall this is exactly what we want, good work!

On Wed, Feb 15, 2012 at 10:00 PM, Stephen Warren <swarren@nvidia.com> wrote:

> --- a/arch/arm/mach-u300/core.c
> +++ b/arch/arm/mach-u300/core.c
> @@ -1552,7 +1552,7 @@ static struct platform_device pinmux_device = {
>  };
>
>  /* Pinmux settings */
> -static struct pinctrl_map __initdata u300_pinmux_map[] = {
> +static struct pinctrl_map u300_pinmux_map[] = {

This was actually not tagged __initdata until last merge window.

The reason it was made discardable was for platform that needed
to discard a large number of mappings after boot, since only a few
of them got registered from the board files.

(Yes, I know this will not be a problem in device tree configs...)

Can we combine the best of two worlds by still making a
shallow copy (like previously) and put that shallow copy into the
list instead?

> +#define for_each_maps(_maps_node_, _i_, _map_) \
> +       list_for_each_entry(_maps_node_, &pinctrl_maps, node) \
> +               for (_i_ = 0, _map_ = &_maps_node_->maps[_i_]; \
> +                       _i_ < _maps_node_->num_maps; \
> +                       i++, _map_ = &_maps_node_->maps[_i_])

I really like this macro.

>  /**
> @@ -654,8 +684,8 @@ EXPORT_SYMBOL_GPL(pinctrl_disable);
>  int __init pinctrl_register_mappings(struct pinctrl_map const *maps,
>                                     unsigned num_maps)
>  {
> -       void *tmp_maps;
>        int i;
> +       struct pinctrl_maps *maps_node;
>
>        pr_debug("add %d pinmux maps\n", num_maps);
>
> @@ -689,31 +719,17 @@ int __init pinctrl_register_mappings(struct pinctrl_map const *maps,
>                                 maps[i].function);
>        }
>
> -       /*
> -        * Make a copy of the map array - string pointers will end up in the
> -        * kernel const section anyway so these do not need to be deep copied.
> -        */
> -       if (!pinctrl_maps_num) {
> -               /* On first call, just copy them */
> -               tmp_maps = kmemdup(maps,
> -                                  sizeof(struct pinctrl_map) * num_maps,
> -                                  GFP_KERNEL);
> -               if (!tmp_maps)
> -                       return -ENOMEM;
> -       } else {
> -               /* Subsequent calls, reallocate array to new size */
> -               size_t oldsize = sizeof(struct pinctrl_map) * pinctrl_maps_num;
> -               size_t newsize = sizeof(struct pinctrl_map) * num_maps;
> +       maps_node = kzalloc(sizeof(*maps), GFP_KERNEL);
> +       if (!maps_node)
> +               return -ENOMEM;
>
> -               tmp_maps = krealloc(pinctrl_maps,
> -                                   oldsize + newsize, GFP_KERNEL);
> -               if (!tmp_maps)
> -                       return -ENOMEM;
> -               memcpy((tmp_maps + oldsize), maps, newsize);

So can we keep this codepath (with apropriate changes) and have the
copy added to the list entry?

> -       }
> +       maps_node->maps = maps;

i.e. here.

Thanks,
Linus Walleij
