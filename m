Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613Ab1GTClU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 22:41:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:39796 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab1GTClT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 22:41:19 -0400
Subject: Re: [PATCH tip/core/urgent 1/7] rcu: decrease rcu_report_exp_rnp
 coupling with scheduler
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, greearb@candelatech.com, edt@aei.ca
In-Reply-To: <1311121103-16978-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20110720001738.GA16369@linux.vnet.ibm.com>
	 <1311121103-16978-1-git-send-email-paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 20 Jul 2011 04:40:18 +0200
Message-ID: <1311129618.5345.2.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-19 at 17:18 -0700, Paul E. McKenney wrote:
> +++ b/kernel/rcutree_plugin.h
> @@ -696,8 +696,10 @@ static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp)
>         raw_spin_lock_irqsave(&rnp->lock, flags);
>         for (;;) {
>                 if (!sync_rcu_preempt_exp_done(rnp))
> +                       raw_spin_unlock_irqrestore(&rnp->lock, flags);
>                         break;

I bet that'll all work much better if you wrap it in curly braces like:

		if (!sync_rcu_preempt_exp_done(rnp)) {
			raw_spin_unlock_irqrestore(&rnp->lock, flags);
			break;
		}

That might also explain those explosions Ed and Ben have been seeing.

>                 if (rnp->parent == NULL) {
> +                       raw_spin_unlock_irqrestore(&rnp->lock, flags);
>                         wake_up(&sync_rcu_preempt_exp_wq);
>                         break;
>                 }
> @@ -707,7 +709,6 @@ static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp)
>                 raw_spin_lock(&rnp->lock); /* irqs already disabled */
>                 rnp->expmask &= ~mask;
>         }
> -       raw_spin_unlock_irqrestore(&rnp->lock, flags);
>  } 
