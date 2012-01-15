Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904Ab2AOSNm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 13:13:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760Ab2AOSNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 13:13:41 -0500
Date: Sun, 15 Jan 2012 19:07:21 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Andrew Vagin <avagin@openvz.org>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [RFC] fs, proc: Introduce /proc/<pid>/task/<tid>/children
	entry v5
Message-ID: <20120115180721.GA23810@redhat.com>
References: <20111228121407.GL27266@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111228121407.GL27266@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/28, Cyrill Gorcunov wrote:
>
> When we do checkpoint of a task we need to know the list of children
> the task has but there is no easy way to make a reverse parent->children
> chain from an arbitrary <pid> (while a parent pid is provided in "PPid"
> field of /proc/<pid>/status).

Looks correct at first glance... But I'll try to recheck. I guess you need
to resend anyway, I bet nobody can recall this patch ;)

However I do not understand the ptrace_may_access() check at all.

> +static struct pid *
> +get_children_pid(struct proc_pid_children_iter *iter, struct pid *pid_prev, loff_t pos)
> +{
> +	struct task_struct *start, *task;
> +	struct pid *pid = NULL;
> +
> +	read_lock(&tasklist_lock);
> +
> +	start = pid_task(iter->pid_start, PIDTYPE_PID);
> +	if (!start)
> +		goto out;
> +
> +	/*
> +	 * Lets try to continue searching this would speed
> +	 * search significantly.
> +	 */
> +	if (pid_prev) {
> +		task = pid_task(pid_prev, PIDTYPE_PID);
> +		if (task && task->real_parent == start &&
> +		    !(list_empty(&task->sibling))) {
> +			/*
> +			 * OK, ltes try the fastpath, we might
> +			 * miss some freshly created children
> +			 * here, but it was never promised to be
> +			 * accurate.
> +			 *
> +			 * Also note if we have not enough rights
> +			 * to access the next children pid we simply
> +			 * fall into slow-search version.
> +			 */

Why we should try the slow-search path if ptrace_may_access() fails?

> +			if (!list_is_last(&task->sibling, &start->children)) {
> +				task = list_first_entry(&task->sibling,
> +							struct task_struct, sibling);
> +				if (ptrace_may_access(task, PTRACE_MODE_READ)) {
> +					pid = get_pid(task_pid(task));
> +					goto out;
> +				}
> +			} else
> +				goto out;
> +		}
> +	}

Well, this is cosmetic, but imho

			if (list_is_last(...))
				goto out;

			task = list_first_entry(...);
			...

looks better.


> +	list_for_each_entry(task, &start->children, sibling) {
> +		if (pos-- == 0) {
> +			if (ptrace_may_access(task, PTRACE_MODE_READ)) {
> +				pid = get_pid(task_pid(task));
> +				goto out;
> +			} else {
> +				/* Maybe we success with the next children */
> +				pos++;

Again. I simply can't understand what ptrace_may_access() actually
means. Why do we use the possible child, not parent?

IOW. I have no idea if we really need any security check at all.
You can find the children pids without this patch anyway via.
grep PPid /proc/*/status.

But if you want ptrace_may_access/whatever, you should check
ptrace_may_access(start), no?

Oleg.

