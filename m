Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab2BQAfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 19:35:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39367 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800Ab2BQAfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 19:35:46 -0500
Date: Thu, 16 Feb 2012 16:35:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: apw@canonical.com, arjan@linux.intel.com, fhrbata@redhat.com,
        john.johansen@canonical.com, penguin-kernel@I-love.SAKURA.ne.jp,
        rientjes@google.com, rusty@rustcorp.com.au, tj@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] introduce complete_vfork_done()
Message-Id: <20120216163544.4e41e5a5.akpm@linux-foundation.org>
In-Reply-To: <20120216172647.GB30393@redhat.com>
References: <20120214164709.GA21178@redhat.com>
	<20120214164914.GF21185@redhat.com>
	<20120215123049.6e938eed.akpm@linux-foundation.org>
	<20120216150429.GB11953@redhat.com>
	<20120216172626.GA30393@redhat.com>
	<20120216172647.GB30393@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Feb 2012 18:26:47 +0100
Oleg Nesterov <oleg@redhat.com> wrote:

> No functional changes.
> 
> Move the clear-and-complete-vfork_done code into the new trivial
> helper, complete_vfork_done().
> 
> ...
>
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1915,7 +1915,6 @@ static int coredump_wait(int exit_code, struct core_state *core_state)
>  {
>  	struct task_struct *tsk = current;
>  	struct mm_struct *mm = tsk->mm;
> -	struct completion *vfork_done;
>  	int core_waiters = -EBUSY;
>  
>  	init_completion(&core_state->startup);
> @@ -1934,11 +1933,8 @@ static int coredump_wait(int exit_code, struct core_state *core_state)
>  	 * Make sure nobody is waiting for us to release the VM,
>  	 * otherwise we can deadlock when we wait on each other
>  	 */
> -	vfork_done = tsk->vfork_done;
> -	if (vfork_done) {
> -		tsk->vfork_done = NULL;
> -		complete(vfork_done);
> -	}
> +	if (tsk->vfork_done)
> +		complete_vfork_done(tsk);
>  
>  	if (core_waiters)
>  		wait_for_completion(&core_state->startup);
>
> ...
>
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -667,6 +667,14 @@ struct mm_struct *mm_access(struct task_struct *task, unsigned int mode)
>  	return mm;
>  }
>  
> +void complete_vfork_done(struct task_struct *tsk)
> +{
> +	struct completion *vfork_done = tsk->vfork_done;
> +
> +	tsk->vfork_done = NULL;
> +	complete(vfork_done);
> +}
> +
>  /* Please note the differences between mmput and mm_release.
>   * mmput is called whenever we stop holding onto a mm_struct,
>   * error success whatever.
> @@ -682,8 +690,6 @@ struct mm_struct *mm_access(struct task_struct *task, unsigned int mode)
>   */
>  void mm_release(struct task_struct *tsk, struct mm_struct *mm)
>  {
> -	struct completion *vfork_done = tsk->vfork_done;
> -
>  	/* Get rid of any futexes when releasing the mm */
>  #ifdef CONFIG_FUTEX
>  	if (unlikely(tsk->robust_list)) {
> @@ -703,11 +709,8 @@ void mm_release(struct task_struct *tsk, struct mm_struct *mm)
>  	/* Get rid of any cached register state */
>  	deactivate_mm(tsk, mm);
>  
> -	/* notify parent sleeping on vfork() */
> -	if (vfork_done) {
> -		tsk->vfork_done = NULL;
> -		complete(vfork_done);
> -	}
> +	if (tsk->vfork_done)
> +		complete_vfork_done(tsk);

This all looks somewhat smelly.

- Why do we zero tsk->vfork_done in this manner?  It *looks* like
  it's done to prevent the kernel from running complete() twice against
  a single task in a race situation.  If this is the case then it's
  pretty lame, isn't it?  We'd need external locking to firm that up
  and I'm not seeing it.

- Moving the test for non-null tsk->vfork_done into
  complete_vfork_done() would simplify things a bit?

- The complete_vfork_done() interface isn't wonderful.  What prevents
  tsk from getting freed?  Presumably the caller must have pinned it in
  some fashion?  Or must hold some lock?  Or it's always run against
  `current', in which case it would be clearer to not pass the
  task_struct arg at all?

