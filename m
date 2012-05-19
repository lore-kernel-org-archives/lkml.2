Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab2ESRJS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 13:09:18 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35120 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab2ESRJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 13:09:16 -0400
MIME-Version: 1.0
In-Reply-To: <1337193010.27694.146.camel@twins>
References: <CAKfTPtDSDAOAdv0GTDswZeRM7TmACrjok+5kddSaQpvy6_6xWw@mail.gmail.com>
 <CAKfTPtCfiY7A29+e50F+6awd8BjNJjg4=uNN4ReZfdS_4FbpkA@mail.gmail.com>
 <1337084609.27020.156.camel@laptop> <CAKfTPtDz1-fR2i5x7AVd8sGZhX2VNtz2rnQC3ePrcHO9MWK3FQ@mail.gmail.com>
 <1337086834.27020.162.camel@laptop> <CAKfTPtDrZ-tfC81jnxwpB+DCtmxhU+VfoYbtSBr8MkFt+P8JcA@mail.gmail.com>
 <1337096141.27694.82.camel@twins> <1337193010.27694.146.camel@twins>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 19 May 2012 10:08:54 -0700
X-Google-Sender-Auth: ulMT0u5snY7-kt_ajbB4lvBY3mM
Message-ID: <CA+55aFzuygx6L-2hVCMbk5cvEdDp6AUtOGq-wYFn=4yEyebPLw@mail.gmail.com>
Subject: Re: Plumbers: Tweaking scheduler policy micro-conf RFP
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>, paulmck@linux.vnet.ibm.com,
        smuckle@quicinc.com, khilman@ti.com, Robin.Randhawa@arm.com,
        suresh.b.siddha@intel.com, thebigcorporation@gmail.com,
        venki@google.com, panto@antoniou-consulting.com, mingo@elte.hu,
        paul.brett@intel.com, pdeschrijver@nvidia.com, pjt@google.com,
        efault@gmx.de, fweisbec@gmail.com, geoff@infradead.org,
        rostedt@goodmis.org, tglx@linutronix.de, amit.kucheria@linaro.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linaro-sched-sig@lists.linaro.org,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Juri Lelli <juri.lelli@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 11:30 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> The reason I want to push this into the arch is that the current one
> size fits all topology really doesn't fit.

NAK NAK NAK.

Ingo, please don't take any of these patches if they are starting to
make NUMA scheduling be some arch-specific crap.

Peter - you're way off base. You are totally and utterly wrong for
several reasons:

 - x86 isn't that special. In fact, x86 covers almost all the possible
NUMA architectures just within x86, so making some arch-specific NUMA
crap is *idiotic*.

  Your argument that SMT, multi-core with NUMA effects within the
core, yadda yadda is somehow x86-specific is pure crap. Everybody else
already does that or will do that. More importantly, most of the other
architectures don't even *matter* enough for them to ever write their
own NUMA scheduler.

 - NUMA topology details aren't even that important!

   Christ, people. You're never going to be perfect anyway. And
outside of some benchmarks, and some trivial loads, the loads aren't
going to be well-behaved to really let you even try.

  You don't even know what the right scheduling policy should be. We
already know that even the *existing* power-aware scheduling is pure
crap and nobody believes it actually works.

Trying to redesign something from scratch when you don't even
understand it, AND THEN MAKING IT ARCH-SPECIFIC, is just f*cking
moronic. The *only* thing that will ever result in is some crap code
that handles the one or two machines you tested it on right, for the
one or two loads you tested it with.

If you cannot make it simple enough, and generic enough, that it works
reasonably well for POWER and s390 (and ARM), don't even bother.

Seriously.

If you hate the s390 'book' domain and it really causes problems, rip
it out. NUMA code has *never* worked well. And I'm not talking just
Linux. I'm talking about all the other systems that tried to to do it,
and tried too effin hard.

Stop the idiocy. Make things *simpler* and *less* capable instead of
trying to cover some "real" topology. Nobody cares in real life.
Seriously. And the hardware people are going to keep on making things
different. Don't try to build up some perfect NUMA topology and then
try to see how insanely well you can match a particular machine. Make
some generic "roughly like this" topology with (say) four three of
NUMAness, and then have architectures say "this is roughly what my
machine looks like".

And if you cannot do that kind of "roughly generic NUMA", then stop
working on this crap immediately. Rather than waste everybodys time
with some crazy arch-specific random scheduling.

Make the levels be something like

 (a) "share core resources" (SMT or shared inner cache, like a shared
L2 when there is a big L3)
 (b) share socket
 (c) shared board/node

and don't try to make it any more clever. Don't try to describe just
*how* much resources are shared. Nobody cares at that level. If it's
not a difference of an order of magnitude, it's damn well the same
f*cking thing!  Don't think that SMT is all that different from "two
cores sharing the same L2". Sure, they are different, but you won't
find real-life loads that care enough for us to ever bother with the
differences.

Don't try to describe it any more than that. Seriously. Any time you
add "implementation detail" level knowledge (like the s390 'book' or
the various forms of SMT vs "shared decorer" (Bulldozer/Trinity) vs
"true cores sharing L2" (clusters of cores sharing an L2, with a big
shared L3 within the socket), you're just shooting yourself in the
foot. You're adding crap that shouldn't be added.

In particular, don't even try to give random "weights" to how close
things are to each other. Sure, you can parse (and generate) those
complex NUMA tables, but nobody is *ever* smart enough to really use
them. Once you move data between boards/nodes, screw the number of
hops. You are NOT going to get some scheduling decision right that
says "node X is closer to node Y than to node Z". Especially since the
load is invariably going to access non-node memory too *anyway*.

Seriously, if you think you need some complex data structures to
describe the relationship between cores, you're barking up the wrong
tree.

Make it a simple three-level tree like the above. No weights. No
*nothing*. If there isn't an order of magnitude difference in
performance and/or a *major* power domain issue, they're at the same
level. Nothing smarter than that, because it will just be f*cking
stupid, and it will be a nightmare to maintain, and nobody will
understand it anyway.

And the *only* thing that should be architecture-specific is the
architecture CPU init code that says "ok, this core is a SMT thread,
so it is in the same (a) level NUMA domain as that other core".

I'm very very serious about this. Try to make the scheduler have a
*simple* model that people can actually understand. For example, maybe
it can literally be a multi-level balancing thing, where the per-cpu
runqueues are grouped into a "shared core resources" balancer that
balances within the SMT or shared-L2 domain. And then there's an
upper-level balancer (that runs much more seldom) that is written to
balances within the socket. And then one that balances within the
node/board. And finally one that balances across boards.

Then, at each level, just say "spread out" (unrelated loads that want
maximum throughput) vs "try to group together" (for power reasons and
to avoid cache bouncing for related loads).

I dunno what the details need to be, and the above is just some random
off-the-cuff example.

But what I *do* know that we don't want any arch-specific code. And I
*do* know that the real world simply isn't simple enough that we could
ever do a perfect job, so don't even try - instead aim for
"understandable, maintainable, and gets the main issues roughly
right".

                               Linus
