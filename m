Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab0LIDoi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 22:44:38 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:33093 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752181Ab0LIDoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 22:44:37 -0500
Subject: Re: [RFC][PATCH] timekeeping: Keep xtime_nsec remainder separate
 from ntp_error
From: john stultz <johnstul@us.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Zippel <zippel@linux-m68k.org>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1291860553.5015.1512.camel@gandalf.stny.rr.com>
References: <1291833054.5015.1133.camel@gandalf.stny.rr.com>
	 <1291838382.2909.17.camel@work-vm>
	 <1291839317.5015.1139.camel@gandalf.stny.rr.com>
	 <1291848477.2909.152.camel@work-vm>
	 <1291860553.5015.1512.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Dec 2010 19:44:31 -0800
Message-ID: <1291866271.2909.245.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-08 at 21:09 -0500, Steven Rostedt wrote:
> On Wed, 2010-12-08 at 14:47 -0800, john stultz wrote:
> > On Wed, 2010-12-08 at 15:15 -0500, Steven Rostedt wrote:
> > > On Wed, 2010-12-08 at 11:59 -0800, john stultz wrote:
> > > 
> > > > Hey Steven!
> > > > 
> > > > Thanks for the great analysis and tooling to help find these unexpected
> > > > behaviors! 
> > > > 
> > > > Sadly, I believe your proposed change can still cause minor nsec
> > > > inconsistencies from gettimeofday/vgettimeofday. In fact, the previous
> > > > implementation where the nsec inconsistency error was observed preserved
> > > > the sub-nanosecond remainder in xtime_nsec.
[snip]
> OK, but have you looked at my patch carefully? It does not do what the
> old code does. It still keeps the "round up", but then it subtracts the
> remainder from the delta when we come in again. I don't think my way has
> the same issue.

Ah. I didn't read your patch correctly. It looked very close to what was
there before, so I jumped the gun a bit. That said, the fact that your
"remainder" holds the "negative amount we rounded up" shows how quickly
this type of code can get subtle. :)


> My code still rounds up, but the difference is that it now subtracts
> from the new start to get back to where it left off:
> 
> 	xtime_nsec += xtime.tv_nsec << shift;
> 
> 	[ do stuff ]
> 
> 	xtime.tv_nsec = (xtime_nsec >> shift) + 1;
> 	xtime_nsec -= xtime.tv_nsec << shift;
> 
> The result of xtime_nsec is now negative, because we added 1 and
> shifted.
> 
> Heck, I think this is all Roland needed to do to fix the issue. Lets
> look at this again:
> 
> Pre-accumulation: 
> 	xtime = 0, rem = 0, delta = 1500
> 	gtod:	0 + cyc2ns(1500)
> 		0 + 1499999 (note cyc2ns truncated the 0.4 remainder)
> 		1499999
> 
> Accumulation occurs.
> 
> Post-accumulation:
> 	xtime = 1000000, rem=-0.4, delta = 500
> 
> 	gtod: 	1000000 + cyc2ns(500)
> 		1000000 + 499999 (cyc2ns truncates the .8 remainder)
> 		1499999
> 
> Even if the subtraction moves the shift backward one, we are still ok,
> because when we calculate xtime.tv_nsec at the end, we do the "+1" again
> which returns us that missing ns!

So, yes, this does *seem* comforting. Keep the negative delta, and
re-add it in. It sounds pretty good, but my gut felt like it was prone
to the same issue as keeping the remainder. Took me awhile to find a
case that broke, but I think the following 

I've kept everything in ns to simplify the example.

The accumulation interval is 1000.6ns, and with the exception of the
first interval, we accumulate exactly on that boundary, leaving a
1000.4ns delta around.


gtod:		0 + 2001 			= 2001
accumulate:	1000.6 + 1000.4			= 2001
		1001 + -.4 + 1000.4		= 2001
gtod: 		1001 + 1000			= 2001
---------------
gtod:		1001 + 2001			= 3002
accumulate:	1001 + -.4 + 1000.6 + 1000.4	= 3001.6
		2001.2 + 1000.4			= 3001.6
		2002 + -.8 + 1000.4		= 3001.6
gtod:		2002 + 1000			= 3002
---------------
gtod:		2002 + 2001			= 4003
accumulate:	2002 + -.8 + 1000.6 + 1000.4	= 4002.2
		3001.8 + 1000.4			= 4002.2
		3002 + -2 + 1000.4		= 4002.2
gtod:		3002 + 1000			= 4002


So I believe your patch will still suffer from the same problem.

Its getting to the end of my day, so I might have flubbed something, so
let me know if you see anything wrong here.


> > Oh yea. I agree the adjustment code is very opaque. And there is risk in
> > modifying the code that has been "functioning" but just not in the ideal
> > environment. This stuff is terribly subtle. And there is a real
> > possibility that in fixing the issue you've found, we may cause bugs
> > that effect users in a much more negative way then the incorrect
> > likely() overhead.
> 
> It's not the "likely()" I care about, its the fact that we are going
> into the slow path (timekeeping_bigadjust()) every time. This does a
> hell of a lot more work than the simple "adj=1" that is given.

True, we're taking the slow path every time. But the slow path does
function correctly and we do keep our long term accuracy. Its just not
optimal. The risk here is that is subtle code, so in working to make
things more optimal, we risk actually hurting the sync behavior. 

So caution is needed to ensure correct functionality isn't compromised
as we work on improving performance.

thanks
-john


