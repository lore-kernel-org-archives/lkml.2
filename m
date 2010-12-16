Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab0LPSH7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 13:07:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53333 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078Ab0LPSH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 13:07:58 -0500
Date: Thu, 16 Dec 2010 18:58:01 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 5/5] sched: Reduce ttwu rq->lock contention
Message-ID: <20101216175801.GB12841@redhat.com>
References: <20101216145602.899838254@chello.nl> <20101216150920.968046926@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101216150920.968046926@chello.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16, Peter Zijlstra wrote:
>
> Then instead of locking the remote rq and activating the task, place
> the task on a remote queue, again using cmpxchg, and notify the remote
> cpu per IPI if this queue was empty to start processing its wakeups.

Interesting... I didn't actually read this patch yet, just a very
minor nit.

> +#ifdef CONFIG_SMP
> +static void ttwu_queue_remote(struct task_struct *p, int cpu)
> +{
> +	struct task_struct *next = NULL;
> +	struct rq *rq = cpu_rq(cpu);
> +
> +	for (;;) {
> +		struct task_struct *old = next;
> +
> +		p->wake_entry = next;
> +		next = cmpxchg(&rq->wake_list, old, p);

Somehow I was confused by initial "next = NULL", perhaps

	struct rq *rq = cpu_rq(cpu);
	struct task_struct *next = rq->wake_list;

makes a bit more sense.

Oleg.

