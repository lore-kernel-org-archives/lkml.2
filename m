Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab2DKKFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 06:05:44 -0400
Received: from out07.mta.xmission.com ([166.70.13.237]:50852 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755718Ab2DKKFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 06:05:39 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
References: <20120410194554.GA7196@redhat.com>
	<20120410194625.GB7196@redhat.com>
Date: Wed, 11 Apr 2012 03:09:27 -0700
In-Reply-To: <20120410194625.GB7196@redhat.com> (Oleg Nesterov's message of
	"Tue, 10 Apr 2012 21:46:25 +0200")
Message-ID: <m1obqyh960.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+k4MXx9CU977whDiumBSaHVev4L//TRMM=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_05 8+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: **
Subject: Re: [PATCH 1/1] creds: kill __task_cred()->task_is_dead() validation
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

A small nit.  The subject should be:
"Remove task_is_dead from __task_cred() validation."
there is no method __task_cred()->task_is_dead().


> commit 8f92054e:
>
>     add the following validation condition:
>
>         task->exit_state >= 0
>
>     to permit the access if the target task is dead and therefore
>     unable to change its own credentials.
>
> OK, but afaics currently this can only help wait_task_zombie() which
> calls __task_cred() without rcu lock.
>
> Remove this validation and change wait_task_zombie() to use task_uid()
> instead. This means we do rcu_read_lock() only to shut up the lockdep,
> but we already do the same in, say, wait_task_stopped().
>
> task_is_dead() should die, task->exit_state != 0 means that this task
> has passed exit_notify(), only do_wait-like code paths should use this.
>
> Unfortunately, we can't kill task_is_dead() right now, it has already
> found the bugy users in drivers/staging/, the fix already exists.

I would say task_is_dead() has already acquired buggy users in
drivers/staging.

As for the patch itself, and the direction of removing task_is_dead().
It looks good from where I sit.

Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>

Eric


> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  include/linux/cred.h |   10 +++-------
>  kernel/exit.c        |    2 +-
>  2 files changed, 4 insertions(+), 8 deletions(-)
>
> diff --git a/include/linux/cred.h b/include/linux/cred.h
> index adadf71..1b64c72 100644
> --- a/include/linux/cred.h
> +++ b/include/linux/cred.h
> @@ -276,17 +276,13 @@ static inline void put_cred(const struct cred *_cred)
>   * @task: The task to query
>   *
>   * Access the objective credentials of a task.  The caller must hold the RCU
> - * readlock or the task must be dead and unable to change its own credentials.
> + * readlock.
>   *
>   * The result of this function should not be passed directly to get_cred();
>   * rather get_task_cred() should be used instead.
>   */
> -#define __task_cred(task)						\
> -	({								\
> -		const struct task_struct *__t = (task);			\
> -		rcu_dereference_check(__t->real_cred,			\
> -				      task_is_dead(__t));		\
> -	})
> +#define __task_cred(task)	\
> +	rcu_dereference((task)->real_cred)
>  
>  /**
>   * get_current_cred - Get the current task's subjective credentials
> diff --git a/kernel/exit.c b/kernel/exit.c
> index 4b4042f..7b36288 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -1214,7 +1213,7 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
>  	unsigned long state;
>  	int retval, status, traced;
>  	pid_t pid = task_pid_vnr(p);
> -	uid_t uid = __task_cred(p)->uid;
> +	uid_t uid = task_uid(p);
>  	struct siginfo __user *infop;
>  
>  	if (!likely(wo->wo_flags & WEXITED))
