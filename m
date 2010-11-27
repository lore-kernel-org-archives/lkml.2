Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab0K0Otw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 09:49:52 -0500
Received: from mail.openrapids.net ([64.15.138.104]:43422 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752384Ab0K0Otv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 09:49:51 -0500
Date: Sat, 27 Nov 2010 09:49:49 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [thisops uV2 02/10] vmstat: Optimize zone counter
	modifications through the use of this cpu operations
Message-ID: <20101127144949.GC15365@Krystal>
References: <20101126210937.383047168@linux.com> <20101126210950.142747403@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101126210950.142747403@linux.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 09:43:58 up 3 days, 19:47,  2 users,  load average: 0.03, 0.03,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (cl@linux.com) wrote:
> this cpu operations can be used to slightly optimize the function. The
> changes will avoid some address calculations and replace them with the
> use of the percpu segment register.
> 
> If one would have this_cpu_inc_return and this_cpu_dec_return then it
> would be possible to optimize inc_zone_page_state and dec_zone_page_state even
> more.

Then we might want to directly target the implementation with
this_cpu_add_return/this_cpu_sub_return (you implement these in patch 03), which
would not need to disable preemption on the fast path. I think we already
discussed this in the past. The reason eludes me at the moment, but I remember
discussing that changing the increment/decrement delta to the nearest powers of
two would let us deal with overflow cleanly. But it's probably too early in the
morning for me to wrap my head around the issue at the moment.

Thanks,

Mathieu

> 
> V1->V2:
> 	- Fix __dec_zone_state overflow handling
> 	- Use s8 variables for temporary storage.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> ---
>  mm/vmstat.c |   56 ++++++++++++++++++++++++++++++++------------------------
>  1 file changed, 32 insertions(+), 24 deletions(-)
> 
> Index: linux-2.6/mm/vmstat.c
> ===================================================================
> --- linux-2.6.orig/mm/vmstat.c	2010-11-24 13:38:34.000000000 -0600
> +++ linux-2.6/mm/vmstat.c	2010-11-24 15:03:08.000000000 -0600
> @@ -167,18 +167,20 @@ static void refresh_zone_stat_thresholds
>  void __mod_zone_page_state(struct zone *zone, enum zone_stat_item item,
>  				int delta)
>  {
> -	struct per_cpu_pageset *pcp = this_cpu_ptr(zone->pageset);
> -
> -	s8 *p = pcp->vm_stat_diff + item;
> +	struct per_cpu_pageset * __percpu pcp = zone->pageset;
> +	s8 * __percpu p = pcp->vm_stat_diff + item;
>  	long x;
> +	long t;
> +
> +	x = delta + __this_cpu_read(*p);
>  
> -	x = delta + *p;
> +	t = __this_cpu_read(pcp->stat_threshold);
>  
> -	if (unlikely(x > pcp->stat_threshold || x < -pcp->stat_threshold)) {
> +	if (unlikely(x > t || x < -t)) {
>  		zone_page_state_add(x, zone, item);
>  		x = 0;
>  	}
> -	*p = x;
> +	__this_cpu_write(*p, x);
>  }
>  EXPORT_SYMBOL(__mod_zone_page_state);
>  
> @@ -221,16 +223,19 @@ EXPORT_SYMBOL(mod_zone_page_state);
>   */
>  void __inc_zone_state(struct zone *zone, enum zone_stat_item item)
>  {
> -	struct per_cpu_pageset *pcp = this_cpu_ptr(zone->pageset);
> -	s8 *p = pcp->vm_stat_diff + item;
> -
> -	(*p)++;
> +	struct per_cpu_pageset * __percpu pcp = zone->pageset;
> +	s8 * __percpu p = pcp->vm_stat_diff + item;
> +	s8 v, t;
> +
> +	__this_cpu_inc(*p);
> +
> +	v = __this_cpu_read(*p);
> +	t = __this_cpu_read(pcp->stat_threshold);
> +	if (unlikely(v > t)) {
> +		s8 overstep = t >> 1;
>  
> -	if (unlikely(*p > pcp->stat_threshold)) {
> -		int overstep = pcp->stat_threshold / 2;
> -
> -		zone_page_state_add(*p + overstep, zone, item);
> -		*p = -overstep;
> +		zone_page_state_add(v + overstep, zone, item);
> +		__this_cpu_write(*p, - overstep);
>  	}
>  }
>  
> @@ -242,16 +247,19 @@ EXPORT_SYMBOL(__inc_zone_page_state);
>  
>  void __dec_zone_state(struct zone *zone, enum zone_stat_item item)
>  {
> -	struct per_cpu_pageset *pcp = this_cpu_ptr(zone->pageset);
> -	s8 *p = pcp->vm_stat_diff + item;
> -
> -	(*p)--;
> -
> -	if (unlikely(*p < - pcp->stat_threshold)) {
> -		int overstep = pcp->stat_threshold / 2;
> +	struct per_cpu_pageset * __percpu pcp = zone->pageset;
> +	s8 * __percpu p = pcp->vm_stat_diff + item;
> +	s8 v, t;
> +
> +	__this_cpu_dec(*p);
> +
> +	v = __this_cpu_read(*p);
> +	t = __this_cpu_read(pcp->stat_threshold);
> +	if (unlikely(v < - t)) {
> +		s8 overstep = t >> 1;
>  
> -		zone_page_state_add(*p - overstep, zone, item);
> -		*p = overstep;
> +		zone_page_state_add(v - overstep, zone, item);
> +		__this_cpu_write(*p, overstep);
>  	}
>  }
>  
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
