Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab1F3QcY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 12:32:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378Ab1F3QcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 12:32:22 -0400
Date: Thu, 30 Jun 2011 12:32:18 -0400
From: Jason Baron <jbaron@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Aloisio Almeida <aloisio.almeida@openbossa.org>
Subject: Re: RFC: Add __dynamic_dev_dbg
Message-ID: <20110630163218.GA2457@redhat.com>
References: <1309285246-8495-1-git-send-email-aloisio.almeida@openbossa.org>
 <1309285246-8495-2-git-send-email-aloisio.almeida@openbossa.org>
 <1309292325.29598.9.camel@Joe-Laptop>
 <1309311096.2208.33.camel@aeonflux>
 <1309312164.29598.53.camel@Joe-Laptop>
 <1309370457.2208.48.camel@aeonflux>
 <BANLkTinospg_dhTC8Tcok3kqk9gOryG6eA@mail.gmail.com>
 <1309391163.29598.92.camel@Joe-Laptop>
 <CAEsZsEgfKPtsXKGiAV3QuH=YESyS+GHnsNjauVZV==AN94fxug@mail.gmail.com>
 <1309409341.1726.14.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309409341.1726.14.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 09:49:01PM -0700, Joe Perches wrote:
> (resending to LKML)
> 
> That seems enough easy to fix.
> 
> Jason?  How does this look?
> 

Thanks for noticing the inconsistency. Patch makes sense to me.

There seem to be a number of pending dynamic debug patches. So if you want to
send me this patch with a changelog and sob line, I can queue up with the rest.

thanks,

-Jason

> ---
> 
>  drivers/base/core.c           |    5 +++--
>  include/linux/device.h        |    5 +++++
>  include/linux/dynamic_debug.h |   10 ++++++++--
>  lib/dynamic_debug.c           |   38 ++++++++++++++++++++++++++++++++++++++
>  4 files changed, 54 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index bc8729d..82c8654 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -1764,8 +1764,8 @@ void device_shutdown(void)
>  
>  #ifdef CONFIG_PRINTK
>  
> -static int __dev_printk(const char *level, const struct device *dev,
> -			struct va_format *vaf)
> +int __dev_printk(const char *level, const struct device *dev,
> +		 struct va_format *vaf)
>  {
>  	if (!dev)
>  		return printk("%s(NULL device *): %pV", level, vaf);
> @@ -1773,6 +1773,7 @@ static int __dev_printk(const char *level, const struct device *dev,
>  	return printk("%s%s %s: %pV",
>  		      level, dev_driver_string(dev), dev_name(dev), vaf);
>  }
> +EXPORT_SYMBOL(__dev_printk);
>  
>  int dev_printk(const char *level, const struct device *dev,
>  	       const char *fmt, ...)
> diff --git a/include/linux/device.h b/include/linux/device.h
> index e4f62d8..53711f2 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -785,6 +785,8 @@ extern const char *dev_driver_string(const struct device *dev);
>  
>  #ifdef CONFIG_PRINTK
>  
> +extern int __dev_printk(const char *level, const struct device *dev,
> +			struct va_format *vaf);
>  extern int dev_printk(const char *level, const struct device *dev,
>  		      const char *fmt, ...)
>  	__attribute__ ((format (printf, 3, 4)));
> @@ -805,6 +807,9 @@ extern int _dev_info(const struct device *dev, const char *fmt, ...)
>  
>  #else
>  
> +static inline int __dev_printk(const char *level, const struct device *dev,
> +			       struct va_format *vaf)
> +	 { return 0; }
>  static inline int dev_printk(const char *level, const struct device *dev,
>  		      const char *fmt, ...)
>  	__attribute__ ((format (printf, 3, 4)));
> diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
> index e747ecd..bdf1531 100644
> --- a/include/linux/dynamic_debug.h
> +++ b/include/linux/dynamic_debug.h
> @@ -47,6 +47,13 @@ extern int ddebug_remove_module(const char *mod_name);
>  extern int __dynamic_pr_debug(struct _ddebug *descriptor, const char *fmt, ...)
>  	__attribute__ ((format (printf, 2, 3)));
>  
> +struct device;
> +
> +extern int __dynamic_dev_dbg(struct _ddebug *descriptor,
> +			     const struct device *dev,
> +			     const char *fmt, ...)
> +	__attribute__ ((format (printf, 3, 4)));
> +
>  #define dynamic_pr_debug(fmt, ...) do {					\
>  	static struct _ddebug descriptor				\
>  	__used								\
> @@ -57,7 +64,6 @@ extern int __dynamic_pr_debug(struct _ddebug *descriptor, const char *fmt, ...)
>  		__dynamic_pr_debug(&descriptor, pr_fmt(fmt), ##__VA_ARGS__); \
>  	} while (0)
>  
> -
>  #define dynamic_dev_dbg(dev, fmt, ...) do {				\
>  	static struct _ddebug descriptor				\
>  	__used								\
> @@ -65,7 +71,7 @@ extern int __dynamic_pr_debug(struct _ddebug *descriptor, const char *fmt, ...)
>  	{ KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,		\
>  		_DPRINTK_FLAGS_DEFAULT };				\
>  	if (unlikely(descriptor.enabled))				\
> -		dev_printk(KERN_DEBUG, dev, fmt, ##__VA_ARGS__);	\
> +		__dynamic_dev_dbg(&descriptor, dev, fmt, ##__VA_ARGS__);	\
>  	} while (0)
>  
>  #else
> diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
> index 75ca78f..5c5f8f9 100644
> --- a/lib/dynamic_debug.c
> +++ b/lib/dynamic_debug.c
> @@ -30,6 +30,7 @@
>  #include <linux/jump_label.h>
>  #include <linux/hardirq.h>
>  #include <linux/sched.h>
> +#include <linux/device.h>
>  
>  extern struct _ddebug __start___verbose[];
>  extern struct _ddebug __stop___verbose[];
> @@ -456,6 +457,43 @@ int __dynamic_pr_debug(struct _ddebug *descriptor, const char *fmt, ...)
>  }
>  EXPORT_SYMBOL(__dynamic_pr_debug);
>  
> +int __dynamic_dev_dbg(struct _ddebug *descriptor,
> +		      const struct device *dev, const char *fmt, ...)
> +{
> +	struct va_format vaf;
> +	va_list args;
> +	int res;
> +
> +	BUG_ON(!descriptor);
> +	BUG_ON(!fmt);
> +
> +	va_start(args, fmt);
> +
> +	vaf.fmt = fmt;
> +	vaf.va = &args;
> +
> +	res = printk(KERN_DEBUG);
> +	if (descriptor->flags & _DPRINTK_FLAGS_INCL_TID) {
> +		if (in_interrupt())
> +			res += printk(KERN_CONT "<intr> ");
> +		else
> +			res += printk(KERN_CONT "[%d] ", task_pid_vnr(current));
> +	}
> +	if (descriptor->flags & _DPRINTK_FLAGS_INCL_MODNAME)
> +		res += printk(KERN_CONT "%s:", descriptor->modname);
> +	if (descriptor->flags & _DPRINTK_FLAGS_INCL_FUNCNAME)
> +		res += printk(KERN_CONT "%s:", descriptor->function);
> +	if (descriptor->flags & _DPRINTK_FLAGS_INCL_LINENO)
> +		res += printk(KERN_CONT "%d ", descriptor->lineno);
> +
> +	res += __dev_printk("", dev, &vaf);
> +
> +	va_end(args);
> +
> +	return res;
> +}
> +EXPORT_SYMBOL(__dynamic_dev_dbg);
> +
>  static __initdata char ddebug_setup_string[1024];
>  static __init int ddebug_setup_query(char *str)
>  {
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
