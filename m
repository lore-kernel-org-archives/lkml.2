Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546Ab0DMSiW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 14:38:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002Ab0DMSiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 14:38:21 -0400
Date: Tue, 13 Apr 2010 20:35:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH v2 7/11] Uprobes Implementation
Message-ID: <20100413183537.GA17538@redhat.com>
References: <20100331155106.4181.50759.sendpatchset@localhost6.localdomain6> <20100331155228.4181.61294.sendpatchset@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100331155228.4181.61294.sendpatchset@localhost6.localdomain6>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31, Srikar Dronamraju wrote:
>
> --- /dev/null
> +++ b/kernel/uprobes.c
> ...
> +static struct uprobe_process *find_uprocess(struct pid *tg_leader)
> +{
> +	struct uprobe_process *uproc;
> +	struct task_struct *tsk = get_pid_task(tg_leader, PIDTYPE_PID);
> +
> +	if (!tsk)
> +		return NULL;
> +
> +	if (!tsk->utask || !tsk->utask->uproc) {
> +		put_task_struct(tsk);
> +		return NULL;
> +	}
> +
> +	uproc = tsk->utask->uproc;
> +	BUG_ON(uproc->tg_leader != tg_leader);
> +	atomic_inc(&uproc->refcount);
> +	put_task_struct(tsk);
> +	return uproc;

Looks like, this doesn't need get/put task_struct, you could just
use pid_task() under rcu_read_lock().

> +static void cleanup_uprocess(struct uprobe_process *uproc,
> +					struct task_struct *start)
> +{
> +	struct task_struct *tsk = start;
> +
> +	if (!start)
> +		return;
> +
> +	rcu_read_lock();
> +	do {
> +		if (tsk->utask) {
> +			kfree(tsk->utask);
> +			tsk->utask = NULL;
> +		}
> +		tsk = next_thread(tsk);

This doesn't look right. We can't trust ->thread_group list even under
rcu_read_lock(). The task can exit and __exit_signal() can remove it
from ->thread_group list before we take rcu_read_lock().

> +static struct uprobe_task *add_utask(struct task_struct *t,
> +					struct uprobe_process *uproc)
> +{
> +	struct uprobe_task *utask;
> +
> +	if (!t)
> +		return NULL;
> +	utask = kzalloc(sizeof *utask, GFP_USER);
> +	if (unlikely(utask == NULL))
> +		return ERR_PTR(-ENOMEM);
> +
> +	utask->uproc = uproc;
> +	utask->active_ppt = NULL;
> +	t->utask = utask;
> +	atomic_inc(&uproc->refcount);
> +
> +	return utask;
> +}

This is called by create_uprocess(). Who will free t->utask if t has
already passed tracehook_report_exit() ?

> +static struct task_struct *find_next_thread(struct uprobe_process *uproc,
> +						struct task_struct *start)
> +{
> +	struct task_struct *next_t = NULL;
> +
> +	rcu_read_lock();
> +	if (start) {
> +		struct task_struct *t = start;
> +
> +		do {
> +			if (unlikely(t->flags & PF_EXITING))
> +				goto dont_add;

not sure I understand this check. Somehow we should prevent the races
with tracehook_report_exit/tracehook_report_exec, but PF_EXITING can't
help ?

> +dont_add:
> +			t = next_thread(t);
> +		} while (t != start);

again, this doesn't look right. Btw, I'd suggest to use while_each_thread().

> +static struct uprobe_process *create_uprocess(struct pid *tg_leader)
> +{
> ...
> +	/*
> +	 * Create and populate one utask per thread in this process.  We
> +	 * can't call add_utask() while holding RCU lock, so we:
> +	 *	1. rcu_read_lock()
> +	 *	2. Find the next thread, add_me, in this process that's not
> +	 *	having a utask struct allocated.
> +	 *	3. rcu_read_unlock()
> +	 *	4. add_utask(add_me, uproc)
> +	 *	Repeat 1-4 'til we have utasks for all threads.
> +	 */
> +	cur_t = get_pid_task(tg_leader, PIDTYPE_PID);
> +	do {
> +		utask = add_utask(cur_t, uproc);
> +		if (IS_ERR(utask)) {
> +			err = PTR_ERR(utask);
> +			goto fail;
> +		}
> +		add_me = find_next_thread(uproc, cur_t);
> +		put_task_struct(cur_t);
> +		cur_t = add_me;
> +	} while (add_me != NULL);

can't we race with clone(CLONE_THREAD) and miss the new thread? Probably
I missed something, but afaics we need some barriers to ensure that either
tracehook_report_clone() sees current->utask != NULL or find_next_thread()
sees the new thread in ->thread_group.

> +static struct pid *get_tg_leader(pid_t p)
> +{
> +	struct pid *pid = NULL;
> +
> +	rcu_read_lock();
> +	if (current->nsproxy)
> +		pid = find_vpid(p);

Is it really possible to call register/unregister with nsproxy == NULL?

> +	if (pid) {
> +		struct task_struct *t = pid_task(pid, PIDTYPE_PID);
> +
> +		if (!t || unlikely(t->flags & PF_EXITING))

Why do we check PF_EXITING?

> +int register_uprobe(struct uprobe *u)
> +{
> +	struct uprobe_process *uproc;
> +	struct uprobe_probept *ppt;
> +	struct pid *p;
> +	int ret = 0;
> +
> +	if (!u || !u->handler)
> +		return -EINVAL;
> +
> +	p = get_tg_leader(u->pid);
> +	if (!p)
> +		return -ESRCH;
> +
> +
> +	/* Get the uprobe_process for this pid, or make a new one. */
> +	mutex_lock(&uprobe_mutex);
> +	uproc = find_uprocess(p);
> +
> +	if (!uproc) {
> +		uproc = create_uprocess(p);
> +		if (IS_ERR(uproc)) {
> +			ret = (int) PTR_ERR(uproc);
> +			mutex_unlock(&uprobe_mutex);
> +			goto fail_tsk;
> +		}
> +	}
> +	mutex_unlock(&uprobe_mutex);
> +	mutex_lock(&uproc->mutex);
> +
> +	if (uproc->n_ppts >= MAX_USER_BKPT_XOL_SLOTS)
> +		goto fail_uproc;
> +
> +	ret = xol_validate_vaddr(p, u->vaddr, uproc->xol_area);

OK, uproc and p can't go away. But why it is safe to use pid_task(p) ?

I am looking at 6th patch http://marc.info/?l=linux-kernel&m=127005086102256
and xol_validate_vaddr() calls pid_task() without rcu and doesn't check
the result is not NULL.

We already dropped uprobe_mutex, can't this task exit?

> +void uprobe_handle_clone(unsigned long clone_flags,
> +				struct task_struct *child)
> +{
> +	struct uprobe_process *uproc;
> +	struct uprobe_task *ptask, *ctask;
> +
> +	ptask = current->utask;
> +	if (!ptask)
> +		return;
> +
> +	uproc = ptask->uproc;
> +
> +	if (clone_flags & CLONE_THREAD) {
> +		mutex_lock(&uprobe_mutex);
> +		/* New thread in the same process. */
> +		ctask = child->utask;
> +		if (unlikely(ctask)) {
> +			/*
> +			 * create_uprocess() ran just as this clone
> +			 * happened, and has already accounted for the
> +			 * new child.
> +			 */
> +		} else
> +			ctask = add_utask(child, uproc);

This looks a bit strange. Why do we need "ctask" at all? It is not used,
you could just do

	if (likely(!child->utask))
		add_utask(child, uproc);

The same for "else" branch.

> +	} else {
> +		struct uprobe_probept *ppt;
> +		int ret;
> +
> +		/*
> +		 * New process spawned by parent.  Remove the probepoints
> +		 * in the child's text.
> +		 *
> +		 * We also hold the uproc->mutex for the parent - so no
> +		 * new uprobes will be registered 'til we return.
> +		 */
> +		mutex_lock(&uproc->mutex);
> +		ctask = child->utask;
> +		if (unlikely(ctask)) {
> +			/*
> +			 * create_uprocess() ran just as this fork
> +			 * happened, and has already created a new utask.
> +			 */
> +			mutex_unlock(&uproc->mutex);
> +			return;
> +		}
> +		list_for_each_entry(ppt, &uproc->uprobe_list, ut_node) {
> +			ret = user_bkpt_remove_bkpt(child, &ppt->user_bkpt);

OK, iiuc this should restore the original instruction, right?

But what about clone(CLONE_VM)? In this case this child shares ->mm with
parent.

Oleg.

