Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601Ab2IKG6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 02:58:53 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36222 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757006Ab2IKG6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 02:58:50 -0400
Message-ID: <504EE124.3010401@linaro.org>
Date: Tue, 11 Sep 2012 08:58:44 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: prarit@redhat.com, xen-devel@lists.xensource.com,
        linaro-dev@lists.linaro.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-pm@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        richardcochran@gmail.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, mingo@kernel.org,
        lenb@kernel.org
Subject: Re: CONFIG_NO_HZ + CONFIG_CPU_IDLE freeze the system (Was Re: [PATCH]
 acpi : remove power from acpi_processor_cx structure)
References: <1343164349-28550-1-git-send-email-daniel.lezcano@linaro.org> <201209062204.11288.rjw@sisk.pl> <50490920.9070204@linaro.org> <201209062318.42874.rjw@sisk.pl> <504A02BD.4000805@linaro.org> <504A2D73.3010702@linaro.org> <504A68A0.7010907@linaro.org> <504E1FE5.6090502@linaro.org> <504E4343.5070004@linaro.org> <504E8372.20904@linaro.org>
In-Reply-To: <504E8372.20904@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2012 02:18 AM, John Stultz wrote:
> On 09/10/2012 12:45 PM, Daniel Lezcano wrote:
>> On 09/10/2012 07:14 PM, John Stultz wrote:
>>> In the meantime, I'll try to reproduce on my T61. If you could send me
>>> your .config, I'd appreciate it.
>> http://pastebin.com/qSxqfdDK
>>
>> The header of the config file shows for a v3.5-rc7 because it is the
>> result of the git-bisect. If you keep this config file for the latest
>> kernel that should reproduce the problem.
>>
>> Let me know if you were able to reproduce the problem.
> Great! With this I was able to quickly reproduce the problem and I think
> I have a fix.

Cool !

> Would you mind testing the following patch? It seems to resolve the
> issue, but I've not yet run it through my test suite to make sure it
> didn't break anything else.

No problem, I will try it this evening.

Is this problem related to all 32bits arch ?

Thanks !

  -- Daniel

> If both your and my testing comes back ok, I'll submit it to Thomas.
> 
> thanks
> -john
> 
> From f10a285a5b532a14d3330f6e60e4d7bd5627932a Mon Sep 17 00:00:00 2001
> From: John Stultz <john.stultz@linaro.org>
> Date: Mon, 10 Sep 2012 20:00:15 -0400
> Subject: [PATCH] time: Fix timeekeping_get_ns overflow on 32bit systems
> 
> Daniel Lezcano reported seeing multi-second stalls from
> keyboard input on his T61 laptop when NOHZ and CPU_IDLE
> were enabled on a 32bit kernel.
> 
> He bisected the problem down to
> 1e75fa8be9fb61e1af46b5b3b176347a4c958ca1 (time: Condense
> timekeeper.xtime into xtime_sec).
> 
> After reproducing this issue, I narrowed the problem down
> to the fact that timekeeping_get_ns() returns a 64bit
> nsec value that hasn't been accumulated. In some cases
> this value was being then stored in timespec.tv_nsec
> (which is a long).
> 
> On 32bit systems, With idle times larger then 4 seconds
> (or less, depending on the value of xtime_nsec), the
> returned nsec value would overflow 32bits. This limited
> kept time from increasing, causing timers to not expire.
> 
> The fix is to make sure we don't directly store the
> result of timekeeping_get_ns() into a tv_nsec field,
> instead using a 64bit nsec value which can then be
> added into the timespec via timespec_add_ns().
> 
> With this patch I cannot reproduce the issue.
> 
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Richard Cochran <richardcochran@gmail.com>
> Cc: Prarit Bhargava <prarit@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Reported-and-bisected-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>  kernel/time/timekeeping.c |   19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 34e5eac..d3b91e7 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -303,10 +303,11 @@ void getnstimeofday(struct timespec *ts)
>          seq = read_seqbegin(&tk->lock);
>  
>          ts->tv_sec = tk->xtime_sec;
> -        ts->tv_nsec = timekeeping_get_ns(tk);
> +        nsecs = timekeeping_get_ns(tk);
>  
>      } while (read_seqretry(&tk->lock, seq));
>  
> +    ts->tv_nsec = 0;
>      timespec_add_ns(ts, nsecs);
>  }
>  EXPORT_SYMBOL(getnstimeofday);
> @@ -345,6 +346,7 @@ void ktime_get_ts(struct timespec *ts)
>  {
>      struct timekeeper *tk = &timekeeper;
>      struct timespec tomono;
> +    s64 nsec;
>      unsigned int seq;
>  
>      WARN_ON(timekeeping_suspended);
> @@ -352,13 +354,14 @@ void ktime_get_ts(struct timespec *ts)
>      do {
>          seq = read_seqbegin(&tk->lock);
>          ts->tv_sec = tk->xtime_sec;
> -        ts->tv_nsec = timekeeping_get_ns(tk);
> +        nsec = timekeeping_get_ns(tk);
>          tomono = tk->wall_to_monotonic;
>  
>      } while (read_seqretry(&tk->lock, seq));
>  
> -    set_normalized_timespec(ts, ts->tv_sec + tomono.tv_sec,
> -                ts->tv_nsec + tomono.tv_nsec);
> +    ts->tv_sec += tomono.tv_sec;
> +    ts->tv_nsec = 0;
> +    timespec_add_ns(ts, nsec + tomono.tv_nsec);
>  }
>  EXPORT_SYMBOL_GPL(ktime_get_ts);
>  
> @@ -1244,6 +1247,7 @@ void get_monotonic_boottime(struct timespec *ts)
>  {
>      struct timekeeper *tk = &timekeeper;
>      struct timespec tomono, sleep;
> +    s64 nsec;
>      unsigned int seq;
>  
>      WARN_ON(timekeeping_suspended);
> @@ -1251,14 +1255,15 @@ void get_monotonic_boottime(struct timespec *ts)
>      do {
>          seq = read_seqbegin(&tk->lock);
>          ts->tv_sec = tk->xtime_sec;
> -        ts->tv_nsec = timekeeping_get_ns(tk);
> +        nsec = timekeeping_get_ns(tk);
>          tomono = tk->wall_to_monotonic;
>          sleep = tk->total_sleep_time;
>  
>      } while (read_seqretry(&tk->lock, seq));
>  
> -    set_normalized_timespec(ts, ts->tv_sec + tomono.tv_sec + sleep.tv_sec,
> -            ts->tv_nsec + tomono.tv_nsec + sleep.tv_nsec);
> +    ts->tv_sec += tomono.tv_sec + sleep.tv_sec;
> +    ts->tv_nsec = 0;
> +    timespec_add_ns(ts, nsec + tomono.tv_nsec + sleep.tv_nsec);
>  }
>  EXPORT_SYMBOL_GPL(get_monotonic_boottime);
>  


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

