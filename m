Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574Ab2IQKIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 06:08:09 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35035 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040Ab2IQKIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 06:08:06 -0400
Date: Mon, 17 Sep 2012 12:07:59 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
        Borislav Petkov <bp@alien8.de>, Nikolay Ulyanitsky <lystor@gmail.com>,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
Message-ID: <20120917100759.GB32463@gmail.com>
References: <CA+Medix98MHYzpKSDKKWf7Wew0H4zDFsUS74LrhsP2Lxemd3Mw@mail.gmail.com>
 <20120914212717.GA29307@liondog.tnic>
 <CA+55aFwn3UhTDDch4+-=9=T3rHpDvqphY+NLtf2Ljq-7eG+gYw@mail.gmail.com>
 <1347680006.4340.142.camel@marge.simpson.net>
 <m24nmzz2f8.fsf@firstfloor.org>
 <1347727001.7029.37.camel@marge.simpson.net>
 <20120915223212.4174a314@pyramind.ukuu.org.uk>
 <1347770100.6952.31.camel@marge.simpson.net>
 <CA+55aFwTd+Nde=RfthE5XwFqGfZKVKKd9JfAeDUmwed1E634rQ@mail.gmail.com>
 <1347869299.6955.156.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347869299.6955.156.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> On Sun, 2012-09-16 at 12:57 -0700, Linus Torvalds wrote: 
> > On Sat, Sep 15, 2012 at 9:35 PM, Mike Galbraith <efault@gmx.de> wrote:
> > >
> > > Oh, while I'm thinking about it, there's another scenario that could
> > > cause the select_idle_sibling() change to affect pgbench on largeish
> > > packages, but it boils down to preemption odds as well.
> > 
> > So here's a possible suggestion..
> > 
> > Let's assume that the scheduler code to find the next idle CPU on the
> > package is actually a good idea, and we shouldn't mess with the idea.
> 
> We should definitely mess with the idea, as it causes some problems.
> 
> > But at the same time, it's clearly an *expensive* idea, 
> > which is why you introduced the "only test a single CPU 
> > buddy" approach instead. But that didn't work, and you can 
> > come up with multiple reasons why it wouldn't work. Plus, 
> > quite fundamentally, it's rather understandable that "try to 
> > find an idle CPU on the same package" really would be a good 
> > idea, right?
> 
> I would argue that it did work, it shut down the primary 
> source of pain, which I do not believe to be the traversal 
> cost, rather the bouncing.
> 
>     4 socket 40 core + SMT Westmere box, single 30 sec tbench runs, higher is better:
>     
>      clients     1       2       4        8       16       32       64      128
>      ..........................................................................
>      pre        30      41     118      645     3769     6214    12233    14312
>      post      299     603    1211     2418     4697     6847    11606    14557

That's a very tempting speedup for a simpler and more 
fundamental workload than postgresql's somewhat weird
user-space spinlocks that burn CPU time in user-space
instead of blocking/waiting on a futex.

IIRC mysql does this properly and outperforms postgresql
on this benchmark, in an apples-to-apples configuration?

> 10x at 1 pair shouldn't be traversal, the whole box is 
> otherwise idle. We'll do a lot more (ever more futile) 
> traversal as load increases, but at the same time, our futile 
> attempts fail more frequently, so we shoot ourselves in the 
> foot less frequently.
> 
> The down side is (appears to be) that I also shut down some 
> ~odd case preemption salvation, salvation that only large 
> packages will receive.
> 
> The problem as I see it is that we're making light tasks _too_ 
> mobile, turning an optimization into a pessimization for light 
> tasks.  For longer running tasks this mobility within a large 
> package isn't such a big deal, but for fast movers, it hurts a 
> lot.

There's not enough time to resolve this for v3.6, so I agree 
with the revert - would you be willing to post a v2 of your 
original patch? I really think we want your tbench speedups, 
quite a few real-world messaging applications use the tbench 
patterns of scheduling.

Thanks,

	Ingo
