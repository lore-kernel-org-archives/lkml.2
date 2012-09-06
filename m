Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759113Ab2IFQyV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 12:54:21 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48476 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab2IFQyT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 12:54:19 -0400
Message-ID: <1346950364.18408.38.camel@twins>
Subject: Re: [PATCH tip/core/rcu 10/26] rcu: Exit RCU extended QS on kernel
 preemption after irq/exception
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Date: Thu, 06 Sep 2012 18:52:44 +0200
In-Reply-To: <1346360743-3628-10-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120830210520.GA2824@linux.vnet.ibm.com>
	 <1346360743-3628-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1346360743-3628-10-git-send-email-paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-30 at 14:05 -0700, Paul E. McKenney wrote:
> From: Frederic Weisbecker <fweisbec@gmail.com>
> 
> When an exception or an irq exits, and we are going to resume into
> interrupted kernel code, the low level architecture code calls
> preempt_schedule_irq() if there is a need to reschedule.
> 
> If the interrupt/exception occured between a call to rcu_user_enter()
> (from syscall exit, exception exit, do_notify_resume exit, ...) and
> a real resume to userspace (iret,...), preempt_schedule_irq() can be
> called whereas RCU thinks we are in userspace. But preempt_schedule_irq()
> is going to run kernel code and may be some RCU read side critical
> section. We must exit the userspace extended quiescent state before
> we call it.
> 
> To solve this, just call rcu_user_exit() in the beginning of
> preempt_schedule_irq().

> ---
>  kernel/sched/core.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 07c6d9a..0bd599b 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -3564,6 +3564,7 @@ asmlinkage void __sched preempt_schedule_irq(void)
>  	/* Catch callers which need to be fixed */
>  	BUG_ON(ti->preempt_count || !irqs_disabled());
>  
> +	rcu_user_exit();
>  	do {
>  		add_preempt_count(PREEMPT_ACTIVE);
>  		local_irq_enable();

But in this case you want to restart the tick as well, are we going to
add a nohz_user_exit() like call as well, or do we have something that
does both?
