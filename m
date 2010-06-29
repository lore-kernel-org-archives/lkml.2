Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581Ab0F2RVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 13:21:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14357 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755099Ab0F2RVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 13:21:37 -0400
Date: Tue, 29 Jun 2010 19:18:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>, john stultz <johnstul@us.ibm.com>,
       Kees Cook <kees.cook@canonical.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Neil Horman <nhorman@tuxdriver.com>, Roland McGrath <roland@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sanitize task->comm to avoid leaking escape codes
Message-ID: <20100629171846.GA18440@redhat.com>
References: <20100623181129.GM5876@outflux.net> <20100623194145.GA19628@redhat.com> <1277787505.3599.25.camel@localhost.localdomain> <20100629133131.GB5237@redhat.com> <20100629162334.GE2765@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100629162334.GE2765@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29, Paul E. McKenney wrote:
>
> On Tue, Jun 29, 2010 at 03:31:31PM +0200, Oleg Nesterov wrote:
>
> > So, afaics, set_task_comm()->wmb() buys nothing and should be removed.
> > The last zero char in task_struct->comm[] is always here, at least this
> > guarantees that strcpy(char *dest, tsk->comm) is always safe.
> >
> > (I cc'ed the expert, Paul can correct me)
>
> First, all of the implementations that I can see do task_lock(tsk), which
> should prevent readers from seeing any changes.  So I am guessing that
> you guys want to allow readers to get at ->comm without having to acquire
> this lock.

Ah, sorry for confusion.

No, we are not trying to invent the lockless get_task_comm(). I'd say
it is not needed, if we really care about the precise ->comm we can
take task->alloc_lock.

The only problem is that I believe that set_task_comm() wrongly pretends
wmb() can help the lockless reader, it does:

	task_lock(tsk);

	/*
	 * Threads may access current->comm without holding
	 * the task lock, so write the string carefully.
	 * Readers without a lock may see incomplete new
	 * names but are safe from non-terminating string reads.
	 */
	memset(tsk->comm, 0, TASK_COMM_LEN);
	wmb();
	strlcpy(tsk->comm, buf, sizeof(tsk->comm));
	task_unlock(tsk);

but afaics this wmb() buys absolutely nothing if we race with the
reader doing, say,

	printk("my name is %s\n", current->comm);

Afaics, this wmb()

	- can't prevent from printing the mixture of the old/new data

	- is not needed to make strcpy(somewhere, task->comm) safe,
	  the final char is always '0', we never change it.

	- adds the unnecessary confusion

> [... snip a lot of good ideas ...]

Thanks a lot, Paul ;)

Oleg.

