Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180Ab2H1RKU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 13:10:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487Ab2H1RKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 13:10:19 -0400
Date: Tue, 28 Aug 2012 19:12:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt <rostedt@goodmis.org>,
        dhowells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: lockdep trace from posix timers
Message-ID: <20120828171236.GA31080@redhat.com>
References: <20120820154154.GB20258@redhat.com> <1345478211.23018.69.camel@twins> <20120820161012.GC21400@redhat.com> <1345479590.23018.75.camel@twins> <20120820162302.GA22354@redhat.com> <20120821182751.GA11243@redhat.com> <20120821183408.GA11721@redhat.com> <20120824185619.GA16719@redhat.com> <1346171342.2296.4.camel@laptop> <20120828170121.GA30165@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120828170121.GA30165@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28, Oleg Nesterov wrote:
>
> On 08/28, Peter Zijlstra wrote:
> >
> > +again:
> > +	workp = &task->task_works;
> > +	work = *workp;
> > +	while (work) {
> > +		if (work->func == func) {
>
> But you can't dereference this pointer. Without some locking this
> can race with another task_work_cancel() or task_work_run(), this
> work can be free/unmapped/reused.
>
> > +			if (cmpxchg(workp, work, work->next) == work)
> > +				return work;
>
> Or this can race with task_work_cancel(work) + task_work_add(work).
> cmpxchg() can succeed even if work->func is already different.

Even simpler, this can race with another task_work_cancel() which
is going to remove work->next.

Oleg.

