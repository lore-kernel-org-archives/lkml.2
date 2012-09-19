Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab2ISPYA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 11:24:00 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:52880 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754200Ab2ISPX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 11:23:57 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18NvGMFcWANlAvoqlQsom6D5/6tZ+Ju50SslDVtkM
	hAqLgZgmluAhB4
Message-ID: <1348068230.4457.152.camel@marge.simpson.net>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Nikolay Ulyanitsky <lystor@gmail.com>,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 19 Sep 2012 17:23:50 +0200
In-Reply-To: <20120919145454.GA18327@gmail.com>
References: <CA+Medix98MHYzpKSDKKWf7Wew0H4zDFsUS74LrhsP2Lxemd3Mw@mail.gmail.com>
	 <20120914212717.GA29307@liondog.tnic>
	 <CA+55aFwn3UhTDDch4+-=9=T3rHpDvqphY+NLtf2Ljq-7eG+gYw@mail.gmail.com>
	 <1347680006.4340.142.camel@marge.simpson.net>
	 <m24nmzz2f8.fsf@firstfloor.org>
	 <1347727001.7029.37.camel@marge.simpson.net>
	 <20120915223212.4174a314@pyramind.ukuu.org.uk>
	 <1347770100.6952.31.camel@marge.simpson.net>
	 <1348058119.4457.129.camel@marge.simpson.net>
	 <20120919145454.GA18327@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-19 at 16:54 +0200, Ingo Molnar wrote: 
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > On Sun, 2012-09-16 at 06:35 +0200, Mike Galbraith wrote:
> > 
> > > Oh, while I'm thinking about it, there's another scenario 
> > > that could cause the select_idle_sibling() change to affect 
> > > pgbench on largeish packages, but it boils down to 
> > > preemption odds as well.  IIRC pgbench _was_ at least 1:N, 
> > > ie one process driving the whole load.  Waker of many 
> > > (singularly bad idea as a way to generate load) being 
> > > preempted by it's wakees stalls the whole load, so expensive 
> > > spreading of wakees to the four winds ala WAKE_BALANCE 
> > > becomes attractive, that pain being markedly less intense 
> > > than having multiple cores go idle while creator or work 
> > > waits for one.
> > 
> > Enabling SMT on little E5620 box says that's the deal.  
> > pgbench as run is 1:N, and all you have to do is disable 
> > select_idle_sibling() entirely to see that for _this_ (~odd) 
> > load, max spread and lower wakeup latency for the mother of 
> > all work itself is a good thing.
> > 
> > pgbench -i pgbench && pgbench -c $N -T 10 pgbench
> > 
> > N=   1     2     4     8    16    32    64
> >   1336  2482  3752  3485  3327  2928  2290  virgin 3.6.0-rc6
> >   1408  2457  3363  3070  2938  2368  1757  +revert reverted 
> >   1310  2492  2487  2729  2186   975   874  +revert + select_idle_sibling() disabled
> >   1407  2505  3422  3137  3093  2828  2250  +revert + schedctl -B /etc/init.d/postgresql restart
> >   1321  2403  2515  2759  2420  2301  1894  +revert + schedctl -B /etc/init.d/postgresql restart + select_idle_sibling() disabled
> > 
> > Hohum, damned if ya do, damned if ya don't.  Damn.
> 
> As a test, could you mark that 'big PostgreSQL central work 
> queue process' with some high priority (renice -20?), to make 
> sure it's never preempted by wakees? Does that recover 
> performance as well?

schedctl -B started postgress SCHED_BATCH, so pgbench won't be preempted
since it's the only SCHED_NORMAL task left in the lot.  All others are
postmaster, and SCHED_BATCH.

-Mike

