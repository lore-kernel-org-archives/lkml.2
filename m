Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507Ab2IODdd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 23:33:33 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:60160 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755237Ab2IODdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 23:33:32 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18xZ7ovPG0xO2PL3/cn/yj/HoyeEtz4WiMWwV/0nI
	Hfu1Y3XE6zT7AW
Message-ID: <1347680006.4340.142.camel@marge.simpson.net>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
From: Mike Galbraith <efault@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>, Nikolay Ulyanitsky <lystor@gmail.com>,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Date: Sat, 15 Sep 2012 05:33:26 +0200
In-Reply-To: <CA+55aFwn3UhTDDch4+-=9=T3rHpDvqphY+NLtf2Ljq-7eG+gYw@mail.gmail.com>
References: <CA+Medix98MHYzpKSDKKWf7Wew0H4zDFsUS74LrhsP2Lxemd3Mw@mail.gmail.com>
	 <20120914212717.GA29307@liondog.tnic>
	 <CA+55aFwn3UhTDDch4+-=9=T3rHpDvqphY+NLtf2Ljq-7eG+gYw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-14 at 14:42 -0700, Linus Torvalds wrote: 
> On Fri, Sep 14, 2012 at 2:27 PM, Borislav Petkov <bp@alien8.de> wrote:
> >
> > as Nikolay says below, we have a regression in 3.6 with pgbench's
> > benchmark in postgresql.
> >
> > I was able to reproduce it on another box here and did a bisection run.
> > It pointed to the commit below.
> 
> Ok. I guess we should just revert it. However, before we do that,
> maybe Mike can make it just use the exact old semantics of
> select_idle_sibling() in the update_top_cache_domain() logic.
> 
> Because the patch in question seems to do two things:
>  (a) cache the "idle_buggy" logic, so that we don't have those costly loops
>  (b) change it to do that "left-right" thing.
> 
> and that (b) thing may be what causes a regression for you.
> 
> So my gut feel is that the patch was wrong to begin with, exactly
> because it did two independent changes. It *should* have treated those
> two issues as independent changes and separate commits.
> 
> Maybe I'm mis-reading it. Mike? Peter?

It does two things, but it's one problem.  If you crawl over the whole
package, you constantly pull tasks all over the package, which as you
can see from the numbers hurts quite a lot.

The only reason I can think of why pgbench might suffer is postgres's
userspace spinlocks.  If you always look for an idle core, you improve
the odds that the wakeup won't preempt a lock holder, sending others
into a long spin.

-Mike

