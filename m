Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab2CGJRa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 04:17:30 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62319 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751262Ab2CGJR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 04:17:27 -0500
X-IronPort-AV: E=Sophos;i="4.73,545,1325433600"; 
   d="scan'208";a="4480319"
Message-ID: <4F572730.8000000@cn.fujitsu.com>
Date: Wed, 07 Mar 2012 17:15:28 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Christoph Lameter <cl@linux.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuset: mm: Reduce large amounts of memory barrier related
 damage v2
References: <20120306132735.GA2855@suse.de>
In-Reply-To: <20120306132735.GA2855@suse.de>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-07 17:15:29,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-07 17:15:32,
	Serialize complete at 2012-03-07 17:15:32
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2012 13:27:35 +0000, Mel Gorman wrote:
[skip]
> @@ -964,7 +964,6 @@ static void cpuset_change_task_nodemask(struct task_struct *tsk,
>  {
>  	bool need_loop;
>  
> -repeat:
>  	/*
>  	 * Allow tasks that have access to memory reserves because they have
>  	 * been OOM killed to get memory anywhere.
> @@ -983,45 +982,19 @@ repeat:
>  	 */
>  	need_loop = task_has_mempolicy(tsk) ||
>  			!nodes_intersects(*newmems, tsk->mems_allowed);
> -	nodes_or(tsk->mems_allowed, tsk->mems_allowed, *newmems);
> -	mpol_rebind_task(tsk, newmems, MPOL_REBIND_STEP1);
>  
> -	/*
> -	 * ensure checking ->mems_allowed_change_disable after setting all new
> -	 * allowed nodes.
> -	 *
> -	 * the read-side task can see an nodemask with new allowed nodes and
> -	 * old allowed nodes. and if it allocates page when cpuset clears newly
> -	 * disallowed ones continuous, it can see the new allowed bits.
> -	 *
> -	 * And if setting all new allowed nodes is after the checking, setting
> -	 * all new allowed nodes and clearing newly disallowed ones will be done
> -	 * continuous, and the read-side task may find no node to alloc page.
> -	 */
> -	smp_mb();
> +	if (need_loop)
> +		write_seqcount_begin(&tsk->mems_allowed_seq);
>  
> -	/*
> -	 * Allocation of memory is very fast, we needn't sleep when waiting
> -	 * for the read-side.
> -	 */
> -	while (need_loop && ACCESS_ONCE(tsk->mems_allowed_change_disable)) {
> -		task_unlock(tsk);
> -		if (!task_curr(tsk))
> -			yield();
> -		goto repeat;
> -	}
> -
> -	/*
> -	 * ensure checking ->mems_allowed_change_disable before clearing all new
> -	 * disallowed nodes.
> -	 *
> -	 * if clearing newly disallowed bits before the checking, the read-side
> -	 * task may find no node to alloc page.
> -	 */
> -	smp_mb();
> +	nodes_or(tsk->mems_allowed, tsk->mems_allowed, *newmems);
> +	mpol_rebind_task(tsk, newmems, MPOL_REBIND_STEP1);
>  
>  	mpol_rebind_task(tsk, newmems, MPOL_REBIND_STEP2);
>  	tsk->mems_allowed = *newmems;
> +
> +	if (need_loop)
> +		write_seqcount_end(&tsk->mems_allowed_seq);
> +
>  	task_unlock(tsk);
>  }

With this patch, we needn't break the nodemask update into two steps.

Beside that, we need deal with fork() carefully, or it is possible that the child
task will be set to a wrong nodemask.

Thanks
Miao
