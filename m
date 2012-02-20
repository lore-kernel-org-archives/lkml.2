Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab2BTTOL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 14:14:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17011 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602Ab2BTTOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 14:14:10 -0500
Date: Mon, 20 Feb 2012 14:14:04 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Kent Overstreet <koverstreet@google.com>, axboe@kernel.dk,
        ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Chris Wright <chrisw@redhat.com>
Subject: Re: [PATCH 7/9] block: implement bio_associate_current()
Message-ID: <20120220191404.GB13423@redhat.com>
References: <1329431878-28300-1-git-send-email-tj@kernel.org>
 <1329431878-28300-8-git-send-email-tj@kernel.org>
 <20120217011907.GA15073@google.com>
 <20120217221406.GJ29414@google.com>
 <20120217223420.GJ26620@redhat.com>
 <20120217224103.GN29414@google.com>
 <20120217225125.GK26620@redhat.com>
 <20120217225735.GP29414@google.com>
 <20120220142233.GA10342@redhat.com>
 <20120220165922.GA7836@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120220165922.GA7836@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 08:59:22AM -0800, Tejun Heo wrote:
> Hello, Vivek.
> 
> On Mon, Feb 20, 2012 at 09:22:33AM -0500, Vivek Goyal wrote:
> > I guess you will first determine cfqq associated with cic and then do
> > 
> > cfqq->cfqg->blkg->blkcg == bio_blkcg(bio)
> > 
> > One can do that but still does not get rid of requirement of checking
> > for CGRPOUP_CHANGED as not every bio will have cgroup information stored
> > and you still will have to check whether submitting task has changed
> > the cgroup since it last did IO.
> 
> Hmmm... but in that case task would be using a different blkg and the
> test would still work, wouldn't it?

Oh.., forgot that bio_blkio_blkcg() returns the current tasks's blkcg if
bio->blkcg is not set. So if a task's cgroup changes, bio_blkcg() will
point to latest cgroup and cfqq->cfqg->blkg->blkcg will point to old
cgroup and test will indicate the discrepancy. So yes, it should work
for both the cases.

> 
> > > blkcg doesn't allow that anyway (it tries but is racy) and I actually
> > > was thinking about sending a RFC patch to kill CLONE_IO.
> > 
> > I thought CLONE_IO is useful and it allows threads to share IO context.
> > qemu wanted to use it for its IO threads so that one virtual machine
> > does not get higher share of disk by just craeting more threads. In fact
> > if multiple threads are doing related IO, we would like them to use
> > same io context.
> 
> I don't think that's true.  Think of any multithreaded server program
> where each thread is working pretty much independently from others.

If threads are working pretty much independently, then one does not have
to specify CLONE_IO.

In case of qemu IO threads, I have debugged issues where an big IO range
is being splitted among its IO threads. Just do a sequential IO inside
guest, and I was seeing that few sector IO comes from one process, next
few sector come from other process and it goes on. A sequential range
of IO is some split among a bunch of threads and that does not work
well with CFQ if every IO is coming from its own IO context and IO
context is not shared. After a bunch of IO from one io context, CFQ
continues to idle on that io context thinking more IO will come soon.
Next IO does come but from a different thread and differnet context.

CFQ now has employed some techniques to detect that case and try
to do preemption and try to reduce idling in such cases. But sometimes
these techniques work well and other times don't.  So to me, CLONE_IO
can help in this case where application can specifically share
IO context and CFQ does not have to do all the tricks.

That's a different thing that applications might not be making use
of CLONE_IO.

> Virtualization *can* be a valid use case but are they actually using
> it?  Aren't they better served by cgroup?

cgroup can be very heavy weight when hundred's of virtual machines
are running. Why? because of idling. CFQ still has lots of tricks
to do preemption and cut down on idling across io contexts, but
across cgroup boundaries, isolation is much more stronger and very
little preemption (if any) is allowed. I suspect in current
implementation, if we create lots of blkio cgroup, it will be 
bad for overall throughput of virtual machines (purely because of
idling).

So I am not too excited about blkio cgroup solution because it might not
scale well. (Until and unless we find a better algorithm to cut down
on idling).

I am ccing Chris Wright <chrisw@redhat.com>. He might have thoughts
on usage of CLONE_IO and qemu.

> 
> > Those programs who don't use CLONE_IO (dump utility),
> > we try to detect closely realted IO in CFQ and try to merge cfq queues.
> > (effectively trying to simulate shared io context).
> >
> > Hence, I think CLONE_IO is useful and killing it probably does not buy
> > us much.
> 
> I don't know.  Anything can be useful to somebody somehow.  I'm
> skeptical whether ioc sharing is justified.  It was first introduced
> for syslets which never flew and as you asked in another message the
> implementation has always been broken (it likely ends up ignoring
> CLONE_IO more often than not) and *nobody* noticed the brekage all
> that time.
> 
> Another problem is it doesn't play well with cgroup.  If you start
> sharing ioc among tasks, those tasks can't be migrated to other
> cgroups.  The enforcement of that, BTW, is also broken.

Do we try to prevent sharing of io context across cgroups as of today?
Can you point me to the relevant code chunk.

> 
> So, to me, it looks like a mostly unused feature which is broken left
> and right, which isn't even visible through the usual pthread
> interface.

> 
> > Can we logically say that io_context is owned by thread group leader and
> > cgroup of io_context changes only if thread group leader changes the
> > cgroup. So even if some threads are in different cgroup, IO gets accounted
> > to thread group leaders's cgroup.
> 
> I don't think that's a good idea.  There are lots of multithreaded
> heavy-IO servers and the behavior change can be pretty big and I don't
> think the new behavior is necessarily better either.

But I thought above you mentioned that these multithread IO servers
are not using CLONE_IO. If that's the case they don't get effected by
this change.

I thought sharing io_context was similar to shared memory pages accounting
in memcg where the process which touched page first gets accounted for
it and other process get a free ride irrespective of cgroups. And when
page owning process moves to a different cgroup, all the accounting
also moves. (Hopefully I remember the details of memcg correctly).

I don't know. Those who have seen IO patterns from other applications can
tell more, whether it is useful or it is just a dead interface.

Thanks
Vivek
