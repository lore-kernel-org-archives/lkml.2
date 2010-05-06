Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325Ab0EFVOF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 17:14:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48446 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab0EFVOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 17:14:01 -0400
Date: Thu, 6 May 2010 17:14:01 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Josef Bacik <josef@redhat.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/3] Btrfs: add basic DIO read support
Message-ID: <20100506211400.GE2997@infradead.org>
References: <20100506190101.GD13974@dhcp231-156.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100506190101.GD13974@dhcp231-156.rdu.redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +struct btrfs_dio_private {
> +	struct inode *inode;
> +	u64 logical_offset;
> +	u32 *csums;
> +	void *private;
> +};
> +
> +static void btrfs_endio_direct(struct bio *bio, int err)
> +{
> +	struct bio_vec *bvec_end = bio->bi_io_vec + bio->bi_vcnt - 1;
> +	struct bio_vec *bvec = bio->bi_io_vec;
> +	struct btrfs_dio_private *dip = bio->bi_private;
> +	struct inode *inode = dip->inode;
> +	struct btrfs_root *root = BTRFS_I(inode)->root;
> +	u64 start;
> +	u32 *private = dip->csums;
> +
> +	start = dip->logical_offset;
> +	do {
> +		if (!(BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)) {
> +			struct page *page = bvec->bv_page;
> +			char *kaddr;
> +			u32 csum = ~(u32)0;
> +
> +			kaddr = kmap_atomic(page, KM_USER0);

KM_USER0 seems wrong given that the bio completion callback can and
usually will be called from some kind of IRQ context.

> +	ret = blockdev_direct_IO_own_submit(rw, iocb, inode, NULL, iov,
> +					    offset, nr_segs,
> +					    btrfs_get_blocks_direct,
> +					    btrfs_submit_direct);

Don't you need to do some alignment checks of your own given that you
don't pass in a block device?

Btw, passing in the bdev here is a really horrible API, I'd much rather
move this to the callers..

