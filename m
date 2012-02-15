Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761350Ab2BOOoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 09:44:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25798 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754777Ab2BOOn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 09:43:58 -0500
Date: Wed, 15 Feb 2012 15:36:06 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Valdis.Kletnieks@vt.edu,
        Michal Marek <mmarek@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: + syscalls-x86-add-__nr_kcmp-syscall-v8.patch added to -mm tree
Message-ID: <20120215143606.GA14037@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/* The caller must have pinned the task */
> +static struct file *
> +get_file_raw_ptr(struct task_struct *task, unsigned int idx)
> +{
> +	struct fdtable *fdt;
> +	struct file *file;
> +
> +	spin_lock(&task->files->file_lock);

task->files can be NULL, we can race with exit_files().

> +	fdt = files_fdtable(task->files);
> +	if (idx < fdt->max_fds)
> +		file = fdt->fd[idx];

You can probably rely on rcu instead of ->file_lock, but this is minor.

> +SYSCALL_DEFINE5(kcmp, pid_t, pid1, pid_t, pid2, int, type,
> +		unsigned long, idx1, unsigned long, idx2)
> +{
> +	struct task_struct *task1, *task2;
> +	int ret;
> +
> +	rcu_read_lock();
> +
> +	/*
> +	 * Tasks are looked up in caller's PID namespace only.
> +	 */
> +	task1 = find_task_by_vpid(pid1);
> +	task2 = find_task_by_vpid(pid2);
> +	if (!task1 || !task2)
> +		goto err_no_task;
> +
> +	get_task_struct(task1);
> +	get_task_struct(task2);
> +
> +	rcu_read_unlock();
> +
> +	/*
> +	 * One should have enough rights to inspect task details.
> +	 */
> +	if (!ptrace_may_access(task1, PTRACE_MODE_READ) ||
> +	    !ptrace_may_access(task2, PTRACE_MODE_READ)) {
> +		ret = -EACCES;

Well, probably this is fine... but may be you can add a comment.
The task can change its credentials right after ptrace_may_access()
succeeds. This _looks_ wrong, perhaps it makes sense to  add the
"we do not care" note.

Oleg.

