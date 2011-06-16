Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab1FPDCM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 23:02:12 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50862 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab1FPDCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 23:02:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kcBgp7NXpNX+3i7xnF50u0Gime89L3k2TdlgM5+h+YfkhJ10pmTsMwrMe+u88gQxAA
         0DVsk9O2qwSsrNIONzbsWm31GLlIZpLYGl08y0d6PX4xaETuf+r6zBlNIXpxOiiEDIft
         m2NpMAGAWSJQorxPC7n27DRB4DoB4ZSbJiVcI=
Date: Thu, 16 Jun 2011 05:02:04 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Sharp <dhsharp@google.com>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Rubin <mrubin@google.com>, x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiaying Zhang <jiayingz@google.com>
Subject: Re: [PATCH v2] trace: Add x86 irq vector entry/exit tracepoints
Message-ID: <20110616030200.GC18579@somewhere.redhat.com>
References: <1304107962-18576-1-git-send-email-vnagarnaik@google.com>
 <1306877298-31713-1-git-send-email-vnagarnaik@google.com>
 <20110531235957.GB5256@somewhere.redhat.com>
 <BANLkTi=YYCXHi5k82Q+sE6+134i97pjjAA@mail.gmail.com>
 <BANLkTinT6ULRWwHAGYFpQSw-ptQiuzrkPtZuKVZHD8b5mh9hpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinT6ULRWwHAGYFpQSw-ptQiuzrkPtZuKVZHD8b5mh9hpA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry guys I only found your answers today by browsing my email client.
I guess I posponed my reading but completely forgot :-(

On Wed, Jun 01, 2011 at 04:30:18PM -0700, David Sharp wrote:
> On Wed, Jun 1, 2011 at 3:38 PM, Vaibhav Nagarnaik <vnagarnaik@google.com> wrote:
> > On Tue, May 31, 2011 at 5:00 PM, Frederic Weisbecker
> > <fweisbec@gmail.com> wrote:
> >>
> >> IIRC, Thomas suggested in the v1 to turn arch tracepoints into core ones when they
> >> stand for generic (ie: shared by all archs) event meaning.
> >>
> >> I don't know where the discussion went after that, but that still seems to
> >> me an important direction. Tracing irqs by their vector number should be reserved
> >> for pure arch meanings. Sharing common tracepoints for generic events amongst archs makes life
> >> easier for tools. Bonus when the tracepoint can be placed in the generic code.
> >>
> >
> > I agree with you that the tracepoints should be as generic as possible
> > to have them traced across platforms, but I see these tracepoints as
> > specific to x86 platform. Since most of these vectors are x86 specific.
> > The only ones that you pointed out as generic were:
> 
> I think what Vaibhav means is that this is "the one trace event for
> all hard IRQs on the platform". A tracepoint for the cross-platform
> irq handlers is also useful, but that is not the purpose of this
> tracepoint.

If a generic tracepoint can replace one per arch, we all want that instead.
This is 24 times (24 archs) less maintainance burden.

So if that doesn't meet your needs, you really need to explain us in detail why.

I believe it's fine to deduce from a generic timer tracepoint that the arch fired
a specific interrupt to achieve that.

You might need some low level details, but then tell us why.

> There's not actually much overlap between platforms for
> IRQs, so each platform needs to do the work of covering all their
> IRQs, and won't see much benefit from the generic tracepoints.

There is at least 5 overlaps. And everybody will benefit from the generic tracepoints.

> On Tue, May 31, 2011 at 5:00 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > Tracing irqs by their vector number should be reserved for pure arch meanings.
> 
> exactly, and this tracepoint is for that "arch meaning".

Ok but there is no point in having an arch tracepoint where the arch code is only
doing:

arch_foo_irq()
{
	generic_foo_irq();
}

It may do some specific low level things, ack the apic, etc... But that's not what
is interesting, right? What is interesting is the fact you have an interrupt.

> I'd also add that having these tracepoints here makes it more obvious
> that we will get all IRQ events, which is what is important to us.

Look at those arch level handlers, it's doesn't seem you can miss anything there.

It can happen in the case of the local apic timer, but then you get a warning
of spurious LAPIC timer interrupt. They are corner cases, better check these
rather than tracing every layers to ensure you always get everything.
