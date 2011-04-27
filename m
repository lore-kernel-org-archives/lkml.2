Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759127Ab1D0NEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 09:04:23 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:30297 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932335Ab1D0NEV (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 27 Apr 2011 09:04:21 -0400
Date: Wed, 27 Apr 2011 09:04:03 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org
Subject: Re: submitting read(1%)/write(99%) IO within a kernel thread, vs
 doing it in userspace (aio) with CFQ shows drastic drop. Ideas?
Message-ID: <20110427130403.GA29593@dumpdata.com>
References: <20110426173732.GA25442@dumpdata.com>
 <20110426183321.GG9414@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110426183321.GG9414@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4DB8144D.0119:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 02:33:21PM -0400, Vivek Goyal wrote:
> On Tue, Apr 26, 2011 at 01:37:32PM -0400, Konrad Rzeszutek Wilk wrote:
> > 
> > I was hoping you could shed some light at a peculiar problem I am seeing
> > (this is with the PV block backend I posted recently [1]).
> > 
> > I am using the IOmeter fio test, with two threads and modified it slightly
> > (please see at the bottom). The "disk" the I/Os are being done on is an iSCSI disk
> > that on the other side is LIO TCM 10G RAMdisk. The network is 1GB and
> > the line speed when doing just full blow random reads or full random writes
> > is 112MB/s (native or from the guest).
> > 
> > I launch a guest and inside the guest I run the 'fio iometer'. When launching
> > the guest I have the option of using two different block backends:
> > the kernel one (simple code [1] doing 'submit_bio') or the userspace one (which
> > uses the AIO library and opens the disk using O_DIRECT). The throughput and submit
> > latency are widely different for this particular workload. If I swap the IO
> > scheduler in the host for the iSCSI disk from 'cfq' to deadline or noop - throughput
> > and latencies become the same (however CPU usage is not, but that is not important here).
> > Here is a simple table with the numbers:
> > 
> > IOmeter       |       |      |          |
> > 64K, randrw   |  NOOP | CFQ  | deadline |
> > randrwmix=80  |       |      |          |
> > --------------+-------+------+----------+
> > blkback       |103/27 |32/10 | 102/27   |
> > --------------+-------+------+----------+
> > QEMU qdisk    |103/27 |102/27| 102/27   |
> > 
> > What I found out is that if I pollute the ring request with just one
> > different type of I/O operation (so 99% is WRITE, and I stick 1% READ on it)
> > the I/O  plummets if I use the kernel thread. But that problem does
> > not show up when the I/O operations are plumbed through the AIO library.
> 
> Konrad,
> 
> I suspect that difference is that sync vs async requests. In the case of
> a kernel thread submitting IO, I think all the WRITES might be being
> considered as async and will go in a different queue. If you mix those
> with some READS, they are always sync and will go in differnet queue.
> In presence of sync queue, CFQ will idle and choke up WRITES in
> an attempt to improve latencies of READs.
> 
> In case of AIO, I am assuming it is direct IO and both READS and WRITES
> will be considered SYNC and will go in a single queue and no choking
> of WRITES will take place. 
> 
> Can you run blktrace on your host iscsi device (15-20 seconds) and upload
> the traces somewhere. That might give us some ideas.
> 
> The bio's you are preparing in kernel thread, if you flag them sync using
> (REQ_SYNC flag), then this problem might disappear (Only if my problem
> analysis is right. :-))

Your analysis was spot-on-dead right. Thank you!
