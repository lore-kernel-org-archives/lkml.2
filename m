Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab2KFST5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 13:19:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46372 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571Ab2KFST4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 13:19:56 -0500
Date: Tue, 6 Nov 2012 19:20:00 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Josh Stone <jistone@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, David Smith <dsmith@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: uprobes && pre-filtering
Message-ID: <20121106182000.GA3522@redhat.com>
References: <20121105190446.GA6188@redhat.com> <20121106090525.GB27055@linux.vnet.ibm.com> <20121106170243.GA32311@redhat.com> <50994BC1.1000705@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50994BC1.1000705@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06, Josh Stone wrote:
>
> On 11/06/2012 09:02 AM, Oleg Nesterov wrote:
> >>> - Perhaps we should extend the API. We can add
> >>>
> >>> 	uprobe_apply(consumer, task, bool add_remove);
> >>>
> >>>   which adds/removes breakpoints to task->mm.
> >>>
> >>>   This way consumer can probe every task it wants to trace after
> >>>   uprobe_register().
> >>>
> >>>   Its ->filter(UPROBE_FILTER_REGISTER) should simply return false. Or,
> >>>   better, we can split uprobe_register() into 2 functions,
> >>>   __uprobe_register() and uprobe_apply_all() which actually does
> >>>   register_for_each_vma().
> >>>
> >>>   ***** QUESTION *****: perhaps this is all systemtap needs? ignoring
> >>>   UPROBE_FILTER_MMAP.
> >>>
> >> So in this case, would uprobe_register() just add a consumer to a
> >> new/existing uprobe. The actual probe insertion is done by the
> >> uprobe_apply()/uprobe_apply_all().
> >
> > Yes. Not sure we really need this, but to me this extension looks natural.
> >
> > Frank, Josh, do you think it can help systemtap ?
>
> Yes, I think this sounds closer to systemtap's model of probing.  We
> already track tasks that come and go to see which are "interesting", so
> we could easily call apply() at that time.  We actually watch mmaps too,
> so I think we could apply() for that case as well.

OK, thanks.

(just in case, mmap is different, but lets ignore this now).

> We wouldn't even need filtering functions at all in this mode.  But
> maybe other consumers could still use it, like perf.

Of course, we need ->filter() anyway.

> However, it's not clear to me what value there is in uprobe_register, if
> you always have to apply it too.  The modes are something like:
>
> 1. uprobe_register(); uprobe_apply_all();
> 2. uprobe_register(); uprobe_apply(); [...]

No, no, sorry for confusion.

I meant we could add __uprobe_register() (or whatever) which doesn't actually
insert the breakpoint. So if the tracer relies on uprobe_apply() it can avoid
the costly register_for_each_vma/filter and do __uprobe_register + apply.

This is not strictly necessary even if we add uprobe_apply*, and you can
always use uprobe_register() (or uprobe_register_all as you denoted it
below).

> first applicable task to come around.  So why not instead:
>
> 1. uprobe_register_all();
> 2. uprobe_register_task(); [...]
>
> In this case, the second would have to allow the same consumer to be
> repeated on different tasks, but it feels more natural to me.

This can work too.

But uprobe_unregister_task() doesn't look very clear. What should it
do? IOW, you still need uprobe_unregister_all() and this doesn't look
symmetrical.

Oleg.

