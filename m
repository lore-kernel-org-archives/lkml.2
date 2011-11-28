Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab1K1OQQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 09:16:16 -0500
Received: from mga03.intel.com ([143.182.124.21]:63829 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753933Ab1K1OQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 09:16:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,584,1315206000"; 
   d="scan'208";a="79789904"
Date: Mon, 28 Nov 2011 22:16:07 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7] btrfs: fix dirtied pages accounting on sub-page
 writes
Message-ID: <20111128141607.GA32356@localhost>
References: <20111128135338.249672012@intel.com>
 <20111128140513.528601145@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111128140513.528601145@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

This btrfs patch depends on the account_page_redirty() introduced
earlier in this series.

Shall I carry it together with this patchset?

Thanks,
Fengguang

On Mon, Nov 28, 2011 at 09:53:43PM +0800, Wu, Fengguang wrote:
> When doing 1KB sequential writes to the same page,
> balance_dirty_pages_ratelimited_nr() should be called once instead of 4
> times, the latter makes the dirtier tasks be throttled much too heavy.
> 
> Fix it with proper de-accounting on clear_page_dirty_for_io().
> 
> CC: Chris Mason <chris.mason@oracle.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  fs/btrfs/file.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> --- linux-next.orig/fs/btrfs/file.c	2011-11-17 20:13:47.000000000 +0800
> +++ linux-next/fs/btrfs/file.c	2011-11-17 20:18:51.000000000 +0800
> @@ -1136,7 +1136,8 @@ again:
>  				     GFP_NOFS);
>  	}
>  	for (i = 0; i < num_pages; i++) {
> -		clear_page_dirty_for_io(pages[i]);
> +		if (clear_page_dirty_for_io(pages[i]))
> +			account_page_redirty(pages[i]);
>  		set_page_extent_mapped(pages[i]);
>  		WARN_ON(!PageLocked(pages[i]));
>  	}
> 
