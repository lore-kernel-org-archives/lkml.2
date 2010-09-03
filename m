Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632Ab0ICFKr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 01:10:47 -0400
Received: from cantor.suse.de ([195.135.220.2]:44360 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852Ab0ICFKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 01:10:46 -0400
Date: Fri, 3 Sep 2010 15:10:35 +1000
From: Neil Brown <neilb@suse.de>
To: Valerie Aurora <vaurora@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, jblunck@suse.de,
        hch@infradead.org
Subject: Re: [PATCH 5/5] union: hybrid union filesystem prototype
Message-ID: <20100903151035.6d5c3c11@notabene>
In-Reply-To: <20100902213315.GA16004@shell>
References: <20100826183340.027591901@szeredi.hu>
	<20100826183507.402136609@szeredi.hu>
	<20100901214238.GC15849@shell>
	<E1Or5xN-0001uq-Ob@pomaz-ex.szeredi.hu>
	<20100902213315.GA16004@shell>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Sep 2010 17:33:15 -0400
Valerie Aurora <vaurora@redhat.com> wrote:

> On Thu, Sep 02, 2010 at 11:19:41AM +0200, Miklos Szeredi wrote:
> > On Wed, 1 Sep 2010, Valerie Aurora wrote:
> > > > +
> > > > +		err = vfs_create(upperdir, newdentry, attr->ia_mode, NULL);
> > > 
> > > Passing a NULL namiedata pointer to vfs_create() is a convenient
> > > temporary hack, but unfortunately NFS, ceph, etc. still use the
> > > nameidata passed to vfs_create() and other ops.
> > > 
> > > The way union mounts gets a valid nameidata is by doing the create in
> > > the VFS before calling file system ops that may trigger a copyup,
> > > while we still have the original nameidata.  This is one of the major
> > > reasons union mounts lives in the VFS.
> > 
> > Not a big deal, just set up nd as if this was a single component
> > lookup.  The previous version did it like this:
> > 
> > +       struct nameidata nd = {
> > +               .last_type = LAST_NORM,
> > +               .last = *name,
> > +       };
> > +
> > +       nd.path = pue->upperpath;
> > +       path_get(&nd.path);
> > +
> > +       newdentry = lookup_create(&nd, S_ISDIR(attr->ia_mode));
> > 
> > But that's not a solution to the NFS suckage, it's just a workaround.
> 
> Hm, I suspect it's more complicated than this.  I looked at how
> unionfs does it in init_lower_nd() and it requires poking around in
> VFS internal details in the file system implementation.  So unioning
> code is not in the VFS, but VFS code is in the union fs.  Progress?  I
> dunno.

Slightly off-topic, but my personal definition of 'progress' in this context
would be giving more control to the filesystems rather than the VFS telling
them how they have to behave.  The VFS should largely be a library that the
filesystems can call on to do common tasks, but where they can augment what
libVFS does, or just ignore it as they choose.  This would be more like the
model of the page-cache.  It is really easy for a filesystem to use the
pagecache to store file content, and really easy for it to do something else
if that works better.

In this particular situation - where unionfs has a dentry and want to copy
that file to a different dentry, I think what we really want to do is call
the section of code in the middle of do_filp_open, roughly from the "We have
the parent and last component"  comment to the do_last() call.  If that could
be factored out and exported it would get close to what we want.

I had a look at NFS and ceph, and they want to see LOOKUP_CREATE and
LOOPUP_OPEN set, and want the intent.open.file to exist.  do_filp_open can do
all that for you.


> 
> > "Fortunately" NFS isn't good for a writable layer of a union for other
> > reasons, so this isn't a big concern at the moment.
> 
> It's the long-term effect on the code structure that concerns me more.

Code structure:  absolutely agree this is important.  But I don't think it 
    needs to be a problem - just refactor 'VFS" code and call into it.
    (I note that nfsd always passes a NULL nameidata - when refactoring that
    code it would be worth aiming to make it usable by nfsd too).

NFS as writable layer:  Not a concern at the moment, no.  But I think it is
   worth keeping it in mind.
   The biggest problem is, I think, the lack of xattrs which are currently
   needed for whiteout and opaque.
   I think there would be little cost in allowing a symlink to
   (union-whiteout) to be treated as a whiteout even though it has no xattrs
   (maybe as a mount option).
   For opaque you would need a somewhat less-elegant work around. e.g. if the
   directory contains a symlink to (union-opaque) called ._.union_opaque,
   then that symlink is hidden, and the directory is opaque.  This could be
   enabled by that same mount option.
   This might not be as efficient as xattrs, but then people don't use
   networked filesystems for their speed - they have other benefits.

NeilBrown

