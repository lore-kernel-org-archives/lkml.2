Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512Ab1EQTSU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 15:18:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51235 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756397Ab1EQTSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 15:18:17 -0400
Date: Tue, 17 May 2011 21:18:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Don Zickus <dzickus@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>, Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [RFC] ACPI, APEI, Generic Hardware Error Source (GHES) injecting
 support
Message-ID: <20110517191803.GC29574@elte.hu>
References: <1304996921-24881-1-git-send-email-ying.huang@intel.com>
 <20110516193301.GF29881@redhat.com>
 <4DD218B1.7080601@intel.com>
 <20110517135027.GJ31888@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110517135027.GJ31888@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Don Zickus <dzickus@redhat.com> wrote:

> On Tue, May 17, 2011 at 02:41:53PM +0800, Huang Ying wrote:
> > On 05/17/2011 03:33 AM, Don Zickus wrote:
> > > On Tue, May 10, 2011 at 11:08:41AM +0800, Huang Ying wrote:
> > >> The testing of Generic Hardware Error Source (GHES) is quite
> > >> difficult, because special hardware is needed to trigger the hardware
> > >> error. So a software based hardware error injector for GHES is
> > >> implemented.
> > >>
> > >> Error notification is not provided in this patch.  So you still need
> > >> some NMI/SCI/IRQ injecting support to make it work.
> > > 
> > > Should we add that to this patch, otherwise it seems like the injection
> > > isn't very useful or intuitive from the end-user perspective that they
> > > have to provide their own notification source (ie NMI/SCI/MCE/IRQ).
> > 
> > We can provide the NMI/SCI/IRQ injecting in another patch.  What do you
> > think about the NMI injecting patch attached?
> 
> I understand what the patch is doing and I like the various injection
> points, but looking at your other injection modules I start to wonder if
> there is a smarter and easier way to do all this.  I believe the software
> injection is definitely useful but it does add bloat to the kernel.
> 
> I am starting to like Ingo's event filtering idea for stuff like this I
> think (though I am still wrapping my head around it).  The beauty of
> kprobes and tracepoints and even jump labels was that they were not very
> intrusive, they did their work on the side.  It would be nice if we could
> figure out a framework for the injection stuff that did something similar.
> 
> Perhaps Ingo has some ideas?

Boris has injection in the EDAC code as well and wants it for RAS purposes and 
i recently outlined to him how event injection could possible look like in the 
not so far future:

---------------->

I think the model we want is to inject actual perf events at the *kernel* 
level, and to add the ability for some events (MCE events here) to also run a 
(optional) callback once user-space does that injection.

So for example [sufficienty privileged] user-space could inject *any* perf 
event - for example a PERF_COUNT_HW_CACHE_MISSES event (for test purposes) and 
any tooling that runs could not tell apart this injected event from a real 
event.

Once we have that, adding a injection callback to MCE events is just another 
step: such a callback could propagate the injected event to the real hardware 
for example, if that is possible. (it would validate, etc. as well)

In the generic case the event just gets injected into the perf event stream.

The ABI for injection could be some obvious extension, either another ioctl 
variant to the perf fd itself, we already have various ways to access it:

 #define PERF_EVENT_IOC_ENABLE           _IO ('$', 0)
 #define PERF_EVENT_IOC_DISABLE          _IO ('$', 1)
 #define PERF_EVENT_IOC_REFRESH          _IO ('$', 2)
 #define PERF_EVENT_IOC_RESET            _IO ('$', 3)
 #define PERF_EVENT_IOC_PERIOD           _IOW('$', 4, __u64)
 #define PERF_EVENT_IOC_SET_OUTPUT       _IO ('$', 5)
 #define PERF_EVENT_IOC_SET_FILTER       _IOW('$', 6, char *)

Or sys_write() access to the perf event fd. The sys_write() one looks like the
conceptually nicest solution to me, because we can read() the fd as well to get
event (counts..) out of it.

I think this model would give us a *lot* of testing power, and we could utilize
arbitrary hardware-injection capabilities as well.

<----------------

That way what would remain in mm/memory-failure.c file is all the useful (and 
interesting!) MM specific knowledge: the method of getting to a list of 
affected tasks for policy action, to collect the tasks that are affected by an 
anonymous page going bad, or by a pagecache page going bad, etc.

These would be offered as filter action functionality, and could be triggered 
from filters straight in the kernel, without having to touch a user-space 
daemon.

The whole boring transport, filtering, enumeration and configuration that is 
duplicated here would go away and would be replaced by EVENT() definitions in 
the places that generate events and callbacks to filter action in 
mm/memory-inject.c.

Now what is somewhat unfortunate as a practical matter is that some of this 
functionality has already been exposed in semi-ABI ways in an ad-hoc fashion, 
so some of the design may be hardcoded. That does not keep me from pointing out 
when i see the mess growing ... :-)

Thanks,

	Ingo
