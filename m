Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab1JLRzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 13:55:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453Ab1JLRza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 13:55:30 -0400
Date: Wed, 12 Oct 2011 19:51:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <htejun@gmail.com>
Cc: rjw@sisk.pl, paul@paulmenage.org, lizf@cn.fujitsu.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, fweisbec@gmail.com,
        matthltc@us.ibm.com, akpm@linux-foundation.org,
        Paul Menage <menage@google.com>, Ben Blum <bblum@andrew.cmu.edu>
Subject: Re: [PATCH 3/4] threadgroup: extend threadgroup_lock() to cover
	exit and exec
Message-ID: <20111012175104.GA6156@redhat.com>
References: <1315159280-25032-1-git-send-email-htejun@gmail.com> <1315159280-25032-4-git-send-email-htejun@gmail.com> <20110918173723.GA2384@redhat.com> <20111010171105.GE8100@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111010171105.GE8100@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/10, Tejun Heo wrote:
>
> Hope you can still remember some
> of this one. :)

I am not sure ;)

> On Sun, Sep 18, 2011 at 07:37:23PM +0200, Oleg Nesterov wrote:
> > > With this change, threadgroup_lock() guarantees that the target
> > > threadgroup will remain stable - no new task will be added, no new
> > > PF_EXITING will be set and exec won't happen.
> >
> > To me, this is the only "contradictory" change,
>
> What do you mean "contradictory"?  Can you please elaborate?

Because, iirc, with this patch do_exit() does (almost) everything
under rw_sem. OK, down_read() should be cheap, but still.

See also below.

> > > +	/*
> > > +	 * Release threadgroup and make sure we are holding no locks.
> > > +	 */
> > > +	threadgroup_change_done(tsk);
> >
> > I am wondering, can't we narrow the scope of threadgroup_change_begin/done
> > in do_exit() path?
> >
> > The code after 4/4 still has to check PF_EXITING, this is correct. And yes,
> > with this patch PF_EXITING becomes stable under ->group_rwsem. But, it seems,
> > we do not really need this?
> >
> > I mean, can't we change cgroup_exit() to do threadgroup_change_begin/done
> > instead? We do not really care about PF_EXITING, we only need to ensure that
> > we can't race with cgroup_exit(), right?
>
> If we confine our usage to cgroup, excluding just against
> cgroup_exit() might work although this is still a bit nasty.  ie. some
> callbacks might not expect half torn-down tasks in methods other than
> the exit callback.

Oh, sorry, I don't understand... I already forgot the details.

> Also, it makes the mechanism unnecessarily cgroup-specific without
> gaining much if anything.

Yes! And _personally_ I think it should be cgroup-specific, that is
why I dislike the very fact do_exit() uses it directly. To me it would
be cleaner to shift it into cgroup hooks. Yes, sure, this is subjective.

In fact I still hope we can kill this sem altogether, but so far I have
no idea how we can do this. We do need the new per-process lock to
protect (in particular) ->thread_group. It is quite possible that it
should be rw_semaphore. But in this case we down_write(), not _read
in exit/fork paths, and its scope should be small.

I do not think the current lock should have more users. Of course I
can be wrong. And what exactly it protects? I mean copy_process().
Almost everything, but this simply connects to cgroup fork hooks.

Just my opinion, I am not going to insist.

Oleg.

