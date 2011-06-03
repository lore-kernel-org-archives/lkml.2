Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130Ab1FCG4y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 02:56:54 -0400
Received: from gate.crashing.org ([63.228.1.57]:35413 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116Ab1FCG4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 02:56:53 -0400
Subject: Re: tty breakage in X (Was: tty vs workqueue oddities)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: gregkh@suse.de,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>
In-Reply-To: <1307081874.23876.14.camel@pasglop>
References: <1306999045.29297.55.camel@pasglop>
	 <1307003821.29297.77.camel@pasglop>
	 <20110602110727.7343782b@lxorguk.ukuu.org.uk>
	 <1307062574.29297.204.camel@pasglop>  <1307081874.23876.14.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Jun 2011 16:56:29 +1000
Message-ID: <1307084189.23876.19.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-03 at 16:17 +1000, Benjamin Herrenschmidt wrote:

> Some more data: It -looks- like what happens is that the flush_to_ldisc
> work queue entry constantly re-queues itself (because the PTY is full ?)
> and the workqueue thread will basically loop forver calling it without
> ever scheduling, thus starving the consumer process that could have
> emptied the PTY.
> 
> At least that's a semi half-assed theory. If I add a schedule() to
> process_one_work() after dropping the lock, the problem disappears.
> 
> So there's a combination of things here that are quite interesting:
> 
>  - A lot of work queued for the kworker will essentially go on without
> scheduling for as long as it takes to empty all work items. That doesn't
> sound very nice latency-wise. At least on a non-PREEMPT kernel.
> 
>  - flush_to_ldisc seems to be nasty and requeues itself over and over
> again from what I can tell, when it can't push the data out, in this
> case, I suspect because the PTY is full but I don't know for sure yet.

Interesting results from x86. I could not initially reproduce there at
all on my little Atom board (the one from kernel summit last year).

Eventually I looked at the kernel config, switched off PREEMPT_VOLUNTARY
and I can now reproduce on x86 too. Again, if you have both threads/core
running, the problem isn't as visible (you do see "hickups" when cat'ing
a large file, the atom is slow enough I suppose).

But offline a cpu (leave only one up) and cat a large file (dmesg is
enough for me to trigger it) and you see the hangs.

So I think my theory stands that flush_to_ldisc constantly reschedule
itself causing the worker thread to eat all CPU and starve the consumer
of the PTY. I won't have time to dig much deeper today nor probably this
week-end so I'm sending this email for others who want to look.

Cheers,
Ben.


