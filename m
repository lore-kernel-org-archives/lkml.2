Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751192Ab0HQUo5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 16:44:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035Ab0HQUou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 16:44:50 -0400
Date: Tue, 17 Aug 2010 16:44:30 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Neil Brown <neilb@suse.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 14/39] union-mount: Union mounts documentation
Message-ID: <20100817204430.GE5556@shell>
References: <1281282776-5447-1-git-send-email-vaurora@redhat.com> <1281282776-5447-15-git-send-email-vaurora@redhat.com> <20100810085641.2b9a714c@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100810085641.2b9a714c@notabene>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 10, 2010 at 08:56:41AM +1000, Neil Brown wrote:
> On Sun,  8 Aug 2010 11:52:31 -0400
> Valerie Aurora <vaurora@redhat.com> wrote:
> 
> 
> > +A union mount layers one read-write file system over one or more
> > +read-only file systems, with all writes going to the writable file
> > +system.  The namespace of both file systems appears as a combined
> > +whole to userland, with files and directories on the writable file
> > +system covering up any files or directories with matching pathnames on
> > +the read-only file system.  The read-write file system is the
> > +"topmost" or "upper" file system and the read-only file systems are
> > +the "lower" file systems.  A few use cases:
> > +
> > +- Root file system on CD with writes saved to hard drive (LiveCD)
> > +- Multiple virtual machines with the same starting root file system
> > +- Cluster with NFS mounted root on clients
> > +
> > +Most if not all of these problems could be solved with a COW block
> > +device or a clustered file system (include NFS mounts).  However, for
> > +some use cases, sharing is more efficient and better performing if
> > +done at the file system namespace level.  COW block devices only
> > +increase their divergence as time goes on, and a fully coherent
> > +writable file system is unnecessary synchronization overhead if no
> > +other client needs to see the writes.
> 
> Thanks for including lots of documentation!
> Given how intrusive this patch set is, I would really like the see the
> justification above fleshed out a bit more.
> 
> What would be particularly valuable would be real-life use cases where
> someone has put this to work and found that it genuinely meets a need.
> I realise there can be a bit of a chicken/egg issue there, but if you do have
> anything it would be good to include it.

I felt the way you did until I talked to several users who explained
to me why none of the existing solutions worked well for their use
case.  The real-life use cases are those where people are currently
using unionfs and aufs, which include many live CDs, Linux appliances,
and at least three national lab computer clusters.  The best argument
for their need for a union file system is that they are using unionfs
and aufs despite the pain of using out-of-mainline code and (according
to the users I have spoken to) frequent crashes.  Union mounts is
intended as an in-mainline replacement for the existing users of
unionfs and aufs.

I'm not sure this needs to be in Documentation/ - at the point it is
merged into mainline, we will have already agreed on whether it is
necessary. :)

> > +Non-features
> > +------------
> > +
> > +Features we do not currently plan to support in union mounts:
> > +
> > +Online upgrade: E.g., installing software on a file system NFS
> > +exported to clients while the clients are still up and running.
> > +Allowing the read-only bottom layer of a union mount to change
> > +invalidates our locking strategy.
> 
> I wonder if the restriction is not more serious than this.
> Given the prevalence of "copy-up", particularly of directories, I would think
> that even off-line upgrade would not be supported.
> If the upgrade adds a file in a directory that has already been read (and
> hence copied-up), or changes a file that has been chmodded, then the upgrade
> will not be completely visible, which sounds dangerous.
> 
> Don't you have to require (or strongly recommend) that the underlying
> filesystem remain unchanged while the on-top filesystem exists, not just
> while it is mounted ??

It is true, you have to know what you are doing and carefully groom
both file systems if you want to change the lower file system and get
the effect you intended.  Just updating the lower file system and
slapping the overlay back on will probably not accomplish what you
want.

But frankly, this is an impossible problem to solve generically at the
file system level.  When a user says, "Show the changes to the lower
file system in my overlaid file system," they are actually saying,
"Replace everything in /bin, but not /etc/hostname, and merge the
lower package database with the upper package database, and update
/etc/resolv.conf, unless it's the mailserver..."  If you look into the
problems with merging after running in disconnected mode in Coda, it's
exactly the same set of problems.  They "solved" it by proposing
application-specific merging programs that you run one by one for each
file that was modified in two places during the time the client was
disconnected.  Here's the first quote I found:

http://www.coda.cs.cmu.edu/ljpaper/lj.html

"The second issue is that during reintegration it may appear that
during the disconnection another client has modified the file too and
have shipped it to the server. This is called a local/global conflict
(viz. Client/Server) which needs repair. Repairs can sometimes be done
automatically by application specific resolvers (which know that one
client inserting an appointment into a calendar file for Monday and
another client inserting one for Tuesday have not created an
irresolvable conflict). Sometimes, but quite infrequently, human
intervention is needed to repair the conflict."

Union mounts doesn't solve the problem of how to resolve conflicts
between two versions of a file system.  All I can do is give you tools
to clear opaque flags, delete fallthrus and whiteouts, and things like
that.  You can, for example, clear all opaque directory flags and
fallthrus in the overlay, so that new files will show up but deleted
files will continue to be whited-out - which may be what you want,
unless it's not.

Another thing you can do is is do the upgrade on the union mounted fs,
unmount it, remount the fs's separately, and then do a comparison and
delete all files on the overlay that are identical on both fs's.  All
this only makes sense to do in userspace, it's way too complicated and
policy-ridden to do in-kernel and online.

To solve the upgrade problem, you don't need a file system, you need
to use a tool like Puppet, which will automatically upgrade and
configure thousands of hosts using recipes:

http://www.puppetlabs.com/puppet/introduction/

> As a counter-position for you or others to write cogent arguments against,
> and to then include those arguments in the justification section,  I would
> like to present my preferred approach, which is essentially that the problem
> is better solved at the block layer or the distro layer.

I personally like the block layer solution better and would be
happiest if all unionfs and aufs users switched to it and no one
needed union mounts. :) This is one case where the author is not in
love with the solution.  I'm not going to argue for the need for it
beyond noting the existing unionfs and aufs user base.

As to whether union mounts will work for the same cases as unionfs and
aufs, all I can say is that union mounts offers as much functionality
as I can figure out how to give without crashing the kernel.  At that
point userspace will have to either rewrite to work around problems or
else keep using out-of-mainline code.

-VAL
