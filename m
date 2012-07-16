Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913Ab2GPLKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 07:10:52 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:42232 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890Ab2GPLKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 07:10:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Regression][Revert request] Excessive delay or hang during resume from system suspend due to a hrtimer commit
Date: Mon, 16 Jul 2012 13:16:28 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>, stable@vger.kernel.org,
        Andreas Schwab <schwab@linux-m68k.org>
References: <201207152240.50129.rjw@sisk.pl> <alpine.LFD.2.02.1207161035500.32033@ionos>
In-Reply-To: <alpine.LFD.2.02.1207161035500.32033@ionos>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207161316.28875.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 16, 2012, Thomas Gleixner wrote:
> On Sun, 15 Jul 2012, Rafael J. Wysocki wrote:
> > To everyone involved: the fact that this change, which was likely to introduce
> > regressions from the look of it alone, has been pushed to Linus (an to -stable
> > at the same time!) so late in the cycle, is seriuosly disappointing.
> 
> Well, we spent an massive amount of time in testing, reviewing and
> discussion and it definitely did not break suspend/resume here.

I'm not saying that you didn't consider it thoroughly, but unfortunately you
did overlook this particular issue, didn't you?

> This was not pushed without a lot of thoughts and in fact what you are
> seing is another long standing bug in the timekeeping resume code,
> which was just papered over by the incorrect handling of the clock was
> set cases in the other parts of the system.
> 
> Does the following patch fix the problem for you ?

Yes, it does, thanks!

> @John: Should that clear ntp as well or is it enough to set ntp_error
>        to 0 ?
> 
> /me really goes on vacation now.

So who's going to take care of the patch? :-)

Rafael


> ---------
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 269b1fe..3447cfa 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -717,6 +717,7 @@ static void timekeeping_resume(void)
>  	timekeeper.clock->cycle_last = timekeeper.clock->read(timekeeper.clock);
>  	timekeeper.ntp_error = 0;
>  	timekeeping_suspended = 0;
> +	timekeeping_update(false);
>  	write_sequnlock_irqrestore(&timekeeper.lock, flags);
>  
>  	touch_softlockup_watchdog();
> 
> 
> 

