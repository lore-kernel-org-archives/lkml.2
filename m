Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab2KPVQs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 16:16:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46027 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab2KPVQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 16:16:46 -0500
Date: Fri, 16 Nov 2012 13:16:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Richard Purdie <rpurdie@rpsys.net>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] backlight: Add of_find_backlight_by_node() function
Message-Id: <20121116131645.c979837c.akpm@linux-foundation.org>
In-Reply-To: <1352469878-4532-1-git-send-email-thierry.reding@avionic-design.de>
References: <1352469878-4532-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  9 Nov 2012 15:04:38 +0100
Thierry Reding <thierry.reding@avionic-design.de> wrote:

> This function finds the struct backlight_device for a given device tree
> node. A dummy function is provided so that it safely compiles out if OF
> support is disabled.
> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
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

Using IS_ENABLED() was odd.  We'll never support CONFIG_OF=m, so can't
we use plain old "#ifdef CONFIG_OF" here?

--- a/drivers/video/backlight/backlight.c~backlight-add-of_find_backlight_by_node-function-fix
+++ a/drivers/video/backlight/backlight.c
@@ -370,7 +370,7 @@ void backlight_device_unregister(struct 
 }
 EXPORT_SYMBOL(backlight_device_unregister);
 
-#if IS_ENABLED(CONFIG_OF)
+#ifdef CONFIG_OF
 static int of_parent_match(struct device *dev, void *data)
 {
 	return dev->parent && dev->parent->of_node == data;
--- a/include/linux/backlight.h~backlight-add-of_find_backlight_by_node-function-fix
+++ a/include/linux/backlight.h
@@ -134,7 +134,7 @@ struct generic_bl_info {
 	void (*kick_battery)(void);
 };
 
-#if IS_ENABLED(CONFIG_OF)
+#ifdef CONFIG_OF
 struct backlight_device *of_find_backlight_by_node(struct device_node *node);
 #else
 static inline struct backlight_device *
_


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

It's a global, exported-to-modules function.  We should document such
major interfaces.  Unless they are dead trivial, but I don't think this
one is that simple.  The semantics of the return value could be
explained, and callers should be told that of_find_backlight_by_node()
took a ref on the returned device, and that they need to run
put_device(retval->dev), if retval was not NULL.

And anything else which might be useful.


