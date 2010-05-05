Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934799Ab0EENTh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 09:19:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16790 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932275Ab0EENTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 09:19:35 -0400
Date: Wed, 5 May 2010 09:19:20 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Jamie Lokier <jamie@shareable.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Jan Blunck <jblunck@suse.de>
Subject: Re: [PATCH 17/39] union-mount: Union mounts documentation
Message-ID: <20100505131920.GB7534@shell>
References: <1272928358-20854-1-git-send-email-vaurora@redhat.com> <1272928358-20854-18-git-send-email-vaurora@redhat.com> <20100504211209.GC4360@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100504211209.GC4360@shareable.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 04, 2010 at 10:12:09PM +0100, Jamie Lokier wrote:
> Valerie Aurora wrote:
> > +File copyup: Create a file on the top layer that has the same metadata
> > +and contents as the file with the same pathname on the bottom layer.
> 
> Can copyup be interrupted?  E.g. if I chmod an 80GB file, will the
> chmod() system call pause for a couple of hours, or can I control-C it?

The right behavior is that you should be able to control-C it, but I
doubt that currently works.  Let me look into testing and implementing
this.

> > +This deviation from standard is due to technical limitations of the
> > +union mount implementation.  Specifically, we would need to replace an
> > +open file descriptor from the lower layer with an open file descriptor
> > +for a file with matching pathname and contents on the upper layer,
> > +which is difficult to do.  We avoid this in other system calls by
> > +doing the copyup before the file is opened.  Unionfs doesn't encounter
> > +this problem because it creates a dummy file struct which redirects or
> > +fans out operations to the struct files for the underlying file
> > +systems.
> > +
> > +From an application's point of view, the result of an in-kernel file
> > +copyup is the logical equivalent of another application updating the
> > +file via the rename() pattern: creat() a new file, copy the data over,
> > +make changes the copy, and rename() over the old version.  Any
> > +existing open file descriptors for that file (including those in the
> > +same application) refer to a now invisible object that used to have
> > +the same pathname.  Only opens that occur after the copyup will see
> > +updates to the file.
> 
> Does it apply the same permission checks that a program doing
> copy+rename would have to pass?  I guess that is just write access to
> the directory.

Yes.

> Does it effectively "rename" all hard links referring to the file, to
> point to the new version, or does it only affect the path that was
> used by the writer/modifier, leaving the other links continue to refer
> to the original file?

In order to update all the hard links to a file, we would have to walk
the entire file system searching for links with a matching inode
number and copy them up too.  We're never going to do a
file-system-wide walk, so we won't do that.  The other hard links
still point to the old copy of the file.  We hope applications don't
commonly depend on this.

> > + - File copyup on open(O_DIRECT)
> 
> Why is O_DIRECT relevant?  O_DIRECT doesn't imply writing, and
> copy+rename behaviour is the same with O_DIRECT as not.
> 
> Some programs use O_DIRECT to read very large files, without intending
> they will ever be modified.  For example, qemu using O_DIRECT to
> access a disk image backing file.

You're right, this is a mistake.

> > +NFS interaction
> > +===============
> > +
> > +NFS is currently not supported as either type of layer.  NFS as
> > +read-only layer requires support from the server to honor the
> > +read-only guarantee needed for the bottom layer.  To do this, the
> > +server needs to revoke access to clients requesting read-only file
> > +systems if the exported file system is remounted read-write or
> > +unmounted (during which arbitrary changes can occur).  Some recent
> > +discussion:
> > +
> > +http://markmail.org/message/3mkgnvo4pswxd7lp
> > +
> > +NFS as the read-write layer would require implementation of the
> > +->whiteout() and ->fallthru() methods.  DT_WHT directory entries are
> > +theoretically already supported.
> > +
> > +Also, technically the requirement for a readdir() cookie that is
> > +stable across reboots comes only from file systems exported via NFSv2:
> > +
> > +http://oss.oracle.com/pipermail/btrfs-devel/2008-January/000463.html
> > +
> > +Todo:
> > +
> > +- Guarantee really really read-only on NFS exports
> > +- Implement whiteout()/fallthru() for NFS
> 
> I'm finding it hard to imagine _guaranteeing_ really read-only.  All
> you can guarantee is that the NFS says it is read-only.
> 
> For example, a userspace NFS server cannot prevent the filesystem it's
> serving from changing.

We're discussing how to detect this now.

> Is this not a problem with other network filesystems like CIFS, P9, FUSE?

Each file system that wants to support union mounts will need to
implement the features necessary for that layer (hard read-only for
the lower layer, whiteouts and fallthrus for the upper layer).

> > +Known non-POSIX behaviors
> > +-------------------------
> > +
> > +- Link count may be wrong for files on bottom layer with > 1 link count
> 
> Can you say a bit more about what will be seen?

Sure, I'll write up an example.

> > +- File copyup is the logical equivalent of an update via copy +
> > +  rename().  Any existing open file descriptors will continue to refer
> > +  to the read-only copy on the bottom layer and will not see any
> > +  changes that occur after the copy-up.
> 
> I can imagine some database-like programs getting confused by that.
> 
> Maybe it would be better to fail copyup operations when the file is
> currently open O_RDONLY by anyone, analogous to the way writable
> mounts are refused when any union holds it read-only?
> 
> Are there uses likely to be broken by that behaviour?

That's an interesting question.  In general, this seems like a bad
idea - any process can prevent another process from writing to a file
by opening it.  This is like chmod'ing it to 444.

-VAL
