Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab0JMIJH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 04:09:07 -0400
Received: from smtp.nokia.com ([192.100.122.233]:21798 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901Ab0JMIJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 04:09:05 -0400
Message-ID: <4CB568C0.9030906@nokia.com>
Date: Wed, 13 Oct 2010 11:07:28 +0300
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Ball <cjb@laptop.org>, Andrew Morton <akpm@linux-foundation.org>,
        "Shevchenko Andriy (EXT-Teleca/Helsinki)" 
	<ext-andriy.shevchenko@nokia.com>
Subject: Re: [PATCH] mmc: append a file to change host clock at run time
References: <1286896642-27772-1-git-send-email-ext-andriy.shevchenko@nokia.com>
In-Reply-To: <1286896642-27772-1-git-send-email-ext-andriy.shevchenko@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Oct 2010 08:07:29.0651 (UTC) FILETIME=[AE4F4C30:01CB6AAD]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/10 18:17, Andy Shevchenko wrote:
> For debugging power managment features there is quite convenient to have a
> possibility to change MMC host controller clock at run time. This patch adds
> 'clock' file under MMC host root of debugfs.
>
> Usage as follows:
>
> 	# cat /sys/kernel/debug/mmc0/clock
> 	24000000
>
> 	# echo "1000000000">  /sys/kernel/debug/mmc0/clock
> 	# cat /sys/kernel/debug/mmc0/clock
> 	52000000
>
> 	# echo "48000000">  /sys/kernel/debug/mmc0/clock
> 	# cat /sys/kernel/debug/mmc0/clock
> 	48000000
>
> The second piece of example shows limits which are applied accordingly to used
> host driver.
>
> Signed-off-by: Andy Shevchenko<ext-andriy.shevchenko@nokia.com>
> ---
>   drivers/mmc/core/debugfs.c |   33 +++++++++++++++++++++++++++++++--
>   1 files changed, 31 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/mmc/core/debugfs.c b/drivers/mmc/core/debugfs.c
> index 96d10f4..4ff109f 100644
> --- a/drivers/mmc/core/debugfs.c
> +++ b/drivers/mmc/core/debugfs.c
> @@ -133,6 +133,31 @@ static const struct file_operations mmc_ios_fops = {
>   	.release	= single_release,
>   };
>
> +static int mmc_clock_opt_get(void *data, u64 *val)
> +{
> +	struct mmc_host *host = data;
> +
> +	*val = host->ios.clock;
> +
> +	return 0;
> +}
> +
> +static int mmc_clock_opt_set(void *data, u64 val)
> +{
> +	struct mmc_host *host = data;
> +
> +	/* We need this check due to input value is u64 */
> +	if (val>  host->f_max)
> +		return -EINVAL;
> +
> +	mmc_set_clock(host, (unsigned int) val);

Probably need to claim the host here otherwise you might
be changing the clock while a request is in progress

> +
> +	return 0;
> +}
> +
> +DEFINE_SIMPLE_ATTRIBUTE(mmc_clock_fops, mmc_clock_opt_get, mmc_clock_opt_set,
> +	"%llu\n");
> +
>   void mmc_add_host_debugfs(struct mmc_host *host)
>   {
>   	struct dentry *root;
> @@ -149,11 +174,15 @@ void mmc_add_host_debugfs(struct mmc_host *host)
>   	host->debugfs_root = root;
>
>   	if (!debugfs_create_file("ios", S_IRUSR, root, host,&mmc_ios_fops))
> -		goto err_ios;
> +		goto err_node;
> +
> +	if (!debugfs_create_file("clock", S_IRUSR | S_IWUSR, root, host,
> +			&mmc_clock_fops))
> +		goto err_node;
>
>   	return;
>
> -err_ios:
> +err_node:
>   	debugfs_remove_recursive(root);
>   	host->debugfs_root = NULL;
>   err_root:

