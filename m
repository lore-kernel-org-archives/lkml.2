Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030723Ab2HHTbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 15:31:55 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:49342 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758666Ab2HHTbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 15:31:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: Re: [PATCH] PM QoS: Add a metric : Bus Throughput.
Date: Wed, 8 Aug 2012 21:37:46 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
References: <1344413691-808-1-git-send-email-jonghwa3.lee@samsung.com>
In-Reply-To: <1344413691-808-1-git-send-email-jonghwa3.lee@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201208082137.46553.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 08, 2012, Jonghwa Lee wrote:
> Bus throughput metric is added to PM QoS in order to control the
> frequency of memory interfaces and busses with PM QoS.
> 
> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

I said some time ago I didn't want any new global PM QoS classes to be
added this way.

Can you please post a driver patch using this new thing?

Rafael


> ---
>  include/linux/pm_qos.h |    2 ++
>  kernel/power/qos.c     |   15 ++++++++++++++-
>  2 files changed, 16 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/pm_qos.h b/include/linux/pm_qos.h
> index 233149c..6db4939 100644
> --- a/include/linux/pm_qos.h
> +++ b/include/linux/pm_qos.h
> @@ -15,6 +15,7 @@ enum {
>  	PM_QOS_CPU_DMA_LATENCY,
>  	PM_QOS_NETWORK_LATENCY,
>  	PM_QOS_NETWORK_THROUGHPUT,
> +	PM_QOS_BUS_DMA_THROUGHPUT,
>  
>  	/* insert new class ID */
>  	PM_QOS_NUM_CLASSES,
> @@ -26,6 +27,7 @@ enum {
>  #define PM_QOS_NETWORK_LAT_DEFAULT_VALUE	(2000 * USEC_PER_SEC)
>  #define PM_QOS_NETWORK_THROUGHPUT_DEFAULT_VALUE	0
>  #define PM_QOS_DEV_LAT_DEFAULT_VALUE		0
> +#define	PM_QOS_BUS_DMA_THROUGHPUT_DEFAULT_VALUE	0
>  
>  struct pm_qos_request {
>  	struct plist_node node;
> diff --git a/kernel/power/qos.c b/kernel/power/qos.c
> index 6a031e6..75322cc 100644
> --- a/kernel/power/qos.c
> +++ b/kernel/power/qos.c
> @@ -100,12 +100,25 @@ static struct pm_qos_object network_throughput_pm_qos = {
>  	.name = "network_throughput",
>  };
>  
> +static BLOCKING_NOTIFIER_HEAD(bus_dma_throughput_notifier);
> +static struct pm_qos_constraints bus_dma_tput_constraints = {
> +	.list = PLIST_HEAD_INIT(bus_dma_tput_constraints.list),
> +	.target_value = PM_QOS_BUS_DMA_THROUGHPUT_DEFAULT_VALUE,
> +	.default_value = PM_QOS_BUS_DMA_THROUGHPUT_DEFAULT_VALUE,
> +	.type = PM_QOS_MAX,
> +	.notifiers = &bus_dma_throughput_notifier,
> +};
> +static struct pm_qos_object bus_dma_throughput_pm_qos = {
> +	.constraints = &bus_dma_tput_constraints,
> +	.name = "bus_dma_throughput",
> +};
>  
>  static struct pm_qos_object *pm_qos_array[] = {
>  	&null_pm_qos,
>  	&cpu_dma_pm_qos,
>  	&network_lat_pm_qos,
> -	&network_throughput_pm_qos
> +	&network_throughput_pm_qos,
> +	&bus_dma_throughput_pm_qos,
>  };
>  
>  static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
> 

