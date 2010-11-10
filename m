Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab0KJPu4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 10:50:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56144 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756388Ab0KJPuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 10:50:55 -0500
Date: Wed, 10 Nov 2010 16:44:30 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Prasad <prasad@linux.vnet.ibm.com>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Q: perf_event && event->owner
Message-ID: <20101110154430.GA1454@redhat.com>
References: <20101108145754.GB3434@redhat.com> <20101108201108.GA6777@nowhere> <20101109155714.GA1903@redhat.com> <1289321804.2191.57.camel@laptop> <20101109165805.GA6971@redhat.com> <1289322469.2191.59.camel@laptop> <20101109174219.GA8279@redhat.com> <1289325703.2191.60.camel@laptop> <20101109185748.GA12138@redhat.com> <1289402233.2084.5.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289402233.2084.5.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10, Peter Zijlstra wrote:
>
> On Tue, 2010-11-09 at 19:57 +0100, Oleg Nesterov wrote:
> > Either sys_perf_open() should do get_task_struct() like we currently
> > do, or perf_event_exit_task() should clear event->owner and then
> > perf_release() should do something like
> >
> >         rcu_read_lock();
> >         owner = event->owner;
> >         if (owner)
> >                 get_task_struct(owner);
> >         rcu_read_unlock();
> >
> >         if (owner) {
> >                 mutex_lock(&event->owner->perf_event_mutex);
> >                 list_del_init(&event->owner_entry);
> >                 mutex_unlock(&event->owner->perf_event_mutex);
> >                 put_task_struct(owner);
> >         }
> >
> > Probably this can be simplified...
>
> I think that's still racy, suppose we do:
>
> void perf_event_exit_task(struct task_struct *child)
> {
> 	struct perf_event *event, *tmp;
> 	int ctxn;
>
> 	mutex_lock(&child->perf_event_mutex);
> 	list_for_each_entry_safe(event, tmp, &child->perf_event_list,
> 				 owner_entry) {
> 		event->owner = NULL;
> 		list_del_init(&event->owner_entry);
> 	}
> 	mutex_unlock(&child->perf_event_mutex);
>
> 	for_each_task_context_nr(ctxn)
> 		perf_event_exit_task_context(child, ctxn);
> }
>
>
> and the close() races with an exit, then couldn't we observe
> event->owner after the last put_task_struct()?

I think no. Note that we do not just free task_struct via rcu callback.
Instead, delayed_put_task_struct() drops the (may be) last reference.

But the code is racy, yes. owner != NULL case is fine. But
perf_release() can see event->owner == NULL before list_del() was
completed. perf_event_exit_task() needs wmb() in between, I think.

Oleg.

