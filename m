Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751028Ab2KGFCN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 00:02:13 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64939 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab2KGFCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 00:02:12 -0500
Date: Wed, 7 Nov 2012 13:02:04 +0800
From: Shaohua Li <shli@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Dave Chinner <david@fromorbit.com>, NeilBrown <neilb@suse.de>,
        linux RAID <linux-raid@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: Problem with DISCARD and RAID5
Message-ID: <20121107050204.GA5920@kernel.org>
References: <20121101173854.62061307@notabene.brown>
 <20121102014058.GA20526@kernel.org>
 <20121105214846.GM29378@dastard>
 <5098C4F8.9050700@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5098C4F8.9050700@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2012 at 09:06:16AM +0100, Jens Axboe wrote:
> On 2012-11-05 22:48, Dave Chinner wrote:
> > On Fri, Nov 02, 2012 at 09:40:58AM +0800, Shaohua Li wrote:
> >> On Thu, Nov 01, 2012 at 05:38:54PM +1100, NeilBrown wrote:
> >>>
> >>> Hi Shaohua,
> >>>  I've been doing some testing and discovered a problem with your discard
> >>>  support for RAID5.
> >>>
> >>>  The code in blkdev_issue_discard assumes that the 'granularity' is a power
> >>>  of 2, and for example subtracts 1 to get a mask.
> >>>
> >>>  However RAID5 sets the granularity to be the stripe size which often is not
> >>>  a power of two.  When this happens you can easily get into an infinite loop.
> >>>
> >>>  I suspect that to make this work properly, blkdev_issue_discard will need to
> >>>  be changed to allow 'granularity' to be an arbitrary value.
> >>>  When it is a power of two, the current masking can be used.
> >>>  When it is anything else, it will need to use sector_div().
> >>
> >> Yep, looks we need use sector_div. And this isn't the only problem. discard
> >> request can be merged, and the merge check only checks max_discard_sectors.
> >> That means the split requests in blkdev_issue_discard can be merged again. The
> >> split nerver works.
> >>
> >> I'm wondering what's purpose of discard_alignment and discard_granularity. Are
> >> there devices with discard_granularity not 1 sector?
> > 
> > Most certainly. Thin provisioned storage often has granularity in the
> > order of megabytes....
> 
> Can't really to to much about that...
> 
> >> If bio isn't discard
> >> aligned, what device will do?
> > 
> > Up to the device.
> 
> We should not send those down, if they are violating the restrictions
> set by the driver.
> 
> >> Further, why driver handles alignment/granularity
> >> if device will ignore misaligned request.
> > 
> > When you send a series of sequential unaligned requests, the device
> > may ignore them all. Hence you end up with nothing being discarded,
> > even though the entire range being discarded is much, much larger
> > than the discard granularity....
> 
> That's just tough luck, unfortunately. Shaohua, I'd suggest sending down
> whatever discards you can, IFF they are aligned according to the
> restrictions being set. If that ends up not discarding to devices that
> have large alignment/size constraints, nothing we can do about that.

So we have two problems here:

1. as Neil described, blkdev_issue_discard assumes alignment and granularity
are a power of 2. We can fix it with sector_div for example.

2. discard request can be merged. The merge check currently ignore alignment
and granularity. So it's possible unaligned requests are merged to aligned, or
one aligned request and one unaligned request are merged to unaligned. Just
ignore unaligned request, so such merge will not happen?
