Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932717Ab0KOTp5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 14:45:57 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:55498 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932119Ab0KOTp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 14:45:56 -0500
Subject: Re: [PATCH] clocksource: document some basic concepts
From: john stultz <johnstul@us.ibm.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Nicolas Pitre <nico@fluxnic.net>, Colin Cross <ccross@google.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>
In-Reply-To: <1289817228-14838-1-git-send-email-linus.walleij@stericsson.com>
References: <1289817228-14838-1-git-send-email-linus.walleij@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Nov 2010 11:45:27 -0800
Message-ID: <1289850327.3004.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-15 at 11:33 +0100, Linus Walleij wrote:
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

Thanks for writing this up!

I do worry a little that by talking about the two subjects in the same
document, it creates an impression that the two infrastructures are
conceptually linked (even though this is mostly about the differences
between them).

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
> +counter register is read in two phases on the bus lowest 16 bits first and
> +the higher 16 bits in a second bus cycle with the counter bits potentially
> +being updated inbetween leading to the risk of very strange values from the
> +counter.
> +
> +When the wall-clock accuracy of the clock source isn't satisfactory, there
> +are various quirks and layers in the timekeeping code for e.g. synchronizing
> +the user-visible time to RTC clocks in the system or against networked time
> +servers using NTP, but all they do is basically to update an offset against
> +the clock source, which provides the fundamental timeline for the system.
> +These measures does not affect the clock source per se.

Its not so much updating an offset, but more adjusting the frequency to
steer the clocksource to NTP time. 

Also while syncing the RTC is something that the timekeeping code does,
its not really connected to the clocksource code in particular. 


> +
> +The clock source struct shall provide means to translate the provided counter
> +into a rough nanosecond value as an unsigned long long (unsigned 64 bit) number.
> +Since this operation may be invoked very often doing this in a strict
> +mathematical sense is not desireable: instead the number is taken as close as
> +possible to a nanosecond value using only the arithmetic operations
> +mult and shift, so in clocksource_cyc2ns() you find:
> +
> +  ns ~= (clocksource * mult) >> shift
> +
> +You will find a number of helper functions in the clock source code intended
> +to aid in providing these mult and shift values, such as
> +clocksource_khz2mult(), clocksource_hz2mult() that help determinining the
> +mult factor from a fixed shift, and clocksource_calc_mult_shift() and
> +clocksource_register_hz() which will help out assigning both shift and mult
> +factors using the frequency of the clock source and desirable minimum idle
> +time as the only input. In the past, the timekeeping authors would come up with
> +these values by hand, which is why you will sometimes find hard-coded shift
> +and mult values in the code.

Yea. I'm working on cleaning these out, so I'd recommend just pointing
to using clocksource_register_hz/khz(), to have a proper mult-shift pair
calculated out for you. The explanation about the hard-coded bit from
the past is good while we're in transition.

> +Since a 32 bit counter at say 100 MHz will wrap around to zero after some 43
> +seconds, the code handling the clock source will have to compensate for this.
> +That is the reason to why the clock source struct also contains a 'mask'
> +member telling how many bits of the source are valid. This way the timekeeping
> +code knows when the counter will wrap around and can insert the necessary
> +compensation code on both sides of the wrap point so that the system timeline
> +remains monotonic. Note that the clocksource_cyc2ns() function will not
> +compensate for wrap-arounds: it will return the rough number of nanoseconds
> +since the last wrap-around.

Hrm. There are some more non-obvious conditions on this. In fact, for
clocksources that wrap at longer periods, you may hit an multiplication
overflows before the wrap boundary.

I'm starting to feel like clocksource_cyc2ns() should be internalized to
the timekeeping code so its subtle limitations aren't accidentally
tripped over, if its incorrectly re-used for some other purpose.

In fact, as with the clocksource_register_hz/khz, I'm thinking we should
move more towards internalizing most of the complex bits of the
clocksource structure. I'm hoping a read(), freq_hz/khz value, rating
and flags would be all that's needed, hopefully simplifying things for
clocksource writers, and reducing the chance folks might get something
wrong.

thanks
-john

