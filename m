Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865Ab2LDCwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 21:52:25 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:30615 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751497Ab2LDCwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 21:52:24 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiQKAEhkvVB5LPYI/2dsb2JhbABEhUOyW4YXF3OCHgEBBAEnExwjEAgDFQMuFCUDIROICgWuX5A3FIwsIYM/YQOWAJBIgwaBUA
Date: Tue, 4 Dec 2012 13:52:21 +1100
From: Dave Chinner <david@fromorbit.com>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>
Subject: Re: [PATCH v4 16/31] loop: use aio to perform io on the underlying
 file
Message-ID: <20121204025221.GF32450@dastard>
References: <1353537671-26284-1-git-send-email-dave.kleikamp@oracle.com>
 <1353537671-26284-17-git-send-email-dave.kleikamp@oracle.com>
 <20121122230628.GV2591@dastard>
 <50BCDA7B.7080000@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50BCDA7B.7080000@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2012 at 10:59:39AM -0600, Dave Kleikamp wrote:
> On 11/22/2012 05:06 PM, Dave Chinner wrote:
> > On Wed, Nov 21, 2012 at 04:40:56PM -0600, Dave Kleikamp wrote:
> >> From: Zach Brown <zab@zabbo.net>
> >>
> >> This uses the new kernel aio interface to process loopback IO by
> >> submitting concurrent direct aio.  Previously loop's IO was serialized
> >> by synchronous processing in a thread.
> >>
> >> The aio operations specify the memory for the IO with the bio_vec arrays
> >> directly instead of mappings of the pages.
> >>
> >> The use of aio operations is enabled when the backing file supports the
> >> read_iter and write_iter methods.  These methods must only be added when
> >> O_DIRECT on bio_vecs is supported.
> >>
> >> Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
> >> Cc: Zach Brown <zab@zabbo.net>
> > 
> > I suspect aio iocompetion here doesn't work for FUA write IO.
> 
> Since the underlying file system is doing direct IO, we at least know
> that the IO has been performed to the underlying device. It could still
> be in the devices write cache, so maybe an fsync is still needed. It
> wouldn't be hard to fix if that's the right thing to do.

FUA means the write is all the way to stable storage when completion
is signalled by the underlying device. That means the loop device
needs to (at least) fdatasync after the write completes...

> >> +static void lo_rw_aio_complete(u64 data, long res)
> >> +{
> >> +	struct bio *bio = (struct bio *)(uintptr_t)data;
> >> +
> >> +	if (res > 0)
> >> +		res = 0;
> >> +	else if (res < 0)
> >> +		res = -EIO;
> >> +
> >> +	bio_endio(bio, res);
> >> +}
> > 
> > This effectively does nothing...
> 
> It passes the IO completion from the underlying device to the caller.

Yes, I know. What I'm saying is that it does nothing on completion
of a FUA write when it should be doing a fsync.....

> >> -			    lo->lo_encrypt_key_size) {
> >> -				ret = -EOPNOTSUPP;
> >> -				goto out;
> >> -			}
> >> -			ret = file->f_op->fallocate(file, mode, pos,
> >> -						    bio->bi_size);
> >> -			if (unlikely(ret && ret != -EINVAL &&
> >> -				     ret != -EOPNOTSUPP))
> >> -				ret = -EIO;
> >> -			goto out;
> >> -		}
> >> -
> >>  		ret = lo_send(lo, bio, pos);
> >>  
> >>  		if ((bio->bi_rw & REQ_FUA) && !ret) {
> > 
> > And as you can see here that after writing the data in the filebacked
> > path, there's special handling for REQ_FUA (i.e. another fsync).
> > ....
> 
> In this path, the data may still be in the underlying filesystem's page
> cache.

Sure, but fsync means that it ends up on stable storage, as per the
requirement of an FUA write. Direct IO does not mean the data is on
stable storage, just that it bypasses the page cache.

> > And this extra fsync is now not done in the aio path. I.e. the AIO
> > completion path needs to issue the fsync to maintain correct REQ_FUA
> > semantics...
> 
> If this is really necessary, I can fix it.

Absolutely. If we don't implement FUA properly, we'll end up with
corrupted filesystems and/or data loss when kernel crashes or
powerloss occurs. That's not an acceptable outcome, so we need FUA
to be implemented properly.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
