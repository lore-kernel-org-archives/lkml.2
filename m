Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236Ab0HIW4z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 18:56:55 -0400
Received: from cantor.suse.de ([195.135.220.2]:32959 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757162Ab0HIW4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 18:56:53 -0400
Date: Tue, 10 Aug 2010 08:56:41 +1000
From: Neil Brown <neilb@suse.de>
To: Valerie Aurora <vaurora@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 14/39] union-mount: Union mounts documentation
Message-ID: <20100810085641.2b9a714c@notabene>
In-Reply-To: <1281282776-5447-15-git-send-email-vaurora@redhat.com>
References: <1281282776-5447-1-git-send-email-vaurora@redhat.com>
	<1281282776-5447-15-git-send-email-vaurora@redhat.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  8 Aug 2010 11:52:31 -0400
Valerie Aurora <vaurora@redhat.com> wrote:


> +A union mount layers one read-write file system over one or more
> +read-only file systems, with all writes going to the writable file
> +system.  The namespace of both file systems appears as a combined
> +whole to userland, with files and directories on the writable file
> +system covering up any files or directories with matching pathnames on
> +the read-only file system.  The read-write file system is the
> +"topmost" or "upper" file system and the read-only file systems are
> +the "lower" file systems.  A few use cases:
> +
> +- Root file system on CD with writes saved to hard drive (LiveCD)
> +- Multiple virtual machines with the same starting root file system
> +- Cluster with NFS mounted root on clients
> +
> +Most if not all of these problems could be solved with a COW block
> +device or a clustered file system (include NFS mounts).  However, for
> +some use cases, sharing is more efficient and better performing if
> +done at the file system namespace level.  COW block devices only
> +increase their divergence as time goes on, and a fully coherent
> +writable file system is unnecessary synchronization overhead if no
> +other client needs to see the writes.

Thanks for including lots of documentation!
Given how intrusive this patch set is, I would really like the see the
justification above fleshed out a bit more.

What would be particularly valuable would be real-life use cases where
someone has put this to work and found that it genuinely meets a need.
I realise there can be a bit of a chicken/egg issue there, but if you do have
anything it would be good to include it.
A particular need for this is that fact that a number of standard features
are not going to be supported and it would be good to be sure that there are
real cases that don't need those.

...

> +Non-features
> +------------
> +
> +Features we do not currently plan to support in union mounts:
> +
> +Online upgrade: E.g., installing software on a file system NFS
> +exported to clients while the clients are still up and running.
> +Allowing the read-only bottom layer of a union mount to change
> +invalidates our locking strategy.

I wonder if the restriction is not more serious than this.
Given the prevalence of "copy-up", particularly of directories, I would think
that even off-line upgrade would not be supported.
If the upgrade adds a file in a directory that has already been read (and
hence copied-up), or changes a file that has been chmodded, then the upgrade
will not be completely visible, which sounds dangerous.

Don't you have to require (or strongly recommend) that the underlying
filesystem remain unchanged while the on-top filesystem exists, not just
while it is mounted ??



As a counter-position for you or others to write cogent arguments against,
and to then include those arguments in the justification section,  I would
like to present my preferred approach, which is essentially that the problem
is better solved at the block layer or the distro layer.

A distro-layer solution would be appropriate when you want a common root
filesystem with per-host configuration, whether in an NFS cluster of a
virtual-machine cluster.
This involved every file that might need configuration being made a symlink
to e.g. /local, and every instance mounts some local directory on /local.
e.g.  mount --bind /local-`hostname` /local

This is obviously less transparent, but it is also more predictable (you
know exactly what can and cannot be changed by an upgraded on the shared
filesystem).

A convincing use case that required NFS sharing and required signficantly
more customisation that just some config file would be a good
counter-argument to this.

I see two block-layer solutions.  The obvious is a COW block device as you
have mentioned.  I am not convinced that it is as bad as you think.
Particularly if the COW device could advertise that it handles small
'discard' requests efficiently, and if filesystems could then send small
discard requests whenever appropriate, the wastage due to divergence need not
be too great.
In any case, some hard numbers like "Performing a kernel compile on a COW
device requires N meg of space while using a union-mounted filesystem it
requires M ( << N) meg of space" would help a lot.  (of course that is a silly
test as we would use "make O=/somewhere/else", not COW or Union for that
task).

The second solution would be filesystem specific, and hence a good selling
point of a new up-and-coming filesystem.
If a filesystem was comfortable with data on multiple devices, and was able
to copy-on-write files, then it should be relatively easy to give it a
read-only device and a clean read-write device, and tell it write all changes
only to the second device (and never update even the filesystem metadata on
the first device).  The filesystem could then make effective use of any space
available in the second device, without wastage.


> +Thank you for reading!

Thank you for writing!

NeilBrown
