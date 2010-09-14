Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab0INHgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 03:36:49 -0400
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:47766 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752297Ab0INHgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 03:36:47 -0400
Date: Tue, 14 Sep 2010 17:36:43 +1000
From: Dave Chinner <david@fromorbit.com>
To: Brett Russ <icycle+lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: O_DIRECT reads appear to be cached on block device partition
 file?
Message-ID: <20100914073643.GB15695@dastard>
References: <i6mrcc$ers$1@dough.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <i6mrcc$ers$1@dough.gmane.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 11:49:32PM -0400, Brett Russ wrote:
> Running a 2.6.31 kernel on a blade chassis system with multiple
> blades sharing common JBOD storage.  The application intelligently
> divides the drives up among the blades, but one blade in particular
> is charged with monitoring.  As part of this, this one monitoring
> blade can perform reads of a certain 512B sector of all disks in the
> system.  This sector is often written by other blades, these writes
> are sync'd to disk.  To work around the lack of cache coherency
> between the distinct blades, I'm using O_DIRECT on the monitoring
> blade such that it always reads from the media to get the latest
> copy of this sector.  The basic steps are:
> 
> # grab a 512B aligned buffer (use 4KB to be safe)
> posix_memalign(&ptr, getpagesize(), 512B)
> open(/dev/sdX3, O_RDONLY|O_DIRECT)
> lseek(fd, offset, SEEK_SET)
> read(fd, ptr, 512B)
> 
> If I run the above on the monitoring blade, then sync an update to
> the sector in question from another blade, then re-reun the above
> code on the monitoring blade, believe it or not I appear to be
> reading stale data.  If I use dd with iflag=direct, reading the same
> sector offset at the /dev/sdX3 partition file, I see the same stale
> data as seen from the code above.  If, however, I instead access
> this sector offset from the /dev/sdX device file using the (offset
> of partition 3 + offset of the sector) I see the intended data,
> which makes me believe some caching occurred locally for /dev/sdX3.

What does blktrace tell you?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
