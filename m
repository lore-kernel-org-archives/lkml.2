Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520Ab2GYWkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 18:40:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38035 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab2GYWks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 18:40:48 -0400
Date: Wed, 25 Jul 2012 15:40:44 -0700
From: Tejun Heo <tj@kernel.org>
To: Peter Boonstoppel <pboonstoppel@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Andy Walls <awalls@md.metrocast.net>,
        Diwakar Tundlam <dtundlam@nvidia.com>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 1/1] kthread: disable preemption during complete()
Message-ID: <20120725224044.GC32378@google.com>
References: <5FBF8E85CA34454794F0F7ECBA79798F379D364859@HQMAIL04.nvidia.com>
 <20120725000901.GA5304@google.com>
 <5FBF8E85CA34454794F0F7ECBA79798F379D36485E@HQMAIL04.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5FBF8E85CA34454794F0F7ECBA79798F379D36485E@HQMAIL04.nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing Oleg and Peter)

On Wed, Jul 25, 2012 at 03:35:32PM -0700, Peter Boonstoppel wrote:
> After a kthread is created it signals the requester using complete()
> and enters TASK_UNINTERRUPTIBLE. However, since complete() wakes up
> the requesting thread this can cause a preemption. The preemption will
> not remove the task from the runqueue (for that schedule() has to be
> invoked directly).
> 
> This is a problem if directly after kthread creation you try to do a
> kthread_bind(), which will block in HZ steps until the thread is off
> the runqueue.
> 
> This patch disables preemption during complete(), since we call
> schedule() directly afterwards, so it will correctly enter
> TASK_UNINTERRUPTIBLE. This speeds up kthread creation/binding during
> cpu hotplug significantly.
> 
> Signed-off-by: Peter Boonstoppel <pboonstoppel@nvidia.com>
> ---
>  kernel/kthread.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/kthread.c b/kernel/kthread.c
> index b579af5..757d8dd 100644
> --- a/kernel/kthread.c
> +++ b/kernel/kthread.c
> @@ -16,6 +16,7 @@
>  #include <linux/mutex.h>
>  #include <linux/slab.h>
>  #include <linux/freezer.h>
> +#include <linux/preempt.h>
>  #include <trace/events/sched.h>
>  
>  static DEFINE_SPINLOCK(kthread_create_lock);
> @@ -113,7 +114,17 @@ static int kthread(void *_create)
>  	/* OK, tell user we're spawned, wait for stop or wakeup */
>  	__set_current_state(TASK_UNINTERRUPTIBLE);
>  	create->result = current;
> +
> +	/*
> +	 * Disable preemption so we enter TASK_UNINTERRUPTIBLE after
> +	 * complete() instead of possibly being preempted. This speeds
> +	 * up clients that do a kthread_bind() directly after
> +	 * creation.
> +	 */
> +	preempt_disable();

Shouldn't this happen before setting current state to UNINTERRUPTIBLE?
What prevents preemption happening right above preempt_disable()?

>  	complete(&create->done);
> +	preempt_enable_no_resched();
> +
>  	schedule();

PeterZ, Oleg, can you guys please review this?

Thanks.

-- 
tejun
