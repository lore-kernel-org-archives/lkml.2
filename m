Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab0F0KCq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 06:02:46 -0400
Received: from sh.osrg.net ([192.16.179.4]:47942 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754838Ab0F0KCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 06:02:42 -0400
Date: Sun, 27 Jun 2010 19:01:33 +0900
To: hch@lst.de
Cc: fujita.tomonori@lab.ntt.co.jp, snitzer@redhat.com, axboe@kernel.dk,
       dm-devel@redhat.com, James.Bottomley@suse.de,
       linux-kernel@vger.kernel.org, martin.petersen@oracle.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH 1/2] block: fix leaks associated with discard request
 payload
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100627092652.GA11625@lst.de>
References: <1277582211-10725-1-git-send-email-snitzer@redhat.com>
	<20100627174721D.fujita.tomonori@lab.ntt.co.jp>
	<20100627092652.GA11625@lst.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100627185927K.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sun, 27 Jun 2010 19:01:35 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Jun 2010 11:26:52 +0200
Christoph Hellwig <hch@lst.de> wrote:

> On Sun, Jun 27, 2010 at 05:49:29PM +0900, FUJITA Tomonori wrote:
> > On Sat, 26 Jun 2010 15:56:50 -0400
> > Mike Snitzer <snitzer@redhat.com> wrote:
> > 
> > > Fix leaks introduced via "block: don't allocate a payload for discard
> > > request" commit a1d949f5f44.
> > > 
> > > sd_done() is not called for REQ_TYPE_BLOCK_PC commands so cleanup
> > > discard request's payload directly in scsi_finish_command().
> > 
> > Instead of adding another discard hack to scsi_finish_command(), how
> > about converting discard to REQ_TYPE_FS request? discard is FS request
> > from the perspective of the block layer. It also fixes a problem that
> > discard isn't retried in the case of UNIT ATTENTION.
> >
> > I think that we can get more cleaner code if we handle discard as
> > normal (fs) request in the block layer (and scsi-ml). We need more
> > changes but this patch is the first step.
> 
> Making discard a REQ_TYPE_FS inside scsi (it already is before entering
> sd_prep_fn) means we'll need to special case it all over the I/O
> submission and completion path.  Having the payload length not matching

Hmm, my patch doesn't add any special case in scsi submission and
completion. sd_prep_fn already has a hack for discard to set
bi->bi_size to rq->__data_size so scsi can tell the block layer to
finish discard requests.

Adding another special case for discard to scsi_io_completion()
doesn't look good.

About the block layer, we already have special case for discard
everywhere (rq->cmd_flags & REQ_DISCARD).


> the transfer length is something we don't expect for FS requests.

Yeah, that's tricky. I'm not sure yet which is better; change how the
block layer handles the transfer length or let the lower layer to add
pages (as we do now).


> > index e16185b..9e15c46 100644
> > --- a/block/blk-lib.c
> > +++ b/block/blk-lib.c
> > @@ -20,6 +20,10 @@ static void blkdev_discard_end_io(struct bio *bio, int err)
> >  	if (bio->bi_private)
> >  		complete(bio->bi_private);
> >  
> > +	/* free the page that the lower layer allocated */
> > +	if (bio_page(bio))
> > +		__free_page(bio_page(bio));
> > +
> 
> This is exactly what this patchkit gets rid off.  Having a payload
> page that the caller tracks (previously fully, with this patch only for
> freeing) makes DM's life a lot harder.  Remember we don't actually store
> any payload in there before entering sd_prep_fn - it's just that the
> scsi commands implementing discards need some payload - either a sector
> sizes zero filled buffer for WRITE SAME, or an LBA/len encoding inside
> the payload for UNMAP.

It's so bad if the block layer frees pages that the lower layer
allocates? I thought it's ok if the block layer doesn't allocate.

It's better if sd_done() frees a page? As my patch does, if we handle
discard as FS in scsi-ml, sd_done() is called.


> > -	rq->cmd_type = REQ_TYPE_BLOCK_PC;
> > +	rq->cmd_type = REQ_TYPE_FS;
> 
> No need to set REQ_TYPE_FS here, it's already set up that way.

Oops, sure.
