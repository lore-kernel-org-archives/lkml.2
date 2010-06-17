Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760660Ab0FQX4W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 19:56:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772Ab0FQX4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 19:56:21 -0400
Date: Thu, 17 Jun 2010 19:50:10 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Clark Williams <williams@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RESEND][PATCH v2] perf probe: add kernel source path option
Message-ID: <20100617225010.GB20602@ghostprotocols.net>
References: <1276543590-10486-1-git-send-email-chase.douglas@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276543590-10486-1-git-send-email-chase.douglas@canonical.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrected Masami-san address,

Em Mon, Jun 14, 2010 at 03:26:30PM -0400, Chase Douglas escreveu:
> The probe plugin requires access to the source code for some operations.
> The source code must be in the exact same location as specified by the
> DWARF tags, but sometimes the location is an absolute path that cannot
> be replicated by a normal user. This change adds the -s|--source option
> to allow the user to specify the root of the kernel source tree.
> 
> Signed-off-by: Chase Douglas <chase.douglas@canonical.com>

Just tested it, works as advertised:

[root@emilia mingo]# perf probe -L __schedule | head -22
Debuginfo analysis failed. (-2)
  Error: Failed to show lines. (-2)
[root@emilia mingo]# perf probe -s /usr/src/debug/kernel-rt-2.6.33.4-rt20.19.el5rt/linux-2.6.33.4.x86_64 -L __schedule | head -22
<__schedule:0>
      0  {
         	struct task_struct *prev, *next;
         	unsigned long *switch_count;
         	struct rq *rq;
         	int cpu;
         
      6  	cpu = smp_processor_id();
      7  	rq = cpu_rq(cpu);
      8  	rcu_sched_qs(cpu);
      9  	prev = rq->curr;
     10  	switch_count = &prev->nivcsw;
         
     12  	release_kernel_lock(prev);
         
         	schedule_debug(prev);
         
     16  	preempt_disable();
         
     18  	if (sched_feat(HRTICK))
     19  		hrtick_clear(rq);
         
[root@emilia mingo]# cat /sys/kernel/debug/sched_features
FAIR_SLEEPERS GENTLE_FAIR_SLEEPERS NO_NORMALIZED_SLEEPER START_DEBIT WAKEUP_PREEMPT ADAPTIVE_GRAN ASYM_GRAN NO_WAKEUP_SYNC NO_WAKEUP_OVERLAP SYNC_WAKEUPS AFFINE_WAKEUPS SYNC_LESS NO_SYNC_MORE NO_NEXT_BUDDY LAST_BUDDY CACHE_HOT_BUDDY NO_ARCH_POWER NO_HRTICK NO_DOUBLE_TICK LB_BIAS LB_SHARES_UPDATE ASYM_EFF_LOAD OWNER_SPIN 
[root@emilia mingo]# perf probe __schedule:19
Add new event:
  probe:__schedule     (on __schedule:19)

You can now use it on all perf tools, such as:

	perf record -e probe:__schedule -aR sleep 1

[root@emilia mingo]# perf record -e probe:__schedule -aR sleep 1
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.061 MB perf.data (~2684 samples) ]
[root@emilia mingo]# perf report | head -15
#
# (For a higher level overview, try: perf report --sort comm,dso)
#
[root@emilia mingo]# echo HRTICK > /sys/kernel/debug/sched_features
[root@emilia mingo]# cat /sys/kernel/debug/sched_features
FAIR_SLEEPERS GENTLE_FAIR_SLEEPERS NO_NORMALIZED_SLEEPER START_DEBIT WAKEUP_PREEMPT ADAPTIVE_GRAN ASYM_GRAN NO_WAKEUP_SYNC NO_WAKEUP_OVERLAP SYNC_WAKEUPS AFFINE_WAKEUPS SYNC_LESS NO_SYNC_MORE NO_NEXT_BUDDY LAST_BUDDY CACHE_HOT_BUDDY NO_ARCH_POWER HRTICK NO_DOUBLE_TICK LB_BIAS LB_SHARES_UPDATE ASYM_EFF_LOAD OWNER_SPIN 
[root@emilia mingo]# perf record -e probe:__schedule -aR sleep 1
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 1.528 MB perf.data (~66766 samples) ]
[root@emilia mingo]# perf report | head -15
# Events: 19K cycles
#
# Overhead          Command       Shared Object  Symbol
# ........  ...............  ..................  ......
#
    38.42%             init                   0  [k] 0000000000000000
     5.42%     sirq-timer/0  [kernel.kallsyms]   [k] kernel_thread_helper
     5.41%     sirq-timer/5  [kernel.kallsyms]   [k] kernel_thread_helper
     5.41%     sirq-timer/4  [kernel.kallsyms]   [k] kernel_thread_helper
     5.41%     sirq-timer/3  [kernel.kallsyms]   [k] kernel_thread_helper
     5.41%     sirq-timer/2  [kernel.kallsyms]   [k] kernel_thread_helper
     5.41%     sirq-timer/1  [kernel.kallsyms]   [k] kernel_thread_helper
     5.40%     sirq-timer/7  [kernel.kallsyms]   [k] kernel_thread_helper
     5.40%     sirq-timer/6  [kernel.kallsyms]   [k] kernel_thread_helper
     5.26%          swapper                   0  [k] 0000000000000000
[root@emilia mingo]#

Really cool stuff, thanks for your patch and to Masami for his amazing work on
'perf probe'.

I think we should look at usual places like debuginfo packages and
/usr/src/linux-`uname`, ~/git/linux-2.6/, etc, but that is something for a
follow on patch.

Best Regards,

- Arnaldo
