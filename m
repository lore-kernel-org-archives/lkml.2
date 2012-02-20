Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab2BTVWD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 16:22:03 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34964 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab2BTVWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 16:22:01 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.220.168 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
Date: Mon, 20 Feb 2012 13:21:52 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Kent Overstreet <koverstreet@google.com>, axboe@kernel.dk,
        ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Chris Wright <chrisw@redhat.com>
Subject: Re: [PATCH 7/9] block: implement bio_associate_current()
Message-ID: <20120220212152.GD3538@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1329431878-28300-8-git-send-email-tj@kernel.org>
 <20120217011907.GA15073@google.com>
 <20120217221406.GJ29414@google.com>
 <20120217223420.GJ26620@redhat.com>
 <20120217224103.GN29414@google.com>
 <20120217225125.GK26620@redhat.com>
 <20120217225735.GP29414@google.com>
 <20120220142233.GA10342@redhat.com>
 <20120220165922.GA7836@mtj.dyndns.org>
 <20120220191404.GB13423@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120220191404.GB13423@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Feb 20, 2012 at 02:14:04PM -0500, Vivek Goyal wrote:
> Oh.., forgot that bio_blkio_blkcg() returns the current tasks's blkcg if
> bio->blkcg is not set. So if a task's cgroup changes, bio_blkcg() will
> point to latest cgroup and cfqq->cfqg->blkg->blkcg will point to old
> cgroup and test will indicate the discrepancy. So yes, it should work
> for both the cases.

Yeah, about the same thing for ioprio.  After all, if the cfqg is
pointing to the same blkcg / prio, we are using the right one, so
comparing to the current value should always give the correct result.
It can be thought of as caching the lookup instead of trying to keep
the two states in sync via async notification.  ie. cic caches the
cfqg used last time and if it doesn't match the current one we look up
the new one.

> In case of qemu IO threads, I have debugged issues where an big IO range
> is being splitted among its IO threads. Just do a sequential IO inside
> guest, and I was seeing that few sector IO comes from one process, next
> few sector come from other process and it goes on. A sequential range
> of IO is some split among a bunch of threads and that does not work
> well with CFQ if every IO is coming from its own IO context and IO
> context is not shared. After a bunch of IO from one io context, CFQ
> continues to idle on that io context thinking more IO will come soon.
> Next IO does come but from a different thread and differnet context.

That would be a matching use case or maybe we should improve aio
support so that qemu can simply use aio?

> I am ccing Chris Wright <chrisw@redhat.com>. He might have thoughts
> on usage of CLONE_IO and qemu.

Yeah, learning about actual use cases would be very helpful.

> Do we try to prevent sharing of io context across cgroups as of today?
> Can you point me to the relevant code chunk.

blkiocg_can_attach() in blk-cgroup.c.  We simply can't support it as
it may imply multiple cgroups per ioc.

> > > Can we logically say that io_context is owned by thread group leader and
> > > cgroup of io_context changes only if thread group leader changes the
> > > cgroup. So even if some threads are in different cgroup, IO gets accounted
> > > to thread group leaders's cgroup.
> > 
> > I don't think that's a good idea.  There are lots of multithreaded
> > heavy-IO servers and the behavior change can be pretty big and I don't
> > think the new behavior is necessarily better either.
> 
> But I thought above you mentioned that these multithread IO servers
> are not using CLONE_IO. If that's the case they don't get effected by
> this change.

Hmmm?  I thought you were suggesting changing the default behavior.

> I don't know. Those who have seen IO patterns from other applications can
> tell more, whether it is useful or it is just a dead interface.

blk-cgroup limitation seems rather severe to me and it can prevent
migrating tasks in very non-obvious way.  e.g. multiple controllers
mounted on the same cgroup hierarchy and the target process happens to
use CLONE_IO.  Migrating attempts will simply fail with -EINVAL - go
figure. :( And it seems nobody noticed rather serious breakage for
years so I was getting suspicious whether it was being used at all.

Thanks.

-- 
tejun
