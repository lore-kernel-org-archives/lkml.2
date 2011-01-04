Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856Ab1ADPE4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 10:04:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170Ab1ADPEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 10:04:55 -0500
Date: Tue, 4 Jan 2011 15:57:22 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
Subject: Re: [tip:sched/core] sched, autogroup: Fix reference leak
Message-ID: <20110104145722.GA5812@redhat.com>
References: <1293784350.6839.2.camel@marge.simson.net> <tip-101e5f77bf35679809586e250b6c62193d2ed179@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-101e5f77bf35679809586e250b6c62193d2ed179@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04, tip-bot for Mike Galbraith wrote:
>
> The cgroup exit mess also uncovered a struct autogroup reference leak.
> copy_process() was simply freeing vs putting the signal_struct,
> stranding a reference.
>
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Oleg Nesterov <oleg@redhat.com>
> LKML-Reference: <1293784350.6839.2.camel@marge.simson.net>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/fork.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/fork.c b/kernel/fork.c
> index b6f2475..0672444 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1317,7 +1317,7 @@ bad_fork_cleanup_mm:
>  	}
>  bad_fork_cleanup_signal:
>  	if (!(clone_flags & CLONE_THREAD))
> -		free_signal_struct(p->signal);
> +		put_signal_struct(p->signal);

Well, free_signal_struct() was correct. Without CLONE_THREAD
sig->sigcnt must be equal to 1.

But yes, autogroup puts sched_autogroup_exit() into put_signal_struct(),
so this patch looks fine.

Although I must admit, to me it would be more clean to simply move
sched_autogroup_exit() from put_signal_struct() into free_signal_struct()
instead.

Oleg.	

