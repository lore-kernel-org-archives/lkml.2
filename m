Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab0CZVvX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 17:51:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034Ab0CZVvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 17:51:21 -0400
Date: Fri, 26 Mar 2010 22:49:06 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Americo Wang <xiyou.wangcong@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       Spencer Candland <spencer@bluehost.com>,
       Stanislaw Gruszka <sgruszka@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC,PATCH 1/2] cputimers/proc: do_task_stat()->task_times()
	can race with getrusage()
Message-ID: <20100326214906.GA18467@redhat.com>
References: <20100324204550.GA31777@redhat.com> <20100326035344.GQ3308@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100326035344.GQ3308@balbir.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26, Balbir Singh wrote:
>
> * Oleg Nesterov <oleg@redhat.com> [2010-03-24 21:45:50]:
>
> > do_task_stat()->task_times() can race with getrusage(), they both can
> > try to update task->prev_Xtime at the same time.
> >
> > Remove this bit of d180c5bc "sched: Introduce task_times() to replace
> > task_{u,s}time()".
>
> One of the reasons for adding this accuracy was to avoid sampling
> based noise and errors that occur with utime and stime.
>
> As long as there is no preemption during the assignment, I think we
> should be OK.

I don't think preemp_disable() can help. Probably we can use task_lock().


As for do_task_stat()->thread_group_times(), I think we can make it
rc-safe without breaking /bin/top.

	1. add spin_lock_irqsave(&sig->cputimer.lock) around
	   sig->prev_Xtime = max(...)

	2. Add a couple of barriers into thread_group_cputime()
	   and __exit_signal() so that without ->siglock we can
	   never overestimate utime/stime if we race with exit.

	   If we underestimate these values, this should be fine:

	   - the error can't be "systematic", the next read from
	     /prod/pid/stat will see the updated values

	   - the prev_Xtime logic in thread_group_times() ensures
	     the reported time can never go back.

	   IOW: at worse, cat /proc/pid/stat can miss the time
	   which the exited thread spent on CPU after the previous
	   read of /proc/pid/stat. This looks absolutely harmless,
	   the next read will see this time.

	   Probably we can even detect this case if we look at
	   sig->nr_threads and retry.

I'll try to make patches unless someone has a better idea.

I just can't accept the fact that we are doing while_each_thread()
under ->siglock here ;)

Oleg.

