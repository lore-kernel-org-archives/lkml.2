Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab1H2C3n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 22:29:43 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49132 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab1H2C3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 22:29:38 -0400
Date: Mon, 29 Aug 2011 10:29:26 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Frank Rowand <frank.rowand@am.sony.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, users@kernel.org,
        hch <hch@infradead.org>, scameron@beardog.cce.hp.com,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Jens Axboe <jaxboe@fusionio.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [kernel.org users] [KORG] Panics on master backend
Message-ID: <20110829022926.GA10356@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <4E53ECEF.7040109@kernel.org>
 <1314129133.8002.102.camel@twins>
 <20110824160806.GA12317@redhat.com>
 <1314267872.27911.6.camel@twins>
 <20110825135429.GA32048@redhat.com>
 <20110826060107.GA28189@zhy>
 <20110826135739.GA12565@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110826135739.GA12565@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 03:57:39PM +0200, Oleg Nesterov wrote:
> On 08/26, Yong Zhang wrote:
> >
> > On Thu, Aug 25, 2011 at 03:54:29PM +0200, Oleg Nesterov wrote:
> > >
> > > Of course it is not TASK_RUNNING, but it can be running or not.
> >
> > Yup. Before we go beyond ttwu_remote() in ttwu(), 'cpu' is not safe.
> > For example, wait_event() could be preempted in between.
> >
> > But after we go beyond ttwu_remote(), ->pi_lock will stabilize it.
> 
> Yes.
> 
> > So after we take Oleg's suggestion("task_cpu(p) == smp_processor_id()"),
> > things we left is just how to account stat correctly.
> 
> Imho, we don't really care. This race is very unlikely, 

Yup.

> and I think
> that the "wrong" cpu argument in ttwu_stat() is harmless.

Hmm, the affected accounting is sched_domain->ttwu_wake_remote.

> > @@ -2696,7 +2697,12 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
> >  	success = 1; /* we're going to change ->state */
> >  	cpu = task_cpu(p);
> >  
> > -	if (p->on_rq && ttwu_remote(p, wake_flags))
> > +	/*
> > +	 * read cpu for another time if ttwu_remote() success,
> > +	 * just to prevent task migration in between, otherwise
> > +	 * we maybe account stat incorrectly.
> > +	 */
> > +	if (p->on_rq && ttwu_remote(p, wake_flags, &cpu))
> 
> I don't think this makes the things better. p->on_rq can be already
> false or ttwu_remote() can fail, in this case we still use the result
> of initial task_cpu().

Ah, My code (ttwu_remote(p, wake_flags, &cpu)) just catch the case:
task is dancing with 'p->on_rq == true'.

But forget the case: task has danced with 'p->on_rq == false' in the end.

So we should reread task_cpu(p) if 'p->on_cpu == true &&
__ARCH_WANT_INTERRUPTS_ON_CTXSW == y', but the code will be a little ugly
and it only aims to account stat more correctly.
We need some balance here :)
BTW, I don't think we should care much on the 'incorrect stat' either
if we don't make intolerable mistake.

Thanks,
Yong
