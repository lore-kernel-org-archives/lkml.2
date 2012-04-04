Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482Ab2DDSBP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 14:01:15 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:51971 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932300Ab2DDSBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 14:01:14 -0400
Message-ID: <4F7C8C3E.1020203@us.ibm.com>
Date: Wed, 04 Apr 2012 11:00:30 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120310 Thunderbird/11.0
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Salman Qazi <sqazi@google.com>, stable@kernel.org
Subject: Re: [PATCH] clocksource, prevent overflow in clocksource_cyc2ns
References: <1333552260-1170-1-git-send-email-prarit@redhat.com>
In-Reply-To: <1333552260-1170-1-git-send-email-prarit@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12040418-6148-0000-0000-000004CDC42F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2012 08:11 AM, Prarit Bhargava wrote:
> The clocksource code has a watchdog which runs once a minute.  The
> clocksource watchdog calculates the number of nanoseconds since the last
> time the watchdog ran and compares that value to the number of nanoseconds
> that have passed on another clocksource.  If these values do not match (to
> within .0625s) then the watchdog marks the current clocksource as unstable
> and switches to another clocksource.
>
> This works so long as the delta between calls of the watchdog is small
> (maximum delta is ~18 seconds with the tsc).  After that, the
> clocksource_cyc2ns() calculation will overflow and the calculated number
> of ns returned is incorrect.
>
> This causes the watchdog to erroneously mark the tsc as unstable and
> switch to the hpet.
>
> A long delay on the system is not usual, however, it can be reproduced
> simply by doing
>
> echo 1>  /proc/sys/kernel/sysrq
> for i in `seq 10000`; do sleep 1000&  done
> echo t>  /proc/sysrq-trigger
>
> on a 32-cpu system (which is not an unusual number of processes for this
> size of system).  This floods the printk buffer and results in a
> pause of approximately 600 seconds which prevents the clocksource watchdog
> from running during that time.  On the next call, the watchdog erroneously
> marks the tsc as unstable and switches to the hpet because the checked
> values for the tsc overflow.

Hmm. This is a pretty good mix of existing problems. :)

We've seen clocksource watchdog false-positives w/ virtualization 
migrations before, and I think that recently got resolved . Also the 
huge dumps to printk's which runs with irqs off (usually over slow 
serial ports) causing lost time also is an outstanding issue.


> Fixing this is simple -- use mult_frac() in clocksource_cyc2ns().
>
> Signed-off-by: Prarit Bhargava<prarit@redhat.com>
> Cc: John Stultz<johnstul@us.ibm.com>
> Cc: Thomas Gleixner<tglx@linutronix.de>
> Cc: Salman Qazi<sqazi@google.com>
> Cc: stable@kernel.org
> ---
>   include/linux/clocksource.h |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
> index fbe89e1..1625ddb 100644
> --- a/include/linux/clocksource.h
> +++ b/include/linux/clocksource.h
> @@ -273,7 +273,7 @@ static inline u32 clocksource_hz2mult(u32 hz, u32 shift_constant)
>    */
>   static inline s64 clocksource_cyc2ns(cycle_t cycles, u32 mult, u32 shift)
>   {
> -	return ((u64) cycles * mult)>>  shift;
> +	return mult_frac(cycles, mult, (1UL<<  shift));
>   }
>
>
So I'm not sure this is actually the right fix.

The first issue is that the overflow is expected at a specific 
frequency, and the clocksource code and clockevent code work together to 
make sure the timekeeping core can accumulate time within that 
frequency. This is important not just for multiplication overflows, but 
also because some clocksource hardware wraps after just a few seconds, 
requiring we accumulate frequently.

The rest of the timekeeping code is designed with the requirement that 
the overflow you're solving with the above doesn't happen.  It doesn't 
mean it can't happen (as you've experience), but that you're running 
outside the expected bounds of the timekeeping code. So just fixing the 
multiply in clocksource_cyc2ns doesn't also change the assumptions 
elsewhere in the timekeeping code.

Additionally, gettimeofday/clock_gettime is a hotpath, and this adds 
extra overhead to the calculation.  So that's not great either.

So as I said above, I think there's really two issues at play here:
1) If you starve the timekeeping code from being able to periodically 
accumulate time bad things happen.
2) The clocksource watchdog in particular cannot suffer much delay at 
all, and falsely triggers on occasion.

Item #1 is really an issue of degree. We can try to be more flexible by 
stretching the expected length of the period out further. But some 
hardware that wraps quickly just cannot accommodate long intervals.  On 
the TSC we have quite a bit of time till it wraps, but by keeping the 
periods shorter, we allow for finer grained clock adjustments for NTP.  
So its somewhat of a balancing act between allowing for really precise 
timekeeping and robustness in the face of interrupt starvation (and we 
have only been getting better here, the periodic accumulation was only a 
tick back in the day, so SMIs or any long period with irqs off would 
cause lost time). Currently the TSC period should be 10 minutes before 
we overflow (which aligns to your 600 seconds above). I believe this to 
be a reasonable length of time where we should expect interrupts to be 
able to occur.   For example, other common clock hardware, like the 
acpi_pm can really only last ~5 seconds before it wraps.

Item #2 is where I think the real fix is needed. The watchdog has been 
useful in being able to detect flakey TSCs, but because running with a 
bad TSC can be very problematic for the kernel, its is quick on the 
trigger to disqualify it. Also, over the years, the expected use cases 
have grown for systems, and that has run into problems as it hits the 
bounds of the watchdogs' expectations. In fact, I suspect its not that 
the TSC wrapping but the HPET or acpi_pm that is being used as the 
"stable" watchdog clocksource.  One likely way to trigger a false 
positive is if the watchdog is the acpi_pm, but the clocksoruce is the 
TSC, we can delay/starve interrupts for quite some time, since the TSC 
won't wrap. But if the watchdog arrives late, and the acpi_pm clock has 
wrapped, then it assumes the TSC is broken. The problem with these 
issues is from the kernel's perspective you have to trust one of the two 
clocks. A similar issue can happen w/ the HPET but not as quickly (since 
it won't wrap as fast,  although maybe you're hitting the multiplication 
overflow there... honestly your 18 second interval time in the above 
isn't lining up for me right now, have to think more on that).

The hard problem is that the TSC can go wrong in *many* ways. Its a 
terrible architecture feature,  but there's nothing close to it 
performance wise, so we do what we can to try to make use of it when its 
safe.   Its variation of problems makes it hard to detect false 
positives when the "trusted" watchdog fails.

One idea I've had is to replace the watchdog clocksource with the 
read_persistent_clock() RTC  interface. This would allow us to avoid 
wrapping issues with watchdog clocksources, however it would also mean 
we couldn't really check the TSC accuracy for a number of seconds to 
minutes (due to the RTC granularity being just seconds itself). Or maybe 
it would be good to still use the watchdog, but double check against the 
RTC if we get a false positive long after boot?

Another idea I had tried to work on a few years ago was to try to catch 
watchdog overflows was checking if the TSC delta ==  watchdog delta + 
some multiple of watchdog intervals, but I didn't manage to get the math 
right there, and with small enough wrapping intervals and a long enough 
delay, a % error bound becomes impossible to trigger.

One idea might be to replace the cyc2ns w/ mult_frac in only the 
watchdog code.  I need to think on that some more (and maybe have you 
provide some debug output) to really understand how that's solving the 
issue for you, but it would be able to be done w/o affecting the other 
assumptions of the timekeeping core.

Thomas: Any other ideas? Looking at the watchdog code, since its not an 
hrtimer, could it also possibly be delayed past its .0625s threshold 
even just due to long NOHZ deep idle? I suspect quite a few assumptions 
have changed since that code was written. :)

thanks
-john

