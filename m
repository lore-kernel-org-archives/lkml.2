Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281Ab1BJW55 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 17:57:57 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58230 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756844Ab1BJW54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 17:57:56 -0500
Date: Thu, 10 Feb 2011 14:57:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: Nick Piggin <npiggin@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fix filp_cachep memory corruption
Message-Id: <20110210145753.9bec879f.akpm@linux-foundation.org>
In-Reply-To: <12967.1296674338@jrobl>
References: <12967.1296674338@jrobl>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Feb 2011 04:18:58 +0900
"J. R. Okajima" <hooanon05@yahoo.co.jp> wrote:

> 
> commit e1ddf5b0dd3e8234581c78c3cadd6e2adfe6e2d4
> Author: J. R. Okajima <hooanon05@yahoo.co.jp>
> Date:   Thu Feb 3 03:38:12 2011 +0900
> 
>     fix filp_cachep memory corruption
>     
>     By the commit
>     	31e6b01 2011-01-07 fs: rcu-walk for path lookup
>     the condition "-ESTALE && !LOOKUP_REVAL" is added to "goto reval" in
>     do_filp_open(), and it lookup again with LOOKUP_REVAL _after_
>     release_open_intent(). Since release_open_intent() is called by
>     do_last() and finish_open() too, add the same condition to all of them.
>     
>     Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index 084be4d..1f62d6a 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -2269,7 +2269,8 @@ static struct file *finish_open(struct nameidata *nd,
>  	return filp;
>  
>  exit:
> -	if (!IS_ERR(nd->intent.open.file))
> +	if (!(error == -ESTALE && !(nd->flags & LOOKUP_REVAL))
> +	    && !IS_ERR(nd->intent.open.file))
>  		release_open_intent(nd);
>  	path_put(&nd->path);
>  	return ERR_PTR(error);
> @@ -2393,7 +2394,8 @@ exit_mutex_unlock:
>  exit_dput:
>  	path_put_conditional(path, nd);
>  exit:
> -	if (!IS_ERR(nd->intent.open.file))
> +	if (!(error == -ESTALE && !(nd->flags & LOOKUP_REVAL))
> +	    && !IS_ERR(nd->intent.open.file))
>  		release_open_intent(nd);
>  	path_put(&nd->path);
>  	return ERR_PTR(error);
> @@ -2564,7 +2566,8 @@ exit_dput:
>  out_path:
>  	path_put(&nd.path);
>  out_filp:
> -	if (!IS_ERR(nd.intent.open.file))
> +	if (!(error == -ESTALE && !(flags & LOOKUP_REVAL))
> +	    && !IS_ERR(nd.intent.open.file))
>  		release_open_intent(&nd);
>  	filp = ERR_PTR(error);
>  	goto out;

The patch is pretty ugly.  It would be much nicer if we had a
well-named and documented helper function to replace that repeated
open-coded test.  Not just because the code looks better - a standalone
function is an opportunity to explain to readers what the code is
trying to do.


Anyway, as Nick appears to have done a dump-and-run on the kernel
project, I shall send your fix into Linus as-is.  Perhaps you or Nick
could look into cleaning things up later on?

