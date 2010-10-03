Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032Ab0JCWzn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 18:55:43 -0400
Received: from gate.crashing.org ([63.228.1.57]:60103 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752874Ab0JCWzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 18:55:42 -0400
Subject: Re: [patch 46/47] powerpc: Use new irq allocator
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
In-Reply-To: <m1bp7bfc9n.fsf@fess.ebiederm.org>
References: <20100930221351.682772535@linutronix.de>
	 <20100930221743.014571381@linutronix.de> <1285893737.2463.4.camel@pasglop>
	 <alpine.LFD.2.00.1010011504380.2416@localhost6.localdomain6>
	 <m1bp7bfc9n.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Oct 2010 09:54:19 +1100
Message-ID: <1286146459.2463.308.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-10-03 at 09:53 -0700, Eric W. Biederman wrote:
> Thomas Gleixner <tglx@linutronix.de> writes:
> 
> >> That would make things much cleaner and in fact move one large step
> >> toward being able to make powerpc virq scheme generic, which seems to be
> >> a good idea from what I've heard :-)
> >
> > Yep.
> 
> I'm not certain about making the ppc virq scheme generic.  Maybe it is
> just my distorted impression but I have the understanding that ppc irq
> numbers mean nothing and are totally unstable whereas on x86 irq numbers
> in general are stable (across kernel upgrades and changes in device
> probe order) and the irq number has a useful hardware meaning.  Which
> means you don't have to go through several layers of translation tables
> to figure out which hardware pin you are talking about.

In addition to Thomas comments, it's actually more complex than that :-)

Even assuming that what you say is true (and last I looked at my x86
machine, it's not ... x86 remaps "GSI" numbers and the results doesn't
seem always entirely predictible. HT interrupts makes it worse and MSIs
just completely kill your argument :-)

Some setups have stable numbers, some don't. Hypervisors can return your
crazy HW interrupt numbers, etc...

However, remapping arbitrary crazy HW number is only one aspect of the
powerpc virq scheme (typically for IRQ domains using the radix tree
based reverse-map).

The main deal I'd say is that in embedded land (and to some extent I
suspect that's going to happen more with x86), you quickly end up with
multiple interrupt domains, via cascaded controllers of all kinds etc...

In fact, I've been in situations where I want to be able to hot plug
entire PICs.

At this point, you end up having -some- kind of scheme to map the linux
IRQ numbers to HW numbers. The "old way" to do that tends to be by
assigning fixed ranges of numbers. This somewhat works, but it is a bit
clumsy and not very dynamic nor suited for hotpluggable stuff. It
generally requires the platform code to know about everything and
declare such ranges, etc...

Now, if the stability of the numbers is a problem for you, there's a few
easy things to do to solve that:

 - First, and we do that today on powerpc, we reserve 1...15 as "legacy"
and only a PIC that claims to be "legacy" can claim them (for us that
means some kind of 8259). So your old style legacy x86 IRQs can remain
there if you want to.

 - In systems with one domain, we tend to often end up with virq ==
hwirq since we try to allocate the same number "by default". Probably
what happens today with GSI on my x86 box here.

 - Then, while powerpc allocates virq numbers when irqs are mapped, that
can be quite "late", it could be perfectly kosher to imagine a way for
"child" PICs to instead instanciate the mapping of their whole range
early. That way, their virq numbers remain contiguous, providing a
simpler 1:N mapping, and in embedded systems, you'll probably end up
with the same mapping on every boot.

 - Appart from the risk of breaking crap that parses /proc/interrupts,
adding the HW irq information there would be trivial and solve your
problem.

So overall, I don't see a problem at all. And it makes handling of
arbitrary combinations of interrupt domains (cascaded PICs) very very
easy indeed.

Cheers,
Ben.

