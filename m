Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab2KLXyT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 18:54:19 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:48941 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158Ab2KLXyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 18:54:18 -0500
Message-ID: <50A18C0F.9000604@us.ibm.com>
Date: Mon, 12 Nov 2012 15:53:51 -0800
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: David Henningsson <david.henningsson@canonical.com>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        "Rostedt, Steven" <rostedt@goodmis.org>
Subject: Re: getnstimeofday stuck for several milliseconds?
References: <50977DF5.60703@canonical.com>
In-Reply-To: <50977DF5.60703@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111223-7408-0000-0000-00000A31C5D1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2012 12:51 AM, David Henningsson wrote:
> Hi LKML,
>
> I'm trying to make audio more useful in everyday low-latency scenarios 
> such as gaming or VOIP.
>
> While doing so, I ran the wakeup_rt tracer, to track the time from 
> PulseAudio requesting wakeup (through hrtimers), to the thread 
> actually running.
>
> I'm not sure how much overhead added by the wakeup_rt tracer itself, 
> but I got 9 ms on one machine and 20 ms on another, which I consider 
> to be quite a lot even for a standard kernel (i e without RT or other 
> special configuration).
>
> The 9 ms example is pastebinned at [1], and here's where we get stuck 
> for most of the time:
>
>   <idle>-0       3d... 1105us : ktime_get_real <-intel_idle
>   <idle>-0       3d... 1106us!: getnstimeofday <-ktime_get_real
>   <idle>-0       3d... 7823us : ktime_get_real <-intel_idle
>
>   <idle>-0       3d... 7890us : ktime_get_real <-intel_idle
>   <idle>-0       3d... 7891us!: getnstimeofday <-ktime_get_real
>   <idle>-0       3d... 9023us : ktime_get_real <-intel_idle
>
Its been awhile since I looked at wakeup_rt trace output, but that looks 
more like ~6.7ms and ~1.2ms latencies, not 9ms (are you adding these 
together?).

> It seems to me that sometimes we get stuck for several milliseconds 
> inside the getnstimeofday function - this was seen on both the 9 ms 
> and the 20 ms trace. This looks like a bug to me, and as I'm not sure 
> on how to best debug it further, and therefore I'm asking for help (or 
> a bug fix!) here.
>
> For reference, the 9 ms trace was from a ~2 year old laptop (core i3 
> cpu) running 3.7rc2 vanilla/mainline kernel, and the 20 ms trace was 
> from an ~1 year old Atom-based machine running the 3.2-ubuntu kernel. 
> While tracing was enabled, I was running a libSDL game for a minute or 
> two.
>
> Thanks in advance for looking into this, and let me know if you need 
> further information, or anything else I can do to help sorting this 
> one out.

Hrmm.. So 6.7ms is still a long time.

Looking at the trace you posted here: http://pastebin.se/6iMRdDfR

The trace also looks like its the cpuidle to interrupt transition where 
you're seeing this.  I sort of wonder if its mis-attributing the idle 
time to the getnstimeofday()? Mainly because you don't seem to spend 
much time in intel_idle() otherwise.

Or maybe we're both misreading it and its saying there's a delay between 
the first ktime_get_real() from intel_idle() to the second call of 
ktime_get_real(), between which we're in deep idle (which would make sense)?

Because unless the timekeeping lock is getting held for a long time, I 
don't know why else you'd see such long delays at getnstimeofday().

Cc'ing Steven to see if he can't help understand whats going on here.

thanks
-john



