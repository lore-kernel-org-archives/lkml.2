Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759355Ab2K3S5u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 13:57:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416Ab2K3S5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:57:47 -0500
Date: Fri, 30 Nov 2012 19:57:09 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jeff Chua <jeff.chua.linux@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jan Kara <jack@suse.cz>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: [PATCH 1/2] percpu-rwsem: use synchronize_sched_expedited
Message-ID: <20121130185709.GA13238@redhat.com>
References: <CA+55aFyvT3R3kgwJzp9mY5eE1fwMnzXnmBpHSbqjd-eJRVDkJw@mail.gmail.com> <50AF7901.20401@kernel.dk> <CAAJw_ZvXGKcjfOAS_tRdXJ9SjpCKw1t7rNt+Q=ieCkVJwN2qcg@mail.gmail.com> <Pine.LNX.4.64.1211241555470.4300@file.rdu.redhat.com> <CAAJw_ZvUqRmCCQ5-2PdFPRyfdzZMuphGU=hgAjUOHGk=n9Mheg@mail.gmail.com> <CAAJw_ZuJXnAz1ukBwQa3xNbQaL1KUBSrbQMK2hn-7D6Ar1p3fQ@mail.gmail.com> <50B46E05.70906@kernel.dk> <CAAJw_ZsYuLCwCTc6U=ELO_PvyjnVKQdkPke2enfzm6zOeWAqjA@mail.gmail.com> <Pine.LNX.4.64.1211272257140.18338@file.rdu.redhat.com> <20121129160607.06a063bb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121129160607.06a063bb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29, Andrew Morton wrote:
>
> On Tue, 27 Nov 2012 22:59:52 -0500 (EST)
> Mikulas Patocka <mpatocka@redhat.com> wrote:
>
> > percpu-rwsem: use synchronize_sched_expedited
> >
> > Use synchronize_sched_expedited() instead of synchronize_sched()
> > to improve mount speed.
> >
> > This patch improves mount time from 0.500s to 0.013s.
> >
> > Note: if realtime people complain about the use
> > synchronize_sched_expedited() and synchronize_rcu_expedited(), I suggest
> > that they introduce an option CONFIG_REALTIME or
> > /proc/sys/kernel/realtime and turn off these *_expedited functions if
> > the option is enabled (i.e. turn synchronize_sched_expedited into
> > synchronize_sched and synchronize_rcu_expedited into synchronize_rcu).
> >
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>
> So I read through this thread but I really didn't see a clear
> description of why mount() got slower.  The changelog for 4b05a1c74d1
> is spectacularly awful :(
>
>
> Apparently the slowdown occurred because a blockdev mount patch
> 62ac665ff9fc07497ca524 ("blockdev: turn a rw semaphore into a percpu rw
> semaphore") newly uses percpu rwsems, and percpu rwsems are slow on the
> down_write() path.
>
> And using synchronize_sched_expedited() rather than synchronize_sched()
> makes percpu_down_write() somewhat less slow.  Correct?
>
> Why is it OK to use synchronize_sched_expedited() here?  If it's
> faster, why can't we use synchronize_sched_expedited() everywhere and
> zap synchronize_sched()?

synchronize_sched_expedited() is much faster but it is heavyweight,
try_stop_cpus() affects the whole system.

We briefly discussed this possibility with Paul, personally I think it
would be better to add percpu_rw_semaphore->use_expedited or add the
percpu_down_write_expedited().

But this change was already applied. I hope we can do this later.

> Oleg, this has implications for your
> percpu_rw_semaphore-reimplement-to-not-block-the-readers-unnecessarily.patch.
> I've changed that to use synchronize_sched_expedited() everywhere -
> please have a think and a retest.

Thanks a lot Andrew. The fix looks obviously fine, but I'll try to test
anyway.

> Note that elsewhere in this thread,
> percpu_rw_semaphore-reimplement-to-not-block-the-readers-unnecessarily.patch
> was found to slow mount down again somewhat, because it adds an
> additional synchronize_sched[_expedited]() to the percpu_down_write()
> path.

Cough... this patch _removes_ one synchronize_sched[_expedited]() and
removes msleep ;) Although the main point was not-block-the-readers.

And I think we can remove another one, but this is not trivial and
percpu_free_rwsem() should be might_sleep().

Oleg.

