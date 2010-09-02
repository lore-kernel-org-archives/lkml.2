Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab0IBOZH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 10:25:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36608 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab0IBOZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 10:25:05 -0400
Date: Thu, 2 Sep 2010 10:25:01 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Andrew Morton <akpm@linuxfoundation.org>, Josef Bacik <josef@redhat.com>,
        linux-kernel@vger.kernel.org, btrfs-devel <btrfs-devel@oss.oracle.com>
Subject: Re: [patch] O_DIRECT: fix the splitting up of contiguous I/O
Message-ID: <20100902142501.GA14932@infradead.org>
References: <x49vd7f368c.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49vd7f368c.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, can you please send this on to Linus and -stable ASAP?  It's
causing massive problems for our users.

On Thu, Aug 12, 2010 at 04:50:59PM -0400, Jeff Moyer wrote:
> Hi,
> 
> commit c2c6ca4 (direct-io: do not merge logically non-contiguous
> requests) introduced a bug whereby all O_DIRECT I/Os were submitted a
> page at a time to the block layer.  The problem is that the code
> expected dio->block_in_file to correspond to the current page in the
> dio.  In fact, it corresponds to the previous page submitted via
> submit_page_section.  This was purely an oversight, as the
> dio->cur_page_fs_offset field was introduced for just this purpose.
> This patch simply uses the correct variable when calculating whether
> there is a mismatch between contiguous logical blocks and contiguous
> physical blocks (as described in the comments).
> 
> I also switched the if conditional following this check to an else if,
> to ensure that we never call dio_bio_submit twice for the same dio (in
> theory, this should not happen, anyway).
> 
> I've tested this by running blktrace and verifying that a 64KB I/O was
> submitted as a single I/O.  I also ran the patched kernel through
> xfstests' aio tests using xfs, ext4 (with 1k and 4k block sizes) and
> btrfs and verified that there were no regressions as compared to an
> unpatched kernel.
> 
> Comments, as always, are welcome.
> 
> Cheers,
> Jeff
> 
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
> Acked-by: Josef Bacik <jbacik@redhat.com>
> 
> diff --git a/fs/direct-io.c b/fs/direct-io.c
> index 7600aac..445901c 100644
> --- a/fs/direct-io.c
> +++ b/fs/direct-io.c
> @@ -632,7 +632,7 @@ static int dio_send_cur_page(struct dio *dio)
>  	int ret = 0;
>  
>  	if (dio->bio) {
> -		loff_t cur_offset = dio->block_in_file << dio->blkbits;
> +		loff_t cur_offset = dio->cur_page_fs_offset;
>  		loff_t bio_next_offset = dio->logical_offset_in_bio +
>  			dio->bio->bi_size;
>  
> @@ -657,7 +657,7 @@ static int dio_send_cur_page(struct dio *dio)
>  		 * Submit now if the underlying fs is about to perform a
>  		 * metadata read
>  		 */
> -		if (dio->boundary)
> +		else if (dio->boundary)
>  			dio_bio_submit(dio);
>  	}
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
---end quoted text---
