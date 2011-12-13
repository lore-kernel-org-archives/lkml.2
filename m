Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab1LMOYO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 09:24:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754295Ab1LMOYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 09:24:13 -0500
Message-ID: <4EE75FF8.5060208@redhat.com>
Date: Tue, 13 Dec 2011 16:23:52 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [patch 0/3] kvm tool: Serial emulation overhaul
References: <20111210132220.083204833@linutronix.de> <alpine.LFD.2.02.1112101715500.10936@tux.localdomain> <alpine.LFD.2.02.1112102144370.3020@ionos> <alpine.LFD.2.02.1112111014500.1663@tux.localdomain> <20111211103047.GA19299@elte.hu> <alpine.LFD.2.02.1112111459270.3020@ionos> <20111211155347.GA1297@elte.hu> <CAOJsxLHTuN43AGA7C02MtETzJU87y9cRaWRg6e9ER7NxOK2w-Q@mail.gmail.com> <20111212172059.GC23870@elte.hu> <CAOJsxLFk9Af+b4PAx_j+1QhApBsFdXyZY1aK08fb_6_dTiBEDQ@mail.gmail.com> <20111212192135.GA18876@elte.hu> <alpine.LFD.2.02.1112130056370.3020@ionos> <4EE72FCB.3070109@redhat.com> <alpine.LFD.2.02.1112131434320.3020@ionos>
In-Reply-To: <alpine.LFD.2.02.1112131434320.3020@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2011 03:52 PM, Thomas Gleixner wrote:
> On Tue, 13 Dec 2011, Avi Kivity wrote:
>
> > On 12/13/2011 02:59 AM, Thomas Gleixner wrote:
> > 
> > <snip trace>
> > > Why the heck is a paravirtualized guest using an local APIC timer
> > > emulation, instead of a paravirtualized clock event device?
> > >
> > > Just look at the trace. That's insane. We enter the guest for 2us to
> > > come back and handle the APIC_EOI for 11us. Then we go back to the
> > > guest for 9us and spend again 11us for handling a write to APIC_TMICT.
> > >
> > > That's 11us guest vs. 22us host time.
> > 
> > Run your guest with x2apic enabled, the timing will be very different. 
>
> And what magic do I have to use to make that happen other than having
> x2apic support enabled in the kernel? Or do I need a certain kernel
> version for host and guest to make that work?

With qemu, -cpu host or -cpu blah,+x2apic.  kvm-tool does the equivalent
of -cpu host, so I'm surprised it doesn't show up.  x2apic has been
recognized by the guest for a long time (ce69a784; 2.6.32, I'll be
surprised if you have anything older than that on your machine).

Does x2apic show up in your guest's /proc/cpuinfo?

> > The problem with paravirt clockevents is that if/when the APIC becomes
> > virtualized, then guests which were started with the paravirt
> > clockevents don't get accelerated when they are migrated onto newer
> > hardware.  This problem has bitten us several times in the past; if you
> > want to see how it looks when applied on a large scale look at Xen -
> > they have a paravirt-the-fsck-out-of-everything mode and a full virt
> > mode (which should be way faster these days); the two aren't
> > compatible.  Of course back when they started, they didn't have a
> > choice, but we do.
>
> Well, I can see the migration pain for life migration and I agree that
> paravirt the world and some more is a horror as well. Though there is
> a midground between everything and being smart about certain
> aspects. 

Agree, clocksource is one example where the gain exceeds the pain.

> The whole APIC timer calibration and the back and forth
> conversion is definitely nothing which falls into the category of
> smart.

APIC timer calibration is silly but it hasn't proven to be a real-world
problem.

-- 
error compiling committee.c: too many arguments to function

