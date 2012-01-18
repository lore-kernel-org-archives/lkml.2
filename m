Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293Ab2ARJmm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 04:42:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45689 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757104Ab2ARJmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 04:42:40 -0500
Date: Wed, 18 Jan 2012 10:42:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
        Motohiro Kosaki <kosaki.motohiro@jp.fujitsu.com>,
        Linux Kernel ML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] TASK_DEAD task is able to be woken up in special condition
Message-ID: <20120118094219.GE5842@elte.hu>
References: <20120116205140.6120.E1E9C6FF@jp.fujitsu.com>
 <1326721082.2442.234.camel@twins>
 <20120117174031.3118.E1E9C6FF@jp.fujitsu.com>
 <20120117090605.GD7612@elte.hu>
 <20120117151242.GA13290@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120117151242.GA13290@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@redhat.com> wrote:

> On 01/17, Ingo Molnar wrote:
> >
> > * Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
> >
> > > --- linux-3.2.orig/kernel/exit.c
> > > +++ linux-3.2/kernel/exit.c
> > > @@ -1038,6 +1038,22 @@ NORET_TYPE void do_exit(long code)
> > >
> > >  	preempt_disable();
> > >  	exit_rcu();
> > > +
> > > +	/*
> > > +	 * The setting of TASK_RUNNING by try_to_wake_up() may be delayed
> > > +	 * when the following two conditions become true.
> > > +	 *   - There is race condition of mmap_sem (It is acquired by
> > > +	 *     exit_mm()), and
> > > +	 *   - SMI occurs before setting TASK_RUNINNG.
> > > +	 *     (or hypervisor of virtual machine switches to other guest)
> > > +	 *  As a result, we may become TASK_RUNNING after becoming TASK_DEAD
> > > +	 *
> > > +	 * To avoid it, we have to wait for releasing tsk->pi_lock which
> > > +	 * is held by try_to_wake_up()
> > > +	 */
> > > +	smp_mb();
> > > +	raw_spin_unlock_wait(&tsk->pi_lock);
> >
> > Hm, unlock_wait() is really nasty. Wouldnt the adoption of 
> > the -rt kernel's delayed task put logic solve most of these 
> > races?
> 
> How? The problem is that the exiting task can do the last 
> schedule() in TASK_RUNNING state, this breaks the TASK_DEAD 
> logic in finish_task_switch().

Well, but does the -rt kernel suffer from the same race? It can 
generate delays at the exact same place, and can generate much 
longer delays than an SMI, if a high-prio RT task comes along.

So if there's something in the -rt kernel that fixes this race 
we'd like to have that. If the bug is present in the -rt kernel 
then why didn't it ever get triggered? We caught much more 
narrow races in -rt, and very early on in the project.

Thanks,

	Ingo
