Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab1EPL66 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 07:58:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753329Ab1EPL65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 07:58:57 -0400
Date: Mon, 16 May 2011 13:57:11 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 4/9] ptrace: relocate set_current_state(TASK_TRACED) in
	ptrace_stop()
Message-ID: <20110516115711.GB4898@redhat.com>
References: <1305301580-9924-1-git-send-email-tj@kernel.org> <1305301580-9924-5-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305301580-9924-5-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13, Tejun Heo wrote:
>
> In ptrace_stop(), after arch hook is done, the task state and jobctl
> bits are updated while holding siglock.  The ordering requirement
> there is that TASK_TRACED is set before JOBCTL_TRAPPING is cleared to
> prevent ptracer waiting on TRAPPING doesn't end up waking up TRACED is
> actually set and sees TASK_RUNNING in wait(2).
>
> Move set_current_state(TASK_TRACED) to the top of the block and
> reorganize comments.  This makes the ordering more obvious
> (TASK_TRACED before other updates)

I am ab bit confused... please see below.

> and helps future updates to group
> stop participation.

OK, so I assume we need this change.

> This patch doesn't cause any functional change.

Agreed, so the patch looks fine.


But the comment looks a bit confusing to me. This is fine, I almost never
read them ;) Just I'd like to ensure I din't miss something.

> @@ -1733,6 +1733,18 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
>  	}
>
>  	/*
> +	 * We're committing to trapping.  TRACED should be visible before
> +	 * TRAPPING is cleared

This looks as if you explain the barrier in set_current_state(). And,
btw, why can't we use __set_current_state() here ?

And. not only TRACED, at least ->exit_code should be visible as well.

IOW. It is not that TRACED should be visible before jobctl &= ~JOBCTL_TRAPPING,
we should correctly update the tracee before __wake_up_sync_key(), and I assume
this is what the comment says.

Correct?

Oleg.

