Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab2GVUri (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 16:47:38 -0400
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:39208 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752001Ab2GVUrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 16:47:37 -0400
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
Date: Sun, 22 Jul 2012 16:46:54 -0400
In-Reply-To: <20120722164953.GC5144@dhcp-172-17-108-109.mtv.corp.google.com>
References: <20120719211510.GA32763@google.com>
	 <20120719211629.GC32763@google.com>
	 <1342894814.2504.31.camel@palomino.walls.org>
	 <20120722164953.GC5144@dhcp-172-17-108-109.mtv.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1342990015.2487.19.camel@palomino.walls.org>
Mime-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.260,0.0.0000
 definitions=2012-07-22_05:2012-07-20,2012-07-22,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=6.0.2-1203120001 definitions=main-1207220255
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-07-22 at 09:49 -0700, Tejun Heo wrote:
> Hello,
> 
> On Sat, Jul 21, 2012 at 02:20:06PM -0400, Andy Walls wrote:
> > > +	worker->current_work = work;
> > >  	spin_unlock_irq(&worker->lock);
> > >  
> > >  	if (work) {
> > >  		__set_current_state(TASK_RUNNING);
> > >  		work->func(work);
> > 
> > If the call to 'work->func(work);' frees the memory pointed to by
> > 'work', 'worker->current_work' points to deallocated memory.
> > So 'worker->current_work' will only ever used as a unique 'work'
> > identifier to handle, correct?
> 
> Yeah.  flush_kthread_work(@work) which can only be called if @work is
> known to be alive looks at the pointer to determine whether it's the
> current work item on the worker.

OK.  Thanks.

Hmmm, I didn't know about the constraint about 'known to be alive' in
the other email I just sent.

That might make calling flush_kthread_work() hard for a user to use, if
the user lets the work get freed by another thread executing the work.


> > >  void flush_kthread_work(struct kthread_work *work)
> > >  {
> > > -	int seq = work->queue_seq;
> > > +	struct kthread_flush_work fwork = {
> > > +		KTHREAD_WORK_INIT(fwork.work, kthread_flush_work_fn),
> > > +		COMPLETION_INITIALIZER_ONSTACK(fwork.done),
> > > +	};
> > > +	struct kthread_worker *worker;
> > > +	bool noop = false;
> > > +
> > 
> > You might want a check for 'work == NULL' here, to gracefully handle
> > code like the following:

> workqueue's flush_work() doesn't allow %NULL pointer.  I don't want to
> make the behaviors deviate and don't see much point in changing
> workqueue's behavior at this point.

OK.  Fair enough.

Thanks.

Regards,
Andy


