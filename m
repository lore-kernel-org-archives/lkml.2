Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265Ab0FNM3i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 08:29:38 -0400
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:52624 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752146Ab0FNM3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 08:29:36 -0400
Date: Mon, 14 Jun 2010 22:29:12 +1000
From: Dave Chinner <david@fromorbit.com>
To: Tao Ma <tao.ma@oracle.com>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org, sandeen@sandeen.net,
       Alex Elder <aelder@sgi.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] xfs: Make fiemap works with sparse file.
Message-ID: <20100614122912.GD6590@dastard>
References: <1276308495-14267-1-git-send-email-tao.ma@oracle.com>
 <20100614002705.GA6590@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100614002705.GA6590@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 10:27:06AM +1000, Dave Chinner wrote:
> On Sat, Jun 12, 2010 at 10:08:15AM +0800, Tao Ma wrote:
> > The reason is that in xfs_getbmap we will
> > calculate holes and set it in 'out', while out is malloced by
> > bmv_count(fi_extent_max+1) which didn't consider holes. So in the
> > worst case, if 'out' vector looks like
> > [hole, extent, hole, extent, hole, ... hole, extent, hole],
> > we will only return half of fi_extent_max extents.
> 
> Right, it's not broken, we simply return less than fi_extent_mex
> extents when there are holes. I don't see that as a problem as
> applications have to handle that case anyway, and....
> 
> > So in xfs_vn_fiemap, we should consider this worst case. If the
> > user wants fi_extent_max extents, we need a 'out' with size of
> > 2 *fi_extent_max + 2(one more the header).
> 
> That's rather dangerous, I think. It relies on other code to catch
> the buffer overrun that this sets up for fragmented, non-sparse
> files. Personally I'd much prefer to return fewer extents for sparse
> files than to add a landmine like this into the kernel code....

I just had a thought - if you want to avoid holes being reported to
fiemap, then add a BMV_IF_NO_HOLES flag to xfs_getbmap() and skip
holes in the mappin gloop when this flag is set. That will make
fiemap fill in the full number of extents without hacking the
extent count...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
