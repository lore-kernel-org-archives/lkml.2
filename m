Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab2KMAJl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 19:09:41 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:34090 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297Ab2KMAJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 19:09:40 -0500
Message-ID: <50A18FB6.90407@us.ibm.com>
Date: Mon, 12 Nov 2012 16:09:26 -0800
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: David Henningsson <david.henningsson@canonical.com>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        "Rostedt, Steven" <rostedt@goodmis.org>
Subject: Re: getnstimeofday stuck for several milliseconds?
References: <50977DF5.60703@canonical.com> <50A18C0F.9000604@us.ibm.com>
In-Reply-To: <50A18C0F.9000604@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111300-5518-0000-0000-0000093B94A9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2012 03:53 PM, John Stultz wrote:
> On 11/05/2012 12:51 AM, David Henningsson wrote:
>> Hi LKML,
>>
>> I'm trying to make audio more useful in everyday low-latency 
>> scenarios such as gaming or VOIP.
>>
>> While doing so, I ran the wakeup_rt tracer, to track the time from 
>> PulseAudio requesting wakeup (through hrtimers), to the thread 
>> actually running.
>>
>> I'm not sure how much overhead added by the wakeup_rt tracer itself, 
>> but I got 9 ms on one machine and 20 ms on another, which I consider 
>> to be quite a lot even for a standard kernel (i e without RT or other 
>> special configuration).
>>
>> The 9 ms example is pastebinned at [1], and here's where we get stuck 
>> for most of the time:
>>
>>   <idle>-0       3d... 1105us : ktime_get_real <-intel_idle
>>   <idle>-0       3d... 1106us!: getnstimeofday <-ktime_get_real
>>   <idle>-0       3d... 7823us : ktime_get_real <-intel_idle
>>
>>   <idle>-0       3d... 7890us : ktime_get_real <-intel_idle
>>   <idle>-0       3d... 7891us!: getnstimeofday <-ktime_get_real
>>   <idle>-0       3d... 9023us : ktime_get_real <-intel_idle
>>
>
> Looking at the trace you posted here: http://pastebin.se/6iMRdDfR
>
> The trace also looks like its the cpuidle to interrupt transition 
> where you're seeing this.  I sort of wonder if its mis-attributing the 
> idle time to the getnstimeofday()? Mainly because you don't seem to 
> spend much time in intel_idle() otherwise.
>
> Or maybe we're both misreading it and its saying there's a delay 
> between the first ktime_get_real() from intel_idle() to the second 
> call of ktime_get_real(), between which we're in deep idle (which 
> would make sense)?
>
The more I think about it, I'm pretty sure this is the case:
The full context you need is:
     <idle>-0       3d... 7890us : ktime_get_real <-intel_idle
     <idle>-0       3d... 7891us!: getnstimeofday <-ktime_get_real
     <idle>-0       3d... 9023us : ktime_get_real <-intel_idle
     <idle>-0       3d... 9024us : getnstimeofday <-ktime_get_real

Where intel_idle() is calling ktime_get_real twice in a row, and 
inbetween we see a large latency. Looking at intel_idle() the code in 
question is:

     kt_before = ktime_get_real();

     stop_critical_timings();
     if (!need_resched()) {

         __monitor((void *)&current_thread_info()->flags, 0, 0);
         smp_mb();
         if (!need_resched())
             __mwait(eax, ecx);
     }

     start_critical_timings();

     kt_after = ktime_get_real();


Where we're basically timing how long we were in idle for.

So I think the problem is just misreading the trace output.

thanks
-john




