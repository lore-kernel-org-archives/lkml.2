Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370Ab0ITF0E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 01:26:04 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:39380 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835Ab0ITF0B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 01:26:01 -0400
Date: Sun, 19 Sep 2010 22:25:53 -0700
From: Ram Pai <linuxram@us.ibm.com>
To: Valerie Aurora <vaurora@redhat.com>
Cc: Ram Pai <ram.n.pai@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Christoph Hellwig <hch@infradead.org>,
        Andreas Gruenbacher <agruen@suse.de>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 03/34] VFS: Add CL_NO_SLAVE flag to
 clone_mnt()/copy_tree()
Message-ID: <20100920052553.GM8926@ram-laptop>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
 <1284675145-4391-4-git-send-email-vaurora@redhat.com>
 <AANLkTim1bbGrrPcFHThx3XOm8GmudQFSmFUs3NAXT5yC@mail.gmail.com>
 <20100917043401.GD8926@ram-laptop>
 <20100917171514.GA32258@shell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100917171514.GA32258@shell>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 01:15:14PM -0400, Valerie Aurora wrote:
> On Thu, Sep 16, 2010 at 09:34:01PM -0700, Ram Pai wrote:
> > On Thu, Sep 16, 2010 at 05:09:58PM -0700, Ram Pai wrote:
> > > On Thu, Sep 16, 2010 at 3:11 PM, Valerie Aurora <vaurora@redhat.com> wrote:
> > > 
> > > > Passing the CL_NO_SLAVE flag to clone_mnt() causes the clone
> > > > to fail if the source mnt is a slave.
> > > >
> > > > Signed-off-by: Valerie Aurora <vaurora@redhat.com>
> > > > ---
> > > >  fs/namespace.c |    3 +++
> > > >  fs/pnode.h     |    1 +
> > > >  2 files changed, 4 insertions(+), 0 deletions(-)
> > > >
> > > > diff --git a/fs/namespace.c b/fs/namespace.c
> > > > index eeb4c22..6956062 100644
> > > > --- a/fs/namespace.c
> > > > +++ b/fs/namespace.c
> > > > @@ -565,6 +565,9 @@ static struct vfsmount *clone_mnt(struct vfsmount *old,
> > > > struct dentry *root,
> > > >        if ((flag & CL_NO_SHARED) && (IS_MNT_SHARED(old)))
> > > >                return ERR_PTR(-EINVAL);
> > > >
> > > > +       if ((flag & CL_NO_SLAVE) && (IS_MNT_SLAVE(old)))
> > > > +               return ERR_PTR(-EINVAL);
> > > > +
> > > >
> > > 
> > > 
> > > its been a while and my memory may have corroded.  But I dont think this
> > > check is needed. Because cloning a 'slave mount' makes the mount a 'private
> > > mount' and not a 'slave mount'.
> >
> > There is one case where a 'slave mount' when cloned can generate a 'slave mount', and
> > that is when the 'slave mount' is also a 'shared mount'. So the above check has to
> > be
> > 
> >        if ((flag & CL_NO_SLAVE) && (IS_MNT_SLAVE(old) && IS_MNT_SHARED(old)))
> >                return ERR_PTR(-EINVAL);
> 
> Hey Ram,
> 
> I added this flag for union mounts. Union mounts can't deal with
> namespace changes in the read-only layers, so we don't allow union of
> read-only mounts that are the target of propagation events (shared or
> slave).
> 
> We could automatically convert all slave or shared mounts into private
> mounts when we clone the mounts, but that would surprise an
> administrator who carefully set up their shared or slave read-only
> mounts before unioning them.  So instead of silently converting slave
> or shared to private, we error out.  Does that make sense?

I understand your intentions, but I think you are making a wrong assumption.
You seem to be thinking that if a slave-mount is cloned, the new cloned
mount will also be a slave-mount and will hence receive propagations. As
per shared subtree semantics, a slave-mount when cloned will create a private
mount. Since your intention is to avoid generating any new mounts that 
recieve propagations, you should be checking for shared-mounts and 
slave-shared-mounts because these are the two kind of mounts that when
cloned create new mounts that receive propagation.

btw: slave-shared-mount is a mount that is shared and is also a slave of
a shared mount.

> 
> All that being said, I debated how to do this cleanly and I'm still
> not satisfied.  My goal is to both check and clone the proposed
> read-only layers in one pass.  Without these flags, I had to do four
> passes:
> 
> 1. Find the "lowest" read-only mount at this mountpoint.
> 2. Check each mount for read-only, not shared, not slave.
> 3. Clone the subtree starting at the "lowest" mount.
> 4. Recheck the cloned tree for rules in #2.
> 
> One of the reasons I had to do it this way is that you can't hold
> vfsmount_lock while calling copy_tree(), so the mount flags can change
> between the first check in #2 and the copy_tree() in #3.  Also
> sb->s_flag can change.  

Isn't this whole operation done under the protection of namespace_sem? 
I know that shared/slave flags can't change if the namespace_sem is held. 
The same may also be true for sb->s_flag. 


> One of the problems with the current code is
> that it can't deal with cloning existing union mounts, which we need
> if we are to make bind mounts work (see do_loopback()).

if I understand your union mount semantics correctly, you dont' allow the
same filesystem to be union mounted rw in two different locations. correct?
If yes, then bind mount of a union-mount has to be disallowed.

RP

> 
> Anyway, if you have any ideas, I'm all ears.
> 
> Thanks for reviewing,
> 
> -VAL
