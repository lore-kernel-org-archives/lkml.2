Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab1D1H5h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 03:57:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670Ab1D1H5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 03:57:36 -0400
Date: Thu, 28 Apr 2011 09:57:29 +0200 (CEST)
From: Lukas Czerner <lczerner@redhat.com>
X-X-Sender: lukas@dhcp-27-109.brq.redhat.com
To: Jeff Moyer <jmoyer@redhat.com>
cc: Lukas Czerner <lczerner@redhat.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>,
        jaxboe@fusionio.com
Subject: Re: [PATCH 1/2] blkdev: Submit discard bio in batches in
 blkdev_issue_discard()
In-Reply-To: <x49aafb4x1k.fsf@segfault.boston.devel.redhat.com>
Message-ID: <alpine.LFD.2.00.1104280950380.31735@dhcp-27-109.brq.redhat.com>
References: <1303303172-22404-1-git-send-email-lczerner@redhat.com> <x49aafb4x1k.fsf@segfault.boston.devel.redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Apr 2011, Jeff Moyer wrote:

> Lukas Czerner <lczerner@redhat.com> writes:
> 
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
> I don't see any major problems here.  I would like you to test
> explicitly for queue_flag_discard before submitting any bios, though.
> Previously, after the first bio returned EOPNOTSUPP, you errored out.
> Now, you submit all bios that will end with the same failure.  It's
> definitely suboptimal, and you already have the q, so you might as well
> test for this early on.
> 
> Also, as I noted to you on irc, another fix required in this area is
> submitting discard requests (the final one in the batch) that do not
> honor the discard granularity exported by the device.  That's not
> directly related to this patch, though.
> 
> Cheers,
> Jeff
> 

Thanks for review and comments Jeff, I'll resend patches after I retest
them.

-Lukas
