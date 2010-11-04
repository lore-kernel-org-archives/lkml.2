Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab0KDT3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 15:29:22 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:41170 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362Ab0KDT3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 15:29:17 -0400
Subject: Re: [PATCH 7/7] [RFC] Introduce Alarm (hybrid) timers
From: John Stultz <john.stultz@linaro.org>
To: Richard Cochran <richardcochran@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>
In-Reply-To: <20101104075229.GA28086@riccoc20.at.omicron.at>
References: <1288809079-14663-1-git-send-email-john.stultz@linaro.org>
	 <1288809079-14663-8-git-send-email-john.stultz@linaro.org>
	 <20101104075229.GA28086@riccoc20.at.omicron.at>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Nov 2010 12:29:00 -0700
Message-ID: <1288898940.2766.17.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-04 at 08:52 +0100, Richard Cochran wrote:
> On Wed, Nov 03, 2010 at 11:31:19AM -0700, John Stultz wrote:
> 
> > Another large distinction is that while the in-kernel interface
> > is pretty similar, the user-space interface for android alarm
> > timers is via ioctls. I've instead chosen to export this
> > functionality via the posix interface, as it seemed a little
> > simpler and avoids creating duplicate interfaces to things like
> > CLOCK_REALTIME and CLOCK_MONOTONIC under alternate names (ie:
> > RTC and ELAPSED_REALTIME). Instead, if one wants to use a
> > alarm timer, simply create a posix timer against either
> > CLOCK_REALTIME_ALARM or CLOCK_MONOTONIC_ALARM.
> 
> I have a comment on this, below ...
> 
> > diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
> > index e6b46b5..9d1ace6 100644
> > --- a/include/linux/posix-timers.h
> > +++ b/include/linux/posix-timers.h
> > @@ -5,6 +5,7 @@
> >  #include <linux/list.h>
> >  #include <linux/sched.h>
> >  #include <linux/rtc.h>
> > +#include <linux/alarmtimer.h>
> >  
> >  union cpu_time_count {
> >  	cputime_t cpu;
> > @@ -65,6 +66,7 @@ struct k_itimer {
> >  			unsigned long expires;
> >  		} mmtimer;
> >  		struct rtc_timer rtctimer;
> > +		struct alarm alarmtimer;
> >  	} it;
> >  };
> 
> I have an initial dynamic clock patch set ready for review and will
> post it later today if I can. In implementing the timer_ calls, I
> began to wonder about this 'it' union. If we really allow and
> implement many kinds of dynamic clocks, then it would seem ugly to me
> to simply add yet another union member for each new clock. Wouldn't it
> be better to provide a private void pointer for the underlying
> driver's use?

Yea. That union is getting a bit ugly, but it lets us avoid having to
manage allocating and freeing a parallel timer structure that points
back to the k_itimer. Its not a huge issue, but the code in this case is
much simpler, but at the cost of making the k_itimer it union a little
gross. So yea, I'm fine changing it if there's a real desire for it to
be done.


> > diff --git a/include/linux/time.h b/include/linux/time.h
> > index 914c48d..4791858 100644
> > --- a/include/linux/time.h
> > +++ b/include/linux/time.h
> > @@ -290,6 +290,8 @@ struct itimerval {
> >  #define CLOCK_MONOTONIC_RAW		4
> >  #define CLOCK_REALTIME_COARSE		5
> >  #define CLOCK_MONOTONIC_COARSE		6
> > +#define CLOCK_REALTIME_ALARM		7
> > +#define CLOCK_MONOTONIC_ALARM		8
> 
> I have thought about and have taken Alan Cox's anti-SYS5.4/SuS/POSIX
> enumeration arguments to heart. If you need a really good example of
> the weaknesses of that way, take a look at clock_getcpuclockid,
> pthread_getcpuclockid, and their implementation in posix-cpu-timers.c
> 
> If we are serious about dynamic clocks, then we will never again touch
> the CLOCK_ list. I hope that, after reviewing the coming patch set,
> you will also agree ;)

Well, I'm eager to see you patch, and I do think dynamic clockids are a
very useful concept that we need.

However, I suspect there will still be a need for static clockids for
those cases where its a conceptual api that doesn't deal with specific
hardware that has lifetime issues, such as the MONOTONIC/REALTIME_ALARM
cases above.

I look forward to your patches!

thanks
-john

