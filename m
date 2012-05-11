Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945982Ab2EKSay (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 14:30:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932622Ab2EKSaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 14:30:52 -0400
Date: Fri, 11 May 2012 18:51:28 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: torvalds@linux-foundation.org, hpa@zytor.com, mingo@elte.hu,
        linux-kernel@vger.kernel.org, suresh@aristanetworks.com
Subject: Re: [PATCH v2 2/4] coredump: ensure the fpu state is flushed for
	proper multi-threaded core dump
Message-ID: <20120511165128.GA21511@redhat.com>
References: <CA+55aFwNST_Lhou1h9JWkg348BET7CbqNX50XYPOFNbXioXdxg@mail.gmail.com> <1336692811-30576-1-git-send-email-suresh.b.siddha@intel.com> <1336692811-30576-2-git-send-email-suresh.b.siddha@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336692811-30576-2-git-send-email-suresh.b.siddha@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10, Suresh Siddha wrote:
>
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1930,8 +1930,21 @@ static int coredump_wait(int exit_code, struct core_state *core_state)
>  		core_waiters = zap_threads(tsk, mm, core_state, exit_code);
>  	up_write(&mm->mmap_sem);
>
> -	if (core_waiters > 0)
> +	if (core_waiters > 0) {
> +		struct core_thread *ptr;
> +
>  		wait_for_completion(&core_state->startup);
> +		/*
> +		 * Wait for all the threads to become inactive, so that
> +		 * all the thread context (extended register state, like
> +		 * fpu etc) gets copied to the memory.
> +		 */
> +		ptr = core_state->dumper.next;
> +		while (ptr != NULL) {
> +			wait_task_inactive(ptr->task, 0);
> +			ptr = ptr->next;
> +		}
> +	}

OK, but this adds the unnecessary penalty if we are not going to dump
the core.

Perhaps it makes sense to create a separate helper and call it from
do_coredump() right before "retval = binfmt->core_dump(&cprm)" ?

This also increases the chance that wait_task_inactive() won't actually
wait.

Oleg.

