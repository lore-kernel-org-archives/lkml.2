Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab2BTOWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 09:22:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47576 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752794Ab2BTOWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 09:22:40 -0500
Date: Mon, 20 Feb 2012 09:22:33 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Kent Overstreet <koverstreet@google.com>, axboe@kernel.dk,
        ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] block: implement bio_associate_current()
Message-ID: <20120220142233.GA10342@redhat.com>
References: <1329431878-28300-1-git-send-email-tj@kernel.org>
 <1329431878-28300-8-git-send-email-tj@kernel.org>
 <20120217011907.GA15073@google.com>
 <20120217221406.GJ29414@google.com>
 <20120217223420.GJ26620@redhat.com>
 <20120217224103.GN29414@google.com>
 <20120217225125.GK26620@redhat.com>
 <20120217225735.GP29414@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120217225735.GP29414@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 02:57:35PM -0800, Tejun Heo wrote:
> Hey, Vivek.
> 
> On Fri, Feb 17, 2012 at 05:51:26PM -0500, Vivek Goyal wrote:
> > Otherwise on every IO, we will end up comparing submitting tasks's
> > cgroup and cic/cfqq's cgroup.
> 
> But how much is that different from checking CHANGED bit on each IO?
> I mean, we can just do sth like cfqg->blkg->blkcg == bio_blkcg(bio).
> It isn't expensive.

I guess you will first determine cfqq associated with cic and then do

cfqq->cfqg->blkg->blkcg == bio_blkcg(bio)

One can do that but still does not get rid of requirement of checking
for CGRPOUP_CHANGED as not every bio will have cgroup information stored
and you still will have to check whether submitting task has changed
the cgroup since it last did IO.

> 
> > Also this will create problems, if two threads sharing io context are
> > in two different cgroups. We will frequently end up changing the
> > association.
> 
> blkcg doesn't allow that anyway (it tries but is racy) and I actually
> was thinking about sending a RFC patch to kill CLONE_IO.

I thought CLONE_IO is useful and it allows threads to share IO context.
qemu wanted to use it for its IO threads so that one virtual machine
does not get higher share of disk by just craeting more threads. In fact
if multiple threads are doing related IO, we would like them to use
same io context. Those programs who don't use CLONE_IO (dump utility),
we try to detect closely realted IO in CFQ and try to merge cfq queues.
(effectively trying to simulate shared io context).

Hence, I think CLONE_IO is useful and killing it probably does not buy
us much.

Can we logically say that io_context is owned by thread group leader and
cgroup of io_context changes only if thread group leader changes the
cgroup. So even if some threads are in different cgroup, IO gets accounted
to thread group leaders's cgroup.

So we can store ioc->blkcg association and this association changes when
thread group leader changes cgroup. We can possibly keep CHANGED_CGROUP
also around so that next time old cic->cfqq association is dropped and
a new one is established with new ioc->blkcg.

Thanks
Vivek
