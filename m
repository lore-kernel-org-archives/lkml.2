Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481Ab0KLVwL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:52:11 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:57437 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755400Ab0KLVwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:52:06 -0500
Subject: Re: [PATCH] Improve clocksource unstable warning
From: john stultz <johnstul@us.ibm.com>
To: Andy Lutomirski <luto@mit.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        pc@us.ibm.com
In-Reply-To: <AANLkTi=s+0i36qd-bd3=MdeiJS-TThos9RmeUCsfHyy=@mail.gmail.com>
References: <80b5a10ac1a6ef51afca3c113b624bf1b5049452.1289427381.git.luto@mit.edu>
	 <AANLkTi=s+0i36qd-bd3=MdeiJS-TThos9RmeUCsfHyy=@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Nov 2010 13:51:45 -0800
Message-ID: <1289598705.3292.29.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-12 at 13:31 -0800, john stultz wrote:
> On Wed, Nov 10, 2010 at 2:16 PM, Andy Lutomirski <luto@mit.edu> wrote:
> > When the system goes out to lunch for a long time, the clocksource
> > watchdog might get false positives.  Clarify the warning so that
> > people stop blaming their system freezes on the timing code.
> 
> So this issue has also crept up at times in the -rt kernel, where some
> high priority rt tasks hogs the cpu long enough for the watchdog
> clocksource to wrap, and then the TSC seems to have sped up relative
> to the watchdog when the system returns to a normal state and causes a
> false positive, so the TSC gets kicked out.
> 
> So the watchdog heuristic is rough, since it depends on three things:
> 1) The watchdog clocksource is actually trustworthy
> 2) The watchdog actually runs near to when it expects to run.
> 3) When reading the different clocksources, any interruptions when the
> watchdog runs are small enough to to be handled by the allowed margin
> of error.
> 
> And in these cases we're breaking #2
> 
> So I had a few  ideas  to improve the huristic somewhat (and huristic
> refinement is always ugly). So first of all,  the whole reason for the
> watchdog code is the TSC. Other platforms may want to make use of it,
> but none do at this moment.
> 
> The majority of TSC issues are caused when the TSC halts in idle
> (probably most common these days) or slows down due to cpufreq
> scaling.
> 
> When we get these false positives, its because the watchdog check
> interval is too long and the watchdog hardware has wrapped. This makes
> it appear that the TSC is running too *fast*.  So we could try to be
> more skeptical of watchdog failures where the TSC appears to have sped
> up, rather then the more common real issue of it slowing down.
> 
> Now the actual positive where this could occur is if you were on an
> old APM based laptop, and booted on battery power and the cpus started
> at their slow freq. Then you plugged in the AC and the cpus jumped to
> the faster rate. So while I suspect this is a rare case these days (on
> ACPI based hardware the kernel has more say in cpufreq transitions, so
> I believe we are unlikely to calculate tsc_khz while the cpus are in
> low power mode), we still need to address this.
> 
> Ideas:
> 1) Maybe should we check that we get two sequential failures where the
> cpu seems fast before we throw out the TSC? This will still fall over
> in some stall cases (ie: a poor rt task hogging the cpu  for 10
> minutes, pausing for a 10th of a second and then continuing to hog the
> cpu).
> 
> 2) We could look at the TSC delta, and if it appears outside the order
> of 2-10x faster (i don't think any cpus scale up even close to 10x in
> freq, but please correct me if so), then assume we just have been
> blocked from running and don't throw out the TSC.
> 
> 3) Similar to #2 we could look at the max interval that the watchdog
> clocksource provides, and if the TSC delta is greater then that, avoid
> throwing things out. This combined with #2 might narrow out the false
> positives fairly well.
> 
> Any additional thoughts here?

Here's a rough and untested attempt at adding just #3.

thanks
-john

Improve watchdog hursitics to avoid false positives caused by the
watchdog being delayed.

Signed-off-by: John Stultz <johnstul@us.ibm.com>

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index c18d7ef..d63f6f8 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -247,6 +247,7 @@ static void clocksource_watchdog(unsigned long data)
 	struct clocksource *cs;
 	cycle_t csnow, wdnow;
 	int64_t wd_nsec, cs_nsec;
+	int64_t wd_max_nsec;
 	int next_cpu;
 
 	spin_lock(&watchdog_lock);
@@ -257,6 +258,8 @@ static void clocksource_watchdog(unsigned long data)
 	wd_nsec = clocksource_cyc2ns((wdnow - watchdog_last) & watchdog->mask,
 				     watchdog->mult, watchdog->shift);
 	watchdog_last = wdnow;
+	wd_max_nsec = clocksource_cyc2ns(watchdog->mask, watchdog->mult,
+						watchdog->shift);
 
 	list_for_each_entry(cs, &watchdog_list, wd_list) {
 
@@ -280,6 +283,14 @@ static void clocksource_watchdog(unsigned long data)
 		cs_nsec = clocksource_cyc2ns((csnow - cs->wd_last) &
 					     cs->mask, cs->mult, cs->shift);
 		cs->wd_last = csnow;
+
+		/* Check to make sure the watchdog wasn't delayed */
+		if (cs_nsec > wd_max_nsec) {
+			WARN_ONCE(1,
+				"clocksource_watchdog: watchdog delayed?\n");
+			continue;
+		}
+
 		if (abs(cs_nsec - wd_nsec) > WATCHDOG_THRESHOLD) {
 			clocksource_unstable(cs, cs_nsec - wd_nsec);
 			continue;


