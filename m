Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578Ab0GAAHP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 20:07:15 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44463 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755465Ab0GAAHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 20:07:08 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 03/11] oom: make oom_unkillable_task() helper function
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100630141944.GE15644@barrios-desktop>
References: <20100630182752.AA4E.A69D9226@jp.fujitsu.com> <20100630141944.GE15644@barrios-desktop>
Message-Id: <20100701085648.DA19.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  1 Jul 2010 09:07:02 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Jun 30, 2010 at 06:28:37PM +0900, KOSAKI Motohiro wrote:
> > Now, we have the same task check in two places. Unify it.
> > 
> > Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > ---
> >  mm/oom_kill.c |   33 ++++++++++++++++++++++-----------
> >  1 files changed, 22 insertions(+), 11 deletions(-)
> > 
> > diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> > index dc8589e..a4a5439 100644
> > --- a/mm/oom_kill.c
> > +++ b/mm/oom_kill.c
> > @@ -101,6 +101,26 @@ static struct task_struct *find_lock_task_mm(struct task_struct *p)
> >  	return NULL;
> >  }
> >  
> > +/* return true if the task is not adequate as candidate victim task. */
> > +static bool oom_unkillable_task(struct task_struct *p, struct mem_cgroup *mem,
> > +			   const nodemask_t *nodemask)
> > +{
> > +	if (is_global_init(p))
> > +		return true;
> > +	if (p->flags & PF_KTHREAD)
> > +		return true;
> > +
> > +	/* When mem_cgroup_out_of_memory() and p is not member of the group */
> > +	if (mem && !task_in_mem_cgroup(p, mem))
> > +		return true;
> > +
> > +	/* p may not have freeable memory in nodemask */
> > +	if (!has_intersects_mems_allowed(p, nodemask))
> > +		return true;
> > +
> > +	return false;
> > +}
> > +
> 
> I returend this patch as review 7/11. 
> Why didn't you check p->signal->oom_adj == OOM_DISABLE in here?
> I don't figure out code after your patches are applied totally.
> But I think it would be check it in this function as function's name says.

For preserve select_bad_process() semantics. It have

        for_each_process(p) {
                if (oom_unkillable_task(p, mem, nodemask))
			continue;

                if (thread_group_empty(p) && (p->flags & PF_EXITING) && p->mm) {
                        if (p != current)
                                return ERR_PTR(-1UL);

                        chosen = p;
                        *ppoints = ULONG_MAX;
                }

	        if (oom_adj == OOM_DISABLE)
			continue;

That said, Current OOM-Killer intend to kill PF_EXITING process even if
it have OOM_DISABLE. (practically, it's not kill. it only affect to give 
allocation bonus to PF_EXITING process)

My trivial fixes series don't intend to make large semantics change.



