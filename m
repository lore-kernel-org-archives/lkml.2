Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388Ab1I0P4L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 11:56:11 -0400
Received: from smtp.citrix.com ([66.165.176.89]:14525 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940Ab1I0P4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 11:56:10 -0400
X-IronPort-AV: E=Sophos;i="4.68,449,1312171200"; 
   d="scan'208";a="17733963"
Message-ID: <4E81F278.5040107@citrix.com>
Date: Tue, 27 Sep 2011 16:57:44 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110818 Icedove/3.0.11
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Konrad Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH v2] xen: Fix selfballooning and ensure it doesn't go too
 far
References: <2de59b55-4ecc-4155-8709-f8b0f5e012bc@default>
In-Reply-To: <2de59b55-4ecc-4155-8709-f8b0f5e012bc@default>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/09/11 16:03, Dan Magenheimer wrote:
> Note: This patch is also now in a git tree at:
> 
> git://oss.oracle.com/git/djm/tmem.git#selfballoon-fix-v2
> 
> The balloon driver's "current_pages" is very different from
> totalram_pages.  Self-ballooning needs to be driven by
> the latter.

I don't think this part of the change makes any difference. It looks like it
rearranges the maths without changing the end result (other than
slightly increasing the rate of change).

I think this (partial, untested) patch is equivalent:

diff --git a/drivers/xen/xen-selfballoon.c b/drivers/xen/xen-selfballoon.c
index 1b4afd8..b207e89 100644
--- a/drivers/xen/xen-selfballoon.c
+++ b/drivers/xen/xen-selfballoon.c
@@ -194,14 +194,15 @@ __setup("selfballooning", xen_selfballooning_setup);
  */
 static void selfballoon_process(struct work_struct *work)
 {
-	unsigned long cur_pages, goal_pages, tgt_pages;
+	unsigned long cur_pages, goal_pages, tgt_pages, rsvd_pages, floor_pages;
 	bool reset_timer = false;
 
 	if (xen_selfballooning_enabled) {
 		cur_pages = balloon_stats.current_pages;
 		tgt_pages = cur_pages; /* default is no change */
-		goal_pages = percpu_counter_read_positive(&vm_committed_as) +
-			balloon_stats.current_pages - totalram_pages;
+		rsvd_pages = cur_pages - totalram_pages;
+		goal_pages = percpu_counter_read_positive(&vm_committed_as)
+			+ rsvd_pages;
 #ifdef CONFIG_FRONTSWAP
 		/* allow space for frontswap pages to be repatriated */
 		if (frontswap_selfshrinking && frontswap_enabled)
@@ -216,6 +217,11 @@ static void selfballoon_process(struct work_struct *work)
 				((goal_pages - cur_pages) /
 				  selfballoon_uphysteresis);
 		/* else if cur_pages == goal_pages, no change */
+		floor_pages = rsvd_pages + totalreserve_pages +
+			((roundup_pow_of_two(max_pfn) / 128) *
+				selfballoon_safety_margin);
+		if (tgt_pages < floor_pages)
+			tgt_pages = floor_pages;
 		balloon_set_new_target(tgt_pages);
 		reset_timer = true;
 	}

> Also, Committed_AS doesn't account for pages
> used by the kernel so enforce a floor for when there are little
> or no user-space threads using memory.  The floor function
> includes a "safety margin" tuneable in case we discover later
> that the floor function is still too aggressive in some workloads,
> though likely it will not be needed.

The sysfs file isn't documented (but then neither are any of the other
(self-)balloon driver sysfs files).

I don't think "safety_margin" is the right name.  Perhaps,
"min_reservation_ratio" or something like that?

David

> Changes since version 1:
> - tuneable safety margin added
> 
> [v2: konrad.wilk@oracle.com: make safety margin tuneable]
> 
> Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
> 
> diff --git a/drivers/xen/xen-selfballoon.c b/drivers/xen/xen-selfballoon.c
> index 6ea852e..ceaada6 100644
> --- a/drivers/xen/xen-selfballoon.c
> +++ b/drivers/xen/xen-selfballoon.c
> @@ -93,6 +93,12 @@ static unsigned int selfballoon_uphysteresis __read_mostly = 1;
>  /* In HZ, controls frequency of worker invocation. */
>  static unsigned int selfballoon_interval __read_mostly = 5;
>  
> +/*
> + * Scale factor for safety margin for minimum selfballooning target for balloon.
> + * Default adds about 3% (4/128) of max_pfn.
> + */
> +static unsigned int selfballoon_safety_margin = 4;
> +
>  static void selfballoon_process(struct work_struct *work);
>  static DECLARE_DELAYED_WORK(selfballoon_worker, selfballoon_process);
>  
> @@ -195,14 +201,13 @@ __setup("selfballooning", xen_selfballooning_setup);
>   */
>  static void selfballoon_process(struct work_struct *work)
>  {
> -	unsigned long cur_pages, goal_pages, tgt_pages;
> +	unsigned long cur_pages, goal_pages, tgt_pages, floor_pages;
>  	bool reset_timer = false;
>  
>  	if (xen_selfballooning_enabled) {
> -		cur_pages = balloon_stats.current_pages;
> +		cur_pages = totalram_pages;
>  		tgt_pages = cur_pages; /* default is no change */
> -		goal_pages = percpu_counter_read_positive(&vm_committed_as) +
> -			balloon_stats.current_pages - totalram_pages;
> +		goal_pages = percpu_counter_read_positive(&vm_committed_as);
>  #ifdef CONFIG_FRONTSWAP
>  		/* allow space for frontswap pages to be repatriated */
>  		if (frontswap_selfshrinking && frontswap_enabled)
> @@ -217,7 +222,13 @@ static void selfballoon_process(struct work_struct *work)
>  				((goal_pages - cur_pages) /
>  				  selfballoon_uphysteresis);
>  		/* else if cur_pages == goal_pages, no change */
> -		balloon_set_new_target(tgt_pages);
> +		floor_pages = totalreserve_pages +
> +			((roundup_pow_of_two(max_pfn) / 128) *
> +				selfballoon_safety_margin);
> +		if (tgt_pages < floor_pages)
> +			tgt_pages = floor_pages;
> +		balloon_set_new_target(tgt_pages +
> +			balloon_stats.current_pages - totalram_pages);
>  		reset_timer = true;
>  	}
>  #ifdef CONFIG_FRONTSWAP
> @@ -340,6 +351,30 @@ static ssize_t store_selfballoon_uphys(struct sys_device *dev,
>  static SYSDEV_ATTR(selfballoon_uphysteresis, S_IRUGO | S_IWUSR,
>  		   show_selfballoon_uphys, store_selfballoon_uphys);
>  
> +SELFBALLOON_SHOW(selfballoon_safety_margin, "%d\n", selfballoon_safety_margin);
> +
> +static ssize_t store_selfballoon_safety_margin(struct sys_device *dev,
> +					       struct sysdev_attribute *attr,
> +					       const char *buf,
> +					       size_t count)
> +{
> +	unsigned long val;
> +	int err;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +	err = strict_strtoul(buf, 10, &val);
> +	if (err || val == 0 || val > 128)
> +		return -EINVAL;
> +	selfballoon_safety_margin = val;
> +	return count;
> +}
> +
> +static SYSDEV_ATTR(selfballoon_safety_margin, S_IRUGO | S_IWUSR,
> +		   show_selfballoon_safety_margin,
> +		   store_selfballoon_safety_margin);
> +
> +
>  #ifdef CONFIG_FRONTSWAP
>  SELFBALLOON_SHOW(frontswap_selfshrinking, "%d\n", frontswap_selfshrinking);
>  
> @@ -421,6 +456,7 @@ static struct attribute *selfballoon_attrs[] = {
>  	&attr_selfballoon_interval.attr,
>  	&attr_selfballoon_downhysteresis.attr,
>  	&attr_selfballoon_uphysteresis.attr,
> +	&attr_selfballoon_safety_margin.attr,
>  #ifdef CONFIG_FRONTSWAP
>  	&attr_frontswap_selfshrinking.attr,
>  	&attr_frontswap_hysteresis.attr,

