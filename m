Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034Ab2EVWoJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 18:44:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37576 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360Ab2EVWoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 18:44:07 -0400
Date: Tue, 22 May 2012 15:44:02 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, agk@redhat.com
Subject: Re: [Bcache v13 14/16] bcache: Request, io and allocation code
Message-ID: <20120522224402.GN14339@google.com>
References: <cover.1336619038.git.koverstreet@google.com>
 <9ea33658f2a71b3b9bd2ec10bee959bef146f23c.1336619038.git.koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ea33658f2a71b3b9bd2ec10bee959bef146f23c.1336619038.git.koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 11:11:25PM -0400, Kent Overstreet wrote:
> +int submit_bbio_split(struct bio *bio, struct cache_set *c,
> +		      struct bkey *k, unsigned ptr)
> +{
> +	struct closure *cl = bio->bi_private;
> +	struct bbio *b;
> +	struct bio *n;
> +	unsigned sectors_done = 0;
> +
> +	closure_get(cl);
> +
> +	bio->bi_sector	= PTR_OFFSET(k, ptr);
> +	bio->bi_bdev	= PTR_CACHE(c, k, ptr)->bdev;
> +
> +	do {
> +		n = bio_split_get(bio, bio_max_sectors(bio), c);
> +		if (!n) {
> +			closure_put(cl);
> +			return -ENOMEM;
> +		}
> +
> +		b = container_of(n, struct bbio, bio);
> +
> +		bkey_copy_single_ptr(&b->key, k, ptr);
> +		SET_KEY_SIZE(&b->key, KEY_SIZE(k) - sectors_done);
> +		SET_PTR_OFFSET(&b->key, 0, PTR_OFFSET(k, ptr) + sectors_done);
> +
> +		b->submit_time_us = local_clock_us();
> +		generic_make_request(n);
> +	} while (n != bio);
> +
> +	return 0;
> +}

Where is @sectors_done updated?

Thanks.

-- 
tejun
