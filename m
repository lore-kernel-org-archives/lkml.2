Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848Ab0FIHrv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 03:47:51 -0400
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:60152 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755585Ab0FIHrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 03:47:49 -0400
Date: Wed, 9 Jun 2010 17:47:41 +1000
From: Dave Chinner <david@fromorbit.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: xfs, 2.6.27=>.32 sync write 10 times slowdown [was: xfs,
 aacraid 2.6.27 => 2.6.32 results in 6 times slowdown]
Message-ID: <20100609074741.GJ7869@dastard>
References: <4C0E13A7.20402@msgid.tls.msk.ru>
 <20100608122919.GC7869@dastard>
 <4C0EA938.9000104@msgid.tls.msk.ru>
 <20100608231845.GG7869@dastard>
 <4C0F3819.4000409@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C0F3819.4000409@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 09, 2010 at 10:43:37AM +0400, Michael Tokarev wrote:
> 09.06.2010 03:18, Dave Chinner wrote:
> >On Wed, Jun 09, 2010 at 12:34:00AM +0400, Michael Tokarev wrote:
> []
> >>Simple test doing random reads or writes of 4k blocks in a 1Gb
> >>file located on an xfs filesystem, Mb/sec:
> >>
> >>                      sync  direct
> >>              read   write   write
> >>2.6.27 xfs   1.17    3.69    3.80
> >>2.6.32 xfs   1.26    0.52    5.10
> >>                     ^^^^
> >>2.6.32 ext3  1.19    4.91    5.02

Out of curiousity, what does 2.6.34 get on this workload?

Also, what happens if you test with noop or deadline scheduler,
rather than cfq (or whichever one you are using)? i.e. is this a
scheduler regression rather than a filesystem issue?

Also, a block trace of the sync write workload on both .27 and .32
would be interesting to see what the difference in IO patterns is...

> >>Note the 10 times difference between O_SYNC and O_DIRECT writes
> >>in 2.6.32.  This is, well, huge difference, and this is where
> >>the original slowdown comes from, apparently.
> >
> >Are you running on the raw block device, or on top of LVM/DM/MD to
> >split up the space on the RAID drive? DM+MD have grown barrier
> >support since 2.6.27, so it may be that barriers are now being
> >passed down to the raid hardware on 2.6.32 and they never were on
> >2.6.27. Can you paste the output of dmesg when the XFS filesystem in
> 
> That's why I asked how to tell if barriers are actually hitting the
> device in question.
> 
> No, this is the only machine where DM/MD is _not_ used.  On all other
> machines we use MD software raid, this machine comes with an onboard
> raid controller that does not work in JBOD mode so I weren't able to
> use linux software raid.  This is XFS on top of Adaptec RAID card,
> nothing in-between.

Well, I normally just create a raid0 lun per disk in those cases,
hence the luns present the storage to linux as a JBOD....

> I also experimented with both O_SYNC|O_DIRECT: it is as slow as
> without O_DIRECT, i.e. O_SYNC makes whole thing slow regardless
> of other options.

So it's the inode writeback that is causing the slowdown. We've
recently changed O_SYNC semantics to be real O_SYNC, not O_DSYNC
as .27 is. I can't remember if that was in 2.6.32 or not, but
there's definitely a recent change to O_SYNC behaviouri that would
cause this...

> related to block devices or usage of barriers.  For XFS it always
> mounts like this:
> 
>  SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
>  SGI XFS Quota Management subsystem
>  XFS mounting filesystem sda6

So barriers are being issued.

> and for the device in question, it is always like
> 
>  Adaptec aacraid driver 1.1-5[2456]-ms
>  aacraid 0000:03:01.0: PCI INT A -> GSI 24 (level, low) -> IRQ 24
>  AAC0: kernel 5.1-0[8832] Feb  1 2006

Old firmware. An update might help.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
