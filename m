Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091Ab1DZUn7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 16:43:59 -0400
Received: from smtp-out.google.com ([74.125.121.67]:22164 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576Ab1DZUn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 16:43:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=c9HUOBJxc71mfkwb29bYYpSn5T3yh1omITVn9aMS+jW0LpdklbPaYxya2mfhSXn/MX
         +wR5jirRc5KzO98SE8Ug==
Date: Tue, 26 Apr 2011 13:44:10 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: bookjovi@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Rientjes <rientjes@google.com>,
        Stephen Wilson <wilsons@start.ca>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] proc: fix pagemap_read() error case (was Re: [PATCH]
 proc: put check_mem_permission before __get_free_page in mem_read)
In-Reply-To: <20110426145226.F383.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.LSU.2.00.1104261321550.9533@sister.anvils>
References: <alpine.LSU.2.00.1104252048190.6978@sister.anvils> <20110426141449.F37C.A69D9226@jp.fujitsu.com> <20110426145226.F383.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Apr 2011, KOSAKI Motohiro wrote:
> 
> I've finished audit other /proc allocation callsite. If my understand
> is correct, only pagemap_read() has the same issue.
> 
> fixed.

Great, thank you.  Though I see Steve has cleverly spotted another:
yes, that should be worth looking into, but I've not studied it.

I confess that when I wrote yesterday, I thought there were a lot more
such instances in fs/proc.  I thought /proc/pid/smaps was vulnerable,
for example, but I cannot see that now: maybe I just confused it with
/proc/pid/pagemap.

I was worrying about this a couple of months ago, when David had an
OOM dump with OOM-killed threads failing to exit because they could
not skb_alloc in proc_exit_connector()'s cn_netlink_send() - connector
needs to allocate skb upfront (I'm being vague!), not when thread exits.

But it was a mystery why memory was still unavailable at that late
stage: my unsubstantiated suspicion was that something else was
holding on to the mm-to-be-freed while trying to allocate memory.

> 
> 
> From 5f83db14a7c62381c4f23994d559041c4c3320a8 Mon Sep 17 00:00:00 2001
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Date: Tue, 26 Apr 2011 14:26:52 +0900
> Subject: [PATCH] proc: fix pagemap_read() error case
> 
> Currently, pagemap_read() has three error and/or corner case
> handling mistake.
>  (1) If ppos parameter is wrong, mm refcount will be leak.
>  (2) If count parameter is 0, mm refcount will be leak too.
>  (3) If the current task is sleeping in kmalloc() and the system
>      is out of memory and oom-killer kill the proc associated task,
>      mm_refcount prevent the task free its memory. then system may
>      hang up.
> 
> <Quote Hugh's explain why we shold call kmalloc() before get_mm()>
>   check_mem_permission gets a reference to the mm.  If we __get_free_page
>   after check_mem_permission, imagine what happens if the system is out
>   of memory, and the mm we're looking at is selected for killing by the
>   OOM killer: while we wait in __get_free_page for more memory, no memory
>   is freed from the selected mm because it cannot reach exit_mmap while
>   we hold that reference.
> 
> This patch fixes the above three.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Hugh Dickins <hughd@google.com>

Acked-by: Hugh Dickins <hughd@google.com>

> ---
>  fs/proc/task_mmu.c |   19 +++++++++----------
>  1 files changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 51b9d98..6fb07ce 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -769,18 +769,12 @@ static ssize_t pagemap_read(struct file *file, char __user *buf,
>  	if (!task)
>  		goto out;
>  
> -	mm = mm_for_maps(task);
> -	ret = PTR_ERR(mm);
> -	if (!mm || IS_ERR(mm))
> -		goto out_task;
> -
>  	ret = -EINVAL;
>  	/* file position must be aligned */
>  	if ((*ppos % PM_ENTRY_BYTES) || (count % PM_ENTRY_BYTES))
>  		goto out_task;
>  
>  	ret = 0;
> -
>  	if (!count)
>  		goto out_task;
>  
> @@ -788,7 +782,12 @@ static ssize_t pagemap_read(struct file *file, char __user *buf,
>  	pm.buffer = kmalloc(pm.len, GFP_TEMPORARY);
>  	ret = -ENOMEM;
>  	if (!pm.buffer)
> -		goto out_mm;
> +		goto out_task;
> +
> +	mm = mm_for_maps(task);
> +	ret = PTR_ERR(mm);
> +	if (!mm || IS_ERR(mm))
> +		goto out_free;
>  
>  	pagemap_walk.pmd_entry = pagemap_pte_range;
>  	pagemap_walk.pte_hole = pagemap_pte_hole;
> @@ -831,7 +830,7 @@ static ssize_t pagemap_read(struct file *file, char __user *buf,
>  		len = min(count, PM_ENTRY_BYTES * pm.pos);
>  		if (copy_to_user(buf, pm.buffer, len)) {
>  			ret = -EFAULT;
> -			goto out_free;
> +			goto out_mm;
>  		}
>  		copied += len;
>  		buf += len;
> @@ -841,10 +840,10 @@ static ssize_t pagemap_read(struct file *file, char __user *buf,
>  	if (!ret || ret == PM_END_OF_BUFFER)
>  		ret = copied;
>  
> -out_free:
> -	kfree(pm.buffer);
>  out_mm:
>  	mmput(mm);
> +out_free:
> +	kfree(pm.buffer);
>  out_task:
>  	put_task_struct(task);
>  out:
> -- 
> 1.7.3.1
