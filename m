Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613Ab0KJPRZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 10:17:25 -0500
Received: from canuck.infradead.org ([134.117.69.58]:39948 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756199Ab0KJPRX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 10:17:23 -0500
Subject: Re: Q: perf_event && event->owner
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Prasad <prasad@linux.vnet.ibm.com>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101109185748.GA12138@redhat.com>
References: <20101108145647.GA3426@redhat.com>
	 <20101108145754.GB3434@redhat.com> <20101108201108.GA6777@nowhere>
	 <20101109155714.GA1903@redhat.com> <1289321804.2191.57.camel@laptop>
	 <20101109165805.GA6971@redhat.com> <1289322469.2191.59.camel@laptop>
	 <20101109174219.GA8279@redhat.com> <1289325703.2191.60.camel@laptop>
	 <20101109185748.GA12138@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 10 Nov 2010 16:17:13 +0100
Message-ID: <1289402233.2084.5.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-09 at 19:57 +0100, Oleg Nesterov wrote:
> Either sys_perf_open() should do get_task_struct() like we currently
> do, or perf_event_exit_task() should clear event->owner and then
> perf_release() should do something like
> 
>         rcu_read_lock();
>         owner = event->owner;
>         if (owner)
>                 get_task_struct(owner);
>         rcu_read_unlock();
> 
>         if (owner) {
>                 mutex_lock(&event->owner->perf_event_mutex);
>                 list_del_init(&event->owner_entry);
>                 mutex_unlock(&event->owner->perf_event_mutex);
>                 put_task_struct(owner);
>         }
> 
> Probably this can be simplified... 

I think that's still racy, suppose we do:

void perf_event_exit_task(struct task_struct *child)
{
	struct perf_event *event, *tmp;
	int ctxn;

	mutex_lock(&child->perf_event_mutex);
	list_for_each_entry_safe(event, tmp, &child->perf_event_list,
				 owner_entry) {
		event->owner = NULL;
		list_del_init(&event->owner_entry);
	}
	mutex_unlock(&child->perf_event_mutex);

	for_each_task_context_nr(ctxn)
		perf_event_exit_task_context(child, ctxn);
}


and the close() races with an exit, then couldn't we observe
event->owner after the last put_task_struct()? In which case a
get_task_struct() will result in a double-free.


