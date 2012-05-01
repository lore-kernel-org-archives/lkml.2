Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026Ab2EAStf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 14:49:35 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61329 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581Ab2EAStd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 14:49:33 -0400
Date: Tue, 1 May 2012 20:43:23 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC V1 0/5] Rationalize time keeping
Message-ID: <20120501184322.GA2655@netboy.at.omicron.at>
References: <cover.1335510125.git.richardcochran@gmail.com>
 <4F9B228F.90903@linaro.org>
 <20120428080443.GA2241@netboy.at.omicron.at>
 <4F9EFC70.50405@linaro.org>
 <20120501071749.GD2243@netboy.at.omicron.at>
 <4F9F9862.2010103@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9F9862.2010103@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2012 at 01:01:38AM -0700, John Stultz wrote:
> On 05/01/2012 12:17 AM, Richard Cochran wrote:
> >On Mon, Apr 30, 2012 at 01:56:16PM -0700, John Stultz wrote:
> >>Well, the leap-offset is a second, but when it arrives is only
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >>tick-accurate. :)
    ^^^^^^^^^^^^^^

(You said it yourself ...

> >It would be fine to change the leap second status on the tick, but
> >then you must also change the time then, and only then, as well. I
> >know Linux moved away from this long ago, and the new way is better,
> >but still what the kernel does today is just plain wrong.
> >
> >But there is a fix. I just offered it.
> Maybe could you clarify a bit more here about how the kernel is
> plain wrong?  Try a clear problem description including examples
> (before and after you changes)? I'm worried we're talking about
> different problems.

... how the kernel is plain wrong ;)

Here is an example, a preview of what will happen (again) this
summer. This trace is the output of a program that sets the time to
five seconds before the end of the day of a leap second, set the INS
flag, and reads the time in a tight loop, all using adjtimex(). Kernel
is 3.3.0+ and platform is Intel Atom.

Time status
| ID Insert/Delete
| |  TAI offset
| |  |  UTC time_t value
| |  |  |
v v  v  v
1 I- 34 1341100799.000000276
1 I- 34 1341100799.000016480
1 I- 34 1341100799.000021718
        ...
1 I- 34 1341100799.999991361
1 I- 34 1341100799.999995622
1 I- 34 1341100799.999999952
1 I- 34 1341100800.000004212 * What is this?  Seconds and status wrong...
1 I- 34 1341100800.000009590
1 I- 34 1341100800.000014130
1 I- 34 1341100800.000018530
        ...
1 I- 34 1341100800.000087605
1 I- 34 1341100800.000091935
1 I- 34 1341100800.000096265
1 I- 34 1341100800.000100595 * ... still wrong ...
1 I- 34 1341100800.000105065
1 I- 34 1341100800.000109535
1 I- 34 1341100800.000113866
        ...
1 I- 34 1341100800.000227011
1 I- 34 1341100800.000231341
1 I- 34 1341100800.000235671
3 I- 34 1341100799.000276949 * Saved by the tick. (but TAI offset wrong)
3 I- 34 1341100799.000289451
3 I- 34 1341100799.000295807
3 I- 34 1341100799.000303280

Although this example is with adjtimex(), clock_gettime() will show
the same time_t defect. 

> >If we leave everything as is, then the user is left with two choices
> >for data collection applications.
> >
> >1. Turn off your data system on the night of a leap second.
> >
> >2. Record data even during a leap second, but post process the files
> >    to fix up all the uglies.
> >
> >Either way, the kernel has failed us.
> 3. Use adjtimex() and interpret the timespec and time_state return
> together to interpret 23:59:60 properly?
> 
> 4. Use adjtimex(), and use the timespec  + the time_tai offset value
> to calculate TAI time?
> 
> I dunno. Again, I suspect we're thinking about different issues that
> sound very similar. :)

The two options that you suggested won't work without additional
fixing of the uglies (see above).

> You did just suggest we allow for CLOCK_TAI to be broken for folks
> want to use smeared-leap-seconds.  That sounds like an eventual bug
> too.  :) Regardless, the point of my suggestion is that you're
> likely going to be adding logic to a very hot path, and the
> resulting benefit has not been clearly stated.

The benefit is to get correct UTC time_t values from the kernel at all
times, via all interfaces.

I can't understand the argument that a hot path is exempt from having
to be correct. Any programs receiving (really quick) time stamps that
are nonetheless occasionally off by one second will have to program
the checks and corrections themselves. That can hardly be more
efficient than doing the check in the kernel.

Or if user space is just ignoring the issue, then it is going to bite
them one day (unless they just turn off their systems for the leap
second). IMHO, the fact that such bugs can only happen once every six
months (at most) makes them far worse.

> Expect push back
> there (not just from me), so have a strong argument and show
> overhead impact with numbers to help your case.  Alternatively look
> for other solutions that don't affect the hot-path (like what I
> suggested w/ adjtimex() above - although that may have downsides
> too).

Okay, I will gather some numbers on the performace impact.
 
> Do forgive me for prodding you here.  Assuming I understand your
> goals (adding CLOCK_TAI, reworking timekeeping core to keep
> construct time in a more sane way, and improved leapsecond logic), I
> very much want to see them come to be.  I appreciate your focus on
> solving some of the complex and unloved issues here.
> 
> I look forward to your next revision!

Thank you for your encouragement,

Richard
