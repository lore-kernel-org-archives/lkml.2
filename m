Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446Ab1FCGZN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 02:25:13 -0400
Received: from gate.crashing.org ([63.228.1.57]:39569 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800Ab1FCGZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 02:25:11 -0400
Subject: Re: tty breakage in X (Was: tty vs workqueue oddities)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: gregkh@suse.de,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>
In-Reply-To: <1307062574.29297.204.camel@pasglop>
References: <1306999045.29297.55.camel@pasglop>
	 <1307003821.29297.77.camel@pasglop>
	 <20110602110727.7343782b@lxorguk.ukuu.org.uk>
	 <1307062574.29297.204.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Jun 2011 16:17:54 +1000
Message-ID: <1307081874.23876.14.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-03 at 10:56 +1000, Benjamin Herrenschmidt wrote:

> I just noticed it doesn't happen (or if it does, it recovers fast enough
> to not be noticable) on an SMP machine (dual G5). However, if I boot the
> same machine with maxcpus=1, the problem is back. A simple "dmesg" in
> gnome terminal shows it.
> 
> However, on that much faster machine, it also recovers a lot faster. On
> the powerbook, it hangs a few minutes, on the G5 it hangs a few seconds.
> 
> I don't have the bandwidth to dive into the workqueue/tty before this
> week-end, I'll give it a shot next week if nobody beats me to it.

Some more data: It -looks- like what happens is that the flush_to_ldisc
work queue entry constantly re-queues itself (because the PTY is full ?)
and the workqueue thread will basically loop forver calling it without
ever scheduling, thus starving the consumer process that could have
emptied the PTY.

At least that's a semi half-assed theory. If I add a schedule() to
process_one_work() after dropping the lock, the problem disappears.

So there's a combination of things here that are quite interesting:

 - A lot of work queued for the kworker will essentially go on without
scheduling for as long as it takes to empty all work items. That doesn't
sound very nice latency-wise. At least on a non-PREEMPT kernel.

 - flush_to_ldisc seems to be nasty and requeues itself over and over
again from what I can tell, when it can't push the data out, in this
case, I suspect because the PTY is full but I don't know for sure yet.

Cheers,
Ben.


