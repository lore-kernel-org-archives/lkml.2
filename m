Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757826Ab1K3MPF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 07:15:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8106 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807Ab1K3MPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 07:15:01 -0500
Date: Wed, 30 Nov 2011 07:14:18 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Jan Kara <jack@suse.cz>
cc: Alasdair G Kergon <agk@redhat.com>, esandeen@redhat.com,
        Surbhi Palande <csurbhi@gmail.com>, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org,
        Christopher Chaltain <christopher.chaltain@canonical.com>,
        Valerie Aurora <val@vaaconsulting.com>
Subject: Re: [dm-devel] [PATCH] deadlock with suspend and quotas
In-Reply-To: <20111130111657.GA4541@quack.suse.cz>
Message-ID: <Pine.LNX.4.64.1111300700190.27712@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1111281754120.11895@hs20-bc2-1.build.redhat.com>
 <20111129101901.GA5635@quack.suse.cz> <20111129102156.GA7463@quack.suse.cz>
 <Pine.LNX.4.64.1111290556270.12274@hs20-bc2-1.build.redhat.com>
 <20111129111136.GC5635@quack.suse.cz> <Pine.LNX.4.64.1111290746230.10352@hs20-bc2-1.build.redhat.com>
 <20111129130913.GE5635@quack.suse.cz> <20111129131811.GS7595@agk-dp.fab.redhat.com>
 <20111129133239.GA9926@quack.suse.cz> <Pine.LNX.4.64.1111300143340.31264@hs20-bc2-1.build.redhat.com>
 <20111130111657.GA4541@quack.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 Nov 2011, Jan Kara wrote:

> On Wed 30-11-11 01:52:22, Mikulas Patocka wrote:
> > > > dm-ioctl.h:
> > > > /*
> > > >  * Set this to avoid attempting to freeze any filesystem when suspending.
> > > >  */
> > > > #define DM_SKIP_LOCKFS_FLAG     (1 << 10) /* In */
> > >   Thanks. I was now checking in detail and indeed FIFREEZE fails if
> > > ->freeze_fs is not set. And only xfs, ext3, ext4, reiserfs, jfs, nilfs2,
> > > and gfs2 provide this function. So I was correct in assuming that when
> > > filesystem supports FIFREEZE it must make sure no modifications happen to
> > > the filesystem. So I believe that my original plan for sync to skip frozen
> > > filesystem is correct.
> > > 
> > > 								Honza
> > 
> > LVM doesn't suspend with FIFREEZE, it calls freeze_bdev directly from 
> > drivers/md/dm.c (and it works for all filesystems, including ext2).
>   Ah, I see. Sorry I missed this. But then I can only reiterate that
> drivers/md/dm.c is IMHO broken. Either it cares about filesystem being
> really frozen - and then it should refuse the operation for e.g. ext2
> because it cannot be frozen - or it does not care about filesystem being
> frozen and then there's no point in calling freeze_super(). Possibly, you
> might still want to e.g. try snapshotting even if freeze_super() would
> return EOPNOTSUPP but that should be handled inside dm, not by errorneously
> marking filesystem as frozen when it is not. Or am I still missing
> something?
> 
> > So if you skip sync of frozen filesystems, you introduce a data
> > corruption if someone takes a snapshot of ext2.
>   Yes, because ext2 cannot really be frozen, it is (errorneously) marked
> as such but it is not frozen...
> 
> 								Honza

The semantics of freeze is like "do the best you can". You can't freeze 
ext2 to a clean state (even if you managed to block all code paths that 
create dirty data, it still can't be cleaned because you can't get rid of 
inodes that are open and deleted).

On non-journaled filesystems, freeze_bdev does a sync of the filesystem 
and prevents some code paths (such as __generic_file_aio_write) from 
creating more dirty data with "vfs_check_frozen" --- that vfs_check_frozen 
doesn't guarantee anything, but it reduces a probability of corruption.

So at the end, all data that were dirty before taking a snapshot are 
guaranteed to be flushed to disk. And if someone writes to the ext2 
filesystem while taking a snapshot, it may create inconsistencies that 
must be fixed by running fsck on the snapshot.

Mikulas
