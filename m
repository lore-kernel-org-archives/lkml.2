Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758004Ab1LNTIM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 14:08:12 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:47286 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757122Ab1LNTII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 14:08:08 -0500
Message-ID: <1323889666.6805.71.camel@work-vm>
Subject: Re: [RFC 0/2] ABI for clock_gettime_ns
From: john stultz <johnstul@us.ibm.com>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        Kumar Sundararajan <kumar@fb.com>, Arun Sharma <asharma@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 14 Dec 2011 11:07:46 -0800
In-Reply-To: <20111214183025.GB2465@netboy.at.omicron.at>
References: <cover.1323739287.git.luto@amacapital.net>
	 <20111213032406.GA9604@netboy.at.omicron.at>
	 <1323747782.4078.144.camel@work-vm>
	 <CALCETrV8MWwv5ei=4FirhEMyKR5A6hkq4sGSmFqo=mCgopdgXg@mail.gmail.com>
	 <20111214074640.GB2180@netboy.at.omicron.at>
	 <1323881310.6805.41.camel@work-vm>
	 <20111214183025.GB2465@netboy.at.omicron.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11121419-9360-0000-0000-00000184299D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-14 at 19:30 +0100, Richard Cochran wrote:
> On Wed, Dec 14, 2011 at 08:48:30AM -0800, john stultz wrote:
> > On Wed, 2011-12-14 at 08:46 +0100, Richard Cochran wrote:
> > > On Mon, Dec 12, 2011 at 11:09:29PM -0800, Andy Lutomirski wrote:
> > > > On Mon, Dec 12, 2011 at 7:43 PM, john stultz <johnstul@us.ibm.com> wrote:
> > > > >> - New name, to distance ourselves from POSIX (clock_ns_get?)
> > > > 
> > > > I will defer to the bikeshedding consensus :)
> > > > 
> > > > >> - Family of calls, with set/get
> > > > 
> > > > Setting the time is a big can of worms.  adjtimex is rather
> > > > incomprehensible (without reading lots of source and/or the rfc) and
> > > > IMO puts a lot of NTP magic into the kernel, where it doesn't belong.
> > 
> > Honestly, I don't really see how we jumped to adjtimex from setting the
> > time, nor the complexity hinted at. First, the rational for getting
> > clock_gettime_ns is to avoid the overhead of userland translating from
> > timespec to ns.   I doubt there are similar performance needs for
> > settimeofday().  Even if it was needed, it shouldn't be more complex
> > then the unit conversion done in this abi patch. Am I missing something?
> 
> So, you agree on adding new syscalls as a performance tweek?

Well, the patch that started this off was introducing a new vdso
function (which had no syscall equivalent) that provided the same data
as clock_gettime(CLOCK_THREAD_CPUTIME,...) but in ns format, because
that was a reasonable performance win.

While I'm not eager to add duplicative interfaces, if the syscall data
structure is in the way of performance, folks will make ugly hacks to
get around it, so we might as well adapt to something better as a
standard interface. However, to avoid maintenance burden, I'd like to
keep the duplicative interfaces similar so we can share as much back-end
logic as possible.

> I am not against it, but I do think syscalls should try to satisfy a
> large number of user cases.

I don't think what is being proposed is trying to limit its use cases.
The only limitation api wise was if we should return just nanoseconds or
something with the potential for sub-ns values.

> > But again, the hard part with in-kernel TAI (possibly as the base of
> > time)is that initialization of the TAI/UTC offset needs to be able to be
> > phased in slowly, as we also have to preserve legacy interfaces and
> > behavior. 
> 
> With brand new syscall, there are no legacy uses.
> 
> > Why do we need a new interface for TAI? clock_gettime(CLOCK_TAI,...)
> > should be achievable. I do think it would be interesting, but I also
> > think its separate from the goal of this proposal.
> 
> I mean to define an interface that always returns TAI values, no matter
> what the clock device.

Maybe I'm still not understanding, but that seems more limited then what
is being proposed, at least in my mind. clock_gettime_ns() would still
take a clockid, so having a CLOCK_TAI would be a potential change in the
future.

I don't see a reason to limit clock_gettime_ns() to only CLOCK_TAI.
After all, while CLOCK_TAI doesn't have leapseconds, it still can be set
by userland if its wrong, so it doesn't provide the same functionality
as CLOCK_MONOTONIC. Additionally, the motivation for this new interface
is for a more efficient CLOCK_THREAD_CPUTIME vdso implementation, so an
exclusive CLOCK_TAI interface wouldn't serve that need.

I agree adding CLOCK_TAI is an interesting feature, but that could done
properly with the existing clock_gettime() interface. So I think the
CLOCK_TAI discussion is really disconnected from the new ABI being
proposed.

thanks
-john



