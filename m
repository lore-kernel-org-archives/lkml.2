Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190Ab2EVCmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 22:42:17 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36118 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755379Ab2EVCmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 22:42:16 -0400
Date: Mon, 21 May 2012 19:42:13 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@kernel.org>
cc: hpa@zytor.com, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, pjt@google.com, cl@linux.com,
        riel@redhat.com, bharata.rao@gmail.com, akpm@linux-foundation.org,
        Lee.Schermerhorn@hp.com, aarcange@redhat.com, danms@us.ibm.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/numa] sched/numa: Introduce sys_numa_{t,m}bind()
In-Reply-To: <alpine.DEB.2.00.1205211914100.13682@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1205211932350.13682@chino.kir.corp.google.com>
References: <tip-nf7brf1b88w0ojwuf689xeet@git.kernel.org> <alpine.DEB.2.00.1205191922250.24674@chino.kir.corp.google.com> <20120521084046.GB31407@gmail.com> <alpine.DEB.2.00.1205211914100.13682@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2012, David Rientjes wrote:

> [    0.602181] divide error: 0000 [#1] SMP 
> [    0.606159] CPU 0 
> [    0.608003] Modules linked in:
> [    0.611266] 
> [    0.612767] Pid: 1, comm: swapper/0 Not tainted 3.4.0 #1
> [    0.620912] RIP: 0010:[<ffffffff810af9ab>]  [<ffffffff810af9ab>] update_sd_lb_stats+0x38b/0x740

This is 

4ec4412e kernel/sched/fair.c 3876)      if (local_group) {
bd939f45 kernel/sched/fair.c 3877)              if (env->idle != CPU_NEWLY_IDLE) {
04f733b4 kernel/sched/fair.c 3878)                      if (balance_cpu != env->dst_cpu) {
4ec4412e kernel/sched/fair.c 3879)                              *balance = 0;
4ec4412e kernel/sched/fair.c 3880)                              return;
4ec4412e kernel/sched/fair.c 3881)                      }
bd939f45 kernel/sched/fair.c 3882)                      update_group_power(env->sd, env->dst_cpu);
4ec4412e kernel/sched/fair.c 3883)              } else if (time_after_eq(jiffies, group->sgp->next_update))
bd939f45 kernel/sched/fair.c 3884)                      update_group_power(env->sd, env->dst_cpu);
1e3c88bd kernel/sched_fair.c 3885)      }
1e3c88bd kernel/sched_fair.c 3886) 
1e3c88bd kernel/sched_fair.c 3887)      /* Adjust by relative CPU power of the group */
9c3f75cb kernel/sched_fair.c 3888)      sgs->avg_load = (sgs->group_load*SCHED_POWER_SCALE) / group->sgp->power;

the divide of group->sgp->power.  This doesn't happen when reverting back 
to sched/urgent at 30b4e9eb783d ("sched: Fix KVM and ia64 boot crash due 
to sched_groups circular linked list assumption").  Let me know if you'd 
like a bisect if the problem isn't immediately obvious.
