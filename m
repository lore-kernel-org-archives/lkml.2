Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab0JNB5a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 21:57:30 -0400
Received: from void.printf.net ([89.145.121.20]:39717 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325Ab0JNB53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 21:57:29 -0400
Date: Thu, 14 Oct 2010 02:57:26 +0100
From: Chris Ball <cjb@laptop.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Adrian Hunter <adrian.hunter@nokia.com>,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: Re: [PATCHv2] mmc: append a file to change host clock at run time
Message-ID: <20101014015726.GA3553@void.printf.net>
References: <4CB568C0.9030906@nokia.com> <1286958142-22461-1-git-send-email-ext-andriy.shevchenko@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286958142-22461-1-git-send-email-ext-andriy.shevchenko@nokia.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

On Wed, Oct 13, 2010 at 11:22:22AM +0300, Andy Shevchenko wrote:
> For debugging power managment features there is quite convenient to have a
> possibility to change MMC host controller clock at run time. This patch adds
> 'clock' file under MMC host root of debugfs.
> 
> Usage as follows:
> 
> 	# cat /sys/kernel/debug/mmc0/clock
> 	52000000
> 
> 	# echo "1000000000" > /sys/kernel/debug/mmc0/clock
> 	# cat /sys/kernel/debug/mmc0/clock
> 	52000000
> 
> 	# echo "48000000" > /sys/kernel/debug/mmc0/clock
> 	# cat /sys/kernel/debug/mmc0/clock
> 	48000000
> 
> The second piece of example shows limits which are applied accordingly to used
> host driver.
> 
> Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
> ---
>  drivers/mmc/core/debugfs.c |   35 +++++++++++++++++++++++++++++++++--
>  1 files changed, 33 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mmc/core/debugfs.c b/drivers/mmc/core/debugfs.c
> index 96d10f4..9b6ec07 100644
> --- a/drivers/mmc/core/debugfs.c
> +++ b/drivers/mmc/core/debugfs.c
> @@ -133,6 +133,33 @@ static const struct file_operations mmc_ios_fops = {
>  	.release	= single_release,
>  };
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
> +	if (val > host->f_max)
> +		return -EINVAL;
> +
> +	mmc_claim_host(host);
> +	mmc_set_clock(host, (unsigned int) val);
> +	mmc_release_host(host);
> +
> +	return 0;
> +}
> +
> +DEFINE_SIMPLE_ATTRIBUTE(mmc_clock_fops, mmc_clock_opt_get, mmc_clock_opt_set,
> +	"%llu\n");
> +
>  void mmc_add_host_debugfs(struct mmc_host *host)
>  {
>  	struct dentry *root;
> @@ -149,11 +176,15 @@ void mmc_add_host_debugfs(struct mmc_host *host)
>  	host->debugfs_root = root;
>  
>  	if (!debugfs_create_file("ios", S_IRUSR, root, host, &mmc_ios_fops))
> -		goto err_ios;
> +		goto err_node;
> +
> +	if (!debugfs_create_file("clock", S_IRUSR | S_IWUSR, root, host,
> +			&mmc_clock_fops))
> +		goto err_node;
>  
>  	return;
>  
> -err_ios:
> +err_node:
>  	debugfs_remove_recursive(root);
>  	host->debugfs_root = NULL;
>  err_root:
> -- 

Thanks, looks good -- applied to mmc-next with minor changelog edits.

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
