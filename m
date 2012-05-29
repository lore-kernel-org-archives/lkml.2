Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab2E2ODe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 10:03:34 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36501 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab2E2ODd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 10:03:33 -0400
Message-ID: <1338300173.26856.83.camel@twins>
Subject: Re: [PATCH 20/35] autonuma: avoid CFS select_task_rq_fair to return
 -1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>
Date: Tue, 29 May 2012 16:02:53 +0200
In-Reply-To: <1337965359-29725-21-git-send-email-aarcange@redhat.com>
References: <1337965359-29725-1-git-send-email-aarcange@redhat.com>
	 <1337965359-29725-21-git-send-email-aarcange@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-25 at 19:02 +0200, Andrea Arcangeli wrote:
> Fix to avoid -1 retval.
> 
> Includes fixes from Hillf Danton <dhillf@gmail.com>.

This changelog is very much insufficient. It fails to mention why your
solution is the right one or if there's something else wrong with that
code.

> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> ---
>  kernel/sched/fair.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 940e6d1..137119f 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -2789,6 +2789,9 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
>  		if (new_cpu == -1 || new_cpu == cpu) {
>  			/* Now try balancing at a lower domain level of cpu */
>  			sd = sd->child;
> +			if (new_cpu < 0)
> +				/* Return prev_cpu is find_idlest_cpu failed */
> +				new_cpu = prev_cpu;
>  			continue;
>  		}
>  
> @@ -2807,6 +2810,7 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
>  unlock:
>  	rcu_read_unlock();
>  
> +	BUG_ON(new_cpu < 0);
>  	return new_cpu;
>  }
>  #endif /* CONFIG_SMP */

