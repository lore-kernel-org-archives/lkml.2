Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab0DAHmB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 03:42:01 -0400
Received: from smtp-out.google.com ([216.239.44.51]:22046 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab0DAHly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 03:41:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=cg6aNri/OhkS1rvx9j9QykeYj+MKm9fEixDbK5DxUp5txX7wR/78Ox+DTY6n9GIt9
	4OimgjWs6OAdvBBwoepmQ==
Date: Thu, 1 Apr 2010 00:41:47 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Oleg Nesterov <oleg@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, anfei <anfei.zhou@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       nishimura@mxp.nes.nec.co.jp,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] oom: fix the unsafe proc_oom_score()->badness() call
In-Reply-To: <20100331201746.GC11635@redhat.com>
Message-ID: <alpine.DEB.2.00.1004010029260.6285@chino.kir.corp.google.com>
References: <20100326150805.f5853d1c.akpm@linux-foundation.org> <20100326223356.GA20833@redhat.com> <20100328145528.GA14622@desktop> <20100328162821.GA16765@redhat.com> <alpine.DEB.2.00.1003281341590.30570@chino.kir.corp.google.com> <20100329112111.GA16971@redhat.com>
 <alpine.DEB.2.00.1003291302170.14859@chino.kir.corp.google.com> <20100330163909.GA16884@redhat.com> <alpine.DEB.2.00.1003301331110.5234@chino.kir.corp.google.com> <20100331091628.GA11438@redhat.com> <20100331201746.GC11635@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Mar 2010, Oleg Nesterov wrote:

> But. Oh well. David, oom-badness-heuristic-rewrite.patch changed badness()
> to consult p->signal->oom_score_adj. Until recently this was wrong when it
> is called from proc_oom_score().
> 
> This means oom-badness-heuristic-rewrite.patch depends on
> signals-make-task_struct-signal-immutable-refcountable.patch, or we
> need the pid_alive() check again.
> 

oom-badness-heuristic-rewrite.patch didn't change anything, Linus' tree 
currently dereferences p->signal->oom_adj which is no different from 
dereferencing p->signal->oom_score_adj without a refcount on the 
signal_struct in -mm.  oom_adj was moved to struct signal_struct in 
2.6.32, see 28b83c5.

> oom_badness() gets the new argument, long totalpages, and the callers
> were updated. However, long uptime is not used any longer, probably
> it make sense to kill this arg and simplify the callers? Unless you
> are going to take run-time into account later.
> 
> So, I think -mm needs the patch below, but I have no idea how to
> write the changelog ;)
> 
> Oleg.
> 
> --- x/fs/proc/base.c
> +++ x/fs/proc/base.c
> @@ -430,12 +430,13 @@ static const struct file_operations proc
>  /* The badness from the OOM killer */
>  static int proc_oom_score(struct task_struct *task, char *buffer)
>  {
> -	unsigned long points;
> +	unsigned long points = 0;
>  	struct timespec uptime;
>  
>  	do_posix_clock_monotonic_gettime(&uptime);
>  	read_lock(&tasklist_lock);
> -	points = oom_badness(task->group_leader,
> +	if (pid_alive(task))
> +		points = oom_badness(task,
>  				global_page_state(NR_INACTIVE_ANON) +
>  				global_page_state(NR_ACTIVE_ANON) +
>  				global_page_state(NR_INACTIVE_FILE) +

This should be protected by the get_proc_task() on the inode before 
this function is called from proc_info_read().
