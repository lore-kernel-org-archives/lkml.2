Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650Ab1BDD2w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 22:28:52 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61129 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755529Ab1BDD2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 22:28:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PfmBM4q7cf79XH4CLLQTeBb6tdeAJJQuC6cZtbSgDgygMKvSq9FUD2usfxlhmq8o4l
         l9wEDlil876mU4yogjlmiTi3sM0rCTCt/xiPBTM/Zs+5Ad0UX2HeP8CJ4TPbbknhzrpX
         /3j6SSxKLEkYv3Bo0Ycn/uxLQn8Xm3LHNdT1s=
Date: Fri, 4 Feb 2011 11:28:34 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
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
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/4] lockdep, timer: Fix del_timer_sync() annotation
Message-ID: <20110204032834.GA2791@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <20110203140940.072679794@chello.nl>
 <20110203141548.039540914@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110203141548.039540914@chello.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 03, 2011 at 03:09:41PM +0100, Peter Zijlstra wrote:
> Calling local_bh_enable() will want to actually start processing
> softirqs, which isn't a good idea since this can get called with IRQs
> disabled.
> 
> Cure this by using _local_bh_enable() which doesn't start processing
> softirqs, and use raw_local_irq_save() to avoid any softirqs from
> happending without letting lockdep think IRQs are in fact disabled.
> 
> Reported-by: Nick Bowler <nbowler@elliptictech.com>
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

This is more cheap than what I have done ;)
I think it will cure the issue reported by Nick.
Thanks you anyway.

Reviewed-by: Yong Zhang <yong.zhang0@gmail.com>
