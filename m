Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070Ab1GFLgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 07:36:25 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:49195 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909Ab1GFLgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 07:36:24 -0400
From: Richard Weinberger <richard@nod.at>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [PATCH][Resend v2] Fix infinite loop in search_binary_handler()
Date: Wed, 6 Jul 2011 13:36:20 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37.6-0.5-desktop; KDE/4.6.5; x86_64; ; )
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <1309779003-8668-1-git-send-email-richard@nod.at> <201107051421.02658.richard@nod.at> <201107062028.JFH82378.OLQHFFMVJtFOSO@I-love.SAKURA.ne.jp>
In-Reply-To: <201107062028.JFH82378.OLQHFFMVJtFOSO@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107061336.20411.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 06 Juli 2011, 13:28:18 schrieb Tetsuo Handa:
> Richard Weinberger wrote:
> > But IMHO adding a new attribute to task_struct is a bit overkill.
> 
> Indeed. I came up with a simpler solution. ;-)
> ----------------------------------------
> [PATCH] exec: Do not call request_module() twice from
> search_binary_handler().
> 
> Currently, search_binary_handler() tries to load binary loader module using
> request_module() if a loader for the requested program is not yet loaded.
> But second attempt of request_module() does not affect the result of
> search_binary_handler().
> 
> If request_module() triggered recursion, calling request_module() twice
> causes 2 to the power of MAX_KMOD_CONCURRENT (= 50) repetitions. It is not
> an infinite loop but is sufficient for users to consider as a hang up.
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
> @@ -1411,6 +1411,8 @@ int search_binary_handler(struct linux_binprm
> *bprm,struct pt_regs *regs) printable(bprm->buf[2]) &&
>  			    printable(bprm->buf[3]))
>  				break; /* -ENOEXEC */
> +			if (try)
> +				break; /* -ENOEXEC */
>  			request_module("binfmt-%04x", *(unsigned short *)(&bprm->buf[2]));
>  #endif
>  		}

Nice solution. :-)

Tested-by: Richard Weinberger <richard@nod.at>

Thanks,
//richard
