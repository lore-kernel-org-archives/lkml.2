Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216Ab2H1R3G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 13:29:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:36146 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab2H1R3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 13:29:04 -0400
Subject: Re: lockdep trace from posix timers
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt <rostedt@goodmis.org>,
        dhowells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <20120828170121.GA30165@redhat.com>
References: <1345475530.23018.50.camel@twins>
	 <20120820154154.GB20258@redhat.com> <1345478211.23018.69.camel@twins>
	 <20120820161012.GC21400@redhat.com> <1345479590.23018.75.camel@twins>
	 <20120820162302.GA22354@redhat.com> <20120821182751.GA11243@redhat.com>
	 <20120821183408.GA11721@redhat.com> <20120824185619.GA16719@redhat.com>
	 <1346171342.2296.4.camel@laptop>  <20120828170121.GA30165@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Aug 2012 19:28:50 +0200
Message-ID: <1346174930.2296.13.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-28 at 19:01 +0200, Oleg Nesterov wrote:
> >  struct callback_head *
> >  task_work_cancel(struct task_struct *task, task_work_func_t func)
> >  {
> > +     struct callback_head **workp, *work;
> > +
> > +again:
> > +     workp = &task->task_works;
> > +     work = *workp;
> > +     while (work) {
> > +             if (work->func == func) {
> 
> But you can't dereference this pointer. Without some locking this
> can race with another task_work_cancel() or task_work_run(), this
> work can be free/unmapped/reused.
> 
> > +                     if (cmpxchg(workp, work, work->next) == work)
> > +                             return work;
> 
> Or this can race with task_work_cancel(work) + task_work_add(work).
> cmpxchg() can succeed even if work->func is already different. 

Bah.. you and your races ;-)

Surely we can do this locklessly.. I'll go try harder still.

