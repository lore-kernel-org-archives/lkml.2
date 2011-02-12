Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab1BLGft (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 01:35:49 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64292 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab1BLGfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 01:35:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:reply-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=fU/oEdUrUxz2mNvatdfhwV3JBZQky3sHR3F+lKdWapwCctF5jyNF3exZz1LOI63uI2
         eIkt6b65gqKunz9yTb56FWrZMim1CzaL5aUbHlUlG9T6h2Ez3sIR7Jgc+IwKCNt/JNar
         Z46WFiMnOHTjnfwBVMpHYBt8tlEy7P6XYnzek=
Date: Fri, 11 Feb 2011 22:35:24 -0800
From: mark gross <markgross@thegnar.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: James Bottomley <James.Bottomley@suse.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, mark gross <markgross@thegnar.org>,
        David Alan Gilbert <linux@treblig.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>, Len Brown <lenb@kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [Patch v2] idle governor: Avoid lock acquisition to read
 pm_qos before entering idle
Message-ID: <20110212063524.GA15289@gvim.org>
Reply-To: markgross@thegnar.org
References: <1297457344.2645.323.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297457344.2645.323.camel@schen9-DESK>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11, 2011 at 12:49:04PM -0800, Tim Chen wrote:
> Thanks to the reviews and comments by Rafael, James, Mark and Andi.
> Here's version 2 of the patch incorporating your comments and also some
> update to my previous patch comments.
> 
> I noticed that before entering idle state, the menu idle governor will
> look up the current pm_qos target value according to the list of qos
> requests received.  This look up currently needs the acquisition of a
> lock to access the list of qos requests to find the qos target value,
> slowing down the entrance into idle state due to contention by multiple
> cpus to access this list.  The contention is severe when there are a lot
> of cpus waking and going into idle.  For example, for a simple workload
> that has 32 pair of processes ping ponging messages to each other, where
> 64 cpu cores are active in test system, I see the following profile with
> 37.82% of cpu cycles spent in contention of pm_qos_lock:
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
> A better approach will be to cache the updated pm_qos target value so
> reading it does not require lock acquisition as in the patch below.  
> With this patch the contention for pm_qos_lock is removed and I saw a
> 2.2X increase in throughput for my message passing workload. 
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
> index aeaa7f8..6a8fad8 100644
> --- a/kernel/pm_qos_params.c
> +++ b/kernel/pm_qos_params.c
> @@ -53,11 +53,17 @@ enum pm_qos_type {
>  	PM_QOS_MIN		/* return the smallest value */
>  };
>  
> +/*
> + * Note: The lockless read path depends on the CPU accessing
> + * target_value atomically.  Atomic access is only guaranteed on all CPU
> + * types linux supports for 32 bit quantites
> + */
>  struct pm_qos_object {
>  	struct plist_head requests;
>  	struct blocking_notifier_head *notifiers;
>  	struct miscdevice pm_qos_power_miscdev;
>  	char *name;
> +	s32 target_value;	/* Do not change to 64 bit */
>  	s32 default_value;
>  	enum pm_qos_type type;
>  };
> @@ -70,7 +76,8 @@ static struct pm_qos_object cpu_dma_pm_qos = {
>  	.requests = PLIST_HEAD_INIT(cpu_dma_pm_qos.requests, pm_qos_lock),
>  	.notifiers = &cpu_dma_lat_notifier,
>  	.name = "cpu_dma_latency",
> -	.default_value = 2000 * USEC_PER_SEC,
> +	.target_value = PM_QOS_CPU_DMA_LAT_DEFAULT_VALUE,
> +	.default_value = PM_QOS_CPU_DMA_LAT_DEFAULT_VALUE,
>  	.type = PM_QOS_MIN,
>  };
>  
> @@ -79,7 +86,8 @@ static struct pm_qos_object network_lat_pm_qos = {
>  	.requests = PLIST_HEAD_INIT(network_lat_pm_qos.requests, pm_qos_lock),
>  	.notifiers = &network_lat_notifier,
>  	.name = "network_latency",
> -	.default_value = 2000 * USEC_PER_SEC,
> +	.target_value = PM_QOS_NETWORK_LAT_DEFAULT_VALUE,
> +	.default_value = PM_QOS_NETWORK_LAT_DEFAULT_VALUE,
>  	.type = PM_QOS_MIN
>  };
>  
> @@ -89,7 +97,8 @@ static struct pm_qos_object network_throughput_pm_qos = {
>  	.requests = PLIST_HEAD_INIT(network_throughput_pm_qos.requests, pm_qos_lock),
>  	.notifiers = &network_throughput_notifier,
>  	.name = "network_throughput",
> -	.default_value = 0,
> +	.target_value = PM_QOS_NETWORK_THROUGHPUT_DEFAULT_VALUE,
> +	.default_value = PM_QOS_NETWORK_THROUGHPUT_DEFAULT_VALUE,
>  	.type = PM_QOS_MAX,
>  };
>  
> @@ -132,6 +141,16 @@ static inline int pm_qos_get_value(struct pm_qos_object *o)
>  	}
>  }
>  
> +static inline s32 pm_qos_read_value(struct pm_qos_object *o)
> +{
> +	return o->target_value;
> +}
> +
> +static inline void pm_qos_set_value(struct pm_qos_object *o, s32 value)
> +{
> +	o->target_value = value;
> +}
> +
>  static void update_target(struct pm_qos_object *o, struct plist_node *node,
>  			  int del, int value)
>  {
> @@ -156,6 +175,7 @@ static void update_target(struct pm_qos_object *o, struct plist_node *node,
>  		plist_add(node, &o->requests);
>  	}
>  	curr_value = pm_qos_get_value(o);
> +	pm_qos_set_value(o, curr_value);
>  	spin_unlock_irqrestore(&pm_qos_lock, flags);
>  
>  	if (prev_value != curr_value)
> @@ -190,18 +210,11 @@ static int find_pm_qos_object_by_minor(int minor)
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
> -	spin_unlock_irqrestore(&pm_qos_lock, flags);
> -
> -	return value;
> +	return pm_qos_read_value(pm_qos_array[pm_qos_class]);
>  }
>  EXPORT_SYMBOL_GPL(pm_qos_request);
>  
> 
>
Ack --mark
:wq
 
