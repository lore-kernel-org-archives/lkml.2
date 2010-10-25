Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775Ab0JYNsI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 09:48:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34878 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755261Ab0JYNsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 09:48:06 -0400
Date: Mon, 25 Oct 2010 15:47:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Huang Ying <ying.huang@intel.com>, Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Borislav Petkov <petkovbb@googlemail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Don Zickus <dzickus@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [NAK] Re: [PATCH -v2 9/9] ACPI, APEI, Generic Hardware Error
 Source POLL/IRQ/NMI notification type support
Message-ID: <20101025134740.GA8888@elte.hu>
References: <1287992610-14996-1-git-send-email-ying.huang@intel.com>
 <1287992610-14996-10-git-send-email-ying.huang@intel.com>
 <20101025084553.GA27119@elte.hu>
 <1287997112.2862.322.camel@yhuang-dev>
 <20101025091913.GA17622@basil.fritz.box>
 <20101025111530.GA27659@elte.hu>
 <20101025123753.GB17622@basil.fritz.box>
 <20101025125531.GA6075@elte.hu>
 <20101025131127.GC17622@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101025131127.GC17622@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> On Mon, Oct 25, 2010 at 02:55:31PM +0200, Ingo Molnar wrote:
> > 
> > * Andi Kleen <andi@firstfloor.org> wrote:
> > 
> > > On Mon, Oct 25, 2010 at 01:15:30PM +0200, Ingo Molnar wrote:
> > > 
> > > > > > > einj.c: it's about the 3rd separate 'error injection' concept that got 
> > > > > > > introduced ...
> > > > > > 
> > > > > > EINJ is a true platform feature, not just software feature. We need to support 
> > > > > > it to debug various hardware error features.
> > > > > 
> > > > > Also having multiple error injecting interfaces is a good thing.
> > > > 
> > > > It's never a good thing to have separate, vendor dependent interfaces for what 
> > > > to the user is basically the same conceptual thing!
> > > 
> > > Perhaps a simple example (simplified, in practice there are more complications) 
> > > makes it more clear:
> > > 
> > > The memory error handler does different actions depending on what the state the 
> > > page the error is happening on is in.
> > 
> > What you appear to be arguing for is the ability to inject different types of 
> > events.
> 
> Different events in different contexts with different drivers with different 
> parameters [...]

Correct.

> [...] using different tools.

That's possible, but i'd expect tools/ras/ to be populated with uniformly working 
tools. There's little sense in fragmenting the hw-testing field...

> Commonality: about 0% exept there's "error" somewhere in the description.

Wrong. Their main purpose is common: they are events attached to existing hardware 
topologies, which events can be configured, which events can be received and which 
can be injected with attributes for rare-event simulation purposes.

The tool people have spoken to us clear and loud that they want to _receive_ events 
in a unified and structured way - not via lots of separate ABIs from facilities that 
have mismatching capabilities.

We want to be able to inject _other_ events as well, not just hw-error ones - 
especially rare ones.

I.e. there's clear, demonstrated, patches-pending demand for uniformity and there's 
similar demand for a broader concept.

You are now making the point that somehow the receipt and sending/injecting of 'hw 
errors on Intel hardware' should be a separate, fragmented, disoriented, messy piece 
of interface design, closely matching some ACPI spec detail, which should be 
disassociated from the preferred mechanism of error reporting?

Your argument makes absolutely no sense to me.

The kernel is an abstraction machine: common hw aspects should be generalized to the 
extent it makes sense, with reasonable extensions for anything we dont want (or 
cannot) generalize.

There's _tons_ of interesting structure here to be taken advantage of: just look at 
what Boris is trying to achieve with his EDAC tooling patches. See what Lin Ming is 
trying to do by moving event descriptors to /sys, so that events can come with 
elements of our hw and sw topology in a natural way.

There is absolutely no justification whatsoever for the new /dev/erst-dbg ABI ...

Furthermore, you have ignored my other argument for the second time now: why does 
this code not do the event _reporting_ via the facilities we use and prefer? As far 
as users are concerned, the ability to receive hardware error events in a unified 
way is an even more important aspect than the matter of event injection.

Once you do that i think you will see how naturally error injection fits into the 
picture as well. It is an aspect of pretty much any event (not just hw-error events) 
that we want to be able to 'inject/simulate' them, to test tools.

Your refusal to even consider this possibility and to look at the EDAC/RAS patches 
that deal with this is puzzling to me.

Thanks,

	Ingo
