Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab1HQL6m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 07:58:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079Ab1HQL6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 07:58:40 -0400
Date: Wed, 17 Aug 2011 13:55:43 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lennart@poettering.net, kay.sievers@vrfy.org,
        linux-man@vger.kernel.org, roland@hack.frob.com,
        torvalds@linux-foundation.org
Subject: Re: +
	prctl-add-pr_setget_child_reaper-to-allow-simple-process-supervision
	.patch added to -mm tree
Message-ID: <20110817115543.GA8745@redhat.com>
References: <201108162011.p7GKBcY0023134@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108162011.p7GKBcY0023134@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16, Andrew Morton wrote:
>
> From: Lennart Poettering <lennart@poettering.net>
>
> Userspace service managers/supervisors need to track their started
> services.  Many services daemonize by double-forking and get implicitely
> re-parented to PID 1.  The process manager will no longer be able to
> receive the SIGCHLD signals for them.
>
> With this prctl, a service manager can mark itself as a sort of 'sub-init'
> process, able to stay as the parent process for all processes created by
> the started services.  All SIGCHLD signals will be delivered to the
> service manager.

I try to never argue with the new features. But to be honest, this
doesn't look very good to me.

OK, a service manager M does prctl(PR_SET_CHILD_REAPER), then it forks
a service X which forks another child C and exits. Then C exits and
notifies M.

But. How can M know that the service X should be restarted? It only
knows the pid. What if wait(WEXITED) succeeds because C in turn does
fork + exit? What M has 2 or more services?




Anyway, the implementation is certainly buggy.

> @@ -1296,6 +1296,8 @@ struct task_struct {
>  				 * execve */
>  	unsigned in_iowait:1;
>
> +	/* Reparent child processes to this process instead of pid 1. */
> +	unsigned child_reaper:1;

First of all - this is already very wrong imho. This should be
per-process, not per-thread.

> +	/* find the first ancestor which is marked as child_reaper */
> +	for (reaper = father->parent;
> +	     reaper != &init_task && reaper != pid_ns->child_reaper;
> +	     reaper = reaper->parent)

This loop can never reach init_task/child_reaper and crash the kernel.
For example, father->parent can point to init_task's sub-thread.

OTOH you shouldn't use init_task at all.

Also. You shouldn't do this if the sub-namespace init exits, this is
wrong.

> +		if (reaper->child_reaper)
> +			return reaper;

No, we can't blindly return this task, it can be dead/exiting. More
precisely, we must not do this if it has already passed
forget_original_parent(). That is why the code above checks PF_EXITING.

Oleg.

