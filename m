Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762556Ab2KBBlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 21:41:18 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51933 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759556Ab2KBBlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 21:41:16 -0400
Date: Fri, 2 Nov 2012 09:40:58 +0800
From: Shaohua Li <shli@kernel.org>
To: NeilBrown <neilb@suse.de>
Cc: linux RAID <linux-raid@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: Problem with DISCARD and RAID5
Message-ID: <20121102014058.GA20526@kernel.org>
References: <20121101173854.62061307@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121101173854.62061307@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2012 at 05:38:54PM +1100, NeilBrown wrote:
> 
> Hi Shaohua,
>  I've been doing some testing and discovered a problem with your discard
>  support for RAID5.
> 
>  The code in blkdev_issue_discard assumes that the 'granularity' is a power
>  of 2, and for example subtracts 1 to get a mask.
> 
>  However RAID5 sets the granularity to be the stripe size which often is not
>  a power of two.  When this happens you can easily get into an infinite loop.
> 
>  I suspect that to make this work properly, blkdev_issue_discard will need to
>  be changed to allow 'granularity' to be an arbitrary value.
>  When it is a power of two, the current masking can be used.
>  When it is anything else, it will need to use sector_div().

Yep, looks we need use sector_div. And this isn't the only problem. discard
request can be merged, and the merge check only checks max_discard_sectors.
That means the split requests in blkdev_issue_discard can be merged again. The
split nerver works.

I'm wondering what's purpose of discard_alignment and discard_granularity. Are
there devices with discard_granularity not 1 sector? If bio isn't discard
aligned, what device will do? Further, why driver handles alignment/granularity
if device will ignore misaligned request. Jens, can you share some hints please?

Thanks,
Shaohua
