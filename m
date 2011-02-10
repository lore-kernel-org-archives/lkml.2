Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587Ab1BJPwf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 10:52:35 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:41553 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756564Ab1BJPwc (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 10 Feb 2011 10:52:32 -0500
Date: Thu, 10 Feb 2011 10:51:42 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Daniel Kiper <dkiper@net-space.pl>
Cc: ian.campbell@citrix.com, akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        dan.magenheimer@oracle.com, v.tolstov@selfip.ru, pasik@iki.fi,
        dave@linux.vnet.ibm.com, wdauchy@gmail.com, rientjes@google.com,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH R3 5/7] xen/balloon: Protect against CPU exhaust by
 event/x proces
Message-ID: <20110210155142.GC12087@dumpdata.com>
References: <20110203162851.GH1364@router-fw-old.local.net-space.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110203162851.GH1364@router-fw-old.local.net-space.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4D54099C.00C5:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 03, 2011 at 05:28:51PM +0100, Daniel Kiper wrote:
> Protect against CPU exhaust by event/x process during
> errors by adding some delays in scheduling next event.
> 
> Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
> ---
>  drivers/xen/balloon.c |   99 +++++++++++++++++++++++++++++++++++++++---------
>  1 files changed, 80 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
> index 4223f64..ed103d4 100644
> --- a/drivers/xen/balloon.c
> +++ b/drivers/xen/balloon.c
> @@ -66,6 +66,20 @@
>  
>  #define BALLOON_CLASS_NAME "xen_memory"
>  
> +/*
> + * balloon_process() state:
> + *
> + * BP_ERROR: error, go to sleep,
> + * BP_DONE: done or nothing to do,
> + * BP_HUNGRY: hungry.
> + */
> +
> +enum bp_state {
> +	BP_ERROR,

BP_EAGAIN?

So if we fail to increase the first hour, we would keep on trying to
increase forever (with a 32 second delay between each call). Do you
think it makes sense (as a future patch, not tied in with this patchset)
to printout a printk(KERN_INFO that we have been trying to increase
for the last X hours, seconds and have not gone anywhere (and perhaps
stop trying to allocate more memory?).

> +	BP_DONE,
> +	BP_HUNGRY
> +};
> +
>  struct balloon_stats {
>  	/* We aim for 'current allocation' == 'target allocation'. */
>  	unsigned long current_pages;
> @@ -73,6 +87,8 @@ struct balloon_stats {
>  	/* Number of pages in high- and low-memory balloons. */
>  	unsigned long balloon_low;
>  	unsigned long balloon_high;
> +	unsigned long schedule_delay;
> +	unsigned long max_schedule_delay;
>  };
>  
>  static DEFINE_MUTEX(balloon_mutex);
> @@ -171,6 +187,25 @@ static struct page *balloon_next_page(struct page *page)
>  	return list_entry(next, struct page, lru);
>  }
>  
> +static void update_schedule_delay(enum bp_state state)
> +{
> +	unsigned long new_schedule_delay;
> +
> +	if (state != BP_ERROR) {
> +		balloon_stats.schedule_delay = 1;
> +		return;
> +	}
> +
> +	new_schedule_delay = balloon_stats.schedule_delay << 1;
> +
> +	if (new_schedule_delay > balloon_stats.max_schedule_delay) {
> +		balloon_stats.schedule_delay = balloon_stats.max_schedule_delay;
> +		return;
> +	}
> +
> +	balloon_stats.schedule_delay = new_schedule_delay;
> +}
> +
>  static unsigned long current_target(void)
>  {
>  	unsigned long target = balloon_stats.target_pages;
> @@ -183,11 +218,12 @@ static unsigned long current_target(void)
>  	return target;
>  }
>  
> -static int increase_reservation(unsigned long nr_pages)
> +static enum bp_state increase_reservation(unsigned long nr_pages)
>  {
> +	enum bp_state state = BP_DONE;
> +	int rc;
>  	unsigned long  pfn, i;
>  	struct page   *page;
> -	long           rc;
>  	struct xen_memory_reservation reservation = {
>  		.address_bits = 0,
>  		.extent_order = 0,
> @@ -198,8 +234,15 @@ static int increase_reservation(unsigned long nr_pages)
>  		nr_pages = ARRAY_SIZE(frame_list);
>  
>  	page = balloon_first_page();
> +
> +	if (!page)
> +		return BP_ERROR;
> +
>  	for (i = 0; i < nr_pages; i++) {
> -		BUG_ON(page == NULL);
> +		if (!page) {
> +			nr_pages = i;
> +			break;
> +		}
>  		frame_list[i] = page_to_pfn(page);
>  		page = balloon_next_page(page);
>  	}
> @@ -207,8 +250,11 @@ static int increase_reservation(unsigned long nr_pages)
>  	set_xen_guest_handle(reservation.extent_start, frame_list);
>  	reservation.nr_extents = nr_pages;
>  	rc = HYPERVISOR_memory_op(XENMEM_populate_physmap, &reservation);
> -	if (rc < 0)
> -		goto out;
> +	if (rc < nr_pages) {
> +		if (rc <= 0)
> +			return BP_ERROR;
> +		state = BP_HUNGRY;
> +	}
>  
>  	for (i = 0; i < rc; i++) {
>  		page = balloon_retrieve();
> @@ -238,15 +284,14 @@ static int increase_reservation(unsigned long nr_pages)
>  
>  	balloon_stats.current_pages += rc;
>  
> - out:
> -	return rc < 0 ? rc : rc != nr_pages;
> +	return state;
>  }
>  
> -static int decrease_reservation(unsigned long nr_pages)
> +static enum bp_state decrease_reservation(unsigned long nr_pages)
>  {
> +	enum bp_state state = BP_DONE;
>  	unsigned long  pfn, i;
>  	struct page   *page;
> -	int            need_sleep = 0;
>  	int ret;
>  	struct xen_memory_reservation reservation = {
>  		.address_bits = 0,
> @@ -260,7 +305,7 @@ static int decrease_reservation(unsigned long nr_pages)
>  	for (i = 0; i < nr_pages; i++) {
>  		if ((page = alloc_page(GFP_BALLOON)) == NULL) {
>  			nr_pages = i;
> -			need_sleep = 1;
> +			state = BP_ERROR;
>  			break;
>  		}
>  
> @@ -296,7 +341,7 @@ static int decrease_reservation(unsigned long nr_pages)
>  
>  	balloon_stats.current_pages -= nr_pages;
>  
> -	return need_sleep;
> +	return state;
>  }
>  
>  /*
> @@ -307,27 +352,35 @@ static int decrease_reservation(unsigned long nr_pages)
>   */
>  static void balloon_process(struct work_struct *work)
>  {
> -	int need_sleep = 0;
> +	enum bp_state rc, state = BP_DONE;
>  	long credit;
>  
>  	mutex_lock(&balloon_mutex);
>  
>  	do {
>  		credit = current_target() - balloon_stats.current_pages;
> -		if (credit > 0)
> -			need_sleep = (increase_reservation(credit) != 0);
> -		if (credit < 0)
> -			need_sleep = (decrease_reservation(-credit) != 0);
> +
> +		if (credit > 0) {
> +			rc = increase_reservation(credit);
> +			state = (rc == BP_ERROR) ? BP_ERROR : state;
> +		}
> +
> +		if (credit < 0) {
> +			rc = decrease_reservation(-credit);
> +			state = (rc == BP_ERROR) ? BP_ERROR : state;
> +		}
> +
> +		update_schedule_delay(state);
>  
>  #ifndef CONFIG_PREEMPT
>  		if (need_resched())
>  			schedule();
>  #endif
> -	} while ((credit != 0) && !need_sleep);
> +	} while (credit && state != BP_ERROR);
>  
>  	/* Schedule more work if there is some still to be done. */
> -	if (current_target() != balloon_stats.current_pages)
> -		schedule_delayed_work(&balloon_worker, HZ);
> +	if (state == BP_ERROR)
> +		schedule_delayed_work(&balloon_worker, balloon_stats.schedule_delay * HZ);
>  
>  	mutex_unlock(&balloon_mutex);
>  }
> @@ -394,6 +447,9 @@ static int __init balloon_init(void)
>  	balloon_stats.balloon_low   = 0;
>  	balloon_stats.balloon_high  = 0;
>  
> +	balloon_stats.schedule_delay = 1;
> +	balloon_stats.max_schedule_delay = 32;
> +
>  	register_balloon(&balloon_sysdev);
>  
>  	/*
> @@ -447,6 +503,9 @@ BALLOON_SHOW(current_kb, "%lu\n", PAGES2KB(balloon_stats.current_pages));
>  BALLOON_SHOW(low_kb, "%lu\n", PAGES2KB(balloon_stats.balloon_low));
>  BALLOON_SHOW(high_kb, "%lu\n", PAGES2KB(balloon_stats.balloon_high));
>  
> +static SYSDEV_ULONG_ATTR(schedule_delay, 0644, balloon_stats.schedule_delay);
> +static SYSDEV_ULONG_ATTR(max_schedule_delay, 0644, balloon_stats.max_schedule_delay);
> +
>  static ssize_t show_target_kb(struct sys_device *dev, struct sysdev_attribute *attr,
>  			      char *buf)
>  {
> @@ -508,6 +567,8 @@ static SYSDEV_ATTR(target, S_IRUGO | S_IWUSR,
>  static struct sysdev_attribute *balloon_attrs[] = {
>  	&attr_target_kb,
>  	&attr_target,
> +	&attr_schedule_delay.attr,
> +	&attr_max_schedule_delay.attr
>  };
>  
>  static struct attribute *balloon_info_attrs[] = {
> -- 
> 1.5.6.5
