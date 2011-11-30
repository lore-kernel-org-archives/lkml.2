Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642Ab1K3LR7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 06:17:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40218 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348Ab1K3LRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 06:17:55 -0500
Date: Wed, 30 Nov 2011 12:16:57 +0100
From: Jan Kara <jack@suse.cz>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Alasdair G Kergon <agk@redhat.com>,
        esandeen@redhat.com, Surbhi Palande <csurbhi@gmail.com>,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        linux-fsdevel@vger.kernel.org,
        Christopher Chaltain <christopher.chaltain@canonical.com>,
        Valerie Aurora <val@vaaconsulting.com>
Subject: Re: [dm-devel] [PATCH] deadlock with suspend and quotas
Message-ID: <20111130111657.GA4541@quack.suse.cz>
References: <Pine.LNX.4.64.1111281754120.11895@hs20-bc2-1.build.redhat.com>
 <20111129101901.GA5635@quack.suse.cz>
 <20111129102156.GA7463@quack.suse.cz>
 <Pine.LNX.4.64.1111290556270.12274@hs20-bc2-1.build.redhat.com>
 <20111129111136.GC5635@quack.suse.cz>
 <Pine.LNX.4.64.1111290746230.10352@hs20-bc2-1.build.redhat.com>
 <20111129130913.GE5635@quack.suse.cz>
 <20111129131811.GS7595@agk-dp.fab.redhat.com>
 <20111129133239.GA9926@quack.suse.cz>
 <Pine.LNX.4.64.1111300143340.31264@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1111300143340.31264@hs20-bc2-1.build.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 30-11-11 01:52:22, Mikulas Patocka wrote:
> > > dm-ioctl.h:
> > > /*
> > >  * Set this to avoid attempting to freeze any filesystem when suspending.
> > >  */
> > > #define DM_SKIP_LOCKFS_FLAG     (1 << 10) /* In */
> >   Thanks. I was now checking in detail and indeed FIFREEZE fails if
> > ->freeze_fs is not set. And only xfs, ext3, ext4, reiserfs, jfs, nilfs2,
> > and gfs2 provide this function. So I was correct in assuming that when
> > filesystem supports FIFREEZE it must make sure no modifications happen to
> > the filesystem. So I believe that my original plan for sync to skip frozen
> > filesystem is correct.
> > 
> > 								Honza
> 
> LVM doesn't suspend with FIFREEZE, it calls freeze_bdev directly from 
> drivers/md/dm.c (and it works for all filesystems, including ext2).
  Ah, I see. Sorry I missed this. But then I can only reiterate that
drivers/md/dm.c is IMHO broken. Either it cares about filesystem being
really frozen - and then it should refuse the operation for e.g. ext2
because it cannot be frozen - or it does not care about filesystem being
frozen and then there's no point in calling freeze_super(). Possibly, you
might still want to e.g. try snapshotting even if freeze_super() would
return EOPNOTSUPP but that should be handled inside dm, not by errorneously
marking filesystem as frozen when it is not. Or am I still missing
something?

> So if you skip sync of frozen filesystems, you introduce a data
> corruption if someone takes a snapshot of ext2.
  Yes, because ext2 cannot really be frozen, it is (errorneously) marked
as such but it is not frozen...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
