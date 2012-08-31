Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab2HaUGe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 16:06:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50394 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827Ab2HaUGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 16:06:33 -0400
Date: Fri, 31 Aug 2012 13:06:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ed Cashin <ecashin@coraid.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/14] aoe: kernel thread handles I/O completions for
 simple locking
Message-Id: <20120831130632.f7b12060.akpm@linux-foundation.org>
In-Reply-To: <bd1dae439834419bfa6056e75361d23e0404ac82.1346158422.git.ecashin@coraid.com>
References: <cover.1346158422.git.ecashin@coraid.com>
	<bd1dae439834419bfa6056e75361d23e0404ac82.1346158422.git.ecashin@coraid.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Aug 2012 10:39:46 -0400
Ed Cashin <ecashin@coraid.com> wrote:

> +static int
> +kthread(void *vp)
> +{
> +	struct ktstate *k;
> +	DECLARE_WAITQUEUE(wait, current);
> +	int more;
> +
> +	k = vp;
> +	current->flags |= PF_NOFREEZE;
> +	set_user_nice(current, -10);
> +	complete(&k->rendez);	/* tell spawner we're running */
> +	do {
> +		spin_lock_irq(k->lock);
> +		more = k->fn();
> +		if (!more) {
> +			add_wait_queue(k->waitq, &wait);
> +			__set_current_state(TASK_INTERRUPTIBLE);
> +		}
> +		spin_unlock_irq(k->lock);
> +		if (!more) {
> +			schedule();
> +			remove_wait_queue(k->waitq, &wait);
> +		} else
> +			cond_resched();
> +	} while (!kthread_should_stop());
> +	complete(&k->rendez);	/* tell spawner we're stopping */
> +	return 0;
> +}
> +
> +static void
> +aoe_ktstop(struct ktstate *k)
> +{
> +	kthread_stop(k->task);
> +	wait_for_completion(&k->rendez);
> +}
> +
> +static int
> +aoe_ktstart(struct ktstate *k)
> +{
> +	struct task_struct *task;
> +
> +	init_completion(&k->rendez);
> +	task = kthread_run(kthread, k, k->name);
> +	if (task == NULL || IS_ERR(task))
> +		return -ENOMEM;
> +	k->task = task;
> +	wait_for_completion(&k->rendez); /* allow kthread to start */
> +	init_completion(&k->rendez);	/* for waiting for exit later */
> +	return 0;
> +}

It's a pretty unlikely thing, but I wonder if there's a way in which
aoe_ktstart() can run that second init_completion() _after_ kthread()
has run its second complete().  ie: someone runs aoe_ktstop()
super-early.  If that can happen, the later wait_for_completion() hangs
up.



