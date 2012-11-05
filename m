Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab2KEQxs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 11:53:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36397 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753019Ab2KEQxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 11:53:47 -0500
Date: Mon, 5 Nov 2012 17:53:42 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Ben Hutchings <ben@decadent.org.uk>, Jens Axboe <axboe@kernel.dk>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [floppy, blk_peek_request] BUG: scheduling while atomic:
 kworker/u:0/6/0x10000002
In-Reply-To: <20121105163618.GA28720@redhat.com>
Message-ID: <alpine.LNX.2.00.1211051753150.24253@pobox.suse.cz>
References: <20121105070106.GA17015@localhost> <alpine.LNX.2.00.1211051422500.24253@pobox.suse.cz> <alpine.LNX.2.00.1211051433180.24253@pobox.suse.cz> <20121105152706.GA3200@herton-Z68MA-D2H-B3> <alpine.LNX.2.00.1211051632460.24253@pobox.suse.cz>
 <20121105163618.GA28720@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Nov 2012, Vivek Goyal wrote:

> > > Yes, I saw the same thing here, destroy_workqueue should be done before
> > > clearing the queue (blk_cleanup_queue) indeed. user_reset_fdc called
> > > process_fd_request and that scheduled redo_fd_request, that tries to
> > > take the queue already cleaned up in set_next_request I expect.
> > > 
> > > > 
> > > > 
> > > > 
> > > > 
> > > >  drivers/block/floppy.c |    2 +-
> > > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > > 
> > > > diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
> > > > index 1c49d71..3b9cc0f 100644
> > > > --- a/drivers/block/floppy.c
> > > > +++ b/drivers/block/floppy.c
> > > > @@ -4329,6 +4329,7 @@ out_unreg_region:
> > > >  	platform_driver_unregister(&floppy_driver);
> > > >  out_unreg_blkdev:
> > > >  	unregister_blkdev(FLOPPY_MAJOR, "fd");
> > > > +	destroy_workqueue(floppy_wq);
> > > 
> > > This should go right after the out_put_disk label, otherwise we may
> > > leak the floppy_wq on early error.
> > 
> > Indeed.
> > 
> > Fengguang, could you please test with the patch below instead? (it should 
> > be functionally equivalent in most of the cases though).
> > 
> 
> What about floppy_module_exit(). There also we seem to cleanup the queue
> first before flushing and destroying floppy_wq workqueue.

Yup, will fix that up in a final patch once we have confirmation from 
Fengguang that it fixes the problem he is seeing.

Thanks,

-- 
Jiri Kosina
SUSE Labs
