Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab0EJM5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 08:57:52 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:55598 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab0EJM5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 08:57:49 -0400
To: Valerie Aurora <vaurora@redhat.com>
CC: miklos@szeredi.hu, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-reply-to: <20100429202012.GA6539@shell> (message from Valerie Aurora on
	Thu, 29 Apr 2010 16:20:12 -0400)
Subject: Re: [PATCH 16/35] union-mount: Writable overlays/union mounts documentation
References: <1271372682-21225-11-git-send-email-vaurora@redhat.com> <1271372682-21225-12-git-send-email-vaurora@redhat.com> <1271372682-21225-13-git-send-email-vaurora@redhat.com> <1271372682-21225-14-git-send-email-vaurora@redhat.com> <1271372682-21225-15-git-send-email-vaurora@redhat.com> <1271372682-21225-16-git-send-email-vaurora@redhat.com> <1271372682-21225-17-git-send-email-vaurora@redhat.com> <E1O4GKw-000257-Hh@pomaz-ex.szeredi.hu> <20100428201908.GC16691@shell> <E1O7Q7n-0002KC-Tm@pomaz-ex.szeredi.hu> <20100429202012.GA6539@shell>
Message-Id: <E1OBSYC-0004oQ-U4@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 10 May 2010 14:57:36 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Apr 2010, Valerie Aurora wrote:
> On Thu, Apr 29, 2010 at 11:33:39AM +0200, Miklos Szeredi wrote:
> > On Wed, 28 Apr 2010, Valerie Aurora wrote:
> > > I went down this road initially (do most of the unioning in a file
> > > system) and spent a couple of months on it.  But I always ended up
> > > having to do some level of copy-around and redirection similar to that
> > > in unionfs.
> > 
> > I haven't looked at unionfs in a long time.  Can you say something
> > more specific about what these problems were?
> 
> Sure.  The short version is that unionfs has to allocate another copy
> of each file system structure - inode, etc. - and then keep an array
> of the matching structures from each of the file system layers.

Let's not over-generalize the problem.  Current implementation has the
following properties:

 a) one read-only layer and one read-write layer
 b) for each non-directory only one of the layers is relevant
 c) for directories both layers may be relevant
 d) no need to go from a lower dentry or inode to an upper dentry/inode

>  Each
> unionfs file system op copies data up and down between the unionfs
> structures and the underlying structures, and then calls the lower
> file system op as necessary.  Often it has to duplicate code from the
> VFS before calling the lower file system ops.

Yep, and that can be fixed by adding better helpers to the VFS which
do all the locking magic, etc, and are supplied with a "struct path"
instead of a "char *".

> 
> Where union mounts has the advantage is that we make zero copies of
> file system data structures and therefore don't need copyup or
> interposition on as many ops.

My proposal a few mails back would eliminate that as well.

Imagine it like this: you have a filesystem full of symlinks.  Special
symlinks, in fact, which are always followed and so are invisible from
userspace.

What this means is that it's not necessary to interposition on any
operation that:

 - doesn't modify the file and is not a lookup, or
 - where file/directory is fully on the upper layer

>  But if you wait until the file system
> op is called, you have to attach your union-related data to the
> associated data structure, and the underlying file system is already
> using the private data pointer.  And you have to keep a copy of the
> underlying file system ops.  And each data structure can be part of
> multiple unions.  So you end up with an effective second copy of the
> file system data structure and a mess of linked lists or pointers.

For the simplified case all we need in each union fs inode is a
reference to a dentry in either the lower or upper layers, and in the
rare case of unioned directory a reference to a denty in both.

And notice, that is exactly the same as what you have in union mounts.
It shouldn't make too much difference if those refs are stored in a
filesystem or in a VFS level union structure.

> > > One of the major difficulties that arises even when doing unioning at
> > > the VFS level is keeping around the parent's path in order to do the
> > > copyup later on.  Take a look at the code pattern in the "union-mount:
> > > Implement union-aware syscall()" series of patches.  That's the
> > > prettiest and most efficient version I could come up with, after two
> > > other implementations, and it's in the VFS, at the vfs_foo_syscall()
> > > level.  I don't even know how I would start if I had to wait until the
> > > file system op is called.
> > 
> > On a high level I don't see a problem, the parent of every dentry can
> > be found through ->d_parent.
> 
> Unfortunately, dentries aren't unioned - paths (dentry/mnt pairs) are.

That's simply not true, we are unioning *filesystems* not paths.  And
that's true of union mounts as well.

Unioning of complete namespaces is a completely different, and orders
of magnitude more complex issue.

> So you can get the parent dentry in the file system op, but the dentry
> is potentially part of many different mounts.

And that's irrelevant.  The union filesystem can make a pair of
private, kernel-only, mounts for the underlying filesystems and be
done with that.

>  There's no mapping from
> a lower-level read-only dentry to the covering read-write parent
> dentry because the read-only dentry could potentially be mounted in 5
> different places.  Which union mount is this dentry part of?

If we keep to the simplified rules, then there's no need to map from a
lower dentry to an upper dentry.

> I think the chmod() case really shows the issues well.  user_path_nd()
> records the parent's path during lookup (in an inefficient, possibly
> racy manner), then union_copyup() does the copy (too early, before a
> lot of permission checks).  The underlying file system doesn't get
> involved until the ->setattr() call in notify_change(), and all that
> gets is the dentry.

The same can be done with the union fs, except copy up is done by the
union filesystem instead of the VFS.  And that is _after_ the
permission checks.

> > One issue is having to duplicate some locking and other stuff around
> > vfs_whatever() calls.  But that could be fixed by exporting suitable
> > helpers from the VFS.
> 
> That's somewhat of an issue right now.  For union mounts to be most
> efficient and wonderful, system calls should be separated into two
> sequential parts called from the same context as the user_path()
> lookup:
> 
> 1) permission checks and all read-only checks that can fail.
> [union copyup happens here]
> 2) the actual write or change to the file system
> 
> Otherwise we have to push the parent nameidata down through the stack
> to where the actual change happens.  So if want to avoid copying up
> the file unless chmod() succeeds, in the current code structure I'd
> have to add a nameidata and a mnt to notify_change()'s arguments.  But
> this is an optimization, not a correctness problem.

Not quite, allowing unprivileged users to trigger arbitrary copy-up is
clearly a DoS.

Thanks,
Miklos
