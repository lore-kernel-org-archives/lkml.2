Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759152Ab2DJPJP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 11:09:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53860 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755772Ab2DJPIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 11:08:42 -0400
Date: Sat, 7 Apr 2012 10:28:30 +0200
From: Jan Kara <jack@suse.cz>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Divyesh Shah <dpshah@google.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Subject: Re: question about blkio_get_stat()
Message-ID: <20120407082830.GB2584@quack.suse.cz>
References: <20120402135455.GA15588@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120402135455.GA15588@elgon.mountain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

On Mon 02-04-12 16:54:56, Dan Carpenter wrote:
> Smatch complains that we go outside the array in blkio_get_stat().
> 
> block/blk-cgroup.c
>    731          if (type == BLKIO_STAT_DEQUEUE)
>                     ^^^^^^^^^^^^^^^^^^^^^^^^^^
> BLKIO_STAT_DEQUEUE is 9.
> 
>    732                  return blkio_fill_stat(key_str, MAX_KEY_LEN - 1,
>    733                                          blkg->stats.dequeue, cb, dev);
>    734  #endif
>    735  
>    736          for (sub_type = BLKIO_STAT_READ; sub_type < BLKIO_STAT_TOTAL;
>    737                          sub_type++) {
>    738                  blkio_get_key_name(sub_type, dev, key_str, MAX_KEY_LEN, false);
>    739                  cb->fill(cb, key_str, blkg->stats.stat_arr[type][sub_type]);
>                                                     ^^^^^^^^^^^^^^^^^^^^
> This array only has 4 elements and if "type" is 9 we're past the end of
> array.
> 
>    740          }
> 
> It's odd that Smatch only started complaining about this now, but this
> code has been there for years.  I'm puzzled by what changed.  Sorry if
> there is something obvious I have missed.
  It seems that BLKIO_STAT_... values larger than BLK_IO_STAT_QUEUE are
defined only if CONFIG_DEBUG_BLK_CGROUP is defined. And in that case they
are also handled by blkio_get_stat() in a special way so we never get to
computing blkg->stats.stat_arr[type][sub_type]. So everything seems fine.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
