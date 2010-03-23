Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab0CWSdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 14:33:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657Ab0CWSdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 14:33:18 -0400
Date: Tue, 23 Mar 2010 19:31:16 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 0/3] proc: task->signal can't be NULL
Message-ID: <20100323183116.GA22516@redhat.com>
References: <20100322184127.GA3952@redhat.com> <m1ocifvkzl.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ocifvkzl.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@redhat.com> writes:
>
> > Can't we kill this counter? Afaics, get_nr_threads() doesn't need to
> > be "precise", we probably can estimate the number of threads using
> > signal->live (yes sure, we can't use ->live as nr_threads).
> >
> > Except: first_tid() uses get_nr_threads() for optimization. Is this
> > optimization really important? Afaics, it only helps in the unlikely
> > case, probably in that case the extra lockless while_each_thread()
> > doesn't hurt.
> >
> > IOW, how about
> >
> > 	--- a/fs/proc/base.c
> > 	+++ b/fs/proc/base.c
> > 	@@ -3071,11 +3071,6 @@ static struct task_struct *first_tid(str
> > 				goto found;
> > 		}
> >
> > 	-	/* If nr exceeds the number of threads there is nothing todo */
> > 	-	pos = NULL;
> > 	-	if (nr && nr >= get_nr_threads(leader))
> > 	-		goto out;
> > 	-
> > 		/* If we haven't found our starting place yet start
> > 		 * with the leader and walk nr threads forward.
> > 		 */
> >
> > ?
> >
> > Not that I think it is terribly important to kill this counter, and
> > probably signal->nr_threads can make sense anyway, so far I am just
> > curious.
>
> I think that was just a sanity check since it was easy.  I want to say
> it prevents a DOS attack with user space passing unreasonably large
> file position but that DOS attack is handled by ensuring we don't walk
> through the list if threads more than once.

If a bad user passes the large f_pos > nr_threads then this check
eliminates the unneeded while_each_thread() loop, yes. But it can use
f_pos == nr_threads and provoke the same loop?

Or. just do rewinddir() + readdir(big_count). Now we walk through the
list and call proc_task_fill_cache() for each entry.

IOW, I don't understand how this check can help from the DOS pov.

> However:
> proc_task_getattr uses get_nr_threads to get it's nlink count correct.

Yes. But we don't need the exactly precise number here if we are
racing with fork/exit ?

> Not walking the thread list to get the number of threads seems like an
> important cpu time saving measure.

Not sure I understand... Also, first_tid() could use sig->sigcnt (the
reference counter) instead of sig->count. This is not the same, but I
think in practice this is fine.


OK. Let's keep this counter as "int nr_thread".

Besides, when I tried to re-implement get_nr_threads() using signal->live
I got the really ugly result ;)

Thanks.

Oleg.

