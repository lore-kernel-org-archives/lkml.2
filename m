Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751354Ab1ADPnH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 10:43:07 -0500
Received: from canuck.infradead.org ([134.117.69.58]:33324 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab1ADPnF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 10:43:05 -0500
Subject: Re: [RFC][PATCH 16/17] sched: Move the second half of ttwu() to
 the remote cpu
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Jens Axboe <axboe@kernel.dk>,
        Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20110104151826.GA6800@redhat.com>
References: <20101224122338.172750730@chello.nl>
	 <20101224123743.303699501@chello.nl> <20110104142805.GA4347@redhat.com>
	 <1294152441.2016.148.camel@laptop>  <20110104151826.GA6800@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 04 Jan 2011 16:43:01 +0100
Message-ID: <1294155781.2016.160.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-04 at 16:18 +0100, Oleg Nesterov wrote:

> > I don't think so, nobody should be migrating a TASK_WAKING task.
> 
> I am not sure...
> 
> Suppose that p was TASK_INTERRUPTIBLE and p->on_rq == 1 before, when
> set_cpus_allowed_ptr() was called. To simplify, suppose that
> the caller is preempted right after it drops p->pi_lock and before
> it does stop_one_cpu(migration_cpu_stop).
> 
> After that p can complete chedule() and deactivate itself.
> 
> Now, try_to_wake_up() can set TASK_WAKING, choose another CPU,
> and do ttwu_queue_remote().
> 
> Finally, the caller of set_cpus_allowed_ptr() resumes and
> schedules migration_cpu_stop.

But __migrate_task() will then find !p->on_rq and not actually do
anything.

> It is very possible I missed something, but what is the new
> locking rules for set_task_cpu() anyway? I mean, which rq->lock
> it needs?

In the patches I just posted: set_task_cpu(p, cpu) callers need to
either hold task_rq(p)->lock (the old rq) or p->pi_lock.

