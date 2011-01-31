Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695Ab1AaLsN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 06:48:13 -0500
Received: from casper.infradead.org ([85.118.1.10]:48088 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631Ab1AaLsM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 06:48:12 -0500
Subject: Re: [RFC -v7 PATCH 4/7] Add yield_to(task, preempt) functionality.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rik van Riel <riel@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>,
        ttracy@redhat.com, "Nakajima, Jun" <jun.nakajima@intel.com>
In-Reply-To: <20110126172148.32d07561@annuminas.surriel.com>
References: <20110126165657.2ddd2ac9@annuminas.surriel.com>
	 <20110126172148.32d07561@annuminas.surriel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 31 Jan 2011 12:49:02 +0100
Message-ID: <1296474542.15234.394.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-26 at 17:21 -0500, Rik van Riel wrote:
> +bool __sched yield_to(struct task_struct *p, bool preempt)
> +{
> +       struct task_struct *curr = current;
> +       struct rq *rq, *p_rq;
> +       unsigned long flags;
> +       bool yielded = 0;
> +
> +       local_irq_save(flags);
> +       rq = this_rq();
> +
> +again:
> +       p_rq = task_rq(p);
> +       double_rq_lock(rq, p_rq);
> +       while (task_rq(p) != p_rq) {
> +               double_rq_unlock(rq, p_rq);
> +               goto again;
> +       }
> +
> +       if (!curr->sched_class->yield_to_task)
> +               goto out;
> +
> +       if (curr->sched_class != p->sched_class)
> +               goto out;
> +
> +       if (task_running(p_rq, p) || p->state)
> +               goto out;
> +
> +       yielded = curr->sched_class->yield_to_task(rq, p, preempt);
> +
> +out:
> +       double_rq_unlock(rq, p_rq);
> +       local_irq_restore(flags);
> +
> +       if (yielded)
> +               yield();
> +
> +       return yielded;
> +}
> +EXPORT_SYMBOL_GPL(yield_to); 

yield() will again acquire rq->lock.. not not simply have
->yield_to_task() do everything required and make that an unconditional
schedule()?
