Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab2A3PPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 10:15:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42686 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749Ab2A3PPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 10:15:43 -0500
Date: Mon, 30 Jan 2012 16:09:22 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Christopher Yeoh <cyeoh@au1.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] Fix race in process_vm_rw_core
Message-ID: <20120130150922.GA17643@redhat.com>
References: <20120130124406.1567af7a@Gantu.yeoh.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120130124406.1567af7a@Gantu.yeoh.info>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30, Christopher Yeoh wrote:
>
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -198,7 +198,7 @@ static int proc_root_link(struct dentry *dentry, struct path *path)
>  	return result;
>  }
>
> -static struct mm_struct *mm_access(struct task_struct *task, unsigned int mode)
> +struct mm_struct *mm_access(struct task_struct *task, unsigned int mode)

This is not enough, we should move it outside of fs/proc/, otherwise
the kernel can't be compiled without CONFIG_PROC.

> --- a/mm/process_vm_access.c
> +++ b/mm/process_vm_access.c
> @@ -298,23 +298,15 @@ static ssize_t process_vm_rw_core(pid_t pid, const struct iovec *lvec,
>  		goto free_proc_pages;
>  	}
>  
> -	task_lock(task);
> -	if (__ptrace_may_access(task, PTRACE_MODE_ATTACH)) {
> -		task_unlock(task);
> -		rc = -EPERM;
> -		goto put_task_struct;
> -	}
> -	mm = task->mm;
> -
> -	if (!mm || (task->flags & PF_KTHREAD)) {
> -		task_unlock(task);
> -		rc = -EINVAL;
> +	mm = mm_access(task, PTRACE_MODE_ATTACH);
> +	if (!mm || IS_ERR(mm)) {
> +		if (!mm)
> +			rc = -EINVAL;
> +		else
> +			rc = -EPERM;
>  		goto put_task_struct;
>  	}
>  
> -	atomic_inc(&mm->mm_users);
> -	task_unlock(task);
> -

Looks obviously correct.

Oleg.

