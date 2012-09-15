Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab2IOQNy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 12:13:54 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:49275 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754223Ab2IOQNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 12:13:50 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19zbUEAS99zQcBKvk+7ZxN/g3X9kh3v1b+L/rdRgr
	DaQCXfXkXcTbGb
Message-ID: <1347725625.7029.25.camel@marge.simpson.net>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
From: Mike Galbraith <efault@gmx.de>
To: Borislav Petkov <bp@alien8.de>
Cc: Nikolay Ulyanitsky <lystor@gmail.com>, linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Date: Sat, 15 Sep 2012 18:13:45 +0200
In-Reply-To: <20120915151827.GA17439@liondog.tnic>
References: <CA+Medix98MHYzpKSDKKWf7Wew0H4zDFsUS74LrhsP2Lxemd3Mw@mail.gmail.com>
	 <20120914212717.GA29307@liondog.tnic>
	 <1347682262.4340.160.camel@marge.simpson.net>
	 <20120915104451.GC12364@liondog.tnic>
	 <1347720459.7256.11.camel@marge.simpson.net>
	 <20120915151827.GA17439@liondog.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-09-15 at 17:18 +0200, Borislav Petkov wrote: 
> On Sat, Sep 15, 2012 at 04:47:39PM +0200, Mike Galbraith wrote:
> > Increasing /proc/sys/kernel/sched_min_granularity_ns to roughly half
> > of sched_latency_ns should also help. That will allow LAST_BUDDY to do
> > it's job, try to hand the CPU back to a preempted task if possible.
> 
> Just for my n00b scheduler understanding: this way you're practically
> extending the timeslice of the task so that it gets done without being
> preempted and the lock-holding period of the preempted task gets smaller
> and thus you get more completed transactions in postgres during the
> benchmark run?

Not really, preemption will happen, but when the preempting task goes to
sleep (or uses it's fair share), instead of selecting the leftmost task
(lowest vruntime), the preempted task gets the CPU back if we can do
that without violating fairness.  If the preempted task happens to be a
userland spinlock holder, it then release the lock sooner, others don't
spin as long, do more work, less playing space heater while lock holder
waits for spinners to eat enough CPU to become less deserving that it.

> > The change that increased sched_nr_latency to 8 should have injured
> > postgress as well. ATM, it's disabled unless you're massively loaded.
> >
> > I _think_ it's about preemption, but it doesn't matter, patch is
> > toast.
> 
> In any case, if you wanna retry the buddy thing for 3.7, ping me and I
> can run it on the assortment of machines I have here.

Thanks, but off the top of my head I see no way to fix it up without
there being side effects somewhere, there always are.

-Mike

