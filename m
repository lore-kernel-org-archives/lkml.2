Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab1GLRHV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 13:07:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14046 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752264Ab1GLRHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 13:07:19 -0400
Date: Tue, 12 Jul 2011 13:06:58 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Roland Dreier <roland@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Alan Stern <stern@rowland.harvard.edu>,
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
Message-ID: <20110712170658.GF1293@redhat.com>
References: <CAG4TOxMjuntpd3Q5jgn+xDa2tgB9tq+jLcDquM_eAdFHXLDrWA@mail.gmail.com>
 <1310166270-23196-1-git-send-email-roland@kernel.org>
 <CAMM=eLfzKuw-2vbERV6D7dAHb1BWopOKZ=dB7vWxcxSCoj6Tkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMM=eLfzKuw-2vbERV6D7dAHb1BWopOKZ=dB7vWxcxSCoj6Tkw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 06:40:11PM -0400, Mike Snitzer wrote:
> [cc'ing dm-devel, vivek and tejun]
> 
> On Fri, Jul 8, 2011 at 7:04 PM, Roland Dreier <roland@kernel.org> wrote:
> > From: Roland Dreier <roland@purestorage.com>
> >
> > This fixes crashes such as the below that I see when the storage
> > underlying a dm-multipath device is hot-removed.  The problem is that
> > dm requeues a request to a device whose block queue has already been
> > cleaned up, and blk_insert_cloned_request() doesn't check if the queue
> > is alive, but rather goes ahead and tries to queue the request.  This
> > ends up dereferencing the elevator that was already freed in
> > blk_cleanup_queue().
> 
> Your patch looks fine to me:
> Acked-by: Mike Snitzer <snitzer@redhat.com>
> 
> And I looked at various code paths to arrive at the references DM takes.
> 
> A reference is taken on the underlying devices' block_device via
> drivers/md/dm-table.c:open_dev() with blkdev_get_by_dev().  open_dev()
> also does bd_link_disk_holder(), resulting in the mpath device
> becoming a holder of the underlying devices. e.g.:
> /sys/block/sda/holders/dm-4
> 
> But at no point does DM-mpath get a reference to the underlying
> devices' request_queue that gets assigned to clone->q (in
> drivers/md/dm-mpath.c:map_io).
> 
> Seems we should, though AFAIK it won't help with the issue you've
> pointed out (because the hotplugged device's driver already called
> blk_cleanup_queue and nuked the elevator).

[Thinking loud]

Could it be a driver specific issue that it cleaned up the request
queue too early?

Is there any notion of device reference which higher layers take and
that should make sure request queue is intact till somebody is holding
device reference.

If yes, what't the connection between device reference and request
queue reference. IOW, why request queue reference is needed and why
device reference is not sufficient. (Because there is not necessarily
one to one mapping between request queue and device?)

I seem to just have lots of question about devices and referencing.
Hopefully somebody with more knowledge in this area be able to
shed some light on it.

Thanks
Vivek
