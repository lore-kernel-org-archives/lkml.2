Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab0H0HGF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 03:06:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54358 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092Ab0H0HGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 03:06:03 -0400
Date: Fri, 27 Aug 2010 17:05:51 +1000
From: Neil Brown <neilb@suse.de>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        vaurora@redhat.com, viro@zeniv.linux.org.uk, jblunck@suse.de,
        hch@infradead.org
Subject: Re: [PATCH 0/5] hybrid union filesystem prototype
Message-ID: <20100827170551.19616048@notabene>
In-Reply-To: <20100826183340.027591901@szeredi.hu>
References: <20100826183340.027591901@szeredi.hu>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Aug 2010 20:33:40 +0200
Miklos Szeredi <miklos@szeredi.hu> wrote:

> This is the result of my experimentation with trying to do
> union-mounts like semantics with a filesystem.  The implementation is
> far from perfect, but I think the concept does sort of work.  See the
> patch header for the union filesystem.
> 
> VFS modifications necessary to make it work:
> 
>   - allow f_op->open() to return a different file
>   - pass dentry to i_op->permission() instead of inode
>   - hack to vfs_rename() to allow rename to same inode

Hi Miklos,

 My first problem with this that there isn't nearly enough documentation.
So I offer the following to fix this problem.  Please correct anything that I
got glaringly wrong.  I don't claim it is at all complete, but touches on the
things that I thought were interesting.

NeilBrown



Hybrid Union Filesystem
=======================

This document describes a prototype for a new approach to providing
union-filesystem functionality in Linux.
A union-filesystem tries to present the union of two different filesystems as
though it were a single filesystem.  The result will inevitably fail to look
exactly like a normal filesystem for various technical reasons.  The
expectation is that many use cases will be able to ignore these differences.

This approach is 'hybrid' because the objects that appear in the filesystem
do not all appear to belong to that filesystem.  In many case an object
accessed in the hybrid-union will be indistinguishable from accessing the
corresponding object from the original filesystem.  This is most obvious
from the 'st_dev' field returned by stat(2).  Some objects will report an
st_dev from one original filesystem, some from the other, none will report an
st_dev from the union itself.  Similarly st_ino will only be unique when
combined with st_dev, and both of these can change over the lifetime of an
object.
Many applications and tools ignore these values and will not be affected.

Upper and Lower
---------------

A union filesystem combines two filesystems - an 'upper' filesystem and a
'lower' filesystem.  Note that while in set theory, 'union' is a commutative
operation, in filesystems it is not - the two filesystems are treated
differently.  When a name exists in both filesystems, the object in the
'upper' filesystem is visible while the object in the 'lower' filesystem is
either hidden or, in the case of directories, merged with the 'upper' object.

It would be more correct to refer to an upper and lower 'directory tree'
rather than 'filesystem' as it is quite possible for both directory trees to
be in the same filesystem and there is no requirement that the root of a
filesystem be given for either upper or lower.

The lower filesystem can be any filesystem supported by Linux and does not
need to be writable.  It could even be another union.
The upper filesystem will normally be writeable and if it is it must support
the creation of trusted.* extended attributes, and must provide valid d_type
in readdir responses, at least for symbolic links - so NFS is not suitable.

A read-only union of two read-only filesystems is support for any filesystem
type.

Directories
-----------

Unioning mainly involved directories.  If a given name appears in both upper
ad lower filesystems and refers to a non-directory in either, then the lower
object is hidden - the name refers only to the upper object.

Where both upper and lower objects are directories, a merged directory is
formed.

At mount time, the two directories given as mount options are combined
into a merged directory.  Then whenever a lookup is requested in such a
merged directory, the lookup is performed in each actual directory and the
combined result is cached in the dentry belonging to the union filesystem.
If both actual lookups find directories, both are stored and a merged
directory is create, otherwise only one is stored: the upper if it exists,
else the lower.

Only the lists of names from directories are merged.  Other content such as
metadata and extended attributes are reported for the upper directory only.
These attributes of the lower directory are hidden.

whiteouts and opaque directories
--------------------------------

In order to support rm and rmdir without changing the lower filesystem, a
union filesystem needs to record in the upper filesystem that files have been
removed.  This is done using whiteouts and opaque directories (non-directories
are always opaque).

The hybrid union filesystem uses extended attributes with a "trusted.union."
prefix to record these details.

A whiteout is created as a symbolic link with target "(union-whiteout)" and
with xattr "trusted.union.whiteout" set to "y".  When a whiteout is found in
the upper level of a merged directory, any matching name in the lower level
is ignored, and the whiteout itself is also hidden.

A directory is made opaque by setting the xattr "trusted.union.opaque" to "y".
Where the upper filesystem contains an opaque directory, any directory in the
lower filesystem with the same name is ignored.

readdir
-------

When a 'readdir' request is made on a merged directory, the upper and lower
directories are each read and the name lists merged in the obvious way (upper
is read first, then lower - entries that already exist are not re-added).
This merged name list is cached in the 'struct file' and so remains as long as
the file is kept open.  If the directory is opened and read by two processes
at the same time, they will each have separate caches.
A seekdir to the start of the directory (offset 0) followed by a readdir will
cause the cache to be discarded and rebuilt.

This means that changes to the merged directory do not appear while a
directory is being read.  This is unlikely to be noticed by many programs.

seek offsets are assigned sequentially when the directories are read.  Thus
if
  - read part of a directory
  - remember an offset, and close the directory
  - re-open the directory some time later
  - seek to the remembered offset

there may be little correlation between the old and new locations in the list
of filenames, particularly if anything has changed in the directory.

Readdir on directories that are not merged is simply handled by the
underlying directory (upper or lower).


Non-directories
---------------

Objects that are not directories (files, symlinks, device-special files etc)
are presented either from the upper or lower filesystem as appropriate.
When a file in the lower filesystem is accessed in a way the requires
write-access; such as opening for write access, changing some metadata etc,
the file is first copied from the lower filesystem to the upper filesystem
(copy_up).  Note that creating a hard-link also requires copy-up, though of
course creation of a symlink does not.

The copy_up process first makes sure that the containing directory exists
in the upper filesystem - creating it and any parents as necessary.  It then
creates the object with the same metadata (owner, mode, mtime, symlink-target
etc) and then if the object is a file, the data is copied from the lower to
the upper filesystem.  Finally any extended attributes are copied up.

Once the copy_up is complete, the hybrid-union filesystem simply provides
direct access to the newly created file in the upper filesystem - future
operations on the file are barely noticed by the hybrid-union (though an
operation on the name of the file such as rename or unlink will of course be
noticed and handled).

Changes to underlying filesystems
---------------------------------

The hybrid-union filesystem does not insist that the upper and lower
filesystems that it combines remain read-only.  This is certainly preferred
but it is non-trivial to enforce (e.g. for NFS) and so cannot be depended on.
A system integrator should ensure the underlying filesystems are not changed
- except through the hybrid union - if they want predictable behaviour, or
must accept the consequences.
The hybrid-union filesystem only ensures that unexpected changes do not cause
a system crash or serious corruption to either underlying filesystem.

The exact behaviour of the hybrid-union is best described in terms from the
'dcache' and as objects can expire from the 'dcache' at unpredictable times,
the exact behaviour when the underlying filesystems change is in
general unpredictable.

Each dcache entry in the hybrid union holds a reference to a corresponding
dcache entry in upper or lower filesystem or, in the case of merged
directories, in both the upper and lower filesystems.

If a referenced file is rename directly in one of the filesystems, that
renaming will not be noticed in the hybrid union until the referencing dcache
entry expires.

If a referenced file is unlinked from a local filesystem, it could similarly
still be accessibly through the hybrid while the dcache entry persists.  If a
referenced file is on an NFS filesystem and is unlinked remotely, the file in
the hybrid-union will become 'stale' returning ESTALE for most accesses.  It
will not disappear until the dcache entry expires from the dcache.

If a referenced file is changed, either contents or metadata, that change
will be immediately visible in the hybrid union.

If the contents of a directory are changed, then a readdir will not see that
change unless it opens the file or seeks to the start of the file after the
change was made.  Then it will be visible.

Changes will *not* be visible to a lookup if the name that is changed is
currently cached in the the dcache, whether positive or negative.
e.g. If a name is looked for in the hybrid union and not found, a negative
dcache entry will be created.  If the same name is directly created in the
upper filesystem it will not immediately become visible to the hybrid, though
it will be visible in a readdir.  This could be confusing, and could
probably be fixed using dcache revalidation.
