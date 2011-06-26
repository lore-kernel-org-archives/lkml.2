Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068Ab1FZKT5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 06:19:57 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:39714 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab1FZKTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 06:19:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hcPRYLAN1IYi9ro3t8wvHBOcODn+qUg6QPKE1YeFgliAgf9DC6ww2jJl5LxZzmPuAj
         JNkhvs7GiI8pHf4XyZ5diyRkTbcE7e7iQWo3vsKvBrLPjIOzUg0HUGHTxGeyGx4Fo+wY
         8Q/Av3lb51jIi62af0RFpUvb+Q5AueRe8+zMk=
Date: Sun, 26 Jun 2011 12:19:45 +0200
From: Tejun Heo <tj@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 4/4] sched: Distangle worker accounting from rq->lock
Message-ID: <20110626101945.GB12200@mtj.dyndns.org>
References: <20110622174659.496793734@linutronix.de>
 <20110622174919.135236139@linutronix.de>
 <20110623083722.GF30101@htj.dyndns.org>
 <alpine.LFD.2.02.1106231139270.11814@ionos>
 <20110623101541.GL30101@htj.dyndns.org>
 <20110623104455.GA9274@elte.hu>
 <BANLkTi=SxzG_fonb008KQzbZk16tuxm7NA@mail.gmail.com>
 <alpine.LFD.2.02.1106231337260.11814@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1106231337260.11814@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Thomas.

On Fri, Jun 24, 2011 at 11:01:12AM +0200, Thomas Gleixner wrote:
> The whole design is completely plugged into the scheduler, as you
> _abuse_ rq->lock to serialize the accounting and allow the unlocked
> access to the idle_list. It does not matter at all whether that code
> path is fast or not, it simply does not belong there.

It didn't happen like that.  Hooking into scheduler was the one of the
biggest issues and there were several different attempts at using /
generalizing existing hooks somehow which took good six months without
much agreement from scheduler side.

I don't recall all the details now but IIRC it tried to use
fire_sched_out_preempt_notifiers() which was called inside rq lock
which introduced all the convolution with rq lock.  Later somebody
suggested just open coding it and being done with it and that's how it
ended up inside rq lock.  Hindsight is 20/20 and we could have pulled
it out of rq lock at that time but the rest of the code has been
already running with various different hooking schemes for quite some
time by then.

Anyways, so, let's clean it up.

> The only reason why you want this precise accounting thing is a corner
> case of system overload, but not the common case. In case of system
> overload you can do extra work to figure out how many of these beasts
> are on the fly and whether it makes sense to start some more, simply
> because it does not matter in a overload situation whether you run
> through a list to gather information.

Sure, there are multiple ways to resolve the situation.  I was mostly
worried about waking up / attempting to start more workers under CPU
pressure (this is fine under memory pressure as CPU is idle and memory
allocation failure / blocking would quickly recall rescuers).  I've
been looking at the code and am still not sure but it could be that
this isn't really something to worry about.

Workqueue code always wakes up the first idle worker and a worker
leaves idle state not by its waker but on its own accord when it start
running, which means that, with the suggested change, there can be
multiple spurious wake ups but they'll all try to wake up the same
idle worker which hasn't started running yet.  We might still
unnecessarily try to summon rescuers tho.  It needs more
considerations and experimentations.

Another concern is the additional spin_lock in the sleeping path to
synchronize against CPU unplug operation I mentioned in the other
reply.  Another way to do it would be using preempt_disable/enable()
instead and calling synchronize_sched() from trustee.  It would only
add an extra preemption flipping compared to the current code.

> Can we please stop adding stuff to the most crucial code pathes in the
> kernel just to avoid thinking a bit harder about problems?

Heh... sure, let's just keep it technical, okay?

Thanks.

-- 
tejun
