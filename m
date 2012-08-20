Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078Ab2HTP10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 11:27:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:55363 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757080Ab2HTP1Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 11:27:24 -0400
Message-ID: <1345476436.23018.54.camel@twins>
Subject: Re: lockdep trace from posix timers
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt <rostedt@goodmis.org>,
        dhowells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Date: Mon, 20 Aug 2012 17:27:16 +0200
In-Reply-To: <1345475434.23018.48.camel@twins>
References: <20120724203613.GA9637@redhat.com>
	 <1345140478.29668.54.camel@twins> <20120817151447.GA7918@redhat.com>
	 <1345446957.23018.14.camel@twins> <1345463081.23018.34.camel@twins>
	 <20120820145919.GB18499@redhat.com> <1345475434.23018.48.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-20 at 17:10 +0200, Peter Zijlstra wrote:
> On Mon, 2012-08-20 at 16:59 +0200, Oleg Nesterov wrote:
> > On 08/20, Peter Zijlstra wrote:
> > >
> > >  task_work_cancel(struct task_struct *task, task_work_func_t func)
> > >  {
> > > ...
> > > +
> > > +again:
> > > +	workp = &task->task_works;
> > > +	work = *workp;
> > > +	while (work) {
> > > +		if (work->func == func) {
> > 
> > But this all can race with task_work_run() if task != current.
> > 
> > This "work" can be freed/reused. And it should only return !NULL
> > if twork->func() was not called.
> 
> Ah, because we could be iterating the list after the xchg done by run.

I guess we could steal the entire list and requeue it afterwards and
lift TIF_NOTIFY_RESUME along with it.. but I can't say that's pretty.




