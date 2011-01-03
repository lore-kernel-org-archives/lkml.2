Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835Ab1ACIV0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 03:21:26 -0500
Received: from canuck.infradead.org ([134.117.69.58]:42067 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab1ACIVZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 03:21:25 -0500
Subject: Re: [PATCH] Re: [PATCH] sched, cgroup: Use exit hook to avoid
 use-after-free crash
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, Miklos Vajna <vmiklos@frugalware.org>,
        shenghui <crosslonelyover@gmail.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
        Paul Turner <pjt@google.com>, Yong Zhang <yong.zhang0@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>
In-Reply-To: <1293784350.6839.2.camel@marge.simson.net>
References: <AANLkTi=1GMKF4emms0Qpx31=xk-FZXOTaeONmCohzWb2@mail.gmail.com>
	 <1293106330.2170.618.camel@laptop> <1293107624.2170.642.camel@laptop>
	 <1293128670.2170.748.camel@laptop>
	 <1293132304.6798.6.camel@marge.simson.net>
	 <1293132862.25981.22.camel@laptop>
	 <1293187425.7138.2.camel@marge.simson.net>
	 <1293188091.25981.200.camel@laptop>
	 <1293192999.18035.4.camel@marge.simson.net>
	 <1293206353.29444.205.camel@laptop>  <20101229152522.GA23825@elte.hu>
	 <1293784350.6839.2.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 03 Jan 2011 09:21:25 +0100
Message-ID: <1294042885.2016.11.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-31 at 09:32 +0100, Mike Galbraith wrote:

> sched: fix autogroup reference leak and cpu_cgroup_exit() explosion
> 
> In the event of a fork failure, the new cpu_cgroup_exit() method tries to
> move an unhashed task.  Since PF_EXITING isn't set in that case, autogroup
> will dig aground in a freed signal_struct.  Neither cgroups nor autogroup
> has anything it needs to do with this shade, so don't go there.
> 
> This also uncovered a struct autogroup reference leak. copy_process() was
> simply freeing vs putting the signal_struct, stranding a reference.
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> 
> ---
>  kernel/fork.c  |    2 +-
>  kernel/sched.c |   10 ++++++++++
>  2 files changed, 11 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.37.git/kernel/fork.c
> ===================================================================
> --- linux-2.6.37.git.orig/kernel/fork.c
> +++ linux-2.6.37.git/kernel/fork.c
> @@ -1318,7 +1318,7 @@ bad_fork_cleanup_mm:
>  	}
>  bad_fork_cleanup_signal:
>  	if (!(clone_flags & CLONE_THREAD))
> -		free_signal_struct(p->signal);
> +		put_signal_struct(p->signal);
>  bad_fork_cleanup_sighand:
>  	__cleanup_sighand(p->sighand);
>  bad_fork_cleanup_fs:
> Index: linux-2.6.37.git/kernel/sched.c
> ===================================================================
> --- linux-2.6.37.git.orig/kernel/sched.c
> +++ linux-2.6.37.git/kernel/sched.c
> @@ -9193,6 +9193,16 @@ cpu_cgroup_attach(struct cgroup_subsys *
>  static void
>  cpu_cgroup_exit(struct cgroup_subsys *ss, struct task_struct *task)
>  {
> +	/*
> +	 * cgroup_exit() is called in the copy_process failure path.
> +	 * The task isn't hashed, and we don't want to make autogroup
> +	 * dig into a freed signal_struct, so just go away.
> +	 *
> +	 * XXX: why are cgroup methods diddling unattached tasks?
> +	 */
> +	if (!(task->flags & PF_EXITING))
> +		return;
> +
>  	sched_move_task(task);
>  }

Ah, that looks plausible. I've folded this chunk into my patch and kept
your fork-fail mod in a separate patch.
