Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab2ITV6d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 17:58:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65105 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293Ab2ITV6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 17:58:32 -0400
Date: Thu, 20 Sep 2012 14:58:27 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, neilb@suse.de
Subject: Re: [PATCH v2 02/26] block: Add bio_advance()
Message-ID: <20120920215827.GF7264@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-3-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347322957-25260-3-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 05:22:13PM -0700, Kent Overstreet wrote:
> +/**
> + * bio_advance - increment/complete a bio by some number of bytes
> + * @bio:	bio to advance
> + * @bytes:	number of bytes to complete
> + *
> + * This updates bi_sector, bi_size and bi_idx; if the number of bytes to
> + * complete doesn't align with a bvec boundary, then bv_len and bv_offset will
> + * be updated on the last bvec as well.
> + *
> + * @bio will then represent the remaining, uncompleted portion of the io.
> + */
> +void bio_advance(struct bio *bio, unsigned bytes)
> +{
> +	if (bio_integrity(bio))
> +		bio_integrity_advance(bio, bytes);
> +
> +	bio->bi_sector += bytes >> 0;

Hmmm.... bytes >> 0?

> +	bio->bi_size -= bytes;
> +
> +	if (!bio->bi_size)
> +		return;
> +
> +	while (bytes) {
> +		if (unlikely(bio->bi_idx >= bio->bi_vcnt)) {
> +			printk(KERN_ERR "%s: bio idx %d >= vcnt %d\n",

pr_err() is preferred but maybe WARN_ON_ONCE() is better fit here?
This happening would be a bug, right?

Thanks.

-- 
tejun
