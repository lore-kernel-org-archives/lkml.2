Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728Ab0C2Lma (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 07:42:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045Ab0C2Lm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 07:42:29 -0400
Date: Mon, 29 Mar 2010 13:40:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Roland McGrath <roland@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ptrace: kill BKL in ptrace syscall
Message-ID: <20100329114046.GB16971@redhat.com>
References: <1269812331-8511-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269812331-8511-1-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28, Frederic Weisbecker wrote:
>
> From: Arnd Bergmann <arnd@arndb.de>
>
> The comment suggests that this usage is stale. There is no bkl in the
> exec path so if there is a race lurking there, the bkl in ptrace is
> not going to help in this regard.

I never understood this comment too, and I do not see any potentional
races bkl could prevent.

> Overview of the possibility of "accidental" races this bkl might
> protect:
>
> - ptrace_traceme() is protected against task removal and concurrent
> read/write on current->ptrace as it locks write tasklist_lock.
>
> - arch_ptrace_attach() is serialized by ptrace_traceme() against
> concurrent PTRACE_TRACEME or PTRACE_ATTACH
>
> - ptrace_attach() is protected the same way ptrace_traceme() and
> in turn serializes arch_ptrace_attach()
>
> - ptrace_check_attach() does its own well described serializing too.
>
> There is no obvious race here.

Yes, nothing inside sys_ptrace() pathes relies on bkl, and all recent
changes were done assuming that lock_kernel() doesn't exist.

I think the patch is correct.

Acked-by: Oleg Nesterov <oleg@redhat.com>

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  kernel/ptrace.c |   10 ----------
>  1 files changed, 0 insertions(+), 10 deletions(-)
>
> diff --git a/kernel/ptrace.c b/kernel/ptrace.c
> index 42ad8ae..5357502 100644
> --- a/kernel/ptrace.c
> +++ b/kernel/ptrace.c
> @@ -666,10 +666,6 @@ SYSCALL_DEFINE4(ptrace, long, request, long, pid, long, addr, long, data)
>  	struct task_struct *child;
>  	long ret;
>
> -	/*
> -	 * This lock_kernel fixes a subtle race with suid exec
> -	 */
> -	lock_kernel();
>  	if (request == PTRACE_TRACEME) {
>  		ret = ptrace_traceme();
>  		if (!ret)
> @@ -703,7 +699,6 @@ SYSCALL_DEFINE4(ptrace, long, request, long, pid, long, addr, long, data)
>   out_put_task_struct:
>  	put_task_struct(child);
>   out:
> -	unlock_kernel();
>  	return ret;
>  }
>
> @@ -813,10 +808,6 @@ asmlinkage long compat_sys_ptrace(compat_long_t request, compat_long_t pid,
>  	struct task_struct *child;
>  	long ret;
>
> -	/*
> -	 * This lock_kernel fixes a subtle race with suid exec
> -	 */
> -	lock_kernel();
>  	if (request == PTRACE_TRACEME) {
>  		ret = ptrace_traceme();
>  		goto out;
> @@ -846,7 +837,6 @@ asmlinkage long compat_sys_ptrace(compat_long_t request, compat_long_t pid,
>   out_put_task_struct:
>  	put_task_struct(child);
>   out:
> -	unlock_kernel();
>  	return ret;
>  }
>  #endif	/* CONFIG_COMPAT */
> --
> 1.6.2.3
>

