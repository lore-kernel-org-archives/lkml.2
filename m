Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758831Ab2KVXGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 18:06:33 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:56603 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751970Ab2KVXGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 18:06:31 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsgIAH6vrlB5LKAf/2dsb2JhbABEhT22MoV5F3OCHgEBBScTHCMQCAMVAy4UJQMhCgmIDL9yFIwjhEEDlgCQQ4MD
Date: Fri, 23 Nov 2012 10:06:28 +1100
From: Dave Chinner <david@fromorbit.com>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>
Subject: Re: [PATCH v4 16/31] loop: use aio to perform io on the underlying
 file
Message-ID: <20121122230628.GV2591@dastard>
References: <1353537671-26284-1-git-send-email-dave.kleikamp@oracle.com>
 <1353537671-26284-17-git-send-email-dave.kleikamp@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353537671-26284-17-git-send-email-dave.kleikamp@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 04:40:56PM -0600, Dave Kleikamp wrote:
> From: Zach Brown <zab@zabbo.net>
> 
> This uses the new kernel aio interface to process loopback IO by
> submitting concurrent direct aio.  Previously loop's IO was serialized
> by synchronous processing in a thread.
> 
> The aio operations specify the memory for the IO with the bio_vec arrays
> directly instead of mappings of the pages.
> 
> The use of aio operations is enabled when the backing file supports the
> read_iter and write_iter methods.  These methods must only be added when
> O_DIRECT on bio_vecs is supported.
> 
> Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
> Cc: Zach Brown <zab@zabbo.net>

I suspect aio iocompetion here doesn't work for FUA write IO.

> +#ifdef CONFIG_AIO
> +static void lo_rw_aio_complete(u64 data, long res)
> +{
> +	struct bio *bio = (struct bio *)(uintptr_t)data;
> +
> +	if (res > 0)
> +		res = 0;
> +	else if (res < 0)
> +		res = -EIO;
> +
> +	bio_endio(bio, res);
> +}

This effectively does nothing...

> @@ -413,37 +456,6 @@ static int do_bio_filebacked(struct loop_device *lo, struct bio *bio)
>  	if (bio_rw(bio) == WRITE) {
>  		struct file *file = lo->lo_backing_file;
>  
> -		if (bio->bi_rw & REQ_FLUSH) {
> -			ret = vfs_fsync(file, 0);
> -			if (unlikely(ret && ret != -EINVAL)) {
> -				ret = -EIO;
> -				goto out;
> -			}
> -		}
> -
> -		/*
> -		 * We use punch hole to reclaim the free space used by the
> -		 * image a.k.a. discard. However we do not support discard if
> -		 * encryption is enabled, because it may give an attacker
> -		 * useful information.
> -		 */
> -		if (bio->bi_rw & REQ_DISCARD) {
> -			struct file *file = lo->lo_backing_file;
> -			int mode = FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE;
> -
> -			if ((!file->f_op->fallocate) ||
> -			    lo->lo_encrypt_key_size) {
> -				ret = -EOPNOTSUPP;
> -				goto out;
> -			}
> -			ret = file->f_op->fallocate(file, mode, pos,
> -						    bio->bi_size);
> -			if (unlikely(ret && ret != -EINVAL &&
> -				     ret != -EOPNOTSUPP))
> -				ret = -EIO;
> -			goto out;
> -		}
> -
>  		ret = lo_send(lo, bio, pos);
>  
>  		if ((bio->bi_rw & REQ_FUA) && !ret) {

And as you can see here that after writing the data in the filebacked
path, there's special handling for REQ_FUA (i.e. another fsync).
....

> @@ -512,7 +546,29 @@ static inline void loop_handle_bio(struct loop_device *lo, struct bio *bio)
>  		do_loop_switch(lo, bio->bi_private);
>  		bio_put(bio);
>  	} else {
> -		int ret = do_bio_filebacked(lo, bio);
> +		int ret;
> +
> +		if (bio_rw(bio) == WRITE) {
> +			if (bio->bi_rw & REQ_FLUSH) {
> +				ret = vfs_fsync(lo->lo_backing_file, 1);
> +				if (unlikely(ret && ret != -EINVAL))
> +					goto out;
> +			}
> +			if (bio->bi_rw & REQ_DISCARD) {
> +				ret = lo_discard(lo, bio);
> +				goto out;
> +			}
> +		}
> +#ifdef CONFIG_AIO
> +		if (lo->lo_flags & LO_FLAGS_USE_AIO &&
> +		    lo->transfer == transfer_none) {
> +			ret = lo_rw_aio(lo, bio);
> +			if (ret == 0)
> +				return;
> +		} else
> +#endif
> +			ret = do_bio_filebacked(lo, bio);
> +out:

And this extra fsync is now not done in the aio path. I.e. the AIO
completion path needs to issue the fsync to maintain correct REQ_FUA
semantics...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
