Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab0JGWFD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 18:05:03 -0400
Received: from phunq.net ([64.81.85.152]:56520 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751514Ab0JGWFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 18:05:01 -0400
X-Greylist: delayed 1915 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Oct 2010 18:05:00 EDT
From: Daniel Phillips <phillips@phunq.net>
To: Cong Meng <mcpacino@gmail.com>
Subject: Re: introduce dm-snap-mv
Date: Thu, 7 Oct 2010 14:31:14 -0700
User-Agent: KMail/1.9.9
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>, Nick Piggin <npiggin@kernel.dk>
References: <20101006083150.GA15758@zhongling>
In-Reply-To: <20101006083150.GA15758@zhongling>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201010071431.14937.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Meng,

The patch looks sensible, however the question is: why do you want to
do this?  Would it not be better to generalize your metadata format to
accomodate the device's native blocksize?

Regards,

Daniel

> a kernel patch
> --------------
> Now, dm-snap-mv highly depends on a kernel patch below, which make __getblk()
> can get a 4K buffer head while block size of the disk is NOT 4K.
> 
> Signed-off-by: Cong Meng <mcpacino@gmail.com>
> ---
>  fs/buffer.c |    7 ++-----
>  1 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 3e7dca2..f7f9d33 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1051,10 +1051,7 @@ grow_buffers(struct block_device *bdev, sector_t block, int size)
>  	pgoff_t index;
>  	int sizebits;
>  
> -	sizebits = -1;
> -	do {
> -		sizebits++;
> -	} while ((size << sizebits) < PAGE_SIZE);
> +	sizebits = PAGE_CACHE_SHIFT - bdev->bd_inode->i_blkbits;
>  
>  	index = block >> sizebits;
>  
> @@ -2924,7 +2921,7 @@ int submit_bh(int rw, struct buffer_head * bh)
>  	 */
>  	bio = bio_alloc(GFP_NOIO, 1);
>  
> -	bio->bi_sector = bh->b_blocknr * (bh->b_size >> 9);
> +	bio->bi_sector = bh->b_blocknr << (bh->b_bdev->bd_inode->i_blkbits - 9);
>  	bio->bi_bdev = bh->b_bdev;
>  	bio->bi_io_vec[0].bv_page = bh->b_page;
>  	bio->bi_io_vec[0].bv_len = bh->b_size;
