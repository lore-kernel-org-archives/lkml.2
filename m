Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab1DZLd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 07:33:27 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49479 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab1DZLd0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 07:33:26 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] cpumask: convert cpumask_of_cpu() with cpumask_of()
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1303814572.20212.249.camel@twins>
References: <20110425184245.2699.A69D9226@jp.fujitsu.com> <1303814572.20212.249.camel@twins>
Message-Id: <20110426203520.F3AE.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Tue, 26 Apr 2011 20:33:23 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 2011-04-25 at 18:41 +0900, KOSAKI Motohiro wrote:
> > This patch adapt the code to new api fashion. 
> > 
> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Mike Galbraith <efault@gmx.de>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > ---
> >  kernel/kthread.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/kernel/kthread.c b/kernel/kthread.c
> > index 3b34d27..4102518 100644
> > --- a/kernel/kthread.c
> > +++ b/kernel/kthread.c
> > @@ -202,7 +202,7 @@ void kthread_bind(struct task_struct *p, unsigned int cpu)
> >  		return;
> >  	}
> >  
> > -	p->cpus_allowed = cpumask_of_cpu(cpu);
> > +	cpumask_copy(&p->cpus_allowed, cpumask_of(cpu));
> >  	p->rt.nr_cpus_allowed = 1;
> >  	p->flags |= PF_THREAD_BOUND;
> >  }
> 
> But why? Are we going to get rid of cpumask_t (which is a fixed sized
> struct to direct assignment is perfectly fine)?
> 
> Also, do we want to convert cpus_allowed to cpumask_var_t? It would save
> quite a lot of memory on distro configs that set NR_CPUS silly high.
> Currently NR_CPUS=4096 configs allocate 512 bytes per task for this
> bitmap, 511 of which will never be used on most machines (510 in the
> near future).
>
> The cost if of course an extra memory dereference in scheduler hot
> paths.. also not nice.

To be honest, I dislike current cpumask_size() always return NR_CPUS. It
screw up almost all of cpumask_var_t benefit. But, we have to eliminate
all dangerous = operator usage before changing its implementation.

(btw, I wonder this limitation doesn't documented at all in code. Should
 we add this?)

Thus, now I'm finding all of =operator by tool and replacing it. The second
motivation of eliminating old api is to easy detect obsolete usage by tool.

So, I personally hope task->cpus_allowed convert to cpumask_var_t 
as cpuset->cpus_allowed. For some years, storage guys repeatedly alert
stack overflow chance is increasing as time goes.

However, yes, extra memory dereference is also bad. If scheduler folks
dislike cpumask_var_t, I can drop to think convert task->cpus_allowed.

But, if we can't convert cpus_allowed, I'd like to move it into last of
task_struct. because usually cpu_allowed is only accessed first byte
(as you described).

Thanks.



>From 8844bba7597ac1c7fd2e88406da17d818ce271d1 Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Tue, 26 Apr 2011 19:58:39 +0900
Subject: [PATCH] cpumask: add cpumask_var_t documentation

cpumask_var_t has one nortable difference against cpumask_t.
This patch adds the explanation.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 include/linux/cpumask.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index a3ff24f..3d09505 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -617,6 +617,12 @@ static inline size_t cpumask_size(void)
  *	  ... use 'tmpmask' like a normal struct cpumask * ...
  *
  *	free_cpumask_var(tmpmask);
+ *
+ * However, one notable exception is there. cpumask_var_t is allocated
+ * only nr_cpu_ids bits (in the other hand, real cpumask_t always has
+ * NR_CPUS bits). therefore cpumask_var_t can't use '=' operator.
+ * It makes NR_CPUS size memcopy and bring memroy corruption. You have
+ * to use cpumask_copy() instead.
  */
 #ifdef CONFIG_CPUMASK_OFFSTACK
 typedef struct cpumask *cpumask_var_t;
-- 
1.7.3.1



