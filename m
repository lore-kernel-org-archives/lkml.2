Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab1K0Rjb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 12:39:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751662Ab1K0Rja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 12:39:30 -0500
Date: Sun, 27 Nov 2011 18:34:30 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>,
        Pedro Alves <pedro@codesourcery.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        James Bottomley <jbottomley@parallels.com>
Subject: Re: [RFC][PATCH 0/3] fork: Add the ability to create tasks with
	given pids
Message-ID: <20111127173430.GB5674@redhat.com>
References: <4EC4F2FB.408@parallels.com> <201111221204.39235.pedro@codesourcery.com> <20111122153326.GD322@google.com> <201111231620.45440.pedro@codesourcery.com> <20111123162417.GE25780@google.com> <4ECD3946.1030503@parallels.com> <4ECD542C.7010705@parallels.com> <20111124173121.GA23260@redhat.com> <4ECF6AA0.80006@parallels.com> <4ED205D1.5060407@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ED205D1.5060407@openvz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27, Konstantin Khlebnikov wrote:
>
> We can add flag to sys_wait4(), and stash pid in wait_task_zombie(), right before release_task()
> code will looks something like this:
>
> -       if (p != NULL)
> +       if (p != NULL) {
> +               if ((wo->wo_flags & WCATCHPID) && !current->pid_stash) {
> +                       struct pid *pid = task_pid(p);
> +
> +                       pid->flags |= PID_STASHED;
> +                       current->pid_stash = get_pid(pid);
> +               }
>                 release_task(p);
> +       }
>
> And next fork() creates child with the same pid.
> So, struct pid will work like boomerang =)

Like PR_RESERVE_PID, this can only help if the tracee (or whatever)
is single-threaded and it is the natural child.

Personally I do not think such a limited interface makes sense.

Oleg.

