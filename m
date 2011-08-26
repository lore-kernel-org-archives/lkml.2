Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143Ab1HZOBu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 10:01:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58954 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754884Ab1HZOBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 10:01:49 -0400
Date: Fri, 26 Aug 2011 15:57:39 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Frank Rowand <frank.rowand@am.sony.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, users@kernel.org,
        hch <hch@infradead.org>, scameron@beardog.cce.hp.com,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Jens Axboe <jaxboe@fusionio.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [kernel.org users] [KORG] Panics on master backend
Message-ID: <20110826135739.GA12565@redhat.com>
References: <4E53ECEF.7040109@kernel.org> <1314129133.8002.102.camel@twins> <20110824160806.GA12317@redhat.com> <1314267872.27911.6.camel@twins> <20110825135429.GA32048@redhat.com> <20110826060107.GA28189@zhy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110826060107.GA28189@zhy>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26, Yong Zhang wrote:
>
> On Thu, Aug 25, 2011 at 03:54:29PM +0200, Oleg Nesterov wrote:
> >
> > Of course it is not TASK_RUNNING, but it can be running or not.
>
> Yup. Before we go beyond ttwu_remote() in ttwu(), 'cpu' is not safe.
> For example, wait_event() could be preempted in between.
>
> But after we go beyond ttwu_remote(), ->pi_lock will stabilize it.

Yes.

> So after we take Oleg's suggestion("task_cpu(p) == smp_processor_id()"),
> things we left is just how to account stat correctly.

Imho, we don't really care. This race is very unlikely, and I think
that the "wrong" cpu argument in ttwu_stat() is harmless.

My only point was, this "cpu = task_cpu(p)" looks confusing, as if we
can trust it below, during the actual wakeup.

> @@ -2696,7 +2697,12 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
>  	success = 1; /* we're going to change ->state */
>  	cpu = task_cpu(p);
>  
> -	if (p->on_rq && ttwu_remote(p, wake_flags))
> +	/*
> +	 * read cpu for another time if ttwu_remote() success,
> +	 * just to prevent task migration in between, otherwise
> +	 * we maybe account stat incorrectly.
> +	 */
> +	if (p->on_rq && ttwu_remote(p, wake_flags, &cpu))

I don't think this makes the things better. p->on_rq can be already
false or ttwu_remote() can fail, in this case we still use the result
of initial task_cpu().

Oleg.

