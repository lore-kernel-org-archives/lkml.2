Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758991Ab2AFTWM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 14:22:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43170 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756423Ab2AFTWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 14:22:09 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Dave Young <dyoung@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] loop: zero fill bio instead of return -EIO for partial read
References: <20120106033555.GA27916@darkstar.nay.redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 06 Jan 2012 14:22:04 -0500
In-Reply-To: <20120106033555.GA27916@darkstar.nay.redhat.com> (Dave Young's
	message of "Fri, 6 Jan 2012 11:35:55 +0800")
Message-ID: <x49hb08prfn.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Young <dyoung@redhat.com> writes:

> commit 8268f5a7415d914fc855a86aa2284ac819dc6b2e trying to fix the loop device
> partial read information leak problem. But it changed the semantics of read
> behavior. When we read beyond the end of the device we should get 0 bytes,
> which is normal behavior, we should not just return -EIO
>
> Instead of return -EIO, zero out the bio to avoid information leak in case of
> partail read. 

I tested the patch with a program which patterns the loop device,
truncates the backing file, and then performs preads from various
offsets within the loop device, validates the return values and inspects
the contents.  With this patch, everything works as expected.

By the way, truncating the backing file for a loop device is insane.
Why would you do that?  Also, if you really want all of the data gone,
you'll have to flush the contents of the buffer cache for the loop
device first.  It's quite the head scratcher the first time you truncate
a file, wait a few seconds, and then witness the file size grow.  ;-)

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

>
> Signed-off-by: Dave Young <dyoung@redhat.com>
> ---
>  drivers/block/loop.c |   24 +++++++++++++-----------
>  1 file changed, 13 insertions(+), 11 deletions(-)
>
> --- linux-2.6.orig/drivers/block/loop.c	2012-01-06 11:19:48.000000000 +0800
> +++ linux-2.6/drivers/block/loop.c	2012-01-06 11:20:18.842630580 +0800
> @@ -357,14 +357,14 @@ lo_direct_splice_actor(struct pipe_inode
>  	return __splice_from_pipe(pipe, sd, lo_splice_actor);
>  }
>  
> -static int
> +static ssize_t
>  do_lo_receive(struct loop_device *lo,
>  	      struct bio_vec *bvec, int bsize, loff_t pos)
>  {
>  	struct lo_read_data cookie;
>  	struct splice_desc sd;
>  	struct file *file;
> -	long retval;
> +	ssize_t retval;
>  
>  	cookie.lo = lo;
>  	cookie.page = bvec->bv_page;
> @@ -380,26 +380,28 @@ do_lo_receive(struct loop_device *lo,
>  	file = lo->lo_backing_file;
>  	retval = splice_direct_to_actor(file, &sd, lo_direct_splice_actor);
>  
> -	if (retval < 0)
> -		return retval;
> -	if (retval != bvec->bv_len)
> -		return -EIO;
> -	return 0;
> +	return retval;
>  }
>  
>  static int
>  lo_receive(struct loop_device *lo, struct bio *bio, int bsize, loff_t pos)
>  {
>  	struct bio_vec *bvec;
> -	int i, ret = 0;
> +	ssize_t s;
> +	int i;
>  
>  	bio_for_each_segment(bvec, bio, i) {
> -		ret = do_lo_receive(lo, bvec, bsize, pos);
> -		if (ret < 0)
> +		s = do_lo_receive(lo, bvec, bsize, pos);
> +		if (s < 0)
> +			return s;
> +
> +		if (s != bvec->bv_len) {
> +			zero_fill_bio(bio);
>  			break;
> +		}
>  		pos += bvec->bv_len;
>  	}
> -	return ret;
> +	return 0;
>  }
>  
>  static int do_bio_filebacked(struct loop_device *lo, struct bio *bio)
