Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab0LHT7v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 14:59:51 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:57240 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756474Ab0LHT7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 14:59:48 -0500
Subject: Re: [RFC][PATCH] timekeeping: Keep xtime_nsec remainder separate
 from ntp_error
From: john stultz <johnstul@us.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Zippel <zippel@linux-m68k.org>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1291833054.5015.1133.camel@gandalf.stny.rr.com>
References: <1291833054.5015.1133.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Dec 2010 11:59:42 -0800
Message-ID: <1291838382.2909.17.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-08 at 13:30 -0500, Steven Rostedt wrote:
> While doing my end of year unlikely() cleanup, running the annotate
> branch profiler, I came across this:
> 
>  correct incorrect  %        Function                  File              Line
>  ------- ---------  -        --------                  ----              ----
>   122588 65653641  99 timekeeping_adjust             timekeeping.c        664
>   167493 14584927  98 timekeeping_adjust             timekeeping.c        658
> 
> This shows that the following likely()'s are wrong most of the time:
> 
> 	if (error > interval) {
> 		error >>= 2;
> 		if (likely(error <= interval))
> 			adj = 1;
> 		else
> 			adj = timekeeping_bigadjust(error, &interval, &offset);
> 	} else if (error < -interval) {
> 		error >>= 2;
> 		if (likely(error >= -interval)) {
> 
> Talking about this with John Stultz, we both agreed that the annotations
> should be correct and is not the issue, but something else is going
> wrong.
> 
> Adding in trace_printks(), I saw that the adj values that were added to
> the "mult" multiplier were sometimes quite large. The time intervals
> never got down into a small error, but instead was making large
> oscillations, both positive and negative to where it should be.
> 
> John noticed that if he removed the commit:
> 
> commit 5cd1c9c5cf30d4b33df3d3f74d8142f278d536b7
> timekeeping: fix rounding problem during clock update
> 
> that the problem would go away and we would get back into a tight
> oscillation that would stay within the fast path (and the likely()'s
> were again likely).
> 
> What the above commit did was to fix a bug that caused time to go
> backward a nanosec due to the truncating of the xtime_nsec shifted into
> the xtime.tv_nsec.  The fix for that bug (and what that commit did) was
> to always round up one. It added +1 to the xtime.tv_nsec after it did
> the conversion, and then took the difference between this shifted and
> the xtime_nsec and stored that into the ntp_error.
> 
> The ntp_error is used to control the frequency, and this constant adding
> of the shift remainder would cause the large oscillation.
> 
> This patch instead adds another field to the timekeeping structure that
> stores the remainder separately. On re-entry into update_wall_time(),
> the remainder is added back onto the xtime_nsec after it is set to the
> xtime.tv_nsec and restoring its original value.
> 
> This handles the rounding problem that the original commit addressed but
> does not cause the large oscillation that it caused.

Hey Steven!

Thanks for the great analysis and tooling to help find these unexpected
behaviors! 

Sadly, I believe your proposed change can still cause minor nsec
inconsistencies from gettimeofday/vgettimeofday. In fact, the previous
implementation where the nsec inconsistency error was observed preserved
the sub-nanosecond remainder in xtime_nsec.

I suspect we may need to still round up and store the error, but tweak
the adjustment code to handle the larger error per-iteration then it was
originally designed for (note: the current code is still functioning
properly, its just not often hitting the expected trivial case).

The only alternative would be to integrate the sub-ns remainder into the
gettime caclculation (including reworking all the vsyscall
implementations to utilize it as well).

thanks
-john

