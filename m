Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759376Ab2AMWax (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 17:30:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55060 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038Ab2AMWaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 17:30:52 -0500
Date: Fri, 13 Jan 2012 14:30:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christopher Yeoh <cyeoh@au1.ibm.com>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] Fix race in process_vm_rw_core
Message-Id: <20120113143050.df23a02c.akpm@linux-foundation.org>
In-Reply-To: <20120113220028.4ba7cead@Gantu.yeoh.info>
References: <20120113220028.4ba7cead@Gantu.yeoh.info>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jan 2012 22:00:28 +1030
Christopher Yeoh <cyeoh@au1.ibm.com> wrote:

> Hi Linus,
> 
> Below is a patch which fixes the race in process_vm_core found by
> Oleg (http://article.gmane.org/gmane.linux.kernel/1235667/).
> It consolidates some code with mm_for_maps since what they do is almost
> identical.
> 
> Oleg - I've kept the breakout of ptrace_may_attach and get_task_mm to
> preserve only having to take the task lock once. I see some performance
> difference with a microbenchmark but haven't had a chance to test with
> some HPC benchmarks yet so for the moment I'd like to leave it in. At
> this stage I think its more important to get the race fixed and I'm at
> Linux.conf.au all next week. I'll send a patch out for the 
> rw_copy_check_uvector cleanup after I get back from LCA.
> 
> ...
>
> +struct mm_struct *get_check_task_mm(struct task_struct *task, unsigned int mode)
> +{
> +	struct mm_struct *mm;
> +	int err;
> +
> +	err =  mutex_lock_killable(&task->signal->cred_guard_mutex);
> +	if (err)
> +		return ERR_PTR(err);
> +
> +	task_lock(task);
> +	if (__ptrace_may_access(task, mode)) {
> +		mm = ERR_PTR(-EACCES);
> +		goto out;
> +	}
> +
> +	mm = task->mm;
> +	if (mm) {
> +		if (task->flags & PF_KTHREAD)
> +			mm = NULL;
> +		else
> +			atomic_inc(&mm->mm_users);
> +	}
> +
> +out:
> +	task_unlock(task);
> +	mutex_unlock(&task->signal->cred_guard_mutex);
> +
> +	return mm;
> +}
> +EXPORT_SYMBOL_GPL(get_check_task_mm);

I don't think the export is needed - CONFIG_PROC_FS=m isn't supported.

btw, I'm trying to work out why we didn't make the whole process_vm_access.o
feature Kconfigurable, so people who don't want it do not get burdened
with it?

