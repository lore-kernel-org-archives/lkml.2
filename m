Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750948Ab1BJFKx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 00:10:53 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:33149 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab1BJFKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 00:10:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:reply-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=pojqRmRvgMHiihuNgM8WnyemvEHAlLxjoAZ8tRW28YOYqdhfA5tFboy1Haf8fRAYrz
         OaSIXYfdEzoDzjHxK4c4lIW7/45UBxdI2ZhDCj5dhE/Bq6YANCgqdtRNL9mTM7NPgI1u
         ClDQ740m3gCqGBsFbmx1tmzZ9mWkjQrl8qgeI=
Date: Wed, 9 Feb 2011 21:10:42 -0800
From: mark gross <markgross@thegnar.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, mark gross <markgross@thegnar.org>,
        James Bottomley <James.Bottomley@suse.de>,
        David Alan Gilbert <linux@treblig.org>, linux-kernel@vger.kernel.org,
        Len <len.brown@intel.com>, Andi Kleen <ak@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [Patch] idle governor: Avoid lock acquisition to read pm_qos
 before entering idle
Message-ID: <20110210051042.GC4897@gvim.org>
Reply-To: markgross@thegnar.org
References: <1297300864.2645.128.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297300864.2645.128.camel@schen9-DESK>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 09, 2011 at 05:21:04PM -0800, Tim Chen wrote:
> I noticed that before entering idle state, the menu idle governor will
> look up the current pm_qos value according to the list of qos request
> received.  This look up currently needs the acquisition of a lock to go
> down a list of qos requests to find the qos value, slowing down the

wait a second... It gets the target_value (that is an atomic variable)
humpf.  I was looking at 2.6.35, where this is true.  If you want to put
back a target_value why not put it back the way it was?

> entrance into idle state due to contention by multiple cpus to traverse
> this list.  The contention is severe when there are a lot of cpus waking
> and going into idle.  For example, for a simple workload that has 32
> pair of processes ping ponging messages to each other, where 64 cores
> cores are active in test system, I see the following profile:
> 
> -     37.82%          swapper  [kernel.kallsyms]          [k]
> _raw_spin_lock_irqsave
>    - _raw_spin_lock_irqsave
>       - 95.65% pm_qos_request             
>            menu_select                                             
>            cpuidle_idle_call                      
>          - cpu_idle                                                     
>               99.98% start_secondary
> 

I'm surprised by this as the last update to the pm_qos replaced the
lists with a O(1) data structure so there was no more walking of pending
requests.

What is the profile after the patch the Plist should be only one
dereference and an if instruction slower than a cached value.

Does your patch remove the need for the locks because if it doesn't I
don't see how it will make much of a difference?

> Perhaps a better approach will be to cache the updated pm_qos value so
> reading it does not require lock acquisition as in the patch below.   

See v2.6.35 for an possible instance of the better approach.

> 
> Tim
> 
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> diff --git a/include/linux/pm_qos_params.h b/include/linux/pm_qos_params.h
> index 77cbddb..a7d87f9 100644
> --- a/include/linux/pm_qos_params.h
> +++ b/include/linux/pm_qos_params.h
> @@ -16,6 +16,10 @@
>  #define PM_QOS_NUM_CLASSES 4
>  #define PM_QOS_DEFAULT_VALUE -1
>  
> +#define PM_QOS_CPU_DMA_LAT_DEFAULT_VALUE	(2000 * USEC_PER_SEC)
> +#define PM_QOS_NETWORK_LAT_DEFAULT_VALUE	(2000 * USEC_PER_SEC)
> +#define PM_QOS_NETWORK_THROUGHPUT_DEFAULT_VALUE	0
> +
>  struct pm_qos_request_list {
>  	struct plist_node list;
>  	int pm_qos_class;
> diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
> index aeaa7f8..b6310d1 100644
> --- a/kernel/pm_qos_params.c
> +++ b/kernel/pm_qos_params.c
> @@ -58,6 +58,7 @@ struct pm_qos_object {
>  	struct blocking_notifier_head *notifiers;
>  	struct miscdevice pm_qos_power_miscdev;
>  	char *name;
> +	s32 value;
>  	s32 default_value;
>  	enum pm_qos_type type;
>  };
> @@ -70,7 +71,8 @@ static struct pm_qos_object cpu_dma_pm_qos = {
>  	.requests = PLIST_HEAD_INIT(cpu_dma_pm_qos.requests, pm_qos_lock),
>  	.notifiers = &cpu_dma_lat_notifier,
>  	.name = "cpu_dma_latency",
> -	.default_value = 2000 * USEC_PER_SEC,
> +	.value = PM_QOS_CPU_DMA_LAT_DEFAULT_VALUE,
> +	.default_value = PM_QOS_CPU_DMA_LAT_DEFAULT_VALUE,
>  	.type = PM_QOS_MIN,
>  };
>  
> @@ -79,7 +81,8 @@ static struct pm_qos_object network_lat_pm_qos = {
>  	.requests = PLIST_HEAD_INIT(network_lat_pm_qos.requests, pm_qos_lock),
>  	.notifiers = &network_lat_notifier,
>  	.name = "network_latency",
> -	.default_value = 2000 * USEC_PER_SEC,
> +	.value = PM_QOS_NETWORK_LAT_DEFAULT_VALUE,
> +	.default_value = PM_QOS_NETWORK_LAT_DEFAULT_VALUE,
>  	.type = PM_QOS_MIN
>  };
>  
> @@ -89,7 +92,8 @@ static struct pm_qos_object network_throughput_pm_qos = {
>  	.requests = PLIST_HEAD_INIT(network_throughput_pm_qos.requests, pm_qos_lock),
>  	.notifiers = &network_throughput_notifier,
>  	.name = "network_throughput",
> -	.default_value = 0,
> +	.value = PM_QOS_NETWORK_THROUGHPUT_DEFAULT_VALUE,
> +	.default_value = PM_QOS_NETWORK_THROUGHPUT_DEFAULT_VALUE,
>  	.type = PM_QOS_MAX,
>  };
>  
> @@ -132,6 +136,16 @@ static inline int pm_qos_get_value(struct pm_qos_object *o)
>  	}
>  }
>  
> +static inline s32 pm_qos_read_value(struct pm_qos_object *o)
> +{
> +	return o->value;
> +}
> +
> +static inline int pm_qos_set_value(struct pm_qos_object *o, s32 value)
> +{
> +	o->value = value;
> +}
> +
>  static void update_target(struct pm_qos_object *o, struct plist_node *node,
>  			  int del, int value)
>  {
> @@ -156,6 +170,7 @@ static void update_target(struct pm_qos_object *o, struct plist_node *node,
>  		plist_add(node, &o->requests);
>  	}
>  	curr_value = pm_qos_get_value(o);
> +	pm_qos_set_value(o, curr_value);
>  	spin_unlock_irqrestore(&pm_qos_lock, flags);
>  
>  	if (prev_value != curr_value)
> @@ -190,18 +205,11 @@ static int find_pm_qos_object_by_minor(int minor)
>   * pm_qos_request - returns current system wide qos expectation
>   * @pm_qos_class: identification of which qos value is requested
>   *
> - * This function returns the current target value in an atomic manner.
> + * This function returns the current target value.
>   */
>  int pm_qos_request(int pm_qos_class)
>  {
> -	unsigned long flags;
> -	int value;
> -
> -	spin_lock_irqsave(&pm_qos_lock, flags);
> -	value = pm_qos_get_value(pm_qos_array[pm_qos_class]);
Hmmm, I was looking at 2.6.35 where we had the return of an
atomic value here.

what happened to the atomic value in the 2.6.35 kernel?

> -	spin_unlock_irqrestore(&pm_qos_lock, flags);
> -
> -	return value;
> +	return pm_qos_read_value(pm_qos_array[pm_qos_class]);

why does this not need a lock?  This value is getting updated by
multiple CPU's concurrently  It probably should at least be an atomic
read like it used to be in 2.6.35.

it looks to me that your change is really just remove the locks around
the current QoS target.  The caching of the target to avoid hitting the
plist is really close to a noop.  

--mark
>  }
>  EXPORT_SYMBOL_GPL(pm_qos_request);
>  
> 
> 
