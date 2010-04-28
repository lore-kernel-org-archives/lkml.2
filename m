Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192Ab0D1UT1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 16:19:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20149 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755101Ab0D1UT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 16:19:26 -0400
Date: Wed, 28 Apr 2010 16:19:09 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 16/35] union-mount: Writable overlays/union mounts documentation
Message-ID: <20100428201908.GC16691@shell>
References: <1271372682-21225-9-git-send-email-vaurora@redhat.com> <1271372682-21225-10-git-send-email-vaurora@redhat.com> <1271372682-21225-11-git-send-email-vaurora@redhat.com> <1271372682-21225-12-git-send-email-vaurora@redhat.com> <1271372682-21225-13-git-send-email-vaurora@redhat.com> <1271372682-21225-14-git-send-email-vaurora@redhat.com> <1271372682-21225-15-git-send-email-vaurora@redhat.com> <1271372682-21225-16-git-send-email-vaurora@redhat.com> <1271372682-21225-17-git-send-email-vaurora@redhat.com> <E1O4GKw-000257-Hh@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1O4GKw-000257-Hh@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 06:30:10PM +0200, Miklos Szeredi wrote:
> On Thu, 15 Apr 2010, Valerie Aurora wrote:
> > +VFS implementation
> > +==================
> > +
> > +Writable overlays are implemented as an integral part of the VFS,
> > +rather than as a VFS client file system (i.e., a stacked file system
> > +like unionfs or ecryptfs).  Implementing writable overlays inside the
> > +VFS eliminates the need for duplicate copies of VFS data structures,
> > +unnecessary indirection, and code duplication, but requires very
> > +maintainable, low-to-zero overhead code.  Writable overlays require no
> > +change to file systems serving as the read-only layer, and requires
> > +some minor support from file systems serving as the read-write layer.
> > +File systems that want to be the writable layer must implement the new
> > +->whiteout() and ->fallthru() inode operations, which create special
> > +dummy directory entries.
> 
> Maybe this should have been discussed earlier, but looking at all the
> places where copyup and whiteout logic needs to be added (and the
> current code is still unfinished, as you state) makes me wonder, does
> all that really belong in the VFS?
> 
> What exactly are the areas where a VFS implementation eliminates
> duplication and unnecessary indirection?  Well, it turns out that in
> the current implementation there's only one place, and that's
> non-directory nodes.
> 
> Which begs the question: why do all the other things (union lookup,
> directory merging and copyup, file copyup) need to be in the VFS?
> Especially since I can imagine other union implementations wanting to
> do these differently (e.g. not copying up directories in readdir).
>
> What really needs to be in the VFS is the ability to:
> 
> - allow a filesystem to "redirect" a lookup to a different fs,
> 
> - if the operation happens to modify the file, then *not* redirect the
>   lookup
> 
> And there is already one example for the above: LAST_BIND lookups in
> /proc.  So basically it's mostly there and just needs to be
> implemented in a filesystem.
> 
> Have I missed something fundamental?  Are there other reasons why a
> filesystem based implementation would be inferior?

I'm sorry I have responded sooner, I've been trying to write a
detailed useful message and that turns out to be hard.  I'll just
include a few of the highlights; mainly I want to say that I'd
rather do it the way you describe but when I tried it ended up even
uglier than the VFS implementation.

I went down this road initially (do most of the unioning in a file
system) and spent a couple of months on it.  But I always ended up
having to do some level of copy-around and redirection similar to that
in unionfs.

One of the major difficulties that arises even when doing unioning at
the VFS level is keeping around the parent's path in order to do the
copyup later on.  Take a look at the code pattern in the "union-mount:
Implement union-aware syscall()" series of patches.  That's the
prettiest and most efficient version I could come up with, after two
other implementations, and it's in the VFS, at the vfs_foo_syscall()
level.  I don't even know how I would start if I had to wait until the
file system op is called.

If you have some insights on how to do this, I'd love to hear them.  I
don't enjoy writing VFS code for the fun of it. :)

Thanks,

-VAL


