Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279Ab1BCRpU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 12:45:20 -0500
Received: from casper.infradead.org ([85.118.1.10]:54742 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756441Ab1BCRpT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 12:45:19 -0500
Subject: Re: [PATCH 4/4] workqueue: Remove now superfluous
 cancel_delayed_work() calls
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Tejun Heo <tj@kernel.org>
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
In-Reply-To: <20110203161906.GG2570@htj.dyndns.org>
References: <20110203140940.072679794@chello.nl>
	 <20110203141548.346089735@chello.nl> <20110203161906.GG2570@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 03 Feb 2011 18:45:41 +0100
Message-ID: <1296755141.26581.470.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-03 at 17:19 +0100, Tejun Heo wrote:
> Hello, Peter.
> 
> On Thu, Feb 03, 2011 at 03:09:44PM +0100, Peter Zijlstra wrote:
> > Since queue_delayed_work() can now deal with existing timers, we don't
> > need to explicitly call cancel_delayed_work() anymore.
> 
> This is nice but there's small complication with the way
> queue_delayed_work() behaves.  If a delayed work item is already
> pending, another queue_delayed_work() doesn't modify the delay whether
> the new delay is longer or shorter than the current one.  The previous
> patch doesn't really change the behavior as the whole thing is gated
> with WORK_STRUCT_PENDING_BIT.
> 
> So, cancel_delayed_work() followed by queue_delayed_work() schedules
> the work to be executed at the specified time regardless of the
> current pending state while queue_delayed_work() takes effect iff
> currently the work item is not pending.

Right, I didn't think it would matter much, the difference is tiny. Only
a small window between the timer triggering and the work getting
scheduled has a different semantics, it used to be the same as before
that window, now its like after that window.

Since its all timing the code needs to deal with those cases anyway, no?

> The current behavior is weird and it often is easier to use explicit
> timer + work item if the timer needs to be modified, but it has been
> that way from the beginning so I don't think changing it would be a
> good idea.  We can introduce a new interface (mod_delayed_work()
> maybe) for this tho.

Well we could simply not apply patch 4 and things simply remain as they
are. The mod_timer() semantics are identical to add_timer() if you call
del_timer() like thing before, so patch 3 doesn't actually change any
semantics if you keep using it the old way.
