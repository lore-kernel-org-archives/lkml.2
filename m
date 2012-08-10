Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472Ab2HJRYl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 13:24:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44360 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831Ab2HJRYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 13:24:39 -0400
Date: Fri, 10 Aug 2012 13:24:28 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH 2/6] floppy: do put_disk on current dr if blk_init_queue
 fails
Message-ID: <20120810172428.GG5416@redhat.com>
References: <1344542391-16474-1-git-send-email-herton.krzesinski@canonical.com>
 <1344542391-16474-3-git-send-email-herton.krzesinski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344542391-16474-3-git-send-email-herton.krzesinski@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2012 at 04:59:47PM -0300, Herton Ronaldo Krzesinski wrote:
> If blk_init_queue fails, we do not call put_disk on the current dr
> (dr is decremented first in the error handling loop).
> 
> Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
> Cc: stable@vger.kernel.org

Hi,

So for the current drive we do put_disk() here and for rest of the drives
we do it in out_put_disk:.

How about if we go through all the N_DRIVE always and do put disk as need be.

	for(i = 0, i < N_DRIVE, i++) {
		if (!disks[i])
			continue;

		if (disks[i]->queue)
			blk_cleanup_queue();

		if (!disk_registered[i])
			disks[i]->queue = NULL;

		put_disk();
	}

It is little more lines of code but personally I find it easier to understand 
and less error prone as future modifications take place.

Thanks
Vivek

> ---
>  drivers/block/floppy.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
> index c8d9e68..1e09e99 100644
> --- a/drivers/block/floppy.c
> +++ b/drivers/block/floppy.c
> @@ -4151,6 +4151,7 @@ static int __init do_floppy_init(void)
>  
>  		disks[dr]->queue = blk_init_queue(do_fd_request, &floppy_lock);
>  		if (!disks[dr]->queue) {
> +			put_disk(disks[dr]);
>  			err = -ENOMEM;
>  			goto out_put_disk;
>  		}
> -- 
> 1.7.9.5
