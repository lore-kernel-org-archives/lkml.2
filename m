Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760Ab3AGVoY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 16:44:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38618 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755617Ab3AGVoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 16:44:23 -0500
Date: Mon, 7 Jan 2013 13:44:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Xi Wang <xi.wang@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jason Baron <jbaron@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH RFC] exec: avoid possible undefined behavior in count()
Message-Id: <20130107134422.038de6f9.akpm@linux-foundation.org>
In-Reply-To: <1357450145-23964-1-git-send-email-xi.wang@gmail.com>
References: <1357450145-23964-1-git-send-email-xi.wang@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  6 Jan 2013 00:29:05 -0500
Xi Wang <xi.wang@gmail.com> wrote:

> The tricky problem is this check:
> 
> 	if (i++ >= max)
> 
> icc (mis)optimizes this check as:
> 
> 	if (++i > max)
> 
> The check now becomes a no-op since max is MAX_ARG_STRINGS (0x7FFFFFFF).
> 
> This is "allowed" by the C standard, assuming i++ never overflows,
> because signed integer overflow is undefined behavior.  This optimization
> effectively reverts the previous commit 362e6663ef ("exec.c, compat.c:
> fix count(), compat_count() bounds checking") that tries to fix the check.
> 
> This patch simply moves ++ after the check.
> 
> ...
>
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -434,8 +434,9 @@ static int count(struct user_arg_ptr argv, int max)
>  			if (IS_ERR(p))
>  				return -EFAULT;
>  
> -			if (i++ >= max)
> +			if (i >= max)
>  				return -E2BIG;
> +			++i;
>  
>  			if (fatal_signal_pending(current))
>  				return -ERESTARTNOHAND;

I have no problem working around a compiler bug when the workaround is
so small and simple.  For clarity and accuracy I renamed the patch to
"fs/exec.c: work around icc miscompilation".  

However I'd also like to be able to add "this bug has been reported to
the icc developers and will be fixed in version X.Y"?
