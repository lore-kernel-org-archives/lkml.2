Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab0LPPbL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 10:31:11 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:39154 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756482Ab0LPPbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 10:31:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JAZBV0bTCTr0L75idaGiLxp2Inpos/mk1/uD7/zs1aMs5U6UV5IElU3SEgWiiPGUw2
         S95XxTPFxF1ZzlsQRqoaVmCt82SD60xiB664rbXybzlGYC/neh2uHXCul/GKzmOznbzo
         6OM5punDZ6FjyeDwTNrZeSqf7ENK04xlVs78E=
Date: Thu, 16 Dec 2010 16:31:03 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 5/5] sched: Reduce ttwu rq->lock contention
Message-ID: <20101216153100.GC1687@nowhere>
References: <20101216145602.899838254@chello.nl>
 <20101216150920.968046926@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101216150920.968046926@chello.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 03:56:07PM +0100, Peter Zijlstra wrote:
> Reduce rq->lock contention on try_to_wake_up() by changing the task
> state using a cmpxchg loop.
> 
> Once the task is set to TASK_WAKING we're guaranteed the only one
> poking at it, then proceed to pick a new cpu without holding the
> rq->lock (XXX this opens some races).
> 
> Then instead of locking the remote rq and activating the task, place
> the task on a remote queue, again using cmpxchg, and notify the remote
> cpu per IPI if this queue was empty to start processing its wakeups.
> 
> This avoids (in most cases) having to lock the remote runqueue (and
> therefore the exclusive cacheline transfer thereof) but also touching
> all the remote runqueue data structures needed for the actual
> activation.
> 
> As measured using: http://oss.oracle.com/~mason/sembench.c
> 
> $ echo 4096 32000 64 128 > /proc/sys/kernel/sem
> $ ./sembench -t 2048 -w 1900 -o 0
> 
> unpatched: run time 30 seconds 537953 worker burns per second
> patched:   run time 30 seconds 657336 worker burns per second
> 
> Still need to sort out all the races marked XXX (non-trivial), and its
> x86 only for the moment.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  arch/x86/kernel/smp.c   |    1 
>  include/linux/sched.h   |    7 -
>  kernel/sched.c          |  241 ++++++++++++++++++++++++++++++++++--------------
>  kernel/sched_fair.c     |    5 
>  kernel/sched_features.h |    3 
>  kernel/sched_idletask.c |    2 
>  kernel/sched_rt.c       |    4 
>  kernel/sched_stoptask.c |    3 
>  8 files changed, 190 insertions(+), 76 deletions(-)
> 
> Index: linux-2.6/arch/x86/kernel/smp.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/smp.c
> +++ linux-2.6/arch/x86/kernel/smp.c
> @@ -205,6 +205,7 @@ void smp_reschedule_interrupt(struct pt_
>  	/*
>  	 * KVM uses this interrupt to force a cpu out of guest mode
>  	 */
> +	sched_ttwu_pending();
>  }

Great, that's going to greatly simplify and lower the overhead of
the remote tick restart I'm doing on wake up for the nohz task thing.
