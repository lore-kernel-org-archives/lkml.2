Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481Ab2KEP10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 10:27:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42843 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415Ab2KEP1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 10:27:18 -0500
Date: Mon, 5 Nov 2012 13:27:07 -0200
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Vivek Goyal <vgoyal@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>, Jens Axboe <axboe@kernel.dk>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [floppy, blk_peek_request] BUG: scheduling while atomic:
 kworker/u:0/6/0x10000002
Message-ID: <20121105152706.GA3200@herton-Z68MA-D2H-B3>
References: <20121105070106.GA17015@localhost>
 <alpine.LNX.2.00.1211051422500.24253@pobox.suse.cz>
 <alpine.LNX.2.00.1211051433180.24253@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1211051433180.24253@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2012 at 02:34:13PM +0100, Jiri Kosina wrote:
> On Mon, 5 Nov 2012, Jiri Kosina wrote:
> 
> > > I got the below oops in Linux 3.7-rc4 and it's bisected down to
> > > 
> > > commit b54e1f88897bcacc2cd359f48ea3b39eaf55f084
> > > Author: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
> > > Date:   Mon Aug 27 20:56:51 2012 -0300
> > > 
> > >     floppy: don't call alloc_ordered_workqueue inside the alloc_disk loop
> > 
> > Fengguang,
> > 
> > thanks for the report.
> > 
> > How reliable is the bisection result? (i.e. how reliably are you able to 
> > trigger this oops?).
> > 
> > I am having a hard time seeing how that particular commit could be causing 
> > this kind of oops.
> 
> Hmm, actually I do see an option how this might happen on machines not 
> having an actual floppy drive.
> 
> Fengguang, does the patch below make any difference for you please?
> 
> Thanks.

Yes, I saw the same thing here, destroy_workqueue should be done before
clearing the queue (blk_cleanup_queue) indeed. user_reset_fdc called
process_fd_request and that scheduled redo_fd_request, that tries to
take the queue already cleaned up in set_next_request I expect.

> 
> 
> 
> 
>  drivers/block/floppy.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
> index 1c49d71..3b9cc0f 100644
> --- a/drivers/block/floppy.c
> +++ b/drivers/block/floppy.c
> @@ -4329,6 +4329,7 @@ out_unreg_region:
>  	platform_driver_unregister(&floppy_driver);
>  out_unreg_blkdev:
>  	unregister_blkdev(FLOPPY_MAJOR, "fd");
> +	destroy_workqueue(floppy_wq);

This should go right after the out_put_disk label, otherwise we may
leak the floppy_wq on early error.

>  out_put_disk:
>  	for (drive = 0; drive < N_DRIVE; drive++) {
>  		if (!disks[drive])
> @@ -4340,7 +4341,6 @@ out_put_disk:
>  		}
>  		put_disk(disks[drive]);
>  	}
> -	destroy_workqueue(floppy_wq);
>  	return err;
>  }
>  
> 
> -- 
> Jiri Kosina
> SUSE Labs
> 

-- 
[]'s
Herton
