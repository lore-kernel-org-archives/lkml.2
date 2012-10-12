Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759067Ab2JLOvR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 10:51:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48671 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757961Ab2JLOvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 10:51:15 -0400
Date: Fri, 12 Oct 2012 16:51:04 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Ben Hutchings <ben@decadent.org.uk>, Sasha Levin <levinsasha928@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: blk: NULL ptr deref in blk_dequeue_request()
In-Reply-To: <1349884374.6336.67.camel@deadeye.wl.decadent.org.uk>
Message-ID: <alpine.LNX.2.00.1210121650270.24717@pobox.suse.cz>
References: <505E2108.2060108@gmail.com>  <CA+1xoqc1Bc1rPgH+9Xs9-BV7qp3N7mDpNLj1mPwZHdF=H4mHTg@mail.gmail.com>  <20121008172207.GB14767@quack.suse.cz>  <alpine.LNX.2.00.1210082340501.19980@pobox.suse.cz>  <507424F7.60801@gmail.com> <50742600.10606@gmail.com>
 <1349884374.6336.67.camel@deadeye.wl.decadent.org.uk>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Oct 2012, Ben Hutchings wrote:

> > >>>>>> I'm still seeing this on linux-next.
> > >>>>   I think this is floppy related (see redo_fd_request() in the stack
> > >>>> trace). And there were quite some changes to the area recently. Adding
> > >>>> maintainer to CC.
> > >> Hmm ... I don't immediately see how this is happening.
> > >>
> > >> Sasha, could you please do git bisect on drivers/block/floppy.c between 
> > >> f6365201d and your git HEAD for starters (assuming that f6365201d works 
> > >> well for you?).
> > >>
> > > 
> > > A bisect on floppy.c yielded the following:
> > > 
> > > b33d002f4b6bae912463e5a66387c498aa69b6fe is the first bad commit
> > > commit b33d002f4b6bae912463e5a66387c498aa69b6fe
> > > Author: Ben Hutchings <ben@decadent.org.uk>
> > > Date:   Mon Aug 27 20:56:53 2012 -0300
> > > 
> > >     genhd: Make put_disk() safe for disks that have not been registered
> > 
> > 2 more things:
> > 
> >  1. The guest vm which I'm testing on doesn't emulate anything which even looks like a floppy.
> >  2. I'm seeing the following lines before the BUG:
> > 
> > [    9.836604] floppy0: no floppy controllers found
> > [    9.837246] work still pending
> > [    9.837743] floppy0: floppy_shutdown: timeout handler died.
> 
> I see two problems:
> 
> 1. redo_fd_request() races with tear-down of the disks, but because
> set_next_request() checks disk->queue before doing anything this was
> usually harmless.  Now that do_floppy_init() doesn't clear disk->queue,
> the race condition is much easier to hit.  This may fix that problem in
> do_floppy_init(), though there appear to be worse bugs in tear-down
> order in floppy_module_exit():
> 
> --- a/drivers/block/floppy.c
> +++ b/drivers/block/floppy.c
> @@ -4320,13 +4320,13 @@ out_unreg_region:
>  out_unreg_blkdev:
>  	unregister_blkdev(FLOPPY_MAJOR, "fd");
>  out_put_disk:
> +	destroy_workqueue(floppy_wq);
>  	while (dr--) {
>  		del_timer_sync(&motor_off_timer[dr]);
>  		if (disks[dr]->queue)
>  			blk_cleanup_queue(disks[dr]->queue);
>  		put_disk(disks[dr]);
>  	}
> -	destroy_workqueue(floppy_wq);
>  	return err;
>  }
>  
> --- END ---
> 
> 2. I made a big mistake in using the existing GENHD_FL_UP flag, as it is
> cleared by del_gendisk().  Incremental patch below, but it should be
> squashed into the previous patch if that branch is still rebase-able.

Sasha,

did you manage to test this to see if it fixes the symptom you are seeing, 
please?

-- 
Jiri Kosina
SUSE Labs
