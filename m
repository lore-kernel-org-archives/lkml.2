Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab2AaGgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 01:36:31 -0500
Received: from MAIL.13thfloor.at ([213.145.232.33]:56841 "EHLO
	MAIL.13thfloor.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab2AaGga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 01:36:30 -0500
Date: Tue, 31 Jan 2012 07:36:28 +0100
From: Herbert Poetzl <herbert@13thfloor.at>
To: Wu Fengguang <wfg@linux.intel.com>
Cc: Shaohua Li <shaohua.li@intel.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>
Subject: Re: Bad SSD performance with recent kernels
Message-ID: <20120131063628.GR29272@MAIL.13thfloor.at>
Mail-Followup-To: Wu Fengguang <wfg@linux.intel.com>,
	Shaohua Li <shaohua.li@intel.com>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <tj@kernel.org>
References: <20120129111645.GA5839@localhost> <1327842831.2718.2.camel@edumazet-laptop> <20120129161058.GA13156@localhost> <CANejiEW86b7btiOcVFF3qVhqU1t6FRosvgfiydWwU5zgeDFOqw@mail.gmail.com> <20120130071346.GM29272@MAIL.13thfloor.at> <1327908158.21268.3.camel@sli10-conroe> <20120130073621.GN29272@MAIL.13thfloor.at> <1327911142.21268.7.camel@sli10-conroe> <CANejiEXwt7zdWRD0gTg1JXNPZ52vU1Z4cQsb3xztqDLccyTPSQ@mail.gmail.com> <20120130142837.GA21750@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120130142837.GA21750@localhost>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 10:28:37PM +0800, Wu Fengguang wrote:
> On Mon, Jan 30, 2012 at 06:31:34PM +0800, Li, Shaohua wrote:

>> Looks the 2.6.39 block plug introduces some latency here. deleting
>> blk_start_plug/blk_finish_plug in generic_file_aio_read seems
>> workaround
>> the issue. The plug seems not good for sequential IO, because readahead
>> code already has plug and has fine grained control.

> Why not remove the generic_file_aio_read() plug completely? It
> actually prevents unplugging immediately after the readahead IO is
> submitted and in turn stalls the IO pipeline as showed by Eric's
> blktrace data.

> Eric, will you test this patch? Thank you.

> --- linux.orig/mm/filemap.c	2012-01-30 22:27:11.000000000 +0800
> +++ linux/mm/filemap.c	2012-01-30 22:27:25.000000000 +0800
> @@ -1414,15 +1414,12 @@ generic_file_aio_read(struct kiocb *iocb
>  	unsigned long seg = 0;
>  	size_t count;
>  	loff_t *ppos = &iocb->ki_pos;
> -	struct blk_plug plug;

>  	count = 0;
>  	retval = generic_segment_checks(iov, &nr_segs, &count, VERIFY_WRITE);
>  	if (retval)
>  		return retval;

> -	blk_start_plug(&plug);
> -
>  	/* coalesce the iovecs and go direct-to-BIO for O_DIRECT */
>  	if (filp->f_flags & O_DIRECT) {
>  		loff_t size;
> @@ -1495,7 +1492,6 @@ generic_file_aio_read(struct kiocb *iocb
>  			break;
>  	}
>  out:
> -	blk_finish_plug(&plug);
>  	return retval;
>  }
>  EXPORT_SYMBOL(generic_file_aio_read);

I can confirm, this seems to fix the issue here as well:

kernel    ------------ read /dev/sda -------------
          --- noop ---  - deadline -  ---- cfs ---
          [MB/s]  %CPU  [MB/s]  %CPU  [MB/s]  %CPU
--------------------------------------------------
3.2.2      45.82   3.7   44.85   3.6   45.04   3.4
3.2.2i     45.59   2.3   51.78   2.6   46.03   2.2
3.2.2i128 250.24  20.9  252.68  21.3  250.00  21.6
3.2.2p    250.88  20.8  249.69  20.7  252.34  21.4
3.2.2p128 249.36  20.7  251.47  20.9  249.03  21.2

3.2.2 ... unmodified 3.2.2 kernel 1M
3.2.2i .. unmodified 3.2.2 kernel with idle=poll, 1M
3.2.2i128 unmodified 3.2.2 kernel with idle=poll, 128k 
3.2.2p .. unmodified 3.2.2 kernel with patch, 1M
3.2.2p128 unmodified 3.2.2 kernel with patch, 128k

thanks again,
Herbert

