Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab2IFNd0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 09:33:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33973 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590Ab2IFNdZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 09:33:25 -0400
Message-ID: <1346938342.18408.3.camel@twins>
Subject: Re: [PATCH tip/core/rcu 01/23] rcu: Move RCU grace-period
 initialization into a kthread
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Date: Thu, 06 Sep 2012 15:32:22 +0200
In-Reply-To: <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120830181811.GA29154@linux.vnet.ibm.com>
	 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
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
> +       unsigned long flags;
> +       struct rcu_data *rdp;
> +       struct rcu_node *rnp;
> +       struct rcu_state *rsp = arg;
> +
> +       for (;;) {
> +
> +               /* Handle grace-period start. */
> +               rnp = rcu_get_root(rsp);
> +               for (;;) {
> +                       wait_event_interruptible(rsp->gp_wq, rsp->gp_flags);
> +                       if (rsp->gp_flags)
> +                               break;
> +                       flush_signals(current);
> +               }
> +               raw_spin_lock_irqsave(&rnp->lock, flags); 

You're in a kthread, it should be impossible for IRQs to be disabled
here, no? Similar for most (all) other sites in this function.

Using the unconditional IRQ disable/enable is generally faster.
