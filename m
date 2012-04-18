Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab2DRXUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 19:20:32 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:59286 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540Ab2DRXU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 19:20:27 -0400
Message-ID: <4F8F4C31.7010209@linaro.org>
Date: Wed, 18 Apr 2012 16:20:17 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
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
x-cbid: 12041823-2398-0000-0000-000005EDB5E3
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
>

Hey Prarit,
     So at tglx's prodding I took a look at the sysrq code, and the 
problem is the entire sysrq path runs with irqs disabled. As you 
note,with many cores and many processes, it can take a while to spit all 
that data out.

Instead of the earlier hack I suggested, would you try the following 
simpler one? I suspect we just need to touch the clocksource watchdog 
before returning.  This should avoid the TSC disqualification you're 
seeing. On systems using clocksources that wrap, we'll still lose time, 
since no time accumulation occurred during the long irq off period, but 
I think that's acceptable given this is not normal operation.

Let me know if this helps.

thanks
-john

As irqs may be disabled for quite some time in the sysrq path, touch 
clocksource
watchdog before re-enabling interrupts.

Signed-off-by: John Stultz <john.stultz@linaro.org>

diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
index 05728894..28fe2cb 100644
--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -41,6 +41,7 @@
  #include<linux/slab.h>
  #include<linux/input.h>
  #include<linux/uaccess.h>
+#include<linux/clocksource.h>

  #include<asm/ptrace.h>
  #include<asm/irq_regs.h>
@@ -544,6 +545,7 @@ void __handle_sysrq(int key, bool check_mask)
  		printk("\n");
  		console_loglevel = orig_log_level;
  	}
+	clocksource_touch_watchdog();
  	spin_unlock_irqrestore(&sysrq_key_table_lock, flags);
  }


