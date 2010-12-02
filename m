Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989Ab0LBXIH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 18:08:07 -0500
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:41080 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753573Ab0LBXIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 18:08:05 -0500
Date: Fri, 3 Dec 2010 10:07:43 +1100
From: Dave Chinner <david@fromorbit.com>
To: Spelic <spelic@shiftmail.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        xfs@oss.sgi.com, linux-lvm@redhat.com
Subject: Re: Bugs in mkfs.xfs, device mapper, xfs, and /dev/ram
Message-ID: <20101202230743.GZ16922@dastard>
References: <4CF7A539.1050206@shiftmail.org>
 <4CF7A9CF.2020904@shiftmail.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CF7A9CF.2020904@shiftmail.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 02, 2010 at 03:14:39PM +0100, Spelic wrote:
> Sorry for replying to my own email already
> one more thing on the 3rd bug:
> 
> On 12/02/2010 02:55 PM, Spelic wrote:
> >Hello all
> >[CUT]
> >.......
> >with NFS over <RDMA or IPoIB> over Infiniband over XFS over
> >ramdisk it is possible to write a file (2.3GB) which is larger
> >than
> 
> This is also reproducible with:
> NFS over TCP over Ethernet over XFS over ramdisk.
> You don't need infiniband for this.
> With ethernet it doesn't hang (that's another bug, for RDMA people,
> in the othter thread) but the file is still 1.9GB, i.e. larger than
> the device.
> 
> 
> Look, after running the test over ethernet,
> at server side:
> 
> # ll -h /mnt/ram
> total 1.5G
> drwxr-xr-x 2 root root   21 2010-12-02 12:54 ./
> drwxr-xr-x 3 root root 4.0K 2010-11-29 23:51 ../
> -rw-r--r-- 1 root root 1.9G 2010-12-02 15:04 zerofile

This is a classic ENOSPC vs NFS client writeback overcommit caching
issue.  Have a look at the block map output - I bet theres holes in
the file and it's only consuming 1.5GB of disk space. use xfs_bmap
to check this. du should tell you the same thing.

Basically, the NFS client overcommits the server filesystem space by
doing local writeback caching. Hence it caches 1.9GB of data before
it gets the first ENOSPC error back from the server at around 1.5GB
of written data. At that point, the data that gets ENOSPC errors is
tossed by the NFS client, and a ENOSPC error is placed on the
address space to be reported to the next write/sync call. That gets
to the dd process when it's 1.9GB into the write.

However, there is still (in this case) 400MB of dirty data in the
NFS client cache that it will try to write to the server. Because
XFS uses speculative preallocation and reserves some space for
metadata allocation during delayed allocation, it's handling of the
initial ENOSPC condition can result in some space being freed up
again as unused reserved metadata space is returned to the free pool
as delalloc occurs during server writeback. This usually takes a
second or two to complete.

As a result, shortly after the first ENOSPC has been reported and
subsequent writes have also ENOSPC, we can have space freed up and
another write will succeed. At that point, the write that succeeds
will be a different offset to the last one that succeeded, leaving a
hole in the file and moving the EOF well past 1.5GB. That will go on
until there really is no space left at all or the NFS client has no
more dirty data to send.

Basically, what you see it not a bug in XFS, it is a result of NFS
clients being able to overcommit server filesystem space and the
interaction that has with the way the filesystem on the NFS server
handles ENOSPC.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
