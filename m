Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab0LDOlr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 09:41:47 -0500
Received: from www.tglx.de ([62.245.132.106]:44818 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755114Ab0LDOlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 09:41:46 -0500
Date: Sat, 4 Dec 2010 15:41:05 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jan Kiszka <jan.kiszka@web.de>
cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        Tom Lyon <pugs@cisco.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 0/5] KVM&genirq: Enable adaptive IRQ sharing for
 passed-through devices
In-Reply-To: <4CFA2763.4060102@web.de>
Message-ID: <alpine.LFD.2.00.1012041526280.2653@localhost6.localdomain6>
References: <cover.1291419444.git.jan.kiszka@web.de> <alpine.LFD.2.00.1012041052450.2653@localhost6.localdomain6> <4CFA2763.4060102@web.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan,

On Sat, 4 Dec 2010, Jan Kiszka wrote:

> Am 04.12.2010 11:37, Thomas Gleixner wrote:
> > On Sat, 4 Dec 2010, Jan Kiszka wrote:
> > If interrupt is shared, then you want to keep the current behaviour:
> > 
> >    disable at line level (IRQF_ONESHOT)
> >    run handler thread (PCI level masking)
> >    reenable at line level in irq_finalize_oneshot()
> >    reenable at PCI level when guest is done
> 
> If the interrupt is shared, we must mask at PCI level inside the primary
> handler as we also have to support non-threaded users of the same line.
> So we always have a transition line-level -> device-level
> masking in a primary handler.

Sorry that left out the hard irq part. Of course it needs to do the
PCI level masking in the primary one.
 
> reduce the latency. So both threaded and non-threaded cases should be
> addressable by any approach.

The oneshot magic should work on non threaded cases as well. Needs
some modifications, but nothing complex.
 
> > If interrupts are in flight accross request/free then this change
> > takes effect when the next interrupt comes in.
> 
> For registration, that might be too late. We need to synchronize on
> in-flight interrupts for that line and then ensure that it gets enabled
> independently of the registered user. That user may have applied
> outdated information, thus would block the line for too long if user
> space decides to do something else.

No, that's really just a corner case when going from one to two
handlers and I don't think it matters much. If you setup a new driver
it's not really important whether that first thing comes in a few ms
later.

Also there is a pretty simple solution for this: The core code knows,
that there is an ONESHOT interrupt in flight, so it simply can call
the primary handler of that device with the appropriate flag set
(maybe an additional one to indicate the transition) and let that deal
with it. Needs some thought vs. locking and races, but that shouldn't
be hard.

> Pulling the effect of disable_irq_nosync into genirq also for threaded
> handling would remove the need for re-registering handlers. That's good.
> But we need to think about the hand-over scenarios again. Maybe
> solvable, but non-trivial.

See above.

Thanks,

	tglx
