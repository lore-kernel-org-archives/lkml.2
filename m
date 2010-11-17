Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934717Ab0KQMRL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 07:17:11 -0500
Received: from freeflow.nu ([178.79.134.28]:51212 "EHLO freeflow.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934714Ab0KQMRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 07:17:08 -0500
Message-ID: <4CE3C7C2.7000200@kernel.org>
Date: Wed, 17 Nov 2010 14:17:06 +0200
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch] trace: Add user-space event tracing/injection
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6> <4CE38C53.8090606@kernel.org> <20101117120740.GA24972@elte.hu>
In-Reply-To: <20101117120740.GA24972@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On 11/17/10 2:07 PM, Ingo Molnar wrote:
> * Pekka Enberg<penberg@kernel.org>  wrote:
>
>> (Trimming CC for sanity.)
> [ Added back Linus (in case he wants to object to the new prctl()) and lkml. ]
>
>> On 11/16/10 11:04 PM, Thomas Gleixner wrote:
>>> 'trace' is our shot at improving the situation: it aims at providing a
>>> simple to use and straightforward tracing tool based on the perf
>>> infrastructure and on the well-known perf profiling workflow:
>>>
>>>     trace record firefox          # trace firefox and all child tasks,
>>>                                     put it into trace.data
>>>
>>>     trace summary                 # show quick overview of the trace,
>>>                                     based on trace.data
>>>
>>>     trace report                  # detailed traces, based on trace.data
>> Nice work guys!
>>
>> Does this concept lend itself to tracing latencies in userspace applications that
>> run in virtual machines (e.g. the Java kind)? I'm of course interested in this
>> because of Jato [1] where bunch of interesting things can cause jitter: JIT
>> compilation, GC, kernel, and the actual application doing something (in either
>> native code or JIT'd code). It's important to be able to measure where "slowness"
>> to desktop applications and certain class of server applications comes from to be
>> able to improve things.
> Makes quite a bit of sense.
>
> How about the attached patch? It works fine with the simple testcase included in the
> changelog. There's a common-sense limit on the message size - but otherwise it adds
> support for apps to generate a free-form string trace event.
>
> Thanks,
>
> 	Ingo
>
> ---------------------------------->
> Subject: trace: Add user-space event tracing/injection
> From: Ingo Molnar<mingo@elte.hu>
> Date: Wed Nov 17 10:11:53 CET 2010
>
> This feature (suggested by Darren Hart and Pekka Engberg) allows user-space
> programs to print trace events in a very simple and self-contained way:
>
>   #include<sys/prctl.h>
>   #include<string.h>
>
>   #define PR_TASK_PERF_USER_TRACE 35
>
>   int main(void)
>   {
>           char *msg = "Hello World!\n";
>
>           prctl(PR_TASK_PERF_USER_TRACE, msg, strlen(msg));
>
>           return 0;
>   }
>
> These show up in 'trace' output as:
>
>   $ trace report
>   #
>   # trace events of 'sleep 1':
>   #
>          testit/ 6006 ( 0.002 ms):<"Hello World!">
>          testit/ 6006 ( 0.002 ms):<"Hello World!">

Wow! This looks really nice!

What does the duration in milliseconds mean there? For things like GC 
and JIT, I want something like:

void gc(void)
{
         prctl(PR_TASK_PERF_USER_TRACE_START, ...)

         collect();

         prctl(PR_TASK_PERF_USER_TRACE_END, ...)
}

So that it's clear from the tracing output that the VM was busy doing GC 
for n milliseconds. Barring background JIT'ing and pauseless GC, I'd 
also be interested in showing how much time the VM was actually 
_blocking_ the running application (which can happen with signals too, 
btw, for things like accessing data that's lazily initialized).

             Pekka
