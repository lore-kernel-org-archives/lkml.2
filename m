Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052Ab2CGLWP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 06:22:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57003 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755332Ab2CGLWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 06:22:05 -0500
Date: Wed, 7 Mar 2012 11:22:01 +0000
From: Mel Gorman <mgorman@suse.de>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Christoph Lameter <cl@linux.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuset: mm: Reduce large amounts of memory barrier
 related damage v2
Message-ID: <20120307112201.GC17697@suse.de>
References: <20120306132735.GA2855@suse.de>
 <4F572730.8000000@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4F572730.8000000@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 05:15:28PM +0800, Miao Xie wrote:
> On Tue, 6 Mar 2012 13:27:35 +0000, Mel Gorman wrote:
> [skip]
> > @@ -964,7 +964,6 @@ static void cpuset_change_task_nodemask(struct task_struct *tsk,
> >  {
> >  	bool need_loop;
> >  
> > -repeat:
> >  	/*
> >  	 * Allow tasks that have access to memory reserves because they have
> >  	 * been OOM killed to get memory anywhere.
> > @@ -983,45 +982,19 @@ repeat:
> >  	 */
> >  	need_loop = task_has_mempolicy(tsk) ||
> >  			!nodes_intersects(*newmems, tsk->mems_allowed);
> > -	nodes_or(tsk->mems_allowed, tsk->mems_allowed, *newmems);
> > -	mpol_rebind_task(tsk, newmems, MPOL_REBIND_STEP1);
> >  
> > -	/*
> > -	 * ensure checking ->mems_allowed_change_disable after setting all new
> > -	 * allowed nodes.
> > -	 *
> > -	 * the read-side task can see an nodemask with new allowed nodes and
> > -	 * old allowed nodes. and if it allocates page when cpuset clears newly
> > -	 * disallowed ones continuous, it can see the new allowed bits.
> > -	 *
> > -	 * And if setting all new allowed nodes is after the checking, setting
> > -	 * all new allowed nodes and clearing newly disallowed ones will be done
> > -	 * continuous, and the read-side task may find no node to alloc page.
> > -	 */
> > -	smp_mb();
> > +	if (need_loop)
> > +		write_seqcount_begin(&tsk->mems_allowed_seq);
> >  
> > -	/*
> > -	 * Allocation of memory is very fast, we needn't sleep when waiting
> > -	 * for the read-side.
> > -	 */
> > -	while (need_loop && ACCESS_ONCE(tsk->mems_allowed_change_disable)) {
> > -		task_unlock(tsk);
> > -		if (!task_curr(tsk))
> > -			yield();
> > -		goto repeat;
> > -	}
> > -
> > -	/*
> > -	 * ensure checking ->mems_allowed_change_disable before clearing all new
> > -	 * disallowed nodes.
> > -	 *
> > -	 * if clearing newly disallowed bits before the checking, the read-side
> > -	 * task may find no node to alloc page.
> > -	 */
> > -	smp_mb();
> > +	nodes_or(tsk->mems_allowed, tsk->mems_allowed, *newmems);
> > +	mpol_rebind_task(tsk, newmems, MPOL_REBIND_STEP1);
> >  
> >  	mpol_rebind_task(tsk, newmems, MPOL_REBIND_STEP2);
> >  	tsk->mems_allowed = *newmems;
> > +
> > +	if (need_loop)
> > +		write_seqcount_end(&tsk->mems_allowed_seq);
> > +
> >  	task_unlock(tsk);
> >  }
> 

Thanks for reviewing this.

> With this patch, we needn't break the nodemask update into two steps.
> 

Good point. At a glance it's sufficiently complex to warrent its own patch.

> Beside that, we need deal with fork() carefully, or it is possible that the child
> task will be set to a wrong nodemask.
> 

Can you clarify this statement please? It's not clear what the old code
did that protected against problems in fork() versus this patch. fork is
not calling get_mems_allowed() for example or doing anything special
around mems_allowed.

Maybe you are talking about an existing problem whereby during fork
there should be get_mems_allowed/put_mems_allowed and the mems_allowed
mask gets copied explicitly?

-- 
Mel Gorman
SUSE Labs
