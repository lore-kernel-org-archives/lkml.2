Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab2APTF0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 14:05:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754760Ab2APTFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 14:05:25 -0500
Date: Mon, 16 Jan 2012 19:59:24 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Christopher Yeoh <cyeoh@au1.ibm.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] Fix race in process_vm_rw_core
Message-ID: <20120116185924.GA24418@redhat.com>
References: <20120113220028.4ba7cead@Gantu.yeoh.info> <20120113160442.GA20137@redhat.com> <20120114095633.139119b2@Gantu.yeoh.info> <20120114175829.GA32638@redhat.com> <20120116135655.1a31e13c@rockpopper>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120116135655.1a31e13c@rockpopper>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16, Christopher Yeoh wrote:
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
> +	mm = task->mm;
> +	if (mm != current->mm && __ptrace_may_access(task, mode)) {
> +		mm = ERR_PTR(-EACCES);
> +		goto out;
> +	}
> +
> +	if (mm) {
> +		if (task->flags & PF_KTHREAD)
> +			mm = NULL;
> +		else
> +			atomic_inc(&mm->mm_users);
> +	}

This still looks a bit strange, we call __ptrace_may_access()
before we check ->mm != NULL even if this is safe... Really, we
would simply fix the bug then try to microoptimize this code.

But OK, I promised I won't argue ;)

I believe the patch is correct and fixes the problem.

Oleg.

