Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868Ab2GXU1r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 16:27:47 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:41039 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755426Ab2GXU1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 16:27:45 -0400
Date: Tue, 24 Jul 2012 16:27:38 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Rajat Sharma <fs.rajat@gmail.com>
Cc: Ankit Jain <jankit@suse.de>, Al Viro <viro@zeniv.linux.org.uk>,
        bcrl@kvack.org, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: Re: [RFC][PATCH] Make io_submit non-blocking
Message-ID: <20120724202738.GC29239@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Rajat Sharma <fs.rajat@gmail.com>, Ankit Jain <jankit@suse.de>,
	Al Viro <viro@zeniv.linux.org.uk>, bcrl@kvack.org,
	linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
	linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>
References: <500E89D1.9010303@suse.de>
 <CAAYFAvp7xDG8et_dyqSgEVOAr7ykNBkgBhs1m5gGjoOdQFkxGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAYFAvp7xDG8et_dyqSgEVOAr7ykNBkgBhs1m5gGjoOdQFkxGQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 06:04:23PM +0530, Rajat Sharma wrote:
> >
> > Currently, io_submit tries to execute the io requests on the
> > same thread, which could block because of various reaons (eg.
> > allocation of disk blocks). So, essentially, io_submit ends
> > up being a blocking call.
> 
> Ideally filesystem should take care of it e.g. by deferring such time
> consuming allocations and return -EIOCBQUEUED immediately. But have
> you seen such cases?

Oh, it happens all the time if you are using AIO.  If the file system
needs to read or write any metadata block, AIO can become distinctly
non-"A".  The workaround that I've chosen is to create a way to cache
the information needed for the bmap() operation, triggered via an
ioctl() issued at open time, so that this is not an issue, but that
only works if the file is pre-allocated, and there is no need to do
any block allocations.

It's all very well and good to say, "the file system should handle
it", but that just pushes the problem onto the file system.  And since
you need to potentially issue block I/O requests, which you can't do
from an interrupt context (i.e., a block I/O completion handler), you
really do need to create a workqueue in order to make things work.

If you do it in the fs/direct_io.c layer, at least that way you can
solve the problem once for all file systems....

> With lots of application threads firing continuous IOs, workqueue
> threads might become bottleneck and you might have to eventually
> develop a priority scheduling. This workqueue was originally designed
> for IO retries which is an error path, now consumers of workqueue
> might easily increase by 100x.

Yes, you definitely need to throttle how many outstanding AIO's can be
allowed to be outstanding, either globally, or on a
per-superblock/process/user/cgroup basis, and return EAGAIN if there
are too many outstanding requests.

Speaking of cgroups, one of the other challenges with running the AIO
out of a workqueue is trying to respect cgroup restrictions.  In
particular, the io-throttle cgroup (which is needed to provide
Proportional I/O support), but also the memory cgroup.

All of these complications is why I decided to simply go with the "pin
metadata" approach, since I didn't need to worry (at least initially)
with the allocating write case.  (These patches to ext4 haven't yet
been published upstream, mainly because they need a lot of cleanup
work and I haven't had time to do that cleanup; my intention is to get
the "big extents" patchset upstream, though.)

						- Ted
