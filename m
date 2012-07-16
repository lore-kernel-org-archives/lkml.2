Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab2GPKTu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 06:19:50 -0400
Received: from www.linutronix.de ([62.245.132.108]:52469 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab2GPKTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 06:19:46 -0400
Date: Mon, 16 Jul 2012 12:19:39 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mike Galbraith <efault@gmx.de>
cc: Jan Kara <jack@suse.cz>, Jeff Moyer <jmoyer@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        mgalbraith@suse.com
Subject: Re: Deadlocks due to per-process plugging
In-Reply-To: <1342433303.7659.42.camel@marge.simpson.net>
Message-ID: <alpine.LFD.2.02.1207161216200.32033@ionos>
References: <20120711133735.GA8122@quack.suse.cz>  <x49ehoii8ps.fsf@segfault.boston.devel.redhat.com>  <20120711201601.GB9779@quack.suse.cz>  <alpine.LFD.2.02.1207121552111.32033@ionos>  <20120713123318.GB20361@quack.suse.cz>  <alpine.LFD.2.02.1207131444490.32033@ionos>
  <20120713144622.GB28715@quack.suse.cz>  <alpine.LFD.2.02.1207151057010.32033@ionos>  <1342343673.28142.2.camel@marge.simpson.net>  <1342405366.7659.35.camel@marge.simpson.net>  <alpine.LFD.2.02.1207161058550.32033@ionos>  <1342432094.7659.39.camel@marge.simpson.net>
 <1342433303.7659.42.camel@marge.simpson.net>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2012, Mike Galbraith wrote:

> Hm, wonder how bad this sucks.. and if I should go hide under a big
> sturdy rock after I poke xmit :)
> 
> ---
>  block/blk-core.c |    1 +
>  kernel/rtmutex.c |   11 +++++++++--
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -2782,6 +2782,7 @@ void blk_flush_plug_list(struct blk_plug
>  	if (q)
>  		queue_unplugged(q, depth, from_schedule);
>  }
> +EXPORT_SYMBOL(blk_flush_plug_list);

You don't need that one. blk-core and rtmutex are builtin

>  void blk_finish_plug(struct blk_plug *plug)
>  {
> --- a/kernel/rtmutex.c
> +++ b/kernel/rtmutex.c
> @@ -20,6 +20,7 @@
>  #include <linux/module.h>
>  #include <linux/sched.h>
>  #include <linux/timer.h>
> +#include <linux/blkdev.h>
>  
>  #include "rtmutex_common.h"
>  
> @@ -647,8 +648,11 @@ static inline void rt_spin_lock_fastlock
>  
>  	if (likely(rt_mutex_cmpxchg(lock, NULL, current)))
>  		rt_mutex_deadlock_account_lock(lock, current);
> -	else
> +	else {
> +		if (blk_needs_flush_plug(current))
> +			blk_schedule_flush_plug(current);
>  		slowfn(lock);
> +	}

That should do the trick.

