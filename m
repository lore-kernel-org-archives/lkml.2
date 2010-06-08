Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab0FHXSy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 19:18:54 -0400
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:55543 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755024Ab0FHXSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 19:18:53 -0400
Date: Wed, 9 Jun 2010 09:18:45 +1000
From: Dave Chinner <david@fromorbit.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: xfs, 2.6.27=>.32 sync write 10 times slowdown [was: xfs,
 aacraid 2.6.27 => 2.6.32 results in 6 times slowdown]
Message-ID: <20100608231845.GG7869@dastard>
References: <4C0E13A7.20402@msgid.tls.msk.ru>
 <20100608122919.GC7869@dastard>
 <4C0EA938.9000104@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C0EA938.9000104@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 09, 2010 at 12:34:00AM +0400, Michael Tokarev wrote:
> 08.06.2010 16:29, Dave Chinner wrote:
> >On Tue, Jun 08, 2010 at 01:55:51PM +0400, Michael Tokarev wrote:
> >>Hello.
> >>
> >>I've got a.. difficult issue here, and am asking if anyone else
> >>has some expirence or information about it.
> >>
> >>Production environment (database).  Machine with an Adaptec
> >>RAID SCSI controller, 6 drives in raid10 array, XFS filesystem
> >>and Oracle database on top of it (with - hopefully - proper
> >>sunit/swidth).
> >>
> >>Upgrading kernel from 2.6.27 to 2.6.32, and users starts screaming
> >>about very bad performance.  Iostat reports increased I/O latencies,
> >>I/O time increases from ~5ms to ~30ms.  Switching back to 2.6.27,
> >>and everything is back to normal (or, rather, usual).
....
> >>The most problematic issue here is that this is only one machine that
> >>behaves like this, and it is a production server, so I've very little
> >>chances to experiment with it.
> >>
> >>So before the next try, I'd love to have some suggestions about what
> >>to look for.   In particular, I think it's worth the effort to look
> >>at write barriers, but again, I don't know how to check if they're
> >>actually being used.
> >>
> >>Anyone have suggestions for me to collect and to look at?
> >
> >http://xfs.org/index.php/XFS_FAQ#Q._Should_barriers_be_enabled_with_storage_which_has_a_persistent_write_cache.3F
> 
> Yes, I've seen this.  We use xfs for quite long time.  The on-board
> controller does not have battery unit, so it should be no different
> than a software raid array or single drive.
> 
> But I traced the issue to a particular workload -- see $subject.
> 
> Simple test doing random reads or writes of 4k blocks in a 1Gb
> file located on an xfs filesystem, Mb/sec:
> 
>                      sync  direct
>              read   write   write
> 2.6.27 xfs   1.17    3.69    3.80
> 2.6.32 xfs   1.26    0.52    5.10
>                      ^^^^
> 2.6.32 ext3  1.19    4.91    5.02
> 
> Note the 10 times difference between O_SYNC and O_DIRECT writes
> in 2.6.32.  This is, well, huge difference, and this is where
> the original slowdown comes from, apparently. 

Are you running on the raw block device, or on top of LVM/DM/MD to
split up the space on the RAID drive? DM+MD have grown barrier
support since 2.6.27, so it may be that barriers are now being
passed down to the raid hardware on 2.6.32 and they never were on
2.6.27. Can you paste the output of dmesg when the XFS filesystem in
question is mounted on both 2.6.27 and 2.6.32 so we can see if
there is a difference in the use of barriers?

Also, remember that O_DIRECT does not imply O_SYNC. O_DIRECT writes
only write data, while O_SYNC will also write metadata and/or the
log.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
