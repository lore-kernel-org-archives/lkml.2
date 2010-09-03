Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438Ab0ICJQM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 05:16:12 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:35076 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab0ICJQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 05:16:11 -0400
To: Neil Brown <neilb@suse.de>
CC: vaurora@redhat.com, miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, jblunck@suse.de,
        hch@infradead.org
In-reply-to: <20100903151035.6d5c3c11@notabene> (message from Neil Brown on
	Fri, 3 Sep 2010 15:10:35 +1000)
Subject: Re: [PATCH 5/5] union: hybrid union filesystem prototype
References: <20100826183340.027591901@szeredi.hu>
	<20100826183507.402136609@szeredi.hu>
	<20100901214238.GC15849@shell>
	<E1Or5xN-0001uq-Ob@pomaz-ex.szeredi.hu>
	<20100902213315.GA16004@shell> <20100903151035.6d5c3c11@notabene>
Message-Id: <E1OrSNT-0006Th-Na@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 03 Sep 2010 11:16:07 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Sep 2010, Neil Brown wrote:
> Slightly off-topic, but my personal definition of 'progress' in this context
> would be giving more control to the filesystems rather than the VFS telling
> them how they have to behave.  The VFS should largely be a library that the
> filesystems can call on to do common tasks, but where they can augment what
> libVFS does, or just ignore it as they choose.  This would be more like the
> model of the page-cache.  It is really easy for a filesystem to use the
> pagecache to store file content, and really easy for it to do something else
> if that works better.
> 
> In this particular situation - where unionfs has a dentry and want to copy
> that file to a different dentry, I think what we really want to do is call
> the section of code in the middle of do_filp_open, roughly from the "We have
> the parent and last component"  comment to the do_last() call.  If that could
> be factored out and exported it would get close to what we want.
> 
> I had a look at NFS and ceph, and they want to see LOOKUP_CREATE and
> LOOPUP_OPEN set, and want the intent.open.file to exist.  do_filp_open can do
> all that for you.

Right, the difference between current open and what NFS wants is that
the current open is an inode based operation (like getattr).  The open
NFS wants is a name based operation (like create).

Unfortunately symlinks complicate that to a great extent.  Which means
this new operation really becomes a cobination of follow_link, create
and open.


> > > "Fortunately" NFS isn't good for a writable layer of a union for other
> > > reasons, so this isn't a big concern at the moment.
> > 
> > It's the long-term effect on the code structure that concerns me more.
> 
> Code structure:  absolutely agree this is important.  But I don't think it 
>     needs to be a problem - just refactor 'VFS" code and call into it.
>     (I note that nfsd always passes a NULL nameidata - when refactoring that
>     code it would be worth aiming to make it usable by nfsd too).
> 
> NFS as writable layer:  Not a concern at the moment, no.  But I think it is
>    worth keeping it in mind.
>    The biggest problem is, I think, the lack of xattrs which are currently
>    needed for whiteout and opaque.

There was a patch that seem to have been generally liked, don't know
what happened to it:

  http://lwn.net/Articles/353831/

>    I think there would be little cost in allowing a symlink to
>    (union-whiteout) to be treated as a whiteout even though it has no xattrs
>    (maybe as a mount option).
>    For opaque you would need a somewhat less-elegant work around. e.g. if the
>    directory contains a symlink to (union-opaque) called ._.union_opaque,
>    then that symlink is hidden, and the directory is opaque.  This could be
>    enabled by that same mount option.
>    This might not be as efficient as xattrs, but then people don't use
>    networked filesystems for their speed - they have other benefits.

I think unionfs/aufs do something like that.  Having namespace
pollution is ugly, but well, we can live with that.

But that's again something I'd think about when someone actually needs
it.

Thanks,
Miklos
