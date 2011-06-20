Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab1FTUSa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 16:18:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64428 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789Ab1FTUS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 16:18:28 -0400
Date: Mon, 20 Jun 2011 22:16:03 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, hch@infradead.org,
        John Johansen <john.johansen@canonical.com>,
        Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH 7/7] ptrace: s/tracehook_tracer_task()/ptrace_parent()/
Message-ID: <20110620201603.GA17157@redhat.com>
References: <1308322240-8247-1-git-send-email-tj@kernel.org> <1308322240-8247-8-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308322240-8247-8-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17, Tejun Heo wrote:
>
> tracehook.h is on the way out.  Rename tracehook_tracer_task() to
> ptrace_parent() and move it from tracehook.h to ptrace.h.

I am a bit surpised you decided to keep this helper. Can't we simply
kill it?

OK, we will see. I guess this change is mostly needed to remove yet
another function from tracehook.h.

> @@ -216,7 +216,7 @@ static struct mm_struct *__check_mem_permission(struct task_struct *task)
>  	if (task_is_stopped_or_traced(task)) {
>  		int match;
>  		rcu_read_lock();
> -		match = (tracehook_tracer_task(task) == current);
> +		match = (ptrace_parent(task) == current);
>  		rcu_read_unlock();
>  		if (match && ptrace_may_access(task, PTRACE_MODE_ATTACH))

All we need

	if (task_is_traced(task) && task->parent == current) {
		if (ptrace_may_access()
			return mm;
	}

Of course I do not blame this patch, my only point is that this helper
only adds more confusion imho.




> @@ -67,7 +67,7 @@ static int may_change_ptraced_domain(struct task_struct *task,
>  	int error = 0;
>
>  	rcu_read_lock();
> -	tracer = tracehook_tracer_task(task);
> +	tracer = ptrace_parent(task);
>  	if (tracer) {
>  		/* released below */
>  		cred = get_task_cred(tracer);

Hmm. And then this task_struct is used after we dropped rcu_read_lock().

John, is this correct?

Oleg.

