Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab2A3Ov4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 09:51:56 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38283 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082Ab2A3Ovy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 09:51:54 -0500
Message-ID: <1327935109.2297.1.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: Bad SSD performance with recent kernels
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Wu Fengguang <wfg@linux.intel.com>
Cc: Shaohua Li <shaohua.li@intel.com>, Herbert Poetzl <herbert@13thfloor.at>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>
Date: Mon, 30 Jan 2012 15:51:49 +0100
In-Reply-To: <20120130142837.GA21750@localhost>
References: <1327831380.14602.6.camel@edumazet-laptop>
	 <20120129111645.GA5839@localhost> <1327842831.2718.2.camel@edumazet-laptop>
	 <20120129161058.GA13156@localhost>
	 <CANejiEW86b7btiOcVFF3qVhqU1t6FRosvgfiydWwU5zgeDFOqw@mail.gmail.com>
	 <20120130071346.GM29272@MAIL.13thfloor.at>
	 <1327908158.21268.3.camel@sli10-conroe>
	 <20120130073621.GN29272@MAIL.13thfloor.at>
	 <1327911142.21268.7.camel@sli10-conroe>
	 <CANejiEXwt7zdWRD0gTg1JXNPZ52vU1Z4cQsb3xztqDLccyTPSQ@mail.gmail.com>
	 <20120130142837.GA21750@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 30 janvier 2012 à 22:28 +0800, Wu Fengguang a écrit :
> On Mon, Jan 30, 2012 at 06:31:34PM +0800, Li, Shaohua wrote:
> 
> > Looks the 2.6.39 block plug introduces some latency here. deleting
> > blk_start_plug/blk_finish_plug in generic_file_aio_read seems
> > workaround
> > the issue. The plug seems not good for sequential IO, because readahead
> > code already has plug and has fine grained control.
> 
> Why not remove the generic_file_aio_read() plug completely? It
> actually prevents unplugging immediately after the readahead IO is
> submitted and in turn stalls the IO pipeline as showed by Eric's
> blktrace data.
> 
> Eric, will you test this patch? Thank you.
> 
> --- linux.orig/mm/filemap.c	2012-01-30 22:27:11.000000000 +0800
> +++ linux/mm/filemap.c	2012-01-30 22:27:25.000000000 +0800
> @@ -1414,15 +1414,12 @@ generic_file_aio_read(struct kiocb *iocb
>  	unsigned long seg = 0;
>  	size_t count;
>  	loff_t *ppos = &iocb->ki_pos;
> -	struct blk_plug plug;
>  
>  	count = 0;
>  	retval = generic_segment_checks(iov, &nr_segs, &count, VERIFY_WRITE);
>  	if (retval)
>  		return retval;
>  
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


Excellent results

# echo 3 >/proc/sys/vm/drop_caches ;dd if=/dev/sdb of=/dev/null bs=2M count=2048
2048+0 enregistrements lus
2048+0 enregistrements écrits
4294967296 octets (4,3 GB) copiés, 16,2309 s, 265 MB/s

# echo 3 >/proc/sys/vm/drop_caches ;dd if=/dev/sdb of=/dev/null bs=128k count=32768
32768+0 enregistrements lus
32768+0 enregistrements écrits
4294967296 octets (4,3 GB) copiés, 16,3153 s, 263 MB/s

# hdparm -t /dev/sdb

/dev/sdb:
 Timing buffered disk reads: 752 MB in  3.00 seconds = 250.62 MB/sec


