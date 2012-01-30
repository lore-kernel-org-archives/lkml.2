Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab2A3Oio (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 09:38:44 -0500
Received: from mga03.intel.com ([143.182.124.21]:23482 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495Ab2A3Oin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 09:38:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="101128170"
Date: Mon, 30 Jan 2012 22:28:37 +0800
From: Wu Fengguang <wfg@linux.intel.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>
Subject: Re: Bad SSD performance with recent kernels
Message-ID: <20120130142837.GA21750@localhost>
References: <1327831380.14602.6.camel@edumazet-laptop>
 <20120129111645.GA5839@localhost>
 <1327842831.2718.2.camel@edumazet-laptop>
 <20120129161058.GA13156@localhost>
 <CANejiEW86b7btiOcVFF3qVhqU1t6FRosvgfiydWwU5zgeDFOqw@mail.gmail.com>
 <20120130071346.GM29272@MAIL.13thfloor.at>
 <1327908158.21268.3.camel@sli10-conroe>
 <20120130073621.GN29272@MAIL.13thfloor.at>
 <1327911142.21268.7.camel@sli10-conroe>
 <CANejiEXwt7zdWRD0gTg1JXNPZ52vU1Z4cQsb3xztqDLccyTPSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANejiEXwt7zdWRD0gTg1JXNPZ52vU1Z4cQsb3xztqDLccyTPSQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 06:31:34PM +0800, Li, Shaohua wrote:

> Looks the 2.6.39 block plug introduces some latency here. deleting
> blk_start_plug/blk_finish_plug in generic_file_aio_read seems
> workaround
> the issue. The plug seems not good for sequential IO, because readahead
> code already has plug and has fine grained control.

Why not remove the generic_file_aio_read() plug completely? It
actually prevents unplugging immediately after the readahead IO is
submitted and in turn stalls the IO pipeline as showed by Eric's
blktrace data.

Eric, will you test this patch? Thank you.

--- linux.orig/mm/filemap.c	2012-01-30 22:27:11.000000000 +0800
+++ linux/mm/filemap.c	2012-01-30 22:27:25.000000000 +0800
@@ -1414,15 +1414,12 @@ generic_file_aio_read(struct kiocb *iocb
 	unsigned long seg = 0;
 	size_t count;
 	loff_t *ppos = &iocb->ki_pos;
-	struct blk_plug plug;
 
 	count = 0;
 	retval = generic_segment_checks(iov, &nr_segs, &count, VERIFY_WRITE);
 	if (retval)
 		return retval;
 
-	blk_start_plug(&plug);
-
 	/* coalesce the iovecs and go direct-to-BIO for O_DIRECT */
 	if (filp->f_flags & O_DIRECT) {
 		loff_t size;
@@ -1495,7 +1492,6 @@ generic_file_aio_read(struct kiocb *iocb
 			break;
 	}
 out:
-	blk_finish_plug(&plug);
 	return retval;
 }
 EXPORT_SYMBOL(generic_file_aio_read);
