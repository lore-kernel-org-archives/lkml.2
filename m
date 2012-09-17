Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab2IQKrd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 06:47:33 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:56393 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754440Ab2IQKrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 06:47:32 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18TpkgQCXQTOiWgR+MCGj9YD+9wRT7Jz5D1EJdUWI
	77+Td1Q2oUV4oU
Message-ID: <1347878845.6955.203.camel@marge.simpson.net>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
        Borislav Petkov <bp@alien8.de>, Nikolay Ulyanitsky <lystor@gmail.com>,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 17 Sep 2012 12:47:25 +0200
In-Reply-To: <20120917100759.GB32463@gmail.com>
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
	 <20120917100759.GB32463@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-17 at 12:07 +0200, Ingo Molnar wrote: 
> * Mike Galbraith <efault@gmx.de> wrote:
> 

> >     4 socket 40 core + SMT Westmere box, single 30 sec tbench runs, higher is better:
> >     
> >      clients     1       2       4        8       16       32       64      128
> >      ..........................................................................
> >      pre        30      41     118      645     3769     6214    12233    14312
> >      post      299     603    1211     2418     4697     6847    11606    14557
> 
> That's a very tempting speedup for a simpler and more 
> fundamental workload than postgresql's somewhat weird
> user-space spinlocks that burn CPU time in user-space
> instead of blocking/waiting on a futex.
> 
> IIRC mysql does this properly and outperforms postgresql
> on this benchmark, in an apples-to-apples configuration?

It's been a while since I fiddled with oltp (lost my fast mysql db,
every attempt to re-create produced a complete slug), but postgress was
always the throughput winner at that here.

> > 10x at 1 pair shouldn't be traversal, the whole box is 
> > otherwise idle. We'll do a lot more (ever more futile) 
> > traversal as load increases, but at the same time, our futile 
> > attempts fail more frequently, so we shoot ourselves in the 
> > foot less frequently.
> > 
> > The down side is (appears to be) that I also shut down some 
> > ~odd case preemption salvation, salvation that only large 
> > packages will receive.
> > 
> > The problem as I see it is that we're making light tasks _too_ 
> > mobile, turning an optimization into a pessimization for light 
> > tasks.  For longer running tasks this mobility within a large 
> > package isn't such a big deal, but for fast movers, it hurts a 
> > lot.
> 
> There's not enough time to resolve this for v3.6, so I agree 
> with the revert - would you be willing to post a v2 of your 
> original patch? I really think we want your tbench speedups, 
> quite a few real-world messaging applications use the tbench 
> patterns of scheduling.

I don't know what a v2 would look like, but I can keep thinking about
this irritating little <naughty words elided>.  Peter's a lot hairier
chested, not to mention having a sense of _taste_ :) so it might be
better to just consider my patch a diagnostic, and let him fix it up in
a (likely lots) less tummy distressing manner.

-Mike

