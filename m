Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab2DEQqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 12:46:25 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:58262 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab2DEQqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 12:46:24 -0400
Message-ID: <4F7DCC3C.70208@us.ibm.com>
Date: Thu, 05 Apr 2012 09:45:48 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120310 Thunderbird/11.0
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Salman Qazi <sqazi@google.com>, stable@kernel.org
Subject: Re: [PATCH] clocksource, prevent overflow in clocksource_cyc2ns
References: <1333552260-1170-1-git-send-email-prarit@redhat.com> <4F7C8C3E.1020203@us.ibm.com> <4F7C9402.3090602@redhat.com> <4F7CF094.5020201@us.ibm.com> <4F7D8FA1.1010107@redhat.com>
In-Reply-To: <4F7D8FA1.1010107@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12040516-5518-0000-0000-00000379D9C3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2012 05:27 AM, Prarit Bhargava wrote:
>> So what kernel version are you using?
> I retested using top of the linux.git tree, running
>
> echo 1>  /proc/sys/kernel/sysrq
> for i in `seq 10000`; do sleep 1000&  done
> echo t>  /proc/sysrq-trigger
>
> and I no longer see a problem.  However, if I increase the number of threads to
> 1000/cpu I get
>
> Clocksource %s unstable (delta = -429565427)
> Clocksource switching to hpet

Yea, so this is with the 12minute + stall starving the system from irqs? 
Again, its all a matter of degree.

>
>> to narrow down if you're  problem  is currently present in mainline or only in
>> older kernels, as that will help us find the proper fix.
> If I hack in (sorry for the cut-and-paste)
>
> diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
> index c958338..f38b8d0 100644
> --- a/kernel/time/clocksource.c
> +++ b/kernel/time/clocksource.c
> @@ -279,11 +279,16 @@ static void clocksource_watchdog(unsigned long data)
>                          continue;
>                  }
>
> -               wd_nsec = clocksource_cyc2ns((wdnow - cs->wd_last)&  watchdog->m
> -                                            watchdog->mult, watchdog->shift);
> +               /*wd_nsec = clocksource_cyc2ns((wdnow - cs->wd_last)&  watchdog-
> +                                            watchdog->mult, watchdog->shift);*/
> +               wd_nsec = mult_frac(((wdnow - cs->wd_last), watchdog->mult,
> +                                   1UL<<  watchdog->shift);
> +
> +               /*cs_nsec = clocksource_cyc2ns((csnow - cs->cs_last)&
> +                                            cs->mask, cs->mult, cs->shift);*/
> +               cs_nsec = mult_frac(((csnow - cs->cs_last), cs->mult,
> +                                   1UL<<  cs->shift);
>
> -               cs_nsec = clocksource_cyc2ns((csnow - cs->cs_last)&
> -                                            cs->mask, cs->mult, cs->shift);
>                  cs->cs_last = csnow;
>                  cs->wd_last = wdnow;
>
>
> then I don't see unstable messages.
>
> I think the problem is still here but it only happens in extreme cases.

I suspect if you were closely watching the clock  you'd probably see 
some odd time inconsistencies as well. Its all due to running outside 
the expected bounds of the system.  If you were to use the acpi_pm 
clocksource and stall the system for 10+ minutes, when you returned the 
system clock would be 10 minutes behind.

I think if 10 minutes printk dumps is going to be expected behavior 
(which given the size of these machines, isn't unreasonable), we may 
need to find a way to allow printk to take a break every so often and 
allow irqs to happen. Disabling irqs for 10+ minutes can cause all sorts 
of system trouble.  I've seen scsi adapters hang if their heart beat 
code didn't get an irq every 10 minutes or so.

I had proposed something like this awhile back, but the issue cropping 
up there was lost time due to long printks holding off irqs while we're 
using the jiffies clocks in early boot, so it was at a much smaller scale.

Could you give the following a try and let me know if it helps?

thanks
-john


Only flush 1k chunks max from console_unlock to allow IRQ starvation 
from happening.

NOT FOR INCLUSION

Signed-off-by: John Stultz <john.stultz@linaro.org>

diff --git a/kernel/printk.c b/kernel/printk.c
index b663c2c..b699cc7 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1272,6 +1272,7 @@ void console_unlock(void)
  	unsigned long flags;
  	unsigned _con_start, _log_end;
  	unsigned wake_klogd = 0, retry = 0;
+	unsigned chunk_size, length;

  	if (console_suspended) {
  		up(&console_sem);
@@ -1280,15 +1281,18 @@ void console_unlock(void)

  	console_may_schedule = 0;

+	chunk_size = min(LOG_BUF_MASK, 1024); /* 1k chunks */
  again:
  	for ( ; ; ) {
  		raw_spin_lock_irqsave(&logbuf_lock, flags);
  		wake_klogd |= log_start - log_end;
  		if (con_start == log_end)
  			break;			/* Nothing to print */
+		length = (log_end - con_start)&  LOG_BUF_MASK;
+		length = min(length , chunk_size);
  		_con_start = con_start;
-		_log_end = log_end;
-		con_start = log_end;		/* Flush */
+		_log_end = (con_start + length)&  LOG_BUF_MASK;
+		con_start = _log_end;		/* Flush */
  		raw_spin_unlock(&logbuf_lock);
  		stop_critical_timings();	/* don't trace print latency */
  		call_console_drivers(_con_start, _log_end);

