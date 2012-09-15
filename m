Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509Ab2IOQgw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 12:36:52 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:37736 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753301Ab2IOQgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 12:36:51 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19BjzMQ/x5B5xFYOUZ4u/vDbBlZamySvTc9nkpsYC
	iBu00RDjfhAPeb
Message-ID: <1347727001.7029.37.camel@marge.simpson.net>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
From: Mike Galbraith <efault@gmx.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Nikolay Ulyanitsky <lystor@gmail.com>,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Date: Sat, 15 Sep 2012 18:36:41 +0200
In-Reply-To: <m24nmzz2f8.fsf@firstfloor.org>
References: <CA+Medix98MHYzpKSDKKWf7Wew0H4zDFsUS74LrhsP2Lxemd3Mw@mail.gmail.com>
	 <20120914212717.GA29307@liondog.tnic>
	 <CA+55aFwn3UhTDDch4+-=9=T3rHpDvqphY+NLtf2Ljq-7eG+gYw@mail.gmail.com>
	 <1347680006.4340.142.camel@marge.simpson.net>
	 <m24nmzz2f8.fsf@firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-09-15 at 09:16 -0700, Andi Kleen wrote: 
> Mike Galbraith <efault@gmx.de> writes:
> >
> > The only reason I can think of why pgbench might suffer is postgres's
> > userspace spinlocks.  If you always look for an idle core, you improve
> > the odds that the wakeup won't preempt a lock holder, sending others
> > into a long spin.
> 
> User space spinlocks like this unfortunately have a tendency to break
> with all kinds of scheduler changes. We've seen this frequently too
> with other users. The best bet currently is to use the real time
> scheduler, but with various tweaks to get its overhead down.

Yeah, that's one way, but decidedly sub-optimal.

> Ultimatively the problem is that user space spinlocks with CPU
> oversubcription is a very unstable setup and small changes can
> easily disturb it.
> 
> Just using futex is unfortunately not the answer either.

Yes, postgress performs loads better with it's spinlocks, but due to
that, it necessarily _hates_ preemption.  How the is the scheduler
supposed to know that any specific userland task _really_ shouldn't be
preempted at any specific time, else bad things follow?

-Mike

