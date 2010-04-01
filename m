Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab0DAJkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 05:40:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59560 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751209Ab0DAJka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 05:40:30 -0400
Message-ID: <4BB46977.9000903@cn.fujitsu.com>
Date: Thu, 01 Apr 2010 17:37:59 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched_wakeup_new and sched_kthread_stop events cause great overload
References: <4BAB2EAF.2030804@cn.fujitsu.com> <1269524133.2957.4067.camel@gandalf.stny.rr.com>
In-Reply-To: <1269524133.2957.4067.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

Sorry for the delay reply since i'm busy during this time.

Steven Rostedt wrote:

>> For sysbench.threads:
>> cat debugfs/tracing/trace | grep "sched_wakeup_new" | wc -l
>> 5001
>> cat debugfs/tracing/trace | grep "sched_kthread_stop" | wc -l
>> 0
> 
> Strange? So if you did:
> 
> cat debugfs/tracing/trace | wc -l
> 
> you should get 5005?
> 

Yes, other 4 lines are tracing message's header

>> For sysbench.mutex:
>> cat debugfs/tracing/trace | grep "sched_wakeup_new" | wc -l
>> 5001
>> cat debugfs/tracing/trace | grep "sched_kthread_stop" | wc -l
>> 0
>>
>> And, if only enable sched_kthread_stop event, the sysbench.threads's
>> overload is 5.90%, the sysbench.mutex's overload is 3.36%.
> 
> Could be something that messes with the cache lines?

We don't know the real reason, but we can keep fighting for this issue, once
we get useful information, we will sent to you.

> 
>> It hardly explain why sched_kthread_stop is never called but cause great overload.
> 
> Would be worth running perf against this test, to see where the issues
> are occurring.
> 

We've used 'perf' to tracing it:
perf record -e sched:sched_wakeup_new -e sched:sched_kthread_stop -f -i -a -c 1 sysbench --num-threads=5000 --max-requests=50000 --test=threads --thread-yields=1000 --thread-locks=10000 run

The output is:
# Samples: 5001
#
# Overhead          Command           Shared Object  Symbol
# ........  ...............  ......................  ......
#
    99.98%         sysbench  /lib64/libc-2.10.90.so  [.] clone
     0.02%  perf.2.6.31-38.  /lib64/libc-2.10.90.so  [.] fork
#
# (For a higher level overview, try: perf report --sort comm,dso)
#

The result shows that the most time is costed on clone and fork, and no path to
call sched_kthread_stop.

Xiao
