Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab2A0I7x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 03:59:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:57074 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562Ab2A0I7w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 03:59:52 -0500
Message-ID: <1327654781.2446.149.camel@twins>
Subject: Re: [BUG] TASK_DEAD task is able to be woken up in special condition
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Yasunori Goto <y-goto@jp.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
        Motohiro Kosaki <kosaki.motohiro@jp.fujitsu.com>,
        Linux Kernel ML <linux-kernel@vger.kernel.org>
Date: Fri, 27 Jan 2012 09:59:41 +0100
In-Reply-To: <20120126162611.GA1982@redhat.com>
References: <20120117090605.GD7612@elte.hu>
	 <20120117151242.GA13290@redhat.com> <20120118094219.GE5842@elte.hu>
	 <20120118142005.GB10105@redhat.com> <1327400349.2614.10.camel@laptop>
	 <1327402527.2614.17.camel@laptop> <20120125154547.GA6671@redhat.com>
	 <1327510290.2614.95.camel@laptop> <20120125174330.GA23303@redhat.com>
	 <1327591943.2446.111.camel@twins> <20120126162611.GA1982@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-26 at 17:26 +0100, Oleg Nesterov wrote:
> On 01/26, Peter Zijlstra wrote:

> > However I think your proposal:
> >
> > >                 for (;;) {
> > >                         tsk->state = TASK_DEAD;
> > >                         schedule();
> > >                 }
> >
> > should equally work, if we hit the race and call schedule() with ->state
> > = TASK_RUNNING,
> 
> Yes, in this case everything is fine, but we can shedule() with TASK_DEAD
> state. preempt_disable() can't (and shouldn't) prevent deactivate_task().
> 
> To simplify, try_to_wake_up() does
> 
> 		spin_lock(pi_lock);
> 
> 		if (!(p->state & state))
> 			goto out;
> 
> 		/* WINDOW */
> 
> 		if (p->on_rq) {
> 			... everything is fine ...
> 		}
> 
> 		p->state = TASK_WAKING;
> 		ttwu_queue(p, cpu);
> 
> And the exiting task does
> 
> 	// but do not sleep ...
> 	current->state = TASK_UNINTERRUPTIBLE;
> 							// ttwu() checks ->state
> 	...
> 	tsk->state = TASK_DEAD;
> 	schedule();
> 		-> deactivate_task();
> 		-> tsk->on_rq = 0;
> 		-> finish_task_switch();
> 
> 							// ttwu() checks ->on_rq
> 
> In theory it can do this all in the WINDOW above. In this case we
> can wake it up again, after finish_task_switch()-put_task_struct().
> 
> No?

Yes, bugger. Ok I'll queue Yasunori-san's patch as is.

Thanks everyone!
