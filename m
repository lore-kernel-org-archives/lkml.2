Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab0H3XMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 19:12:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38554 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753809Ab0H3XMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 19:12:22 -0400
Date: Tue, 31 Aug 2010 09:12:11 +1000
From: Neil Brown <neilb@suse.de>
To: Valerie Aurora <vaurora@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, jblunck@suse.de,
        hch@infradead.org
Subject: Re: [PATCH 0/5] hybrid union filesystem prototype
Message-ID: <20100831091211.403e0d06@notabene>
In-Reply-To: <20100830183843.GB2444@shell>
References: <20100826183340.027591901@szeredi.hu>
	<20100827170551.19616048@notabene>
	<E1Ooub5-0007Wh-SQ@pomaz-ex.szeredi.hu>
	<20100827213502.31af4a4c@notabene>
	<20100830183843.GB2444@shell>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Aug 2010 14:38:43 -0400
Valerie Aurora <vaurora@redhat.com> wrote:

> On Fri, Aug 27, 2010 at 09:35:02PM +1000, Neil Brown wrote:
> > On Fri, 27 Aug 2010 10:47:39 +0200
> > Miklos Szeredi <miklos@szeredi.hu> wrote:
> > > > Changes to underlying filesystems
> > > > ---------------------------------
> > > > 
> > > 
> > > For now I refuse to even think about what happens in this case.
> > > 
> > > The easiest way out of this mess might simply be to enforce exclusive
> > > modification to the underlying filesystems on a local level, same as
> > > the union mount strategy.  For NFS and other remote filesystems we
> > > either
> > > 
> > >  a) add some way to enforce it,
> > >  b) live with the consequences if not enforced on the system level, or
> > >  c) disallow them to be part of the union.
> > > 
> > 
> > I actually think that your approach can work quite will with either the
> > upper or lower changing independently.  Certainly it can produce some odd
> > situations, but even NFS can do that (though maybe not quite so odd).
> 
> I'm very curious about your thoughts on how to handle the lower layer
> changing.  Al Viro's comments:
> 
> http://lkml.indiana.edu/hypermail/linux/kernel/0802.0/0839.html
> 
> Do you see something we're missing?
> 

That would be:

> If you allow a mix of old and new mappings, you can easily run into the
> situations when at some moment X1 covers Y1, X2 covers Y2, X2 is a descendent
> of X1 and Y1 is a descendent of Y2. You *really* don't want to go there -
> if nothing else, defining behaviour of copyup in face of that insanity
> will be very painful.

in particular - right?

The current proposal doesn't do copy-up of directory trees - or even of
directories - which is what I assume the reference to copyup refers to, so
that is a non-issue (i.e. where a tree copy-up might be needed, EXDEV is
returned).

For the [XY][12] issue, let's try to make it a bit more concrete.

Suppose /L is the lower tree, /U is the upper tree and /O is the overlay
mount point.
Suppose further that /U/a/b/c/d/e/f/g exists and (for now) /L/a doesn't.

Then /O/a/b/c/d/e/f/g can appear to 'cover' the above path.

So I open
    /U/a/b/c  and /U/a/b/c/d/e/f
and
    /O/a/b/c  and /O/a/b/c/d/e/f

These are Y1 Y2 X1 X2.  Currently Xn covers Yn.

To get the situation Al describes we would need to perform some manipulations
in /U e.g.
   mv /U/a/b/c/d/e  /U/a/e
   mv /U/a/b /U/a/e/f/g/b
Now each dir still has the same basename as before and there is only one
child per dir, and the longest path is
     /U/a/e/f/g/b/c/d
So now Y1 (/U/../c) is a descendent of Y2 (/U/../f), and the dentries
attached to the 4 open fds haven't seen any local change.

So: is this a problem?  It may seem a bit confusing to someone who doesn't
understand what is happening, but we define that as not being a problem (to
avoid confusion: don't change U or L).
The important questions are:  Can it cause corruption, and can it cause a
deadlock?

If we walk down the directory tree from either X1 or X2, we will see
  c/d  or f/g/b/c/d
respectively.  Both paths will terminate - no loops.  The 'd' below X2 will be
a different dentry than the 'd' above X2 despite the fact that they both
reference the same 'd' under /U.
If we try a 'renameat' - the only thing that I can imagine that would cause
fs corruption, we use the same lock_rename and vfs_rename calls on the /U
filesystem as a direct syscall would, so any attempt to create a disconnected
loop will fail.
It is probable that the upperpath.dentry should be revalidated after getting
the lock to ensure it is still hashed etc, but that would be part of the
revalidation code that I would propose to add.  So I fail to see how any
filesystem corruption could happen.

For locking: we take locks in the /U filesystem while holding locks in the /O
overlay.  There is a clear ordering here so there should be no room for
deadlock.
If the overlay filesystem were to support overlaying a mount-tree on a
mount-tree rather than just a filesystem on a filesystem I imagine that it
would not be too hard to create some weird loops.  However the current
proposal ignores mountpoints and just overlays one filesystem on another, so
the overlay is certain to be separate from, and well-ordered with respect to,
the upper and lower filesystems.

If the long path were on /L rather than /U I don't think anything would be
different.
If the paths were shorter and you managed to directly swap a parent and a
child, overlayfs would be able to notice that during revalidate and - if
necessary due to unpleasant races - would simply return -EBUSY.

It is a fairly key aspect of this proposal that we feel free to return errors
for situations that are too hard.  -EXDEV for non-opaque directory renames is
one such case.  -EBUSY when racing with changes in the covered filesystems
would be another.

I haven't got revalidation code yet, but when {upper,lower}path.dentry were
non-null, it would check they are still hashed, have the same name as the
main dentry, and have the correct corresponding parent.  If they are NULL, we
check that the corresponding parent inode is still NULL.
If not, we repeat union_lookup - or fail or whatever seems appropriate.

Inside any locks that we take on the upper filesystem to perform some
directory manipulations we would repeat the checks (on upperpath only) and
return -EBUSY if the dentries have become 'invalid' since the recent
revalidate.

So I don't see a problem.  Maybe I'm not seeing something that Al does, or
maybe the current proposal is sufficiently different from the one Al was
reviewing that the problems he observed simply don't exist.

I've reviewed your recent discussion with J. R. Okajima and it doesn't help me
see any locking issues more clearly.  Maybe if you could identify a specific
vfs_* call which could issue lock requests in a dangerous order and is not
protected by the revalidation I described above, that might help me see more
clearly.

Thanks,
NeilBrown
