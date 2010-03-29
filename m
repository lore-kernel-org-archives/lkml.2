Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410Ab0C2MTp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 08:19:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241Ab0C2MTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 08:19:43 -0400
Date: Mon, 29 Mar 2010 13:17:32 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Americo Wang <xiyou.wangcong@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       Spencer Candland <spencer@bluehost.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC,PATCH 1/2] cputimers/proc: do_task_stat()->task_times()
	can race with getrusage()
Message-ID: <20100329111731.GA4488@dhcp-lab-161.englab.brq.redhat.com>
References: <20100324204550.GA31777@redhat.com> <20100326035344.GQ3308@balbir.in.ibm.com> <20100326214906.GA18467@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100326214906.GA18467@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 10:49:06PM +0100, Oleg Nesterov wrote:
> As for do_task_stat()->thread_group_times(), I think we can make it
> rc-safe without breaking /bin/top.
> 
> 	1. add spin_lock_irqsave(&sig->cputimer.lock) around
> 	   sig->prev_Xtime = max(...)
The easiest way to avoid that races is move all calls to task_times()
and thread_group_times() inside ->siglock, but that's a bit crappy.

There is also another impossible race here. On 32-bit machines
reading/writing sum_exec_runtime is not atomic, IIRC ->siglock
protect about that as well.

> 	2. Add a couple of barriers into thread_group_cputime()
> 	   and __exit_signal() so that without ->siglock we can
> 	   never overestimate utime/stime if we race with exit.
> 
> 	   If we underestimate these values, this should be fine:
> 
> 	   - the error can't be "systematic", the next read from
> 	     /prod/pid/stat will see the updated values
> 
> 	   - the prev_Xtime logic in thread_group_times() ensures
> 	     the reported time can never go back.
> 
> 	   IOW: at worse, cat /proc/pid/stat can miss the time
> 	   which the exited thread spent on CPU after the previous
> 	   read of /proc/pid/stat. This looks absolutely harmless,
> 	   the next read will see this time.
> 
> 	   Probably we can even detect this case if we look at
> 	   sig->nr_threads and retry.
Races with __exit_signal() can lead to count Xtime values twice,
first: in tsk->Xtime, second: after task exits, in sig->Xtime. As now
we have sig->prev_Xtime, this no longer can break times monotonic,
but still accounting times twice can be problematic. For example let
assume, we have many threads and one, which consume 90% cpu-time of
the process, exits and is accounted twice. Then for long period
sig->prev_Xtime will show value that is much bigger than the estimated
value should be.

> I'll try to make patches unless someone has a better idea.
> 
> I just can't accept the fact that we are doing while_each_thread()
> under ->siglock here ;)
Problem is not only in do_task_stat(). We have couple other places
where we iterate over all threads with ->siglock taken. Maybe we can somehow
redesign things to avoid that. Maybe increase tsk>-signal->Xtime together
with tsk->Xtime is not so bad idea. I'm going to think about that.

Stanislaw
