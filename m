Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811Ab2FRWIK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 18:08:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:46187 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab2FRWIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 18:08:06 -0400
Date: Tue, 19 Jun 2012 00:08:01 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Richard Tollerton <richard.tollerton@gmail.com>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Robin Getz <rgetz@blackfin.uclinux.org>,
        Matt Mackall <mpm@selenic.com>, Nicholas Mc Guire <der.herr@hofr.at>,
        linux-security-module@vger.kernel.org
Subject: Re: How do embedded linux-rt systems fill their entropy/randomness
 pools?
In-Reply-To: <CAM7vvUeRQ0K5J-wtir4JmJcPRfFJtmvxn-yud16BG7KZupFNKg@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1206182321070.3086@ionos>
References: <CAM7vvUeRQ0K5J-wtir4JmJcPRfFJtmvxn-yud16BG7KZupFNKg@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard,

On Mon, 18 Jun 2012, Richard Tollerton wrote:
> Your "genirq: Disable random call on preempt-rt" commit on Jul 21 2009
> removes interrupt timings as a potential source of randomness for the
> kernel entropy pool, if CONFIG_PREEMPT_RT_FULL  is set. I have no qualms
> with this change, per se; manipulating the entropy pool is clearly
> something that shouldn't be happening at IRQ priority.
> 
> However: on an embedded linux-rt system with solid-state storage,
> add_input_randomness() ought to contribute no entropy at all, and
> add_disk_randomness() likely contributes a marginal amount of entropy,
> since SSD seek timings have little variance. That leaves ioctl(/dev/random,
> RNDADDENTROPY) as the only remaining entropy source. But no kernel drivers
> appear to use that, and few distributions have egd set up out-of-the-box.

Well, to be clear. Just do a 

  git grep IRQF_SAMPLE_RANDOM
 
over the mainline Linux source and you will find out, that this is
really not a RT problem.

That's a total of 28 places which have IRQF_SAMPLE_RANDOM set on their
interrupt request call.

You can see the very interesting file which matches that pattern:

Documentation/feature-removal-schedule.txt:What:        IRQF_SAMPLE_RANDOM
Documentation/feature-removal-schedule.txt:Check:       IRQF_SAMPLE_RANDOM
Documentation/feature-removal-schedule.txt:Why: Many of IRQF_SAMPLE_RANDOM users are technically bogus as entropy

Now obviosly neither that misfeature has been removed, nor one of the
folks who are interested in security, randomness etc. has come up with
any useful replacement.

> Thus, for a stock linux-rt kernel, it appears to be the case that **NOTHING
> POPULATES THE ENTROPY POOL**. I can readily reproduce this on a live
> linux-rt ARM system: after boot, /proc/sys/kernel/random/entropy_avail is
> 0, and stays there.

s/stock linux-rt kernel/stock linux kernel/ and I'm with you :)

> This, to me, seems to be a severe problem. In particular, if the embedded
> RT system is responsible for generating its own RSA keys for e.g. SSH/SSL
> on first boot, then the lack of entropy leaves it susceptible to
> catastrophic factorization attacks as documented in "Ron was wrong, Whit is
> right", http://eprint.iacr.org/2012/064.pdf, which made the news 3 months
> or so ago.
> 
> Do you agree with this analysis?

I agree that the lack of randomization is idiotic though I don't agree
that this is a RT problem. I have access to enough systems where RT
and mainline have exactly the same issue.

> Would anybody (else) be interested in pursing a realtime-safe way to use
> interrupt timings as an entropy source?

s/realtime-safe/proper/ and I'm all ear and probably a lot of other
folks as well.

Though I doubt that interrupt timings are going to solve the
problem. Just look at /proc/interrupts on your headless SSD equipped
entropy challenged system.

There is not much which can add to the entropy, really. And that's why
IRQF_SAMPLE_RANDOM is pretty useless and any attempt to make it useful
is probably as useless as well.

And I really disagree with the way how the randomness stuff is done
today. We feed crap into the random generator whether we need it or
not. Look at the code path, then you know _WHY_ I disabled it on RT
(aside of the RT specific locking issues). This stuff is really wrong,
independent of RT.

We need to provide randomness when a consumer needs it, but we don't
have to do expensive randomness calculations when there is no consumer
at all. So why not moving off the expensive computations into the
context of those who need it?

Some time ago I did some experiments on implementing a lockless per
cpu "ring buffer" which could be fed fast and w/o overhead with random
values. Unfortunatly I lost those patches while debugging some weird
file system corruption issue on RT and I never bothered to reimplement
them due to lack of bandwidth :(

But it shouldn't be that hard to reimplement something like that which
is fast and halfways deep (e.g. at least 4k samples per cpu) which can
be fed into the random generator consumer side on demand w/o affecting
the producers. The nice thing is that due to randomness you don't have
to care about races. It does not matter whether a producer overwrites
the value while the consumer side is reading it. And the consumer
side, which is the "slow" path can be a producer as well. It's code
pathes are equally random as any other ones chosen to be a producer.

For me that approach with a few producers sprinkled into frequently
used, but not crucial hot code pathes solved the annoying problem of
missing randomness in my embedded headless systems quite well, w/o
enforcing a braindamaged user space daemon which sucks energy forever
just to fix that shortcoming.

I know that it's not going to be a mathematically provable random
generator on the producer side, but I really don't care. As long as it
passes the various tests on the consumer side, I don't worry about
that theoretical part :)

There are enough papers out there, which cover the inherent randomness
of todays cpu systems, so go wild with finding the relevant points
which can be abused to a stick some value into the pools fast
path.

Thanks,

	tglx
