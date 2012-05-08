Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927Ab2EHWuW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 18:50:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36264 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab2EHWuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 18:50:21 -0400
Date: Tue, 8 May 2012 15:50:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 2/3] pidns: Guarantee that the pidns init will be the
 last pidns process reaped.
Message-Id: <20120508155020.d96a03d1.akpm@linux-foundation.org>
In-Reply-To: <8762c87rrd.fsf_-_@xmission.com>
References: <1335604790.5995.22.camel@marge.simpson.net>
	<20120428142605.GA20248@redhat.com>
	<m14ns355ru.fsf@fess.ebiederm.org>
	<20120429165846.GA19054@redhat.com>
	<1335754867.17899.4.camel@marge.simpson.net>
	<m1zk9rmyh4.fsf@fess.ebiederm.org>
	<20120501134214.f6b44f4a.akpm@linux-foundation.org>
	<87havs7rvv.fsf_-_@xmission.com>
	<8762c87rrd.fsf_-_@xmission.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 06 May 2012 17:35:02 -0700
ebiederm@xmission.com (Eric W. Biederman) wrote:

> 
> This change extends the thread group zombie leader logic to work for pid
> namespaces.  The task with pid 1 is declared the pid namespace leader.
> A pid namespace with no more processes is detected by observing that the
> init task is a zombie in an empty thread group, and the the init task
> has no children.
> 
> Instead of moving lingering EXIT_DEAD tasks off of init's ->children
> list we now block init from exiting until those children have self
> reaped and have removed themselves.  Which guarantees that the init task
> is the last task in a pid namespace to be reaped.
> 
> ...
>
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -164,6 +164,16 @@ static void delayed_put_task_struct(struct rcu_head *rhp)
>  	put_task_struct(tsk);
>  }
>  
> +static bool pidns_leader(struct task_struct *tsk)
> +{
> +	return is_child_reaper(task_pid(tsk));
> +}
> +
> +static bool delay_pidns_leader(struct task_struct *tsk)
> +{
> +	return pidns_leader(tsk) &&
> +	       (!thread_group_empty(tsk) || !list_empty(&tsk->children));
> +}

The code would be significantly easier to understand if the above two
functions were documented.

What is the significance of pidns leadership, and why might callers
want to know this?

delay_pidns_leader() seems poorly named, which doesn't help.  I guess
it's trying to say "should delay the pidns leader".  But even then, it
doesn't describe *why* the leader should be delayed.

Have a think about it, please?

>
> ...
>
