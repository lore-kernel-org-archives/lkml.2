Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab1DVOac (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 10:30:32 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:36307 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750986Ab1DVOa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 10:30:29 -0400
Date: Fri, 22 Apr 2011 15:30:27 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 8/7] signal: cleanup sys_rt_sigprocmask()
Message-ID: <20110422153027.12d16b7e@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <20110418134700.GI15951@redhat.com>
References: <20110418134421.GA15951@redhat.com>
	<20110418134700.GI15951@redhat.com>
X-Mailer: Claws Mail 3.7.8cvs52 (GTK+ 2.22.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Apr 2011 15:47:00 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> sys_rt_sigprocmask() looks unnecessarily complicated, simplify it.
> We can just read current->blocked lockless unconditionally before
> anything else and then copy-to-user it if needed.  At worst we
> copy 4 words on mips.
> 
> We could copy-to-user the old mask first and simplify the code even
> more, but the patch tries to keep the current behaviour: we change
> current->block even if copy_to_user(oset) fails.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
> 
>  kernel/signal.c |   40 +++++++++++++++++-----------------------
>  1 file changed, 17 insertions(+), 23 deletions(-)
> 
> --- sigprocmask/kernel/signal.c~8_sys_sigprocmask	2011-04-17 22:32:58.000000000 +0200
> +++ sigprocmask/kernel/signal.c	2011-04-18 14:45:57.000000000 +0200
> @@ -2172,40 +2172,34 @@ int sigprocmask(int how, sigset_t *set, 
>   *  @oset: previous value of signal mask if non-null
>   *  @sigsetsize: size of sigset_t type
>   */
> -SYSCALL_DEFINE4(rt_sigprocmask, int, how, sigset_t __user *, set,
> +SYSCALL_DEFINE4(rt_sigprocmask, int, how, sigset_t __user *, nset,
>  		sigset_t __user *, oset, size_t, sigsetsize)
>  {
> -	int error = -EINVAL;
>  	sigset_t old_set, new_set;
> +	int error;
>  
> -	/* XXX: Don't preclude handling different sized sigset_t's.  */
> +	/* Don't preclude handling different sized sigset_t's. */
>  	if (sigsetsize != sizeof(sigset_t))
> -		goto out;
> +		return -EINVAL;

I don't think it's correct to remove the 'XXX'. The comment is
currently saying "We don't handle different sized sigset_t's, but we
should", whereas removing the 'XXX' says to me that we _DO_ handle
different sized sigset_t's. If you don't like the 'XXX' you could
always swap it for a 'TODO'?

Otherwise looks like a very nice cleanup.

Reviewed-by: Matt Fleming <matt.fleming@linux.intel.com>
