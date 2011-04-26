Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab1DZUTk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 16:19:40 -0400
Received: from smtp-out.google.com ([216.239.44.51]:10490 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab1DZUTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 16:19:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=tjJuhAyQK6yn8uvGNm8jAKFM/ix77zyKTq0aEuVpp8EVGcwoubZM8jfmrlVp8ceNp+
         YTg84RMjhNpfIZOdJD8A==
Date: Tue, 26 Apr 2011 13:19:41 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: bookjovi@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Rientjes <rientjes@google.com>,
        Stephen Wilson <wilsons@start.ca>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] proc: put check_mem_permission before __get_free_page
 in mem_read
In-Reply-To: <20110426141449.F37C.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.LSU.2.00.1104261317400.9533@sister.anvils>
References: <1303086002-6961-1-git-send-email-bookjovi@gmail.com> <alpine.LSU.2.00.1104252048190.6978@sister.anvils> <20110426141449.F37C.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Apr 2011, KOSAKI Motohiro wrote:
> 
> From 74f827ce74e1c4f846905e940edfa5f639b5a2ce Mon Sep 17 00:00:00 2001
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Date: Tue, 26 Apr 2011 13:57:02 +0900
> Subject: [PATCH] [PATCH] proc: put check_mem_permission after __get_free_page in mem_write
> 
> It should be better if put check_mem_permission after __get_free_page
> in mem_write, to be same as function mem_read.
> 
> Hugh Dickins explained the reason.
> 
>     check_mem_permission gets a reference to the mm.  If we __get_free_page
>     after check_mem_permission, imagine what happens if the system is out
>     of memory, and the mm we're looking at is selected for killing by the
>     OOM killer: while we wait in __get_free_page for more memory, no memory
>     is freed from the selected mm because it cannot reach exit_mmap while
>     we hold that reference.
> 
> 
> Reported-by: Jovi Zhang <bookjovi@gmail.com>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Stephen Wilson <wilsons@start.ca>

Thank you, yes!

Acked-by: Hugh Dickins <hughd@google.com>

> ---
>  fs/proc/base.c |   16 +++++++++-------
>  1 files changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 4deef2e..e93be6e 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -894,20 +894,20 @@ static ssize_t mem_write(struct file * file, const char __user *buf,
>  	if (!task)
>  		goto out_no_task;
>  
> +	copied = -ENOMEM;
> +	page = (char *)__get_free_page(GFP_TEMPORARY);
> +	if (!page)
> +		goto out_task;
> +
>  	mm = check_mem_permission(task);
>  	copied = PTR_ERR(mm);
>  	if (IS_ERR(mm))
> -		goto out_task;
> +		goto out_free;
>  
>  	copied = -EIO;
>  	if (file->private_data != (void *)((long)current->self_exec_id))
>  		goto out_mm;
>  
> -	copied = -ENOMEM;
> -	page = (char *)__get_free_page(GFP_TEMPORARY);
> -	if (!page)
> -		goto out_mm;
> -
>  	copied = 0;
>  	while (count > 0) {
>  		int this_len, retval;
> @@ -929,9 +929,11 @@ static ssize_t mem_write(struct file * file, const char __user *buf,
>  		count -= retval;			
>  	}
>  	*ppos = dst;
> -	free_page((unsigned long) page);
> +
>  out_mm:
>  	mmput(mm);
> +out_free:
> +	free_page((unsigned long) page);
>  out_task:
>  	put_task_struct(task);
>  out_no_task:
> -- 
> 1.7.3.1
