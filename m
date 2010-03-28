Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab0C1VpR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 17:45:17 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:61230 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257Ab0C1VpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 17:45:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KvqbMeaWe0r1Tnd+OvE/ybT0VhgWcG2O+bCKAW5jnPApnoJ7H3p6cGF+v/ll6f7DvL
         8Oef1fRhQGII/pd5k+9yfD7PIFkKpPlgmbpA4Mlvmx9Q3MWueVgd3nG5rxATa77fVmjh
         WIUN33Wl+TJ/NXcRzmrtCOxnamd8Lt6zXoOzY=
Date: Sun, 28 Mar 2010 23:45:16 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ptrace: kill BKL in ptrace syscall
Message-ID: <20100328214515.GG5116@nowhere>
References: <1269812331-8511-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269812331-8511-1-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 28, 2010 at 11:38:51PM +0200, Frederic Weisbecker wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The comment suggests that this usage is stale. There is no bkl in the
> exec path so if there is a race lurking there, the bkl in ptrace is
> not going to help in this regard.
> 
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


And the call to arch_ptrace() doesn't need any pushdown I think,
since this is serialized by nature as there is only one "ptracer"
for a task.



> 
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

