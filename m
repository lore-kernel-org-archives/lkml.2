Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab1GBV5u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 17:57:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50549 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754728Ab1GBV5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 17:57:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH v3 2/3] PM / DEVFREQ: add example governors
Date: Sat, 2 Jul 2011 23:58:58 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Jiejing Zhang <kzjeef@gmail.com>, Colin Cross <ccross@google.com>,
        Nishanth Menon <nm@ti.com>, Thomas Gleixner <tglx@linutronix.de>,
        myungjoo.ham@gmail.com
References: <1306471995-4048-1-git-send-email-myungjoo.ham@samsung.com> <1306471995-4048-2-git-send-email-myungjoo.ham@samsung.com>
In-Reply-To: <1306471995-4048-2-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201107022358.58319.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday, May 27, 2011, MyungJoo Ham wrote:
> Three CPUFREQ-like governors are provided as examples.
> 
> powersave: use the lowest frequency possible. The user (device) should
> set the polling_ms as 0 because polling is useless for this governor.
> 
> performance: use the highest freqeuncy possible. The user (device)
> should set the polling_ms as 0 because polling is useless for this
> governor.
> 
> simple_ondemand: simplified version of CPUFREQ's ONDEMAND governor.
> 
> When a user updates OPP entries (enable/disable/add), OPP framework
> automatically notifies DEVFREQ to update operating frequency
> accordingly. Thus, DEVFREQ users (device drivers) do not need to update
> DEVFREQ manually with OPP entry updates or set polling_ms for powersave
> , performance, or any other "static" governors.
> 
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/base/power/devfreq.c |   69 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/devfreq.h      |    5 +++
>  2 files changed, 74 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/base/power/devfreq.c b/drivers/base/power/devfreq.c
> index 883d953..7648a94 100644
> --- a/drivers/base/power/devfreq.c
> +++ b/drivers/base/power/devfreq.c
> @@ -395,3 +395,72 @@ static int __init devfreq_init(void)
>  	return 0;
>  }
>  late_initcall(devfreq_init);
> +
> +static int devfreq_powersave_func(struct devfreq *df,
> +				  unsigned long *freq)
> +{
> +	*freq = 0; /* devfreq_do will run "ceiling" to 0 */
> +	return 0;
> +}
> +
> +struct devfreq_governor devfreq_powersave = {
> +	.get_target_freq = devfreq_powersave_func,
> +};
> +
> +static int devfreq_performance_func(struct devfreq *df,
> +				    unsigned long *freq)
> +{
> +	*freq = UINT_MAX; /* devfreq_do will run "floor" */
> +	return 0;
> +}
> +
> +struct devfreq_governor devfreq_performance = {
> +	.get_target_freq = devfreq_performance_func,
> +};
> +
> +/* Constants for DevFreq-Simple-Ondemand (DFSO) */
> +#define DFSO_UPTHRESHOLD	(90)
> +#define DFSO_DOWNDIFFERENCTIAL	(5)
> +static int devfreq_simple_ondemand_func(struct devfreq *df,
> +					unsigned long *freq)
> +{
> +	struct devfreq_dev_status stat;
> +	int err = df->profile->get_dev_status(df->dev, &stat);
> +	unsigned long long a, b;
> +
> +	if (err)
> +		return err;
> +
> +	/* Set MAX if it's busy enough */
> +	if (stat.busy_time * 100 >
> +	    stat.total_time * DFSO_UPTHRESHOLD) {
> +		*freq = UINT_MAX;
> +		return 0;
> +	}
> +
> +	/* Set MAX if we do not know the initial frequency */
> +	if (stat.current_frequency == 0) {
> +		*freq = UINT_MAX;
> +		return 0;
> +	}
> +
> +	/* Keep the current frequency */
> +	if (stat.busy_time * 100 >
> +	    stat.total_time * (DFSO_UPTHRESHOLD - DFSO_DOWNDIFFERENCTIAL)) {
> +		*freq = stat.current_frequency;
> +		return 0;
> +	}
> +
> +	/* Set the desired frequency based on the load */
> +	a = (unsigned long long) stat.busy_time * stat.current_frequency;

What's the purpose of the conversion?

> +	b = div_u64(a, stat.total_time);
> +	b *= 100;
> +	b = div_u64(b, (DFSO_UPTHRESHOLD - DFSO_DOWNDIFFERENCTIAL / 2));
> +	*freq = (unsigned long) b;
> +
> +	return 0;
> +}

Rafael
