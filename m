Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab1D1N3j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 09:29:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752305Ab1D1N3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 09:29:37 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Dmitry Monakhov <dmonakhov@openvz.org>, jaxboe@fusionio.com
Subject: Re: [PATCH 1/2] blkdev: Submit discard bio in batches in blkdev_issue_discard()
References: <1303303172-22404-1-git-send-email-lczerner@redhat.com>
	<x49aafb4x1k.fsf@segfault.boston.devel.redhat.com>
	<alpine.LFD.2.00.1104280950380.31735@dhcp-27-109.brq.redhat.com>
	<alpine.LFD.2.00.1104281007530.31735@dhcp-27-109.brq.redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 28 Apr 2011 09:29:29 -0400
In-Reply-To: <alpine.LFD.2.00.1104281007530.31735@dhcp-27-109.brq.redhat.com>
	(Lukas Czerner's message of "Thu, 28 Apr 2011 10:09:18 +0200 (CEST)")
Message-ID: <x49sjt2ld1i.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lukas Czerner <lczerner@redhat.com> writes:

> On Thu, 28 Apr 2011, Lukas Czerner wrote:
>
>> On Wed, 27 Apr 2011, Jeff Moyer wrote:
>> 
>> > Lukas Czerner <lczerner@redhat.com> writes:
>> > 
>> > > Currently we are waiting for every submitted REQ_DISCARD bio separately,
>> > > but it can have unwanted consequences of repeatedly flushing the queue,
>> > > so we rather submit bios in batches and wait for the entire batch, hence
>> > > narrowing the window of other ios going in.
>> > >
>> > > Use bio_batch_end_io() and struct bio_batch for that purpose, the same
>> > > is used by blkdev_issue_zeroout(). Also change bio_batch_end_io() so we
>> > > always set !BIO_UPTODATE in the case of error and remove the check for
>> > > bb, since we are the only user of this function and we always set this.
>> > >
>> > > Remove bio_get()/bio_put() from the blkdev_issue_discard() since
>> > > bio_alloc() and bio_batch_end_io() is doing the same thing, hence it is
>> > > not needed anymore.
>> > >
>> > > I have done simple dd testing with surprising results. The script I have
>> > > used is:
>> > >
>> > > for i in $(seq 10); do
>> > >         echo $i
>> > >         dd if=/dev/sdb1 of=/dev/sdc1 bs=4k &
>> > >         sleep 5
>> > > done
>> > > /usr/bin/time -f %e ./blkdiscard /dev/sdc1
>> > >
>> > > Running time of BLKDISCARD on the whole device:
>> > > with patch              without patch
>> > > 0.95                    15.58
>> > >
>> > > So we can see that in this artificial test the kernel with the patch
>> > > applied is approx 16x faster in discarding the device.
>> > 
>> > I don't see any major problems here.  I would like you to test
>> > explicitly for queue_flag_discard before submitting any bios, though.
>
> Btw, this is already in there:
>
> 	if (!blk_queue_discard(q))
> 		return -EOPNOTSUPP;
>
> at the top of the function.

Boy, how did I miss that?  ;-)

Cheers,
Jeff
