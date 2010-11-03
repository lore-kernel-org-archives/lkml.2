Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab0KCQRa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 12:17:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837Ab0KCQR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 12:17:29 -0400
Date: Wed, 3 Nov 2010 17:10:59 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [PATCH] posix-cpu-timers: rcu_read_lock/unlock protect
	find_task_by_vpid call
Message-ID: <20101103161059.GA13530@redhat.com>
References: <20101102135821.GA5964@swordfish.minsk.epam.com> <alpine.LFD.2.00.1011021630150.9357@localhost6.localdomain6> <20101102160223.GC5964@swordfish.minsk.epam.com> <alpine.LFD.2.00.1011021704110.9357@localhost6.localdomain6> <20101102183308.GA17720@redhat.com> <20101103105832.GA30053@swordfish.minsk.epam.com> <20101103124835.GA604@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101103124835.GA604@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03, Oleg Nesterov wrote:
>
> Sergey, Thomas, please wait a bit.
>
> Yes, I believe this patch is fine by itself. But looking into
> posix-cpu-timers.c again, I suspect that those "other problems
> with de_thread" I already mentioned are much more serious and
> need the urgent fix.

Yes. I'll send the patch tomorrow.


However, my initial thinking was wrong, that bug is orthogonal
to this patch.

Sergey, how much will you hate me if I ask you to re-send it again?


> > On (11/02/10 19:33), Oleg Nesterov wrote:
> > > > On Tue, 2 Nov 2010, Sergey Senozhatsky wrote:
> > > >
> > > > > > We can remove the tasklist_lock while at it. rcu_read_lock is enough.
> > > > > >
> > >
> > > Yes, I believe posix-cpu-timers.c shouldn't use tasklist at all,
> > > but it is not trivial to change this code.
> > >
> > >[..]
> > >
> > > I think this change is fine, but please note that thread_group_leader()
> > > check is not relaible without tasklist. If we race with de_thread()
> > > find_task_by_vpid() can find the new leader before it updates its
> > > ->group_leader. IOW, posix_cpu_timer_create() can fail when it shouldn't.
> > >
> > > Not that I think this really matters, posix_cpu_timer_create() has
> > > other problems with de_thread(). But perhaps it makes sense to
> > > change posix_cpu_timer_create() to use has_group_leader_pid() instead,
> > > just to make this code not look racy and avoid adding new problems.
> > >
> > > The real fix, I think, should change cpu_timer_list to use
> > > struct pid* instead of task_struct.
> > >
> >
> > Hello,
> > Using has_group_leader_pid instead of thread_group_leader, when tasklist_lock
> > is not aquired (check_clock and posix_cpu_timer_create).

This doesn't look like a valid changelog ;) I'd suggest you to write
the new one without quoting old emails. It should explain that a)
tasklist_lock is not enough for find_vpid() and b) it is not needed.

Also, you forgot to add your signed-of-by.

Otherwise,

Reviewed-by: Oleg Nesterov <oleg@redhat.com>

