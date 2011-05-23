Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934302Ab1EWWQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 18:16:25 -0400
Received: from smtp-out.google.com ([216.239.44.51]:15700 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934232Ab1EWWQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 18:16:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=kPWxawc/Ihc4lmPUulnRTLOM1utF6z9c16WxtbAErLh75nGVzAMZaLocBLXOf0mNQF
         7VJmMCVJIotxP+9Xxz3w==
Date: Mon, 23 May 2011 15:16:16 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, caiqian@redhat.com,
        Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 1/5] oom: improve dump_tasks() show items
In-Reply-To: <4DD61FE2.1020303@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1105231514350.17840@chino.kir.corp.google.com>
References: <4DD61F80.1020505@jp.fujitsu.com> <4DD61FE2.1020303@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 May 2011, KOSAKI Motohiro wrote:

> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index f52e85c..43d32ae 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -355,7 +355,7 @@ static void dump_tasks(const struct mem_cgroup *mem, const nodemask_t *nodemask)
>  	struct task_struct *p;
>  	struct task_struct *task;
> 
> -	pr_info("[ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name\n");
> +	pr_info("[   pid]   ppid   uid total_vm      rss     swap score_adj name\n");
>  	for_each_process(p) {
>  		if (oom_unkillable_task(p, mem, nodemask))
>  			continue;
> @@ -370,11 +370,14 @@ static void dump_tasks(const struct mem_cgroup *mem, const nodemask_t *nodemask)
>  			continue;
>  		}
> 
> -		pr_info("[%5d] %5d %5d %8lu %8lu %3u     %3d         %5d %s\n",
> -			task->pid, task_uid(task), task->tgid,
> -			task->mm->total_vm, get_mm_rss(task->mm),
> -			task_cpu(task), task->signal->oom_adj,
> -			task->signal->oom_score_adj, task->comm);
> +		pr_info("[%6d] %6d %5d %8lu %8lu %8lu %9d %s\n",
> +			task_tgid_nr(task), task_tgid_nr(task->real_parent),
> +			task_uid(task),
> +			task->mm->total_vm,
> +			get_mm_rss(task->mm) + p->mm->nr_ptes,
> +			get_mm_counter(p->mm, MM_SWAPENTS),
> +			task->signal->oom_score_adj,
> +			task->comm);
>  		task_unlock(task);
>  	}
>  }

Looks good, with the exception that the "score_adj" header should remain 
"oom_score_adj" since that is its name within procfs that changes the 
tunable.

After that's fixed:

	Acked-by: David Rientjes <rientjes@google.com>
