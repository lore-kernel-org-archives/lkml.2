Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758596Ab0ECMBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 08:01:22 -0400
Received: from anguilla.debian.or.at ([86.59.21.37]:41660 "EHLO
	anguilla.debian.or.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758416Ab0ECMBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 08:01:11 -0400
X-Greylist: delayed 392 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 May 2010 08:01:11 EDT
Date: Mon, 3 May 2010 13:54:38 +0200
From: Peter Palfrader <peter@palfrader.org>
To: linux-kernel@vger.kernel.org
Cc: xfs@oss.sgi.com, david@fromorbit.com, stable@kernel.org
Subject: [regression,bisected] 2.6.32.12: find(1) on xfs causes OOM
Message-ID: <20100503115438.GA16623@anguilla.noreply.org>
Mail-Followup-To: Peter Palfrader <peter@palfrader.org>,
	linux-kernel@vger.kernel.org, xfs@oss.sgi.com, david@fromorbit.com,
	stable@kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
X-PGP: 1024D/94C09C7F 5B00 C96D 5D54 AEE1 206B  AF84 DE7A AF6E 94C0 9C7F
X-Request-PGP: http://www.palfrader.org/keys/94C09C7F.asc
X-Accept-Language: de, en
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have an xfs filesystem in a KVM domain with 512megs of memory and 2 gigs of
swap.

The filesystem is 750g in size, of which some 500g are in use in about 6
million files.  (This XFS filesystem is exported via nfs4.  I haven't tested if
this makes any difference.)

Starting in 2.6.32.12 running something like "find | wc -l" on this
filesystem's mountpoint causes the OOM killer to kill off most of the
system.  (See kern.log[1])

With 2.6.32.11 the system does not behave like this.

Bisecting turned up the following commit.  Reverting it in 2.6.32.12
also results in a system that works.

| 9e1e9675fb29c0e94a7c87146138aa2135feba2f is first bad commit
| commit 9e1e9675fb29c0e94a7c87146138aa2135feba2f
| Author: Dave Chinner <david@fromorbit.com>
| Date:   Fri Mar 12 09:42:10 2010 +1100
| 
|     xfs: reclaim all inodes by background tree walks
|     
|     commit 57817c68229984818fea9e614d6f95249c3fb098 upstream
|     
|     We cannot do direct inode reclaim without taking the flush lock to
|     ensure that we do not reclaim an inode under IO. We check the inode
|     is clean before doing direct reclaim, but this is not good enough
|     because the inode flush code marks the inode clean once it has
|     copied the in-core dirty state to the backing buffer.
|     
|     It is the flush lock that determines whether the inode is still
|     under IO, even though it is marked clean, and the inode is still
|     required at IO completion so we can't reclaim it even though it is
|     clean in core. Hence the requirement that we need to take the flush
|     lock even on clean inodes because this guarantees that the inode
|     writeback IO has completed and it is safe to reclaim the inode.
|     
|     With delayed write inode flushing, we could end up waiting a long
|     time on the flush lock even for a clean inode. The background
|     reclaim already handles this efficiently, so avoid all the problems
|     by killing the direct reclaim path altogether.
|     
|     Signed-off-by: Dave Chinner <david@fromorbit.com>
|     Reviewed-by: Christoph Hellwig <hch@lst.de>
|     Signed-off-by: Alex Elder <aelder@sgi.com>
|     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
|
| diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
| index a82a93d..ea7a59a 100644
| --- a/fs/xfs/linux-2.6/xfs_super.c
| +++ b/fs/xfs/linux-2.6/xfs_super.c
| @@ -953,16 +953,14 @@ xfs_fs_destroy_inode(
|         ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_IRECLAIM));
|  
|         /*
| -        * If we have nothing to flush with this inode then complete the
| -        * teardown now, otherwise delay the flush operation.
| +        * We always use background reclaim here because even if the
| +        * inode is clean, it still may be under IO and hence we have
| +        * to take the flush lock. The background reclaim path handles
| +        * this more efficiently than we can here, so simply let background
| +        * reclaim tear down all inodes.
|          */
| -       if (!xfs_inode_clean(ip)) {
| -               xfs_inode_set_reclaim_tag(ip);
| -               return;
| -       }
| -
|  out_reclaim:
| -       xfs_ireclaim(ip);
| +       xfs_inode_set_reclaim_tag(ip);
|  }
|  
|  /*


Cheers,
Peter

1. http://asteria.noreply.org/~weasel/volatile/2010-05-03-Aju29kSrm0A/kern.log
2. http://asteria.noreply.org/~weasel/volatile/2010-05-03-Aju29kSrm0A/config-2.6.32.12-dsa-amd64
-- 
                           |  .''`.  ** Debian GNU/Linux **
      Peter Palfrader      | : :' :      The  universal
 http://www.palfrader.org/ | `. `'      Operating System
                           |   `-    http://www.debian.org/
