Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab2FNIfg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 04:35:36 -0400
Received: from www.linutronix.de ([62.245.132.108]:54547 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab2FNIfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 04:35:34 -0400
Date: Thu, 14 Jun 2012 10:35:27 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Namhyung Kim <namhyung@kernel.org>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [RFC patch 1/5] kthread: Implement park/unpark facility
In-Reply-To: <8762au62u1.fsf@sejong.aot.lge.com>
Message-ID: <alpine.LFD.2.02.1206141020370.3086@ionos>
References: <20120613102823.373180763@linutronix.de> <20120613105815.132283147@linutronix.de> <8762au62u1.fsf@sejong.aot.lge.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2012, Namhyung Kim wrote:
> >  /**
> > + * kthread_create_on_cpu - Create a cpu bound kthread
> > + * @threadfn: the function to run until signal_pending(current).
> > + * @data: data ptr for @threadfn.
> > + * @node: memory node number.
> 
> Should be @cpu.

Yup. Copy and paste should be forbidden :)

> > +				   cpu);
> > +	if (IS_ERR(p))
> > +		return p;
> > +	/* Park the thread, mark it percpu and then bind it */
> > +	kthread_park(p);
> 
> Why park? AFAIK the p is not running after creation, so binding it
> doesn't need parking, right?
 
Parking is necessary to get it out of the UNINTERRUPTIBLE state,
otherwise the hung task detector would complain. Right the binding is
not strictly necessary. In fact we can delay it to unpark() where we
know that the target cpu is online already.
 
> > +void kthread_unpark(struct task_struct *k)
> > +{
> > +	struct kthread *kthread;
> > +
> > +	get_task_struct(k);
> > +
> > +	kthread = to_kthread(k);
> > +	barrier(); /* it might have exited */
> > +	if (k->vfork_done != NULL) {
> 
> Does is guarantee it's not exited? If so, as it is used a couple of
> times, wouldn't it be better making it up a (static?) helper (with
> comments, hopefully) something like a kthread_is_alive() ?

Good point.

> > +/**
> >   * kthread_stop - stop a thread created by kthread_create().
> >   * @k: thread created by kthread_create().
> >   *
> > @@ -259,7 +398,7 @@ int kthread_stop(struct task_struct *k)
> >  	kthread = to_kthread(k);
> >  	barrier(); /* it might have exited */
> >  	if (k->vfork_done != NULL) {
> > -		kthread->should_stop = 1;
> > +		set_bit(KTHREAD_SHOULD_STOP, &kthread->flags);
> 
> I wonder whether it also needs to unpark @k. Isn't it possible to stop a
> parked thread?

Right, it should be possible and it is. Clearing the park flag is not
strictly necessary, but yes we should do that.

Thanks for the review!

       tglx


