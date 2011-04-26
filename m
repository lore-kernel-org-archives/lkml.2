Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751258Ab1DZSd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 14:33:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756Ab1DZSdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 14:33:25 -0400
Date: Tue, 26 Apr 2011 14:33:21 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org
Subject: Re: submitting read(1%)/write(99%) IO within a kernel thread, vs
 doing it in userspace (aio) with CFQ shows drastic drop. Ideas?
Message-ID: <20110426183321.GG9414@redhat.com>
References: <20110426173732.GA25442@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110426173732.GA25442@dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 01:37:32PM -0400, Konrad Rzeszutek Wilk wrote:
> 
> I was hoping you could shed some light at a peculiar problem I am seeing
> (this is with the PV block backend I posted recently [1]).
> 
> I am using the IOmeter fio test, with two threads and modified it slightly
> (please see at the bottom). The "disk" the I/Os are being done on is an iSCSI disk
> that on the other side is LIO TCM 10G RAMdisk. The network is 1GB and
> the line speed when doing just full blow random reads or full random writes
> is 112MB/s (native or from the guest).
> 
> I launch a guest and inside the guest I run the 'fio iometer'. When launching
> the guest I have the option of using two different block backends:
> the kernel one (simple code [1] doing 'submit_bio') or the userspace one (which
> uses the AIO library and opens the disk using O_DIRECT). The throughput and submit
> latency are widely different for this particular workload. If I swap the IO
> scheduler in the host for the iSCSI disk from 'cfq' to deadline or noop - throughput
> and latencies become the same (however CPU usage is not, but that is not important here).
> Here is a simple table with the numbers:
> 
> IOmeter       |       |      |          |
> 64K, randrw   |  NOOP | CFQ  | deadline |
> randrwmix=80  |       |      |          |
> --------------+-------+------+----------+
> blkback       |103/27 |32/10 | 102/27   |
> --------------+-------+------+----------+
> QEMU qdisk    |103/27 |102/27| 102/27   |
> 
> What I found out is that if I pollute the ring request with just one
> different type of I/O operation (so 99% is WRITE, and I stick 1% READ on it)
> the I/O  plummets if I use the kernel thread. But that problem does
> not show up when the I/O operations are plumbed through the AIO library.

Konrad,

I suspect that difference is that sync vs async requests. In the case of
a kernel thread submitting IO, I think all the WRITES might be being
considered as async and will go in a different queue. If you mix those
with some READS, they are always sync and will go in differnet queue.
In presence of sync queue, CFQ will idle and choke up WRITES in
an attempt to improve latencies of READs.

In case of AIO, I am assuming it is direct IO and both READS and WRITES
will be considered SYNC and will go in a single queue and no choking
of WRITES will take place. 

Can you run blktrace on your host iscsi device (15-20 seconds) and upload
the traces somewhere. That might give us some ideas.

The bio's you are preparing in kernel thread, if you flag them sync using
(REQ_SYNC flag), then this problem might disappear (Only if my problem
analysis is right. :-))

Thanks
Vivek
 

> And if I switch over from the CFQ scheduler the numbers go up again.
> The host and the guest are both running Fedora Core 13 x86_64.
> 
> 
> Any ideas what the kernel AIO library or CFQ might be doing differently?
> 
> The two code pieces simplified:
> 
> The kernel thread is quite simple, it does:
> 
> 	while (!kthread_should_stop()) {
> 		struct blk_plug plug;
> 
> 		.. snip..
> 
> 		blk_start_plug(&plug);
> 
> 		if (do_block_io_op(blkif))
> 			blkif->waiting_reqs = 1;
> 
> 		blk_finish_plug(&plug);
> 
> 	}
> 
>  and 'do_block_io_op' picks up the requests from the ring buffer:
> 
> 	rc = blk_rings->common.req_cons;
> 	rp = blk_rings->common.sring->req_prod;
> 
> 	while (rc != rp) {
> 		.. snip ..	
> 		switch (req.operation) {
> 		case BLKIF_OP_READ:
> 			dispatch_rw_block_io(blkif, &req, pending_req);
> 			break;
> 		case BLKIF_OP_WRITE:
> 			blkif->st_wr_req++;
> 			dispatch_rw_block_io(blkif, &req, pending_req);
> 		.. snip..
> 		cond_resched();
> 	}
> 
> and the 'dispatch_rw_block_io' takes the request (which can contain up
> to 11 pages - so 88 512byte sectors if desired) and sets up 'bio's mapping
> to these pages and then
> 
> 	for (i = 0; i < nbio; i++)
> 		submit_bio(operation, biolist[i]);
> 
> That is it. The interesting thing is that the requests can only contain one
> type - either all of the pages are READ or all WRITE (I am ignoring barrieris here).
> 
> The userspace code is similar. It has a thread that does:
> 
>     rc = blkdev->rings.common.req_cons;
>     rp = blkdev->rings.common.sring->req_prod;
> 
>     while (rc != rp) {
> 	.. snip..
> 	.. picks up the request from the ring buffer and ../
>             /* run i/o in aio mode */
>             ioreq_runio_qemu_aio(ioreq);
> 
> and 'ioreq_runio_qemu_aio':
> 
>     switch (ioreq->req.operation) {
>     case BLKIF_OP_READ:
>         bdrv_aio_readv(blkdev->bs, ioreq->start / BLOCK_SIZE,
>                        &ioreq->v, ioreq->v.size / BLOCK_SIZE,
>                        qemu_aio_complete, ioreq);
> 	.. snip..
>     case BLKIF_OP_WRITE_BARRIER:
>         bdrv_aio_writev(blkdev->bs, ioreq->start / BLOCK_SIZE,
> 
> and the 'bdrv_aio_[read|write]v' ends up calling either io_prep_preadv
> or io_prep_writev and then io_submit.
> 
> 
> The iometer file:
> 
> # This job file tries to mimic the Intel IOMeter File Server Access Pattern
> [global]
> description=Emulation of Intel IOmeter File Server Access Pattern
> numjobs=2
> timeout=60
> 
> [/dev/xvda]
> #bssplit=512/10:1k/5:2k/5:4k/60:8k/2:16k/4:32k/4:64k/10
> #bssplit=512/10:1k/5:2k/5:4k
> bs=64K
> rw=randrw
> rwmixread=80
> direct=1
> size=4g
> ioengine=libaio
> # IOMeter defines the server loads as the following:
> # iodepth=1	Linear
> # iodepth=4	Very Light
> # iodepth=8	Light
> # iodepth=64	Moderate
> # iodepth=256	Heavy
> iodepth=256
> write_bw_log=iometer
> write_lat_log=iometer
> 
> 
> [1]: http://lwn.net/Articles/439629/
>     I updated it a bit (move the plug/unplug higher in the calling chain), so would suggest 
>     git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git devel/xen-blkback-v3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
