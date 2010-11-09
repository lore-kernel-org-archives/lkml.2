Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab0KIRtH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 12:49:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670Ab0KIRtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 12:49:03 -0500
Date: Tue, 9 Nov 2010 18:42:20 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Prasad <prasad@linux.vnet.ibm.com>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Q: perf_event && event->owner
Message-ID: <20101109174219.GA8279@redhat.com>
References: <20101108145647.GA3426@redhat.com> <20101108145754.GB3434@redhat.com> <20101108201108.GA6777@nowhere> <20101109155714.GA1903@redhat.com> <1289321804.2191.57.camel@laptop> <20101109165805.GA6971@redhat.com> <1289322469.2191.59.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289322469.2191.59.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09, Peter Zijlstra wrote:
>
> Ah,.. quite so. So how about we explicitly destroy the list when the
> task dies?

Yes, I think it makes sense to destroy the list and set ->owner = NULL.
If we reset the owner, we can also avoid get_task_struct().

The only problem is perf_event_release_kernel(), it can race with the
exiting event->owner. It can do get_task_struct() under rcu lock temporary,
just to take the mutex and remove the entry.

> > And ptrace(), it doesn't use sys_perf_event_open() to create the event.
>
> Right, I guess it uses kernel based things, I guess we could not add
> kernel based counters to the list.

Agreed, another case when event->owner should be NULL.



Hmm. With or without these changes. Shouldn't perf_event_release_kernel()
remove the event from list before anything else? Otherwise, afaics a thread
which does close(event_fd) can race with creator doing prctl(EVENTS_ENABLE),
no?

Oleg.

