Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750Ab0D3RWk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:22:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30982 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933143Ab0D3RVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:21:55 -0400
Date: Thu, 29 Apr 2010 16:20:12 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 16/35] union-mount: Writable overlays/union mounts documentation
Message-ID: <20100429202012.GA6539@shell>
References: <1271372682-21225-11-git-send-email-vaurora@redhat.com> <1271372682-21225-12-git-send-email-vaurora@redhat.com> <1271372682-21225-13-git-send-email-vaurora@redhat.com> <1271372682-21225-14-git-send-email-vaurora@redhat.com> <1271372682-21225-15-git-send-email-vaurora@redhat.com> <1271372682-21225-16-git-send-email-vaurora@redhat.com> <1271372682-21225-17-git-send-email-vaurora@redhat.com> <E1O4GKw-000257-Hh@pomaz-ex.szeredi.hu> <20100428201908.GC16691@shell> <E1O7Q7n-0002KC-Tm@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1O7Q7n-0002KC-Tm@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 29, 2010 at 11:33:39AM +0200, Miklos Szeredi wrote:
> On Wed, 28 Apr 2010, Valerie Aurora wrote:
> > I'm sorry I have responded sooner, I've been trying to write a
> > detailed useful message and that turns out to be hard.  I'll just
> > include a few of the highlights; mainly I want to say that I'd
> > rather do it the way you describe but when I tried it ended up even
> > uglier than the VFS implementation.
> > 
> > I went down this road initially (do most of the unioning in a file
> > system) and spent a couple of months on it.  But I always ended up
> > having to do some level of copy-around and redirection similar to that
> > in unionfs.
> 
> I haven't looked at unionfs in a long time.  Can you say something
> more specific about what these problems were?

Sure.  The short version is that unionfs has to allocate another copy
of each file system structure - inode, etc. - and then keep an array
of the matching structures from each of the file system layers.  Each
unionfs file system op copies data up and down between the unionfs
structures and the underlying structures, and then calls the lower
file system op as necessary.  Often it has to duplicate code from the
VFS before calling the lower file system ops.

Where union mounts has the advantage is that we make zero copies of
file system data structures and therefore don't need copyup or
interposition on as many ops.  But if you wait until the file system
op is called, you have to attach your union-related data to the
associated data structure, and the underlying file system is already
using the private data pointer.  And you have to keep a copy of the
underlying file system ops.  And each data structure can be part of
multiple unions.  So you end up with an effective second copy of the
file system data structure and a mess of linked lists or pointers.

> > One of the major difficulties that arises even when doing unioning at
> > the VFS level is keeping around the parent's path in order to do the
> > copyup later on.  Take a look at the code pattern in the "union-mount:
> > Implement union-aware syscall()" series of patches.  That's the
> > prettiest and most efficient version I could come up with, after two
> > other implementations, and it's in the VFS, at the vfs_foo_syscall()
> > level.  I don't even know how I would start if I had to wait until the
> > file system op is called.
> 
> On a high level I don't see a problem, the parent of every dentry can
> be found through ->d_parent.

Unfortunately, dentries aren't unioned - paths (dentry/mnt pairs) are.
So you can get the parent dentry in the file system op, but the dentry
is potentially part of many different mounts.  There's no mapping from
a lower-level read-only dentry to the covering read-write parent
dentry because the read-only dentry could potentially be mounted in 5
different places.  Which union mount is this dentry part of?  You have
to record the parent's path during lookup and carry it around until
you do the copyup - for every syscall that alters a file, not just
open() and write(), but chmod(), etc.  So if you implement it in the
VFS, you don't have to carry that info across the file system op
boundary.

I think the chmod() case really shows the issues well.  user_path_nd()
records the parent's path during lookup (in an inefficient, possibly
racy manner), then union_copyup() does the copy (too early, before a
lot of permission checks).  The underlying file system doesn't get
involved until the ->setattr() call in notify_change(), and all that
gets is the dentry.

> One issue is having to duplicate some locking and other stuff around
> vfs_whatever() calls.  But that could be fixed by exporting suitable
> helpers from the VFS.

That's somewhat of an issue right now.  For union mounts to be most
efficient and wonderful, system calls should be separated into two
sequential parts called from the same context as the user_path()
lookup:

1) permission checks and all read-only checks that can fail.
[union copyup happens here]
2) the actual write or change to the file system

Otherwise we have to push the parent nameidata down through the stack
to where the actual change happens.  So if want to avoid copying up
the file unless chmod() succeeds, in the current code structure I'd
have to add a nameidata and a mnt to notify_change()'s arguments.  But
this is an optimization, not a correctness problem.

-VAL
