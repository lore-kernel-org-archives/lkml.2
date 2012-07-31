Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab2GaFtK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 01:49:10 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:33365 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014Ab2GaFtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 01:49:08 -0400
Message-ID: <501771CA.1090304@us.ibm.com>
Date: Mon, 30 Jul 2012 22:48:58 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: CAI Qian <caiqian@redhat.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Zhouping Liu <zliu@redhat.com>
Subject: Re: boot panic regression introduced in 3.5-rc7
References: <1971950954.1278169.1343620316300.JavaMail.root@redhat.com>
In-Reply-To: <1971950954.1278169.1343620316300.JavaMail.root@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12073105-7182-0000-0000-0000021C1EF9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2012 08:51 PM, CAI Qian wrote:
> The bisecting pointed out this patch caused one of dell servers boot panic.
>
>    5baefd6d84163443215f4a99f6a20f054ef11236
>    hrtimer: Update hrtimer base offsets each hrtimer_interrupt
>
> [    2.971092] WARNING: at kernel/time/clockevents.c:209 clockevents_program_event+0x10a/0x120()
> [    2.971092] Hardware name: PowerEdge M605

Ok. So I think I've chased this all the way down.

The main issue as noted earlier, is that on this system, the RTC/CMOS is 
returning a year of 8200 as seen in the dmesg:

[    0.000000] Extended CMOS year: 8200

This causes problems because,  the (signed) 64bit ktime_t structure can 
only store ~292 years of nanoseconds.  Thus, when initialize the time 
from the persistent clock, and set the time to the year 8200, this 
results in the timekeeper.offs_real being capped at KTIME_MAX ((1LL<<63)-1).

So congrats! While most folks haven't started looking at the 2038 issue 
on 32bit systems, you've already started pushing the internal limits on 
64bit systems :)

Now, while this is obviously problematic, this point confused me for a 
bit:  Prior to the commit bisected in the original mail above, we stored 
the same bad KTIME_MAX data in the 
cpu_base->clock_base[HRTIMER_BASE_REALTIME].offset value.  We just 
didn't read the value from the timekeeping core at each interrupt, and 
the value isn't actually changing when the warning and panic is being 
triggered.

So it was unclear as to why if we're providing the same bad KTIME_MAX 
value to hrtimer_interrupt, why are we seeing problems now and not before?

After hacking the kernel and forcing the persistent clock to return a 
similar bad CMOS value of the year 8200, I could reproduce this and 
finally track it down.

Ends up there's a slight difference in  ktime_get_update_offsets() vs 
ktime_get():

ktime_get() does basically the following:
         return timespec_to_ktime(timespec_add(xtime, wall_to_monotonic))

Where as ktime_get_update_offsets does approximately:
         return ktime_sub(timespec_to_ktime(xtime), realtime_offset);

The problem is, at boot we set xtime = year 8200 and wall_to_monotonic = 
year -8200,  ktime_get adds both values, mostly nulling the difference 
out (leaving only how long the system has been up), then converts that 
relatively small value to a ktime_t properly without losing any information.

ktime_get_update_offsets however, since it converts xtime (again set to 
some value greater then year 8200), to a ktime, it gets clamped at 
KTIME_MAX, then we subtract realtime_offset, which is _also_ clamped at 
KTIME_MAX, resulting in us always returning almost[1] zero.  This causes 
us to stop expiring timers.

Now, one of the reasons Thomas and I changed the logic was that using 
the precalculated realtime_offset was slightly more efficient then 
re-adding xtime and wall_to_monotonic's components separately. But how 
valuable this unmeasured slight efficiency is vs extra robustness for 
crazy time values is questionable.

Additionally I suspect that your system probably corrects itself in 
early boot via ntpdate, as I'm pretty sure you'd have other strange 
timer behavior trying to run the system with a date larger then KTIME_MAX.

So I suspect we need two fixes here:
1) Fall back to using the full-precision ktime_get() method of 
calculating the current monotonic time in ktime_get_update_offsets to 
avoid what is in effect precision loss with very large timespecs.
2) Validate that time values we accept are smaller the ktime_t before 
using them.

Thomas, does this sound reasonable? Patches to follow shortly.

thanks
-john


[1] So the reality is slightly more complicated, since 
ktime_get_update_offsets actually returns:
         return ktime_sub(ktime_add(ktime_set(xtime.tv_sec,0),nsecs), 
realtime_offset);
Which basically means we return some value that increases to ~4seconds 
and then nsec overflows and we loop back to zero.

