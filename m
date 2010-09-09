Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034Ab0IIQT0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 12:19:26 -0400
Received: from msux-gh1-uea01.nsa.gov ([63.239.65.39]:62796 "EHLO
	msux-gh1-uea01.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab0IIQTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 12:19:22 -0400
Subject: Re: [PATCH 5/5] union: hybrid union filesystem prototype
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Neil Brown <neilb@suse.de>, vaurora@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, jblunck@suse.de, hch@infradead.org
In-Reply-To: <E1OrSNT-0006Th-Na@pomaz-ex.szeredi.hu>
References: <20100826183340.027591901@szeredi.hu>
	 <20100826183507.402136609@szeredi.hu> <20100901214238.GC15849@shell>
	 <E1Or5xN-0001uq-Ob@pomaz-ex.szeredi.hu> <20100902213315.GA16004@shell>
	 <20100903151035.6d5c3c11@notabene>  <E1OrSNT-0006Th-Na@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Date: Thu, 09 Sep 2010 12:02:32 -0400
Message-Id: <1284048152.24418.68.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-03 at 11:16 +0200, Miklos Szeredi wrote:
> On Fri, 3 Sep 2010, Neil Brown wrote:
> > Slightly off-topic, but my personal definition of 'progress' in this context
> > would be giving more control to the filesystems rather than the VFS telling
> > them how they have to behave.  The VFS should largely be a library that the
> > filesystems can call on to do common tasks, but where they can augment what
> > libVFS does, or just ignore it as they choose.  This would be more like the
> > model of the page-cache.  It is really easy for a filesystem to use the
> > pagecache to store file content, and really easy for it to do something else
> > if that works better.
> > 
> > In this particular situation - where unionfs has a dentry and want to copy
> > that file to a different dentry, I think what we really want to do is call
> > the section of code in the middle of do_filp_open, roughly from the "We have
> > the parent and last component"  comment to the do_last() call.  If that could
> > be factored out and exported it would get close to what we want.
> > 
> > I had a look at NFS and ceph, and they want to see LOOKUP_CREATE and
> > LOOPUP_OPEN set, and want the intent.open.file to exist.  do_filp_open can do
> > all that for you.
> 
> Right, the difference between current open and what NFS wants is that
> the current open is an inode based operation (like getattr).  The open
> NFS wants is a name based operation (like create).
> 
> Unfortunately symlinks complicate that to a great extent.  Which means
> this new operation really becomes a cobination of follow_link, create
> and open.
> 
> 
> > > > "Fortunately" NFS isn't good for a writable layer of a union for other
> > > > reasons, so this isn't a big concern at the moment.
> > > 
> > > It's the long-term effect on the code structure that concerns me more.
> > 
> > Code structure:  absolutely agree this is important.  But I don't think it 
> >     needs to be a problem - just refactor 'VFS" code and call into it.
> >     (I note that nfsd always passes a NULL nameidata - when refactoring that
> >     code it would be worth aiming to make it usable by nfsd too).
> > 
> > NFS as writable layer:  Not a concern at the moment, no.  But I think it is
> >    worth keeping it in mind.
> >    The biggest problem is, I think, the lack of xattrs which are currently
> >    needed for whiteout and opaque.
> 
> There was a patch that seem to have been generally liked, don't know
> what happened to it:
> 
>   http://lwn.net/Articles/353831/
> 

James spent the time to implement the side band protocol for xattrs in
NFSv3 but then hit some resistance with it recently. The thing is we are
trying to push people towards NFSv4 and the xattr solution James was
proposing was to allow people to use SELinux with NFSv3. We had a
meeting with several of the parties and it was determined that it would
be better to focus our efforts on NFSv4 and standardizing security label
support for NFSv4 than to push for the xattr solution with NFSv3. We
received the same requirements of a standards document that has gone
through the IETF process for the NFSv3 xattr solution as well. Since we
have been working on security labels with NFSv4 for almost 3 years now
and are pretty far along it was determined that it would be better to
spend cycles on that instead.


> >    I think there would be little cost in allowing a symlink to
> >    (union-whiteout) to be treated as a whiteout even though it has no xattrs
> >    (maybe as a mount option).
> >    For opaque you would need a somewhat less-elegant work around. e.g. if the
> >    directory contains a symlink to (union-opaque) called ._.union_opaque,
> >    then that symlink is hidden, and the directory is opaque.  This could be
> >    enabled by that same mount option.
> >    This might not be as efficient as xattrs, but then people don't use
> >    networked filesystems for their speed - they have other benefits.
> 
> I think unionfs/aufs do something like that.  Having namespace
> pollution is ugly, but well, we can live with that.

I agree with this as well. Back in 2006 we spoke with Ted Tso at OLS and
I believe he wasn't happy with the namespace pollution either. He
suggested that we create an on disk metadata format for unionfs that
would be used. If you look at the unionfs webpage there is an ODF branch
of the tree. This allows you to store whiteout and opaqueness data in a
separate file so that you don't have to pollute the namespace. This
might have some issues with locking and concurrency though. I didn't
work on this component so I'm unsure how it works. You might want to
look at that and see if it is worth trying to use again. 

> 
> But that's again something I'd think about when someone actually needs
> it.
> 
> Thanks,
> Miklos
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

