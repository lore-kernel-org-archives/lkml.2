Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab1GTAEC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 20:04:02 -0400
Received: from mga14.intel.com ([143.182.124.37]:37227 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102Ab1GTAEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 20:04:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,231,1309762800"; 
   d="scan'208";a="29189698"
Message-ID: <4E261B7F.8020002@linux.intel.com>
Date: Tue, 19 Jul 2011 17:04:15 -0700
From: J Freyensee <james_p_freyensee@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110628 Thunderbird/5.0
MIME-Version: 1.0
To: Per Forlin <per.forlin@linaro.org>
CC: linaro-dev@lists.linaro.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-doc@vger.kernel.org,
        Venkatraman S <svenkatr@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Sourav Poddar <sourav.poddar@ti.com>,
        Chris Ball <cjb@laptop.org>, Akinobu Mita <akinobu.mita@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH v2 2/3] mmc: core: add random fault injection
References: <1311111106-26814-1-git-send-email-per.forlin@linaro.org> <1311111106-26814-3-git-send-email-per.forlin@linaro.org>
In-Reply-To: <1311111106-26814-3-git-send-email-per.forlin@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2011 02:31 PM, Per Forlin wrote:
> This adds support to inject data errors after a completed host transfer.
> The mmc core will return error even though the host transfer is successful.
> This simple fault injection proved to be very useful to test the
> non-blocking error handling in the mmc_blk_issue_rw_rq().
> Random faults can also test how the host driver handles pre_req()
> and post_req() in case of errors.
>
> Signed-off-by: Per Forlin<per.forlin@linaro.org>
> ---
>   drivers/mmc/core/core.c    |   58 ++++++++++++++++++++++++++++++++++++++++++++
>   drivers/mmc/core/debugfs.c |    5 ++++
>   include/linux/mmc/host.h   |    3 ++
>   lib/Kconfig.debug          |   11 ++++++++
>   4 files changed, 77 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index ab36c7b..3f822b4 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -23,6 +23,8 @@
>   #include<linux/log2.h>
>   #include<linux/regulator/consumer.h>
>   #include<linux/pm_runtime.h>
> +#include<linux/fault-inject.h>
> +#include<linux/random.h>
>

As a suggestion, would you want to also use '#ifdef 
CONFIG_FAIL_MMC_REQUEST' for fault-inject.h and random.h?  If they are 
not used in a non-debug linux kernel configuration, could this possibly 
cause a little extra code bloat if they are a part of a production Linux 
kernel compile/configuration?

>   #include<linux/mmc/card.h>
>   #include<linux/mmc/host.h>
> @@ -82,6 +84,58 @@ static void mmc_flush_scheduled_work(void)
>   	flush_workqueue(workqueue);
>   }
>
> +#ifdef CONFIG_FAIL_MMC_REQUEST
> +
> +static DECLARE_FAULT_ATTR(fail_mmc_request);
> +
> +static int __init setup_fail_mmc_request(char *str)

Function comment header somewhere (here or the .h file?)

> +{
> +	return setup_fault_attr(&fail_mmc_request, str);
> +}
> +__setup("fail_mmc_request=", setup_fail_mmc_request);
> +
> +static void mmc_should_fail_request(struct mmc_host *host,
> +				    struct mmc_request *mrq)
> +{

Function comment header somewhere (here or the .h file)?

> +	struct mmc_command *cmd = mrq->cmd;
> +	struct mmc_data *data = mrq->data;
> +	static const int data_errors[] = {
> +		-ETIMEDOUT,
> +		-EILSEQ,
> +		-EIO,
> +	};
> +
> +	if (!data)
> +		return;
> +

Should 'if (!cmd)' also be checked or is this guaranteed to always have 
a valid value for this function (and if there are certain commands in 
'struct mmc_command *cmd = mrq->cmd' that will not work with this 
function then that is something that should be documented in the 
function comment header)?

> +	if (cmd->error || data->error || !host->make_it_fail ||
> +	    !should_fail(&fail_mmc_request, data->blksz * data->blocks))
> +		return;
> +
> +	data->error = data_errors[random32() % ARRAY_SIZE(data_errors)];
> +	data->bytes_xfered = (random32() % (data->bytes_xfered>>  9))<<  9;
> +}
> +
> +static int __init fail_mmc_request_debugfs(void)
> +{
> +	return init_fault_attr_dentries(&fail_mmc_request,
> +					"fail_mmc_request");
> +}
> +
> +#else /* CONFIG_FAIL_MMC_REQUEST */
> +
> +static void mmc_should_fail_request(struct mmc_host *host,
> +				    struct mmc_request *mrq)
> +{
> +}
> +
> +static int __init fail_mmc_request_debugfs(void)
> +{
> +	return 0;
> +}
> +#endif /* CONFIG_FAIL_MMC_REQUEST */
> +
> +
>   /**
>    *	mmc_request_done - finish processing an MMC request
>    *	@host: MMC host which completed request
> @@ -108,6 +162,8 @@ void mmc_request_done(struct mmc_host *host, struct mmc_request *mrq)
>   		cmd->error = 0;
>   		host->ops->request(host, mrq);
>   	} else {
> +		mmc_should_fail_request(host, mrq);
> +
>   		led_trigger_event(host->led, LED_OFF);
>
>   		pr_debug("%s: req done (CMD%u): %d: %08x %08x %08x %08x\n",
> @@ -2064,6 +2120,8 @@ static int __init mmc_init(void)
>   	if (ret)
>   		goto unregister_host_class;
>
> +	fail_mmc_request_debugfs();
> +
>   	return 0;
>
>   unregister_host_class:
> diff --git a/drivers/mmc/core/debugfs.c b/drivers/mmc/core/debugfs.c
> index 998797e..588e76f 100644
> --- a/drivers/mmc/core/debugfs.c
> +++ b/drivers/mmc/core/debugfs.c
> @@ -188,6 +188,11 @@ void mmc_add_host_debugfs(struct mmc_host *host)
>   				root,&host->clk_delay))
>   		goto err_node;
>   #endif
> +#ifdef CONFIG_FAIL_MMC_REQUEST
> +	if (!debugfs_create_u8("make-it-fail", S_IRUSR | S_IWUSR,
> +			       root,&host->make_it_fail))
> +		goto err_node;
> +#endif
>   	return;
>
>   err_node:
> diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
> index 771455f..250b46d 100644
> --- a/include/linux/mmc/host.h
> +++ b/include/linux/mmc/host.h
> @@ -303,6 +303,9 @@ struct mmc_host {
>
>   	struct mmc_async_req	*areq;		/* active async req */
>
> +#ifdef CONFIG_FAIL_MMC_REQUEST
> +	u8			make_it_fail;
> +#endif
>   	unsigned long		private[0] ____cacheline_aligned;
>   };
>
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index c768bcd..c2d1423 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -1057,6 +1057,17 @@ config FAIL_IO_TIMEOUT
>   	  Only works with drivers that use the generic timeout handling,
>   	  for others it wont do anything.
>
> +config FAIL_MMC_REQUEST
> +	bool "Fault-injection capability for MMC IO"
> +	select DEBUG_FS
> +	depends on FAULT_INJECTION&&  MMC
> +	help
> +	  Provide fault-injection capability for MMC IO.
> +	  This will make the mmc core return data errors. This is
> +	  useful to test the error handling in the mmc block device
> +	  and to test how the mmc host driver handles retries from
> +	  the block device.
> +
>   config FAULT_INJECTION_DEBUG_FS
>   	bool "Debugfs entries for fault-injection capabilities"
>   	depends on FAULT_INJECTION&&  SYSFS&&  DEBUG_FS


-- 
J (James/Jay) Freyensee
Storage Technology Group
Intel Corporation
