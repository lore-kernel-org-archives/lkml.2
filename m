Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab1CUP24 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 11:28:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287Ab1CUP2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 11:28:53 -0400
Date: Mon, 21 Mar 2011 16:19:41 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 3/8] job control: Fix ptracer wait(2) hang and explain
	notask_error clearing
Message-ID: <20110321151941.GA20917@redhat.com>
References: <1299614199-25142-1-git-send-email-tj@kernel.org> <1299614199-25142-4-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299614199-25142-4-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08, Tejun Heo wrote:
>
>   static void *nooper(void *arg)
>   {
> 	  pause();
> 	  return NULL;
>   }
>
>   int main(void)
>   {
> 	  const struct timespec ts1s = { .tv_sec = 1 };
> 	  pid_t tracee, tracer;
> 	  siginfo_t si;
>
> 	  tracee = fork();
> 	  if (tracee == 0) {
> 		  pthread_t thr;
>
> 		  pthread_create(&thr, NULL, nooper, NULL);
> 		  nanosleep(&ts1s, NULL);
> 		  printf("tracee exiting\n");
> 		  pthread_exit(NULL);	/* let subthread run */
> 	  }
>
> 	  tracer = fork();
> 	  if (tracer == 0) {
> 		  ptrace(PTRACE_ATTACH, tracee, NULL, NULL);
> 		  while (1) {
> 			  if (waitid(P_PID, tracee, &si, WSTOPPED) < 0) {
> 				  perror("waitid");
> 				  break;
> 			  }
> 			  ptrace(PTRACE_CONT, tracee, NULL,
> 				 (void *)(long)si.si_status);
> 		  }
> 		  return 0;
> 	  }
>
> 	  waitid(P_PID, tracer, &si, WEXITED);
> 	  kill(tracee, SIGKILL);
> 	  return 0;
>   }
>
> Before the patch, after the tracee becomes a zombie, the tracer's
> waitid(WSTOPPED) never returns and the program doesn't terminate.

Yes. The program should terminate after nooper() exits. Agreed, this
looks strange.

> After the patch, tracee exiting triggers waitid() to fail.
>
>   tracee exiting
>   waitid: No child processes

OK, but

> @@ -1550,17 +1550,41 @@ static int wait_consider_task(struct wait_opts *wo, int ptrace,
>  		return 0;
>  	}
>
> -	/*
> -	 * We don't reap group leaders with subthreads.
> -	 */
> -	if (p->exit_state == EXIT_ZOMBIE && !delay_group_leader(p))
> -		return wait_task_zombie(wo, p);
> +	/* slay zombie? */
> +	if (p->exit_state == EXIT_ZOMBIE) {
> +		/* we don't reap group leaders with subthreads */
> +		if (!delay_group_leader(p))
> +			return wait_task_zombie(wo, p);
>
> -	/*
> -	 * It's stopped or running now, so it might
> -	 * later continue, exit, or stop again.
> -	 */
> -	wo->notask_error = 0;
> +		/*
> +		 * Allow access to stopped/continued state via zombie by
> +		 * falling through.  Clearing of notask_error is complex.
> +		 *
> +		 * When !@ptrace:
> +		 *
> +		 * If WEXITED is set, notask_error should naturally be
> +		 * cleared.  If not, subset of WSTOPPED|WCONTINUED is set,
> +		 * so, if there are live subthreads, there are events to
> +		 * wait for.  If all subthreads are dead, it's still safe
> +		 * to clear - this function will be called again in finite
> +		 * amount time once all the subthreads are released and
> +		 * will then return without clearing.
> +		 *
> +		 * When @ptrace:
> +		 *
> +		 * Stopped state is per-task and thus can't change once the
> +		 * target task dies, so notask_error should be cleared only
> +		 * if WCONTINUED is set.
> +		 */
> +		if (likely(!ptrace) || (wo->wo_flags & WCONTINUED))
> +			wo->notask_error = 0;

I don't understand this part. Suppose that this task is not traced and
its real parent does do_wait(WEXITED). We shouldn't return -ECHLD in
this case (EXIT_ZOMBIE && delay_group_leader()).

If the task is traced and debugger does do_wait(WEXITED) we should not
return -ECHLD too.

So I think this patch is wrong in its current state. Hmm, I just noticed
the comment says "If WEXITED is set, notask_error should ...", but this
is not what the code does?





But the main problem is, I do not think do_wait() should block in this
case, and thus I am starting to think this patch is not "complete".

I mean, we are going to add the user-visible change, and I agree the
current behaviour looks strange. But if we change this code, perhaps
the tracer should ignore delay_group_leader() at all (unless we are
going to do wait_task_zombie) ?

Your test-case could use waitid(WEXITED) instead WSTOPPED with the same
result, it should hang. Why it hangs? The tracee is dead, we can't do
ptrace(PTRACE_DETACH), and we can do nothing until other threads exit.
This looks equally strange.

IOW. Assuming that ptrace == T and WEXITED is set, perhaps we should
do something like this pseudo-code

	if (p->exit_state == EXIT_ZOMBIE) {
		if (!delay_group_leader(p))
			return wait_task_zombie(wo, p);

		ptrace_unlink();
		wait_task_zombie(WNOWAIT);
	}

However. This is another user-visible change, we need another discussion
even if I am right. In particular, it is not clear what should we do
if parent == real_parent. And probably this can confuse gdb, but iirc
gdb already have the problems with the dead leader anyway.

Oleg.

