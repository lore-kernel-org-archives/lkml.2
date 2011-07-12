Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab1GLS4q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 14:56:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8840 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753855Ab1GLS4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 14:56:44 -0400
Date: Tue, 12 Jul 2011 14:54:29 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Roland Dreier <roland@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Alan Stern <stern@rowland.harvard.edu>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-scsi@vger.kernel.org,
        Steffen Maier <maier@linux.vnet.ibm.com>,
        "Manvanthara B. Puttashankar" <manvanth@linux.vnet.ibm.com>,
        Tarak Reddy <tarak.reddy@in.ibm.com>,
        "Seshagiri N. Ippili" <sesh17@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org,
        device-mapper development <dm-devel@redhat.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] block: Check that queue is alive in
 blk_insert_cloned_request()
Message-ID: <20110712185429.GK1293@redhat.com>
References: <CAG4TOxMjuntpd3Q5jgn+xDa2tgB9tq+jLcDquM_eAdFHXLDrWA@mail.gmail.com>
 <1310166270-23196-1-git-send-email-roland@kernel.org>
 <CAMM=eLfzKuw-2vbERV6D7dAHb1BWopOKZ=dB7vWxcxSCoj6Tkw@mail.gmail.com>
 <20110712170658.GF1293@redhat.com>
 <1310492490.16900.20.camel@mulgrave>
 <20110712180238.GJ1293@redhat.com>
 <1310495298.16900.24.camel@mulgrave>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310495298.16900.24.camel@mulgrave>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 01:28:18PM -0500, James Bottomley wrote:

[..]
> > > I'm starting to wonder if there's actually any value to
> > > blk_cleanup_queue() and whether its functionality wouldn't be better
> > > assumed by the queue release function on last put.
> > 
> > I think one problem point is q->queue_lock. If driver drops its reference
> > on queue and cleans up its data structures, then it will free up memory
> > associated with q->queue_lock too. (If driver provided its own queue
> > lock). In that case anything which is dependent on queue lock, needs
> > to be freed up on blk_cleanup_queue().
> 
> I don't quite follow.  blk_cleanup_queue() doesn't free anything (well,
> except the elevator).  Final put will free the queue structure which
> contains the lock, but if it's really a final put, you have no other
> possible references, so no-one is using the lock ... well, assuming
> there isn't a programming error, of course ...
> 
> > If we can make sure that request queue reference will keep the spin lock
> > alive, then i guess all cleanup part might be able to go in release
> > queue function.
> 
> As I said: cleanup doesn't free the structure containing the lock,
> release does, so that piece wouldn't be altered by putting
> blk_cleanup_queue() elsewhere.

I thought a driver could either rely on spin lock provided by request
queue or override that by providing its own spinlock.

blk_init_allocated_queue_node()
        /* Override internal queue lock with supplied lock pointer */
        if (lock)
                q->queue_lock           = lock;

So if driver calls blk_cleanup_queue() and drops its reference on queue, then
it should be free to release any memory it has allocated for spinlock.
So though queue is around there are no gurantees that q->queue_lock is
still around. That memory might have been freed by driver and reused.

I see many drivers are providing their own locks. Some samples from
drivers/block.

/virtio_blk.c:	q = vblk->disk->queue = blk_init_queue(do_virtblk_request,
&vblk->lock);
./xd.c:	xd_queue = blk_init_queue(do_xd_request, &xd_lock);
./cpqarray.c:	q = blk_init_queue(do_ida_request, &hba[i]->lock);
./sx8.c:	q = blk_init_queue(carm_rq_fn, &host->lock);
./sx8.c:	q = blk_init_queue(carm_oob_rq_fn, &host->lock);
./floppy.c:	disks[dr]->queue = blk_init_queue(do_fd_request, &floppy_lock);
./viodasd.c:	q = blk_init_queue(do_viodasd_request, &d->q_lock);
./cciss.c:	disk->queue = blk_init_queue(do_cciss_request, &h->lock);
./hd.c:	hd_queue = blk_init_queue(do_hd_request, &hd_lock);
./DAC960.c:  	RequestQueue = blk_init_queue(DAC960_RequestFunction,&Controller->queue_lock);
./z2ram.c:    z2_queue = blk_init_queue(do_z2_request, &z2ram_lock);
./amiflop.c:	disk->queue = blk_init_queue(do_fd_request, &amiflop_lock);
./xen-blkfront.c:	rq = blk_init_queue(do_blkif_request, &blkif_io_lock);
./paride/pd.c:	pd_queue = blk_init_queue(do_pd_request, &pd_lock);
./paride/pf.c:	pf_queue = blk_init_queue(do_pf_request, &pf_spin_lock);
./paride/pcd.c:	pcd_queue = blk_init_queue(do_pcd_request, &pcd_lock);
./mg_disk.c:	host->breq = blk_init_queue(mg_request_poll, &host->lock);
./mg_disk.c:	host->breq = blk_init_queue(mg_request, &host->lock);
./rbd.c:	q = blk_init_queue(rbd_rq_fn, &rbd_dev->lock);
./sunvdc.c:	q = blk_init_queue(do_vdc_request, &port->vio.lock);
./swim.c:	swd->queue = blk_init_queue(do_fd_request, &swd->lock);
./xsysace.c:	ace->queue = blk_init_queue(ace_request, &ace->lock);
./osdblk.c:	q = blk_init_queue(osdblk_rq_fn, &osdev->lock);
./ps3disk.c:	queue = blk_init_queue(ps3disk_request, &priv->lock);
./swim3.c:	swim3_queue = blk_init_queue(do_fd_request, &swim3_lock);
./ub.c:	if ((q = blk_init_queue(ub_request_fn, sc->lock)) == NULL)
./nbd.c:	disk->queue = blk_init_queue(do_nbd_request, &nbd_lock);

Thanks
Vivek
