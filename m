Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab2AQPTH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 10:19:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754401Ab2AQPTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 10:19:04 -0500
Date: Tue, 17 Jan 2012 16:12:42 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
        Motohiro Kosaki <kosaki.motohiro@jp.fujitsu.com>,
        Linux Kernel ML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] TASK_DEAD task is able to be woken up in special
	condition
Message-ID: <20120117151242.GA13290@redhat.com>
References: <20120116205140.6120.E1E9C6FF@jp.fujitsu.com> <1326721082.2442.234.camel@twins> <20120117174031.3118.E1E9C6FF@jp.fujitsu.com> <20120117090605.GD7612@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120117090605.GD7612@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17, Ingo Molnar wrote:
>
> * Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
>
> > --- linux-3.2.orig/kernel/exit.c
> > +++ linux-3.2/kernel/exit.c
> > @@ -1038,6 +1038,22 @@ NORET_TYPE void do_exit(long code)
> >
> >  	preempt_disable();
> >  	exit_rcu();
> > +
> > +	/*
> > +	 * The setting of TASK_RUNNING by try_to_wake_up() may be delayed
> > +	 * when the following two conditions become true.
> > +	 *   - There is race condition of mmap_sem (It is acquired by
> > +	 *     exit_mm()), and
> > +	 *   - SMI occurs before setting TASK_RUNINNG.
> > +	 *     (or hypervisor of virtual machine switches to other guest)
> > +	 *  As a result, we may become TASK_RUNNING after becoming TASK_DEAD
> > +	 *
> > +	 * To avoid it, we have to wait for releasing tsk->pi_lock which
> > +	 * is held by try_to_wake_up()
> > +	 */
> > +	smp_mb();
> > +	raw_spin_unlock_wait(&tsk->pi_lock);
>
> Hm, unlock_wait() is really nasty. Wouldnt the adoption of the
> -rt kernel's delayed task put logic solve most of these races?

How? The problem is that the exiting task can do the last schedule()
in TASK_RUNNING state, this breaks the TASK_DEAD logic in
finish_task_switch().

Oleg.

