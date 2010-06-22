Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab0FVQGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 12:06:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754918Ab0FVQGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 12:06:37 -0400
Date: Tue, 22 Jun 2010 18:04:42 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Mike McCormack <mikem@ring3k.org>
Cc: akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
       serue@us.ibm.com, jmorris@namei.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: Add complete process group list
Message-ID: <20100622160442.GA9072@redhat.com>
References: <4C20D1AE.5000205@ring3k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C20D1AE.5000205@ring3k.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23, Mike McCormack wrote:
>
> The new file /proc/<pid>/groups consists of a single group id per line,
>  with each line being 11 characters long.  This should be enough space
>  for 16bit or 32bit group ids.
>
> This feature might be useful for a server listening on a unix domain pipe
>  to determine the list of groups that a client process is in from its pid.

As usual, I can never comment whether we need this or not. Just a minor
nit about the code,

> +static int groups_proc_show(struct seq_file *m, void *v)
> +{
> +	struct inode *inode = m->private;
> +	struct group_info *group_info;
> +	struct task_struct *task;
> +	const struct cred *cred;
> +	struct pid *pid;
> +	unsigned int g;
> +
> +	pid = proc_pid(inode);
> +	task = get_pid_task(pid, PIDTYPE_PID);

get_proc_task() ?

> +	if (!task)
> +		return -ESRCH;
> +
> +	cred = get_task_cred(task);

OTOH. Not that I think this is terribly important, but I don't think
this needs get_task_struct + get_cred,

	group_info = NULL;

	rcu_read_lock();
	task = pid_task(proc_pid(inode), PIDTYPE_PID);
	if (task) {
		group_info = _task_cred(task)->group_info;
		get_group_info(group_info);
	}
	rcu_read_unlock();

	if (!group_info)
		retrn ESRCH;

Feel free to ignore though.

Oleg.

