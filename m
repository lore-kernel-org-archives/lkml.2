Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab0EaQ62 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 12:58:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754065Ab0EaQ60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 12:58:26 -0400
Date: Mon, 31 May 2010 18:56:58 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 4/5] oom: the points calculation of child processes
	must use find_lock_task_mm() too
Message-ID: <20100531165658.GC9991@redhat.com>
References: <20100531182526.1843.A69D9226@jp.fujitsu.com> <20100531183636.184C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100531183636.184C.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31, KOSAKI Motohiro wrote:
>
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -87,6 +87,7 @@ static struct task_struct *find_lock_task_mm(struct task_struct *p)
>  unsigned long badness(struct task_struct *p, unsigned long uptime)
>  {
>  	unsigned long points, cpu_time, run_time;
> +	struct task_struct *c;
>  	struct task_struct *child;
>  	int oom_adj = p->signal->oom_adj;
>  	struct task_cputime task_time;
> @@ -124,11 +125,13 @@ unsigned long badness(struct task_struct *p, unsigned long uptime)
>  	 * child is eating the vast majority of memory, adding only half
>  	 * to the parents will make the child our kill candidate of choice.
>  	 */
> -	list_for_each_entry(child, &p->children, sibling) {
> -		task_lock(child);
> -		if (child->mm != p->mm && child->mm)
> -			points += child->mm->total_vm/2 + 1;
> -		task_unlock(child);
> +	list_for_each_entry(c, &p->children, sibling) {
> +		child = find_lock_task_mm(c);
> +		if (child) {
> +			if (child->mm != p->mm)
> +				points += child->mm->total_vm/2 + 1;
> +			task_unlock(child);
> +		}

Acked-by: Oleg Nesterov <oleg@redhat.com>




And, I think we need another patch on top of this one. Note that
this list_for_each_entry(p->children) can only see the tasks forked
by p, it can't see other children forked by its sub-threads.

IOW, we need

	do {
		list_for_each_entry(c, &t->children, sibling) {
			...
		}
	} while_each_thread(p, t);

Probably the same for oom_kill_process().

What do you think?

Oleg.

