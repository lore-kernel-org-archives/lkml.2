Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab0HBUkH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 16:40:07 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:45562 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102Ab0HBUkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 16:40:02 -0400
Date: Mon, 2 Aug 2010 13:40:00 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 2/2] CRED: Fix __task_cred()'s lockdep check and banner
 comment
Message-ID: <20100802204000.GH2405@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100729114549.29508.44899.stgit@warthog.procyon.org.uk>
 <20100729114555.29508.4525.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100729114555.29508.4525.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 12:45:55PM +0100, David Howells wrote:
> Fix __task_cred()'s lockdep check by removing the following validation
> condition:
> 
> 	lockdep_tasklist_lock_is_held()
> 
> as commit_creds() does not take the tasklist_lock, and nor do most of the
> functions that call it, so this check is pointless and it can prevent
> detection of the RCU lock not being held if the tasklist_lock is held.
> 
> Instead, add the following validation condition:
> 
> 	task->exit_state >= 0
> 
> to permit the access if the target task is dead and therefore unable to change
> its own credentials.
> 
> 
> Fix __task_cred()'s comment to:
> 
>  (1) discard the bit that says that the caller must prevent the target task
>      from being deleted.  That shouldn't need saying.
> 
>  (2) Add a comment indicating the result of __task_cred() should not be passed
>      directly to get_cred(), but rather than get_task_cred() should be used
>      instead.
> 
> Also put a note into the documentation to enforce this point there too.

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: David Howells <dhowells@redhat.com>
> Acked-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
> 
>  Documentation/credentials.txt |    3 +++
>  include/linux/cred.h          |   15 ++++++++++-----
>  include/linux/sched.h         |    1 +
>  3 files changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/credentials.txt b/Documentation/credentials.txt
> index a2db352..995baf3 100644
> --- a/Documentation/credentials.txt
> +++ b/Documentation/credentials.txt
> @@ -417,6 +417,9 @@ reference on them using:
>  This does all the RCU magic inside of it.  The caller must call put_cred() on
>  the credentials so obtained when they're finished with.
> 
> + [*] Note: The result of __task_cred() should not be passed directly to
> +     get_cred() as this may race with commit_cred().
> +
>  There are a couple of convenience functions to access bits of another task's
>  credentials, hiding the RCU magic from the caller:
> 
> diff --git a/include/linux/cred.h b/include/linux/cred.h
> index ce40cbc..4d2c395 100644
> --- a/include/linux/cred.h
> +++ b/include/linux/cred.h
> @@ -274,13 +274,18 @@ static inline void put_cred(const struct cred *_cred)
>   * @task: The task to query
>   *
>   * Access the objective credentials of a task.  The caller must hold the RCU
> - * readlock.
> + * readlock or the task must be dead and unable to change its own credentials.
>   *
> - * The caller must make sure task doesn't go away, either by holding a ref on
> - * task or by holding tasklist_lock to prevent it from being unlinked.
> + * The result of this function should not be passed directly to get_cred();
> + * rather get_task_cred() should be used instead.
>   */
> -#define __task_cred(task) \
> -	((const struct cred *)(rcu_dereference_check((task)->real_cred, rcu_read_lock_held() || lockdep_tasklist_lock_is_held())))
> +#define __task_cred(task)						\
> +	({								\
> +		const struct task_struct *__t = (task);			\
> +		rcu_dereference_check(__t->real_cred,			\
> +				      rcu_read_lock_held() ||		\
> +				      task_is_dead(__t));		\
> +	})
> 
>  /**
>   * get_current_cred - Get the current task's subjective credentials
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 747fcae..0478888 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -214,6 +214,7 @@ extern char ___assert_task_state[1 - 2*!!(
> 
>  #define task_is_traced(task)	((task->state & __TASK_TRACED) != 0)
>  #define task_is_stopped(task)	((task->state & __TASK_STOPPED) != 0)
> +#define task_is_dead(task)	((task)->exit_state != 0)
>  #define task_is_stopped_or_traced(task)	\
>  			((task->state & (__TASK_STOPPED | __TASK_TRACED)) != 0)
>  #define task_contributes_to_load(task)	\
> 
