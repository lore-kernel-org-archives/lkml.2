Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472Ab2JIXcb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 19:32:31 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:45641 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab2JIXc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 19:32:29 -0400
X-AuditID: 9c930197-b7b6dae000000e70-1c-5074b40a0090
Date: Wed, 10 Oct 2012 08:36:42 +0900
From: Minchan Kim <minchan@kernel.org>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg KH <greg@kroah.com>, Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Sam Hansen <solid.se7en@gmail.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [staging][zram] Fix handling of incompressible pages
Message-ID: <20121009233642.GI13817@bbox>
References: <1349746364-8051-1-git-send-email-ngupta@vflare.org>
 <20121009133128.GA3244@barrios>
 <5074605C.3000301@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5074605C.3000301@vflare.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 10:35:24AM -0700, Nitin Gupta wrote:
> Hi Minchan,
> 
> On 10/09/2012 06:31 AM, Minchan Kim wrote:
> >
> >On Mon, Oct 08, 2012 at 06:32:44PM -0700, Nitin Gupta wrote:
> >>Change 130f315a introduced a bug in the handling of incompressible
> >>pages which resulted in memory allocation failure for such pages.
> >>The fix is to store the page as-is i.e. without compression if the
> >>compressed size exceeds a threshold (max_zpage_size) and request
> >>exactly PAGE_SIZE sized buffer from zsmalloc.
> >
> >It seems you found a bug and already fixed it with below helpers.
> >But unfortunately, description isn't enough to understand the problem for me.
> >Could you explain in detail?
> >You said it results in memory allocation failure. What is failure?
> >You mean this code by needing a few pages for zspage to meet class size?
> >
> >         handle = zs_malloc(zram->mem_pool, clen);
> >         if (!handle) {
> >                 pr_info("Error allocating memory for compressed "
> >                         "page: %u, size=%zu\n", index, clen);
> >                 ret = -ENOMEM;
> >                 goto out;
> >         }
> >
> >So instead of allocating more pages for incompressible page to make zspage,
> >just allocate a page for PAGE_SIZE class without compression?
> >
> 
> When a page expands on compression, say from 4K to 4K+30, we were
> trying to do zsmalloc(pool, 4K+30). However, the maximum size which
> zsmalloc can allocate is PAGE_SIZE (for obvious reasons), so such
> allocation requests always return failure (0).

Right.
I think it would be better to add this explanation in description.

> 
> For a page that has compressed size larger than the original size
> (this may happen with already compressed or random data), there is
> no point storing the compressed version as that would take more
> space and would also require time for decompression when needed
> again. So, the fix is to store any page, whose compressed size
> exceeds a threshold (max_zpage_size), as-it-is i.e. without
> compression.  Memory required for storing this uncompressed page can

Yes. It's already definition of max_zpage_size.

> then be requested from zsmalloc which supports PAGE_SIZE sized
> allocations.

> 
> Lastly, the fix checks that we do not attempt to "decompress" the
> page which we stored in the uncompressed form -- we just memcpy()
> out such pages.
> 
> Thanks,
> Nitin
> 
> 
> >>
> >>Signed-off-by: Nitin Gupta <ngupta@vflare.org>
> >>Reported-by: viechweg@gmail.com
> >>Reported-by: paerley@gmail.com
> >>Reported-by: wu.tommy@gmail.com
> >>Tested-by: wu.tommy@gmail.com
> >>Tested-by: michael@zugelder.org
Anyway, 
Acked-by: Minchan Kim <minchan@kernel.org>

Thanks, Nitin!
-- 
Kind regards,
Minchan Kim
