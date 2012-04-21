Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371Ab2DUWAc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 18:00:32 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:23365 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab2DUWAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 18:00:30 -0400
Date: Sun, 22 Apr 2012 00:00:29 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Sasikanth V <sasikanth.v19@gmail.com>
cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: uselib - Set error on do_filp_open failure only
In-Reply-To: <1335044983-2908-1-git-send-email-sasikanth.v19@gmail.com>
Message-ID: <alpine.LNX.2.00.1204212353310.25551@swampdragon.chaosbits.net>
References: <1335044983-2908-1-git-send-email-sasikanth.v19@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Apr 2012, Sasikanth V wrote:

> At present "error" is set irrespective of do_filp_open failed or not.
> Setting error to PTR_ERR(file) on do_filp_open failure only.
> 
> Signed-off-by: Sasikanth V <sasikanth.v19@gmail.com>
> ---
>  fs/exec.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index b1fd202..cb43367 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -129,9 +129,10 @@ SYSCALL_DEFINE1(uselib, const char __user *, library)
>  
>  	file = do_filp_open(AT_FDCWD, tmp, &uselib_flags, LOOKUP_FOLLOW);
>  	putname(tmp);
> -	error = PTR_ERR(file);
> -	if (IS_ERR(file))
> +	if (IS_ERR(file)) {
> +		error = PTR_ERR(file);
>  		goto out;
> +	}
>       error = -EINVAL;
>       if (!S_ISREG(file->f_path.dentry->d_inode->i_mode))
>


Ok, maybe I'm just stupid, but I really don't see the point of this patch.

With the original code, if "IS_ERR(file)" is true we'll "goto out" with 
'error' set to 'PTR_ERR(file)' and if it is false we'll set 'error = 
-EINVAL' and continue on...

With your new version we will, as I read the code, "goto out" with "error 
= PTR_ERR(file)" if "IS_ERR(file)" is true and if it is false we'll set 
'error = -EINVAL' and continue.

As I see it, there's no difference, except that your new version adds one 
extra line to the source file.

Am I missing something (as in "being completely braindead") or??


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

