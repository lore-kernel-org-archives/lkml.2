Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757846Ab1DZRhp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 13:37:45 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:27689 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757776Ab1DZRhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 13:37:43 -0400
Date: Tue, 26 Apr 2011 13:37:32 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: linux-kernel@vger.kernel.org
Subject: submitting read(1%)/write(99%) IO within a kernel thread, vs doing
 it in userspace (aio) with CFQ shows drastic drop. Ideas?
Message-ID: <20110426173732.GA25442@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4DB702E5.010F:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I was hoping you could shed some light at a peculiar problem I am seeing
(this is with the PV block backend I posted recently [1]).

I am using the IOmeter fio test, with two threads and modified it slightly
(please see at the bottom). The "disk" the I/Os are being done on is an iSCSI disk
that on the other side is LIO TCM 10G RAMdisk. The network is 1GB and
the line speed when doing just full blow random reads or full random writes
is 112MB/s (native or from the guest).

I launch a guest and inside the guest I run the 'fio iometer'. When launching
the guest I have the option of using two different block backends:
the kernel one (simple code [1] doing 'submit_bio') or the userspace one (which
uses the AIO library and opens the disk using O_DIRECT). The throughput and submit
latency are widely different for this particular workload. If I swap the IO
scheduler in the host for the iSCSI disk from 'cfq' to deadline or noop - throughput
and latencies become the same (however CPU usage is not, but that is not important here).
Here is a simple table with the numbers:

IOmeter       |       |      |          |
64K, randrw   |  NOOP | CFQ  | deadline |
randrwmix=80  |       |      |          |
--------------+-------+------+----------+
blkback       |103/27 |32/10 | 102/27   |
--------------+-------+------+----------+
QEMU qdisk    |103/27 |102/27| 102/27   |

What I found out is that if I pollute the ring request with just one
different type of I/O operation (so 99% is WRITE, and I stick 1% READ on it)
the I/O  plummets if I use the kernel thread. But that problem does
not show up when the I/O operations are plumbed through the AIO library.
And if I switch over from the CFQ scheduler the numbers go up again.
The host and the guest are both running Fedora Core 13 x86_64.


Any ideas what the kernel AIO library or CFQ might be doing differently?

The two code pieces simplified:

The kernel thread is quite simple, it does:

	while (!kthread_should_stop()) {
		struct blk_plug plug;

		.. snip..

		blk_start_plug(&plug);

		if (do_block_io_op(blkif))
			blkif->waiting_reqs = 1;

		blk_finish_plug(&plug);

	}

 and 'do_block_io_op' picks up the requests from the ring buffer:

	rc = blk_rings->common.req_cons;
	rp = blk_rings->common.sring->req_prod;

	while (rc != rp) {
		.. snip ..	
		switch (req.operation) {
		case BLKIF_OP_READ:
			dispatch_rw_block_io(blkif, &req, pending_req);
			break;
		case BLKIF_OP_WRITE:
			blkif->st_wr_req++;
			dispatch_rw_block_io(blkif, &req, pending_req);
		.. snip..
		cond_resched();
	}

and the 'dispatch_rw_block_io' takes the request (which can contain up
to 11 pages - so 88 512byte sectors if desired) and sets up 'bio's mapping
to these pages and then

	for (i = 0; i < nbio; i++)
		submit_bio(operation, biolist[i]);

That is it. The interesting thing is that the requests can only contain one
type - either all of the pages are READ or all WRITE (I am ignoring barrieris here).

The userspace code is similar. It has a thread that does:

    rc = blkdev->rings.common.req_cons;
    rp = blkdev->rings.common.sring->req_prod;

    while (rc != rp) {
	.. snip..
	.. picks up the request from the ring buffer and ../
            /* run i/o in aio mode */
            ioreq_runio_qemu_aio(ioreq);

and 'ioreq_runio_qemu_aio':

    switch (ioreq->req.operation) {
    case BLKIF_OP_READ:
        bdrv_aio_readv(blkdev->bs, ioreq->start / BLOCK_SIZE,
                       &ioreq->v, ioreq->v.size / BLOCK_SIZE,
                       qemu_aio_complete, ioreq);
	.. snip..
    case BLKIF_OP_WRITE_BARRIER:
        bdrv_aio_writev(blkdev->bs, ioreq->start / BLOCK_SIZE,

and the 'bdrv_aio_[read|write]v' ends up calling either io_prep_preadv
or io_prep_writev and then io_submit.


The iometer file:

# This job file tries to mimic the Intel IOMeter File Server Access Pattern
[global]
description=Emulation of Intel IOmeter File Server Access Pattern
numjobs=2
timeout=60

[/dev/xvda]
#bssplit=512/10:1k/5:2k/5:4k/60:8k/2:16k/4:32k/4:64k/10
#bssplit=512/10:1k/5:2k/5:4k
bs=64K
rw=randrw
rwmixread=80
direct=1
size=4g
ioengine=libaio
# IOMeter defines the server loads as the following:
# iodepth=1	Linear
# iodepth=4	Very Light
# iodepth=8	Light
# iodepth=64	Moderate
# iodepth=256	Heavy
iodepth=256
write_bw_log=iometer
write_lat_log=iometer


[1]: http://lwn.net/Articles/439629/
    I updated it a bit (move the plug/unplug higher in the calling chain), so would suggest 
    git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git devel/xen-blkback-v3.1

