Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab1BON6F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 08:58:05 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:41425 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab1BON6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 08:58:03 -0500
X-Greylist: delayed 423 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Feb 2011 08:58:03 EST
Date: Tue, 15 Feb 2011 15:50:54 +0200
From: Alexander Shishkin <virtuoso@slind.org>
To: Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] ARM: etm: Allow range selection
Message-ID: <20110215135054.GD18248@shisha.kicks-ass.net>
Mail-Followup-To: Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
	linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
	Russell King <linux@arm.linux.org.uk>,
	Jason Wessel <jason.wessel@windriver.com>,
	Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
References: <1296701663-12168-1-git-send-email-arve@android.com>
 <1297750276-12475-4-git-send-email-arve@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1297750276-12475-4-git-send-email-arve@android.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 10:11:12PM -0800, Arve Hjønnevåg wrote:
> Trace kernel text segment by default as before, allow tracing of other
> ranges by writing a range to /sys/devices/etm/trace_range, or to trace
> everything by writing 0 0.

Since you're adding this, I think it might make sense to add a 3rd optional
ctx id field, so that userspace tracing is also possible, especially when
on-chip ETB sizes increase to something more sensible than what they are
these days.

Thanks!

> 
> Signed-off-by: Arve Hjønnevåg <arve@android.com>
> ---
>  arch/arm/kernel/etm.c |   49 ++++++++++++++++++++++++++++++++++++++++++++++---
>  1 files changed, 46 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
> index bc7d8f2..8a1c422 100644
> --- a/arch/arm/kernel/etm.c
> +++ b/arch/arm/kernel/etm.c
> @@ -40,12 +40,17 @@ struct tracectx {
>  	unsigned long	flags;
>  	int		ncmppairs;
>  	int		etm_portsz;
> +	unsigned long	range_start;
> +	unsigned long	range_end;
>  	struct device	*dev;
>  	struct clk	*emu_clk;
>  	struct mutex	mutex;
>  };
>  
> -static struct tracectx tracer;
> +static struct tracectx tracer = {
> +	.range_start = (unsigned long)_stext,
> +	.range_end = (unsigned long)_etext,
> +};
>  
>  static inline bool trace_isrunning(struct tracectx *t)
>  {
> @@ -115,8 +120,12 @@ static int trace_start(struct tracectx *t)
>  		return -EFAULT;
>  	}
>  
> -	etm_setup_address_range(t, 1, (unsigned long)_stext,
> -			(unsigned long)_etext, 0, 0);
> +	if (t->range_start || t->range_end)
> +		etm_setup_address_range(t, 1,
> +					t->range_start, t->range_end, 0, 0);
> +	else
> +		etm_writel(t, ETMTE_INCLEXCL, ETMR_TRACEENCTRL);
> +
>  	etm_writel(t, 0, ETMR_TRACEENCTRL2);
>  	etm_writel(t, 0, ETMR_TRACESSCTRL);
>  	etm_writel(t, 0x6f, ETMR_TRACEENEVT);
> @@ -525,6 +534,35 @@ static ssize_t trace_mode_store(struct kobject *kobj,
>  static struct kobj_attribute trace_mode_attr =
>  	__ATTR(trace_mode, 0644, trace_mode_show, trace_mode_store);
>  
> +static ssize_t trace_range_show(struct kobject *kobj,
> +				  struct kobj_attribute *attr,
> +				  char *buf)
> +{
> +	return sprintf(buf, "%08lx %08lx\n",
> +			tracer.range_start, tracer.range_end);
> +}
> +
> +static ssize_t trace_range_store(struct kobject *kobj,
> +				   struct kobj_attribute *attr,
> +				   const char *buf, size_t n)
> +{
> +	unsigned long range_start, range_end;
> +
> +	if (sscanf(buf, "%lx %lx", &range_start, &range_end) != 2)
> +		return -EINVAL;
> +
> +	mutex_lock(&tracer.mutex);
> +	tracer.range_start = range_start;
> +	tracer.range_end = range_end;
> +	mutex_unlock(&tracer.mutex);
> +
> +	return n;
> +}
> +
> +
> +static struct kobj_attribute trace_range_attr =
> +	__ATTR(trace_range, 0644, trace_range_show, trace_range_store);
> +
>  static int __init etm_probe(struct amba_device *dev, struct amba_id *id)
>  {
>  	struct tracectx *t = &tracer;
> @@ -576,6 +614,10 @@ static int __init etm_probe(struct amba_device *dev, struct amba_id *id)
>  	if (ret)
>  		dev_dbg(&dev->dev, "Failed to create trace_mode in sysfs\n");
>  
> +	ret = sysfs_create_file(&dev->dev.kobj, &trace_range_attr.attr);
> +	if (ret)
> +		dev_dbg(&dev->dev, "Failed to create trace_range in sysfs\n");
> +
>  	dev_dbg(t->dev, "ETM AMBA driver initialized.\n");
>  
>  out:
> @@ -605,6 +647,7 @@ static int etm_remove(struct amba_device *dev)
>  	sysfs_remove_file(&dev->dev.kobj, &trace_running_attr.attr);
>  	sysfs_remove_file(&dev->dev.kobj, &trace_info_attr.attr);
>  	sysfs_remove_file(&dev->dev.kobj, &trace_mode_attr.attr);
> +	sysfs_remove_file(&dev->dev.kobj, &trace_range_attr.attr);
>  
>  	return 0;
>  }
> -- 
> 1.7.3.1
> 
