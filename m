Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844Ab0FTSbn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 14:31:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756738Ab0FTSbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 14:31:38 -0400
Date: Sun, 20 Jun 2010 20:29:48 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Louis Rilling <louis.rilling@kerlabs.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Linux Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org, Daniel Lezcano <dlezcano@fr.ibm.com>
Subject: Re: [PATCH 1/6] pid:  Remove the child_reaper special case in
	init/main.c
Message-ID: <20100620182948.GB3258@redhat.com>
References: <20100617212003.GA4182@redhat.com> <20100618082033.GD16877@hawkmoon.kerlabs.com> <20100618111554.GA3252@redhat.com> <20100618160849.GA7404@redhat.com> <20100618173320.GG16877@hawkmoon.kerlabs.com> <20100618175541.GA13680@redhat.com> <20100618212355.GA29478@redhat.com> <20100619190840.GA3424@redhat.com> <m1pqzmqema.fsf_-_@fess.ebiederm.org> <m1ljaaqejm.fsf_-_@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ljaaqejm.fsf_-_@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20, Eric W. Biederman wrote:
>
> It turns out that the existing assignment in copy_process of
> the child_reaper can handle the initial assignment of child_reaper
> we just need to generalize the test in kernel/fork.c
>
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  init/main.c   |    9 ---------
>  kernel/fork.c |    2 +-
>  2 files changed, 1 insertions(+), 10 deletions(-)
>
> diff --git a/init/main.c b/init/main.c
> index 3bdb152..38f7edc 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -865,15 +865,6 @@ static int __init kernel_init(void * unused)
>  	 * init can run on any cpu.
>  	 */
>  	set_cpus_allowed_ptr(current, cpu_all_mask);
> -	/*
> -	 * Tell the world that we're going to be the grim
> -	 * reaper of innocent orphaned children.
> -	 *
> -	 * We don't want people to have to make incorrect
> -	 * assumptions about where in the task array this
> -	 * can be found.
> -	 */
> -	init_pid_ns.child_reaper = current;
>
>  	cad_pid = task_pid(current);
>
> diff --git a/kernel/fork.c b/kernel/fork.c
> index b6cce14..8b85b17 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1263,7 +1263,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  		tracehook_finish_clone(p, clone_flags, trace);
>
>  		if (thread_group_leader(p)) {
> -			if (clone_flags & CLONE_NEWPID)
> +			if (pid->numbers[pid->level].nr == 1)
>  				p->nsproxy->pid_ns->child_reaper = p;

I must admit, personally I dislike this change. If it is needed for
the next changes, please explain the need?

Yes, it removes the line from __init function, but it complicates
copy_process(), this doesn't look fair to me ;) I agree, the complication
is minor, but still. And, in fact, to me this change hides CLONE_NEWPID
from grep.

In fact, I was looking at this code when I did 1/4. And I think it is
better to move it (and perhaps another CLONE_NEWPID check in copy_signal)
into copy_pid_ns() path.

Oleg.

