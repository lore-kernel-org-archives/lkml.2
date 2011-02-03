Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465Ab1BCPid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 10:38:33 -0500
Received: from www.tglx.de ([62.245.132.106]:58328 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735Ab1BCPic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 10:38:32 -0500
Date: Thu, 3 Feb 2011 16:35:00 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Tejun Heo <tj@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Faisal Latif <faisal.latif@intel.com>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alessandro Rubini <rubini@cvml.unipv.it>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        "David S. Miller" <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Yong Zhang <yong.zhang0@gmail.com>
Subject: Re: [PATCH 1/4] lockdep, timer: Fix del_timer_sync() annotation
In-Reply-To: <20110203141548.039540914@chello.nl>
Message-ID: <alpine.LFD.2.00.1102031634270.31804@localhost6.localdomain6>
References: <20110203140940.072679794@chello.nl> <20110203141548.039540914@chello.nl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Feb 2011, Peter Zijlstra wrote:

> Calling local_bh_enable() will want to actually start processing
> softirqs, which isn't a good idea since this can get called with IRQs
> disabled.
> 
> Cure this by using _local_bh_enable() which doesn't start processing
> softirqs, and use raw_local_irq_save() to avoid any softirqs from
> happending without letting lockdep think IRQs are in fact disabled.
> 
> Reported-by: Nick Bowler <nbowler@elliptictech.com>

Nick, can you please test ?

Thanks,

	tglx

> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> LKML-Reference: <new-submission>
> ---
>  kernel/timer.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/kernel/timer.c
> ===================================================================
> --- linux-2.6.orig/kernel/timer.c
> +++ linux-2.6/kernel/timer.c
> @@ -969,10 +969,14 @@ EXPORT_SYMBOL(try_to_del_timer_sync);
>  int del_timer_sync(struct timer_list *timer)
>  {
>  #ifdef CONFIG_LOCKDEP
> +	unsigned long flags;
> +
> +	raw_local_irq_save(flags);
>  	local_bh_disable();
>  	lock_map_acquire(&timer->lockdep_map);
>  	lock_map_release(&timer->lockdep_map);
> -	local_bh_enable();
> +	_local_bh_enable();
> +	raw_local_irq_restore(flags);
>  #endif
>  	/*
>  	 * don't use it in hardirq context, because it
> 
> 
