Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030432Ab2CFLwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 06:52:49 -0500
Received: from casper.infradead.org ([85.118.1.10]:40872 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030394Ab2CFLws convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 06:52:48 -0500
Message-ID: <1331034734.11248.287.camel@twins>
Subject: Re: [RFC PATCH 5/6] implement per-cpu&per-domain state machine
 call_srcu()
From: Peter Zijlstra <peterz@infradead.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, fweisbec@gmail.com,
        patches@linaro.org
Date: Tue, 06 Mar 2012 12:52:14 +0100
In-Reply-To: <1331027858-7648-5-git-send-email-laijs@cn.fujitsu.com>
References: <1331023359-6987-1-git-send-email-laijs@cn.fujitsu.com>
	 <1331027858-7648-1-git-send-email-laijs@cn.fujitsu.com>
	 <1331027858-7648-5-git-send-email-laijs@cn.fujitsu.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-06 at 17:57 +0800, Lai Jiangshan wrote:
> +void srcu_barrier(struct srcu_struct *sp)
> +{
> +       struct srcu_sync sync;
> +       struct srcu_head *head = &sync.head;
> +       unsigned long chck_seq; /* snap */
> +
> +       int idle_loop = 0;
> +       int cpu;
> +       struct srcu_cpu_struct *scp;
> +
> +       spin_lock_irq(&sp->gp_lock);
> +       chck_seq = sp->chck_seq;
> +       for_each_possible_cpu(cpu) {

ARGH!! this is really not ok.. so we spend all this time killing
srcu_sync_expidited and co because they prod at all cpus for no good
reason, and what do you do?

Also, what happens if your cpu isn't actually online?


> +               scp = per_cpu_ptr(sp->srcu_per_cpu, cpu);
> +               if (scp->head && !safe_less_than(chck_seq, scp->head->chck_seq,
> +                               sp->chck_seq)) {
> +                       /* this path is likely enterred only once */
> +                       init_completion(&sync.completion);
> +                       srcu_queue_callback(sp, scp, head,
> +                                       __synchronize_srcu_callback);
> +                       /* don't need to wakeup the woken state machine */
> +                       spin_unlock_irq(&sp->gp_lock);
> +                       wait_for_completion(&sync.completion);
> +                       spin_lock_irq(&sp->gp_lock);
> +               } else {
> +                       if ((++idle_loop & 0xF) == 0) {
> +                               spin_unlock_irq(&sp->gp_lock);
> +                               udelay(1);
> +                               spin_lock_irq(&sp->gp_lock);
> +                       }

The purpose of this bit isn't quite clear to me, is this simply a lock
break?

> +               }
> +       }
> +       spin_unlock_irq(&sp->gp_lock);
> +
> +       flush_workqueue(srcu_callback_wq);

Since you already waited for the completions one by one, what's the
purpose of this?

> +}
> +EXPORT_SYMBOL_GPL(srcu_barrier); 
