Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701Ab0KMA7f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 19:59:35 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:46087 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab0KMA7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 19:59:34 -0500
Subject: Re: [PATCH] Improve clocksource unstable warning
From: john stultz <johnstul@us.ibm.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        pc@us.ibm.com
In-Reply-To: <1289607722.3292.84.camel@localhost.localdomain>
References: <80b5a10ac1a6ef51afca3c113b624bf1b5049452.1289427381.git.luto@mit.edu>
	 <AANLkTi=s+0i36qd-bd3=MdeiJS-TThos9RmeUCsfHyy=@mail.gmail.com>
	 <AANLkTimAfULHTkyLVpGv5r3DcSfVXzsgGiHgTdamNpt2@mail.gmail.com>
	 <1289605221.3292.53.camel@localhost.localdomain>
	 <AANLkTi=iso2+R6-5+2ipe39JLHw9o0TgMGCRSTqd5qQz@mail.gmail.com>
	 <AANLkTikd0rstGDDcNdb8u2_H09giaZVxPY1Y5qaiy6_O@mail.gmail.com>
	 <1289607722.3292.84.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Nov 2010 16:58:51 -0800
Message-ID: <1289609931.3292.87.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-11-13 at 00:22 +0000, john stultz wrote:
> On Fri, 2010-11-12 at 18:51 -0500, Andrew Lutomirski wrote:
> > Also wrong if cs_elapsed is just slightly less than wd_wrapping_time
> > but the wd clocksource runs enough faster that it wrapped.
> 
> Ok. Good point, that's a problem. Hrmmmm. Too much math for Friday. :)

I have a hard time leaving things alone. :)

So this still has the issue of the u64%u64 won't work on 32bit systems,
but I think once I rework the modulo bit the following should be what
you were describing.

It is ugly, so let me know if you have a cleaner way.


Signed-off-by: John Stultz <johnstul@us.ibm.com>

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index c18d7ef..0afbcb5 100644
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
 
@@ -280,6 +283,35 @@ static void clocksource_watchdog(unsigned long data)
 		cs_nsec = clocksource_cyc2ns((csnow - cs->wd_last) &
 					     cs->mask, cs->mult, cs->shift);
 		cs->wd_last = csnow;
+
+		/*
+		 * If the cs interval is greater then the wd wrap interval,
+		 * we were somehow delayed. So check that modulo the wrap
+		 * interval, the cs interval is close to the watchdog
+		 * interval value.
+		 */
+		if (cs_nsec > wd_max_nsec){
+			int64_t cs_modulo = cs_nsec % wd_max_nsec;
+
+			/* first check the easy case */
+			if(abs(cs_modulo - wd_nsec) < WATCHDOG_THRESHOLD) {
+				 WARN_ONCE(1, "clocksource_watchdog:"
+						"watchdog delayed?\n");
+				continue;
+			}
+			/* could be split along the wd_max_nsec boundary*/
+			if (wd_nsec < cs_modulo)
+				wd_nsec += wd_max_nsec;
+			else
+				cs_modulo += wd_max_nsec;
+			/* check again */
+			if(abs(cs_modulo - wd_nsec) < WATCHDOG_THRESHOLD) {
+				 WARN_ONCE(1, "clocksource_watchdog:"
+						"watchdog delayed?\n");
+				continue;
+			}
+		}
+
 		if (abs(cs_nsec - wd_nsec) > WATCHDOG_THRESHOLD) {
 			clocksource_unstable(cs, cs_nsec - wd_nsec);
 			continue;


