Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171Ab3AHTBr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 14:01:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756734Ab3AHTBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 14:01:46 -0500
Date: Tue, 8 Jan 2013 20:00:18 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] uprobes: Teach handler_chain() to filter out the
	probed task
Message-ID: <20130108190018.GA4408@redhat.com>
References: <20121229173554.GA2145@redhat.com> <20121229173614.GA2154@redhat.com> <20130108111814.GA1325@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130108111814.GA1325@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08, Srikar Dronamraju wrote:
>
> * Oleg Nesterov <oleg@redhat.com> [2012-12-29 18:36:14]:
>
> > This patch does the first step to improve the filtering. handler_chain()
> > removes the breakpoints installed by this uprobe from current->mm if all
> > handlers return UPROBE_HANDLER_REMOVE.
> >
>
> I am thinking of tid based filter, If let say a tracer is just
> interested in a particular thread of a process, should such a hanlder
> always return 0.

In this case ->handler() should return

	current->mm == PROBED_THEAD->mm ? 0 : UPROBE_HANDLER_REMOVE

> In general, does this mean if the handler is not interested for this
> particular task, but not sure if other tasks in the same process could
> be interested, then such a handler should always return 0?

Probably yes. Obviously it should return UPROBE_HANDLER_REMOVE only if
it knows for sure that current can't share ->mm with the "interesting"
task.

Because, whatever we do, remove_breakpoint() affects ->mm, not task_struct.
Our goal is eliminate do_int3(), not to skip uc->handler() call.

> If yes, should we document it (either in handler_chain() or
> near uprobe_consumer definition)

Oh yes, I do agree. We need to add some documentation. I'll try to do
this in a separate patch (although I would be happy to see the patch
from someone else ;).

> > Note: instead of checking the retcode from uc->handler, we could add
> > uc->filter(UPROBE_FILTER_BPHIT). But I think this is not optimal to
> > call 2 hooks in a row. This buys nothing, and if handler/filter do
> > something nontrivial they will probably do the same work twice.
>
> I was for having the filter called explicitly. But I am okay with it
> being called internally by the handler.

OK, thanks,

> My only small concern was
>
> - Given that we have an explicit filter, handlers (or folks writing
>   handlers can misunderstand and miss filtering assuming that handlers
>   would be called after filtering.

Do you mean that they can assume that uc->filter(mm) should be called at
least once before uc->handler() with the same current->mm ?

They shouldn't in any case. To remind, we can optimize filter_chain()
for example and avoid the potentially costly uc->filter() call. Say,
we can detect/remember the fact that at least one consumre has
->filter == NULL.

OTOH, UPROBE_HANDLER_REMOVE is not really pre-filtering (although I think
it helps to make the things better). It is more like uprobe_unapply_mm()
which (perhaps) we need as well. But doing uprobe_unapply_mm() from
uc->handler is a) deadlockable and b) not optimal because it has to
consult other consumers.

Anyway I agree, the folks writing handlers should understand what do they
do ;) and this needs some documentation.

> > +static void handler_chain(struct uprobe *uprobe, struct pt_regs *regs)
> > +{
> > +	struct uprobe_consumer *uc;
> > +	int remove = UPROBE_HANDLER_REMOVE;
> > +
> > +	down_read(&uprobe->register_rwsem);
> > +	for (uc = uprobe->consumers; uc; uc = uc->next) {
> > +		int rc = uc->handler(uc, regs);
> > +
> > +		WARN(rc & ~UPROBE_HANDLER_MASK,
> > +			"bad rc=0x%x from %pf()\n", rc, uc->handler);
>
> Is this warning required?

Of course this is not strictly needed, just to catch the simple mistakes.
I can remove it.

Oleg.

