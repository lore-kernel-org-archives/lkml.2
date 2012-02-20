Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab2BTQ72 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 11:59:28 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48489 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab2BTQ71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 11:59:27 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.224.9 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
Date: Mon, 20 Feb 2012 08:59:22 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Kent Overstreet <koverstreet@google.com>, axboe@kernel.dk,
        ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] block: implement bio_associate_current()
Message-ID: <20120220165922.GA7836@mtj.dyndns.org>
References: <1329431878-28300-1-git-send-email-tj@kernel.org>
 <1329431878-28300-8-git-send-email-tj@kernel.org>
 <20120217011907.GA15073@google.com>
 <20120217221406.GJ29414@google.com>
 <20120217223420.GJ26620@redhat.com>
 <20120217224103.GN29414@google.com>
 <20120217225125.GK26620@redhat.com>
 <20120217225735.GP29414@google.com>
 <20120220142233.GA10342@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120220142233.GA10342@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Vivek.

On Mon, Feb 20, 2012 at 09:22:33AM -0500, Vivek Goyal wrote:
> I guess you will first determine cfqq associated with cic and then do
> 
> cfqq->cfqg->blkg->blkcg == bio_blkcg(bio)
> 
> One can do that but still does not get rid of requirement of checking
> for CGRPOUP_CHANGED as not every bio will have cgroup information stored
> and you still will have to check whether submitting task has changed
> the cgroup since it last did IO.

Hmmm... but in that case task would be using a different blkg and the
test would still work, wouldn't it?

> > blkcg doesn't allow that anyway (it tries but is racy) and I actually
> > was thinking about sending a RFC patch to kill CLONE_IO.
> 
> I thought CLONE_IO is useful and it allows threads to share IO context.
> qemu wanted to use it for its IO threads so that one virtual machine
> does not get higher share of disk by just craeting more threads. In fact
> if multiple threads are doing related IO, we would like them to use
> same io context.

I don't think that's true.  Think of any multithreaded server program
where each thread is working pretty much independently from others.
Virtualization *can* be a valid use case but are they actually using
it?  Aren't they better served by cgroup?

> Those programs who don't use CLONE_IO (dump utility),
> we try to detect closely realted IO in CFQ and try to merge cfq queues.
> (effectively trying to simulate shared io context).
>
> Hence, I think CLONE_IO is useful and killing it probably does not buy
> us much.

I don't know.  Anything can be useful to somebody somehow.  I'm
skeptical whether ioc sharing is justified.  It was first introduced
for syslets which never flew and as you asked in another message the
implementation has always been broken (it likely ends up ignoring
CLONE_IO more often than not) and *nobody* noticed the brekage all
that time.

Another problem is it doesn't play well with cgroup.  If you start
sharing ioc among tasks, those tasks can't be migrated to other
cgroups.  The enforcement of that, BTW, is also broken.

So, to me, it looks like a mostly unused feature which is broken left
and right, which isn't even visible through the usual pthread
interface.

> Can we logically say that io_context is owned by thread group leader and
> cgroup of io_context changes only if thread group leader changes the
> cgroup. So even if some threads are in different cgroup, IO gets accounted
> to thread group leaders's cgroup.

I don't think that's a good idea.  There are lots of multithreaded
heavy-IO servers and the behavior change can be pretty big and I don't
think the new behavior is necessarily better either.

Thanks.

--
tejun
