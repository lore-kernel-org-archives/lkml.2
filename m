Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528Ab2GYAJI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 20:09:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41281 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326Ab2GYAJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 20:09:06 -0400
Date: Tue, 24 Jul 2012 17:09:01 -0700
From: Tejun Heo <tj@kernel.org>
To: Peter Boonstoppel <pboonstoppel@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Andy Walls <awalls@md.metrocast.net>,
        Diwakar Tundlam <dtundlam@nvidia.com>
Subject: Re: [PATCH 1/1] kthread: disable preemption during complete()
Message-ID: <20120725000901.GA5304@google.com>
References: <5FBF8E85CA34454794F0F7ECBA79798F379D364859@HQMAIL04.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5FBF8E85CA34454794F0F7ECBA79798F379D364859@HQMAIL04.nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jul 24, 2012 at 05:05:32PM -0700, Peter Boonstoppel wrote:
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
> Change-Id: I856ddd4e01ebdb198ba90f343b4a0c5933fd2b23

Is this from internal gerrit?  Can you please remove it before sending
things upstream?

>  #include <linux/mutex.h>
>  #include <linux/slab.h>
>  #include <linux/freezer.h>
> +#include <linux/preempt.h>
> +#include <linux/thread_info.h>
>  #include <trace/events/sched.h>
>  
>  static DEFINE_SPINLOCK(kthread_create_lock);
> @@ -113,7 +115,10 @@ static int kthread(void *_create)
>  	/* OK, tell user we're spawned, wait for stop or wakeup */
>  	__set_current_state(TASK_UNINTERRUPTIBLE);
>  	create->result = current;
> +	preempt_disable();
>  	complete(&create->done);
> +	clear_need_resched();

Is the above really necessary given that you're calling
preempt_enable_no_resched() right after?

> +	preempt_enable_no_resched();
>  	schedule();

Some comments would be really nice.

Thanks.

-- 
tejun
