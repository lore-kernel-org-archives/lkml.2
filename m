Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904Ab1K3WD7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 17:03:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628Ab1K3WD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 17:03:57 -0500
Date: Wed, 30 Nov 2011 17:03:51 -0500
From: Jason Baron <jbaron@redhat.com>
To: jim.cromie@gmail.com
Cc: greg@kroah.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/25] dynamic_debug: make dynamic-debug supersede DEBUG
 ccflag
Message-ID: <20111130220351.GC2500@redhat.com>
References: <1322683014-13285-1-git-send-email-jim.cromie@gmail.com>
 <1322683014-13285-5-git-send-email-jim.cromie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322683014-13285-5-git-send-email-jim.cromie@gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 12:56:33PM -0700, jim.cromie@gmail.com wrote:
> From: Jim Cromie <jim.cromie@gmail.com>
> 
> if CONFIG_DYNAMIC_DEBUG is defined, honor it over DEBUG, so that
> pr_debug()s are controllable, instead of always-on.  When DEBUG is
> also defined, change _DPRINTK_FLAGS_DEFAULT to enable printing by
> default.
> 
> Also adding _DPRINTK_FLAGS_INCL_MODNAME would be nice, but there are
> numerous cases of pr_debug(NAME ": ...), which would result in double
> printing of module-name.  So defer this until things settle.
> 
> CC: Joe Perches <joe@perches.com>
> Signed-off-by: Jim Cromie <jim.cromie@gmail.com>

I think it's this patach that is causing a lot of "=p" when I boot up
using a 'make defconfig'. I'm a bit surprised at how many files have
'DEBUG' defined. Are we sure that we are setting the 'p' flag for the
same set of debug statements that would be set if CONFIG_DYNAMIC_DEBUG
were not set?

Also, it seems a bit strange to me, if I now enable all debug statements
and then clear everything (common pattern, I think), that I'm now
disabling stuff that was enabled by default.

Thanks,

-Jason 


> ---
>  include/linux/device.h        |    8 ++++----
>  include/linux/dynamic_debug.h |    4 ++++
>  include/linux/netdevice.h     |    8 ++++----
>  include/linux/printk.h        |    8 ++++----
>  4 files changed, 16 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/device.h b/include/linux/device.h
> index 3136ede..c9468c1 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -872,14 +872,14 @@ int _dev_info(const struct device *dev, const char *fmt, ...)
>  
>  #define dev_info(dev, fmt, arg...) _dev_info(dev, fmt, ##arg)
>  
> -#if defined(DEBUG)
> -#define dev_dbg(dev, format, arg...)		\
> -	dev_printk(KERN_DEBUG, dev, format, ##arg)
> -#elif defined(CONFIG_DYNAMIC_DEBUG)
> +#if defined(CONFIG_DYNAMIC_DEBUG)
>  #define dev_dbg(dev, format, ...)		     \
>  do {						     \
>  	dynamic_dev_dbg(dev, format, ##__VA_ARGS__); \
>  } while (0)
> +#elif defined(DEBUG)
> +#define dev_dbg(dev, format, arg...)		\
> +	dev_printk(KERN_DEBUG, dev, format, ##arg)
>  #else
>  #define dev_dbg(dev, format, arg...)				\
>  ({								\
> diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
> index f71a6b04..29ea09a 100644
> --- a/include/linux/dynamic_debug.h
> +++ b/include/linux/dynamic_debug.h
> @@ -26,7 +26,11 @@ struct _ddebug {
>  #define _DPRINTK_FLAGS_INCL_FUNCNAME	(1<<2)
>  #define _DPRINTK_FLAGS_INCL_LINENO	(1<<3)
>  #define _DPRINTK_FLAGS_INCL_TID		(1<<4)
> +#if defined DEBUG
> +#define _DPRINTK_FLAGS_DEFAULT _DPRINTK_FLAGS_PRINT
> +#else
>  #define _DPRINTK_FLAGS_DEFAULT 0
> +#endif
>  	unsigned int flags:8;
>  } __attribute__((aligned(8)));
>  
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index cbeb586..f8b71a3c 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -2643,14 +2643,14 @@ int netdev_info(const struct net_device *dev, const char *format, ...);
>  #define MODULE_ALIAS_NETDEV(device) \
>  	MODULE_ALIAS("netdev-" device)
>  
> -#if defined(DEBUG)
> -#define netdev_dbg(__dev, format, args...)			\
> -	netdev_printk(KERN_DEBUG, __dev, format, ##args)
> -#elif defined(CONFIG_DYNAMIC_DEBUG)
> +#if defined(CONFIG_DYNAMIC_DEBUG)
>  #define netdev_dbg(__dev, format, args...)			\
>  do {								\
>  	dynamic_netdev_dbg(__dev, format, ##args);		\
>  } while (0)
> +#elif defined(DEBUG)
> +#define netdev_dbg(__dev, format, args...)			\
> +	netdev_printk(KERN_DEBUG, __dev, format, ##args)
>  #else
>  #define netdev_dbg(__dev, format, args...)			\
>  ({								\
> diff --git a/include/linux/printk.h b/include/linux/printk.h
> index f0e22f7..f9abd93 100644
> --- a/include/linux/printk.h
> +++ b/include/linux/printk.h
> @@ -180,13 +180,13 @@ extern void dump_stack(void) __cold;
>  #endif
>  
>  /* If you are writing a driver, please use dev_dbg instead */
> -#if defined(DEBUG)
> -#define pr_debug(fmt, ...) \
> -	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
> -#elif defined(CONFIG_DYNAMIC_DEBUG)
> +#if defined(CONFIG_DYNAMIC_DEBUG)
>  /* dynamic_pr_debug() uses pr_fmt() internally so we don't need it here */
>  #define pr_debug(fmt, ...) \
>  	dynamic_pr_debug(fmt, ##__VA_ARGS__)
> +#elif defined(DEBUG)
> +#define pr_debug(fmt, ...) \
> +	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
>  #else
>  #define pr_debug(fmt, ...) \
>  	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
> -- 
> 1.7.7.3
> 
