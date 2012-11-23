Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900Ab2KWITl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 03:19:41 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:36390
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754013Ab2KWITk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 03:19:40 -0500
Date: Fri, 23 Nov 2012 03:19:39 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>
Subject: Re: [PATCH v4 09/31] dio: create a dio_aligned() helper function
Message-ID: <20121123081938.GB10731@infradead.org>
References: <1353537671-26284-1-git-send-email-dave.kleikamp@oracle.com>
 <1353537671-26284-10-git-send-email-dave.kleikamp@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353537671-26284-10-git-send-email-dave.kleikamp@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 04:40:49PM -0600, Dave Kleikamp wrote:
> From: Zach Brown <zab@zabbo.net>
> 
> __blockdev_direct_IO() had two instances of the same code to determine
> if a given offset wasn't aligned first to the inode's blkbits and then
> to the underlying device's blkbits.   This was confusing enough but
> we're about to add code that performs the same check on offsets in bvec
> arrays.  Rather than add yet more copies of this code let's have
> everyone call a helper.
> 
> Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
> Cc: Zach Brown <zab@zabbo.net>
> ---
>  fs/direct-io.c | 59 ++++++++++++++++++++++++++++++++++++----------------------
>  1 file changed, 37 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/direct-io.c b/fs/direct-io.c
> index f86c720..035c0a3 100644
> --- a/fs/direct-io.c
> +++ b/fs/direct-io.c
> @@ -1020,6 +1020,39 @@ static inline int drop_refcount(struct dio *dio)
>  }
>  
>  /*
> + * Returns true if the given offset is aligned to either the IO size
> + * specified by the given blkbits or by the logical block size of the
> + * given block device.
> + *
> + * If the given offset isn't aligned to the blkbits arguments as this is
> + * called then blkbits is set to the block size of the specified block
> + * device.  The call can then return either true or false.
> + *
> + * This bizarre calling convention matches the code paths that
> + * duplicated the functionality that this helper was built from.  We
> + * reproduce the behaviour to avoid introducing subtle bugs.
> + */
> +static int dio_aligned(unsigned long offset, unsigned *blkbits,
> +		       struct block_device *bdev)
> +{
> +	unsigned mask = (1 << *blkbits) - 1;
> +
> +	/*
> +	 * Avoid references to bdev if not absolutely needed to give
> +	 * the early prefetch in the caller enough time.
> +	 */
> +
> +	if (offset & mask) {
> +		if (bdev)
> +			*blkbits = blksize_bits(bdev_logical_block_size(bdev));

I don't like having the blkbits assignment hidden in the helper,
shouldn't we have a:

	if (bdev)
		blkbits = blksize_bits(bdev_logical_block_size(bdev));
	else
		blkbits = inode->i_blkbits;

in the caller instead?

