Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab0LDQDj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 11:03:39 -0500
Received: from mail09.linbit.com ([212.69.161.110]:39762 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261Ab0LDQDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 11:03:37 -0500
Date: Sat, 4 Dec 2010 17:03:35 +0100
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
        Alasdair G Kergon <agk@redhat.com>, jaxboe@fusionio.com
Subject: Re: [PATCH] dm: check max_sectors in dm_merge_bvec  (was: Re: dm:
 max_segments=1 if merge_bvec_fn is not supported)
Message-ID: <20101204160334.GD6034@barkeeper1-xen.linbit>
References: <20100306211012.GA9689@racke>
 <20100308163345.42841480@notabene.brown>
 <Pine.LNX.4.64.1003080321190.25635@hs20-bc2-1.build.redhat.com>
 <20100308131449.GA15156@racke>
 <20101204064308.GA7639@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101204064308.GA7639@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 04, 2010 at 01:43:08AM -0500, Mike Snitzer wrote:
> I'm late to this old thread but I stumbled across it while auditing the
> various dm-devel patchwork patches, e.g.:
> https://patchwork.kernel.org/patch/83666/
> https://patchwork.kernel.org/patch/83932/
> 
> On Mon, Mar 08 2010 at  8:14am -0500,
> Lars Ellenberg <lars.ellenberg@linbit.com> wrote:
> 
> > On Mon, Mar 08, 2010 at 03:35:37AM -0500, Mikulas Patocka wrote:
> > > Hi
> > > 
> > > That patch with limits->max_segments = 1; is wrong. It fixes this bug 
> > > sometimes and sometimes not.
> > > 
> > > The problem is, if someone attempts to create a bio with two vector 
> > > entries, the first maps the last sector contained in some page and the 
> > > second maps the first sector of the next physical page: it has one 
> > > segment, it has size <= PAGE_SIZE, but it still may cross raid stripe and 
> > > the raid driver will reject it.
> > 
> > Now that you put it that way ;)
> > You are right.
> > 
> > My asumption that "single segment" was  
> > equalvalent in practice with "single bvec"
> > does not hold true in that case.
> > 
> > Then, what about adding seg_boundary_mask restrictions as well?
> > 	max_sectors = PAGE_SIZE >> 9;
> > 	max_segments = 1;
> > 	seg_boundary_mask = PAGE_SIZE -1;
> > or some such.
> > 
> > > > > This is not the first time this has been patched, btw.
> > > > > See https://bugzilla.redhat.com/show_bug.cgi?id=440093
> > > > > and the patch by Mikulas:
> > > > > https://bugzilla.redhat.com/attachment.cgi?id=342638&action=diff
> > > 
> > > Look at this patch, it is the proper way how to fix it: create a 
> > > merge_bvec_fn that reject more than one biovec entry.
> > 
> > If adding seg_boundary_mask is still not sufficient,
> > lets merge that patch instead?
> > Why has it been dropped, respectively never been merged?
> > It became obsolete for dm-linear by 7bc3447b,
> > but in general the bug is still there, or am I missing something?
> 
> No it _should_ be fixed in general given DM's dm_merge_bvec() _but_ I
> did uncover what I think is a subtle oversight in its implementation.
> 
> Given dm_set_device_limits() sets q->limits->max_sectors,
> shouldn't dm_merge_bvec() be using queue_max_sectors rather than
> queue_max_hw_sectors?
> 
> blk_queue_max_hw_sectors() establishes that max_hw_sectors is the hard
> limit and max_sectors the soft.  But AFAICT no relation is maintained
> between the two over time (even though max_sectors <= max_hw_sectors
> _should_ be enforced; in practice there is no blk_queue_max_sectors
> setter that uniformly enforces as much).

Just for the record, in case someone finds this in the archives,
and wants to backport or base his own work on this:

 A long time ago, there was no .max_hw_sectors.  Then max_hw_sectors got
 introduced, but without accessor function.

 Before 2.6.31, there was no blk_queue_max_hw_sectors(),
 only blk_queue_max_sectors(), which set both.

 2.6.31 introduced some blk_queue_max_hw_sectors(), which _only_ set
 max_hw_sectors, and enforced a lower limit of BLK_DEF_MAX_SECTORS, so
 using that only, you have not been able to actually set lower limits
 than 512 kB. With 2.6.31 to 2.6.33, inclusive, you still need to use
 blk_queue_max_sectors() to set your limits.

 2.6.34 finally dropped the newly introduced function again,
 but renamed the other, so starting with 2.6.34 you need to use
 blk_queue_max_hw_sectors(), which now basically has the function body
 blk_queue_max_sectors() had up until 2.6.33.

> dm_set_device_limits() will set q->limits->max_sectors to <= PAGE_SIZE
> if an underlying device has a merge_bvec_fn.  Therefore, dm_merge_bvec()
> must use queue_max_sectors() rather than queue_max_hw_sectors() to check
> the appropriate limit.

IMO, you should not do this.
max_sectors is a user tunable, capped by max_hw_sectors.
max_hw_sectors is the driver limit.

Please set max_hw_sectors in dm_set_device_limits instead.

BTW, e.g.  o_direct will adhere to max_hw_limits,
but happily ignore max_sectors, I think.

> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  drivers/md/dm.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 7cb1352..e83dcc8 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1358,12 +1358,11 @@ static int dm_merge_bvec(struct request_queue *q,
>  	/*
>  	 * If the target doesn't support merge method and some of the devices
>  	 * provided their merge_bvec method (we know this by looking at
> -	 * queue_max_hw_sectors), then we can't allow bios with multiple vector
> +	 * queue_max_sectors), then we can't allow bios with multiple vector
>  	 * entries.  So always set max_size to 0, and the code below allows
>  	 * just one page.
>  	 */
> -	else if (queue_max_hw_sectors(q) <= PAGE_SIZE >> 9)
> -
> +	else if (queue_max_sectors(q) <= PAGE_SIZE >> 9)
>  		max_size = 0;
>  
>  out_table:


	Lars
