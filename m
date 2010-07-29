Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab0G2K0j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 06:26:39 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:58060 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756342Ab0G2K0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 06:26:37 -0400
Content-Type: text/plain; charset=UTF-8
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Masami Hiramatsu <mhiramat@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2] ftrace: record command lines at more appropriate moment
From: Ian Munsie <imunsie@au1.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
In-reply-to: <20100729025039.GD13088@nowhere>
References: <1280317404-sup-4657@au1.ibm.com> <1280319410-18120-1-git-send-email-imunsie@au1.ibm.com> <20100729025039.GD13088@nowhere>
Date: Thu, 29 Jul 2010 20:26:13 +1000
Message-Id: <1280397883-sup-6572@au1.ibm.com>
User-Agent: Sup/0.11
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Frederic Weisbecker's message of Thu Jul 29 12:50:41 +1000 2010:
> So, in fact we can't do this. There is a strong reason that makes us maintaining
> the cmdline resolution on sched switch rather than on tracing time: for
> performances and scalability.
> 
> Look at what does tracing_record_cmdline():
> 
> - it's one more call
> - it checks a lot of conditions
> - takes a spinlock (gives up if already in use, but that's still bad for the cache
>   in a tracing path)
> - deref a shared hashlist
> ...
> 
> 
> Currently that is made on sched switch time, which means quite often.
> Now imagine you turn on the function tracer: this is going to happen
> for _every_ function called in the kernel. There is going to be a lot
> of cache ping pong between CPUs due to the spinlock for example, for
> every function this is clearly unacceptable (it would be twice per
> function with the function graph tracer).
> 
> And still there are also all the things with the hashlist deref, the checks,
> etc...
> 
> It's not only the function tracers. The lock events will also show you very
> bad results. Same if you enable all the others together.

My first thought when reading this was to make the saved_cmdlines and
related data per CPU to reduce a lot of the cache ping pong, but I'm
happy to take the alternate approach you suggest.

> Better have a new call to tracing_record_cmdline() made from the fork
> and exec tracepoints to solve this problem.
> But still, that only solves the lazy update and not all the problems
> you've listed in this changelog.

Still, it would scratch my itch so I'm happy to take that approach.

> In fact cmdline tracking would grow in complexity in the kernel if we had
> to make it correctly. Ideally:
> 
> * dump every tasks when we start tracing, and map their cmdlines
> * do the pid mapping per time interval. Keys in the hlist must be
>   pid/start_time:end_time, not only pid anymore.
> * map new cmdlines from fork and exec events. If exec, we must open
>   a new entry for our pid, closing noting end_time of this previous
>   pid entry and open a new start_time for the new entry.
> 
> 
> And this would be way much more efficient than the sched_switch based
> thing we have. More efficient in terms of performance and per timeslice
> granularity.
> 
> That's the kind of thing we'd better do from userspace, for tools like
> perf tools or trace-cmd. And perf tools do, partially (no time
> granularity yet).

I'd tend to agree, I find the in-kernel stuff most useful for watching
events on a live system. My itch was that I couldn't simply grep
trace_pipe for a command that I was about to run and reliably see all
it's events.

> But still, in-kernel made cmdline resolution is cool to have on
> some circumstances, especially on ascii tracing and dump. But
> for that I think we should just don't care further and keep this
> basic and non-perfect cmdline tracking, sufficient for most uses.
> 
> In fact we could fix it by dumping the tasks comm from tasklist
> and hook on the fork and exec events, rather than sched switch.
> It would be better for performances, and then appreciated.

I guess the compromise here would be that the saved_cmdlines buffer
would need to grow to hold all the command lines for every process that
has been running since the trace started - a limit of 128 commands as it
is now wouldn't cut it on most systems. Then again, there's no reason
not to bring back Li's patch to provide the option to disable recording
the command lines for people who don't want it.

Hmmm, I suppose we could hook into the process termination and check if
any events were associated with it and free up the entry if not...

Cheers,
-Ian
