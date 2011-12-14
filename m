Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769Ab1LNRdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 12:33:15 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:55702 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757749Ab1LNRdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 12:33:12 -0500
Message-ID: <1323883915.6805.50.camel@work-vm>
Subject: Re: [RFC 0/2] ABI for clock_gettime_ns
From: john stultz <johnstul@us.ibm.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Richard Cochran <richardcochran@gmail.com>, linux-kernel@vger.kernel.org,
        Kumar Sundararajan <kumar@fb.com>, Arun Sharma <asharma@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 14 Dec 2011 09:31:55 -0800
In-Reply-To: <CALCETrW+g6_VSUJJz4NSVwjKhMo+U_3uQDe9W6uEXdjTuaXVhA@mail.gmail.com>
References: <cover.1323739287.git.luto@amacapital.net>
	 <20111213032406.GA9604@netboy.at.omicron.at>
	 <1323747782.4078.144.camel@work-vm>
	 <CALCETrV8MWwv5ei=4FirhEMyKR5A6hkq4sGSmFqo=mCgopdgXg@mail.gmail.com>
	 <20111214074640.GB2180@netboy.at.omicron.at>
	 <1323881310.6805.41.camel@work-vm>
	 <CALCETrW+g6_VSUJJz4NSVwjKhMo+U_3uQDe9W6uEXdjTuaXVhA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11121417-3534-0000-0000-00000395B95F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-14 at 09:15 -0800, Andy Lutomirski wrote:
> On Wed, Dec 14, 2011 at 8:48 AM, john stultz <johnstul@us.ibm.com> wrote:
> > On Wed, 2011-12-14 at 08:46 +0100, Richard Cochran wrote:
> >>
> >> What about this sort of time value?
> >>
> >> struct sys_timeval {
> >>       __s64 nanoseconds;
> >>       __u32 fractional_ns;
> >> };
> >>
> >> The second field can just be zero, for now.
> >
> > I'm mixed on this.
> >
> > We could do this, as the kernel keeps track of sub-ns granularity.
> > However, its not stored in a decimal format. So I worry the extra math
> > needed to convert it to something usable might add extra overhead,
> > removing the gain of the proposed clock_gettime_ns() interface.
> >
> 
> I would actually prefer units of 2^-32 ns over .  I have no attachment
> to SI picoseconds so long as the units are constant.

2^-32ns would be much easier to do.


> Windows sidesteps this issue by returning arbitrary units and telling
> the user what those units are.  This adds a lot of unpleasantness (try
> relating the timestamps to actual wall time) and we need to rescale
> the time anyway for NTP.
> 
> What about:
> 
> struct sys_timeval {
>     u64 nanoseconds;  /* unsigned.  the current time will always be
> after 1970, and those extra 290 years might be nice. */

I'd suspect we will still need this to be signed if it goes to userland.
In-kernel u64 for nanoseconds is fine because it doesn't have to deal
with anything that far in the past. But for userland we probably should
use s64. 

>     u64 padding;  /* for later.  currently always zero. */
> 
> That way, once there's both an implementation and a use case, we can
> implement it.  In the mean time, the overhead is probably immeasurably
> low -- it's a single assignment.

This sounds good to me. 

Kumar, Arun, I know we've strayed a bit from your original patch, but
any objections here?

thanks
-john




