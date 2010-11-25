Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478Ab0KYObZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 09:31:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045Ab0KYObY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 09:31:24 -0500
Date: Thu, 25 Nov 2010 15:23:44 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [patch 1/4] taskstats: Introduce "struct cdata"
Message-ID: <20101125142344.GA31508@redhat.com>
References: <20101119201108.269346583@linux.vnet.ibm.com> <20101119201143.787050299@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101119201143.787050299@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19, Michael Holzheu wrote:
>
> From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
>
> This patch introduces a new structure "struct cdata" that is used to
> store cumulative resource counters for dead child processes and threads.
>
> Note that there is one asymmetry:
> For "struct task_io_accounting" (ioc) there is no extra accounting field for
> dead threads. One field is used for both, dead processes and threads.
>
> This patch introduces no functional change.
>
> Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> ---
>  fs/binfmt_elf.c           |    4 +-
>  fs/exec.c                 |    2 -
>  fs/proc/array.c           |   16 ++++----
>  include/linux/sched.h     |   22 +++++++----
>  kernel/exit.c             |   86 ++++++++++++++++++++++++----------------------
>  kernel/posix-cpu-timers.c |   12 +++---
>  kernel/sys.c              |   44 ++++++++++++-----------
>  7 files changed, 100 insertions(+), 86 deletions(-)

Looks good. In fact, to me it looks like a cleanup.

But. You seem to forgot to change kernel/signal.c, no?

And cosmetic nit,

>  void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
>  {
> -	struct signal_struct *sig = tsk->signal;
> +	struct cdata *tcd = &tsk->signal->cdata_threads;
>  	struct task_struct *t;
>
> -	times->utime = sig->utime;
> -	times->stime = sig->stime;
> -	times->sum_exec_runtime = sig->sum_sched_runtime;
> +	times->utime = tcd->utime;
> +	times->stime = tcd->stime;
> +	times->sum_exec_runtime = tsk->signal->sum_sched_runtime;

Feel free to ignore, but I don't understand why you removed "sig".
Afaics,

	-     times->utime = sig->utime;
	-     times->stime = sig->stime;
	+     times->utime = sig->cdata_threads->utime;
	+     times->stime = sig->cdata_threads->stime;

looks a bit better.

Oleg.

