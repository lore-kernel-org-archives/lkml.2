Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab1LQWlM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 17:41:12 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48754 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab1LQWlJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 17:41:09 -0500
Date: Sun, 18 Dec 2011 01:37:45 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>, Namhyung Kim <namhyung@gmail.com>,
        Lukas Czerner <lczerner@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] loop: fput() called in loop_clr_fd() may cause bd_mutex
 recursive locking
Message-ID: <20111217223745.GC3313@swordfish>
References: <20111217215333.GA3313@swordfish>
 <20111217221232.GA2203@ZenIV.linux.org.uk>
 <20111217221928.GB3313@swordfish>
 <20111217223033.GB2203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20111217223033.GB2203@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (12/17/11 22:30), Al Viro wrote:
> > Sorry, why is that a false positive?
> > 
> > blkdev_put() calls lo_release() while holding bd_mutex,
> > lo_release() calls loop_clr_fd() -> fput(). fput() once again
> > attempts to grub already held bd_mutex calling blkdev_put().
> > Looks like a recursion to me.
> 
> Because of this:
>         /* Avoid recursion */
>         f = file;
>         while (is_loop_device(f)) {
>                 struct loop_device *l;
> 
>                 if (f->f_mapping->host->i_bdev == bdev)
>                         goto out_putf;
> 
>                 l = f->f_mapping->host->i_bdev->bd_disk->private_data;
>                 if (l->lo_state == Lo_unbound) {
>                         error = -EINVAL;
>                         goto out_putf;
>                 }
>                 f = l->lo_backing_file;
>         }
> in loop_set_fd().  

Oh, thanks. I didn't notice that one.

> Think of it for a minute - if we could run into the
> same bdev in that recursion, what would have happened on read() from
> that sucker? So yes, it is a false positive. 

I've tried read()/write() some time ago and it worked. Perhaps, I just
wasn't "lucky" enough to hit any problems.

> And your patch would simply leave the underlying device opened,
> with all the consequences...
> 
well, that sucks.


	Sergey
