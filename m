Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab0F0J1d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 05:27:33 -0400
Received: from verein.lst.de ([213.95.11.210]:53150 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753193Ab0F0J1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 05:27:32 -0400
Date: Sun, 27 Jun 2010 11:26:52 +0200
From: Christoph Hellwig <hch@lst.de>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: snitzer@redhat.com, hch@lst.de, axboe@kernel.dk, dm-devel@redhat.com,
       James.Bottomley@suse.de, linux-kernel@vger.kernel.org,
       martin.petersen@oracle.com, akpm@linux-foundation.org
Subject: Re: [PATCH 1/2] block: fix leaks associated with discard request payload
Message-ID: <20100627092652.GA11625@lst.de>
References: <20100622180029.GA15950@redhat.com> <1277582211-10725-1-git-send-email-snitzer@redhat.com> <20100627174721D.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100627174721D.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 27, 2010 at 05:49:29PM +0900, FUJITA Tomonori wrote:
> On Sat, 26 Jun 2010 15:56:50 -0400
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
> > Fix leaks introduced via "block: don't allocate a payload for discard
> > request" commit a1d949f5f44.
> > 
> > sd_done() is not called for REQ_TYPE_BLOCK_PC commands so cleanup
> > discard request's payload directly in scsi_finish_command().
> 
> Instead of adding another discard hack to scsi_finish_command(), how
> about converting discard to REQ_TYPE_FS request? discard is FS request
> from the perspective of the block layer. It also fixes a problem that
> discard isn't retried in the case of UNIT ATTENTION.
>
> I think that we can get more cleaner code if we handle discard as
> normal (fs) request in the block layer (and scsi-ml). We need more
> changes but this patch is the first step.

Making discard a REQ_TYPE_FS inside scsi (it already is before entering
sd_prep_fn) means we'll need to special case it all over the I/O
submission and completion path.  Having the payload length not matching
the transfer length is something we don't expect for FS requests.

> index e16185b..9e15c46 100644
> --- a/block/blk-lib.c
> +++ b/block/blk-lib.c
> @@ -20,6 +20,10 @@ static void blkdev_discard_end_io(struct bio *bio, int err)
>  	if (bio->bi_private)
>  		complete(bio->bi_private);
>  
> +	/* free the page that the lower layer allocated */
> +	if (bio_page(bio))
> +		__free_page(bio_page(bio));
> +

This is exactly what this patchkit gets rid off.  Having a payload
page that the caller tracks (previously fully, with this patch only for
freeing) makes DM's life a lot harder.  Remember we don't actually store
any payload in there before entering sd_prep_fn - it's just that the
scsi commands implementing discards need some payload - either a sector
sizes zero filled buffer for WRITE SAME, or an LBA/len encoding inside
the payload for UNMAP.


> -	rq->cmd_type = REQ_TYPE_BLOCK_PC;
> +	rq->cmd_type = REQ_TYPE_FS;

No need to set REQ_TYPE_FS here, it's already set up that way.


