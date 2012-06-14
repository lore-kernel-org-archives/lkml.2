Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab2FNCPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 22:15:54 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:50706 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753167Ab2FNCPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 22:15:52 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ak0JABZI2U95LAcV/2dsb2JhbABFtAwEgTCBCIIYAQEFJxMcIxAIAxguFCUDIROICrpFFIscSYRoYAOVIIklhliCcg
Date: Thu, 14 Jun 2012 12:15:47 +1000
From: Dave Chinner <david@fromorbit.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>, xfs@oss.sgi.com
Subject: Re: [PATCH] mm: add gfp_mask parameter to vm_map_ram()
Message-ID: <20120614021547.GC7339@dastard>
References: <20120612012134.GA7706@localhost>
 <20120613123932.GA1445@localhost>
 <20120614012026.GL3019@devil.redhat.com>
 <20120614014902.GB7289@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120614014902.GB7289@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 09:49:02AM +0800, Fengguang Wu wrote:
> On Thu, Jun 14, 2012 at 11:20:26AM +1000, Dave Chinner wrote:
> > 
> > Bug in vm_map_ram - it does an unconditional GFP_KERNEL allocation
> > here, and we are in a GFP_NOFS context. We can't pass a gfp_mask to
> > vm_map_ram(), so until vm_map_ram() grows that we can't fix it...
> 
> This trivial patch should fix it.
> 
> The only behavior change is the XFS part:
> 
> @@ -406,7 +406,7 @@ _xfs_buf_map_pages(
>  
>                 do {
>                         bp->b_addr = vm_map_ram(bp->b_pages, bp->b_page_count,
> -                                               -1, PAGE_KERNEL);
> +                                               -1, GFP_NOFS, PAGE_KERNEL);

This function isn't always called in GFP_NOFS context - readahead
uses different memory allocation semantics (no retry, no warn), so
there are flags that tell it what to do. i.e.

-						-1, PAGE_KERNEL);
+						-1, xb_to_gfp(flags), PAGE_KERNEL);

Otherwise looks fine to me...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
