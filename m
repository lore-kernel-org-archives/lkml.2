Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749Ab0KKUeR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 15:34:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32574 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931Ab0KKUeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 15:34:16 -0500
Date: Thu, 11 Nov 2010 21:27:03 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Message-ID: <20101111202703.GA16282@redhat.com>
References: <1287514410.7368.10.camel@marge.simson.net> <20101020025652.GB26822@elte.hu> <1287648715.9021.20.camel@marge.simson.net> <20101021105114.GA10216@Krystal> <1287660312.3488.103.camel@twins> <20101021162924.GA3225@redhat.com> <1288076838.11930.1.camel@marge.simson.net> <1288078144.7478.9.camel@marge.simson.net> <AANLkTimOJAv2uRfq4bW_QPngkGCmJDjNX5n_izpX=eB8@mail.gmail.com> <1289489200.11397.21.camel@maggy.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289489200.11397.21.camel@maggy.simson.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I didn't read this patch carefully (yet) but,

On 11/11, Mike Galbraith wrote:
>
> @@ -2569,6 +2576,7 @@ void sched_fork(struct task_struct *p, i
>  	 * Silence PROVE_RCU.
>  	 */
>  	rcu_read_lock();
> +	autogroup_fork(p);

Surely this doesn't need rcu.

But the real problem is that copy_process() can fail after that,
and in this case we have the unbalanced kref_get().

> +++ linux-2.6.36.git/kernel/exit.c
> @@ -174,6 +174,7 @@ repeat:
>  	write_lock_irq(&tasklist_lock);
>  	tracehook_finish_release_task(p);
>  	__exit_signal(p);
> +	sched_autogroup_exit(p);

This doesn't look right. Note that "p" can run/sleep after that
(or in parallel), set_task_rq() can use the freed ->autogroup.

Btw, I can't apply this patch...

Oleg.

