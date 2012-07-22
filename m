Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab2GVQuA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 12:50:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53064 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118Ab2GVQt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 12:49:58 -0400
Date: Sun, 22 Jul 2012 09:49:53 -0700
From: Tejun Heo <tj@kernel.org>
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
        ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] kthread_worker: reimplement flush_kthread_work()
 to allow freeing the work item being executed
Message-ID: <20120722164953.GC5144@dhcp-172-17-108-109.mtv.corp.google.com>
References: <20120719211510.GA32763@google.com>
 <20120719211629.GC32763@google.com>
 <1342894814.2504.31.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342894814.2504.31.camel@palomino.walls.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Jul 21, 2012 at 02:20:06PM -0400, Andy Walls wrote:
> > +	worker->current_work = work;
> >  	spin_unlock_irq(&worker->lock);
> >  
> >  	if (work) {
> >  		__set_current_state(TASK_RUNNING);
> >  		work->func(work);
> 
> If the call to 'work->func(work);' frees the memory pointed to by
> 'work', 'worker->current_work' points to deallocated memory.
> So 'worker->current_work' will only ever used as a unique 'work'
> identifier to handle, correct?

Yeah.  flush_kthread_work(@work) which can only be called if @work is
known to be alive looks at the pointer to determine whether it's the
current work item on the worker.

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

workqueue's flush_work() doesn't allow %NULL pointer.  I don't want to
make the behaviors deviate and don't see much point in changing
workqueue's behavior at this point.

Thanks.

-- 
tejun
