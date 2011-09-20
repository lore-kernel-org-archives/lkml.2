Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907Ab1ITP3B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 11:29:01 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:57664 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797Ab1ITP27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 11:28:59 -0400
Date: Tue, 20 Sep 2011 08:28:16 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        lkml <linux-kernel@vger.kernel.org>, richard@nod.at,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] creds: kill __task_cred()->task_is_dead() check
Message-ID: <20110920152816.GD2380@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110919214531.GA18085@sergelap>
 <20110920122202.GA26504@redhat.com>
 <20110920124419.GA10759@hallyn.com>
 <20110920134108.GA30749@redhat.com>
 <20110920143920.GA15859@redhat.com>
 <20110920143942.GB15859@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110920143942.GB15859@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 04:39:42PM +0200, Oleg Nesterov wrote:
> >From 8f92054e commit:
> 
>     Instead, add the following validation condition:
> 
>         task->exit_state >= 0
> 
>     to permit the access if the target task is dead and therefore unable to change
>     its own credentials.
> 
> OK, but afaics currently this can only help wait_task_zombie() which
> calls __task_cred() without rcu lock.
> 
> Remove this validation and change wait_task_zombie() to use task_uid()
> instead. This means we do rcu_read_lock() only to shut up the lockdep,
> but we already do the same in, say, wait_task_stopped().
> 
> Unfortunately, we can't kill task_is_dead() right now, it has already
> found the users in drivers/staging/, and I bet the usage is wrong.

>From a first quick scan...

							Thanx, Paul

> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
> 
>  include/linux/cred.h |    3 +--
>  kernel/exit.c        |    2 +-
>  2 files changed, 2 insertions(+), 3 deletions(-)
> 
> --- 3.1/include/linux/cred.h~1_kill_task_is_dead	2011-09-20 16:28:22.000000000 +0200
> +++ 3.1/include/linux/cred.h	2011-09-20 16:28:47.000000000 +0200
> @@ -284,8 +284,7 @@ static inline void put_cred(const struct
>  #define __task_cred(task)						\
>  	({								\
>  		const struct task_struct *__t = (task);			\
> -		rcu_dereference_check(__t->real_cred,			\
> -				      task_is_dead(__t));		\
> +		rcu_dereference_check(__t->real_cred, 0);		\

The "0" above will make lockdep-RCU complain unconditionally.  My guess
is that you want rcu_dereference_raw().

>  	})
> 
>  /**
> --- 3.1/kernel/exit.c~1_kill_task_is_dead	2011-09-20 16:28:22.000000000 +0200
> +++ 3.1/kernel/exit.c	2011-09-20 16:28:47.000000000 +0200
> @@ -1191,7 +1191,7 @@ static int wait_task_zombie(struct wait_
>  	unsigned long state;
>  	int retval, status, traced;
>  	pid_t pid = task_pid_vnr(p);
> -	uid_t uid = __task_cred(p)->uid;
> +	uid_t uid = task_uid(p);
>  	struct siginfo __user *infop;
> 
>  	if (!likely(wo->wo_flags & WEXITED))
> 
