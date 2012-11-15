Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768384Ab2KOQZC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 11:25:02 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47339 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768340Ab2KOQZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 11:25:00 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] backlight: Add of_find_backlight_by_node() function
To: Thierry Reding <thierry.reding@avionic-design.de>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-fbdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1352326119-7301-1-git-send-email-thierry.reding@avionic-design.de>
References: <1352326119-7301-1-git-send-email-thierry.reding@avionic-design.de>
Date: Thu, 15 Nov 2012 16:24:56 +0000
Message-Id: <20121115162456.101A83E194B@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  7 Nov 2012 23:08:39 +0100, Thierry Reding <thierry.reding@avionic-design.de> wrote:
> This function finds the struct backlight_device for a given device tree
> node. A dummy function is provided so that it safely compiles out if OF
> support is disabled.
> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>

Looks okay to me.

Reviewed-by: Grant Likely <grant.likely@secretlab.ca>
> ---
>  drivers/video/backlight/backlight.c | 17 +++++++++++++++++
>  include/linux/backlight.h           | 10 ++++++++++
>  2 files changed, 27 insertions(+)
> 
> diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
> index 297db2f..0d1ed4f 100644
> --- a/drivers/video/backlight/backlight.c
> +++ b/drivers/video/backlight/backlight.c
> @@ -370,6 +370,23 @@ void backlight_device_unregister(struct backlight_device *bd)
>  }
>  EXPORT_SYMBOL(backlight_device_unregister);
>  
> +#if IS_ENABLED(CONFIG_OF)
> +static int of_parent_match(struct device *dev, void *data)
> +{
> +	return dev->parent && dev->parent->of_node == data;
> +}
> +
> +struct backlight_device *of_find_backlight_by_node(struct device_node *node)
> +{
> +	struct device *dev;
> +
> +	dev = class_find_device(backlight_class, NULL, node, of_parent_match);
> +
> +	return dev ? to_backlight_device(dev) : NULL;
> +}
> +EXPORT_SYMBOL(of_find_backlight_by_node);
> +#endif
> +
>  static void __exit backlight_class_exit(void)
>  {
>  	class_destroy(backlight_class);
> diff --git a/include/linux/backlight.h b/include/linux/backlight.h
> index 5ffc6dd..11840e9 100644
> --- a/include/linux/backlight.h
> +++ b/include/linux/backlight.h
> @@ -134,4 +134,14 @@ struct generic_bl_info {
>  	void (*kick_battery)(void);
>  };
>  
> +#if IS_ENABLED(CONFIG_OF)
> +struct backlight_device *of_find_backlight_by_node(struct device_node *node);
> +#else
> +static inline struct backlight_device *
> +of_find_backlight_by_node(struct device_node *node)
> +{
> +	return NULL;
> +}
> +#endif
> +
>  #endif
> -- 
> 1.8.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
