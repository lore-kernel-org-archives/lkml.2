Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab0GWDeW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 23:34:22 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:59808 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482Ab0GWDeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 23:34:21 -0400
Subject: Re: [RFC][PATCH -rt] Handling delayed clocksource watchdog timer
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>, Darren Hart <dvhltc@us.ibm.com>,
        Paul Clarke <pacman@us.ibm.com>
In-Reply-To: <1279854789.2442.54.camel@localhost.localdomain>
References: <1279854789.2442.54.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Jul 2010 20:34:14 -0700
Message-ID: <1279856054.2442.60.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-22 at 20:13 -0700, john stultz wrote:
> diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
> index 0e98497..a91e7ba 100644
> --- a/kernel/time/clocksource.c
> +++ b/kernel/time/clocksource.c
> @@ -280,7 +280,8 @@ static void clocksource_watchdog(unsigned long data)
>  		cs_nsec = clocksource_cyc2ns((csnow - cs->wd_last) &
>  					     cs->mask, cs->mult, cs->shift);
>  		cs->wd_last = csnow;
> -		if (abs(cs_nsec - wd_nsec) > WATCHDOG_THRESHOLD) {
> +		if (jiffies - watchdog_timer.expires > 4*WATCHDOG_INTERVAL) &&
> +				(abs(cs_nsec - wd_nsec) > WATCHDOG_THRESHOLD) {
>  			clocksource_unstable(cs, cs_nsec - wd_nsec);
>  			continue;
>  		}


Bah. 

Was testing with this patch and just realized it has a thinko
(greater-than instead of less-than).

Should be:

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 0e98497..a91e7ba 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -280,7 +280,8 @@ static void clocksource_watchdog(unsigned long data)
 		cs_nsec = clocksource_cyc2ns((csnow - cs->wd_last) &
 					     cs->mask, cs->mult, cs->shift);
 		cs->wd_last = csnow;
-		if (abs(cs_nsec - wd_nsec) > WATCHDOG_THRESHOLD) {
+		if (jiffies - watchdog_timer.expires < 4*WATCHDOG_INTERVAL) &&
+				(abs(cs_nsec - wd_nsec) > WATCHDOG_THRESHOLD) {
 			clocksource_unstable(cs, cs_nsec - wd_nsec);
 			continue;
 		}


