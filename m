Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab2I0F7I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 01:59:08 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:41500 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab2I0F7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 01:59:06 -0400
Date: Thu, 27 Sep 2012 07:59:00 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Nikolay Ulyanitsky <lystor@gmail.com>, linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
Message-ID: <20120927055900.GA4739@gmail.com>
References: <CA+55aFxw5yab4f=+KwB59RjRNXEhQZ==QEvQeLhEczKCTQK9wg@mail.gmail.com>
 <1348574286.3881.40.camel@twins>
 <20120925131736.GA30652@x1.osrc.amd.com>
 <20120925170058.GC30158@x1.osrc.amd.com>
 <CA+55aFzf=CApkYn+m5omwg+9-9i=11vj=7OMxKrCKb0qc-oBgg@mail.gmail.com>
 <20120926163233.GA5339@x1.osrc.amd.com>
 <CA+55aFzC1GZG8+Gv9KmAcV=RGU+hw39hwC9AjfYVqiJ84qAYkw@mail.gmail.com>
 <20120926213723.GA27692@liondog.tnic>
 <1348722568.7059.115.camel@marge.simpson.net>
 <20120927054742.GA4370@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120927054742.GA4370@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > I think the pgbench problem is more about latency for the 1 
> > in 1:N than spinlocks.
> 
> So my understanding of the psql workload is that basically 
> we've got a central psql proxy process that is distributing 
> work to worker psql processes. If a freshly woken worker 
> process ever preempts the central proxy process then it is 
> preventing a lot of new work from getting distributed.

Also, I'd like to stress that despite the optimization dilemma, 
the psql workload is *important*. More important than tbench - 
because psql does some real SQL work and it also matches the 
design of many real desktop and server workloads.

So if indeed the above is the main problem of psql it would be 
nice to add a 'perf bench sched proxy' testcase that emulates it 
- that would remove psql version dependencies and would ease the 
difficulty of running the benchmarks.

We alread have 'perf bench sched pipe' and 'perf bench sched 
messaging' - but neither shows the psql pattern currently.

I suspect a couple of udelay()s in the messaging benchmark would 
do the trick? The wakeup work there already matches much of how 
psql looks like.

Thanks,

	Ingo
