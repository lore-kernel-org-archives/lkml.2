Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328Ab0C2M4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 08:56:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1584 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109Ab0C2M4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 08:56:19 -0400
Date: Mon, 29 Mar 2010 14:54:15 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
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
Message-ID: <20100329125415.GA22451@redhat.com>
References: <20100324204550.GA31777@redhat.com> <20100326035344.GQ3308@balbir.in.ibm.com> <20100326214906.GA18467@redhat.com> <20100329111731.GA4488@dhcp-lab-161.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100329111731.GA4488@dhcp-lab-161.englab.brq.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29, Stanislaw Gruszka wrote:
>
> On Fri, Mar 26, 2010 at 10:49:06PM +0100, Oleg Nesterov wrote:
> > As for do_task_stat()->thread_group_times(), I think we can make it
> > rc-safe without breaking /bin/top.
> >
> > 	1. add spin_lock_irqsave(&sig->cputimer.lock) around
> > 	   sig->prev_Xtime = max(...)
> The easiest way to avoid that races is move all calls to task_times()
> and thread_group_times() inside ->siglock, but that's a bit crappy.

Yes, and we should avoid overloading ->siglock if possible.

> There is also another impossible race here. On 32-bit machines
> reading/writing sum_exec_runtime is not atomic,

Sure,

> IIRC ->siglock
> protect about that as well.

I don't think so. update_curr/etc updates t->se.sum_exec_runtime without
->siglock, it can't help to read u64 values atomically.

> > 	2. Add a couple of barriers into thread_group_cputime()
> > 	   and __exit_signal() so that without ->siglock we can
> > 	   never overestimate utime/stime if we race with exit.
> > 
> > 	   If we underestimate these values, this should be fine:
> > 
> > 	   - the error can't be "systematic", the next read from
> > 	     /prod/pid/stat will see the updated values
> > 
> > 	   - the prev_Xtime logic in thread_group_times() ensures
> > 	     the reported time can never go back.
> > 
> > 	   IOW: at worse, cat /proc/pid/stat can miss the time
> > 	   which the exited thread spent on CPU after the previous
> > 	   read of /proc/pid/stat. This looks absolutely harmless,
> > 	   the next read will see this time.
> > 
> > 	   Probably we can even detect this case if we look at
> > 	   sig->nr_threads and retry.
> Races with __exit_signal() can lead to count Xtime values twice,
> first: in tsk->Xtime, second: after task exits, in sig->Xtime.

Please see above. This is what should be avoided.

> > I'll try to make patches unless someone has a better idea.
> >
> > I just can't accept the fact that we are doing while_each_thread()
> > under ->siglock here ;)
> Problem is not only in do_task_stat(). We have couple other places
> where we iterate over all threads with ->siglock taken.

Yes sure. I dislike the do_task_stat() case because we always do this,
even if this info is not needed, say, for /bin/ps.

Oleg.

