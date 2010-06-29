Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab0F2NfF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 09:35:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752564Ab0F2NfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 09:35:01 -0400
Date: Tue, 29 Jun 2010 15:31:31 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: john stultz <johnstul@us.ibm.com>, Kees Cook <kees.cook@canonical.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Neil Horman <nhorman@tuxdriver.com>, Roland McGrath <roland@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] sanitize task->comm to avoid leaking escape codes
Message-ID: <20100629133131.GB5237@redhat.com>
References: <20100623181129.GM5876@outflux.net> <20100623194145.GA19628@redhat.com> <1277787505.3599.25.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277787505.3599.25.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29, Artem Bityutskiy wrote:
>
> On Wed, 2010-06-23 at 21:41 +0200, Oleg Nesterov wrote:
> > On 06/23, Kees Cook wrote:
> > >
> > > @@ -956,7 +957,15 @@ void set_task_comm(struct task_struct *tsk, char *buf)
> > >  	 */
> > >  	memset(tsk->comm, 0, TASK_COMM_LEN);
> > >  	wmb();
> >
> > Off-topic. I'd wish I could understand this barrier. Since the lockless
> > reader doesn't do rmb() I don't see how this can help.
>
> This wmb() looks wrong to me as well. To achieve what the comment in
> this function says, it should be smp_wmb() and we should have smp_rmb()
> in the reading side, AFAIU.
>
> >  OTOH, I don't
> > understand why it is needed, we never change ->comm[TASK_COMM_LEN-1] == '0'.
>
> I think the idea was that readers can see incomplete names, but not
> messed up names, consisting of old and new ones.

OK, agreed, comm[TASK_COMM_LEN-1] == '0' can't help to avoid the
messed names.

But nether can help smp_rmb() in the reading (lockless) side?

Say,

	printk("comm=%s\n", current->comm);

if we add rmb() before printk, it can't make any difference. The lockless
code should do something like

	get_comm_lockless(char *to, char *comm)
	{
		while (*comm++ = *to++)
			rmb();
	}

to ensure it sees the result of

	memset(tsk->comm, 0, TASK_COMM_LEN);
	wmb();
	strcpy(tsk->comm, buf);

in the right order.

otherwise printk("comm=%s\n", current->comm) can read, say, comm[1]
before set_task_comm->memset(), and comm[0] after set_task_comm->strcpy().

So, afaics, set_task_comm()->wmb() buys nothing and should be removed.
The last zero char in task_struct->comm[] is always here, at least this
guarantees that strcpy(char *dest, tsk->comm) is always safe.

(I cc'ed the expert, Paul can correct me)

Oleg.

