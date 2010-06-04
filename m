Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab0FDL6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 07:58:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35871 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866Ab0FDL6Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 07:58:16 -0400
Subject: Re: [PATCH UPDATED 2/4] sched: adjust when cpu_active and cpuset
 configurations are updated during cpu on/offlining
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       paulus@samba.org, acme@redhat.com, Paul Menage <menage@google.com>
In-Reply-To: <4C0680DB.9010503@kernel.org>
References: <1275332199-28082-1-git-send-email-tj@kernel.org>
	 <1275332199-28082-3-git-send-email-tj@kernel.org>
	 <1275407846.27810.27627.camel@twins>  <4C053C39.9070405@kernel.org>
	 <1275412835.27810.27887.camel@twins>  <4C0680DB.9010503@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 04 Jun 2010 13:58:21 +0200
Message-ID: <1275652701.27810.39745.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-02 at 18:03 +0200, Tejun Heo wrote:
> Currently, when a cpu goes down, cpu_active is cleared before
> CPU_DOWN_PREPARE starts and cpuset configuration is updated from a
> default priority cpu notifier.  When a cpu is coming up, it's set
> before CPU_ONLINE but cpuset configuration again is updated from the
> same cpu notifier.
> 
> For cpu notifiers, this presents an inconsistent state.  Threads which
> a CPU_DOWN_PREPARE notifier expects to be bound to the CPU can be
> migrated to other cpus because the cpu is no more inactive.
> 
> Fix it by updating cpu_active in the highest priority cpu notifier and
> cpuset configuration in the second highest when a cpu is coming up.
> Down path is updated similarly.  This guarantees that all other cpu
> notifiers see consistent cpu_active and cpuset configuration.
> 
> cpuset_track_online_cpus() notifier is converted to
> cpuset_update_active_cpus() which just updates the configuration and
> now called from cpuset_cpu_[in]active() notifiers registered from
> sched_init_smp().  If cpuset is disabled, cpuset_update_active_cpus()
> degenerates into partition_sched_domains() making separate notifier
> for !CONFIG_CPUSETS unnecessary.
> 
> This problem is triggered by cmwq.  During CPU_DOWN_PREPARE, hotplug
> callback creates a kthread and kthread_bind()s it to the target cpu,
> and the thread is expected to run on that cpu.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Paul Menage <menage@google.com>
> ---
> Okay, how about this one?  Using notifiers seems better for the
> following reasons.
> 
> * Rollback on failure.
> 
> * cpuset/sched_domain don't expect to be called before smp
>   configuration is complete.  If hardcoded into cpu_up/down(),
>   condition checks need to be added so that they're skipped if the
>   system is bringing up the cpus for the first time.
> 
> Works fine here w/ CPUSET enabled and disabled.

OK, this looks good. 

Thanks Tejun.
