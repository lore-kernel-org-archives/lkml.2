Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908Ab2ESW4T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 18:56:19 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54700 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab2ESW4R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 18:56:17 -0400
Message-ID: <1337468148.573.139.camel@twins>
Subject: Re: Plumbers: Tweaking scheduler policy micro-conf RFP
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
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
Date: Sun, 20 May 2012 00:55:48 +0200
In-Reply-To: <CA+55aFzuygx6L-2hVCMbk5cvEdDp6AUtOGq-wYFn=4yEyebPLw@mail.gmail.com>
References: <CAKfTPtDSDAOAdv0GTDswZeRM7TmACrjok+5kddSaQpvy6_6xWw@mail.gmail.com>
	 <CAKfTPtCfiY7A29+e50F+6awd8BjNJjg4=uNN4ReZfdS_4FbpkA@mail.gmail.com>
	 <1337084609.27020.156.camel@laptop>
	 <CAKfTPtDz1-fR2i5x7AVd8sGZhX2VNtz2rnQC3ePrcHO9MWK3FQ@mail.gmail.com>
	 <1337086834.27020.162.camel@laptop>
	 <CAKfTPtDrZ-tfC81jnxwpB+DCtmxhU+VfoYbtSBr8MkFt+P8JcA@mail.gmail.com>
	 <1337096141.27694.82.camel@twins> <1337193010.27694.146.camel@twins>
	 <CA+55aFzuygx6L-2hVCMbk5cvEdDp6AUtOGq-wYFn=4yEyebPLw@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-05-19 at 10:08 -0700, Linus Torvalds wrote:

> Ingo, please don't take any of these patches if they are starting to
> make NUMA scheduling be some arch-specific crap.

I think there's a big mis-understanding here. I fully 100% agree with
you on that. And this thread in particular isn't about NUMA at all.

This thread is about modifying the arch interface of describing the
chip.

The current interface is we have 4 fixed topology domains:

 SMT
 MC
 BOOK
 CPU

(and the NUMA stuff comes on top of that and I just removed arch bits
from that, so lets leave that for now).

The first 3 domains depend on CONFIG_SCHED_{SMT,MC,BOOK} resp. and if an
architecture select one of those it will have to provide a function
cpu_{smt,coregroup,book}_mask and optionally put a struct sched_domain
initializer in their asm/topology.h.

Now I've had quite a few complaints from arch maintainers that the
sched_domain initializer is a far too unwieldy interface to fill out and
I quite agree with them.

Now all I've meant to propose in this thread is to replace the entire
above with a simpler interface.

Instead of the above all I'm asking of doing is providing something
along the lines of:

struct sched_topology arch_topology[] = {
	{ cpu_smt_mask, ST_SMT },
	{ cpu_llc_mask, ST_CACHE },
	{ cpu_socket_mask, ST_SOCKET },
	{ NULL, },
};

and that's just about all an arch would need to do.

That said, there are a few new things in ARM land like the big-little
stuff that have no direct relation to anything on the x86 side. And they
would very much like to have means of describing their chip topology as
well.


About power aware scheduling, yes its all a big mess and the current
stuff is horrid and broken.

That said, I do believe we can do better than nothing about it, and I'm
really not asking for anything perfect -- in fact I'm asking for pretty
much the same thing you are, something simple and understandable.

The simple pack stuff on a minimum amount of power-gated units instead
of spreading it out should get some benefit. For this we'd need to know
at what granularity a chip can power-gate.

> I'm very very serious about this. Try to make the scheduler have a
> *simple* model that people can actually understand. For example, maybe
> it can literally be a multi-level balancing thing, where the per-cpu
> runqueues are grouped into a "shared core resources" balancer that
> balances within the SMT or shared-L2 domain. And then there's an
> upper-level balancer (that runs much more seldom) that is written to
> balances within the socket. And then one that balances within the
> node/board. And finally one that balances across boards.

That is basically how the scheduler is set up. These are the
sched_domains.

There is an awful lot of complexity in that code though, and I've been
trying to clean some of that up but its very slow going.

The purpose of this thread is to both simplify and allow people to more
easily express what they really care about. For this we need to explore
the problem space.

I know I haven't replied to all your points, and I suspect many are
related to annoyances you might have from other threads and I shall
attempt to answer them later.

I do feel bad that I've managed to annoy you to such a degree though. I
really would rather have a much simpler load-balancer too.






