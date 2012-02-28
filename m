Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab2B1OKp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 09:10:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299Ab2B1OKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 09:10:43 -0500
Date: Tue, 28 Feb 2012 09:10:36 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Chris Wright <chrisw@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Kent Overstreet <koverstreet@google.com>,
        axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] block: implement bio_associate_current()
Message-ID: <20120228141036.GE9920@redhat.com>
References: <20120217011907.GA15073@google.com>
 <20120217221406.GJ29414@google.com>
 <20120217223420.GJ26620@redhat.com>
 <20120217224103.GN29414@google.com>
 <20120217225125.GK26620@redhat.com>
 <20120217225735.GP29414@google.com>
 <20120220142233.GA10342@redhat.com>
 <20120220165922.GA7836@mtj.dyndns.org>
 <20120220191404.GB13423@redhat.com>
 <20120227231222.GF14856@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120227231222.GF14856@x200.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 03:12:22PM -0800, Chris Wright wrote:

[..]
> > > > > blkcg doesn't allow that anyway (it tries but is racy) and I actually
> > > > > was thinking about sending a RFC patch to kill CLONE_IO.
> > > > 
> > > > I thought CLONE_IO is useful and it allows threads to share IO context.
> > > > qemu wanted to use it for its IO threads so that one virtual machine
> > > > does not get higher share of disk by just craeting more threads. In fact
> > > > if multiple threads are doing related IO, we would like them to use
> > > > same io context.
> > > 
> > > I don't think that's true.  Think of any multithreaded server program
> > > where each thread is working pretty much independently from others.
> > 
> > If threads are working pretty much independently, then one does not have
> > to specify CLONE_IO.
> > 
> > In case of qemu IO threads, I have debugged issues where an big IO range
> > is being splitted among its IO threads. Just do a sequential IO inside
> > guest, and I was seeing that few sector IO comes from one process, next
> > few sector come from other process and it goes on. A sequential range
> > of IO is some split among a bunch of threads and that does not work
> > well with CFQ if every IO is coming from its own IO context and IO
> > context is not shared. After a bunch of IO from one io context, CFQ
> > continues to idle on that io context thinking more IO will come soon.
> > Next IO does come but from a different thread and differnet context.
> > 
> > CFQ now has employed some techniques to detect that case and try
> > to do preemption and try to reduce idling in such cases. But sometimes
> > these techniques work well and other times don't.  So to me, CLONE_IO
> > can help in this case where application can specifically share
> > IO context and CFQ does not have to do all the tricks.
> > 
> > That's a different thing that applications might not be making use
> > of CLONE_IO.
> > 
> > > Virtualization *can* be a valid use case but are they actually using
> > > it?  Aren't they better served by cgroup?
> > 
> > cgroup can be very heavy weight when hundred's of virtual machines
> > are running. Why? because of idling. CFQ still has lots of tricks
> > to do preemption and cut down on idling across io contexts, but
> > across cgroup boundaries, isolation is much more stronger and very
> > little preemption (if any) is allowed. I suspect in current
> > implementation, if we create lots of blkio cgroup, it will be 
> > bad for overall throughput of virtual machines (purely because of
> > idling).
> > 
> > So I am not too excited about blkio cgroup solution because it might not
> > scale well. (Until and unless we find a better algorithm to cut down
> > on idling).
> > 
> > I am ccing Chris Wright <chrisw@redhat.com>. He might have thoughts
> > on usage of CLONE_IO and qemu.
> 
> Vivek, you summed it up pretty well.  Also, for qemu, raw CLONE_IO is not
> an option because threads are created via pthread (we had done some local
> hacks to verify that CLONE_IO helped w/ the idling problem, and it did).

Chris,

Just to make sure I understand it right I am thinking loud.

That means CLONE_IO is useful and ideally qemu would like to make use of it
but beacuse pthread interface does not support it, it is not used as of
today.

Thanks
Vivek
