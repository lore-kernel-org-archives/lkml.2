Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab2KQDQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 22:16:50 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:38200 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab2KQDQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 22:16:49 -0500
Message-ID: <50A70199.9030109@us.ibm.com>
Date: Fri, 16 Nov 2012 19:16:41 -0800
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2] pstore/ram: no timekeeping calls when unavailable
References: <20121105220059.GA6379@www.outflux.net> <509DA63E.7070500@us.ibm.com> <CAGXu5jKq0=+XfH6yDSaJMcd-S3=o7xB67kspPkCRcXjRSGgciw@mail.gmail.com> <20121117025355.GC29966@lizard>
In-Reply-To: <20121117025355.GC29966@lizard>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111703-7408-0000-0000-00000A550100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2012 06:53 PM, Anton Vorontsov wrote:
> On Fri, Nov 09, 2012 at 05:26:53PM -0800, Kees Cook wrote:
> [....]
>>>> @@ -171,7 +171,13 @@ static size_t ramoops_write_kmsg_hdr(struct
>>>> persistent_ram_zone *prz)
>>>>          struct timeval timestamp;
>>>>          size_t len;
>>>>
>>>> -       do_gettimeofday(&timestamp);
>>>> +       /* Handle dumping before timekeeping has resumed. */
>>>> +       if (unlikely(timekeeping_suspended)) {
>>>> +               timestamp.tv_sec = 0;
>>>> +               timestamp.tv_usec = 0;
>>>> +       } else
>>>> +               do_gettimeofday(&timestamp);
>>>> +
>>> Would nulling out the timestamp be better done in do_gettimeofday()?  That
>>> way we don't have to export timekeeping internals and users would get
>>> something more sane for this corner case.
>> Well... I'm not sure. If we don't want to expose the
>> timekeeping_suspended variable, maybe we need a function to check
>> this? I think it's probably better to find the users of timekeeping
>> that could call it when suspended. That's why I figured the BUG was
>> there. Very very few things should be attempting to call gettimeofday
>> in a place where it might be suspended. As such, it seems like those
>> things should be able to determine how to handle it. Maybe not
>> everything would be sensible to get back 0s.
>>
>> In this particular case, I'm fine with removing the BUG and returning
>> 0 instead, since that's fine for ramoops. :)
> In the lack of agreement on kernel/time/timekeeping.c change, I can't
> apply the patch. And personally I tend to agree that doing this workaround
> in the pstore code is odd. How about introducing ___do_gettimeofday() that
> is safe to call when suspened, and the func would have good kernel doc
> comments explaining the purpose of it?
Yea, I wanted to revisit this, because it is an odd case.

We don't want to call getnstimeofday() while the timekeeping code is 
suspended, since the clocksource cycle_last value may be invalid if the 
hardware was reset during suspend.  Kees is correct,  the WARN_ONs were 
there to make sure no one tries to use the timekeeping core before its 
resumed, so removing them is problematic.

Your sugggestion of having the __do_gettimeofday() internal accessor 
that maybe returns an error if timekeeping has been suspended could work.

The other possibility is depending on the needs for accuracy with the 
timestamp, current_kernel_time() might be a better interface to use, 
since it will return the time at the last tick, and doesn't require 
accessing the clocksource hardware.  Might that be a simpler solution? 
Or is sub-tick granularity necessary?

thanks
-john







