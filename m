Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269Ab0FIPhU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 11:37:20 -0400
Received: from cantor.suse.de ([195.135.220.2]:45294 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932078Ab0FIPhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 11:37:17 -0400
Subject: Re: [PATCH v4] pm_qos: make update_request non blocking
From: James Bottomley <James.Bottomley@suse.de>
To: florian@mickler.org
Cc: pm list <linux-pm@lists.linux-foundation.org>, markgross@thegnar.org,
       mgross@linux.intel.com, linville@tuxdriver.com,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1276097381-3982-1-git-send-email-florian@mickler.org>
References: <1276097381-3982-1-git-send-email-florian@mickler.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Jun 2010 11:37:12 -0400
Message-ID: <1276097832.4343.223.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-09 at 17:29 +0200, florian@mickler.org wrote:
> In order to allow drivers to use pm_qos_update_request from interrupt
> context we call the notifiers via schedule_work().
> 
> Signed-off-by: Florian Mickler <florian@mickler.org>
> ---
> 
> Well, this would be the schedule_work() alternative. 
> 
>  kernel/pm_qos_params.c |   47 ++++++++++++++++++++++++++++++-----------------
>  1 files changed, 30 insertions(+), 17 deletions(-)
> 
> diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
> index f42d3f7..296343a 100644
> --- a/kernel/pm_qos_params.c
> +++ b/kernel/pm_qos_params.c
> @@ -40,6 +40,7 @@
>  #include <linux/string.h>
>  #include <linux/platform_device.h>
>  #include <linux/init.h>
> +#include <linux/workqueue.h>
>  
>  #include <linux/uaccess.h>
>  
> @@ -60,11 +61,13 @@ struct pm_qos_request_list {
>  
>  static s32 max_compare(s32 v1, s32 v2);
>  static s32 min_compare(s32 v1, s32 v2);
> +static void update_notify(struct work_struct *work);
>  
>  struct pm_qos_object {
>  	struct pm_qos_request_list requests;
>  	struct blocking_notifier_head *notifiers;
>  	struct miscdevice pm_qos_power_miscdev;
> +	struct work_struct notify;
>  	char *name;
>  	s32 default_value;
>  	atomic_t target_value;
> @@ -72,10 +75,12 @@ struct pm_qos_object {
>  };
>  
>  static struct pm_qos_object null_pm_qos;
> +
>  static BLOCKING_NOTIFIER_HEAD(cpu_dma_lat_notifier);
>  static struct pm_qos_object cpu_dma_pm_qos = {
>  	.requests = {LIST_HEAD_INIT(cpu_dma_pm_qos.requests.list)},
>  	.notifiers = &cpu_dma_lat_notifier,
> +	.notify = __WORK_INITIALIZER(cpu_dma_pm_qos.notify, update_notify),
>  	.name = "cpu_dma_latency",
>  	.default_value = 2000 * USEC_PER_SEC,
>  	.target_value = ATOMIC_INIT(2000 * USEC_PER_SEC),
> @@ -86,6 +91,7 @@ static BLOCKING_NOTIFIER_HEAD(network_lat_notifier);
>  static struct pm_qos_object network_lat_pm_qos = {
>  	.requests = {LIST_HEAD_INIT(network_lat_pm_qos.requests.list)},
>  	.notifiers = &network_lat_notifier,
> +	.notify = __WORK_INITIALIZER(network_lat_pm_qos.notify, update_notify),
>  	.name = "network_latency",
>  	.default_value = 2000 * USEC_PER_SEC,
>  	.target_value = ATOMIC_INIT(2000 * USEC_PER_SEC),
> @@ -97,13 +103,14 @@ static BLOCKING_NOTIFIER_HEAD(network_throughput_notifier);
>  static struct pm_qos_object network_throughput_pm_qos = {
>  	.requests = {LIST_HEAD_INIT(network_throughput_pm_qos.requests.list)},
>  	.notifiers = &network_throughput_notifier,
> +	.notify = __WORK_INITIALIZER(network_throughput_pm_qos.notify,
> +			update_notify),
>  	.name = "network_throughput",
>  	.default_value = 0,
>  	.target_value = ATOMIC_INIT(0),
>  	.comparitor = max_compare
>  };
>  
> -
>  static struct pm_qos_object *pm_qos_array[] = {
>  	&null_pm_qos,
>  	&cpu_dma_pm_qos,
> @@ -135,35 +142,40 @@ static s32 min_compare(s32 v1, s32 v2)
>  	return min(v1, v2);
>  }
>  
> +static void update_notify(struct work_struct *work)
> +{
> +	struct pm_qos_object *obj =
> +		container_of(work, struct pm_qos_object, notify);
> +
> +	s32 extreme_value = atomic_read(&obj->target_value);
> +	blocking_notifier_call_chain(
> +		obj->notifiers,
> +			(unsigned long) extreme_value, NULL);
> +}
>  
>  static void update_target(int pm_qos_class)
>  {
>  	s32 extreme_value;
>  	struct pm_qos_request_list *node;
> +	struct pm_qos_object *obj = pm_qos_array[pm_qos_class];
>  	unsigned long flags;
>  	int call_notifier = 0;
>  
>  	spin_lock_irqsave(&pm_qos_lock, flags);
> -	extreme_value = pm_qos_array[pm_qos_class]->default_value;
> -	list_for_each_entry(node,
> -			&pm_qos_array[pm_qos_class]->requests.list, list) {
> -		extreme_value = pm_qos_array[pm_qos_class]->comparitor(
> -				extreme_value, node->value);
> -	}
> -	if (atomic_read(&pm_qos_array[pm_qos_class]->target_value) !=
> -			extreme_value) {
> +	extreme_value = obj->default_value;
> +	list_for_each_entry(node, &obj->requests.list, list)
> +		extreme_value = obj->comparitor(extreme_value, node->value);
> +
> +	if (atomic_read(&obj->target_value) != extreme_value) {
>  		call_notifier = 1;
> -		atomic_set(&pm_qos_array[pm_qos_class]->target_value,
> -				extreme_value);
> +		atomic_set(&obj->target_value, extreme_value);
>  		pr_debug(KERN_ERR "new target for qos %d is %d\n", pm_qos_class,
> -			atomic_read(&pm_qos_array[pm_qos_class]->target_value));
> +			atomic_read(&obj->target_value));
>  	}
>  	spin_unlock_irqrestore(&pm_qos_lock, flags);
>  
>  	if (call_notifier)
> -		blocking_notifier_call_chain(
> -				pm_qos_array[pm_qos_class]->notifiers,
> -					(unsigned long) extreme_value, NULL);
> +		schedule_work(&obj->notify);
>  }

This still isn't resilient against two successive calls to update.  If
the second one gets to schedule_work() before the work of the first one
has finished, you'll corrupt the workqueue.

The mechanisms to solve this race (refcounting a pool of structures) are
so heavyweight that I concluded it was simpler just to have atomically
updated pm_qos objects and enforce it ... rather than trying to allow
blocking chains to be added to atomic sites via a workqueue.

James


