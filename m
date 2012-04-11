Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760154Ab2DKM25 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 08:28:57 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:50904 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab2DKM24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 08:28:56 -0400
Date: Wed, 11 Apr 2012 05:27:27 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH 3/4 V2] implement per-domain single-thread state machine
 call_srcu()
Message-ID: <20120411122727.GA9583@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1332144734-9375-1-git-send-email-laijs@cn.fujitsu.com>
 <1332144734-9375-4-git-send-email-laijs@cn.fujitsu.com>
 <20120410231858.GJ2428@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120410231858.GJ2428@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041112-7408-0000-0000-0000041D7EDA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 04:18:58PM -0700, Paul E. McKenney wrote:
> On Mon, Mar 19, 2012 at 04:12:13PM +0800, Lai Jiangshan wrote:
> > o	state machine is light way and single-threaded, it is preemptible when checking.
> > 
> > o	state machine is a work_struct. So, there is no thread occupied
> > 	by SRCU when the srcu is not actived(no callback). And it does
> > 	not sleep(avoid to occupy a thread when sleep).
> > 
> > o	state machine is the only thread can flip/check/write(*) the srcu_struct,
> > 	so we don't need any mutex.
> > 	(write(*): except ->per_cpu_ref, ->running, ->batch_queue)
> > 
> > o	synchronize_srcu() will take the processing ownership when no other
> > 	state-machine is running.(the task of synchronize_srcu() becomes
> > 	the state-machine-thread). This fast patch can avoid scheduling.
> > 	When the fast path fails, it falls back to "call_srcu() + wait".
> > 
> > o	callback is probably called in the same CPU when it is queued.
> > 
> > The trip of a callback:
> > 	1) ->batch_queue when call_srcu()
> > 
> > 	2) ->batch_check0 when try to do check_zero
> > 
> > 	3) ->batch_check1 after finish its first check_zero and the flip
> > 
> > 	4) ->batch_done after finish its second check_zero
> > 
> > The current requirement of the callbacks:
> > 	The callback will be called inside process context.
> > 	The callback should be fast without any sleeping path.
> 
> The basic algorithm looks safe, but I have some questions on liveness
> and expeditedness below.

[ . . . ]

> > +static void srcu_reschedule(struct srcu_struct *sp)
> > +{
> > +	bool pending = true;
> > +
> > +	if (rcu_batch_empty(&sp->batch_done) &&
> > +	    rcu_batch_empty(&sp->batch_check1) &&
> > +	    rcu_batch_empty(&sp->batch_check0) &&
> > +	    rcu_batch_empty(&sp->batch_queue)) {
> > +		spin_lock_irq(&sp->queue_lock);
> > +		if (rcu_batch_empty(&sp->batch_queue)) {
> > +			sp->running = false;
> > +			pending = false;
> > +		}
> > +		spin_unlock_irq(&sp->queue_lock);
> 
> Hmmm...  What happens given the following sequence of events?
> 
> o	SRCU has just finished executing the last callback, so that
> 	all callback queues are empty.
> 
> o	srcu_reschedule() executes the condition of its "if" statement,
> 	but does not yet acquire the spinlock.  (If I read the code
> 	correctly, preemption could legitimately occur at this point.)
> 
> o	call_srcu() initializes the callback, acquires the spinlock,
> 	queues the callback, and invokes queue_delayed_work().

Never mind!  The ->running is still set, so call_srcu() is not going
to invoke queue_delayed_work().

							Thanx, Paul

> o	The delayed work starts executing process_srcu(), which
> 	calls srcu_collect_new(), which moves the callback to
> 	->batch_check0.
> 
> o	srcu_reschedule continues executing, acquires the spinlock,
> 	sees that ->batch_queue is empty, and therefore sets
> 	->running to false, thus setting the stage for two CPUs
> 	mucking with the queues concurrently without protection.
> 
> I believe that you need to recheck all the queues under the lock,
> not just ->batch_queue (and I did update the patch in this manner).
> 
> Or am I missing something subtle?
> 
> > +	}
> > +
> > +	if (pending)
> > +		queue_delayed_work(system_nrt_wq, &sp->work, SRCU_INTERVAL);
> 
> Here, we carefully invoke queue_delayed_work() outside of the lock,
> while in call_srcu() we invoke it under the lock.  Why the difference?
> 
> > +}
> > +
> > +static void process_srcu(struct work_struct *work)
> > +{
> > +	struct srcu_struct *sp;
> > +
> > +	sp = container_of(work, struct srcu_struct, work.work);
> > +
> > +	srcu_collect_new(sp);
> > +	srcu_advance_batches(sp, 1);
> > +	srcu_invoke_callbacks(sp);
> > +	srcu_reschedule(sp);
> > +}
> > -- 
> > 1.7.4.4
> > 

