Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759373Ab2CGPp7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 10:45:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759331Ab2CGPp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 10:45:57 -0500
Date: Wed, 7 Mar 2012 16:38:49 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Cc: Mark Salter <msalter@redhat.com>, linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH 2/2] mm/linux-next: Fix rcu locking in vm_is_stack
Message-ID: <20120307153849.GA18879@redhat.com>
References: <1331045377.17099.2.camel@deneb.redhat.com> <1331064994-6693-1-git-send-email-siddhesh.poyarekar@gmail.com> <1331064994-6693-2-git-send-email-siddhesh.poyarekar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331064994-6693-2-git-send-email-siddhesh.poyarekar@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07, Siddhesh Poyarekar wrote:
>
> Take rcu read lock before we do anything at all with the threadgroup
> list. Also use list_first_entry_rcu to safely get the reference to the
> first task in the list.

Sorry, but both patches are absolutely wrong, afaics. This change fixes
nothing, just obfuscates the code.

Probably my explanation was not clear, let me try again.

rcu_read_lock() can not help without the additional checks. By the
time you take it, task->thread_group->next can point to nowhere.

So,

> @@ -3932,18 +3932,20 @@ pid_t vm_is_stack(struct task_struct *task,
>  		return task->pid;
>
>  	if (in_group) {
> -		struct task_struct *t = task;
> +		struct task_struct *t;
>  		rcu_read_lock();
> -		while_each_thread(task, t) {
> +		t = list_first_entry_rcu(&task->thread_group,
> +					 struct task_struct, thread_group);

It is not safe to dereference this pointer.

Once again. You have the task_struct *task. It exits,
but task->thread_group->next still points to another thread T. Now suppose
that T exits too. But task->thread_group->next was not changed, it still
points to T. RCU grace period passes, T is freed.

After that you take rcu_read_lock(), but it is too late! >next points to
the already freed/reused memory. How can list_first_entry_rcu() help?

What you need is something like

		rcu_read_lock();
		if (!pid_alive(task))
			goto done;

		t = task;
		do {
			...
		} while_each(task, t);

	done:
		rcu_read_unlock();


And. Imho it is not good to have the (afaics exactly?) same code in
mm/nommu.c, even with the same names. Why it is not possible to make
a single definition?

Oleg.

