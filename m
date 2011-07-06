Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab1GFUWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 16:22:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43278 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755800Ab1GFUWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 16:22:23 -0400
Date: Wed, 6 Jul 2011 13:21:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: richard@nod.at, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH][Resend v2] Fix infinite loop in search_binary_handler()
Message-Id: <20110706132138.7e65a912.akpm@linux-foundation.org>
In-Reply-To: <201107062028.JFH82378.OLQHFFMVJtFOSO@I-love.SAKURA.ne.jp>
References: <1309779003-8668-1-git-send-email-richard@nod.at>
	<201107051155.18465.richard@nod.at>
	<201107052102.BHE69234.OLQOVMJFOFFHSt@I-love.SAKURA.ne.jp>
	<201107051421.02658.richard@nod.at>
	<201107062028.JFH82378.OLQHFFMVJtFOSO@I-love.SAKURA.ne.jp>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jul 2011 20:28:18 +0900
Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:

> Richard Weinberger wrote:
> > But IMHO adding a new attribute to task_struct is a bit overkill.
> Indeed. I came up with a simpler solution. ;-)
> ----------------------------------------
> [PATCH] exec: Do not call request_module() twice from search_binary_handler().
> 
> Currently, search_binary_handler() tries to load binary loader module using
> request_module() if a loader for the requested program is not yet loaded. But
> second attempt of request_module() does not affect the result of
> search_binary_handler().
> 
> If request_module() triggered recursion, calling request_module() twice causes
> 2 to the power of MAX_KMOD_CONCURRENT (= 50) repetitions. It is not an infinite
> loop but is sufficient for users to consider as a hang up.
> 
> Therefore, this patch changes not to call request_module() twice, making
> 1 to the power of MAX_KMOD_CONCURRENT repetitions in case of recursion.
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> ---
> diff --git a/fs/exec.c b/fs/exec.c
> index 6075a1e..044c13f 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1411,6 +1411,8 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
>  			    printable(bprm->buf[2]) &&
>  			    printable(bprm->buf[3]))
>  				break; /* -ENOEXEC */
> +			if (try)
> +				break; /* -ENOEXEC */
>  			request_module("binfmt-%04x", *(unsigned short *)(&bprm->buf[2]));
>  #endif
>  		}

What is that "for (try=0; try<2" loop actually there for?  To retry
after the request_module(), it appears.  Which is pointless if
!CONFIG_MODULES.


