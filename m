Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127Ab0HQSMo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 14:12:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19373 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758096Ab0HQSMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 14:12:43 -0400
Date: Tue, 17 Aug 2010 20:09:53 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Nick Piggin <npiggin@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.35+vfs-scale: INFO: suspicious rcu_dereference_check()
	usage (kernel/exit.c:1387)
Message-ID: <20100817180953.GA22177@redhat.com>
References: <AANLkTimVbbdW4iFDgc2jDThbh-p3BWPjMogE9NU8YpZr@mail.gmail.com> <AANLkTiniV_jqMi4vN5yw7q-NjsH1WAPgauWqwy9uxO-A@mail.gmail.com> <AANLkTik4x6h-8aR9e_o-O9NcJ0nD2X7O2=MW7ry=+o3u@mail.gmail.com> <31145.1281988884@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31145.1281988884@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16, David Howells wrote:
>
> Vegard Nossum <vegard.nossum@gmail.com> wrote:
>
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -1386,8 +1386,7 @@ static int wait_task_stopped(struct wait_opts *wo,
>  	if (!unlikely(wo->wo_flags & WNOWAIT))
>  		*p_code = 0;
>
> -	/* don't need the RCU readlock here as we're holding a spinlock */
> -	uid = __task_cred(p)->uid;
> +	uid = task_uid(p);
>  unlock_sig:
>  	spin_unlock_irq(&p->sighand->siglock);
>  	if (!exit_code)
> @@ -1460,7 +1459,7 @@ static int wait_task_continued(struct wait_opts *wo, struct task_struct *p)
>  	}
>  	if (!unlikely(wo->wo_flags & WNOWAIT))
>  		p->signal->flags &= ~SIGNAL_STOP_CONTINUED;
> -	uid = __task_cred(p)->uid;
> +	uid = task_uid(p);
>  	spin_unlock_irq(&p->sighand->siglock);
>
>  	pid = task_pid_vnr(p);

Acked-by: Oleg Nesterov <oleg@redhat.com>


Vegard, perhaps you can take care of wait_task_zombie() too?
Of course, if you wish.

Like wait_task_stopped(), it doesn't really need RCU lock. But if
we change it to use task_uid() to shut up rcu_dereference_check(),
then we can kill task_is_dead().

Oleg.

