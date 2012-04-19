Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab2DSASw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 20:18:52 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:37046 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085Ab2DSASu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 20:18:50 -0400
Message-ID: <4F8F59E2.4080301@linaro.org>
Date: Wed, 18 Apr 2012 17:18:42 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Salman Qazi <sqazi@google.com>, stable@kernel.org
Subject: Re: [PATCH] clocksource, prevent overflow in clocksource_cyc2ns
References: <1333552260-1170-1-git-send-email-prarit@redhat.com> <4F7C8C3E.1020203@us.ibm.com> <4F7C9402.3090602@redhat.com> <4F7CF094.5020201@us.ibm.com> <4F7D8FA1.1010107@redhat.com> <4F8F4C31.7010209@linaro.org> <4F8F555F.7040404@redhat.com>
In-Reply-To: <4F8F555F.7040404@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041900-6078-0000-0000-00000A28133D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2012 04:59 PM, Prarit Bhargava wrote:
>
> Hey John,
>
> Thanks for continuing to work on this.  Coincidentally that exact patch was my
> first attempt at resolving the problem as well.  The problem is that even after
> touching the clocksource watchdog and restoring irqs the printk buffer can take
> a LONG time to flush -- and that still will cause an overflow comparison.  So
> fixing it with just a touch_clocksource_watchdog() isn't the right thing to do
> IMO.  Maybe a combination of the printk() patch you suggested earlier and the
> touch_clocksource_watchdog() is the right way to go but I'll leave that up to
> tglx and yourself to decide on a correct fix.
:( That's a bummer. Something similar may be useful on the printk side 
as well.


> There's also some additional information that I've been gathering on this issue;
> I have seen *idle* systems switch to the hpet because the clocksource watchdog
> hits the overflow comparison.  As expected it happens much less frequently on
> newer kernels (linux.git top of tree) than older stable kernels (2.6.32 based)
> due to the difference in shift values but it is happening in both cases.

Some of the recent adjustments for more robust shift calculations may 
partially be responsible for the improvement. Although I'm not sure why 
idle systems (that don't halt the TSC in idle) would trip this.  Do let 
me know if you find any particular way of reproducing this.

> The odd thing about this behaviour is that I would expect it to occur with the
> same frequency on small systems as it does on large systems with linux.git as
> the watchdog fires once/second.  AFAICT I do not see this on small systems but
> see it only on systems with greater than 24 cpus (both Intel and AMD).
Hrm.

> Using debug code similar to the dump code I previously provided, I can see that
> every so often these large systems can hit a case where the tsc wraps and the
> hpet is still monotonically increasing.  When the unstable calculation is
> performed the result is obviously affected by the overflow.  Sometimes this
> comparison overflow happens within 18 minutes, other times it can take hours or
> days.
TSC wraps? Are you sure that's what you see? Or do you have that 
switched? With the HPET wrapping?


> The other part of this puzzle is that if switch between the tsc and hpet every
> 10 seconds, and run a gettimeofday() comparison program, the gettimeofday()
> program will return a backwards time[1] event usually within half-an-hour.  [I'm
> just including this info here to point out that switching between clocksources
> seems to cause some momentary instability.  Before anyone points this out I will
> say that this not a "real world" bug.  I'm trying to find out if anyone actually
> does switch from the tsc to hpet (and back) on multi-purposed systems.  I'm
> hoping the answer to that is "no" :) ].
So, there were some recent fixes for 3.4 to address an issue 
specifically around inconsistencies at clocksource switch time:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=a939e817aa7e199d2fff05a67cb745be32dd5c2d
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=f695cf94837de53864180400cbac42cfa370426f

I definitely want to make sure any sort of inconsistencies like that are 
resolved. So let me know if you can still trigger anything like that 
with the latest 3.4 kernel.

thanks
-john

