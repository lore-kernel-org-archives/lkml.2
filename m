Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab2DEM1r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 08:27:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591Ab2DEM1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 08:27:46 -0400
Message-ID: <4F7D8FA1.1010107@redhat.com>
Date: Thu, 05 Apr 2012 08:27:13 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: John Stultz <johnstul@us.ibm.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Salman Qazi <sqazi@google.com>, stable@kernel.org
Subject: Re: [PATCH] clocksource, prevent overflow in clocksource_cyc2ns
References: <1333552260-1170-1-git-send-email-prarit@redhat.com> <4F7C8C3E.1020203@us.ibm.com> <4F7C9402.3090602@redhat.com> <4F7CF094.5020201@us.ibm.com>
In-Reply-To: <4F7CF094.5020201@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> So what kernel version are you using?

I retested using top of the linux.git tree, running

echo 1 > /proc/sys/kernel/sysrq
for i in `seq 10000`; do sleep 1000 & done
echo t > /proc/sysrq-trigger

and I no longer see a problem.  However, if I increase the number of threads to
1000/cpu I get

Clocksource %s unstable (delta = -429565427)
Clocksource switching to hpet

> to narrow down if you're  problem  is currently present in mainline or only in
> older kernels, as that will help us find the proper fix.

If I hack in (sorry for the cut-and-paste)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index c958338..f38b8d0 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -279,11 +279,16 @@ static void clocksource_watchdog(unsigned long data)
                        continue;
                }

-               wd_nsec = clocksource_cyc2ns((wdnow - cs->wd_last) & watchdog->m
-                                            watchdog->mult, watchdog->shift);
+               /*wd_nsec = clocksource_cyc2ns((wdnow - cs->wd_last) & watchdog-
+                                            watchdog->mult, watchdog->shift);*/
+               wd_nsec = mult_frac(((wdnow - cs->wd_last), watchdog->mult,
+                                   1UL << watchdog->shift);
+
+               /*cs_nsec = clocksource_cyc2ns((csnow - cs->cs_last) &
+                                            cs->mask, cs->mult, cs->shift);*/
+               cs_nsec = mult_frac(((csnow - cs->cs_last), cs->mult,
+                                   1UL << cs->shift);

-               cs_nsec = clocksource_cyc2ns((csnow - cs->cs_last) &
-                                            cs->mask, cs->mult, cs->shift);
                cs->cs_last = csnow;
                cs->wd_last = wdnow;


then I don't see unstable messages.

I think the problem is still here but it only happens in extreme cases.

P.
