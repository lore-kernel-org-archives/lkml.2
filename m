Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab0GLVxr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 17:53:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59316 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754489Ab0GLVxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 17:53:45 -0400
Date: Mon, 12 Jul 2010 14:52:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Richard Kennedy <richard@rsk.demon.co.uk>,
        Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        <linux-fsdevel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 1/6] writeback: take account of NR_WRITEBACK_TEMP in
 balance_dirty_pages()
Message-Id: <20100712145206.9808b411.akpm@linux-foundation.org>
In-Reply-To: <20100711021748.594522648@intel.com>
References: <20100711020656.340075560@intel.com>
	<20100711021748.594522648@intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Jul 2010 10:06:57 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> 
> Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  mm/page-writeback.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> --- linux-next.orig/mm/page-writeback.c	2010-07-11 08:41:37.000000000 +0800
> +++ linux-next/mm/page-writeback.c	2010-07-11 08:42:14.000000000 +0800
> @@ -503,11 +503,12 @@ static void balance_dirty_pages(struct a
>  		};
>  
>  		get_dirty_limits(&background_thresh, &dirty_thresh,
> -				&bdi_thresh, bdi);
> +				 &bdi_thresh, bdi);
>  
>  		nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
> -					global_page_state(NR_UNSTABLE_NFS);
> -		nr_writeback = global_page_state(NR_WRITEBACK);
> +				 global_page_state(NR_UNSTABLE_NFS);
> +		nr_writeback = global_page_state(NR_WRITEBACK) +
> +			       global_page_state(NR_WRITEBACK_TEMP);
>  
>  		bdi_nr_reclaimable = bdi_stat(bdi, BDI_RECLAIMABLE);
>  		bdi_nr_writeback = bdi_stat(bdi, BDI_WRITEBACK);
> 

hm, OK.

I wonder whether we could/should have unified NR_WRITEBACK_TEMP and
NR_UNSTABLE_NFS.  Their "meanings" aren't quite the same, but perhaps
some "treat page as dirty because the fs is futzing with it" thing.
