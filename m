Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935653Ab2JaOKJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 10:10:09 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:41755 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935517Ab2JaOKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 10:10:05 -0400
MIME-Version: 1.0
In-Reply-To: <1351655191-2648-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20121031034552.GA1999@linux.vnet.ibm.com>
	<1351655191-2648-1-git-send-email-paulmck@linux.vnet.ibm.com>
Date: Wed, 31 Oct 2012 15:10:04 +0100
Message-ID: <CAFTL4hwv6xTiMYMe7ZpYk1bkDVJiwk-DQAm1tRXDFD2OyO_W=A@mail.gmail.com>
Subject: Re: [PATCH tip/core/rcu 1/2] rcu: Add callback-free CPUs
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, sbw@mit.edu, patches@linaro.org, joe.korty@ccur.com,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/31 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> +/*
> + * Per-rcu_data kthread, but only for no-CBs CPUs.  Each kthread invokes
> + * callbacks queued by the corresponding no-CBs CPU.
> + */
> +static int rcu_nocb_kthread(void *arg)
> +{
> +       int c, cl;
> +       struct rcu_head *list;
> +       struct rcu_head *next;
> +       struct rcu_head **tail;
> +       struct rcu_data *rdp = arg;
> +
> +       /* Each pass through this loop invokes one batch of callbacks */
> +       for (;;) {
> +               /* If not polling, wait for next batch of callbacks. */
> +               if (!rcu_nocb_poll)
> +                       wait_event(rdp->nocb_wq, rdp->nocb_head);
> +               list = ACCESS_ONCE(rdp->nocb_head);
> +               if (!list) {
> +                       schedule_timeout_interruptible(1);
> +                       continue;
> +               }
> +
> +               /*
> +                * Extract queued callbacks, update counts, and wait
> +                * for a grace period to elapse.
> +                */
> +               ACCESS_ONCE(rdp->nocb_head) = NULL;
> +               tail = xchg(&rdp->nocb_tail, &rdp->nocb_head);
> +               c = atomic_long_xchg(&rdp->nocb_q_count, 0);
> +               cl = atomic_long_xchg(&rdp->nocb_q_count_lazy, 0);
> +               ACCESS_ONCE(rdp->nocb_p_count) += c;
> +               ACCESS_ONCE(rdp->nocb_p_count_lazy) += cl;
> +               wait_rcu_gp(rdp->rsp->call_remote);
> +
> +               /* Each pass through the following loop invokes a callback. */
> +               trace_rcu_batch_start(rdp->rsp->name, cl, c, -1);
> +               c = cl = 0;
> +               while (list) {
> +                       next = list->next;
> +                       /* Wait for enqueuing to complete, if needed. */
> +                       while (next == NULL && &list->next != tail) {
> +                               schedule_timeout_interruptible(1);
> +                               next = list->next;
> +                       }
> +                       debug_rcu_head_unqueue(list);
> +                       local_bh_disable();
> +                       if (__rcu_reclaim(rdp->rsp->name, list))
> +                               cl++;
> +                       c++;
> +                       local_bh_enable();
> +                       list = next;
> +               }
> +               trace_rcu_batch_end(rdp->rsp->name, c, !!list, 0, 0, 1);
> +               ACCESS_ONCE(rdp->nocb_p_count) -= c;
> +               ACCESS_ONCE(rdp->nocb_p_count_lazy) -= cl;
> +               rdp->n_cbs_invoked += c;
> +       }
> +       return 0;
> +}
> +
> +/* Initialize per-rcu_data variables for no-CBs CPUs. */
> +static void __init rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp)
> +{
> +       rdp->nocb_tail = &rdp->nocb_head;
> +       init_waitqueue_head(&rdp->nocb_wq);
> +}
> +
> +/* Create a kthread for each RCU flavor for each no-CBs CPU. */
> +static void __init rcu_spawn_nocb_kthreads(struct rcu_state *rsp)
> +{
> +       int cpu;
> +       struct rcu_data *rdp;
> +       struct task_struct *t;
> +
> +       if (rcu_nocb_mask == NULL)
> +               return;
> +       for_each_cpu(cpu, rcu_nocb_mask) {
> +               rdp = per_cpu_ptr(rsp->rda, cpu);
> +               t = kthread_run(rcu_nocb_kthread, rdp, "rcuo%d", cpu);

Sorry, I think I left my brain in the middle of the diff. But there is
something I'm misunderstanding I think. Here you're creating an
rcu_nocb_kthread per nocb cpu. Looking at the code of
rcu_nocb_kthread(), it seems to execute the callbacks with
__rcu_reclaim().

So, in the end, no callbacks CPU execute their callbacks. Isn't it the
opposite than what is expected? (again, just referring to my
misunderstanding).

Thanks.

> +               BUG_ON(IS_ERR(t));
> +               ACCESS_ONCE(rdp->nocb_kthread) = t;
> +       }
> +}
