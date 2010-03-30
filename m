Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302Ab0C3M7o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 08:59:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756145Ab0C3M7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 08:59:43 -0400
Date: Tue, 30 Mar 2010 13:01:24 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Americo Wang <xiyou.wangcong@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       Spencer Candland <spencer@bluehost.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 2/4] cputimers: make sure thread_group_cputime()
	can't count the same thread twice lockless
Message-ID: <20100330110124.GA2566@dhcp-lab-161.englab.brq.redhat.com>
References: <20100324204550.GA31777@redhat.com> <20100326035344.GQ3308@balbir.in.ibm.com> <20100326214906.GA18467@redhat.com> <20100329111731.GA4488@dhcp-lab-161.englab.brq.redhat.com> <20100329125415.GA22451@redhat.com> <20100329181204.GA16356@redhat.com> <20100329181329.GC16356@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100329181329.GC16356@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 08:13:29PM +0200, Oleg Nesterov wrote:
> - change __exit_signal() to do __unhash_process() before we accumulate
>   the counters in ->signal
> 
> - add a couple of barriers into thread_group_cputime() and __exit_signal()
>   to make sure thread_group_cputime() can never account the same thread
>   twice if it races with exit.
>
>   If any thread T was already accounted in ->signal, next_thread() or
>   pid_alive() must see the result of __unhash_process(T).

Memory barriers prevents to account times twice, but as we write
sig->{u,s}time and sig->sum_sched_runtime on one cpu and read them
on another cpu, without a lock, this patch make theoretically possible
that some accumulated values of struct task_cputime may include exited
task values and some not. In example times->utime will include values
from 10 threads, and times->{stime,sum_exec_runtime} values form 9
threads, because local cpu updates sig->utime but not two other values.
This can make scaling in thread_group_times() not correct. I'm not sure
how big drawback is that.

Stanislaw
