Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab2JQWOL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 18:14:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54406 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab2JQWOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 18:14:09 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Nishanth Menon <nm@ti.com>
Cc: <linux-pm@vger.kernel.org>, MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PM / OPP: predictable fail results for opp_find* functions
Organization: Deep Root Systems, LLC
References: <1349962803-19674-1-git-send-email-nm@ti.com>
Date: Wed, 17 Oct 2012 15:14:22 -0700
In-Reply-To: <1349962803-19674-1-git-send-email-nm@ti.com> (Nishanth Menon's
	message of "Thu, 11 Oct 2012 08:40:03 -0500")
Message-ID: <87obk0kapt.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nishanth Menon <nm@ti.com> writes:

> Currently the opp_find* functions return -ENODEV when:
> a) it cant find a device (e.g. request for an OPP search on device
>    which was not registered)
> b) When it cant find a match for the search strategy used
>
> This makes life a little in-efficient for users such as devfreq
> to make reasonable judgement before switching search strategies.
>
> So, standardize the return results as following:
>  -EINVAL for bad pointer parameters
>  -ENODEV when device cannot be found
>  -ERANGE when search fails
>
> This has the following benefit for devfreq implementation:
>
> Current code:
> opp = opp_find_freq_floor(dev, freq);
> /* Following search triggers even for un-registered device */
> if (opp == ERR_PTR(-ENODEV))
> 	opp = opp_find_freq_ceil(dev, freq);
>
> Vs (after this change):
> opp = opp_find_freq_floor(dev, freq);
> /* Will only be triggered if search logic fails: intended usage */
> if (opp == ERR_PTR(-ERANGE))
> 	opp = opp_find_freq_ceil(dev, freq);

I think the idea is fine but would prefer to see the benefits summarized
in words, rather than code.

Also, the changelog should describe that the patch not only changes the
meaning of return values, but also converts devfreq to use the new
values.

Otherwise, implementation looks fine.

Reviewed-by: Kevin Hilman <khilman@ti.com>

> Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: Kevin Hilman <khilman@ti.com>
> Cc: linux-pm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
>
> Signed-off-by: Nishanth Menon <nm@ti.com>
> ---
>  drivers/base/power/opp.c  |   27 +++++++++++++++++++--------
>  drivers/devfreq/devfreq.c |    4 ++--
>  2 files changed, 21 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
> index 04d443f..a60a8d1 100644
> --- a/drivers/base/power/opp.c
> +++ b/drivers/base/power/opp.c
> @@ -233,7 +233,10 @@ EXPORT_SYMBOL(opp_get_opp_count);
>   *
>   * Searches for exact match in the opp list and returns pointer to the matching
>   * opp if found, else returns ERR_PTR in case of error and should be handled
> - * using IS_ERR.
> + * using IS_ERR. Error return values can be:
> + * EINVAL:	for bad pointer
> + * ERANGE:	no match found for search
> + * ENODEV:	if device not found in list of registered devices
>   *
>   * Note: available is a modifier for the search. if available=true, then the
>   * match is for exact matching frequency and is available in the stored OPP
> @@ -252,7 +255,7 @@ struct opp *opp_find_freq_exact(struct device *dev, unsigned long freq,
>  				bool available)
>  {
>  	struct device_opp *dev_opp;
> -	struct opp *temp_opp, *opp = ERR_PTR(-ENODEV);
> +	struct opp *temp_opp, *opp = ERR_PTR(-ERANGE);
>  
>  	dev_opp = find_device_opp(dev);
>  	if (IS_ERR(dev_opp)) {
> @@ -282,7 +285,11 @@ EXPORT_SYMBOL(opp_find_freq_exact);
>   * for a device.
>   *
>   * Returns matching *opp and refreshes *freq accordingly, else returns
> - * ERR_PTR in case of error and should be handled using IS_ERR.
> + * ERR_PTR in case of error and should be handled using IS_ERR. Error return
> + * values can be:
> + * EINVAL:	for bad pointer
> + * ERANGE:	no match found for search
> + * ENODEV:	if device not found in list of registered devices
>   *
>   * Locking: This function must be called under rcu_read_lock(). opp is a rcu
>   * protected pointer. The reason for the same is that the opp pointer which is
> @@ -293,7 +300,7 @@ EXPORT_SYMBOL(opp_find_freq_exact);
>  struct opp *opp_find_freq_ceil(struct device *dev, unsigned long *freq)
>  {
>  	struct device_opp *dev_opp;
> -	struct opp *temp_opp, *opp = ERR_PTR(-ENODEV);
> +	struct opp *temp_opp, *opp = ERR_PTR(-ERANGE);
>  
>  	if (!dev || !freq) {
>  		dev_err(dev, "%s: Invalid argument freq=%p\n", __func__, freq);
> @@ -302,7 +309,7 @@ struct opp *opp_find_freq_ceil(struct device *dev, unsigned long *freq)
>  
>  	dev_opp = find_device_opp(dev);
>  	if (IS_ERR(dev_opp))
> -		return opp;
> +		return ERR_CAST(dev_opp);
>  
>  	list_for_each_entry_rcu(temp_opp, &dev_opp->opp_list, node) {
>  		if (temp_opp->available && temp_opp->rate >= *freq) {
> @@ -325,7 +332,11 @@ EXPORT_SYMBOL(opp_find_freq_ceil);
>   * for a device.
>   *
>   * Returns matching *opp and refreshes *freq accordingly, else returns
> - * ERR_PTR in case of error and should be handled using IS_ERR.
> + * ERR_PTR in case of error and should be handled using IS_ERR. Error return
> + * values can be:
> + * EINVAL:	for bad pointer
> + * ERANGE:	no match found for search
> + * ENODEV:	if device not found in list of registered devices
>   *
>   * Locking: This function must be called under rcu_read_lock(). opp is a rcu
>   * protected pointer. The reason for the same is that the opp pointer which is
> @@ -336,7 +347,7 @@ EXPORT_SYMBOL(opp_find_freq_ceil);
>  struct opp *opp_find_freq_floor(struct device *dev, unsigned long *freq)
>  {
>  	struct device_opp *dev_opp;
> -	struct opp *temp_opp, *opp = ERR_PTR(-ENODEV);
> +	struct opp *temp_opp, *opp = ERR_PTR(-ERANGE);
>  
>  	if (!dev || !freq) {
>  		dev_err(dev, "%s: Invalid argument freq=%p\n", __func__, freq);
> @@ -345,7 +356,7 @@ struct opp *opp_find_freq_floor(struct device *dev, unsigned long *freq)
>  
>  	dev_opp = find_device_opp(dev);
>  	if (IS_ERR(dev_opp))
> -		return opp;
> +		return ERR_CAST(dev_opp);
>  
>  	list_for_each_entry_rcu(temp_opp, &dev_opp->opp_list, node) {
>  		if (temp_opp->available) {
> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> index e4d48d2..3838f99 100644
> --- a/drivers/devfreq/devfreq.c
> +++ b/drivers/devfreq/devfreq.c
> @@ -656,14 +656,14 @@ struct opp *devfreq_recommended_opp(struct device *dev, unsigned long *freq,
>  		opp = opp_find_freq_floor(dev, freq);
>  
>  		/* If not available, use the closest opp */
> -		if (opp == ERR_PTR(-ENODEV))
> +		if (opp == ERR_PTR(-ERANGE))
>  			opp = opp_find_freq_ceil(dev, freq);
>  	} else {
>  		/* The freq is an lower bound. opp should be higher */
>  		opp = opp_find_freq_ceil(dev, freq);
>  
>  		/* If not available, use the closest opp */
> -		if (opp == ERR_PTR(-ENODEV))
> +		if (opp == ERR_PTR(-ERANGE))
>  			opp = opp_find_freq_floor(dev, freq);
>  	}
