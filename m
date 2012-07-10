Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674Ab2GJTvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 15:51:25 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:60295 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab2GJTvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 15:51:23 -0400
MIME-Version: 1.0
In-Reply-To: <1341915609.3462.113.camel@twins>
References: <1341392911-1888300-1-git-send-email-avagin@openvz.org>
	<1341915609.3462.113.camel@twins>
Date: Tue, 10 Jul 2012 23:51:21 +0400
Message-ID: <CANaxB-zkijP1yPL4uaxx-dw-8mnQBb0fe3m8uGv7AcgzAcT8bA@mail.gmail.com>
Subject: Re: [PATCH] trace: add ability to set a target task for events
From: Andrey Wagin <avagin@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arun Sharma <asharma@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Peter,

2012/7/10 Peter Zijlstra <peterz@infradead.org>:
> On Wed, 2012-07-04 at 13:08 +0400, Andrew Vagin wrote:
>> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
>>
>> A few events are interesting not only for a current task.
>> For example, sched_stat_* are interesting to a task, which
>> wake up. For this reason, it will be good, if such events will
>> be delivered to a target task too.
>>
>> Now a target task can be set by using __perf_task().
>
> Right, I suspect you actually tested this and it works?

Yes, of course I did.

>
> It would be good it you can expand the Changelog a bit to include your
> entire use-case.
Ok, I'm going to send a new version of this patch with your comments.

> IIRC you're wanting to measure task block latency and
> need the time and place where it goes to sleep, provided by
> trace_sched_switch + callchain, and the time when it gets woken up,
> provided by trace_sched_wakeup().

Actually sched_stat_* contains a time period for which a task slept.

Now for profiling sleep times we need to do following actions:
* Collect sched_switch and sched_stat_sleep events
# ./perf record -e sched:sched_stat_sleep -e sched:sched_switch -gP -o
perf.data.raw ~/foo
* We need to combine sched_switch and  sched_stat_sleep events.
sched_switch contains a callchain and sched_stat_sleep contains a time
period. I taught perf-inject to do that. It sets a period from
sched_stat_sleep to  a proper sched_switch.
# ./perf inject -v -s -i perf.data.raw -o ./perf.data

>
> Hmm.. you only add __perf_task() to sched_stat_template, should it also
> be added to sched_wakeup_template?

Yes, it can be added. It may be useful for someone else.

>
> ISTR us talking about dis-allowing callgraphs on such cross-task events,
> since that would be nigh impossible to interpret, right?
>
> So do we want something like this on top?

Yes, you are right and I checked your code, it works fine. Thanks a
lot for comments.

If someone wants to try out my patches, he can clone the branch
"prof-D-state"  from it git://github.com/avagin/perf.git
