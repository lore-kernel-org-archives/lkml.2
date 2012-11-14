Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423533Ab2KNW0f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 17:26:35 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:45977 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423518Ab2KNW0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 17:26:34 -0500
Message-ID: <50A41A85.9090800@linaro.org>
Date: Wed, 14 Nov 2012 14:26:13 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Will Deacon <will.deacon@arm.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Pekka Enberg <penberg@gmail.com>,
        Robert Richter <robert.richter@amd.com>, tglx <tglx@linutronix.de>
Subject: Re: [RFC] perf: need to expose sched_clock to correlate user samples
 with kernel samples
References: <CABPqkBQALeD=iO9x-N0nw+shhqa1kmUaj=sCvx+MvoAPGQ-y9A@mail.gmail.com> <1350408232.2336.42.camel@laptop> <509DB632.7070305@linaro.org> <1352840337.18025.43.camel@gandalf.local.home>
In-Reply-To: <1352840337.18025.43.camel@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111422-5112-0000-0000-00000E92A079
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2012 12:58 PM, Steven Rostedt wrote:
> On Fri, 2012-11-09 at 18:04 -0800, John Stultz wrote:
>> On 10/16/2012 10:23 AM, Peter Zijlstra wrote:
>>> I've no problem with adding CLOCK_PERF (or another/better name).
>> Hrm. I'm not excited about exporting that sort of internal kernel
>> details to userland.
>>
>> The behavior and expectations from sched_clock() has changed over the
>> years, so I'm not sure its wise to export it, since we'd have to
>> preserve its behavior from then on.
>>
>> Also I worry that it will be abused in the same way that direct TSC
>> access is, where the seemingly better performance from the more
>> careful/correct CLOCK_MONOTONIC would cause developers to write fragile
>> userland code that will break when moved from one machine to the next.
>>
>> I'd probably rather perf output timestamps to userland using sane clocks
>> (CLOCK_MONOTONIC), rather then trying to introduce a new time domain to
>> userland.   But I probably could be convinced I'm wrong.
> I'm surprised that perf has its own clock anyway. But I would like to
> export the tracing clocks. We have three (well four) of them:
>
> trace_clock_local() which is defined to be a very fast clock but may not
> be synced with other cpus (basically, it just calls sched_clock).
>
> trace_clock() which is not totally serialized, but also not totally off
> (between local and global). This uses local_clock() which is the same
> thing that perf_clock() uses.
>
> trace_clock_global() which is a monotonic clock across CPUs. It's much
> slower than the above, but works well when you require synced
> timestamps.
>
> There's also trace_clock_counter() which isn't even a clock :-)  It's
> just a incremental atomic counter that goes up every time it's called.
> This is the most synced clock, but is absolutely meaningless for
> timestamps. It's just a way to show ordered events.

Oof. This is getting uglier. I'd really prefer not to expose all these 
different internal clocks out userland. Especially via clock_gettime().

thanks
-john

