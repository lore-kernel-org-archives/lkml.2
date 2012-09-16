Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751326Ab2IPEfK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 00:35:10 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:37445 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750881Ab2IPEfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 00:35:08 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/OAsMm7IHOFnoyuYYWVkckC4AeMyK61jU+mGsLRv
	ZGs0+UJBn8vSnk
Message-ID: <1347770100.6952.31.camel@marge.simpson.net>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
From: Mike Galbraith <efault@gmx.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Nikolay Ulyanitsky <lystor@gmail.com>,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Date: Sun, 16 Sep 2012 06:35:00 +0200
In-Reply-To: <20120915223212.4174a314@pyramind.ukuu.org.uk>
References: <CA+Medix98MHYzpKSDKKWf7Wew0H4zDFsUS74LrhsP2Lxemd3Mw@mail.gmail.com>
	 <20120914212717.GA29307@liondog.tnic>
	 <CA+55aFwn3UhTDDch4+-=9=T3rHpDvqphY+NLtf2Ljq-7eG+gYw@mail.gmail.com>
	 <1347680006.4340.142.camel@marge.simpson.net>
	 <m24nmzz2f8.fsf@firstfloor.org>
	 <1347727001.7029.37.camel@marge.simpson.net>
	 <20120915223212.4174a314@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-09-15 at 22:32 +0100, Alan Cox wrote: 
> > Yes, postgress performs loads better with it's spinlocks, but due to
> > that, it necessarily _hates_ preemption.  How the is the scheduler
> > supposed to know that any specific userland task _really_ shouldn't be
> > preempted at any specific time, else bad things follow?
> 
> You provide a shared page for a process group so it can write hints to
> which is kernel mapped so the scheduler can peek..

Or perhaps a flag ala SCHED_RESET_ON_FORK to provide a not necessarily
followed hint.  That hint could be to simply always try the LAST_BUDDY
thing with flagged tasks, since we know that works (postgress inspired
LAST_BUDDY).  Even with postgress like things, fast mover kthreads etc
punching through isn't necessarily a bad thing, you just need to avoid
the punch leaving a gigantic hole.

Oh, while I'm thinking about it, there's another scenario that could
cause the select_idle_sibling() change to affect pgbench on largeish
packages, but it boils down to preemption odds as well.  IIRC pgbench
_was_ at least 1:N, ie one process driving the whole load.  Waker of
many (singularly bad idea as a way to generate load) being preempted by
it's wakees stalls the whole load, so expensive spreading of wakees to
the four winds ala WAKE_BALANCE becomes attractive, that pain being
markedly less intense than having multiple cores go idle while creator
or work waits for one.

-Mike

