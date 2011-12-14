Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994Ab1LNS6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 13:58:24 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:38070 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307Ab1LNS6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 13:58:21 -0500
Message-ID: <1323889023.6805.61.camel@work-vm>
Subject: Re: [RFC 0/2] ABI for clock_gettime_ns
From: john stultz <johnstul@us.ibm.com>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        Kumar Sundararajan <kumar@fb.com>, Arun Sharma <asharma@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 14 Dec 2011 10:57:03 -0800
In-Reply-To: <20111214182121.GA2465@netboy.at.omicron.at>
References: <cover.1323739287.git.luto@amacapital.net>
	 <20111213032406.GA9604@netboy.at.omicron.at>
	 <1323747782.4078.144.camel@work-vm>
	 <20111214072058.GA2180@netboy.at.omicron.at>
	 <1323879832.6805.24.camel@work-vm>
	 <20111214182121.GA2465@netboy.at.omicron.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11121418-6148-0000-0000-000001F5E59E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-14 at 19:21 +0100, Richard Cochran wrote:
> On Wed, Dec 14, 2011 at 08:23:52AM -0800, john stultz wrote:
> > On Wed, 2011-12-14 at 08:20 +0100, Richard Cochran wrote:
> > > Michel Hack wrote an article last year detailing how Linux botches the
> > > leap second and suggested a more robust way to handle it.
> > 
> > Hmm. Do you have a link to the article? 
> 
> I don't think it is online. Do you have the magic IEEE access?
> 
> http://ieeexplore.ieee.org/xpl/freeabs_all.jsp?arnumber=5609776

Ah, research. I'll have to look into getting access.

> > I like the idea of having TAI as a kernel clockid. The hard part is
> > getting systems to initialize it properly at boot. 
> > 
> > Also part of the issue with leapseconds is that time functions are such
> > a hot path, we can't really add extra conditionals checking for leap
> > seconds. Instead the leapsecond occurs on the first tick of the
> > leapsecond.
> 
> The idea would only involve one conditional and one addition:
> 
> - System clock represents TAI
> - Table of {threshold; offset} values, read mostly, rarely updated
> - Table has index pointing to next event
> 
> Get time becomes:
> 
> 1. read system time
> 2. test threshold
> 3. apply correction

Again, this seems relatively reasonable. But the difficulty in changing
system clock to be TAI is getting the table initialized and updated on
legacy systems that don't have the userland support added. 

I'd suggest starting with adding the threshold check and leap-second
correction in the getnstimeofday() path, and then see how performance is
impacted. 

That would let us improve leapsecond handling and get a sense of the
performance impact prior to reworking the kernel internals to be TAI.

> > More interestingly to me is Google's recent use of slewed leapseconds.
> > However, how that would work on a public network is a bit more fuzzy.
> > And being able to support both TAI and slewed leapseconds would require
> > quite a bit more logic.
> 
> Do you mean smoothing the jump over the entire day (or other
> interval)? This is also discussed in Hack's paper.

Yea, its been discussed widely before, but I've not heard of it actually
being implemented. You can read about it here:
http://googleblog.blogspot.com/2011/09/time-technology-and-leaping-seconds.html

Its interesting and attractive solution, but again, I suspect it really
only works in a closed network where everyone is using the same
approach. Mixing leap-smeared ntp servers with legacy ntp servers would
likely cause trouble. 

Also, trying to mix TAI with leap-smeared UTC would be complex to do
in-kernel, since we would need another layer of indirection to keep the
smear adjustments to UTC separate from the frequency adjustments for
TAI. Not impossible, but not trivial.


thanks
-john


