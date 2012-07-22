Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab2GVUkP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 16:40:15 -0400
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:60415 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752001Ab2GVUkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 16:40:13 -0400
Subject: Re: [PATCH 2/2] kthread_worker: reimplement flush_kthread_work() to
 allow freeing the work item being executed
From: Andy Walls <awalls@md.metrocast.net>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
        ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 22 Jul 2012 16:39:26 -0400
References: <20120719211510.GA32763@google.com>
	 <20120719211629.GC32763@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1342989568.2487.14.camel@palomino.walls.org>
Mime-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.260,0.0.0000
 definitions=2012-07-22_05:2012-07-20,2012-07-22,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=6.0.2-1203120001 definitions=main-1207220255
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

Thanks for responding to my previous questions.  I have one more.

On Sat, 2012-07-21 at 14:20 -0400, Andy Walls wrote:
> On Thu, 2012-07-19 at 14:16 -0700, Tejun Heo wrote:
> > From 06f9a06f4aeecdb9d07014713ab41b548ae219b5 Mon Sep 17 00:00:00 2001
> > From: Tejun Heo <tj@kernel.org>
> > Date: Thu, 19 Jul 2012 13:52:53 -0700
> > 
> > kthread_worker provides minimalistic workqueue-like interface for
> > users which need a dedicated worker thread (e.g. for realtime
> > priority).  It has basic queue, flush_work, flush_worker operations
> > which mostly match the workqueue counterparts; however, due to the way
> > flush_work() is implemented, it has a noticeable difference of not
> > allowing work items to be freed while being executed. 

[snip]

> > @@ -434,25 +430,35 @@ static void kthread_flush_work_fn(struct kthread_work *work)
> >   */
> >  void flush_kthread_work(struct kthread_work *work)
> >  {
> > -	int seq = work->queue_seq;
> > +	struct kthread_flush_work fwork = {
> > +		KTHREAD_WORK_INIT(fwork.work, kthread_flush_work_fn),
> > +		COMPLETION_INITIALIZER_ONSTACK(fwork.done),
> > +	};
> > +	struct kthread_worker *worker;
> > +	bool noop = false;
> > +
> 
> You might want a check for 'work == NULL' here, to gracefully handle
> code like the following:
> 
> void driver_work_handler(struct kthread_work *work)
> {
> 	...
> 	kfree(work);
> }
> 
> struct kthread_work *driver_queue_batch(void)
> {
> 	struct kthread_work *work = NULL;
> 	...
> 	while (driver_more_stuff_todo()) {
> 		work = kzalloc(sizeof(struct kthread work), GFP_WHATEVER);
> 		...
> 		queue_kthread_work(&driver_worker, work);
> 	}
> 	return work;
> }
> 
> void driver_foobar(void)
> {
> 	...
> 	flush_kthread_work(driver_queue_batch());
> 	...
> }

[snip]

> > +retry:
> > +	worker = work->worker;
> > +	if (!worker)
> > +		return;
> >  
> > -	atomic_inc(&work->flushing);
> > +	spin_lock_irq(&worker->lock);
> > +	if (work->worker != worker) {
> > +		spin_unlock_irq(&worker->lock);
> > +		goto retry;
> > +	}
> >  
> > -	/*
> > -	 * mb flush-b0 paired with worker-b1, to make sure either
> > -	 * worker sees the above increment or we see done_seq update.
> > -	 */
> > -	smp_mb__after_atomic_inc();
> > +	if (!list_empty(&work->node))
> > +		insert_kthread_work(worker, &fwork.work, work->node.next);
> > +	else if (worker->current_work == work)
> > +		insert_kthread_work(worker, &fwork.work, worker->work_list.next);
> > +	else
> > +		noop = true;

The objective is "allowing work items to be freed while being executed",
to me, it does not seem safe to me to allow flush_kthread_work() to
actually dereference the passed in work pointer.

flush_kthread_work() could theoretically be executed after the work
function was executed by the worker kthread which frees the 'work'
object, and that the memory 'work' points to could theoretically already
be reallocated for something else.  (I admit the above likely has very
low probability of occuring.)  

Is there a way to avoid dereferencing 'work' here?

Regards,
Andy

> >  
> > -	/* A - B <= 0 tests whether B is in front of A regardless of overflow */
> > -	wait_event(work->done, seq - work->done_seq <= 0);
> > -	atomic_dec(&work->flushing);
> > +	spin_unlock_irq(&worker->lock);
> >  
> > -	/*
> > -	 * rmb flush-b1 paired with worker-b0, to make sure our caller
> > -	 * sees every change made by work->func().
> > -	 */
> > -	smp_mb__after_atomic_dec();
> > +	if (!noop)
> > +		wait_for_completion(&fwork.done);
> >  }
> >  EXPORT_SYMBOL_GPL(flush_kthread_work);
> >  
> 


