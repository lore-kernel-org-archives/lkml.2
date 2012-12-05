Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207Ab2LEXDY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 18:03:24 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:50296 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029Ab2LEXDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 18:03:23 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] of: Output devicetree alias names in uevent
To: Stepan Moskovchenko <stepanm@codeaurora.org>
Cc: Rob Herring <rob.herring@calxeda.com>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        David Brown <davidb@codeaurora.org>, mbohan@codeaurora.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
In-Reply-To: <1354674637-6448-1-git-send-email-stepanm@codeaurora.org>
References: <1354674637-6448-1-git-send-email-stepanm@codeaurora.org>
Date: Wed, 05 Dec 2012 23:03:17 +0000
Message-Id: <20121205230318.013053E0E22@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  4 Dec 2012 18:30:37 -0800, Stepan Moskovchenko <stepanm@codeaurora.org> wrote:
> In some situations, userspace may want to resolve a
> device by function and logical number (ie, "serial0")
> rather than by the base address or full device path. Being
> able to resolve a device by alias frees userspace from the
> burden of otherwise having to maintain a mapping between
> device addresses and their logical assignments on each
> platform when multiple instances of the same hardware block
> are present in the system.
> 
> Although the uevent device attribute contains devicetree
> compatible information and the full device path, the uevent
> does not list the alises that may have been defined for the
> device.
> 
> Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
> ---
> I have followed the OF_COMPATIBLE convention for adding the
> uevent variables for the alias names, but I can follow some
> other convention if people feel something else is more
> appropriate.

No, this seems fine. Comments below.

>  drivers/of/base.c         |   25 +++++++++++++++++++++++++
>  drivers/of/device.c       |    1 +
>  include/linux/of_device.h |    2 ++
>  3 files changed, 28 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index 5806449..291f0a0 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -19,6 +19,7 @@
>   */
>  #include <linux/ctype.h>
>  #include <linux/module.h>
> +#include <linux/device.h>
>  #include <linux/of.h>
>  #include <linux/spinlock.h>
>  #include <linux/slab.h>
> @@ -1177,6 +1178,30 @@ static void of_alias_add(struct alias_prop *ap, struct device_node *np,
>  }
> 
>  /**
> + * of_device_uevent_aliases - Display OF alises in uevent
> + */
> +void of_device_uevent_aliases(struct device_node *node,
> +			      struct kobj_uevent_env *env)
> +{
> +	struct alias_prop *app;
> +	int seen = 0;
> +
> +	mutex_lock(&of_aliases_mutex);
> +	list_for_each_entry(app, &aliases_lookup, link) {
> +		if (node == app->np) {
> +			add_uevent_var(env, "OF_ALIAS_%d=%s%d", seen, app->stem,
> +				       app->id);

add_uevent_var(env, "OF_ALIAS_%d=%s", seen, app->alias);

> +			seen++;
> +		}
> +	}
> +
> +	if (seen)
> +		add_uevent_var(env, "OF_ALIAS_N=%d", seen);
> +
> +	mutex_unlock(&of_aliases_mutex);
> +}

Why is this implemented as a separate function? Do you forsee it being
called by something else? If not, then just roll it into the body of
of_device_uevent_aliases() please.

Oh, wait, alias_prop is only defined in drivers/of/base.c. Rats. Can you
create a header named drivers/of/of_private.h to move it into please? I
don't want the uevent stuff to appear in drivers/of/base.c.

> +
> +/**
>   * of_alias_scan - Scan all properties of 'aliases' node
>   *
>   * The function scans all the properties of 'aliases' node and populate
> diff --git a/drivers/of/device.c b/drivers/of/device.c
> index 4c74e4f..06e122d 100644
> --- a/drivers/of/device.c
> +++ b/drivers/of/device.c
> @@ -153,6 +153,7 @@ void of_device_uevent(struct device *dev, struct kobj_uevent_env *env)
>  		seen++;
>  	}
>  	add_uevent_var(env, "OF_COMPATIBLE_N=%d", seen);
> +	of_device_uevent_aliases(dev->of_node, env);
>  }
> 
>  int of_device_uevent_modalias(struct device *dev, struct kobj_uevent_env *env)
> diff --git a/include/linux/of_device.h b/include/linux/of_device.h
> index 901b743..748056d 100644
> --- a/include/linux/of_device.h
> +++ b/include/linux/of_device.h
> @@ -36,6 +36,8 @@ extern ssize_t of_device_get_modalias(struct device *dev,
>  					char *str, ssize_t len);
> 
>  extern void of_device_uevent(struct device *dev, struct kobj_uevent_env *env);
> +extern void of_device_uevent_aliases(struct device_node *node,
> +					struct kobj_uevent_env *env);
>  extern int of_device_uevent_modalias(struct device *dev, struct kobj_uevent_env *env);
> 
>  static inline void of_device_node_put(struct device *dev)
> --
> The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> hosted by The Linux Foundation
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
