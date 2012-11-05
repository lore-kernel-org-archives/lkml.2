Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115Ab2KEQgk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 11:36:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378Ab2KEQgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 11:36:39 -0500
Date: Mon, 5 Nov 2012 11:36:19 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Ben Hutchings <ben@decadent.org.uk>, Jens Axboe <axboe@kernel.dk>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [floppy, blk_peek_request] BUG: scheduling while atomic:
 kworker/u:0/6/0x10000002
Message-ID: <20121105163618.GA28720@redhat.com>
References: <20121105070106.GA17015@localhost>
 <alpine.LNX.2.00.1211051422500.24253@pobox.suse.cz>
 <alpine.LNX.2.00.1211051433180.24253@pobox.suse.cz>
 <20121105152706.GA3200@herton-Z68MA-D2H-B3>
 <alpine.LNX.2.00.1211051632460.24253@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1211051632460.24253@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2012 at 04:33:35PM +0100, Jiri Kosina wrote:
> On Mon, 5 Nov 2012, Herton Ronaldo Krzesinski wrote:
> 
> > > Fengguang, does the patch below make any difference for you please?
> > > 
> > > Thanks.
> > 
> > Yes, I saw the same thing here, destroy_workqueue should be done before
> > clearing the queue (blk_cleanup_queue) indeed. user_reset_fdc called
> > process_fd_request and that scheduled redo_fd_request, that tries to
> > take the queue already cleaned up in set_next_request I expect.
> > 
> > > 
> > > 
> > > 
> > > 
> > >  drivers/block/floppy.c |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
> > > index 1c49d71..3b9cc0f 100644
> > > --- a/drivers/block/floppy.c
> > > +++ b/drivers/block/floppy.c
> > > @@ -4329,6 +4329,7 @@ out_unreg_region:
> > >  	platform_driver_unregister(&floppy_driver);
> > >  out_unreg_blkdev:
> > >  	unregister_blkdev(FLOPPY_MAJOR, "fd");
> > > +	destroy_workqueue(floppy_wq);
> > 
> > This should go right after the out_put_disk label, otherwise we may
> > leak the floppy_wq on early error.
> 
> Indeed.
> 
> Fengguang, could you please test with the patch below instead? (it should 
> be functionally equivalent in most of the cases though).
> 

What about floppy_module_exit(). There also we seem to cleanup the queue
first before flushing and destroying floppy_wq workqueue.

Thanks
Vivek

> 
> 
> 
>  drivers/block/floppy.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
> index 1c49d71..e386d83 100644
> --- a/drivers/block/floppy.c
> +++ b/drivers/block/floppy.c
> @@ -4330,6 +4330,7 @@ out_unreg_region:
>  out_unreg_blkdev:
>  	unregister_blkdev(FLOPPY_MAJOR, "fd");
>  out_put_disk:
> +	destroy_workqueue(floppy_wq);
>  	for (drive = 0; drive < N_DRIVE; drive++) {
>  		if (!disks[drive])
>  			break;
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
