Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044Ab0JDAQG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 20:16:06 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:56910 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab0JDAQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 20:16:04 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
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
References: <20100930221351.682772535@linutronix.de>
	<20100930221743.014571381@linutronix.de>
	<1285893737.2463.4.camel@pasglop>
	<alpine.LFD.2.00.1010011504380.2416@localhost6.localdomain6>
	<m1bp7bfc9n.fsf@fess.ebiederm.org> <1286146459.2463.308.camel@pasglop>
Date: Sun, 03 Oct 2010 17:15:47 -0700
In-Reply-To: <1286146459.2463.308.camel@pasglop> (Benjamin Herrenschmidt's
	message of "Mon, 04 Oct 2010 09:54:19 +1100")
Message-ID: <m1pqvqdd8s.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Benjamin Herrenschmidt <benh@kernel.crashing.org>
X-Spam-Relay-Country: 
Subject: Re: [patch 46/47] powerpc: Use new irq allocator
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:

> On Sun, 2010-10-03 at 09:53 -0700, Eric W. Biederman wrote:
>> Thomas Gleixner <tglx@linutronix.de> writes:
>> 
>> >> That would make things much cleaner and in fact move one large step
>> >> toward being able to make powerpc virq scheme generic, which seems to be
>> >> a good idea from what I've heard :-)
>> >
>> > Yep.
>> 
>> I'm not certain about making the ppc virq scheme generic.  Maybe it is
>> just my distorted impression but I have the understanding that ppc irq
>> numbers mean nothing and are totally unstable whereas on x86 irq numbers
>> in general are stable (across kernel upgrades and changes in device
>> probe order) and the irq number has a useful hardware meaning.  Which
>> means you don't have to go through several layers of translation tables
>> to figure out which hardware pin you are talking about.
>
> In addition to Thomas comments, it's actually more complex than that :-)
>
> Even assuming that what you say is true (and last I looked at my x86
> machine, it's not ... x86 remaps "GSI" numbers and the results doesn't
> seem always entirely predictible. HT interrupts makes it worse and MSIs
> just completely kill your argument :-)

I won't say kill.  There are reasons for pushing for sparse irq
numbering, but some things you can't change until you have enough of the
bugs out that people stop compiling the arch with a small fixed sized
irq table.  The common case with MSI can be handled with 16bits...

Currently on x86 we practically have a 1-1 between GSI and irq numbers.
The difference is platforms who have insanely decided to use the freedom
in the ACPI spec to have GSI 0-15 be something other than the i82559
ISA irqs.  Those GSI's we remap.  The rest we leave alone.

We used to have an arbitrary and scary system that compressed GSIs into
some small NR_IRQS and I it is hard to describe how many bugs and weird
corner cases we killed when we removed that code on x86.

So I guess my argument really is that while requiring the users to pass
through a bit of a remapping layer to keep the code from making bad
assumptions isn't bad.  Irq numbers are cheap let's not be so frugal
with them that we create problems with ourselves.  Let's just remove
the hard coded NR_IRQ assumptions, and move on with life.

> Some setups have stable numbers, some don't. Hypervisors can return your
> crazy HW interrupt numbers, etc...

I agree.  There are limits to what can be done.

> However, remapping arbitrary crazy HW number is only one aspect of the
> powerpc virq scheme (typically for IRQ domains using the radix tree
> based reverse-map).
>
> The main deal I'd say is that in embedded land (and to some extent I
> suspect that's going to happen more with x86), you quickly end up with
> multiple interrupt domains, via cascaded controllers of all kinds etc...
>
> In fact, I've been in situations where I want to be able to hot plug
> entire PICs.

I have no problems handling nested irq controllers, that seems sensible.

> At this point, you end up having -some- kind of scheme to map the linux
> IRQ numbers to HW numbers. The "old way" to do that tends to be by
> assigning fixed ranges of numbers. This somewhat works, but it is a bit
> clumsy and not very dynamic nor suited for hotpluggable stuff. It
> generally requires the platform code to know about everything and
> declare such ranges, etc...

Agreed.

> Now, if the stability of the numbers is a problem for you, there's a few
> easy things to do to solve that:

I care about stability more as a metric than as an absolute goal.

>  - First, and we do that today on powerpc, we reserve 1...15 as "legacy"
> and only a PIC that claims to be "legacy" can claim them (for us that
> means some kind of 8259). So your old style legacy x86 IRQs can remain
> there if you want to.

There are weird corner cases in the code that break if you don't do
that.

>  - In systems with one domain, we tend to often end up with virq ==
> hwirq since we try to allocate the same number "by default". Probably
> what happens today with GSI on my x86 box here.

Pretty much.

>  - Then, while powerpc allocates virq numbers when irqs are mapped, that
> can be quite "late", it could be perfectly kosher to imagine a way for
> "child" PICs to instead instanciate the mapping of their whole range
> early. That way, their virq numbers remain contiguous, providing a
> simpler 1:N mapping, and in embedded systems, you'll probably end up
> with the same mapping on every boot.

Which is probably good enough for most purposes.

>  - Appart from the risk of breaking crap that parses /proc/interrupts,
> adding the HW irq information there would be trivial and solve your
> problem.

At this point in time getting things into sysfs seems the way to handle
that.

Eric
