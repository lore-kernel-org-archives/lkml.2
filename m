Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab1DYWBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 18:01:22 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52574 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755280Ab1DYWBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 18:01:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QD/VQwPvVNRxMR4CiE4S5OyBFxbu9GgEszGOpmH5d11RgfWl33DgU2YXBKaWGkdF3z
         fCYaDnXyFjyjXYEhbVxxqd7+i7NviAJvaT+8c1+CHDzCjVqSmqg1yje+tdaggw4AqrIb
         +mXpMi8JiUAmFuThRkBd20l5oe1trIv+opz1c=
Date: Tue, 26 Apr 2011 01:01:16 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, bookjovi@gmail.com,
        kosaki.motohiro@jp.fujitsu.com, wilsons@start.ca
Subject: Re: +
 proc-put-check_mem_permission-before-__get_free_page-in-mem_read.patch added
 to -mm tree
Message-ID: <20110425220116.GA22006@p183>
References: <201104252011.p3PKBFTD005857@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104252011.p3PKBFTD005857@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 01:11:15PM -0700, akpm@linux-foundation.org wrote:
> Subject: proc: put check_mem_permission before __get_free_page in mem_read
> From: Jovi Zhang <bookjovi@gmail.com>
> 
> It would be better to put check_mem_permission() before __get_free_page()
> in mem_read(), to be same as mem_write().

This can be done even more straightforward if you put task_struct right after
it isn't needed.

> --- a/fs/proc/base.c~proc-put-check_mem_permission-before-__get_free_page-in-mem_read
> +++ a/fs/proc/base.c
> @@ -831,23 +831,21 @@ static ssize_t mem_read(struct file * fi
>  	if (!task)
>  		goto out_no_task;
>  
> -	ret = -ENOMEM;
> -	page = (char *)__get_free_page(GFP_TEMPORARY);
> -	if (!page)
> -		goto out;
> -
>  	mm = check_mem_permission(task);
>  	ret = PTR_ERR(mm);
>  	if (IS_ERR(mm))
> -		goto out_free;
> +		goto out_task;
>  
>  	ret = -EIO;
> - 
>  	if (file->private_data != (void*)((long)current->self_exec_id))
> -		goto out_put;
> +		goto out_mm;
> +
> +	ret = -ENOMEM;
> +	page = (char *)__get_free_page(GFP_TEMPORARY);
> +	if (!page)
> +		goto out_mm;
>  
>  	ret = 0;
> - 
>  	while (count > 0) {
>  		int this_len, retval;
>  
> @@ -870,12 +868,10 @@ static ssize_t mem_read(struct file * fi
>  		count -= retval;
>  	}
>  	*ppos = src;
> -
> -out_put:
> -	mmput(mm);
> -out_free:
>  	free_page((unsigned long) page);
> -out:
> +out_mm:
> +	mmput(mm);
> +out_task:
>  	put_task_struct(task);
>  out_no_task:
>  	return ret;
