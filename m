Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924Ab0KOQeJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 11:34:09 -0500
Received: from xenotime.net ([72.52.115.56]:41031 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754897Ab0KOQeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 11:34:07 -0500
Date: Mon, 15 Nov 2010 08:34:04 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Nicolas Pitre <nico@fluxnic.net>, Colin Cross <ccross@google.com>,
        John Stultz <johnstul@us.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>
Subject: Re: [PATCH] clocksource: document some basic concepts
Message-Id: <20101115083404.40e29969.rdunlap@xenotime.net>
In-Reply-To: <1289817228-14838-1-git-send-email-linus.walleij@stericsson.com>
References: <1289817228-14838-1-git-send-email-linus.walleij@stericsson.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Nov 2010 11:33:48 +0100 Linus Walleij wrote:

> This adds some documentation about clock sources and the weak
> sched_clock() function that answers questions that repeatedly
> arise on the mailing lists.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Nicolas Pitre <nico@fluxnic.net>
> Cc: Colin Cross <ccross@google.com>
> Cc: John Stultz <johnstul@us.ibm.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Rabin Vincent <rabin.vincent@stericsson.com>
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
> ---
>  Documentation/timers/00-INDEX        |    2 +
>  Documentation/timers/clocksource.txt |  106 ++++++++++++++++++++++++++++++++++
>  2 files changed, 108 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/timers/clocksource.txt
> 
> diff --git a/Documentation/timers/00-INDEX b/Documentation/timers/00-INDEX
> index a9248da..fb88065 100644
> --- a/Documentation/timers/00-INDEX
> +++ b/Documentation/timers/00-INDEX
> @@ -1,5 +1,7 @@
>  00-INDEX
>  	- this file
> +clocksource.txt
> +	- Clock sources and sched_clock() notes
>  highres.txt
>  	- High resolution timers and dynamic ticks design notes
>  hpet.txt
> diff --git a/Documentation/timers/clocksource.txt b/Documentation/timers/clocksource.txt
> new file mode 100644
> index 0000000..cf4ab9e
> --- /dev/null
> +++ b/Documentation/timers/clocksource.txt
> @@ -0,0 +1,106 @@
> +Clock sources and sched_clock()
> +-------------------------------
> +
> +If you grep through the kernel source you will find a number of architecture-
> +specific implementations of clock sources and several likewise architecture-
> +specific overrides of the sched_clock() function.
> +
> +To provide timekeeping for your platform, the clock source provides
> +the basic timeline, whereas clock events shoot interrupts on certain points
> +on this timeline, providing facilities such as high-resolution timers.
> +sched_clock() is used for scheduling and timestamping.
> +
> +
> +Clock sources
> +-------------
> +
> +The purpose of the clock source is to provide a timeline for the system that
> +tells you where you are in time. For example issuing the command 'date' on
> +a Linux system will eventually read the clock source to determine exactly
> +what time it is.
> +
> +Typically the clock source is a monotonic, atomic counter which will provide
> +n bits which count from 0 to (2^n-1) and then wraps around to 0 and start over.
> +
> +The clock source shall have as high resolution as possible, and shall be as
> +stable and correct as possible as compared to a real-world wall clock. It
> +should not move unpredictably back and forth in time or miss a few cycles
> +here and there.
> +
> +It must be immune the kind of effects that occur in hardware where e.g. the

              immune from the

> +counter register is read in two phases on the bus lowest 16 bits first and

                                          on the bus (lowest

> +the higher 16 bits in a second bus cycle with the counter bits potentially

                                  bus cycle) with

> +being updated inbetween leading to the risk of very strange values from the
> +counter.
> +
> +When the wall-clock accuracy of the clock source isn't satisfactory, there
> +are various quirks and layers in the timekeeping code for e.g. synchronizing
> +the user-visible time to RTC clocks in the system or against networked time
> +servers using NTP, but all they do is basically to update an offset against
> +the clock source, which provides the fundamental timeline for the system.
> +These measures does not affect the clock source per se.
> +
> +The clock source struct shall provide means to translate the provided counter
> +into a rough nanosecond value as an unsigned long long (unsigned 64 bit) number.

                                                                    64-bit)

> +Since this operation may be invoked very often doing this in a strict
> +mathematical sense is not desireable: instead the number is taken as close as

                             desirable:

> +possible to a nanosecond value using only the arithmetic operations
> +mult and shift, so in clocksource_cyc2ns() you find:
> +
> +  ns ~= (clocksource * mult) >> shift
> +
> +You will find a number of helper functions in the clock source code intended
> +to aid in providing these mult and shift values, such as
> +clocksource_khz2mult(), clocksource_hz2mult() that help determinining the

                                                 that help determine

> +mult factor from a fixed shift, and clocksource_calc_mult_shift() and
> +clocksource_register_hz() which will help out assigning both shift and mult
> +factors using the frequency of the clock source and desirable minimum idle
> +time as the only input. In the past, the timekeeping authors would come up with
> +these values by hand, which is why you will sometimes find hard-coded shift
> +and mult values in the code.
> +
> +Since a 32 bit counter at say 100 MHz will wrap around to zero after some 43

           32-bit

> +seconds, the code handling the clock source will have to compensate for this.
> +That is the reason to why the clock source struct also contains a 'mask'
> +member telling how many bits of the source are valid. This way the timekeeping
> +code knows when the counter will wrap around and can insert the necessary
> +compensation code on both sides of the wrap point so that the system timeline
> +remains monotonic. Note that the clocksource_cyc2ns() function will not
> +compensate for wrap-arounds: it will return the rough number of nanoseconds
> +since the last wrap-around.
> +
> +You will notice that the clock event device code is based on the same basic
> +idea about translating counters to nanoseconds using mult and shift
> +arithmetics, and you find the same family of helper functions again for
> +assigning these values. The clock event driver does not need a 'mask'
> +attribute however: the system will not try to plan events beyond the time
> +horizon of the clock event.
> +
> +
> +sched_clock()
> +-------------
> +
> +In addition to the clock sources and clock events there is a special weak
> +function in the kernel called sched_clock(). This function shall return the
> +number of nanoseconds since the system was started. An architecture may or
> +may not provide an implementation of sched_clock() on its own.
> +
> +As the name suggests, sched_clock() is used for scheduling the system,
> +determining the absolute timeslice for a certain process in the CFS scheduler
> +for example. It is also used for printk timestamps when you have selected to
> +include time information in printk for things like bootcharts.
> +
> +Compared to clock sources, sched_clock() has to be very fast: it is called
> +much more often, especially by the scheduler. If you have to do trade-offs
> +between accuracy compared to the clock source, you may sacrifice accuracy
> +for speed in sched_clock(). It however require the same basic characteristics

                                          requires

> +as the clock source, i.e. it has to be monotonic.
> +
> +The sched_clock() function may wrap only on unsigned long long boundaries,
> +i.e. after 64 bits. Since this is a nanosecond value this will mean it wraps
> +after circa 585 years. (For most practical systems this means "never".)
> +
> +If an architecture does not provide its own implementation of this function,
> +it will fall back to using jiffies, making its maximum resolution 1/HZ of the
> +jiffy frequency for the architecture. This will affect scheduling accuracy
> +and will likely show up in system benchmarks.
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
