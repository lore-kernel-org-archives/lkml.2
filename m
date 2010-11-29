Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126Ab0K2T2F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 14:28:05 -0500
Received: from mail.openrapids.net ([64.15.138.104]:57645 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751436Ab0K2T2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 14:28:03 -0500
Date: Mon, 29 Nov 2010 14:28:01 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [thisops uV2 02/10] vmstat: Optimize zone counter
	modifications through the use of this cpu operations
Message-ID: <20101129192801.GE25610@Krystal>
References: <20101126210937.383047168@linux.com> <20101126210950.142747403@linux.com> <20101127144949.GC15365@Krystal> <alpine.DEB.2.00.1011291013460.3923@router.home> <alpine.DEB.2.00.1011291111110.4836@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1011291111110.4836@router.home>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 14:26:15 up 6 days, 29 min,  4 users,  load average: 1.00, 1.00,
	1.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (cl@linux.com) wrote:
> We could do this with local cmpxchgs like in the following patch. This
> would avoid preemption disable and interrupt disable (at least on x86).
> Trouble is how do we make this fit for architectures that do not have
> cmpxchg?

All architectures should have a fallback nowadays, no ? This might involve
disabling interrupts around a cmpxchg emulation, which would make the slow path
disable/enable interrupts twice. Is it what you are concerned about ?

Thanks,

Matheu

> 
> 
> Index: linux-2.6/mm/vmstat.c
> ===================================================================
> --- linux-2.6.orig/mm/vmstat.c	2010-11-29 10:58:52.000000000 -0600
> +++ linux-2.6/mm/vmstat.c	2010-11-29 11:11:34.000000000 -0600
> @@ -169,18 +169,23 @@ void __mod_zone_page_state(struct zone *
>  {
>  	struct per_cpu_pageset __percpu *pcp = zone->pageset;
>  	s8 __percpu *p = pcp->vm_stat_diff + item;
> -	long x;
> -	long t;
> +	long o, n, t, z;
> 
> -	x = delta + __this_cpu_read(*p);
> +	do {
> +		z = 0;
> +		t = this_cpu_read(pcp->stat_threshold);
> +		o = this_cpu_read(*p);
> +		n = delta + o;
> +
> +		if (n > t || n < -t) {
> +			/* Overflow must be added to zone counters */
> +			z = n;
> +			n = 0;
> +		}
> +	} while (o != n && this_cpu_cmpxchg(*p, o, n) != o);
> 
> -	t = __this_cpu_read(pcp->stat_threshold);
> -
> -	if (unlikely(x > t || x < -t)) {
> -		zone_page_state_add(x, zone, item);
> -		x = 0;
> -	}
> -	__this_cpu_write(*p, x);
> +	if (z)
> +		zone_page_state_add(z, zone, item);
>  }
>  EXPORT_SYMBOL(__mod_zone_page_state);
> 
> @@ -190,11 +195,7 @@ EXPORT_SYMBOL(__mod_zone_page_state);
>  void mod_zone_page_state(struct zone *zone, enum zone_stat_item item,
>  					int delta)
>  {
> -	unsigned long flags;
> -
> -	local_irq_save(flags);
>  	__mod_zone_page_state(zone, item, delta);
> -	local_irq_restore(flags);
>  }
>  EXPORT_SYMBOL(mod_zone_page_state);
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
