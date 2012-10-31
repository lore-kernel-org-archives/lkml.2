Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481Ab2JaFh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 01:37:29 -0400
Received: from mail1.windriver.com ([147.11.146.13]:65322 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858Ab2JaFhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 01:37:25 -0400
Date: Wed, 31 Oct 2012 01:37:09 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.6.4-rt11
Message-ID: <20121031053708.GD25658@windriver.com>
References: <alpine.LFD.2.02.1210310144210.2756@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1210310144210.2756@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[[ANNOUNCE] 3.6.4-rt11] On 31/10/2012 (Wed 02:19) Thomas Gleixner wrote:

> Dear RT Folks,
> 
> I'm pleased to announce the 3.6.4-rt11 release.

The rt11 content is present on master in the 3.6-rt patch repo:
  http://git.kernel.org/?p=linux/kernel/git/paulg/3.6-rt-patches.git

I've also created a v3.6.4-rt11-fixes branch, which contains a fix for
the preempt-lazy TIF test on x86_32 (please check this; I really should
not be left unattended, mucking around in .S files while on vacation).
It is queued in the series right after the preempt-lazy-support.patch.

There is also a trivial fix to remove a needless whitespace change (also
appeared in preempt-lazy-support.patch) that triggers a git nag during
a "git am" of it.

Passes quick boot test on x86_32 UP (Note: I didn't try booting without
the TIF %cl patch; not sure what would have happened there...)

[ quick link to TIF patch @kernel.org: http://goo.gl/7Gbtg ]

Paul.
--

> 
> Changes since 3.6.3-rt10:
> 
>    * Crypto wreckage fix (Milan Broz)
> 
>      Another proof why copy and paste should be forbidden, but if that
>      would happen most of us would be serving time.
> 
>    * Another attempt to tame SLUB
> 
>      My previous approach turned out to be too naive though this one
>      has at least held up against massive memory stress tests. It's a
>      very simple and straight forward aproach now and while I'm quite
>      sure that it will not fall over as it did before, there might be
>      hidden latency issues with that new version.
> 
>       So please give it a proper testing!
> 
>    * Lazy preemption
> 
>      It has become an obsession to mitigate the determinism
>      vs. throughput loss of RT. Looking at the mainline semantics of
>      preemption points gives a hint why RT sucks throughput wise for
>      ordinary SCHED_OTHER tasks. One major issue is the wakeup of
>      tasks which are right away preempting the waking task while the
>      waking task holds a lock on which the woken task will block right
>      after having preempted the wakee. In mainline this is prevented
>      due to the implicit preemption disable of spin/rw_lock held
>      regions. On RT this is not possible due to the fully preemptible
>      nature of sleeping spinlocks.
> 
>      Though for a SCHED_OTHER task preempting another SCHED_OTHER task
>      this is really not a correctness issue. RT folks are concerned
>      about SCHED_FIFO/RR tasks preemption and not about the purely
>      fairness driven SCHED_OTHER preemption latencies.
> 
>      So I introduced a lazy preemption mechanism which only applies to
>      SCHED_OTHER tasks preempting another SCHED_OTHER task. Aside of
>      the existing preempt_count each tasks sports now a
>      preempt_lazy_count which is manipulated on lock acquiry and
>      release. This is slightly incorrect as for lazyness reasons I
>      coupled this on migrate_disable/enable so some other mechanisms
>      get the same treatment (e.g. get_cpu_light).
> 
>      Now on the scheduler side instead of setting NEED_RESCHED this
>      sets NEED_RESCHED_LAZY in case of a SCHED_OTHER/SCHED_OTHER
>      preemption and therefor allows to exit the waking task the lock
>      held region before the woken task preempts. That also works
>      better for cross CPU wakeups as the other side can stay in the
>      adaptive spinning loop.
> 
>      For RT class preemption there is no change. This simply sets
>      NEED_RESCHED and forgoes the lazy preemption counter.
> 
>      Initial test do not expose any observable latency increasement,
>      but history shows that I've been proven wrong before :)
> 
>      The lazy preemption mode is per default on, but with
>      CONFIG_SCHED_DEBUG enabled it can be disabled via:
> 
>      # echo NO_PREEMPT_LAZY >/sys/kernel/debug/sched_features
> 
>      and reenabled via
> 
>      # echo PREEMPT_LAZY >/sys/kernel/debug/sched_features
> 
>      The test results so far are very machine and workload dependent,
>      but there is a clear trend that it enhances the non RT workload
>      performance.
> 
>      Please give it a try and share your experience!
> 
> Known issues:
> 
>       There is still some "softirq pending xx" fallout which I have
>       not been able to investigate yet, but that's on my top priority
>       list. It's not a critical issue and only annoys people with
>       CONFIG_NO_HZ=y configurations.
>     
> 
> The delta patch against 3.6.4-rt10 is appended below and can be found
> here:
> 
>   http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/incr/patch-3.6.4-rt10-rt11.patch.xz
> 
> 
> The RT patch against 3.6.4 can be found here:
> 
>   http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/patch-3.6.4-rt11.patch.xz
> 
> The split quilt queue is available at:
> 
>   http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/patches-3.6.4-rt11.tar.xz
> 
> Enjoy,
> 
> 	tglx
> 
> ------------->
> 
