Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008Ab1ECJay (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 05:30:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898Ab1ECJax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 05:30:53 -0400
Date: Tue, 3 May 2011 11:30:43 +0200 (CEST)
From: Lukas Czerner <lczerner@redhat.com>
X-X-Sender: lukas@dhcp-27-109.brq.redhat.com
To: Jens Axboe <jaxboe@fusionio.com>
cc: Lukas Czerner <lczerner@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Monakhov <dmonakhov@openvz.org>, Jeff Moyer <jmoyer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] blkdev: Submit discard bio in batches in 
 blkdev_issue_discard()
In-Reply-To: <4DBEDA78.7020502@fusionio.com>
Message-ID: <alpine.LFD.2.00.1105031128390.4250@dhcp-27-109.brq.redhat.com>
References: <1304345841-20063-1-git-send-email-lczerner@redhat.com> <4DBEDA78.7020502@fusionio.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 May 2011, Jens Axboe wrote:

> On 2011-05-02 08:17, Lukas Czerner wrote:
> > Currently we are waiting for every submitted REQ_DISCARD bio separately,
> > but it can have unwanted consequences of repeatedly flushing the queue,
> > so we rather submit bios in batches and wait for the entire batch, hence
> > narrowing the window of other ios going in.
> > 
> > Use bio_batch_end_io() and struct bio_batch for that purpose, the same
> > is used by blkdev_issue_zeroout(). Also change bio_batch_end_io() so we
> > always set !BIO_UPTODATE in the case of error and remove the check for
> > bb, since we are the only user of this function and we always set this.
> > 
> > Remove bio_get()/bio_put() from the blkdev_issue_discard() since
> > bio_alloc() and bio_batch_end_io() is doing the same thing, hence it is
> > not needed anymore.
> > 
> > I have done simple dd testing with surprising results. The script I have
> > used is:
> > 
> > for i in $(seq 10); do
> >         echo $i
> >         dd if=/dev/sdb1 of=/dev/sdc1 bs=4k &
> >         sleep 5
> > done
> > /usr/bin/time -f %e ./blkdiscard /dev/sdc1
> > 
> > Running time of BLKDISCARD on the whole device:
> > with patch              without patch
> > 0.95                    15.58
> > 
> > So we can see that in this artificial test the kernel with the patch
> > applied is approx 16x faster in discarding the device.
> 
> Good results. It'd be more efficient to add the vectored discard support
> and use it for this too though, and it would get rid of the need to wait
> on the batches since there'd be just one discard bio for the ranges.
> 

I know that you and Christoph were working on adding support for
vectored discard, but I do not know what is the status of it ?

Thanks!
-Lukas
