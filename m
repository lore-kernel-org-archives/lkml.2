Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab2IFNmF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 09:42:05 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40417 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab2IFNmD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 09:42:03 -0400
Message-ID: <1346938791.18408.7.camel@twins>
Subject: Re: [PATCH tip/core/rcu 06/23] rcu: Break up rcu_gp_kthread() into
 subfunctions
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Date: Thu, 06 Sep 2012 15:39:51 +0200
In-Reply-To: <1346350718-30937-6-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120830181811.GA29154@linux.vnet.ibm.com>
	 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1346350718-30937-6-git-send-email-paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-30 at 11:18 -0700, Paul E. McKenney wrote:
> +static int rcu_gp_kthread(void *arg)
> +{
> +       struct rcu_state *rsp = arg;
> +       struct rcu_node *rnp = rcu_get_root(rsp);
> +
> +       for (;;) {
> +
> +               /* Handle grace-period start. */
> +               for (;;) {
> +                       wait_event_interruptible(rsp->gp_wq, rsp->gp_flags);
> +                       if (rsp->gp_flags && rcu_gp_init(rsp))
> +                               break;
> +                       cond_resched();
> +                       flush_signals(current);
> +               }
>  
>                 /* Handle grace-period end. */
>                 for (;;) {
>                         wait_event_interruptible(rsp->gp_wq,
>                                                  !ACCESS_ONCE(rnp->qsmask) &&
>                                                  !rcu_preempt_blocked_readers_cgp(rnp));
>                         if (!ACCESS_ONCE(rnp->qsmask) &&
> +                           !rcu_preempt_blocked_readers_cgp(rnp) &&
> +                           rcu_gp_cleanup(rsp))
>                                 break;
> +                       cond_resched();
>                         flush_signals(current);
>                 }
>         }
>         return 0;
>  } 

Should there not be a kthread_stop() / kthread_park() call somewhere in
there?

Also, it could be me, but all those nested for (;;) loops make the flow
rather non-obvious.
