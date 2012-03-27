Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab2C0JGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 05:06:55 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:47410
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753799Ab2C0JGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 05:06:52 -0400
Date: Tue, 27 Mar 2012 05:06:52 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/2] block: split discard into aligned requests
Message-ID: <20120327090652.GB17685@infradead.org>
References: <1331745148-24885-1-git-send-email-pbonzini@redhat.com>
 <1331745148-24885-3-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331745148-24885-3-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 06:12:28PM +0100, Paolo Bonzini wrote:
> When a disk has a relatively large discard_granularity or small
> max_discard_sectors, discards are not split with optimal alignment.
> In the limit case of discard_granularity == max_discard_sectors, all
> requests might be aligned incorrectly, so in fact you might end up
> with no discarded logical blocks at all.
> 
> One example that helps showing how the patch works is with
> discard_granularity == 64, max_discard_sectors == 128.  A request that is
> submitted for 256 sectors 2..257 will be split in two: 2..129, 130..257.
> However, only 2 aligned blocks out of 3 are included in the request;
> 128..191 may be left intact and not discarded.  With this patch, the
> first request will be truncated to ensure good alignment of what's left,
> and the split will be 2..127, 128..255, 256..257.  discard_alignment is
> also taken into account.
> 
> At most one extra request will be introduced, because the first request
> will be reduced by at most granularity-1 sectors, and granularity
> must be less than max_discard_sectors.  Subsequent requests will run
> on round_down(max_discard_sectors, granularity) sectors, as in the
> current code.
> 
> Cc: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  block/blk-lib.c |   32 ++++++++++++++++++++++----------
>  1 files changed, 22 insertions(+), 10 deletions(-)
> 
> diff --git a/block/blk-lib.c b/block/blk-lib.c
> index d4bb160..837ce96 100644
> --- a/block/blk-lib.c
> +++ b/block/blk-lib.c
> @@ -44,7 +44,7 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
>  	struct request_queue *q = bdev_get_queue(bdev);
>  	int type = REQ_WRITE | REQ_DISCARD;
>  	unsigned int max_discard_sectors;
> -	unsigned int granularity;
> +	unsigned int granularity, alignment, mask;
>  	struct bio_batch bb;
>  	struct bio *bio;
>  	int ret = 0;
> @@ -57,10 +57,12 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
>  
>  	/* Zero-sector (unknown) and one-sector granularities are the same.  */
>  	granularity = max(q->limits.discard_granularity >> 9, 1U);
> +	mask = granularity - 1;

Given that ~ (aligment -1 is a common pattern I thin kthe code would be
better readable without the mask variable.

> +		 * If splitting a request, and the next starting sector would be
> +		 * misaligned, stop the discard at the previous aligned sector.
> +		 */
> +		end_sect = sector + req_sects;
> +		if (req_sects < nr_sects && (end_sect & mask) != alignment) {
> +			end_sect = round_down(end_sect - alignment, granularity) + alignment;

Please avoid overlong lines.

Otherwise the changes look good to me,


Reviewed-by: Christoph Hellwig <hch@lst.de>
