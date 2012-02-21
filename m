Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab2BUNIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 08:08:20 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45165 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754854Ab2BUNIT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 08:08:19 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dongas86@gmail.com designates 10.101.175.14 as permitted sender) smtp.mail=dongas86@gmail.com; dkim=pass header.i=dongas86@gmail.com
MIME-Version: 1.0
In-Reply-To: <1329720360-23227-9-git-send-email-swarren@nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
	<1329720360-23227-9-git-send-email-swarren@nvidia.com>
Date: Tue, 21 Feb 2012 21:08:18 +0800
Message-ID: <CAA+hA=THDSqCU-TBjEN=Rc5DkuVxu9kwvtv5w4G7dc3vDrasYg@mail.gmail.com>
Subject: Re: [PATCH 08/20] pinctrl: Assume map table entries can't have a NULL
 name field
From: Dong Aisheng <dongas86@gmail.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, B29396@freescale.com,
        s.hauer@pengutronix.de, shawn.guo@linaro.org,
        thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 2:45 PM, Stephen Warren <swarren@nvidia.com> wrote:
> pinctrl_register_mappings() already requires that every mapping table
> entry have a non-NULL name field.
>
> Logically, this makes sense too; drivers should always request a specific
> named state so they know what they're getting. Relying on getting the
Hmm? It makes me a little confused.
IIRC we allow the driver to request NULL map name in the linaro
connect discussion.
For those devices they do not want to support multi states, they
really don't want to care about the state name.
The original way is convenient for such a case.

> first mentioned state in the mapping table is error-prone, and a nasty
> special case to implement, given that a given the mapping table may define
> multiple states for a device.
>
User should know this constraint.

> diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
> index b6e3c35..5e30d91 100644
> --- a/drivers/pinctrl/core.c
> +++ b/drivers/pinctrl/core.c
> @@ -488,8 +488,8 @@ static struct pinctrl *pinctrl_get_locked(struct device *dev, const char *name)
>        int i;
>        struct pinctrl_map const *map;
>
> -       /* We must have dev or ID or both */
> -       if (!dev && !name)
> +       /* We must have a state name */
> +       if (WARN_ON(!name))
>                return ERR_PTR(-EINVAL);
>
We're already using the pinctrl device name for hog map.
So should it be something like:
	if (WARN_ON(!dev) || WARN_ON(!name))


>        if (dev)
> @@ -530,23 +530,16 @@ static struct pinctrl *pinctrl_get_locked(struct device *dev, const char *name)
>                pr_debug("in map, found pctldev %s to handle function %s",
>                         dev_name(pctldev->dev), map->function);
>
> -               /*
> -                * If we're looking for a specific named map, this must match,
> -                * else we loop and look for the next.
> -                */
> -               if (name != NULL) {
> -                       if (map->name == NULL)
> -                               continue;
> -                       if (strcmp(map->name, name))
> -                               continue;
> -               }
> +               /* State name must be the one we're looking for */
> +               if (strcmp(map->name, name))
> +                       continue;
>
>                /*
>                 * This is for the case where no device name is given, we
>                 * already know that the function name matches from above
>                 * code.
>                 */
> -               if (!map->dev_name && (name != NULL))
> +               if (!map->dev_name)
>                        found_map = true;
Do we still need this?
Is there still a case the dev_name can be NULL?


>
>                /* If the mapping has a device set up it must match */
> @@ -570,16 +563,14 @@ static struct pinctrl *pinctrl_get_locked(struct device *dev, const char *name)
>        /* We should have atleast one map, right */
>        if (!num_maps) {
>                pr_err("could not find any mux maps for device %s, ID %s\n",
> -                      devname ? devname : "(anonymous)",
> -                      name ? name : "(undefined)");
> +                      devname ? devname : "(anonymous)", name);
>                kfree(p);
>                return ERR_PTR(-EINVAL);
>        }
>
>        pr_debug("found %u mux maps for device %s, UD %s\n",
>                 num_maps,
> -                devname ? devname : "(anonymous)",
> -                name ? name : "(undefined)");
> +                devname ? devname : "(anonymous)", name);
>
>        /* Add the pinmux to the global list */
>        mutex_lock(&pinctrl_list_mutex);
> --
> 1.7.5.4
>

Regards
Dong Aisheng
