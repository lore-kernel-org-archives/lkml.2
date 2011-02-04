Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402Ab1BDLNK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 06:13:10 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41645 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab1BDLNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 06:13:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FLxog3n0yFCNVOclDZJdVy3UJQAfvIc/yMFkYWdAj35qptZbM+BWAl6J+tSFmK67LL
         1OE/9TFWKx+JoKmkhz7GrsJrJxBtJ3pGSRCruVuvJGRdoaW27E01QG5v9a4Le1HY7LWp
         kP+1/b9wZbmxrRPLMrgwsT6s03bdYqNmcUhWw=
Date: Fri, 4 Feb 2011 12:13:01 +0100
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>,
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
Subject: Re: [PATCH 4/4] workqueue: Remove now superfluous
 cancel_delayed_work() calls
Message-ID: <20110204111301.GD12133@htj.dyndns.org>
References: <20110203140940.072679794@chello.nl>
 <20110203141548.346089735@chello.nl>
 <20110203161906.GG2570@htj.dyndns.org>
 <1296755141.26581.470.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296755141.26581.470.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Peter.

On Thu, Feb 03, 2011 at 06:45:41PM +0100, Peter Zijlstra wrote:
> On Thu, 2011-02-03 at 17:19 +0100, Tejun Heo wrote:
> > On Thu, Feb 03, 2011 at 03:09:44PM +0100, Peter Zijlstra wrote:
> > > Since queue_delayed_work() can now deal with existing timers, we don't
> > > need to explicitly call cancel_delayed_work() anymore.
> > 
> > This is nice but there's small complication with the way
> > queue_delayed_work() behaves.  If a delayed work item is already
> > pending, another queue_delayed_work() doesn't modify the delay whether
> > the new delay is longer or shorter than the current one.  The previous
> > patch doesn't really change the behavior as the whole thing is gated
> > with WORK_STRUCT_PENDING_BIT.
> > 
> > So, cancel_delayed_work() followed by queue_delayed_work() schedules
> > the work to be executed at the specified time regardless of the
> > current pending state while queue_delayed_work() takes effect iff
> > currently the work item is not pending.
> 
> Right, I didn't think it would matter much, the difference is tiny. Only
> a small window between the timer triggering and the work getting
> scheduled has a different semantics, it used to be the same as before
> that window, now its like after that window.
> 
> Since its all timing the code needs to deal with those cases anyway, no?

No, AFAICS the change from add_timer() to mod_timer() doesn't make any
difference.  The control never reaches there if the work item is
already pending.  Please consider the following two sequences.

seq1.	queue_delayed_work(wq, dwork, 10*HZ);
	cancel_delayed_work(dwork);
	queue_delayed_work(wq, dwork, 5*HZ);

seq2.	queue_delayed_work(wq, dwork, 10*HZ);
	queue_delayed_work(wq, dwork, 5*HZ);

With or without the patch, dwork in seq1 will execute in 5 seconds,
and, again, with our without the patch dwork in seq2 will execute in
10 seconds, because queueing is gated by WORK_STRUCT_PENDING_BIT and
if the bit is already set the timer isn't modified at all.

IOW, those cancel_delayed_work()'s are there not because
queue_delayed_work() calls add_timer() instead of mod_timer().
They're there because queue_delayed_work() always uses the first
timeout duration and the users want to change it to a new value.

As I wrote before, I'm not a fan of the current behavior but that's
how it is currently.  This patch series doesn't change the behavior
because the timers are guaranteed to be offline when
queue_delayed_work_on() calls add_timer().  To actually change the
behavior, queue_delayed_work_on() needs to be restructured and all its
users audited.

Thank you.

-- 
tejun
