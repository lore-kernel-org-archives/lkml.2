Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407Ab0FRWjE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 18:39:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585Ab0FRWjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 18:39:01 -0400
Date: Sat, 19 Jun 2010 00:37:13 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Don Zickus <dzickus@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jerome Marchand <jmarchan@redhat.com>,
       Mandeep Singh Baines <msb@google.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: while_each_thread() under rcu_read_lock() is broken?
Message-ID: <20100618223713.GA3233@redhat.com>
References: <20100618190251.GA17297@redhat.com> <20100618193403.GA17314@redhat.com> <20100618210801.61B4540162@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100618210801.61B4540162@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18, Roland McGrath wrote:
>
> I think you're right.  I can't see what would prevent that race.

How sad.

> So for_each_process

for_each_process() looks fine. It uses init_task as the anchor,
it can't go away, it is swapper.

> and do_each_thread are safe only under
> read_lock(&tasklist_lock) and while_each_thread is only safe under
> either that or siglock.

Yes,

(Also a few places using next_thread in
> similar loops outside those macros.)

I hope that most (all?) of next_thread() users can be converted to
use while_each_thread().

> Perhaps we could move those del's from __unhash_process to
> __put_task_struct (or just delayed_put_task_struct?)

This needs write_lock_irq(tasklist), we can't take it in atomic
context. And I bet this change (at least right now) has other
implications.

> I think de_thread() in exec-by-nonleader is the only case where this
> can happen, right?  So then perhaps we could make it call release_task
> only via call_rcu?

Hmm, perhaps...  I am already sleeping, will try to check this idea
tomorrow. At first glance, it looks promising to me. And I see the
email from Paul which is too late to read for me today ;)

In any case, I _think_ we can fix while_each_thread(), say XXX(t)
from the previous email. But then we should audit the users like
zap_threads() which assume we should not miss any "interesting" task.
Probably zap_threads() is fine because of mmap_sem, but I can't
think properly now.

Oleg.

