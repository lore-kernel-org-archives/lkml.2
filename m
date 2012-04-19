Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957Ab2DSL4s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 07:56:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13914 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730Ab2DSL4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 07:56:47 -0400
Message-ID: <4F8FFD77.4060503@redhat.com>
Date: Thu, 19 Apr 2012 07:56:39 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Salman Qazi <sqazi@google.com>, stable@kernel.org
Subject: Re: [PATCH] clocksource, prevent overflow in clocksource_cyc2ns
References: <1333552260-1170-1-git-send-email-prarit@redhat.com> <4F7C8C3E.1020203@us.ibm.com> <4F7C9402.3090602@redhat.com> <4F7CF094.5020201@us.ibm.com> <4F7D8FA1.1010107@redhat.com> <4F8F4C31.7010209@linaro.org> <4F8F555F.7040404@redhat.com> <4F8F59E2.4080301@linaro.org>
In-Reply-To: <4F8F59E2.4080301@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/18/2012 08:18 PM, John Stultz wrote:
> On 04/18/2012 04:59 PM, Prarit Bhargava wrote:
>>
>> Hey John,
>>
>> Thanks for continuing to work on this.  Coincidentally that exact patch was my
>> first attempt at resolving the problem as well.  The problem is that even after
>> touching the clocksource watchdog and restoring irqs the printk buffer can take
>> a LONG time to flush -- and that still will cause an overflow comparison.  So
>> fixing it with just a touch_clocksource_watchdog() isn't the right thing to do
>> IMO.  Maybe a combination of the printk() patch you suggested earlier and the
>> touch_clocksource_watchdog() is the right way to go but I'll leave that up to
>> tglx and yourself to decide on a correct fix.
> :( That's a bummer. Something similar may be useful on the printk side as well.

Hmm ... I'll give that a shot.

> 
> 
>> There's also some additional information that I've been gathering on this issue;
>> I have seen *idle* systems switch to the hpet because the clocksource watchdog
>> hits the overflow comparison.  As expected it happens much less frequently on
>> newer kernels (linux.git top of tree) than older stable kernels (2.6.32 based)
>> due to the difference in shift values but it is happening in both cases.
> 
> Some of the recent adjustments for more robust shift calculations may partially
> be responsible for the improvement. Although I'm not sure why idle systems (that
> don't halt the TSC in idle) would trip this.  Do let me know if you find any
> particular way of reproducing this.
> 
>> The odd thing about this behaviour is that I would expect it to occur with the
>> same frequency on small systems as it does on large systems with linux.git as
>> the watchdog fires once/second.  AFAICT I do not see this on small systems but
>> see it only on systems with greater than 24 cpus (both Intel and AMD).
> Hrm.

Yeah, it's odd.  I have no idea why more cpus makes any difference :/

> 
>> Using debug code similar to the dump code I previously provided, I can see that
>> every so often these large systems can hit a case where the tsc wraps and the
>> hpet is still monotonically increasing.  When the unstable calculation is
>> performed the result is obviously affected by the overflow.  Sometimes this
>> comparison overflow happens within 18 minutes, other times it can take hours or
>> days.
> TSC wraps? Are you sure that's what you see? Or do you have that switched? With
> the HPET wrapping?

Sorry, you're right -- the HPET wraps.  I mistyped that.

> 
> 
>> The other part of this puzzle is that if switch between the tsc and hpet every
>> 10 seconds, and run a gettimeofday() comparison program, the gettimeofday()
>> program will return a backwards time[1] event usually within half-an-hour.  [I'm
>> just including this info here to point out that switching between clocksources
>> seems to cause some momentary instability.  Before anyone points this out I will
>> say that this not a "real world" bug.  I'm trying to find out if anyone actually
>> does switch from the tsc to hpet (and back) on multi-purposed systems.  I'm
>> hoping the answer to that is "no" :) ].
> So, there were some recent fixes for 3.4 to address an issue specifically around
> inconsistencies at clocksource switch time:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=a939e817aa7e199d2fff05a67cb745be32dd5c2d
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=f695cf94837de53864180400cbac42cfa370426f
> 

AFAICT I have both of these in my tree.  It is linux-2.6.git as of
592fe8980688e7cba46897685d014c7fb3018a67.

I am doing

while (true)
do
        val=`ps aux | egrep $1 | wc -l`
        if [ $val -ne 2 ]; then
                exit 1
        fi
        echo "switching to tsc"
        echo tsc > /sys/devices/system/clocksource/clocksource0/current_clocksource

        sleep 10
        val=`ps aux | egrep $1 | wc -l`
        if [ $val -ne 2 ]; then
                exit 1
        fi
        echo "switching to hpet"
        echo hpet > /sys/devices/system/clocksource/clocksource0/current_clocksource
        sleep 10
done

where $1 is the pid of my gettimeofday() comparison test.  As I said, the test
exists when a "backwards" time event occurs so the script above also bails.

> 
> I definitely want to make sure any sort of inconsistencies like that are
> resolved. So let me know if you can still trigger anything like that with the
> latest 3.4 kernel.

I'll dig into this a bit more then -- I have a few things I want to investigate.
 I'll also try the touch_clocksource_watchdog() in the printk() code and get
back to in a few days.

P.
