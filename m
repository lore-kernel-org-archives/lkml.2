Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347Ab1BCQqD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 11:46:03 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:60204 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab1BCQqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 11:46:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KSZB0RAZ5Rn1PvM+3X8EpIY04/DUpIy7h7nyMYS5OFOS4lk278WuqPizjTlHpif/CC
         /ziJCslUF73TdMr9DGCxTi7Q7EnmeLt9tDqLD2A9sEyNmQ5wZ5hA1iTiRsr22lPg+aTZ
         HlkGBBScCCI6Km8dWkrQ76iUCuFQceKguYx4w=
Date: Thu, 3 Feb 2011 08:45:49 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Faisal Latif <faisal.latif@intel.com>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Alessandro Rubini <rubini@cvml.unipv.it>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        "David S. Miller" <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Yong Zhang <yong.zhang0@gmail.com>
Subject: Re: [PATCH 4/4] workqueue: Remove now superfluous
 cancel_delayed_work() calls
Message-ID: <20110203164549.GA12802@core.coreip.homeip.net>
References: <20110203140940.072679794@chello.nl>
 <20110203141548.346089735@chello.nl>
 <20110203161906.GG2570@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110203161906.GG2570@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 03, 2011 at 05:19:06PM +0100, Tejun Heo wrote:
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
> 
> The current behavior is weird and it often is easier to use explicit
> timer + work item if the timer needs to be modified, but it has been
> that way from the beginning so I don't think changing it would be a
> good idea.  We can introduce a new interface (mod_delayed_work()
> maybe) for this tho.
> 

I agree. If we were to change queue_delayed_work() we'd have to verify
that all users that do not presently use cancel_delayed_work() in
reschedule would be OK with the new behavior.

Thanks.

-- 
Dmitry
