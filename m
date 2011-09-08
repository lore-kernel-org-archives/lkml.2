Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab1IHXwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:52:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46632 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754031Ab1IHXwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:52:17 -0400
Date: Thu, 8 Sep 2011 16:52:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Mark Salter <msalter@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Pass correct length to strnlen_user in fs/exec.c
Message-Id: <20110908165213.6ebd844f.akpm@linux-foundation.org>
In-Reply-To: <4E680EBC.4000804@gmail.com>
References: <4E680EBC.4000804@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Sep 2011 10:39:24 +1000
Ryan Mallon <rmallon@gmail.com> wrote:

> Replace valid_arg_len function in fs/exec.c with max_arg_len function
> and pass the correct length to strnlen_user.
> 
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -296,9 +296,9 @@ err:
>  	return err;
>  }
>  
> -static bool valid_arg_len(struct linux_binprm *bprm, long len)
> +static long max_arg_len(struct linux_binprm *bprm)
>  {
> -	return len <= MAX_ARG_STRLEN;
> +	return MAX_ARG_STRLEN;
>  }
>  
>  #else
> @@ -354,9 +354,9 @@ static int __bprm_mm_init(struct linux_binprm *bprm)
>  	return 0;
>  }
>  
> -static bool valid_arg_len(struct linux_binprm *bprm, long len)
> +static long max_arg_len(struct linux_binprm *bprm)
>  {
> -	return len <= bprm->p;
> +	return bprm->p;
>  }
>  
>  #endif /* CONFIG_MMU */
> @@ -474,18 +474,19 @@ static int copy_strings(int argc, struct user_arg_ptr argv,
>  		const char __user *str;
>  		int len;
>  		unsigned long pos;
> +		long max_len = max_arg_len(bprm);
>  
>  		ret = -EFAULT;
>  		str = get_user_arg_ptr(argv, argc);
>  		if (IS_ERR(str))
>  			goto out;
>  
> -		len = strnlen_user(str, MAX_ARG_STRLEN);
> -		if (!len || len > MAX_ARG_STRLEN)
> +		len = strnlen_user(str, max_len);
> +		if (!len)
>  			goto out;
>  
>  		ret = -E2BIG;
> -		if (!valid_arg_len(bprm, len))
> +		if (len > max_len)
>  			goto out;
>  
>  		/* We're going to work our way backwords. */

I'm struggling to find a reason to merge this - it churns code around
rather pointlessly?

