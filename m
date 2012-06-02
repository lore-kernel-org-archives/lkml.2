Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933378Ab2FBRnM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 13:43:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933335Ab2FBRnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 13:43:11 -0400
Date: Sat, 2 Jun 2012 19:41:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] Avoid dereferencing a possibly NULL mm
Message-ID: <20120602174134.GA13626@redhat.com>
References: <1338656062-25008-1-git-send-email-siddhesh.poyarekar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338656062-25008-1-git-send-email-siddhesh.poyarekar@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02, Siddhesh Poyarekar wrote:
>
> The NULL check for mm in exit_mm occurs after mm_release is
> called. This looks wrong because mm_release dereferences mm:
>
> ...
>                 if (!(tsk->flags & PF_SIGNALED) &&
>                     atomic_read(&mm->mm_users) > 1) {
>                         /*
> ...

Yes, this looks wrong, but the task without ->mm shouldn't have
->clear_child_tid != NULL, so this is harmless.

> This dereference seems unsafe and hence is fixed by moving the NULL
> check above mm_release.

And this is wrong,

> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -640,9 +640,11 @@ static void exit_mm(struct task_struct * tsk)
>  	struct mm_struct *mm = tsk->mm;
>  	struct core_state *core_state;
>
> -	mm_release(tsk, mm);
>  	if (!mm)
>  		return;
> +
> +	mm_release(tsk, mm);
> +

mm_release()->complete_vfork_done() should be called even if
->mm == NULL. See kthread_stop().

Probably this needs some cleanups or comments, but lets do
this on top of pending fixes in -mm tree.

Oleg.

