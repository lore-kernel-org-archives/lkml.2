Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab2K2JHB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 04:07:01 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:48864 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab2K2JG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 04:06:57 -0500
Message-ID: <1354179992.2499.35.camel@ThinkPad-T5421.cn.ibm.com>
Subject: Re: [PATCH] context_tracking: New context tracking susbsystem
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Gilad.Ben-Yossef.gilad@benyossef.com
Date: Thu, 29 Nov 2012 17:06:32 +0800
In-Reply-To: <1354041205-6989-1-git-send-email-fweisbec@gmail.com>
References: <1354041205-6989-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12112909-8256-0000-0000-0000053A9E1D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-11-27 at 19:33 +0100, Frederic Weisbecker wrote:
[....]
> -
> -	WARN_ON_ONCE(!current->mm);
> -
> -	local_irq_save(flags);
> -	rdtp = &__get_cpu_var(rcu_dynticks);
> -	if (!rdtp->ignore_user_qs && !rdtp->in_user) {
> -		rdtp->in_user = true;
> -		rcu_eqs_enter(true);
> -	}

It seems to me that ignore_user_qs and in_user defined in struct
rcu_dynticks are no longer needed? 

If so, then maybe we could remove them, code below:

==========
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index e441b77..b8fae5d 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -2719,9 +2719,6 @@ rcu_boot_init_percpu_data(int cpu, struct rcu_state *rsp)
 	rdp->dynticks = &per_cpu(rcu_dynticks, cpu);
 	WARN_ON_ONCE(rdp->dynticks->dynticks_nesting != DYNTICK_TASK_EXIT_IDLE);
 	WARN_ON_ONCE(atomic_read(&rdp->dynticks->dynticks) != 1);
-#ifdef CONFIG_RCU_USER_QS
-	WARN_ON_ONCE(rdp->dynticks->in_user);
-#endif
 	rdp->cpu = cpu;
 	rdp->rsp = rsp;
 	rcu_boot_init_nocb_percpu_data(rdp);
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 4b69291..6f21f2e 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -102,10 +102,6 @@ struct rcu_dynticks {
 				    /* idle-period nonlazy_posted snapshot. */
 	int tick_nohz_enabled_snap; /* Previously seen value from sysfs. */
 #endif /* #ifdef CONFIG_RCU_FAST_NO_HZ */
-#ifdef CONFIG_RCU_USER_QS
-	bool ignore_user_qs;	    /* Treat userspace as extended QS or not */
-	bool in_user;		    /* Is the CPU in userland from RCU POV? */
-#endif
 };
 
 /* RCU's kthread states for tracing. */


