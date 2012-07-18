Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866Ab2GRUCn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 16:02:43 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34244 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351Ab2GRUCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 16:02:40 -0400
Date: Wed, 18 Jul 2012 13:02:03 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Tejun Heo <tj@kernel.org>
cc: Aristeu Rozanski <aris@redhat.com>, linux-kernel@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH v3 0/3] cgroup: add xattr support
In-Reply-To: <20120717204126.GE24336@google.com>
Message-ID: <alpine.LSU.2.00.1207181237010.2160@eggly.anvils>
References: <20120702142925.795007114@napanee.usersys.redhat.com> <20120717204126.GE24336@google.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2012, Tejun Heo wrote:
> On Mon, Jul 02, 2012 at 10:29:25AM -0400, Aristeu Rozanski wrote:
> > This series are a refreshed version of a patchset submitted by Li Zefan back
> > in march:
> > 	https://lkml.org/lkml/2012/3/1/13
> > 
> > With Li's permission, I refreshed the patches to apply over the latest upstream
> > and added the modifications suggested by others in the thread:
> > - using a mount option instead of config option to enable the xattr support
> > - reinitialize the list in kmem_xattrs_free()
> > - renamed functions to simple_xattr_*()
> > 
> > Signed-off-by: Li Zefan <lizefan@huawei.com>
> > Signed-off-by: Aristeu Rozanski <aris@redhat.com>
> 
> I raised this point before but I'm worried about directly exposing
> kernel memory through xattr interface to userland.

Quite rightly.

> Maybe it's okay as long as !root users are kept from creating them.

That's how I see it with tmpfs.

> I don't know.  I
> really hope it used anonymous page cache instead of kmem tho.  Hugh,
> would something like that be difficult?

Yes, it would be difficult.

You don't use the word "swappable", but I take that to be implicit
when you say "anonymous ... instead of kmem": it might as well be
kmem if it cannot be swapped.

So you're wondering whether to introduce a new category of swappable
memory: not the original anon pages mapped into userspace, not shmem
use of swappable pages, but xattrs in the cgroup filesystem?

I think it would be foolish to add that dimension of complication
just for cgroupfs xattrs - the shmem/tmpfs case gives enough surprises
as it is.

If we were going to consider swappable kernel memory, we'd be choosing
easier targets (page tables and stacks), than something that at present
is being served by slab objects.

Or am I misunderstanding, or looking at this from the wrong angle?

If there's not a reasonable upper bound on what gets stored here
(did I see the word "icon" earlier in the thread?  which made me
think people would be loading their photo albums into these xattrs),
maybe the problem does need turning around.

Let userspace manage a tmpfs hierarchy parallel to the cgroupfs one?

Hugh
