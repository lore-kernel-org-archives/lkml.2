Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715Ab0CVSTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 14:19:09 -0400
Received: from www.tglx.de ([62.245.132.106]:52904 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837Ab0CVSTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 14:19:04 -0400
Date: Mon, 22 Mar 2010 19:18:36 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, yinghai@kernel.org,
       benh@kernel.crashing.org, hpa@zytor.com, jbarnes@virtuousgeek.org,
       ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 06/20] early_res: seperate common memmap func from e820.c
 to fw_memmap.cy
In-Reply-To: <20100322092809.GA20607@elte.hu>
Message-ID: <alpine.LFD.2.00.1003221752510.3147@localhost.localdomain>
References: <4BA6EA62.1030603@kernel.org> <20100321.210023.209981130.davem@davemloft.net> <4BA6F1F6.3070102@kernel.org> <20100321.213350.176660494.davem@davemloft.net> <20100322092809.GA20607@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

On Mon, 22 Mar 2010, Ingo Molnar wrote:
> 
> ( Cc:-ed Andrew and Linus as this is a general design/policy matter wrt. 
>   memory management. )
> 
> * David Miller <davem@davemloft.net> wrote:
> 
> > From: Yinghai Lu <yinghai@kernel.org>
> > Date: Sun, 21 Mar 2010 21:28:38 -0700
> > 
> > >> 
> > >> That action means you absolutely don't value our feedback at all.
> > > 
> > > [PATCH 01/20] x86: add find_e820_area_node
> > > is addressing your concern that early_res didn't handle memory cross the nodes problem.
> > 
> > Now I know that you _REALLY_ aren't listening to us.

> [ He has done a bit more than just to simply listen: he seems to
> have written a patch which he thinks is addressing the concerns you
> pointed out. It might not be the response you wished for (and it
> might be inadequate) for but it sure gives me the impression of him
> listening to you - unless by 'listening' you mean 'follow my exact
> opinion without argument'. ]

I tend to disagree. Fixing the bug pointed out by Dave is not really a
good argument about listening.

The main point is that there is still no answer why lmb cannot be used
and the reposted patch still is a full move of the x86 e820 functions
into kernel/fw_memmap.c.

That's not a generalization, that's simply a relocation of x86 code to
kernel/. And I agree with Dave and Ben that this is an useless
exercise.

> > We said to use LMB because 1) it already exists 2) many platforms
> > have been using it for years and 3) it doesn't lack the features
> > you're now having to add to e820.
>
> The thing is, lib/lmb.c was librarized two years ago by you (much
> after early_res has been written for x86), but was not properly
> integrated into the core kernel nor into x86. It was first suggested
> by you in the early_res context about ten days ago, when Yinghai
> started posting Sparc64 patches.
>
> Which is about half a year after the whole very difficult
> early_res/bootmem work was started by Yinghai :-(

Well, the early_res split out from x86 was mostly an x86 related
effort and there is no point on enforcing that to archs which are
happily using lmb for quite a while.

You have to admit, that we did not notice either that lmb could be
reused for that purpose as well, so blaming Dave now for not paying
attention to the x86 early_res bits is unfair at least.
 
> I dont mind LMB per se, logically it seems quite similar to the
> early_res bits Yinghai has generalized (to a certain degree), and is
> quite a bit cleaner as you are writing very clean code.
>
> Note the other side of the coin: LMB appears to be deployed on only
> 4 non-x86 architectures that muster ~1% of the Linux boxes while
> early_res is deployed on more than 95%.

Come on, that's a stupid argument. The lmb code looks well structured
and understandable which I can't say about early_res.c. And it
definitly got a fair amount of testing and shakeout.

> So there's a very real hardship of testing and conversion here that
> we cannot ignore and an even better path may be to gradually
> transform the more tested and more deployed early_res code to meet
> the interface details of LMB.

I'd rather see moving that code to the cleaner code base of lmb.

> Please also realize the difficulties Yinghai has gone through
> already: converting and generalizing _all_ of the x86 early
> allocation code to a more generic core kernel approach, with
> essentially zero interest from _any_ non-x86 person ...  Those
> early_res patches were posted all over on lkml, it was literally
> hundreds of difficult patches, and now, months down the line, after
> we've tested and upstreamed it (with many nasty regressions fixed on
> x86 during the development of it) you come with a rigid "do it some
> other way, convert all of x86 over again or else" position.

That's not what Dave and Ben said. They just opposed that we push the
e820 horror into kernel/ and enforce it on everybody else.
 
> I really wish non-x86 architectures apprecitated (and helped) the
> core kernel work x86 is doing, because it is subsidizing non-x86
> architectures all the time.

Can we just stop that "x86 is the center of the universe" chant? 

Most of the core kernel work is done by core kernel developers. Just
because you and I ended up being x86 maintainers does not change that
at all.

In some areas the core code actually suffers from x86. Just look at
timers. At least 50% of the code in kernel/time/clock* and tick-* is
just there to cope with x86 specific hardware wreckage.

I don't see a point in doing the same thing with the e820 horror. That
code drop in kernel/fw_memmap.c is _NOT_ what I consider core kernel
work in the sense of providing generalized non arch specific
infrastructure.

Also I consider lmb core infrastructure. It does not have to be placed
in kernel/ to be accounted for it. It's pretty generic and easy to
extend.

> For example when LMB was plopped into lib/lmb.c in 2008 why was it
> not ported to x86, our most popular architecture? Did you consider

Why did _we_ not look at LMB? The early res code of x86 was (and still
is to some degree) a tangled mess and I wouldn't have expected that
some non x86 person would touch that with a ten foot pole.

We made a mistake and it got pointed out, so we better sit down and
make our homework instead of insisting that early_res/fw_memmap is
something set in stone.

> posting LMB patches for x86 instead of expecting Yinghai to post
> Sparc64, PowerPC, SH and Microblaze patches?

Well, it's pretty easy to move those archs over, but I cannot see any
reason why they should move to something which they consider inferior.
 
> Anyway, i'm sure we can work out an approach, and yes, LMB looks
> pretty good and could be picked up if it can be done gradually -
> given some mutual willingness to work on this as equals.

I think it was made entirely clear, that nobody is opposing to extend
lmb if the need arises. 

So before going any further on this early_res stuff, it needs to be
analysed what has to be done (if at all) to make lmb usable for
x86. From that we can figure out on a technical argument how to
proceed, not by reposting e820 -> kernel patches over and over.

Thanks,

	tglx
