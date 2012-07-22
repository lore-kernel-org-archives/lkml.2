Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab2GVTMw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 15:12:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58514 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab2GVTMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 15:12:51 -0400
Date: Sun, 22 Jul 2012 12:12:07 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Aristeu Rozanski <aris@ruivo.org>
cc: Tejun Heo <tj@kernel.org>, Aristeu Rozanski <aris@redhat.com>,
        linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH v3 0/3] cgroup: add xattr support
In-Reply-To: <20120720175959.GA32741@cathedrallabs.org>
Message-ID: <alpine.LSU.2.00.1207221136160.1896@eggly.anvils>
References: <20120702142925.795007114@napanee.usersys.redhat.com> <20120717204126.GE24336@google.com> <alpine.LSU.2.00.1207181237010.2160@eggly.anvils> <20120718221044.GJ24336@google.com> <alpine.LSU.2.00.1207181736020.3323@eggly.anvils>
 <20120720175959.GA32741@cathedrallabs.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jul 2012, Aristeu Rozanski wrote:
> On Wed, Jul 18, 2012 at 06:11:32PM -0700, Hugh Dickins wrote:
> > > But why do we need something completely new?  Can't we hijack some
> > > inodes used by tmpfs and use them for xattr storage?  ie. Would it be
> > > difficult to use tmpfs as backend storage for on-memory xattr?  With
> > > that, we would already have the mechanism and interface(!) for
> > > limiting the size.
> > 
> > That sounds just like what I was suggesting in my last sentence:
> > let userspace manage a tmpfs hierarchy parallel to the cgroupfs one.
> > 
> > Except, perhaps, where I assume "userspace" should be doing the hard work.
> 
> hm, not sure that's what Tejun meant. tmpfs uses anonymous memory for the file
> contents, so reuse that infrastructure to allocate space for the extended
> attributes the same way, instead of using kmem.
> 
> First thing I can think of is to use whole pages for it to prevent further
> complexity. Shouldn't make much difference considering the usecases we have
> now (systemd and containers), right?

Please, do not do this.

It may be fun to implement, but not to review and maintain.

If we're going to start supporting swappable kernel memory, tmpfs
xattrs is not the right place to start, and libfs xattrs certainly not:
they are a poor fit for swappable memory.  (You contemplate using whole
pages above: that will not be very kind to those without swap.)

By all means continue Zefan's work to move xattr support from tmpfs
to libfs (ah, to fs/xattr.c actually, okay), but keep them as kmem.

Support setting and removing user xattrs only if the user has the
appropriate capability (which root will have): looking through the
list of existing capabilities, CAP_IPC_LOCK actually looks appropriate,
although I admit its name certainly does not - it's the "lock down
unlimited amounts of memory" capability.

And support setting and removing user xattrs only if the filesystem
opts in to that: so cgroupfs can opt in, everything else stay out,
and we know where to look when memory goes missing.

Will "lsattr -R" in the cgroupfs mountpoint do enough to judge how
much memory is being used in this way?  I expect not, but I'm
unfamliar with it: you may need to show counts elsewhere.

If we keep an eye on those counts as systemd starts to make use of
this feature, perhaps a real case for making this memory swappable
will emerge; but more likely, a case for systemd to be economical
with them - they may be good for storing paths to data blobs, but
I doubt they're good for large blobs.

Hugh
