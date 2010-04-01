Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141Ab0DAPyA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 11:54:00 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41811 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757108Ab0DAPxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 11:53:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KkPvxTlLkeEOpEOGbZv2iCBbhL4TWGbz7cOY0741R9RWrnQoQihK3O6QGxIQ0a2wwq
         5WNPtITbwmoSS8yk+jgfR0sx8riEKKx5LL8+3EYdINueMmzr3u+IrHh1UeRY7lAXCfQ4
         kEwDIpoEtoetBK9j06JpcwLg7/w6Bt/f1lO94=
Date: Thu, 1 Apr 2010 18:53:55 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: rostedt@goodmis.org, Ingo Molnar <mingo@elte.hu>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched_wakeup_new and sched_kthread_stop events cause great
	overload
Message-ID: <20100401165352.GB5153@nowhere>
References: <4BAB2EAF.2030804@cn.fujitsu.com> <1269524133.2957.4067.camel@gandalf.stny.rr.com> <4BB46977.9000903@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BB46977.9000903@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 05:37:59PM +0800, Xiao Guangrong wrote:
> Hi Steven,
> 
> Sorry for the delay reply since i'm busy during this time.
> 
> Steven Rostedt wrote:
> 
> >> For sysbench.threads:
> >> cat debugfs/tracing/trace | grep "sched_wakeup_new" | wc -l
> >> 5001
> >> cat debugfs/tracing/trace | grep "sched_kthread_stop" | wc -l
> >> 0
> > 
> > Strange? So if you did:
> > 
> > cat debugfs/tracing/trace | wc -l
> > 
> > you should get 5005?
> > 
> 
> Yes, other 4 lines are tracing message's header
> 
> >> For sysbench.mutex:
> >> cat debugfs/tracing/trace | grep "sched_wakeup_new" | wc -l
> >> 5001
> >> cat debugfs/tracing/trace | grep "sched_kthread_stop" | wc -l
> >> 0
> >>
> >> And, if only enable sched_kthread_stop event, the sysbench.threads's
> >> overload is 5.90%, the sysbench.mutex's overload is 3.36%.
> > 
> > Could be something that messes with the cache lines?
> 
> We don't know the real reason, but we can keep fighting for this issue, once
> we get useful information, we will sent to you.
> 
> > 
> >> It hardly explain why sched_kthread_stop is never called but cause great overload.
> > 
> > Would be worth running perf against this test, to see where the issues
> > are occurring.
> > 
> 
> We've used 'perf' to tracing it:
> perf record -e sched:sched_wakeup_new -e sched:sched_kthread_stop -f -i -a -c 1 sysbench --num-threads=5000 --max-requests=50000 --test=threads --thread-yields=1000 --thread-locks=10000 run


Do you mean you've noticed this overhead with perf only, not
with ftrace, right?



 
> The output is:
> # Samples: 5001
> #
> # Overhead          Command           Shared Object  Symbol
> # ........  ...............  ......................  ......
> #
>     99.98%         sysbench  /lib64/libc-2.10.90.so  [.] clone
>      0.02%  perf.2.6.31-38.  /lib64/libc-2.10.90.so  [.] fork
> #
> # (For a higher level overview, try: perf report --sort comm,dso)
> #
> 
> The result shows that the most time is costed on clone and fork, and no path to
> call sched_kthread_stop.


Could you please add the -g option to you perf record. It would be interesting
to see the callgraphs.
(Redirection to a pipe pass through the newt GUI so you can report the ascii
result).

In perf, even if an event doesn't generate much "events", various things
happen internally due to the fact we have active perf events, especially
on sched out/in and clone and fork.

On clone and fork, the events get inherited from the task parent. With a
high amount of task childs created, this may perfhaps raise an overhead.
But this is not supposed to be the case here because you are using the -a
option, which means the events are not inherited as they are per cpu.

