Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792Ab0HQWxt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 18:53:49 -0400
Received: from cantor.suse.de ([195.135.220.2]:59508 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230Ab0HQWxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 18:53:43 -0400
Date: Wed, 18 Aug 2010 08:53:33 +1000
From: Neil Brown <neilb@suse.de>
To: Valerie Aurora <vaurora@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 14/39] union-mount: Union mounts documentation
Message-ID: <20100818085333.02fa54d4@notabene>
In-Reply-To: <20100817204430.GE5556@shell>
References: <1281282776-5447-1-git-send-email-vaurora@redhat.com>
	<1281282776-5447-15-git-send-email-vaurora@redhat.com>
	<20100810085641.2b9a714c@notabene>
	<20100817204430.GE5556@shell>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Aug 2010 16:44:30 -0400
Valerie Aurora <vaurora@redhat.com> wrote:

> On Tue, Aug 10, 2010 at 08:56:41AM +1000, Neil Brown wrote:
> > On Sun,  8 Aug 2010 11:52:31 -0400
> > Valerie Aurora <vaurora@redhat.com> wrote:
> > 
> > 
> > > +A union mount layers one read-write file system over one or more
> > > +read-only file systems, with all writes going to the writable file
> > > +system.  The namespace of both file systems appears as a combined
> > > +whole to userland, with files and directories on the writable file
> > > +system covering up any files or directories with matching pathnames on
> > > +the read-only file system.  The read-write file system is the
> > > +"topmost" or "upper" file system and the read-only file systems are
> > > +the "lower" file systems.  A few use cases:
> > > +
> > > +- Root file system on CD with writes saved to hard drive (LiveCD)
> > > +- Multiple virtual machines with the same starting root file system
> > > +- Cluster with NFS mounted root on clients
> > > +
> > > +Most if not all of these problems could be solved with a COW block
> > > +device or a clustered file system (include NFS mounts).  However, for
> > > +some use cases, sharing is more efficient and better performing if
> > > +done at the file system namespace level.  COW block devices only
> > > +increase their divergence as time goes on, and a fully coherent
> > > +writable file system is unnecessary synchronization overhead if no
> > > +other client needs to see the writes.
> > 
> > Thanks for including lots of documentation!
> > Given how intrusive this patch set is, I would really like the see the
> > justification above fleshed out a bit more.
> > 
> > What would be particularly valuable would be real-life use cases where
> > someone has put this to work and found that it genuinely meets a need.
> > I realise there can be a bit of a chicken/egg issue there, but if you do have
> > anything it would be good to include it.
> 
> I felt the way you did until I talked to several users who explained
> to me why none of the existing solutions worked well for their use
> case.  The real-life use cases are those where people are currently
> using unionfs and aufs, which include many live CDs, Linux appliances,
> and at least three national lab computer clusters.  The best argument
> for their need for a union file system is that they are using unionfs
> and aufs despite the pain of using out-of-mainline code and (according
> to the users I have spoken to) frequent crashes.  Union mounts is
> intended as an in-mainline replacement for the existing users of
> unionfs and aufs.

You present a good argument that "something must be done", but it gives no
pointers to what that something should be.
I don't suppose it is possible to get that explanation you mention is writing?

> 
> I'm not sure this needs to be in Documentation/ - at the point it is
> merged into mainline, we will have already agreed on whether it is
> necessary. :)

However, until it is merged in to mainline it would be good to keep the
justification of this change well documented so you don't have to repeat the
same argument to every bozo who pops up and thinks they know better.
Ultimately the git commit log (or even an lwn.net article) could well be a
better place to store this rather than Documenation/, but I think there is
still value in it being written.


> 
> > > +Non-features
> > > +------------
> > > +
> > > +Features we do not currently plan to support in union mounts:
> > > +
> > > +Online upgrade: E.g., installing software on a file system NFS
> > > +exported to clients while the clients are still up and running.
> > > +Allowing the read-only bottom layer of a union mount to change
> > > +invalidates our locking strategy.
> > 
> > I wonder if the restriction is not more serious than this.
> > Given the prevalence of "copy-up", particularly of directories, I would think
> > that even off-line upgrade would not be supported.
> > If the upgrade adds a file in a directory that has already been read (and
> > hence copied-up), or changes a file that has been chmodded, then the upgrade
> > will not be completely visible, which sounds dangerous.
> > 
> > Don't you have to require (or strongly recommend) that the underlying
> > filesystem remain unchanged while the on-top filesystem exists, not just
> > while it is mounted ??
> 
> It is true, you have to know what you are doing and carefully groom
> both file systems if you want to change the lower file system and get
> the effect you intended.  Just updating the lower file system and
> slapping the overlay back on will probably not accomplish what you
> want.
> 
> But frankly, this is an impossible problem to solve generically at the
> file system level. 

Absolutely right - no argument about that.
I just think that should be explicit in the documentation.
Right after the "Online upgrade" paragraph:

  Even off-line upgrade - e.g. installing software on an exported filesystem
  and the remounting that on client and union-mounting a pre-existing over
  lay on top of it - is significantly non-trivial and would require
  significant extra management software to created a working solution.
 (or something like that, but more that just one long sentence).


> 
> > As a counter-position for you or others to write cogent arguments against,
> > and to then include those arguments in the justification section,  I would
> > like to present my preferred approach, which is essentially that the problem
> > is better solved at the block layer or the distro layer.
> 
> I personally like the block layer solution better and would be
> happiest if all unionfs and aufs users switched to it and no one
> needed union mounts. :) This is one case where the author is not in
> love with the solution.  I'm not going to argue for the need for it
> beyond noting the existing unionfs and aufs user base.

That may be enough justification to work on this as a research project, but I
don't think it is enough justification to merge it into mainline.

Just because aufs might be the best available solution to a particular problem
doesn't mean that making a better aufs (aka VFS union mounts) will be the best
possible solution.  That can only be determine if the key needs, and the
problems with all available solutions, are publicly known.

Thanks,
NeilBrown

