Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab2KLWkY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 17:40:24 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:38890 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab2KLWkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 17:40:22 -0500
Message-ID: <50A17A9A.1060400@linaro.org>
Date: Mon, 12 Nov 2012 14:39:22 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Anton Blanchard <anton@samba.org>, Will Deacon <will.deacon@arm.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Pekka Enberg <penberg@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>, tglx <tglx@linutronix.de>
Subject: Re: [RFC] perf: need to expose sched_clock to correlate user samples
 with kernel samples
References: <CABPqkBQALeD=iO9x-N0nw+shhqa1kmUaj=sCvx+MvoAPGQ-y9A@mail.gmail.com> <1350408232.2336.42.camel@laptop>	<509DB632.7070305@linaro.org> <CABPqkBRwAEDU3g0D7JH-iMq2JVH63h1pydKOdSWhYwkX27pesA@mail.gmail.com> <50A145A5.7060402@linaro.org> <CABPqkBQonkddt0mfkowM-oFcOPBTA2gNAju+PPrpcfqEs-L=KA@mail.gmail.com>
In-Reply-To: <CABPqkBQonkddt0mfkowM-oFcOPBTA2gNAju+PPrpcfqEs-L=KA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111222-4834-0000-0000-000000602C15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2012 12:54 PM, Stephane Eranian wrote:
> On Mon, Nov 12, 2012 at 7:53 PM, John Stultz <john.stultz@linaro.org> wrote:
>> On 11/11/2012 12:32 PM, Stephane Eranian wrote:
>>> On Sat, Nov 10, 2012 at 3:04 AM, John Stultz <john.stultz@linaro.org>
>>> wrote:
>>>> Also I worry that it will be abused in the same way that direct TSC
>>>> access
>>>> is, where the seemingly better performance from the more careful/correct
>>>> CLOCK_MONOTONIC would cause developers to write fragile userland code
>>>> that
>>>> will break when moved from one machine to the next.
>>>>
>>> The only goal for this new time source is for correlating user-level
>>> samples with
>>> kernel level samples, i.e., application level events with a PMU counter
>>> overflow
>>> for instance. Anybody trying anything else would be on their own.
>>>
>>> clock_gettime(CLOCK_PERF): guarantee to return the same time source as
>>> that used by the perf_event subsystem to timestamp samples when
>>> PERF_SAMPLE_TIME is requested in attr->sample_type.
>>
>> I'm not familiar enough with perf's interfaces, but if you are going to make
>> this clockid bound so tightly with perf, could you maybe export a perf
>> timestamp from one of perf's interfaces rather then using the more generic
>> clock_gettime() interface?
>>
> Yeah, I considered that as well. But it is more complicated. The only syscall
> we could extend for perf_events is ioctl(). But that one requires that an
> event be created so we obtain a file descriptor for the ioctl() call
> So we'd have to
> pretend programming a dummy event just for the purpose of obtained a timestamp.
> We could do that but that's not so nice. But more amenable to the

Sorry, you trailed off.   Did you want to finish that thought? (I do 
that all the time.  :)

> Keep in mind that the clock_gettime() would be used by programs which are not
> self-monitoring but may be monitored externally by a tool such as perf. We just
> need to them to emit their events with a timestamp that can be
> correlated offline
> with those of perf_events.

Again, forgive me for not really knowing much about perf here, but could 
you have a perf log an event when clock_gettime() was called, possibly 
recording the returned value, so you could correlate that data yourself?


>>>> I'd probably rather perf output timestamps to userland using sane clocks
>>>> (CLOCK_MONOTONIC), rather then trying to introduce a new time domain to
>>>> userland.   But I probably could be convinced I'm wrong.
>>>>
>>> Can you get CLOCK_MONOTONIC efficiently and in ALL circumstances without
>>> grabbing any locks because that would need to run from NMI context?
>> No,  of course why we have sched_clock. But I'm suggesting we consider
>> changing what perf exports (via maybe interpolation/translation) to be
>> CLOCK_MONOTONIC-ish.
>>
> Explain to me the key difference between monotonic and what sched_clock()
> is returning today? Does this have to do with the global monotonic vs.
> the cpu-wide
> monotonic?

So CLOCK_MONOTONIC is the number of NTP corrected (for accuracy) seconds 
+ nsecs that the machine has been up for (so that doesn't include time 
in suspend). Its promised to be globally monotonic across cpus.

In my understanding, sched_clock's definition has changed over time. It 
used to be a fast but possibly incorrect nanoseconds since boot, but 
with suspend and other events it could reset/overflow and users (then 
only the scheduler) would be able to deal with it. It also wasn't 
guaranteed to be consistent across cpus.  So it was limited to 
calculating approximate time intervals on a single cpu.

However, with cfs  (And Peter or Ingo could probably hop in and clarify 
further) I believe it started to require some cross-cpu consistency and 
reset events would cause probelms with the scheduler, so additional 
layers have been added to try to enforce these additional requirements.

I suspect they aren't that far off, except calibration frequency errors 
go uncorrected with sched_clock. But was thinking you could get periodic 
timestamps in perf that correlated CLOCK_MONOTONIC with sched_clock and 
then allow the kernel to interpolate the sched_clock times out to 
something pretty close to CLOCK_MONOTONIC. That way perf wouldn't leak 
the sched_clock time domain to userland.

Again, sorry for being a pain here. The CLOCK_PERF would be a easy 
solution, but I just want to make sure its really the best one long term.

thanks
-john



