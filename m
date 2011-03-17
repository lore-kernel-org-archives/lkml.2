Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab1CQNJe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 09:09:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754189Ab1CQNJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 09:09:31 -0400
Date: Thu, 17 Mar 2011 09:08:46 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Mustafa Mesanovic <mume@linux.vnet.ibm.com>, Neil Brown <neilb@suse.de>,
        akpm@linux-foundation.org, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, heiko.carstens@de.ibm.com,
        cotte@de.ibm.com, ehrhardt@linux.vnet.ibm.com, hare@suse.de
Subject: Re: [RFC][PATCH] dm: improve read performance
Message-ID: <20110317130846.GA8188@redhat.com>
References: <201012271219.56476.mume@linux.vnet.ibm.com>
 <201012271323.13406.mume@linux.vnet.ibm.com>
 <4D74AEF9.7050108@linux.vnet.ibm.com>
 <201103171042.52792.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103171042.52792.knikanth@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17 2011 at  1:12am -0400,
Nikanth Karthikesan <knikanth@suse.de> wrote:

> On Monday, March 07, 2011 03:40:01 pm Mustafa Mesanovic wrote:
> > On 12/27/2010 01:23 PM, Mustafa Mesanovic wrote:
> > > On Mon December 27 2010 12:54:59 Neil Brown wrote:
> > >> On Mon, 27 Dec 2010 12:19:55 +0100 Mustafa Mesanovic
> > >> 
> > >> <mume@linux.vnet.ibm.com>  wrote:
> > >>> From: Mustafa Mesanovic<mume@linux.vnet.ibm.com>
> > >>> 
> > >>> A short explanation in prior: in this case we have "stacked" dm
> > >>> devices. Two multipathed luns combined together to one striped logical
> > >>> volume.
> > >>> 
> > >>> I/O throughput degradation happens at __bio_add_page when bio's get
> > >>> checked upon max_sectors. In this setup max_sectors is always set to 8
> > >>> ->  what is 4KiB.
> > >>> A standalone striped logical volume on luns which are not multipathed
> > >>> do not have the problem: the logical volume will take over the
> > >>> max_sectors from luns below.
> > 
> > [...]
> > 
> > >>> Using the patch improves read I/O up to 3x. In this specific case from
> > >>> 600MiB/s up to 1800MiB/s.
> > >> 
> > >> and using this patch will cause IO to fail sometimes.
> > >> If an IO request which is larger than a page crosses a device boundary
> > >> in the underlying e.g. RAID0, the RAID0 will return an error as such
> > >> things should not happen - they are prevented by merge_bvec_fn.
> > >> 
> > >> If merge_bvec_fn is not being honoured, then you MUST limit requests to
> > >> a single entry iovec of at most one page.
> > >> 
> > >> NeilBrown
> > > 
> > > Thank you for that hint, I will try to write a merge_bvec_fn for
> > > dm-stripe.c which solves the problem, if that is ok?
> > > 
> > > Mustafa Mesanovic
> > 
> > Now here my new suggestion to fix this issue, what is your opinion?
> > I tested this with different setups, and it worked fine and I had
> > very good performance improvements.
> > 
> 
> Some minor style nitpicks.
> 
> > [RFC][PATCH] dm: improve read performance - v2
> > 
> > This patch adds a merge_fn for the dm stripe target. This merge_fn
> > prevents dm_set_device_limits() setting the max_sectors to 4KiB
> > (PAGE_SIZE). (As in a prior patch already mentioned.)
> > Now the read performance improved up to 3x higher compared to before.
> > 
> > What happened before:
> > I/O throughput degradation happened at __bio_add_page() when bio's got
> > checked at the very beginning upon max_sectors. In this setup max_sectors
> > is always set to 8. So bio's entered the dm target with a max of 4KiB.
> > 
> > Now dm-stripe target will have its own merge_fn so max_sectors will not
> > pushed down to 8 (4KiB), and bio's can get bigger than 4KiB.
> > 
> > Signed-off-by: Mustafa Mesanovic<mume@linux.vnet.ibm.com>
> > ---
> > 
> >   dm-stripe.c |   24 ++++++++++++++++++++++++
> >   1 file changed, 24 insertions(+)
> > 
> > Index: linux-2.6/drivers/md/dm-stripe.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/md/dm-stripe.c	2011-02-28 10:23:37.000000000
> > +0100 +++ linux-2.6/drivers/md/dm-stripe.c	2011-02-28 10:24:29.000000000
> > +0100 @@ -396,6 +396,29 @@
> >   	blk_limits_io_opt(limits, chunk_size * sc->stripes);
> >   }
> > 
> > +static int stripe_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
> > +			struct bio_vec *biovec, int max_size)
> > +{
> > +	struct stripe_c *sc = (struct stripe_c *) ti->private;
> > +	sector_t offset, chunk;
> > +	uint32_t stripe;
> > +	struct request_queue *q;
> > +
> > +	offset = bvm->bi_sector - ti->begin;
> > +	chunk = offset>>  sc->chunk_shift;
> > +	stripe = sector_div(chunk, sc->stripes);
> > +
> > +	if (!bdev_get_queue(sc->stripe[stripe].dev->bdev)->merge_bvec_fn)
> > +			return max_size;
> > +
> > +	bvm->bi_bdev = sc->stripe[stripe].dev->bdev;
> > +	q = bdev_get_queue(bvm->bi_bdev);
> 
> Initializing q at the top would simplify the check fro merge_bvec_fn above.
> 
> > +	bvm->bi_sector = sc->stripe[stripe].physical_start +
> > +			(chunk<<  sc->chunk_shift) + (offset&  sc->chunk_mask);
> > +
> 
> Can this be written as
> 
> bvm->bi_sector = sc->stripe[stripe].physical_start +
> 			bvm->bi_sector - ti->begin;
> 
> or even better
> bvm->bi_sector = sc->stripe[stripe].physical_start +
> 			dm_target_offset(ti, bvm->bi_sector);
> 
> >
> > +	return min(max_size, q->merge_bvec_fn(q, bvm, biovec));
> > +}
> > +
> >   static struct target_type stripe_target = {
> >   	.name   = "striped",
> >   	.version = {1, 3, 1},
> > @@ -403,6 +426,7 @@
> >   	.ctr    = stripe_ctr,
> >   	.dtr    = stripe_dtr,
> >   	.map    = stripe_map,
> > +	.merge  = stripe_merge,
> >   	.end_io = stripe_end_io,
> >   	.status = stripe_status,
> >   	.iterate_devices = stripe_iterate_devices,
> > 
> > 
> > 
> 
> 
> Reviewed-by: Nikanth Karthikesan <knikanth@suse.de>

You reviewed an old version, v4 was posted to dm-devel and is
available here: https://patchwork.kernel.org/patch/639801/

It should address all your concerns.
