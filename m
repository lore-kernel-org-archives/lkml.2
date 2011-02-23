Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab1BWEVA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 23:21:00 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:36766 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752215Ab1BWEU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 23:20:59 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19RBL8O3KdRqN3gcT8L3R2LfL2OVmrlAjf0D5V7qg
	2tXugsnS+dtIe2
Subject: Re: [PATCH 1/2] sched: allow SCHED_BATCH to preempt SCHED_IDLE
 tasks
From: Mike Galbraith <efault@gmx.de>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        richard.purdie@linuxfoundation.org
In-Reply-To: <1298408674-3130-2-git-send-email-dvhart@linux.intel.com>
References: <1298408674-3130-1-git-send-email-dvhart@linux.intel.com>
	 <1298408674-3130-2-git-send-email-dvhart@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Feb 2011 05:20:54 +0100
Message-ID: <1298434854.7856.24.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-22 at 13:04 -0800, Darren Hart wrote:
> Perform the test for SCHED_IDLE before testing for SCHED_BATCH (and ensure idle
> tasks don't preempt idle tasks) so the non-interactive, but still important,
> SCHED_BATCH tasks will run in favor of the very low priority SCHED_IDLE tasks.

Yeah, that could be construed as a fairness fix for light SCHED_BATCH vs
a heavy SCHED_IDLE.  It should lower latencies for both when mixed.

Acked-by: Mike Galbraith <efault@gmx.de>

Nit below.

> Signed-off-by: Darren Hart <dvhart@linux.intel.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Richard Purdie <richard.purdie@linuxfoundation.org>
> ---
>  kernel/sched_fair.c |   12 +++++++-----
>  1 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 0c26e2d..ff04bbd 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -1857,16 +1857,18 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
>  	if (test_tsk_need_resched(curr))
>  		return;
>  
> +	/* Idle tasks are by definition preempted by non-idle tasks. */
> +	if (unlikely(curr->policy == SCHED_IDLE) &&
> +	    likely(p->policy != SCHED_IDLE))
> +		goto preempt;
> +

if (unlikely(curr->policy == SCHED_IDLE && p->policy != curr->policy))
	goto preempt;

Looks better to me.

	-Mike

