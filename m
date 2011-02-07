Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab1BGJI1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 04:08:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753143Ab1BGJIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 04:08:24 -0500
Message-ID: <4D4FB678.7030701@redhat.com>
Date: Mon, 07 Feb 2011 11:08:08 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>
Subject: Re: [PATCH -v8a 0/7] directed yield for Pause Loop Exiting
References: <20110201094433.72829892@annuminas.surriel.com>
In-Reply-To: <20110201094433.72829892@annuminas.surriel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2011 04:44 PM, Rik van Riel wrote:
> When running SMP virtual machines, it is possible for one VCPU to be
> spinning on a spinlock, while the VCPU that holds the spinlock is not
> currently running, because the host scheduler preempted it to run
> something else.
>
> Both Intel and AMD CPUs have a feature that detects when a virtual
> CPU is spinning on a lock and will trap to the host.
>
> The current KVM code sleeps for a bit whenever that happens, which
> results in eg. a 64 VCPU Windows guest taking forever and a bit to
> boot up.  This is because the VCPU holding the lock is actually
> running and not sleeping, so the pause is counter-productive.
>
> In other workloads a pause can also be counter-productive, with
> spinlock detection resulting in one guest giving up its CPU time
> to the others.  Instead of spinning, it ends up simply not running
> much at all.
>
> This patch series aims to fix that, by having a VCPU that spins
> give the remainder of its timeslice to another VCPU in the same
> guest before yielding the CPU - one that is runnable but got
> preempted, hopefully the lock holder.
>
> v8:
> - some more changes and cleanups suggested by Peter
> v7:
> - move the vcpu to pid mapping to inside the vcpu->mutex
> - rename ->yield to ->skip
> - merge patch 5 into patch 4
> v6:
> - implement yield_task_fair in a way that works with task groups,
>    this allows me to actually get a performance improvement!
> - fix another race Avi pointed out, the code should be good now
> v5:
> - fix the race condition Avi pointed out, by tracking vcpu->pid
> - also allows us to yield to vcpu tasks that got preempted while in qemu
>    userspace
> v4:
> - change to newer version of Mike Galbraith's yield_to implementation
> - chainsaw out some code from Mike that looked like a great idea, but
>    turned out to give weird interactions in practice
> v3:
> - more cleanups
> - change to Mike Galbraith's yield_to implementation
> - yield to spinning VCPUs, this seems to work better in some
>    situations and has little downside potential
> v2:
> - make lots of cleanups and improvements suggested
> - do not implement timeslice scheduling or fairness stuff
>    yet, since it is not entirely clear how to do that right
>    (suggestions welcome)
>
>
> Benchmark results:
>
> Two 4-CPU KVM guests are pinned to the same 4 physical CPUs.
>
> One guest runs the AMQP performance test, the other guest runs
> 0, 2 or 4 infinite loops, for CPU overcommit factors of 0, 1.5
> and 4.
>
> The AMQP perftest is run 30 times, with message payloads of 8 and 16 bytes.
>
> size8	no overcommit	1.5x overcommit		2x overcommit
>
> no PLE	223801		135137			104951
> PLE	224135		141105			118744
>
> size16	no overcommit	1.5x overcommit		2x overcommit
>
> no PLE	222424		126175			105299
> PLE	222534		138082			132945
>
> Note: this is with the KVM guests NOT running inside cgroups.  There
> seems to be a CPU load balancing issue with cgroup fair group scheduling,
> which often results in one guest getting only 80% CPU time and the other
> guest 320%.  That will have to be fixed to get meaningful results with
> cgroups.
>
> CPU time division between the AMQP guest and the infinite loop guest
> were not exactly fair, but the guests got close to the same amount
> of CPU time in each test run.
>
> There is a substantial amount of randomness in CPU time division between
> guests, but the performance improvement is consistent between multiple
> runs.
>

I've merged tip's sched/core, which includes yield_to(), and applied the 
final three patches.  Thanks.

-- 
error compiling committee.c: too many arguments to function

