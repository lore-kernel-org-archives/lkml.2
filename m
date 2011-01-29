Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab1A2AW2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 19:22:28 -0500
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:39788
	"EHLO AM1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754133Ab1A2AW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 19:22:27 -0500
X-SpamScore: -20
X-BigFish: VPS-20(zz14e0Mbb2dK1432N98dNzz1202hzzz2fh2a8h637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4D435DA6.70208@am.sony.com>
Date: Fri, 28 Jan 2011 16:21:58 -0800
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 11/18] sched: Add p->pi_lock to task_rq_lock()
References: <20110104145929.772813816@chello.nl> <20110104150102.862431889@chello.nl>
In-Reply-To: <20110104150102.862431889@chello.nl>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/11 06:59, Peter Zijlstra wrote:
> In order to be able to call set_task_cpu() while either holding
> p->pi_lock or task_rq(p)->lock we need to hold both locks in order to
> stabilize task_rq().
> 
> This makes task_rq_lock() acquire both locks, and have
> __task_rq_lock() validate that p->pi_lock is held. This increases the
> locking overhead for most scheduler syscalls but allows reduction of
> rq->lock contention for some scheduler hot paths (ttwu).
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/sched.c |   81 ++++++++++++++++++++++++++-------------------------------
>  1 file changed, 37 insertions(+), 44 deletions(-)
> 
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> 

> @@ -980,10 +972,13 @@ static void __task_rq_unlock(struct rq *
>  	raw_spin_unlock(&rq->lock);
>  }
>  
> -static inline void task_rq_unlock(struct rq *rq, unsigned long *flags)
> +static inline void
> +task_rq_unlock(struct rq *rq, struct task_struct *p, unsigned long *flags)
>  	__releases(rq->lock)
> +	__releases(p->pi_lock)
>  {
> -	raw_spin_unlock_irqrestore(&rq->lock, *flags);
> +	raw_spin_unlock(&rq->lock);
> +	raw_spin_unlock_irqrestore(&p->pi_lock, *flags);
>  }
>  
>  /*

Most of the callers of task_rq_unlock() were also fixed up to reflect
the newly added parameter "*p", but a couple were missed.  By the end
of the patch series that is ok because the couple that were missed
get removed in patches 12 and 13.  But if you want the patch series
to be bisectable (which I think it is otherwise), you might want to
fix those last couple of callers of task_rq_unlock() in this patch.


> @@ -2646,9 +2647,9 @@ void sched_fork(struct task_struct *p, i
>          *
>          * Silence PROVE_RCU.
>          */
> -       rcu_read_lock();
> +       raw_spin_lock_irqsave(&p->pi_lock, flags);
>         set_task_cpu(p, cpu);
> -       rcu_read_unlock();
> +       raw_spin_unlock_irqrestore(&p->pi_lock, flags);

Does "* Silence PROVE_RCU." no longer apply after remove rcu_read_lock() and
rcu_read_unlock()?

-Frank

