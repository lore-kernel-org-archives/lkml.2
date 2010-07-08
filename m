Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087Ab0GHFDz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 01:03:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46860 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242Ab0GHFDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 01:03:54 -0400
Date: Thu, 8 Jul 2010 15:03:31 +1000
From: Neil Brown <neilb@suse.de>
To: Andreas Dilger <andreas.dilger@oracle.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
       Miklos Szeredi <miklos@szeredi.hu>, david@fromorbit.com,
       aneesh.kumar@linux.vnet.ibm.com, hch@infradead.org,
       viro@zeniv.linux.org.uk, adilger@sun.com, corbet@lwn.net,
       serue@us.ibm.com, hooanon05@yahoo.co.jp, linux-fsdevel@vger.kernel.org,
       sfrench@us.ibm.com, philippe.deniel@CEA.FR,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V14 0/11] Generic name to handle and open by handle
 syscalls
Message-ID: <20100708150331.10c6ef52@notabene.brown>
In-Reply-To: <B5A5C6E8-0F5C-4649-8D72-D0E8989B67A8@oracle.com>
References: <20100706161002.GD7387@fieldses.org>
	<87eifgfsez.fsf@linux.vnet.ibm.com>
	<20100706232351.GD25018@dastard>
	<20100707093629.10c2feab@notabene.brown>
	<20100707021150.GF25018@dastard>
	<20100707125726.3695587a@notabene.brown>
	<20100707125701.GA19872@fieldses.org>
	<E1OWUOL-0004DM-Ul@pomaz-ex.szeredi.hu>
	<20100707131721.GB19872@fieldses.org>
	<E1OWUn0-0004JI-7F@pomaz-ex.szeredi.hu>
	<20100707144511.GA24360@fieldses.org>
	<20100708082143.3701bfc7@notabene.brown>
	<B5A5C6E8-0F5C-4649-8D72-D0E8989B67A8@oracle.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jul 2010 18:03:36 -0600
Andreas Dilger <andreas.dilger@oracle.com> wrote:

> On 2010-07-07, at 16:21, Neil Brown wrote:
> > It doesn't matter if there is an underlying block device, or if it is shared
> > among subvolmes.  st_dev is *the* primary key for filesystems.  Every "struct super_block" has a unique s_dev and that is returned in st_dev.
> > 
> > For "traditional" filesystem, this is the major/minor number of the block
> > device.
> > For NFS and btrfs and other filesystems which don't have exclusive use of a
> > block device, 'set_anon_super' is used to get a unique s_dev based on a major
> > number of '0'.
> 
> But the major/minor number returned is essentially random between different clients, so there is no way to use it on another node that is accessing the same filesystem.  Conversely, the UUID will be the same on all of the clients.
> 
> > So you can *always* use st_dev as an identifier for the filesystem which is
> > stable and unique as long as you hold an active reference to the filesystem
> > (open file descriptor, cwd in fs, etc).
> 
> Only on a single system.

Well the system call only runs on a single system.
If you want a cluster-unique name, get the cluster software to generate it
or enforce it.
Performing a mapping is not hard.

> 
> > If you poll(2) /proc/mounts to get notifications of changes to the mount
> > table, then it should be quite easy to cache st-dev -> uuid mappings in a
> > race-free way.
> 
> This sounds unpleasant for any application to implement.  It might be OK for a user-space NFS/CIFS server, but it is complex and error-prone for any normal usage, and doesn't seem like a good API design to me.

Define "normal usage" for filehandle-based lookup ???

Identifing a filesystem by st_dev is completely reliable.  That is a good
start for API design.

Identifing by UUID is not unless uniqueness is enforced, and ....

> 
> > There might be value in getting name_to_handle to return the st_dev of the
> > target file to ensure that you haven't unexepected crossed into a different
> > filesystem.  I would prefer that to returning a uuid:  st_dev is guaranteed
> > to be unique, a uuid is only supposed to be unique (i.e. that is not
> > enforced).
> 
> UUID duplication (w.r.t. multiple mounts of the same underlying device) doesn't matter at all for regular file opens, where the only interest is getting a handle for the inode.  I wouldn't be against requiring the UUID be unique if that was needed, or failing regular opens in the rare case that there is a non-unique UUID pointing to different devices, or failing directory opens for the case of multiple mountpoints.

It has already been said that requiring uuids to be unique breaks current
practice (involving mounting dm snapshots of active filesystems).
Failing legitimate syscalls in rare circumstances sounds like bad API design
to me.

NeilBrown


> 
> Cheers, Andreas
> --
> Andreas Dilger
> Lustre Technical Lead
> Oracle Corporation Canada Inc.

